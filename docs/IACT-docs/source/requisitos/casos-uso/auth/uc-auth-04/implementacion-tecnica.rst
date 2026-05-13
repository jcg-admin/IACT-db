.. _uc-auth-04-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Stack
==========

Mismo que UC_AUTH_01..03 (Django/DRF, MySQL,
bcrypt, React).

11.2 Estructura backend
=======================

::

   apps/auth_app/
   ├── views/
   │   └── change_password_view.py
   ├── serializers/
   │   └── change_password_serializer.py
   ├── services/
   │   ├── auth_service.py            # change_password()
   │   ├── password_policy.py         # PolicyValidator
   │   └── password_history.py        # HistoryChecker
   ├── models/
   │   ├── user.py
   │   └── password_history.py        # PasswordHistory
   └── urls.py

11.3 Serializer
===============

.. code-block:: python

   # apps/auth_app/serializers/change_password_serializer.py
   from rest_framework import serializers

   class ChangePasswordSerializer(serializers.Serializer):
       current_password = serializers.CharField(
           write_only=True, required=True,
           style={'input_type': 'password'})
       new_password = serializers.CharField(
           write_only=True, required=True, min_length=12,
           style={'input_type': 'password'})
       new_password_confirmation = serializers.CharField(
           write_only=True, required=True,
           style={'input_type': 'password'})

       def validate(self, attrs):
           if attrs['new_password'] != \
                   attrs['new_password_confirmation']:
               raise serializers.ValidationError({
                   'new_password_confirmation':
                   'La confirmacion no coincide.'})
           return attrs

11.4 ChangePasswordView
=======================

.. code-block:: python

   # apps/auth_app/views/change_password_view.py
   from rest_framework.views import APIView
   from rest_framework.permissions import IsAuthenticated
   from rest_framework.response import Response
   from rest_framework import status
   from .change_password_serializer import (
       ChangePasswordSerializer)
   from apps.auth_app.services import AuthService

   class ChangePasswordView(APIView):
       permission_classes = [IsAuthenticated]
       throttle_scope = 'change_password'

       def post(self, request):
           ser = ChangePasswordSerializer(data=request.data)
           ser.is_valid(raise_exception=True)

           svc = AuthService()
           try:
               result = svc.change_password(
                   user=request.user,
                   session_id=request.auth['session_id'],
                   current_password=ser.validated_data[
                       'current_password'],
                   new_password=ser.validated_data[
                       'new_password'],
                   ip=self._client_ip(request),
                   user_agent=request.META.get(
                       'HTTP_USER_AGENT', ''))
           except WrongCurrentPassword:
               return Response(
                   {'error': 'WRONG_CURRENT_PASSWORD',
                    'message': 'Contrasena actual incorrecta'},
                   status=status.HTTP_400_BAD_REQUEST)
           except WeakPassword as e:
               return Response(
                   {'error': 'WEAK_PASSWORD',
                    'message': 'La nueva contrasena no cumple '
                               'la politica.',
                    'violations': e.violations},
                   status=status.HTTP_400_BAD_REQUEST)
           except SameAsCurrent:
               return Response(
                   {'error': 'SAME_AS_CURRENT',
                    'message': 'La nueva contrasena debe ser '
                               'distinta de la actual.'},
                   status=status.HTTP_400_BAD_REQUEST)
           except PasswordReused:
               return Response(
                   {'error': 'PASSWORD_REUSED',
                    'message': 'No puedes reutilizar una de '
                               'tus ultimas 5 contrasenas.'},
                   status=status.HTTP_400_BAD_REQUEST)
           except TooManyAttempts:
               return Response(
                   {'error': 'TOO_MANY_ATTEMPTS',
                    'retry_after': 300},
                   status=status.HTTP_429_TOO_MANY_REQUESTS)

           return Response(result, status=status.HTTP_200_OK)

       @staticmethod
       def _client_ip(request):
           xff = request.META.get('HTTP_X_FORWARDED_FOR')
           return xff.split(',')[0].strip() if xff \
               else request.META.get('REMOTE_ADDR')

11.5 PasswordPolicyValidator
============================

.. code-block:: python

   # apps/auth_app/services/password_policy.py
   import re
   from typing import List

   COMMON_PASSWORDS = set(open(
       '/etc/iact/common_passwords.txt').read().split())

   class PasswordPolicyValidator:
       MIN_LENGTH = 12

       def validate(self, password: str, user) -> List[str]:
           violations = []
           if len(password) < self.MIN_LENGTH:
               violations.append('min_length')
           if not re.search(r'[A-Z]', password):
               violations.append('missing_uppercase')
           if not re.search(r'[a-z]', password):
               violations.append('missing_lowercase')
           if not re.search(r'[0-9]', password):
               violations.append('missing_digit')
           if not re.search(r'[!@#$%^&*()\-_=+\[\]\{\}]',
                            password):
               violations.append('missing_symbol')
           if password.lower() in COMMON_PASSWORDS:
               violations.append('common_password')
           if (user.username
                   and user.username.lower() in
                   password.lower()):
               violations.append('contains_username')
           if (user.email
                   and user.email.split('@')[0].lower() in
                   password.lower()):
               violations.append('contains_email_local_part')
           return violations

11.6 AuthService.change_password
================================

.. code-block:: python

   # apps/auth_app/services/auth_service.py
   import bcrypt
   from django.db import transaction
   from django.utils import timezone
   from apps.auth_app.models import (
       User, Session, BlacklistedToken,
       PasswordHistory, AuditEvent)
   from .password_policy import PasswordPolicyValidator
   from django.conf import settings
   import time, random

   class AuthService:
       HISTORY_DEPTH = 5
       BRUTEFORCE_MAX = 5
       BRUTEFORCE_WINDOW_SEC = 300

       def __init__(self, policy=None):
           self.policy = policy or PasswordPolicyValidator()

       def change_password(self, user, session_id,
                           current_password, new_password,
                           ip='', user_agent=''):
           with transaction.atomic():
               u = User.objects.select_for_update().get(
                   id=user.id)

               # PASO 7: validar actual
               if not bcrypt.checkpw(
                       current_password.encode(),
                       u.password_hash.encode()):
                   self._handle_wrong_current(u, ip)
                   time.sleep(0.1 + random.random() * 0.1)
                   raise WrongCurrentPassword

               # PASO 8: politica
               violations = self.policy.validate(
                   new_password, u)
               if violations:
                   raise WeakPassword(violations)

               # PASO 9: igual a actual
               if bcrypt.checkpw(new_password.encode(),
                                 u.password_hash.encode()):
                   raise SameAsCurrent

               # PASO 9: history
               recent = (PasswordHistory.objects
                         .filter(user=u)
                         .order_by('-changed_at')
                         [:self.HISTORY_DEPTH])
               for entry in recent:
                   if bcrypt.checkpw(
                           new_password.encode(),
                           entry.password_hash.encode()):
                       raise PasswordReused

               # PASO 10
               new_hash = bcrypt.hashpw(
                   new_password.encode(),
                   bcrypt.gensalt(rounds=12)).decode()
               prior_first_login = u.first_login
               u.password_hash = new_hash
               u.first_login = False
               u.password_changed_at = timezone.now()
               u.save()

               # PASO 11
               PasswordHistory.objects.create(
                   user=u, password_hash=new_hash,
                   changed_at=timezone.now())
               # purge >N
               extra_ids = (PasswordHistory.objects
                            .filter(user=u)
                            .order_by('-changed_at')
                            .values_list('id', flat=True)
                            [self.HISTORY_DEPTH:])
               PasswordHistory.objects.filter(
                   id__in=list(extra_ids)).delete()

               # PASO 12
               other_count = 0
               if getattr(settings,
                          'CLOSE_OTHER_SESSIONS_ON_PASSWORD_CHANGE',
                          True):
                   others = (Session.objects
                             .filter(user=u, state='ACTIVE')
                             .exclude(session_id=session_id))
                   other_count = others.count()
                   jtis = list(others.values_list(
                       'access_jti', flat=True))
                   others.update(
                       state='CLOSED',
                       close_reason='PASSWORD_CHANGED',
                       closed_at=timezone.now())
                   for jti in jtis:
                       if jti:
                           BlacklistedToken.objects.create(
                               jti=jti,
                               expires_at=timezone.now())

               # PASO 13
               AuditEvent.objects.create(
                   event_type='PASSWORD_CHANGED',
                   actor_user_id=u.id,
                   occurred_at=timezone.now(),
                   payload={
                       'ip': ip,
                       'user_agent': user_agent,
                       'prior_first_login': prior_first_login,
                       'other_sessions_closed_count':
                           other_count,
                       'scope_upgrade': prior_first_login,
                   })

               return {
                   'message': 'Contrasena actualizada',
                   'changed_at': u.password_changed_at
                                  .isoformat(),
                   'next_step': 'landing',
                   'scope_upgraded': prior_first_login,
                   'other_sessions_closed': other_count,
               }

11.7 PasswordHistory model
==========================

.. code-block:: python

   # apps/auth_app/models/password_history.py
   class PasswordHistory(models.Model):
       user = models.ForeignKey('User', on_delete=models.CASCADE)
       password_hash = models.CharField(max_length=60)
       changed_at = models.DateTimeField(default=timezone.now)

       class Meta:
           db_table = 'password_history'
           indexes = [
               models.Index(fields=['user', '-changed_at']),
           ]
           ordering = ['-changed_at']

11.8 URL + throttling
=====================

.. code-block:: python

   urlpatterns = [
       path('change-password/',
            ChangePasswordView.as_view(),
            name='change-password'),
   ]

   # settings.py
   REST_FRAMEWORK = {
       'DEFAULT_THROTTLE_RATES': {
           'change_password': '60/min',
       },
   }

11.9 Frontend hook
==================

.. code-block:: javascript

   // src/features/auth/hooks/useChangePassword.js
   import { useState } from 'react';
   import { authApi } from '../api/authApi';
   import { toast } from '../../../ui/toast';
   import { useNavigate } from 'react-router-dom';

   export function useChangePassword() {
     const navigate = useNavigate();
     const [errors, setErrors] = useState({});

     async function submit({ current, next, confirm }) {
       setErrors({});
       try {
         const r = await authApi.changePassword({
           current_password: current,
           new_password: next,
           new_password_confirmation: confirm,
         });
         toast.success('Contrasena actualizada correctamente');
         if (r.scope_upgraded) navigate('/');
       } catch (err) {
         const e = err.response?.data;
         setErrors({
           code: e?.error,
           message: e?.message,
           violations: e?.violations,
         });
       }
     }

     return { submit, errors };
   }

11.10 Logging filter
====================

.. code-block:: python

   class _PasswordRedactFilter(logging.Filter):
       SENSITIVE = (
           'current_password', 'new_password',
           'new_password_confirmation')

       def filter(self, record):
           msg = record.getMessage()
           if any(k in msg for k in self.SENSITIVE):
               record.msg = '[REDACTED-PASSWORD-FIELD]'
               record.args = ()
           return True

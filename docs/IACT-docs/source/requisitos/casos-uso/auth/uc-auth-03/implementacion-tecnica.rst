.. _uc-auth-03-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Stack
==========

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Backend**
   - Django 4.2+, DRF 3.14+, bcrypt
 * - **BD**
   - MySQL 8.0
 * - **Generacion entropica**
   - ``secrets.SystemRandom``
 * - **Frontend**
   - React 18, Redux Toolkit

11.2 Backend — estructura
=========================

::

   apps/users/
   ├── views/
   │   └── reset_password_view.py    # ResetPasswordView
   ├── permissions.py                # HasResetPasswordFunction
   apps/auth_app/
   ├── services/
   │   ├── password_generator.py     # Strategy
   │   └── auth_service.py           # reset_password()
   ├── models/
   │   ├── user.py                   # User (touched fields)
   │   └── internal_message.py       # InternalMessage

11.3 Permission class
=====================

.. code-block:: python

   # apps/users/permissions.py
   from rest_framework.permissions import BasePermission

   class HasResetPasswordFunction(BasePermission):
       message = 'Sin permisos para resetear contrasenas'

       def has_permission(self, request, view):
           user = request.user
           if not user.is_authenticated:
               return False
           return user.has_function('reset_password')

11.4 ResetPasswordView
======================

.. code-block:: python

   # apps/users/views/reset_password_view.py
   from rest_framework.views import APIView
   from rest_framework.permissions import IsAuthenticated
   from rest_framework.response import Response
   from rest_framework import status
   from django.shortcuts import get_object_or_404
   from django.db import OperationalError
   from apps.users.permissions import HasResetPasswordFunction
   from apps.auth_app.models import User
   from apps.auth_app.services import AuthService

   class ResetPasswordView(APIView):
       permission_classes = [
           IsAuthenticated, HasResetPasswordFunction
       ]
       throttle_scope = 'reset_password'

       def post(self, request, user_id):
           target = get_object_or_404(User, id=user_id)

           if target.id == request.user.id:
               self._audit_self_reset_attempt(request)
               return Response(
                   {'error': 'SELF_RESET_FORBIDDEN',
                    'message': 'No puedes resetear tu propia '
                               'contrasena.'},
                   status=status.HTTP_400_BAD_REQUEST)

           if target.state == 'ELIMINATED':
               return Response(
                   {'error': 'USER_ELIMINATED',
                    'message': 'No se puede resetear un usuario '
                               'eliminado'},
                   status=status.HTTP_400_BAD_REQUEST)

           svc = AuthService()
           try:
               result = svc.reset_password(
                   admin=request.user,
                   target=target,
                   ip=self._client_ip(request),
                   user_agent=request.META.get(
                       'HTTP_USER_AGENT', ''))
           except OperationalError:
               return Response(
                   {'error': 'DB_TIMEOUT', 'message':
                    'Servicio temporalmente no disponible'},
                   status=status.HTTP_503_SERVICE_UNAVAILABLE)
           except MailboxFailure:
               return Response(
                   {'error': 'MAILBOX_FAILED', 'message':
                    'No se pudo notificar al usuario.'},
                   status=status.HTTP_500_INTERNAL_SERVER_ERROR)

           return Response(result, status=status.HTTP_200_OK)

       @staticmethod
       def _client_ip(request):
           xff = request.META.get('HTTP_X_FORWARDED_FOR')
           return xff.split(',')[0].strip() if xff \
               else request.META.get('REMOTE_ADDR')

11.5 PasswordGenerator (Strategy)
=================================

.. code-block:: python

   # apps/auth_app/services/password_generator.py
   import secrets
   import string
   from abc import ABC, abstractmethod

   class PasswordGenerator(ABC):
       @abstractmethod
       def generate(self, length: int = 12) -> str: ...

   class StandardPasswordGenerator(PasswordGenerator):
       UPPER = string.ascii_uppercase
       LOWER = string.ascii_lowercase
       DIGITS = string.digits
       SYMBOLS = '!@#$%^&*()-_=+[]{}'

       def generate(self, length: int = 12) -> str:
           if length < 12:
               raise ValueError('length must be >= 12')
           rng = secrets.SystemRandom()
           required = [
               rng.choice(self.UPPER),
               rng.choice(self.LOWER),
               rng.choice(self.DIGITS),
               rng.choice(self.SYMBOLS),
           ]
           pool = self.UPPER + self.LOWER + self.DIGITS \
                  + self.SYMBOLS
           filler = [rng.choice(pool)
                     for _ in range(length - len(required))]
           result = required + filler
           rng.shuffle(result)
           return ''.join(result)

11.6 AuthService.reset_password
===============================

.. code-block:: python

   # apps/auth_app/services/auth_service.py
   import bcrypt
   from django.db import transaction
   from django.utils import timezone
   from apps.auth_app.models import (
       User, Session, BlacklistedToken,
       InternalMessage, AuditEvent)
   from .password_generator import StandardPasswordGenerator

   class AuthService:
       def __init__(self, generator=None):
           self.generator = generator or \
               StandardPasswordGenerator()

       def reset_password(self, admin, target, ip='',
                          user_agent=''):
           temp_password = self.generator.generate(length=12)
           hashed = bcrypt.hashpw(
               temp_password.encode(),
               bcrypt.gensalt(rounds=12))

           with transaction.atomic():
               # Lock pesimista
               user = User.objects.select_for_update().get(
                   id=target.id)

               user.password_hash = hashed.decode()
               user.first_login = True
               user.password_changed_at = timezone.now()
               user.save()

               sessions = Session.objects.filter(
                   user=user, state='ACTIVE')
               sessions_count = sessions.count()
               jtis = list(sessions.values_list(
                   'access_jti', flat=True))
               sessions.update(
                   state='CLOSED',
                   close_reason='PASSWORD_RESET',
                   closed_at=timezone.now())

               for jti in jtis:
                   if jti:
                       BlacklistedToken.objects.create(
                           jti=jti,
                           expires_at=timezone.now()
                                      + timedelta(hours=1),
                           token_type='ACCESS')

               try:
                   InternalMessage.objects.create(
                       recipient=user,
                       sender=None,
                       subject='Contrasena temporal',
                       body=self._build_message_body(
                           temp_password))
               except Exception as e:
                   raise MailboxFailure(str(e))

               AuditEvent.objects.create(
                   event_type='PASSWORD_RESET',
                   actor_user_id=admin.id,
                   occurred_at=timezone.now(),
                   payload={
                       'target_user_id': user.id,
                       'ip': ip,
                       'user_agent': user_agent,
                       'sessions_closed_count':
                           sessions_count,
                       'prior_first_login':
                           target.first_login,
                   })

           return {
               'message': 'Contrasena reseteada. '
                          'Notificacion enviada al buzon '
                          'del usuario.',
               'target_user_id': user.id,
               'reset_at': timezone.now().isoformat(),
               'sessions_closed': sessions_count,
           }

       @staticmethod
       def _build_message_body(temp_password):
           return (
               'Tu contrasena fue reseteada por un '
               'administrador.\n\n'
               f'Contrasena temporal: {temp_password}\n\n'
               'Debes cambiarla en tu proximo inicio de '
               'sesion.')

11.7 URL routing
================

.. code-block:: python

   # apps/users/urls.py
   from django.urls import path
   from .views import ResetPasswordView

   urlpatterns = [
       path('<int:user_id>/reset-password/',
            ResetPasswordView.as_view(),
            name='reset-password'),
   ]

11.8 Throttling
===============

.. code-block:: python

   # settings.py
   REST_FRAMEWORK = {
       'DEFAULT_THROTTLE_CLASSES': [
           'rest_framework.throttling.ScopedRateThrottle',
       ],
       'DEFAULT_THROTTLE_RATES': {
           'reset_password': '10/5min',  # CNST-011
       },
   }

11.9 Frontend
=============

.. code-block:: javascript

   // src/features/users/hooks/useResetPassword.js
   import { useState } from 'react';
   import { usersApi } from '../api/usersApi';
   import { toast } from '../../../ui/toast';

   export function useResetPassword() {
     const [loading, setLoading] = useState(false);

     const reset = async (userId, userName) => {
       const ok = await openConfirmModal({
         title: 'Resetear contrasena',
         message: `Esto cerrara las sesiones de ${userName} `
                  + `y le enviara una contrasena temporal a `
                  + `su buzon interno. ¿Continuar?`,
         destructive: true,
       });
       if (!ok) return;

       setLoading(true);
       try {
         const resp = await usersApi.resetPassword(userId);
         toast.success(
           'Contrasena reseteada. El usuario recibira '
           + 'la nueva contrasena en su buzon interno.');
       } catch (err) {
         toast.error(err.response?.data?.message
                     || 'Error al resetear');
       } finally {
         setLoading(false);
       }
     };

     return { reset, loading };
   }

11.10 Restriccion de logging
============================

.. code-block:: python

   # apps/auth_app/services/auth_service.py — TOP
   import logging

   class _SensitiveDataFilter(logging.Filter):
       def filter(self, record):
           # Defensa adicional: nunca log de "Contrasena temporal:"
           msg = record.getMessage()
           if 'Contrasena temporal:' in msg:
               record.msg = '[REDACTED]'
               record.args = ()
           return True

   logger = logging.getLogger(__name__)
   logger.addFilter(_SensitiveDataFilter())

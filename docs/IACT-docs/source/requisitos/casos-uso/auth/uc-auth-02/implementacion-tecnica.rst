.. _uc-auth-02-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Stack
==========

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Backend**
   - Django 4.2+, DRF 3.14+, djangorestframework-simplejwt
 * - **BD**
   - MySQL 8.0 (analitica)
 * - **Cache (opcional)**
   - Redis 7 para BlacklistedToken hot path
 * - **Frontend**
   - React 18, Redux Toolkit, React Router v6
 * - **Servidor**
   - Apache + mod_wsgi (ADR-DEVOPS-001)

11.2 Backend — estructura
=========================

::

   apps/auth_app/
   ├── views/
   │   └── logout_view.py            # LogoutView (DRF APIView)
   ├── services/
   │   ├── auth_service.py           # logout()
   │   └── token_invalidator.py      # Strategy pattern
   ├── models/
   │   ├── session.py                # Session
   │   └── blacklisted_token.py      # BlacklistedToken
   ├── serializers/
   │   └── logout_serializer.py
   └── urls.py                       # path('logout/', ...)

11.3 LogoutView (esqueleto)
===========================

.. code-block:: python

   # apps/auth_app/views/logout_view.py
   from rest_framework.views import APIView
   from rest_framework.permissions import IsAuthenticated
   from rest_framework.response import Response
   from rest_framework import status
   from django.db import transaction, OperationalError
   from apps.auth_app.services import AuthService

   class LogoutView(APIView):
       permission_classes = [IsAuthenticated]

       def post(self, request):
           service = AuthService()
           try:
               result = service.logout(
                   user_id=request.user.id,
                   session_id=request.auth['session_id'],
                   access_jti=request.auth['jti'],
                   refresh_token=request.data.get('refresh_token'),
                   ip=self._client_ip(request),
                   user_agent=request.META.get('HTTP_USER_AGENT', ''),
               )
           except SessionNotFound:
               return Response(
                   {'error': 'SESSION_NOT_FOUND',
                    'message': 'Sesion no localizada'},
                   status=status.HTTP_401_UNAUTHORIZED)
           except UserMismatch:
               # alerta de seguridad emitida internamente
               return Response(
                   {'error': 'USER_MISMATCH',
                    'message': 'Sesion no autorizada'},
                   status=status.HTTP_401_UNAUTHORIZED)
           except OperationalError:
               return Response(
                   {'error': 'DB_TIMEOUT',
                    'message': 'Servicio temporalmente no disponible'},
                   status=status.HTTP_503_SERVICE_UNAVAILABLE)

           return Response(result, status=status.HTTP_200_OK)

       @staticmethod
       def _client_ip(request):
           xff = request.META.get('HTTP_X_FORWARDED_FOR')
           return xff.split(',')[0].strip() if xff \
               else request.META.get('REMOTE_ADDR')

11.4 AuthService.logout (esqueleto)
===================================

.. code-block:: python

   # apps/auth_app/services/auth_service.py
   from django.db import transaction
   from django.utils import timezone
   from apps.auth_app.models import (
       Session, BlacklistedToken, AuditEvent)

   class AuthService:
       def __init__(self,
                    invalidator: 'TokenInvalidator' = None):
           self.invalidator = invalidator or DBBlacklistStrategy()

       def logout(self, user_id, session_id, access_jti,
                  refresh_token=None, ip='', user_agent=''):
           session = (Session.objects
                      .select_for_update()
                      .filter(session_id=session_id)
                      .first())

           if session is None:
               raise SessionNotFound

           if session.user_id != user_id:
               self._emit_security_alert(user_id, session)
               raise UserMismatch

           # FA-02: idempotencia
           if session.state == 'CLOSED':
               return self._handle_replay(session, access_jti,
                                          ip, user_agent)

           with transaction.atomic():
               session.state = 'CLOSED'
               session.close_reason = 'USER_LOGOUT'
               session.closed_at = timezone.now()
               session.save()

               self.invalidator.invalidate(
                   jti=access_jti,
                   expires_at=self._token_exp(access_jti),
                   token_type='ACCESS')

               if refresh_token:
                   self.invalidator.invalidate(
                       jti=self._jti(refresh_token),
                       expires_at=self._token_exp(refresh_token),
                       token_type='REFRESH')

               AuditEvent.objects.create(
                   event_type='LOGOUT',
                   actor_user_id=user_id,
                   occurred_at=timezone.now(),
                   payload={
                       'ip': ip,
                       'user_agent': user_agent,
                       'session_id': str(session.session_id),
                       'close_reason': 'USER_LOGOUT',
                       'refresh_token_invalidated':
                           refresh_token is not None,
                   })

           return {
               'message': 'Sesion cerrada',
               'logout_at': session.closed_at.isoformat(),
           }

11.5 TokenInvalidator (Strategy)
================================

.. code-block:: python

   # apps/auth_app/services/token_invalidator.py
   from abc import ABC, abstractmethod

   class TokenInvalidator(ABC):
       @abstractmethod
       def invalidate(self, jti, expires_at, token_type): ...

   class DBBlacklistStrategy(TokenInvalidator):
       def invalidate(self, jti, expires_at, token_type):
           BlacklistedToken.objects.create(
               jti=jti, expires_at=expires_at,
               token_type=token_type)

   class RedisBlacklistStrategy(TokenInvalidator):
       def __init__(self, redis_client):
           self.redis = redis_client

       def invalidate(self, jti, expires_at, token_type):
           ttl = (expires_at - timezone.now()).total_seconds()
           self.redis.setex(f'bl:{jti}', int(ttl), token_type)

11.6 Modelo Session
===================

.. code-block:: python

   # apps/auth_app/models/session.py
   class Session(models.Model):
       STATES = [('ACTIVE', 'ACTIVE'),
                 ('CLOSED', 'CLOSED')]
       CLOSE_REASONS = [
           ('USER_LOGOUT', 'USER_LOGOUT'),
           ('TIMEOUT', 'TIMEOUT'),
           ('SUPERSEDED', 'SUPERSEDED'),
           ('ADMIN_REVOKED', 'ADMIN_REVOKED'),
       ]
       session_id = models.UUIDField(primary_key=True)
       user = models.ForeignKey('User', on_delete=models.PROTECT)
       state = models.CharField(max_length=10, choices=STATES,
                                default='ACTIVE')
       close_reason = models.CharField(max_length=20,
                                       choices=CLOSE_REASONS,
                                       null=True, blank=True)
       created_at = models.DateTimeField(auto_now_add=True)
       expires_at = models.DateTimeField()
       closed_at = models.DateTimeField(null=True, blank=True)
       client_info = models.JSONField(default=dict)

       class Meta:
           db_table = 'sessions'
           indexes = [
               models.Index(fields=['user', 'state']),
           ]

11.7 URL routing
================

.. code-block:: python

   # apps/auth_app/urls.py
   from django.urls import path
   from .views import LoginView, LogoutView

   app_name = 'auth_app'
   urlpatterns = [
       path('login/', LoginView.as_view(), name='login'),
       path('logout/', LogoutView.as_view(), name='logout'),
   ]

11.8 Frontend — estructura
==========================

::

   src/features/auth/
   ├── components/
   │   ├── LogoutButton.jsx
   │   └── LogoutConfirmModal.jsx
   ├── hooks/
   │   └── useLogout.js
   ├── slices/
   │   └── authSlice.js              # Redux Toolkit
   └── api/
       └── authApi.js                # logout() call

11.9 useLogout hook
===================

.. code-block:: javascript

   // src/features/auth/hooks/useLogout.js
   import { useDispatch } from 'react-redux';
   import { useNavigate } from 'react-router-dom';
   import { authApi } from '../api/authApi';
   import { clearAuth } from '../slices/authSlice';

   export function useLogout() {
     const dispatch = useDispatch();
     const navigate = useNavigate();

     return async () => {
       const refreshToken = localStorage.getItem('refresh_token');
       try {
         await authApi.logout({ refresh_token: refreshToken });
       } catch (err) {
         // logout local incluso si el backend falla
       } finally {
         localStorage.removeItem('access_token');
         localStorage.removeItem('refresh_token');
         dispatch(clearAuth());
         navigate('/login', {
           state: { message: 'Tu sesion fue cerrada correctamente' }
         });
       }
     };
   }

11.10 Configuracion DRF
=======================

.. code-block:: python

   # settings.py
   REST_FRAMEWORK = {
       'DEFAULT_AUTHENTICATION_CLASSES': (
           'apps.auth_app.authentication.JWTAuthenticationWithBlacklist',
       ),
       'DEFAULT_THROTTLE_CLASSES': (
           'rest_framework.throttling.AnonRateThrottle',
           'rest_framework.throttling.UserRateThrottle',
       ),
       'DEFAULT_THROTTLE_RATES': {
           'logout': '60/min',  # CNST-011
       },
   }

11.11 Cron de purga de blacklist
================================

.. code-block:: python

   # apps/auth_app/management/commands/purge_blacklist.py
   from django.core.management.base import BaseCommand
   from django.utils import timezone
   from apps.auth_app.models import BlacklistedToken

   class Command(BaseCommand):
       help = 'Purga BlacklistedToken con expires_at < NOW()'

       def handle(self, *args, **kwargs):
           deleted, _ = BlacklistedToken.objects.filter(
               expires_at__lt=timezone.now()).delete()
           self.stdout.write(
               f'Purged {deleted} expired blacklist entries')

Cronjob: cada hora.

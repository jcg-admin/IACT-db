.. _uc-auth-01-parte-11:

==================================
Parte 11 — Implementacion tecnica
==================================

Referencia tecnica para la fase de
implementacion del UC. Stack canonico,
estructura de archivos backend / frontend,
endpoints, modelos. Las cifras concretas (TTL
de tokens, costo de bcrypt, limites de
throttling) viven en los CNST y futuros ADRs
de implementacion, no aqui.

11.1 Stack tecnologico
======================

Per ADR-DEVOPS-001 (stack canonico del
proyecto) y CNST-021 (Ubuntu + Apache +
mod_wsgi):

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Backend framework**
   - Django + Django REST Framework (DRF)
 * - **Lenguaje**
   - Python 3.x
 * - **Web server**
   - Apache 2.4 + mod_wsgi (CNST-021)
 * - **Base de datos**
   - MySQL 8.0 InnoDB
 * - **Autenticacion**
   - DRF SimpleJWT (CNST-009)
 * - **Hashing**
   - bcrypt (libreria nativa de Django o
     ``passlib``)
 * - **Cache**
   - Django DatabaseCache (no Redis ni
     Memcached — explicitamente fuera del
     stack)
 * - **Frontend framework**
   - React 18
 * - **State management**
   - Redux Toolkit
 * - **Build**
   - Webpack
 * - **HTTP client**
   - axios

Stack **prohibido** en este UC (per ADR-DEVOPS-001):

- Docker / Kubernetes — no.
- Nginx — no (Apache + mod_wsgi).
- Gunicorn / uWSGI — no.
- Celery — no (no necesario aqui; la
  notificacion via InternalMailbox es sincrona
  o cron-driven).
- Redis / Memcached — no (DatabaseCache).
- PostgreSQL — no (MySQL).

11.2 Endpoint
=============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Method**
   - POST
 * - **URL**
   - ``/api/auth/login/``
 * - **Authentication**
   - publico (sin token)
 * - **Throttling**
   - ``AnonRateThrottle`` + ``UserRateThrottle``
     (CNST-011)
 * - **View class**
   - ``LoginView(APIView)``

11.3 Estructura de archivos backend
===================================

Ubicacion canonica del codigo (CNST-022
estructura de directorios):

::

   backend/
   └── apps/
       └── auth_app/
           ├── __init__.py
           ├── apps.py                       # AppConfig
           ├── urls.py                       # POST /api/auth/login/
           ├── views.py                      # LoginView, LogoutView, ...
           ├── serializers.py                # LoginSerializer
           ├── services.py                   # AuthService.authenticate()
           ├── strategies.py                 # AuthenticationStrategy +
           │                                 # LocalPasswordStrategy
           ├── throttles.py                  # AnonLoginThrottle, UserLoginThrottle
           ├── exceptions.py                 # InvalidCredentials,
           │                                 # AccountBlocked, etc.
           ├── audit.py                      # @audits decorator + emit functions
           ├── tests/
           │   ├── __init__.py
           │   ├── test_login_view.py        # CA-01..CA-16
           │   ├── test_serializer.py
           │   ├── test_service.py
           │   └── test_strategies.py
           └── README.rst

Archivos en otras apps que UC_AUTH_01 toca:

::

   backend/apps/users/models.py             # class User
   backend/apps/sessions/models.py          # class Session
   backend/apps/audit/models.py             # class AuditEvent
   backend/apps/mailbox/models.py           # class InternalMailbox
   backend/apps/audit/middleware.py         # AuditEmitter middleware

11.4 Modelo Django de Session (extracto)
========================================

.. code-block:: python

   # apps/sessions/models.py
   from django.db import models
   import uuid

   class Session(models.Model):
       SESSION_STATES = [
           ('ACTIVE',  'Active'),
           ('CLOSED',  'Closed'),
           ('EXPIRED', 'Expired'),
       ]

       CLOSE_REASONS = [
           ('USER_LOGOUT',  'User logout'),
           ('SUPERSEDED',   'Superseded by new login'),
           ('ADMIN_CLOSE',  'Admin closed'),
           ('EXPIRED',      'Expired by timeout'),
       ]

       session_id        = models.UUIDField(primary_key=True,
                                            default=uuid.uuid4)
       user              = models.ForeignKey('users.User',
                                            on_delete=models.PROTECT)
       state             = models.CharField(max_length=10,
                                            choices=SESSION_STATES,
                                            default='ACTIVE')
       started_at        = models.DateTimeField(auto_now_add=True)
       last_activity_at  = models.DateTimeField(auto_now=True)
       expires_at        = models.DateTimeField()
       client_info       = models.JSONField(null=True, blank=True)
       closed_at         = models.DateTimeField(null=True, blank=True)
       close_reason      = models.CharField(max_length=20,
                                            choices=CLOSE_REASONS,
                                            null=True, blank=True)

       class Meta:
           indexes = [
               models.Index(fields=['user', 'state']),
               models.Index(fields=['expires_at']),
           ]

11.5 LoginView (esqueleto)
==========================

.. code-block:: python

   # apps/auth_app/views.py
   from rest_framework.views import APIView
   from rest_framework.response import Response
   from rest_framework import status
   from django.db import transaction
   from .serializers import LoginSerializer
   from .services import AuthService
   from .throttles import AnonLoginThrottle, UserLoginThrottle
   from .exceptions import (InvalidCredentials, AccountBlocked,
                            AccountInactive)

   class LoginView(APIView):
       authentication_classes = []   # publico
       permission_classes = []
       throttle_classes = [AnonLoginThrottle, UserLoginThrottle]

       def post(self, request):
           serializer = LoginSerializer(data=request.data)
           serializer.is_valid(raise_exception=True)

           service = AuthService()

           try:
               result = service.authenticate(
                   username      = serializer.validated_data['username'],
                   password      = serializer.validated_data['password'],
                   client_info   = serializer.validated_data.get('client_info'),
                   ip            = self._client_ip(request),
                   user_agent    = request.META.get('HTTP_USER_AGENT', ''),
               )
           except InvalidCredentials:
               return Response(
                   {'error': {'code': 'INVALID_CREDENTIALS',
                              'message': 'Credenciales invalidas'}},
                   status=status.HTTP_401_UNAUTHORIZED)
           except AccountBlocked:
               return Response(
                   {'error': {'code': 'ACCOUNT_BLOCKED',
                              'message': 'Cuenta bloqueada'}},
                   status=status.HTTP_403_FORBIDDEN)
           except AccountInactive:
               return Response(
                   {'error': {'code': 'ACCOUNT_INACTIVE',
                              'message': 'Cuenta inactiva'}},
                   status=status.HTTP_403_FORBIDDEN)

           return Response(result, status=status.HTTP_200_OK)

       @staticmethod
       def _client_ip(request):
           xff = request.META.get('HTTP_X_FORWARDED_FOR')
           return (xff.split(',')[0].strip() if xff
                   else request.META.get('REMOTE_ADDR', ''))

11.6 AuthService (esqueleto)
============================

.. code-block:: python

   # apps/auth_app/services.py
   from django.db import transaction
   from django.utils import timezone
   from datetime import timedelta
   from .strategies import LocalPasswordStrategy
   from .exceptions import (InvalidCredentials, AccountBlocked,
                            AccountInactive)
   from apps.users.models import User
   from apps.sessions.models import Session
   from apps.audit.models import AuditEvent
   from apps.mailbox.services import deliver_message

   SESSION_TTL_MINUTES = 15   # CNST-005

   class AuthService:
       def __init__(self, strategy=None):
           self.strategy = strategy or LocalPasswordStrategy()

       def authenticate(self, *, username, password,
                        client_info, ip, user_agent):
           # Paso 7: localizar User
           try:
               user = User.objects.get(username=username)
           except User.DoesNotExist:
               self._audit_failed(None, ip, user_agent,
                                  'USER_NOT_FOUND')
               raise InvalidCredentials()

           # Paso 8: validar state
           if user.state == 'BLOCKED':
               self._audit_event(user, ip, user_agent,
                                 'LOGIN_BLOCKED')
               raise AccountBlocked()
           if user.state == 'INACTIVE':
               self._audit_event(user, ip, user_agent,
                                 'LOGIN_INACTIVE')
               raise AccountInactive()

           # Paso 9: verificar password
           if not self.strategy.verify(user, password):
               self._audit_failed(user, ip, user_agent,
                                  'BAD_PASSWORD')
               raise InvalidCredentials()

           # Pasos 10-14: transaccion atomica
           with transaction.atomic():
               # Paso 10: cerrar Sessions previas (CNST-004)
               previous = Session.objects.select_for_update().filter(
                   user=user, state='ACTIVE')
               for prev in previous:
                   prev.state = 'CLOSED'
                   prev.closed_at = timezone.now()
                   prev.close_reason = 'SUPERSEDED'
                   prev.save()
                   self._audit_event(user, ip, user_agent,
                                     'SESSION_CLOSED',
                                     {'session_id': str(prev.session_id),
                                      'cause': 'SUPERSEDED'})
                   if prev.client_info != client_info:
                       deliver_message(
                           user, body='Tu sesion en otro dispositivo se cerro.')

               # Paso 11: crear Session
               new_session = Session.objects.create(
                   user=user,
                   state='ACTIVE',
                   expires_at=timezone.now() + timedelta(
                       minutes=SESSION_TTL_MINUTES),
                   client_info=client_info,
               )

               # Paso 13: AuditEvent LOGIN
               self._audit_event(user, ip, user_agent,
                                 'LOGIN',
                                 {'session_id': str(new_session.session_id)})

               # Paso 14: actualizar User.last_login_at
               user.last_login_at = timezone.now()
               user.save(update_fields=['last_login_at'])

           # Paso 12: generar tokens (fuera de la transaccion)
           tokens = self._issue_jwt(user, new_session)
           return self._build_response(user, new_session, tokens)

       # ... metodos _audit_event, _audit_failed,
       # _issue_jwt, _build_response

11.7 Frontend (React)
=====================

Estructura de archivos:

::

   frontend/src/
   └── features/
       └── auth/
           ├── LoginPage.jsx                # pagina /login
           ├── LoginForm.jsx                # componente formulario
           ├── authSlice.js                 # Redux slice
           ├── authApi.js                   # axios calls
           ├── selectors.js
           └── tests/
               ├── LoginPage.test.jsx
               └── LoginForm.test.jsx

LoginForm responsabilidades:

- Renderizar dos campos (username, password)
  con validacion cliente-side basica.
- Submit via ``authApi.login()``.
- Manejar respuestas 200 / 4xx / 5xx con
  feedback visible al usuario.
- Redirigir tras exito segun ``next_step``:

  - ``null`` → ``/`` (landing por AccessGroup)
  - ``"change_password"`` → ``/change-password``

11.8 Toctree de la spec
=======================

Este archivo es la **Parte 11** del spec de
12 partes de UC_AUTH_01:

- :doc:`index`
- :doc:`informacion-general`
- :doc:`actores-precondiciones`
- :doc:`flujo-principal`
- :doc:`flujos-alternos`
- :doc:`excepciones`
- :doc:`requisitos-no-funcionales`
- :doc:`datos-involucrados`
- :doc:`diagramas-uml`
- :doc:`criterios-aceptacion`
- :doc:`patrones-diseno`
- :doc:`testing`

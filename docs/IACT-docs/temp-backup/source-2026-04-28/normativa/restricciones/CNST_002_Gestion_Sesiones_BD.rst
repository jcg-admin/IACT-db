CNST-002: Gestión de Sesiones en Base de Datos
==============================================

:ID: CNST-002
:Versión: 1.0.1
:Fecha: 2026-01-03
:Estado: VIGENTE
:Clasificación: CRÍTICO - NO NEGOCIABLE
:Origen: Restricción del cliente

----

Propósito
---------

Este documento establece la prohibición de uso de Redis o sistemas de caché en memoria para gestión de sesiones en el Sistema IACT - IVR Analytics & Customer Tracking, y define el mecanismo obligatorio de sesiones en base de datos MySQL con política de sesión única por usuario.

Contexto
--------

Origen de la Restricción
~~~~~~~~~~~~~~~~~~~~~~~~

Restricción de infraestructura impuesta por el cliente. El cliente NO provee ni permite la instalación de servicios Redis, Memcached u otros sistemas de caché en memoria en su infraestructura.

Justificación del Cliente
~~~~~~~~~~~~~~~~~~~~~~~~~

- Simplificación de infraestructura (menos servicios que mantener)
- Reducción de puntos de fallo
- Auditoría de sesiones en base de datos relacional
- Control centralizado de sesiones activas
- Política de seguridad: una sesión por usuario

Aplicable a
~~~~~~~~~~~

- Sistema IACT completo
- Autenticación y autorización
- Gestión de sesiones de usuario
- Tokens de acceso y refresh
- Todas las fases del ciclo de vida (desarrollo, QA, producción)

Restricciones
-------------

Prohibiciones Absolutas
~~~~~~~~~~~~~~~~~~~~~~~

Servicios de Caché Prohibidos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

PROHIBIDO bajo cualquier circunstancia:

- Redis
- Memcached
- AWS ElastiCache
- Azure Cache for Redis
- Cualquier servicio de caché en memoria externa

Librerías Prohibidas
^^^^^^^^^^^^^^^^^^^^

Librerías de caché en código Python:

- ``redis`` / ``redis-py``
- ``django-redis``
- ``pymemcache``
- ``python-memcached``
- ``django-cache-machine``

Configuraciones Prohibidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

NO se permite en settings:

.. code-block:: python

   # PROHIBIDO - No usar Redis
   CACHES = {
       'default': {
           'BACKEND': 'django_redis.cache.RedisCache',
           'LOCATION': 'redis://127.0.0.1:6379/1',
       }
   }

   # PROHIBIDO - No usar Memcached
   CACHES = {
       'default': {
           'BACKEND': 'django.core.cache.backends.memcached.PyMemcacheCache',
           'LOCATION': '127.0.0.1:11211',
       }
   }

   # PROHIBIDO - No usar sesiones en Redis
   SESSION_ENGINE = 'django.contrib.sessions.backends.cache'

Consecuencias de Violación
~~~~~~~~~~~~~~~~~~~~~~~~~~

Consecuencias de violación de esta restricción:

- Rechazo inmediato en code review
- Rollback de deployment si se detecta en producción
- Aplicación NO arrancará en servidores del cliente
- Incidente de infraestructura categoría Alta

Mecanismo Obligatorio
~~~~~~~~~~~~~~~~~~~~~

OBLIGATORIO: Sesiones en Base de Datos MySQL

- Backend: ``django.contrib.sessions.backends.db``
- Modelo: ``Session`` (tabla ``django_session``)
- Base de datos: Analytics (MySQL)
- Política: Una sesión activa por usuario (single session)

Características:

- Sesiones persistentes en MySQL
- Expiración configurable (8 horas por defecto)
- Invalidación de sesiones previas al login
- Auditoría de sesiones activas
- Sin dependencias externas

Implementación
--------------

Configuración de Sesiones
~~~~~~~~~~~~~~~~~~~~~~~~~

Configuración Obligatoria
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # api/config/settings/base.py

   # Backend de sesiones: Base de Datos (OBLIGATORIO)
   SESSION_ENGINE = 'django.contrib.sessions.backends.db'

   # Nombre de cookie de sesión
   SESSION_COOKIE_NAME = 'iact_session'

   # Edad de sesión: 8 horas (28800 segundos)
   SESSION_COOKIE_AGE = 28800

   # Expirar sesión al cerrar navegador
   SESSION_EXPIRE_AT_BROWSER_CLOSE = False

   # Guardar sesión en cada request (recomendado para DB)
   SESSION_SAVE_EVERY_REQUEST = True

   # Cookie segura (HTTPS only en producción)
   SESSION_COOKIE_SECURE = True  # En producción
   SESSION_COOKIE_HTTPONLY = True
   SESSION_COOKIE_SAMESITE = 'Lax'

Tabla de Sesiones
^^^^^^^^^^^^^^^^^

Django crea automáticamente la tabla:

.. code-block:: sql

   -- Tabla django_session (creada por migrate)
   CREATE TABLE django_session (
       session_key VARCHAR(40) NOT NULL PRIMARY KEY,
       session_data LONGTEXT NOT NULL,
       expire_date DATETIME(6) NOT NULL,
       INDEX django_session_expire_date_idx (expire_date)
   ) ENGINE=InnoDB;

Política de Sesión Única
~~~~~~~~~~~~~~~~~~~~~~~~

Implementación de Single Session
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/users/signals.py

   from django.contrib.auth.signals import user_logged_in
   from django.contrib.sessions.models import Session
   from django.dispatch import receiver


   @receiver(user_logged_in)
   def invalidate_previous_sessions(sender, request, user, **kwargs):
                                                                     
       Invalidar todas las sesiones previas del usuario al hacer login.

       CNST-002: Política de sesión única por usuario.
       Solo permite una sesión activa por usuario a la vez.
                                                           
       # Obtener sesión actual
       current_session_key = request.session.session_key

       # Eliminar todas las demás sesiones del usuario
       Session.objects.filter(
           expire_date__gte=timezone.now()
       ).exclude(
           session_key=current_session_key
       ).delete()

       # Nota: No podemos filtrar directamente por user_id en Session
       # porque Session.session_data está serializado.
       # Alternativa: Usar tabla custom UserSession (ver abajo)

Tabla Custom UserSession
^^^^^^^^^^^^^^^^^^^^^^^^

Para mejor control y auditoría:

.. code-block:: python

   # api/apps/users/models.py

   from django.db import models
   from django.contrib.auth import get_user_model
   from django.utils import timezone

   User = get_user_model()


   class UserSession(models.Model):
                                   
       Seguimiento de sesiones activas por usuario.

       CNST-002: Permite implementar política de sesión única
       y auditoría de sesiones.
                               

       user = models.ForeignKey(
           User,
           on_delete=models.CASCADE,
           related_name='sessions'
       )
       session_key = models.CharField(max_length=40, unique=True)
       ip_address = models.GenericIPAddressField()
       user_agent = models.TextField(blank=True)
       created_at = models.DateTimeField(auto_now_add=True)
       last_activity = models.DateTimeField(auto_now=True)
       is_active = models.BooleanField(default=True)

       class Meta:
           db_table = 'user_sessions'
           ordering = ['-last_activity']
           indexes = [
               models.Index(fields=['user', 'is_active']),
               models.Index(fields=['session_key']),
           ]

       def __str__(self):
           return f"{self.user.username} - {self.session_key[:8]}"

       @classmethod
       def create_session(cls, user, session_key, request):
                                                           
           Crear nueva sesión y eliminar sesiones previas (single session).

           Args:
               user: Usuario
               session_key: Session key de Django
               request: Request actual
                                      
           # Desactivar sesiones previas del usuario
           cls.objects.filter(user=user, is_active=True).update(is_active=False)

           # Crear nueva sesión
           return cls.objects.create(
               user=user,
               session_key=session_key,
               ip_address=cls._get_client_ip(request),
               user_agent=request.META.get('HTTP_USER_AGENT', '')[:500]
           )

       @staticmethod
       def _get_client_ip(request):
           """Obtener IP real del cliente."""
           x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
           if x_forwarded_for:
               return x_forwarded_for.split(',')[0].strip()
           return request.META.get('REMOTE_ADDR')

Signal Mejorado con UserSession
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/users/signals.py

   from django.contrib.auth.signals import user_logged_in, user_logged_out
   from django.dispatch import receiver
   from apps.users.models import UserSession


   @receiver(user_logged_in)
   def create_user_session(sender, request, user, **kwargs):
                                                            
       Crear UserSession al login e invalidar sesiones previas.

       CNST-002: Sesión única por usuario.
                                          
       session_key = request.session.session_key
       UserSession.create_session(user, session_key, request)


   @receiver(user_logged_out)
   def deactivate_user_session(sender, request, user, **kwargs):
       """Desactivar UserSession al logout."""
       if hasattr(request, 'session') and request.session.session_key:
           UserSession.objects.filter(
               session_key=request.session.session_key
           ).update(is_active=False)

Casos de Uso Afectados
----------------------

UC-001: Iniciar Sesión
~~~~~~~~~~~~~~~~~~~~~~

Flujo CORRECTO (Obligatorio)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Usuario ingresa credenciales
2. Sistema valida credenciales
3. **Sistema invalida sesiones previas del usuario** (single session)
4. Sistema crea nueva sesión en DB MySQL
5. Sistema crea UserSession para auditoría
6. Sistema retorna cookie de sesión
7. Usuario accede al sistema

Código de Autenticación
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/users/views.py

   from django.contrib.auth import authenticate, login
   from rest_framework.decorators import api_view
   from rest_framework.response import Response


   @api_view(['POST'])
   def login_view(request):
                           
       Login de usuario con sesión en BD.

       CNST-002: Sesión almacenada en MySQL.
       UC-001: Iniciar Sesión.
                              
       username = request.data.get('username')
       password = request.data.get('password')

       user = authenticate(request, username=username, password=password)

       if user:
           # Django automáticamente invalida sesiones previas
           # gracias al signal create_user_session
           login(request, user)

           return Response({
               'success': True,
               'user': {
                   'id': user.id,
                   'username': user.username,
                   'email': user.email
               }
           })

       return Response({
           'success': False,
           'error': 'Credenciales inválidas'
       }, status=401)

UC-002: Cerrar Sesión
~~~~~~~~~~~~~~~~~~~~~

Flujo CORRECTO
^^^^^^^^^^^^^^

1. Usuario solicita logout
2. Sistema marca UserSession como inactiva
3. Sistema elimina sesión de tabla django_session
4. Sistema invalida cookie
5. Usuario es redirigido a login

Código de Logout
^^^^^^^^^^^^^^^^

.. code-block:: python

   from django.contrib.auth import logout

   @api_view(['POST'])
   def logout_view(request):
                            
       Logout de usuario.

       CNST-002: Elimina sesión de BD.
       UC-002: Cerrar Sesión.
                             
       # Signal deactivate_user_session se ejecuta automáticamente
       logout(request)

       return Response({
           'success': True,
           'message': 'Sesión cerrada'
       })

UC-029: Consultar Sesiones Activas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Flujo CORRECTO
^^^^^^^^^^^^^^

1. Administrador accede a panel de sesiones
2. Sistema consulta UserSession activas
3. Sistema muestra: usuario, IP, navegador, última actividad
4. Administrador puede forzar logout de sesión específica

Código de Consulta
^^^^^^^^^^^^^^^^^^

.. code-block:: python

   from apps.users.models import UserSession
   from rest_framework.permissions import IsAdminUser


   class ActiveSessionsView(APIView):
                                     
       Consultar sesiones activas del sistema.

       CNST-002: Auditoría de sesiones en BD.
       UC-029: Consultar Sesiones Activas.
                                          

       permission_classes = [IsAdminUser]

       def get(self, request):
           """Listar sesiones activas."""
           sessions = UserSession.objects.filter(
               is_active=True
           ).select_related('user')

           data = [{
               'id': session.id,
               'user': session.user.username,
               'ip': session.ip_address,
               'user_agent': session.user_agent[:100],
               'created': session.created_at,
               'last_activity': session.last_activity
           } for session in sessions]

           return Response({
               'count': len(data),
               'sessions': data
           })

       def delete(self, request, session_id):
           """Forzar logout de sesión específica (administra_sistema)."""
           session = UserSession.objects.get(id=session_id)
           session.is_active = False
           session.save()

           # Eliminar sesión de Django
           from django.contrib.sessions.models import Session
           Session.objects.filter(session_key=session.session_key).delete()

           return Response({'success': True})

Limpieza de Sesiones Expiradas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Django Command
^^^^^^^^^^^^^^

Django incluye comando para limpiar sesiones expiradas:

.. code-block:: bash

   # Ejecutar periódicamente (cron job diario)
   python manage.py clearsessions

Cron Job Recomendado
^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   # /etc/cron.d/iact-clearsessions

   # Limpiar sesiones expiradas diariamente a las 3 AM
   0 3 * * * iact_user cd /var/www/iact/api && /var/www/iact/venv/bin/python manage.py clearsessions

Validación
----------

Pre-deployment Checklist
~~~~~~~~~~~~~~~~~~~~~~~~

Antes de deployment, verificar:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - ``SESSION_ENGINE = 'django.contrib.sessions.backends.db'``
   * - [ ]
     - NO existe configuración de Redis en settings
   * - [ ]
     - NO existe import de ``redis`` o ``django-redis``
   * - [ ]
     - Tabla ``django_session`` existe en BD
   * - [ ]
     - Tabla ``user_sessions`` existe en BD
   * - [ ]
     - Cron job ``clearsessions`` configurado

Code Review Checklist
~~~~~~~~~~~~~~~~~~~~~

Durante code review, rechazar si:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - Se usa Redis para sesiones
   * - [ ]
     - Se usa Memcached
   * - [ ]
     - Se configura caché en memoria
   * - - [ ]
     - SESSION_ENGINE no es 'db'

Validación Automatizada
~~~~~~~~~~~~~~~~~~~~~~~

Script de Validación
^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   #!/bin/bash
   # scripts/validate_cnst_002.sh

   echo "Validando configuración de sesiones..."

   ERRORS=0

   # Verificar SESSION_ENGINE
   if ! grep -q "SESSION_ENGINE = 'django.contrib.sessions.backends.db'" api/config/settings/base.py; then
       echo "ERROR: SESSION_ENGINE no está configurado para BD"
       ERRORS=$((ERRORS + 1))
   fi

   # Buscar imports prohibidos
   if grep -r "import redis\|from redis" api/; then
       echo "ERROR: Encontrado import de redis"
       ERRORS=$((ERRORS + 1))
   fi

   if grep -r "django_redis\|django-redis" api/; then
       echo "ERROR: Encontrada referencia a django-redis"
       ERRORS=$((ERRORS + 1))
   fi

   # Verificar que no exista configuración de Redis
   if grep -r "RedisCache\|LOCATION.*redis://" api/config/settings/; then
       echo "ERROR: Configuración de Redis encontrada"
       ERRORS=$((ERRORS + 1))
   fi

   if [ $ERRORS -eq 0 ]; then
       echo "OK: Configuración de sesiones válida"
       exit 0
   else
       echo "FALLO: $ERRORS violaciones de CNST-002 encontradas"
       exit 1
   fi

Excepciones
-----------

**NO EXISTEN EXCEPCIONES**

Esta restricción NO tiene excepciones.

La infraestructura del cliente NO provee servicios Redis o Memcached, por lo que técnicamente es imposible violar esta restricción en producción.

Sin embargo, NO se permite su uso ni siquiera en desarrollo local para evitar crear dependencias que no podrán desplegarse.

Alternativas Evaluadas y Rechazadas
-----------------------------------

Alternativa 1: Sesiones en Cookies (Signed Cookies)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Propuesta:** Almacenar datos de sesión en cookies firmadas del cliente.

**Rechazada porque:**

- No permite auditoría centralizada de sesiones
- No permite forzar logout remoto
- Límite de tamaño de cookies (4KB)
- No cumple con requerimiento de single session

Alternativa 2: Instalar Redis en Infraestructura del Cliente
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Propuesta:** Solicitar al cliente instalar Redis.

**Rechazada porque:**

- Cliente explícitamente rechazó esta opción
- Política de simplificación de infraestructura
- No se permite instalar servicios adicionales

Alternativa 3: Redis en Servidor Externo (SaaS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Propuesta:** Usar Redis Cloud u otro servicio SaaS externo.

**Rechazada porque:**

- Políticas de seguridad no permiten datos en servicios externos
- Latencia de red inaceptable
- Costo adicional no justificado

Monitoreo
---------

Métricas a Monitorear
~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 40 60
   :header-rows: 1

   * - Métrica
     - Query
   * - Sesiones activas totales
     - ``SELECT COUNT(*) FROM user_sessions WHERE is_active=1``
   * - Sesiones expiradas sin limpiar
     - ``SELECT COUNT(*) FROM django_session WHERE expire_date < NOW()``
   * - Usuarios con múltiples sesiones
     - ``SELECT user_id, COUNT(*) FROM user_sessions WHERE is_active=1 GROUP BY user_id HAVING COUNT(*) > 1``
   * - Sesiones por hora (últimas 24h)
     - ``SELECT DATE_FORMAT(created_at, '%Y-%m-%d %H:00'), COUNT(*) FROM user_sessions WHERE created_at >= NOW() - INTERVAL 24 HOUR GROUP BY 1``

Alertas Recomendadas
~~~~~~~~~~~~~~~~~~~~

- Más de 100 sesiones expiradas sin limpiar
- Usuario con múltiples sesiones activas (violación de single session)
- Más de 1000 sesiones activas simultáneas
- Tabla django_session con más de 50MB de datos

Referencias
-----------

Documentos Relacionados
~~~~~~~~~~~~~~~~~~~~~~~

- RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md
- UC-001: Iniciar Sesión
- UC-002: Cerrar Sesión
- UC-029: Consultar Sesiones Activas

Documentación Django
~~~~~~~~~~~~~~~~~~~~

- Django Sessions: https://docs.djangoproject.com/en/stable/topics/http/sessions/
- Database-backed sessions: https://docs.djangoproject.com/en/stable/ref/settings/#session-engine
- clearsessions command: https://docs.djangoproject.com/en/stable/ref/django-admin/#clearsessions

Implementación de Referencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- ``api/config/settings/base.py`` - Configuración de sesiones
- ``api/apps/users/models.py`` - Modelo UserSession
- ``api/apps/users/signals.py`` - Signals de sesión única

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 50 20

   * - Versión
     - Fecha
     - Cambios
     - Autor
   * - 1.0.0
     - 2025-12-17
     - Versión inicial completa con Clean Code
     - Equipo IACT
   * - 1.0.1
     - 2026-01-03
     - Actualización de metadatos. Sin cambios funcionales
     - Equipo IACT

Aprobaciones
------------

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Rol
     - Nombre
     - Firma / Fecha
   * - Cliente (Infraestructura)
     - [Nombre]
     - [Pendiente]
   * - Tech Lead
     - [Nombre]
     - [Pendiente]
   * - DevOps Lead
     - [Nombre]
     - [Pendiente]

----

**Fin del Documento CNST-002**
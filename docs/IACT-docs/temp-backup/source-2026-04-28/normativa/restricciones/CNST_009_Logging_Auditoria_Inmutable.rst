CNST-009: Logging y Auditoría Inmutable
=======================================

:ID: CNST-009
:Versión: 1.0.1
:Fecha: 2026-01-03
:Estado: VIGENTE
:Clasificación: CRÍTICO - NO NEGOCIABLE
:Origen: Requerimientos de seguridad y auditoría

----

Propósito
---------

Este documento establece los estándares obligatorios de logging y auditoría para el Sistema IACT - IVR Analytics & Customer Tracking, garantizando trazabilidad completa e inmutabilidad de registros.

Contexto
--------

Origen de la Restricción
~~~~~~~~~~~~~~~~~~~~~~~~

Requerimientos de seguridad y auditoría del cliente. Todo acceso y modificación de datos debe ser registrado de forma inmutable para cumplir con políticas de seguridad corporativas.

Justificación
~~~~~~~~~~~~~

- Trazabilidad completa de acciones de usuario
- Detección de accesos no autorizados
- Evidencia para investigaciones de seguridad
- Cumplimiento de políticas corporativas
- Análisis de uso del sistema

Aplicable a
~~~~~~~~~~~

- Todas las acciones de usuario
- Accesos a APIs
- Modificaciones de datos
- Eventos del sistema (ETL, errores)
- Todas las fases del ciclo de vida

Tipos de Logs
-------------

Clasificación
~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 20 30 50

   * - Tipo
     - Almacenamiento
     - Contenido
   * - Auditoría
     - Base de datos (inmutable)
     - Acciones de usuario
   * - Acceso API
     - Base de datos
     - Requests a endpoints
   * - Aplicación
     - Archivo rotativo
     - Eventos, errores, debug
   * - ETL
     - Archivo + BD
     - Ejecuciones ETL
   * - Seguridad
     - Archivo + BD
     - Intentos de acceso, alertas

Modelo de Auditoría
-------------------

UserActionLog
~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/models.py

   from django.db import models
   from django.contrib.auth import get_user_model

   User = get_user_model()

   class UserActionLog(models.Model):
                                     
       Log inmutable de acciones de usuario.

       CNST-009: Este modelo es APPEND-ONLY.
       NO se permite UPDATE ni DELETE.

       Registra todas las acciones significativas:
       - Login/Logout
       - Visualización de datos
       - Generación de reportes
       - Exportaciones
       - Cambios de configuración
                                 

       ACTION_CHOICES = [
           # Autenticación
           ('LOGIN', 'Inicio de sesión'),
           ('LOGOUT', 'Cierre de sesión'),
           ('LOGIN_FAILED', 'Intento de login fallido'),
           ('PASSWORD_CHANGE', 'Cambio de contraseña'),

           # Datos
           ('VIEW', 'Visualización'),
           ('EXPORT', 'Exportación'),
           ('REPORT_GENERATE', 'Generación de reporte'),

           # Administración
           ('USER_CREATE', 'Creación de usuario'),
           ('USER_UPDATE', 'Modificación de usuario'),
           ('USER_DEACTIVATE', 'Desactivación de usuario'),
           ('ROLE_ASSIGN', 'Asignación de rol'),
           ('ROLE_REVOKE', 'Revocación de rol'),

           # Sistema
           ('ETL_START', 'Inicio de ETL'),
           ('ETL_COMPLETE', 'ETL completado'),
           ('ETL_FAILED', 'ETL fallido'),
           ('CONFIG_CHANGE', 'Cambio de configuración'),
       ]

       RESULT_CHOICES = [
           ('SUCCESS', 'Exitoso'),
           ('FAILED', 'Fallido'),
           ('DENIED', 'Denegado'),
       ]

       # Campos principales
       user = models.ForeignKey(
           User,
           on_delete=models.SET_NULL,
           null=True,
           blank=True,
           related_name='action_logs'
       )
       action = models.CharField(max_length=50, choices=ACTION_CHOICES)
       resource = models.CharField(max_length=200)
       result = models.CharField(
           max_length=20,
           choices=RESULT_CHOICES,
           default='SUCCESS'
       )

       # Contexto
       ip_address = models.GenericIPAddressField(null=True, blank=True)
       user_agent = models.CharField(max_length=500, null=True, blank=True)
       details = models.JSONField(default=dict, blank=True)

       # Timestamp inmutable
       created_at = models.DateTimeField(auto_now_add=True, db_index=True)

       class Meta:
           db_table = 'user_action_logs'
           ordering = ['-created_at']
           indexes = [
               models.Index(fields=['user', 'created_at']),
               models.Index(fields=['action', 'created_at']),
               models.Index(fields=['resource', 'created_at']),
               models.Index(fields=['result', 'created_at']),
           ]

       def __str__(self):
           username = self.user.username if self.user else 'Sistema'
           return f"{username} - {self.action} - {self.resource}"

       def save(self, *args, **kwargs):
                                       
           Solo permite INSERT, no UPDATE.

           CNST-009: Logs de auditoría son inmutables.
                                                      
           if self.pk:
               raise PermissionError(
                   'CNST-009: Los logs de auditoría son inmutables. '
                   'No se permite modificar registros existentes.'
               )
           super().save(*args, **kwargs)

       def delete(self, *args, **kwargs):
                                         
           PROHIBIDO eliminar logs de auditoría.

           CNST-009: Logs de auditoría son inmutables.
                                                      
           raise PermissionError(
               'CNST-009: Los logs de auditoría son inmutables. '
               'No se permite eliminar registros.'
           )

       @classmethod
       def record(cls, user, action, resource, result='SUCCESS',
                  ip_address=None, user_agent=None, details=None):
                                                                  
           Registrar acción de usuario.

           Args:
               user: Usuario que realiza la acción (puede ser None para sistema)
               action: Tipo de acción (ver ACTION_CHOICES)
               resource: Recurso afectado (ej: 'report:calls_summary')
               result: Resultado (SUCCESS, FAILED, DENIED)
               ip_address: IP del cliente
               user_agent: User-Agent del navegador
               details: Diccionario con detalles adicionales

           Returns:
               UserActionLog creado
                                   
           return cls.objects.create(
               user=user if user and user.is_authenticated else None,
               action=action,
               resource=resource,
               result=result,
               ip_address=ip_address,
               user_agent=user_agent,
               details=details or {}
           )

       @classmethod
       def login(cls, user_id, success, ip=None):
           """Registrar intento de login."""
           action = 'LOGIN' if success else 'LOGIN_FAILED'
           result = 'SUCCESS' if success else 'FAILED'

           return cls.objects.create(
               user_id=user_id if success and user_id else None,
               action=action,
               resource='auth:login',
               result=result,
               ip_address=ip,
               details={'user_id_attempted': user_id}
           )

       @classmethod
       def logout(cls, user_id):
           """Registrar logout."""
           return cls.objects.create(
               user_id=user_id,
               action='LOGOUT',
               resource='auth:logout',
               result='SUCCESS'
           )

APIAccessLog
~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/models.py

   class APIAccessLog(models.Model):
                                    
       Log de accesos a API.

       Registra todos los requests a la API para:
       - Análisis de uso
       - Detección de anomalías
       - Debugging
       - Métricas de performance
                                

       # Request
       method = models.CharField(max_length=10)
       path = models.CharField(max_length=500)
       query_params = models.JSONField(default=dict, blank=True)

       # Usuario
       user = models.ForeignKey(
           User,
           on_delete=models.SET_NULL,
           null=True,
           blank=True
       )
       ip_address = models.GenericIPAddressField(null=True, blank=True)
       user_agent = models.CharField(max_length=500, null=True, blank=True)

       # Response
       status_code = models.IntegerField()
       response_time_ms = models.IntegerField()

       # Timestamp
       created_at = models.DateTimeField(auto_now_add=True, db_index=True)

       class Meta:
           db_table = 'api_access_logs'
           ordering = ['-created_at']
           indexes = [
               models.Index(fields=['path', 'created_at']),
               models.Index(fields=['user', 'created_at']),
               models.Index(fields=['status_code', 'created_at']),
           ]

       def __str__(self):
           return f"{self.method} {self.path} - {self.status_code}"

       def save(self, *args, **kwargs):
           """Solo INSERT permitido."""
           if self.pk:
               raise PermissionError(
                   'CNST-009: Logs de acceso son inmutables.'
               )
           super().save(*args, **kwargs)

       def delete(self, *args, **kwargs):
           """DELETE prohibido."""
           raise PermissionError(
               'CNST-009: Logs de acceso son inmutables.'
           )

ErrorThreshold
~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/models.py

   class ErrorThreshold(models.Model):
                                      
       Registro de errores para monitoreo y alertas.

       Cuando se supera un umbral de errores, se dispara
       una alerta a administradores.
                                    

       SEVERITY_CHOICES = [
           ('LOW', 'Bajo'),
           ('MEDIUM', 'Medio'),
           ('HIGH', 'Alto'),
           ('CRITICAL', 'Crítico'),
       ]

       error_type = models.CharField(max_length=100)
       error_message = models.TextField()
       severity = models.CharField(
           max_length=20,
           choices=SEVERITY_CHOICES,
           default='MEDIUM'
       )
       stack_trace = models.TextField(null=True, blank=True)

       # Contexto
       user = models.ForeignKey(
           User,
           on_delete=models.SET_NULL,
           null=True,
           blank=True
       )
       path = models.CharField(max_length=500, null=True, blank=True)

       # Timestamp
       created_at = models.DateTimeField(auto_now_add=True, db_index=True)

       class Meta:
           db_table = 'error_logs'
           ordering = ['-created_at']
           indexes = [
               models.Index(fields=['error_type', 'created_at']),
               models.Index(fields=['severity', 'created_at']),
           ]

       def save(self, *args, **kwargs):
           """Solo INSERT permitido."""
           if self.pk:
               raise PermissionError('CNST-009: Logs de error son inmutables.')
           super().save(*args, **kwargs)

       def delete(self, *args, **kwargs):
           """DELETE prohibido."""
           raise PermissionError('CNST-009: Logs de error son inmutables.')

       @classmethod
       def log_error(cls, error_type, message, severity='MEDIUM',
                     user=None, path=None, stack_trace=None):
           """Registrar error."""
           error = cls.objects.create(
               error_type=error_type,
               error_message=message,
               severity=severity,
               user=user,
               path=path,
               stack_trace=stack_trace
           )

           # Verificar umbral para alertas
           cls._check_threshold(error_type, severity)

           return error

       @classmethod
       def _check_threshold(cls, error_type, severity):
           """Verificar si se supera umbral de errores."""
           from datetime import timedelta
           from django.utils import timezone
           from apps.common.notifications import notify_admins

           # Contar errores en última hora
           one_hour_ago = timezone.now() - timedelta(hours=1)
           recent_count = cls.objects.filter(
               error_type=error_type,
               created_at__gte=one_hour_ago
           ).count()

           # Umbrales
           thresholds = {
               'CRITICAL': 1,   # 1 error crítico = alerta
               'HIGH': 5,       # 5 errores altos = alerta
               'MEDIUM': 20,    # 20 errores medios = alerta
               'LOW': 100,      # 100 errores bajos = alerta
           }

           if recent_count >= thresholds.get(severity, 10):
               notify_admins(
                   subject=f'Alerta: Umbral de errores superado ({error_type})',
                   body=f'Se han registrado {recent_count} errores de tipo '
                        f'"{error_type}" con severidad {severity} en la última hora.',
                   priority='HIGH'
               )

Middleware de Logging
---------------------

API Access Logger
~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/middleware.py

   import time
   import logging
   from apps.common.models import APIAccessLog

   logger = logging.getLogger('api')

   class APIAccessLogMiddleware:
                                
       Middleware que registra todos los accesos a la API.

       CNST-009: Logging obligatorio de todos los requests.
                                                           

       # Paths excluidos del logging detallado
       EXCLUDED_PATHS = [
           '/api/v1/health/',
           '/api/static/',
           '/favicon.ico',
       ]

       def __init__(self, get_response):
           self.get_response = get_response

       def __call__(self, request):
           # Saltar paths excluidos
           if any(request.path.startswith(p) for p in self.EXCLUDED_PATHS):
               return self.get_response(request)

           start_time = time.time()

           response = self.get_response(request)

           # Calcular tiempo de respuesta
           response_time_ms = int((time.time() - start_time) * 1000)

           # Registrar acceso
           try:
               APIAccessLog.objects.create(
                   method=request.method,
                   path=request.path[:500],
                   query_params=dict(request.GET),
                   user=request.user if request.user.is_authenticated else None,
                   ip_address=self._get_client_ip(request),
                   user_agent=request.META.get('HTTP_USER_AGENT', '')[:500],
                   status_code=response.status_code,
                   response_time_ms=response_time_ms
               )
           except Exception as e:
               logger.error(f'Error registrando acceso API: {e}')

           return response

       def _get_client_ip(self, request):
           """Obtener IP real del cliente."""
           x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
           if x_forwarded_for:
               return x_forwarded_for.split(',')[0].strip()
           return request.META.get('REMOTE_ADDR')

Audit Logger Decorator
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/decorators.py

   import functools
   import logging
   from apps.common.models import UserActionLog

   logger = logging.getLogger('audit')

   def audit_action(action, resource_getter=None):
                                                  
       Decorador para registrar acciones en log de auditoría.

       CNST-009: Usar en todas las acciones significativas.

       Args:
           action: Tipo de acción (ver UserActionLog.ACTION_CHOICES)
           resource_getter: Función que extrae el recurso de los argumentos

       Uso:
           @audit_action('REPORT_GENERATE', lambda r, *a, **k: f"report:{k.get('report_type')}")
           def generate_report(request, report_type):
               ...
                  
       def decorator(func):
           @functools.wraps(func)
           def wrapper(request, *args, **kwargs):
               # Determinar recurso
               if resource_getter:
                   resource = resource_getter(request, *args, **kwargs)
               else:
                   resource = f"{request.method}:{request.path}"

               try:
                   result = func(request, *args, **kwargs)

                   # Determinar resultado basado en response
                   status = getattr(result, 'status_code', 200)
                   audit_result = 'SUCCESS' if status < 400 else 'FAILED'

                   # Registrar en auditoría
                   UserActionLog.record(
                       user=request.user,
                       action=action,
                       resource=resource,
                       result=audit_result,
                       ip_address=_get_client_ip(request),
                       user_agent=request.META.get('HTTP_USER_AGENT', '')[:500],
                       details={
                           'status_code': status,
                           'method': request.method,
                       }
                   )

                   return result

               except Exception as e:
                   # Registrar fallo
                   UserActionLog.record(
                       user=request.user,
                       action=action,
                       resource=resource,
                       result='FAILED',
                       ip_address=_get_client_ip(request),
                       details={'error': str(e)}
                   )
                   raise

           return wrapper
       return decorator


   def _get_client_ip(request):
       """Obtener IP del cliente."""
       x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
       if x_forwarded_for:
           return x_forwarded_for.split(',')[0].strip()
       return request.META.get('REMOTE_ADDR')

Configuración de Logging
------------------------

Django Logging Settings
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/config/settings/base.py

   import os

   LOG_DIR = os.environ.get('LOG_DIR', '/opt/iact/logs')

   LOGGING = {
       'version': 1,
       'disable_existing_loggers': False,

       'formatters': {
           'verbose': {
               'format': '{asctime} [{levelname}] {name} {module}: {message}',
               'style': '{',
               'datefmt': '%Y-%m-%d %H:%M:%S',
           },
           'simple': {
               'format': '{asctime} [{levelname}]: {message}',
               'style': '{',
           },
           'json': {
               'format': '{"timestamp": "%(asctime)s", "level": "%(levelname)s", '
                         '"logger": "%(name)s", "message": "%(message)s"}',
           },
       },

       'filters': {
           'require_debug_false': {
               '()': 'django.utils.log.RequireDebugFalse',
           },
       },

       'handlers': {
           # Archivo principal de aplicación
           'file': {
               'level': 'INFO',
               'class': 'logging.handlers.RotatingFileHandler',
               'filename': os.path.join(LOG_DIR, 'django.log'),
               'maxBytes': 10 * 1024 * 1024,  # 10 MB
               'backupCount': 10,
               'formatter': 'verbose',
           },

           # Archivo de auditoría
           'audit_file': {
               'level': 'INFO',
               'class': 'logging.handlers.RotatingFileHandler',
               'filename': os.path.join(LOG_DIR, 'audit.log'),
               'maxBytes': 50 * 1024 * 1024,  # 50 MB
               'backupCount': 20,
               'formatter': 'json',
           },

           # Archivo ETL
           'etl_file': {
               'level': 'INFO',
               'class': 'logging.handlers.RotatingFileHandler',
               'filename': os.path.join(LOG_DIR, 'etl.log'),
               'maxBytes': 10 * 1024 * 1024,
               'backupCount': 10,
               'formatter': 'verbose',
           },

           # Archivo de errores
           'error_file': {
               'level': 'ERROR',
               'class': 'logging.handlers.RotatingFileHandler',
               'filename': os.path.join(LOG_DIR, 'error.log'),
               'maxBytes': 10 * 1024 * 1024,
               'backupCount': 10,
               'formatter': 'verbose',
           },

           # Archivo de seguridad
           'security_file': {
               'level': 'WARNING',
               'class': 'logging.handlers.RotatingFileHandler',
               'filename': os.path.join(LOG_DIR, 'security.log'),
               'maxBytes': 10 * 1024 * 1024,
               'backupCount': 20,
               'formatter': 'json',
           },

           # Consola (desarrollo)
           'console': {
               'level': 'DEBUG',
               'class': 'logging.StreamHandler',
               'formatter': 'simple',
           },
       },

       'loggers': {
           # Logger principal Django
           'django': {
               'handlers': ['file', 'error_file'],
               'level': 'INFO',
               'propagate': True,
           },

           # Logger de requests Django
           'django.request': {
               'handlers': ['file', 'error_file'],
               'level': 'INFO',
               'propagate': False,
           },

           # Logger de aplicaciones IACT
           'apps': {
               'handlers': ['file', 'error_file'],
               'level': 'INFO',
               'propagate': True,
           },

           # Logger de auditoría
           'audit': {
               'handlers': ['audit_file'],
               'level': 'INFO',
               'propagate': False,
           },

           # Logger de API
           'api': {
               'handlers': ['file'],
               'level': 'INFO',
               'propagate': False,
           },

           # Logger ETL
           'etl': {
               'handlers': ['etl_file', 'error_file'],
               'level': 'INFO',
               'propagate': False,
           },

           # Logger de seguridad
           'security': {
               'handlers': ['security_file', 'error_file'],
               'level': 'WARNING',
               'propagate': False,
           },

           # Logger de performance
           'performance': {
               'handlers': ['file'],
               'level': 'WARNING',
               'propagate': False,
           },
       },
   }

Retención de Logs
-----------------

Política de Retención
~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 30 20 50

   * - Tipo de Log
     - Retención
     - Justificación
   * - UserActionLog (BD)
     - 2 años
     - Auditoría y compliance
   * - APIAccessLog (BD)
     - 90 días
     - Análisis de uso
   * - ErrorThreshold (BD)
     - 1 año
     - Análisis de problemas
   * - Archivos .log
     - 30 días
     - Debugging
   * - audit.log
     - 1 año
     - Backup de auditoría

Script de Limpieza
~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/management/commands/cleanup_logs.py

   from django.core.management.base import BaseCommand
   from django.utils import timezone
   from datetime import timedelta
   from apps.common.models import APIAccessLog, ErrorThreshold
   import logging

   logger = logging.getLogger('apps')

   class Command(BaseCommand):
       help = 'Limpiar logs antiguos según política de retención CNST-009'

       def add_arguments(self, parser):
           parser.add_argument(
               '--dry-run',
               action='store_true',
               help='Mostrar qué se eliminaría sin hacerlo'
           )

       def handle(self, *args, **options):
           dry_run = options['dry_run']
           now = timezone.now()

           # APIAccessLog: 90 días
           api_cutoff = now - timedelta(days=90)
           api_old = APIAccessLog.objects.filter(created_at__lt=api_cutoff)
           api_count = api_old.count()

           # ErrorThreshold: 1 año
           error_cutoff = now - timedelta(days=365)
           error_old = ErrorThreshold.objects.filter(created_at__lt=error_cutoff)
           error_count = error_old.count()

           self.stdout.write(f'APIAccessLog antiguos (>90 días): {api_count}')
           self.stdout.write(f'ErrorThreshold antiguos (>1 año): {error_count}')

           if dry_run:
               self.stdout.write('Modo DRY-RUN: No se eliminó nada')
               return

           # Eliminar en batches para no bloquear BD
           # Nota: Estos logs SÍ se pueden eliminar por antigüedad
           # Solo UserActionLog es completamente inmutable

           deleted_api = 0
           while True:
               batch = list(api_old.values_list('id', flat=True)[:1000])
               if not batch:
                   break
               APIAccessLog.objects.filter(id__in=batch).delete()
               deleted_api += len(batch)

           deleted_error = 0
           while True:
               batch = list(error_old.values_list('id', flat=True)[:1000])
               if not batch:
                   break
               ErrorThreshold.objects.filter(id__in=batch).delete()
               deleted_error += len(batch)

           self.stdout.write(
               self.style.SUCCESS(
                   f'Eliminados: {deleted_api} APIAccessLog, {deleted_error} ErrorThreshold'
               )
           )

           logger.info(
               f'Limpieza de logs completada: {deleted_api} APIAccessLog, '
               f'{deleted_error} ErrorThreshold eliminados'
           )

Consulta de Auditoría
---------------------

Vista de Auditoría (Admin)
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/views.py

   from rest_framework import viewsets, filters
   from rest_framework.permissions import IsAuthenticated
   from rest_framework.response import Response
   from django_filters.rest_framework import DjangoFilterBackend
   from apps.common.models import UserActionLog, APIAccessLog
   from apps.common.permissions import IsAdminUser
   from apps.common.pagination import StandardPagination

   class AuditLogViewSet(viewsets.ReadOnlyModelViewSet):
                                                        
       ViewSet de solo lectura para logs de auditoría.

       Solo administradores pueden consultar.
       NO permite crear, modificar ni eliminar.
                                               

       queryset = UserActionLog.objects.all()
       permission_classes = [IsAuthenticated, IsAdminUser]
       pagination_class = StandardPagination
       filter_backends = [DjangoFilterBackend, filters.OrderingFilter]
       filterset_fields = ['user', 'action', 'result', 'resource']
       ordering_fields = ['created_at', 'action', 'result']
       ordering = ['-created_at']

       def get_serializer_class(self):
           from apps.common.serializers import UserActionLogSerializer
           return UserActionLogSerializer


   class UserActivityView(viewsets.ViewSet):
                                            
       Vista de actividad de usuario específico.

       Permite a usuarios ver su propia actividad.
       Admins pueden ver actividad de cualquier usuario.
                                                        

       permission_classes = [IsAuthenticated]

       def list(self, request):
           user_id = request.query_params.get('user_id')

           # Usuarios normales solo ven su propia actividad
           if not request.user.is_staff:
               user_id = request.user.id

           logs = UserActionLog.objects.filter(user_id=user_id).order_by('-created_at')[:100]

           data = [
               {
                   'action': log.action,
                   'resource': log.resource,
                   'result': log.result,
                   'timestamp': log.created_at.isoformat(),
                   'ip_address': log.ip_address,
               }
               for log in logs
           ]

           return Response({'activity': data})

Serializer de Auditoría
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/serializers.py

   from rest_framework import serializers
   from apps.common.models import UserActionLog

   class UserActionLogSerializer(serializers.ModelSerializer):
                                                         
       Serializer de solo lectura para logs de auditoría.
                                                         

       username = serializers.CharField(source='user.username', read_only=True)

       class Meta:
           model = UserActionLog
           fields = [
               'id',
               'username',
               'action',
               'resource',
               'result',
               'ip_address',
               'user_agent',
               'details',
               'created_at',
           ]
           read_only_fields = fields

Validación en Desarrollo
------------------------

Pre-commit Checklist
~~~~~~~~~~~~~~~~~~~~

Antes de hacer commit, verificar:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - Modelos de log tienen ``save()`` protegido
   * - [ ]
     - Modelos de log tienen ``delete()`` protegido
   * - [ ]
     - Acciones importantes usan ``@audit_action``
   * - [ ]
     - ``UserActionLog.record()`` en operaciones críticas
   * - [ ]
     - No hay ``UPDATE`` ni ``DELETE`` en tablas de log

Code Review Checklist
~~~~~~~~~~~~~~~~~~~~~

Durante code review, rechazar si:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - Se modifica o elimina logs de auditoría
   * - [ ]
     - Acción significativa sin logging
   * - [ ]
     - Login/logout sin registro en UserActionLog
   * - [ ]
     - Exportaciones sin auditoría

Script de Validación
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   #!/bin/bash
   # scripts/validate_audit_logging.sh

   echo "Validando logging de auditoría..."

   ERRORS=0

   # Verificar que modelos de log tienen protección
   if ! grep -q "raise PermissionError" api/apps/common/models.py; then
       echo "ERROR: Modelos de log sin protección de inmutabilidad"
       ERRORS=$((ERRORS + 1))
   fi

   # Buscar posibles deletes en tablas de log
   if grep -r "UserActionLog.objects.delete\|\.delete()" api/apps/ --include="*.py" | grep -v "cleanup_logs\|test"; then
       echo "WARNING: Posibles deletes en logs de auditoría"
   fi

   # Verificar que login usa auditoría
   if ! grep -q "UserActionLog" api/apps/users/views.py; then
       echo "WARNING: Login puede no estar registrando auditoría"
   fi

   if [ $ERRORS -eq 0 ]; then
       echo "OK: Configuración de auditoría correcta"
       exit 0
   else
       echo "FALLO: $ERRORS errores de auditoría encontrados"
       exit 1
   fi

Referencias
-----------

Documentos Relacionados
~~~~~~~~~~~~~~~~~~~~~~~

- CNST-002: Gestión de Sesiones (login/logout)
- CNST-005: Seguridad DRF (permisos para auditoría)
- CNST-007: Límites de Performance (logs de performance)

Implementación de Referencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- ``api/apps/common/models.py`` - UserActionLog, APIAccessLog, ErrorThreshold
- ``api/apps/common/middleware.py`` - APIAccessLogMiddleware
- ``api/apps/common/decorators.py`` - audit_action
- ``api/config/settings/base.py`` - LOGGING configuration

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 50 20

   * - Versión
     - Fecha
     - Cambios
     - Autor
   * - 1.0.1
     - 2026-01-03
     - Actualización de metadatos. Sin cambios funcionales
     - Equipo IACT
   * - 1.0.0
     - 2025-12-17
     - Versión inicial con Clean Code, sin referencias externas
     - Equipo IACT

Aprobaciones
------------

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Rol
     - Nombre
     - Firma / Fecha
   * - Cliente (Sponsor)
     - [Nombre]
     - [Pendiente]
   * - Tech Lead
     - [Nombre]
     - [Pendiente]
   * - Security Officer
     - [Nombre]
     - [Pendiente]

----

**Fin del Documento CNST-009**
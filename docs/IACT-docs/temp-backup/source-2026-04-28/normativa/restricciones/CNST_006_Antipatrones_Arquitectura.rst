CNST-006: Antipatrones de Arquitectura Prohibidos
=================================================

:ID: CNST-006
:Versión: 1.1.0
:Fecha: 2026-01-03
:Estado: VIGENTE
:Clasificación: CRÍTICO - NO NEGOCIABLE
:Origen: Estándares de calidad de código

----

Propósito
---------

Este documento establece los antipatrones de arquitectura y diseño prohibidos en el Sistema IACT - IVR Analytics & Customer Tracking, con ejemplos de código incorrecto y correcto para cada caso.

Contexto
--------

Origen de la Restricción
~~~~~~~~~~~~~~~~~~~~~~~~

Estándares de calidad de código requeridos para mantener un sistema mantenible, escalable y libre de deuda técnica. El código debe seguir principios SOLID y Clean Code.

Justificación
~~~~~~~~~~~~~

- Facilitar mantenimiento a largo plazo
- Reducir deuda técnica
- Mejorar legibilidad del código
- Facilitar testing y debugging
- Permitir onboarding rápido de nuevos desarrolladores

Aplicable a
~~~~~~~~~~~

- Todo el código Python del backend
- Código JavaScript/TypeScript del frontend
- Configuraciones y scripts
- Todas las fases del ciclo de vida

Antipatrones Prohibidos
-----------------------

Antipatrón 1: God Class (Clase Dios)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Una clase que hace demasiadas cosas, tiene demasiadas responsabilidades o conoce demasiado sobre otras partes del sistema.

Señales de Alerta
^^^^^^^^^^^^^^^^^

- Clase con más de 500 líneas
- Más de 10 métodos públicos
- Nombre genérico: Manager, Handler, Processor, Service
- Múltiples responsabilidades no relacionadas

Código INCORRECTO
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # PROHIBIDO - God Class
   class SystemManager:
       """Esta clase hace TODO - antipatrón."""

       def __init__(self):
           self.db = Database()
           self.cache = Cache()
           self.logger = Logger()
           self.emailer = Emailer()  # Violación CNST-001

       def authenticate_user(self, username, password):
           # Autenticación
           pass

       def generate_report(self, params):
           # Generación de reportes
           pass

       def run_etl(self):
           # Proceso ETL
           pass

       def send_notification(self, user, message):
           # Notificaciones
           pass

       def backup_database(self):
           # Backups
           pass

       def validate_permissions(self, user, resource):
           # Permisos
           pass

       # ... 50 métodos más ...

Código CORRECTO
^^^^^^^^^^^^^^^

.. code-block:: python

   # CORRECTO - Responsabilidad única por clase

   class AuthenticationService:
       """Maneja solo autenticación."""

       def authenticate(self, username, password):
           pass

       def validate_token(self, token):
           pass


   class ReportGenerator:
       """Genera reportes."""

       def generate(self, report_type, params):
           pass

       def export_to_csv(self, data):
           pass


   class ETLPipeline:
       """Ejecuta proceso ETL."""

       def run(self, start_date, end_date):
           pass


   class NotificationSender:
       """Envía notificaciones internas (CNST-001)."""

       def send(self, recipient, subject, body):
           from apps.common.models import InternalMessage
           InternalMessage.objects.create(
               recipient=recipient,
               subject=subject,
               body=body
           )

Antipatrón 2: Spaghetti Code
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Código con flujo de control enredado, difícil de seguir, con múltiples niveles de anidación y sin estructura clara.

Señales de Alerta
^^^^^^^^^^^^^^^^^

- Más de 3 niveles de anidación (if dentro de if dentro de if)
- Funciones de más de 50 líneas
- Múltiples returns dispersos
- Lógica mezclada sin separación

Código INCORRECTO
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # PROHIBIDO - Spaghetti Code
   def process_call_data(data):
       if data:
           if 'calls' in data:
               for call in data['calls']:
                   if call.get('valid'):
                       if call.get('duration') > 0:
                           if call.get('queue_id'):
                               queue = get_queue(call['queue_id'])
                               if queue:
                                   if queue.is_active:
                                       metric = CallMetric()
                                       metric.queue_id = call['queue_id']
                                       metric.duration = call['duration']
                                       if call.get('outcome') == 'COMPLETED':
                                           metric.completed = True
                                       else:
                                           if call.get('outcome') == 'ABANDONED':
                                               metric.abandoned = True
                                           else:
                                               metric.other = True
                                       metric.save()
                                       return True
       return False

Código CORRECTO
^^^^^^^^^^^^^^^

.. code-block:: python

   # CORRECTO - Código limpio con early returns y funciones pequeñas

   def process_call_data(data):
       """Procesar datos de llamadas."""
       if not data or 'calls' not in data:
           return False

       processed = False
       for call in data['calls']:
           if _process_single_call(call):
               processed = True

       return processed


   def _process_single_call(call):
       """Procesar una llamada individual."""
       if not _is_valid_call(call):
           return False

       queue = _get_active_queue(call['queue_id'])
       if not queue:
           return False

       metric = _create_metric(call)
       metric.save()
       return True


   def _is_valid_call(call):
       """Validar datos de llamada."""
       return (
           call.get('valid') and
           call.get('duration', 0) > 0 and
           call.get('queue_id')
       )


   def _get_active_queue(queue_id):
       """Obtener cola activa."""
       queue = get_queue(queue_id)
       return queue if queue and queue.is_active else None


   def _create_metric(call):
       """Crear métrica desde llamada."""
       metric = CallMetric(
           queue_id=call['queue_id'],
           duration=call['duration']
       )

       outcome = call.get('outcome', '')
       metric.completed = (outcome == 'COMPLETED')
       metric.abandoned = (outcome == 'ABANDONED')
       metric.other = (outcome not in ['COMPLETED', 'ABANDONED'])

       return metric

Antipatrón 3: Copy-Paste Programming
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Duplicación de código en múltiples lugares en vez de extraer funcionalidad común.

Señales de Alerta
^^^^^^^^^^^^^^^^^

- Bloques de código idénticos o casi idénticos
- Misma lógica en múltiples archivos
- Correcciones que deben hacerse en múltiples lugares

Código INCORRECTO
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # PROHIBIDO - Código duplicado

   # En views/reports.py
   class DailyMetricsReportView(APIView):
       def get(self, request):
           user = request.user
           if not user.is_authenticated:
               return Response({'error': 'No autenticado'}, status=401)
           if not user.is_active:
               return Response({'error': 'Usuario inactivo'}, status=403)
           # ... lógica del reporte

   # En views/analytics.py (MISMO CÓDIGO)
   class CallAnalyticsView(APIView):
       def get(self, request):
           user = request.user
           if not user.is_authenticated:
               return Response({'error': 'No autenticado'}, status=401)
           if not user.is_active:
               return Response({'error': 'Usuario inactivo'}, status=403)
           # ... lógica de analytics

   # En views/exports.py (MISMO CÓDIGO otra vez)
   class CSVExportView(APIView):
       def get(self, request):
           user = request.user
           if not user.is_authenticated:
               return Response({'error': 'No autenticado'}, status=401)
           if not user.is_active:
               return Response({'error': 'Usuario inactivo'}, status=403)
           # ... lógica de exportación

Código CORRECTO
^^^^^^^^^^^^^^^

.. code-block:: python

   # CORRECTO - Extraer a permisos reutilizables

   # En common/permissions.py
   from rest_framework import permissions

   class IsActiveUser(permissions.BasePermission):
       """Permiso reutilizable: usuario activo."""

       message = 'Usuario inactivo'

       def has_permission(self, request, view):
           return (
               request.user and
               request.user.is_authenticated and
               request.user.is_active
           )


   # En views/reports.py
   class DailyMetricsReportView(APIView):
       permission_classes = [IsActiveUser]

       def get(self, request):
           # Solo lógica del reporte
           pass


   # En views/analytics.py
   class CallAnalyticsView(APIView):
       permission_classes = [IsActiveUser]

       def get(self, request):
           # Solo lógica de analytics
           pass


   # En views/exports.py
   class CSVExportView(APIView):
       permission_classes = [IsActiveUser]

       def get(self, request):
           # Solo lógica de exportación
           pass

Antipatrón 4: Magic Numbers/Strings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Uso de valores literales sin explicación en el código, haciendo difícil entender su propósito.

Señales de Alerta
^^^^^^^^^^^^^^^^^

- Números sin contexto: ``if status == 1``
- Strings repetidos: ``if role == 'admin'``
- Valores de configuración hardcoded

Código INCORRECTO
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # PROHIBIDO - Magic numbers y strings

   def check_permissions(user, action):
       if user.role == 1:  # ¿Qué es 1?
           return True
       if user.role == 2 and action in ['read', 'list']:  # ¿Qué es 2?
           return True
       if user.login_attempts > 5:  # ¿Por qué 5?
           lock_user(user)
       return False

   def get_metrics(days=30):  # ¿Por qué 30?
       timeout = 300  # ¿300 qué?
       max_records = 10000  # ¿Por qué este límite?
       # ...

Código CORRECTO
^^^^^^^^^^^^^^^

.. code-block:: python

   # CORRECTO - Constantes con nombres descriptivos

   # En common/constants.py
   class UserFunction:
       """Funciones de usuario (RBAC v5.1.1)."""
       ADMINISTRA_SISTEMA = 'administra_sistema'
       ANALIZA_DATOS = 'analiza_datos'
       VE_REPORTES = 've_reportes'


   class SecurityLimits:
       """Límites de seguridad."""
       MAX_LOGIN_ATTEMPTS = 5
       LOCKOUT_DURATION_MINUTES = 30


   class QueryLimits:
       """Límites de consultas."""
       DEFAULT_DAYS_RANGE = 30
       MAX_DAYS_RANGE = 90
       QUERY_TIMEOUT_SECONDS = 300
       MAX_EXPORT_RECORDS = 10000


   # Uso correcto
   from common.constants import UserFunction, SecurityLimits, QueryLimits

   def check_permissions(user, action):
       if user.has_function(UserFunction.ADMINISTRA_SISTEMA):
           return True

       if user.has_function(UserFunction.VE_REPORTES) and action in ['read', 'list']:
           return True

       if user.login_attempts > SecurityLimits.MAX_LOGIN_ATTEMPTS:
           lock_user(user)

       return False


   def get_metrics(days=QueryLimits.DEFAULT_DAYS_RANGE):
       timeout = QueryLimits.QUERY_TIMEOUT_SECONDS
       max_records = QueryLimits.MAX_EXPORT_RECORDS
       # ...


Antipatrón 5: Hardcoded Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Valores de configuración (URLs, credenciales, paths) escritos directamente en el código.

Señales de Alerta
^^^^^^^^^^^^^^^^^

- URLs hardcoded
- Credenciales en código
- Paths absolutos
- Configuraciones específicas de ambiente

Código INCORRECTO
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # PROHIBIDO - Configuración hardcoded

   import mysql.connector

   def connect_to_ivr():
       return mysql.connector.connect(
           host='192.168.1.100',
           user='ivr_user',
           password='secretpassword123',  # NUNCA hacer esto
           database='ivr_production'
       )

   def get_api_url():
       return 'https://api.cliente.com/v1'

   LOG_PATH = '/var/log/iact/app.log'

Código CORRECTO
^^^^^^^^^^^^^^^

.. code-block:: python

   # CORRECTO - Configuración desde variables de entorno

   # En config/settings/base.py
   import os
   from decouple import config

   DATABASES = {
       'ivr_readonly': {
           'ENGINE': 'django.db.backends.mysql',
           'HOST': config('DB_IVR_HOST'),
           'USER': config('DB_IVR_USER'),
           'PASSWORD': config('DB_IVR_PASSWORD'),
           'NAME': config('DB_IVR_NAME'),
       }
   }

   API_BASE_URL = config('API_BASE_URL', default='http://localhost:8000')
   LOG_PATH = config('LOG_PATH', default='/var/log/iact/app.log')


   # En .env (NO commitear)
   DB_IVR_HOST=192.168.1.100
   DB_IVR_USER=ivr_user
   DB_IVR_PASSWORD=secretpassword123
   DB_IVR_NAME=ivr_production
   API_BASE_URL=https://api.cliente.com/v1
   LOG_PATH=/var/log/iact/app.log


   # En .env.example (SÍ commitear)
   DB_IVR_HOST=<HOST>
   DB_IVR_USER=<USER>
   DB_IVR_PASSWORD=<PASSWORD>
   DB_IVR_NAME=<DATABASE>
   API_BASE_URL=<URL>
   LOG_PATH=<PATH>

Antipatrón 6: Premature Optimization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Optimizar código antes de que sea necesario, añadiendo complejidad innecesaria sin beneficio medible.

Señales de Alerta
^^^^^^^^^^^^^^^^^

- Caché complejo para datos poco accedidos
- Estructuras de datos complejas para casos simples
- Código difícil de leer "por rendimiento"

Código INCORRECTO
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # PROHIBIDO - Optimización prematura

   class MetricsCache:
       """Caché complejo innecesario para pocos datos."""

       _instance = None
       _cache = {}
       _timestamps = {}
       _hit_count = {}
       _miss_count = {}
       _lock = threading.Lock()

       def __new__(cls):
           if cls._instance is None:
               cls._instance = super().__new__(cls)
           return cls._instance

       def get(self, key, ttl=300):
           with self._lock:
               if key in self._cache:
                   if time.time() - self._timestamps[key] < ttl:
                       self._hit_count[key] = self._hit_count.get(key, 0) + 1
                       return self._cache[key]
               self._miss_count[key] = self._miss_count.get(key, 0) + 1
               return None

       # ... 100 líneas más de complejidad

Código CORRECTO
^^^^^^^^^^^^^^^

.. code-block:: python

   # CORRECTO - Simple hasta que se demuestre necesidad

   def get_daily_metrics(date):
       """Obtener métricas del día (sin caché innecesario)."""
       return CallMetric.objects.filter(metric_date=date).aggregate(
           total=Sum('total_calls'),
           completed=Sum('completed_calls'),
           abandoned=Sum('abandoned_calls')
       )

   # Si después se demuestra que necesita caché,
   # usar el sistema de caché de Django (simple)

   from django.core.cache import cache

   def get_daily_metrics_cached(date):
       """Métricas con caché simple (solo si es necesario)."""
       cache_key = f'metrics_{date}'

       result = cache.get(cache_key)
       if result is None:
           result = CallMetric.objects.filter(metric_date=date).aggregate(
               total=Sum('total_calls'),
               completed=Sum('completed_calls'),
               abandoned=Sum('abandoned_calls')
           )
           cache.set(cache_key, result, timeout=3600)

       return result

Antipatrón 7: Callback Hell / Pyramid of Doom
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Múltiples niveles de callbacks anidados que hacen el código difícil de leer y mantener.

Señales de Alerta
^^^^^^^^^^^^^^^^^

- Callbacks dentro de callbacks
- Indentación excesiva
- Difícil seguir flujo de ejecución

Código INCORRECTO
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # PROHIBIDO - Callback hell

   def process_data(data, callback):
       def on_validate(is_valid):
           if is_valid:
               def on_transform(transformed):
                   def on_save(saved):
                       if saved:
                           def on_notify(notified):
                               callback(True)
                           notify_completion(on_notify)
                       else:
                           callback(False)
                   save_data(transformed, on_save)
               transform_data(data, on_transform)
           else:
               callback(False)
       validate_data(data, on_validate)

Código CORRECTO
^^^^^^^^^^^^^^^

.. code-block:: python

   # CORRECTO - Flujo lineal y claro

   def process_data(data):
       """Procesar datos con flujo claro."""
       if not validate_data(data):
           return False

       transformed = transform_data(data)

       if not save_data(transformed):
           return False

       notify_completion()
       return True


   # O con excepciones para control de flujo

   class ProcessingError(Exception):
       pass


   def process_data(data):
       """Procesar datos con manejo de errores."""
       try:
           validated = validate_data(data)
           transformed = transform_data(validated)
           saved = save_data(transformed)
           notify_completion(saved)
           return True
       except ProcessingError as e:
           logger.error(f'Error procesando datos: {e}')
           return False

Antipatrón 8: Feature Envy
~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Un método que usa más datos o métodos de otra clase que de la suya propia.

Señales de Alerta
^^^^^^^^^^^^^^^^^

- Múltiples llamadas a métodos de otro objeto
- Acceso constante a atributos de otra clase
- La lógica pertenece más a la otra clase

Código INCORRECTO
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # PROHIBIDO - Feature Envy

   class ReportGenerator:
       def calculate_queue_stats(self, queue):
           # Esta lógica debería estar en Queue o QueueStats
           total_calls = queue.get_total_calls()
           completed = queue.get_completed_calls()
           abandoned = queue.get_abandoned_calls()

           completion_rate = completed / total_calls if total_calls else 0
           abandon_rate = abandoned / total_calls if total_calls else 0

           avg_duration = queue.get_avg_duration()
           avg_wait = queue.get_avg_wait_time()

           service_level = queue.get_service_level()

           return {
               'completion_rate': completion_rate,
               'abandon_rate': abandon_rate,
               'avg_duration': avg_duration,
               'avg_wait': avg_wait,
               'service_level': service_level
           }

Código CORRECTO
^^^^^^^^^^^^^^^

.. code-block:: python

   # CORRECTO - La lógica está donde pertenece

   class QueueStatistics:
       """Estadísticas de una cola."""

       def __init__(self, queue_id, start_date, end_date):
           self.queue_id = queue_id
           self.metrics = self._load_metrics(start_date, end_date)

       def _load_metrics(self, start_date, end_date):
           return CallMetric.objects.filter(
               queue_id=self.queue_id,
               metric_date__range=[start_date, end_date]
           ).aggregate(
               total=Sum('total_calls'),
               completed=Sum('completed_calls'),
               abandoned=Sum('abandoned_calls'),
               avg_duration=Avg('avg_duration'),
               avg_wait=Avg('avg_wait_time')
           )

       @property
       def completion_rate(self):
           total = self.metrics['total'] or 0
           completed = self.metrics['completed'] or 0
           return completed / total if total else 0

       @property
       def abandon_rate(self):
           total = self.metrics['total'] or 0
           abandoned = self.metrics['abandoned'] or 0
           return abandoned / total if total else 0

       def to_dict(self):
           return {
               'completion_rate': self.completion_rate,
               'abandon_rate': self.abandon_rate,
               'avg_duration': self.metrics['avg_duration'],
               'avg_wait': self.metrics['avg_wait']
           }


   class ReportGenerator:
       def get_queue_stats(self, queue_id, start_date, end_date):
           stats = QueueStatistics(queue_id, start_date, end_date)
           return stats.to_dict()

Antipatrón 9: Primitive Obsession
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Usar tipos primitivos (strings, ints) donde objetos de dominio serían más apropiados.

Señales de Alerta
^^^^^^^^^^^^^^^^^

- Strings que representan conceptos complejos
- Validaciones repetidas del mismo tipo de dato
- Múltiples parámetros relacionados

Código INCORRECTO
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # PROHIBIDO - Primitive Obsession

   def create_report(
       start_year, start_month, start_day,
       end_year, end_month, end_day,
       queue_ids_str,  # "1,2,3"
       format_type     # "csv" o "excel"
   ):
       # Validar fechas manualmente cada vez
       if start_month < 1 or start_month > 12:
           raise ValueError('Mes inválido')

       # Parsear queue_ids manualmente
       queue_ids = [int(x) for x in queue_ids_str.split(',')]

       # Validar formato manualmente
       if format_type not in ['csv', 'excel', 'pdf']:
           raise ValueError('Formato inválido')

       # ...

Código CORRECTO
^^^^^^^^^^^^^^^

.. code-block:: python

   # CORRECTO - Objetos de dominio

   from dataclasses import dataclass
   from datetime import date
   from enum import Enum
   from typing import List

   class ExportFormat(Enum):
       CSV = 'csv'
       EXCEL = 'excel'
       PDF = 'pdf'


   @dataclass
   class DateRange:
       """Rango de fechas validado."""

       start: date
       end: date

       def __post_init__(self):
           if self.end < self.start:
               raise ValueError('Fecha fin debe ser >= fecha inicio')

           if (self.end - self.start).days > 90:
               raise ValueError('Rango máximo: 90 días')

       @classmethod
       def last_n_days(cls, days: int):
           end = date.today()
           start = end - timedelta(days=days)
           return cls(start=start, end=end)


   @dataclass
   class ReportRequest:
       """Solicitud de reporte validada."""

       date_range: DateRange
       queue_ids: List[int]
       format: ExportFormat

       def __post_init__(self):
           if not self.queue_ids:
               raise ValueError('Debe especificar al menos una cola')

           if len(self.queue_ids) > 50:
               raise ValueError('Máximo 50 colas por reporte')


   # Uso limpio
   def create_report(request: ReportRequest):
       """Crear reporte con datos validados."""
       # request ya está validado por el dataclass
       metrics = CallMetric.objects.filter(
           queue_id__in=request.queue_ids,
           metric_date__range=[request.date_range.start, request.date_range.end]
       )
       # ...

Antipatrón 10: Shotgun Surgery
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Un cambio requiere modificaciones en muchos lugares diferentes del código.

Señales de Alerta
^^^^^^^^^^^^^^^^^

- Cambiar un campo requiere modificar 10+ archivos
- Lógica relacionada dispersa en todo el proyecto
- Difícil saber todos los lugares afectados por un cambio

Código INCORRECTO
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # PROHIBIDO - Lógica dispersa

   # En models.py
   class User(models.Model):
       function_code = models.CharField(max_length=50)

   # En views.py
   def can_view_reports(user):
       return user.function_code in ['ve_reportes', 'exporta_reportes',
                                      'crea_reportes_avanzados', 'administra_sistema']

   # En api/views.py (duplicado)
   def check_report_access(user):
       return user.function_code in ['ve_reportes', 'exporta_reportes',
                                      'crea_reportes_avanzados', 'administra_sistema']

   # En templates/base.html
   # {% if user.function_code in 've_reportes,exporta_reportes,...' %}

   # En serializers.py
   def validate_user(user):
       if user.function_code not in ['ve_reportes', 'exporta_reportes',
                                       'crea_reportes_avanzados', 'administra_sistema']:
           raise ValidationError('Sin permisos')

   # Agregar una nueva función requiere cambiar TODOS estos lugares

Código CORRECTO
^^^^^^^^^^^^^^^

.. code-block:: python

   # CORRECTO - Lógica centralizada (RBAC v5.1.1)

   # En common/permissions.py (UN solo lugar)

   class FunctionPermissions:
       """Permisos centralizados por función (RBAC v5.1.1)."""

       REPORT_VIEWERS = ['ve_reportes', 'exporta_reportes',
                         'crea_reportes_avanzados', 'administra_sistema']
       DATA_ANALYSTS = ['analiza_datos', 'administra_sistema']
       USER_MANAGERS = ['gestiona_usuarios_completo',
                        'gestiona_usuarios_parcial', 'administra_sistema']
       ALERT_MANAGERS = ['configura_alertas', 'gestiona_eventos_alertas',
                         'gestiona_templates_alertas', 'administra_sistema']

       @classmethod
       def can_view_reports(cls, user):
           return cls._has_any_function(user, cls.REPORT_VIEWERS)

       @classmethod
       def can_analyze_data(cls, user):
           return cls._has_any_function(user, cls.DATA_ANALYSTS)

       @classmethod
       def can_manage_users(cls, user):
           return cls._has_any_function(user, cls.USER_MANAGERS)

       @classmethod
       def _has_any_function(cls, user, allowed_functions):
           if not user or not user.is_authenticated:
               return False
           if user.is_staff:
               return True

           user_functions = user.function_assignments.filter(
               is_active=True
           ).values_list('function_code', flat=True)

           return any(func in user_functions for func in allowed_functions)


   # Uso en cualquier parte del sistema
   from common.permissions import FunctionPermissions

   # En views.py
   if FunctionPermissions.can_view_reports(request.user):
       # ...

   # En serializers.py
   if not FunctionPermissions.can_view_reports(user):
       raise ValidationError('Sin permisos')

   # Agregar nueva función: cambiar SOLO FunctionPermissions


Patrones Recomendados
---------------------

Esta sección complementa los antipatrones prohibidos con patrones arquitectónicos recomendados para el sistema IACT.

Patrón 1: Repository Pattern
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Aislar la lógica de acceso a datos del resto de la aplicación, facilitando testing y cambios en el origen de datos.

Cuándo Usar
^^^^^^^^^^^

- Consultas complejas que se repiten
- Necesidad de mockear acceso a datos en tests
- Lógica de negocio mezclada con queries

Implementación
^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/analytics/repositories.py

   from django.db.models import Sum, Avg, Q
   from django.utils import timezone
   from datetime import timedelta
   from apps.analytics.models import CallMetric

   class MetricsRepository:
                           
       Repositorio de métricas de llamadas.

       Centraliza todas las queries de CallMetric
       para facilitar testing y mantenimiento.
                                              

       def get_daily_summary(self, date):
           """Obtener resumen de métricas de un día."""
           return CallMetric.objects.filter(
               metric_date=date
           ).aggregate(
               total_calls=Sum('total_calls'),
               completed_calls=Sum('completed_calls'),
               abandoned_calls=Sum('abandoned_calls'),
               avg_duration=Avg('avg_duration'),
               avg_wait_time=Avg('avg_wait_time')
           )

       def get_queue_metrics(self, queue_id, start_date, end_date):
           """Obtener métricas de una cola en rango de fechas."""
           return CallMetric.objects.filter(
               queue_id=queue_id,
               metric_date__range=[start_date, end_date]
           ).order_by('metric_date')

       def get_top_queues_by_volume(self, date, limit=10):
           """Top N colas por volumen de llamadas."""
           return CallMetric.objects.filter(
               metric_date=date
           ).order_by('-total_calls')[:limit]

       def get_queues_with_high_abandon_rate(self, date, threshold=0.2):
           """Colas con tasa de abandono superior al umbral."""
           metrics = CallMetric.objects.filter(
               metric_date=date,
               total_calls__gt=0
           )

           return [
               m for m in metrics
               if (m.abandoned_calls / m.total_calls) > threshold
           ]

       def get_last_n_days_metrics(self, queue_id, days=30):
           """Métricas de los últimos N días para una cola."""
           end_date = timezone.now().date()
           start_date = end_date - timedelta(days=days)

           return self.get_queue_metrics(queue_id, start_date, end_date)


   # Uso en vistas
   from apps.analytics.repositories import MetricsRepository

   class DailyMetricsReportView(APIView):
       def __init__(self):
           self.metrics_repo = MetricsRepository()

       def get(self, request):
           date = request.query_params.get('date')
           summary = self.metrics_repo.get_daily_summary(date)
           return Response(summary)

Patrón 2: Service Layer
~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Capa intermedia que contiene lógica de negocio, coordinando múltiples repositorios y operaciones.

Cuándo Usar
^^^^^^^^^^^

- Operaciones que involucran múltiples modelos
- Lógica de negocio compleja
- Necesidad de transacciones

Implementación
^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/reports/services.py

   from django.db import transaction
   from django.utils import timezone
   from apps.analytics.repositories import MetricsRepository
   from apps.reports.models import GeneratedReport
   from apps.common.audit import UserActionLog
   import logging

   logger = logging.getLogger('reports')

   class ReportService:
                       
       Servicio de generación de reportes.

       Coordina repositorios, valida reglas de negocio
       y gestiona auditoría.
                            

       def __init__(self):
           self.metrics_repo = MetricsRepository()

       @transaction.atomic
       def generate_daily_report(self, user, date, queue_ids):
                                                              
           Generar reporte diario con auditoría.

           Args:
               user: Usuario solicitante
               date: Fecha del reporte
               queue_ids: Lista de colas a incluir

           Returns:
               GeneratedReport creado

           Raises:
               ValueError: Si parámetros son inválidos
                                                      
           # Validar
           self._validate_report_request(date, queue_ids)

           # Obtener datos
           metrics = self._gather_metrics(date, queue_ids)

           # Calcular totales
           summary = self._calculate_summary(metrics)

           # Crear reporte
           report = GeneratedReport.objects.create(
               created_by=user,
               report_type='daily_summary',
               report_date=date,
               data=summary,
               status='COMPLETED'
           )

           # Auditar
           UserActionLog.record(
               user_id=user.id,
               action='REPORT_GENERATE',
               resource=f'report:{report.id}',
               result='SUCCESS'
           )

           logger.info(
               f'Reporte generado: ID={report.id}, '
               f'User={user.username}, Date={date}'
           )

           return report

       def _validate_report_request(self, date, queue_ids):
           """Validar parámetros del reporte."""
           if date > timezone.now().date():
               raise ValueError('No se pueden generar reportes de fechas futuras')

           if not queue_ids:
               raise ValueError('Debe especificar al menos una cola')

           if len(queue_ids) > 50:
               raise ValueError('Máximo 50 colas por reporte')

       def _gather_metrics(self, date, queue_ids):
           """Obtener métricas de todas las colas."""
           metrics = []
           for queue_id in queue_ids:
               queue_metrics = self.metrics_repo.get_queue_metrics(
                   queue_id, date, date
               )
               metrics.extend(queue_metrics)
           return metrics

       def _calculate_summary(self, metrics):
           """Calcular resumen de métricas."""
           total_calls = sum(m.total_calls for m in metrics)
           completed = sum(m.completed_calls for m in metrics)
           abandoned = sum(m.abandoned_calls for m in metrics)

           return {
               'total_calls': total_calls,
               'completed_calls': completed,
               'abandoned_calls': abandoned,
               'completion_rate': completed / total_calls if total_calls else 0,
               'abandon_rate': abandoned / total_calls if total_calls else 0
           }


   # Uso en vistas
   from apps.reports.services import ReportService

   class DailyMetricsReportView(APIView):
       def __init__(self):
           self.report_service = ReportService()

       def post(self, request):
           report = self.report_service.generate_daily_report(
               user=request.user,
               date=request.data['date'],
               queue_ids=request.data['queue_ids']
           )
           return Response({'report_id': report.id})

Patrón 3: Factory Pattern
~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Crear objetos sin exponer la lógica de creación, delegando a subclases o métodos factory.

Cuándo Usar
^^^^^^^^^^^

- Múltiples tipos de objetos relacionados
- Lógica de creación compleja
- Necesidad de extensibilidad

Implementación
^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/reports/factories.py

   from abc import ABC, abstractmethod
   from apps.reports.exporters import CSVExporter, ExcelExporter, PDFExporter

   class ReportExporterFactory:
                               
       Factory para crear exportadores de reportes.

       Centraliza la creación de exportadores según formato.
                                                            

       _exporters = {
           'csv': CSVExporter,
           'excel': ExcelExporter,
           'pdf': PDFExporter,
       }

       @classmethod
       def create_exporter(cls, format_type):
                                             
           Crear exportador según formato.

           Args:
               format_type: 'csv', 'excel' o 'pdf'

           Returns:
               Instancia de exportador

           Raises:
               ValueError: Si formato no soportado
                                                  
           exporter_class = cls._exporters.get(format_type.lower())

           if not exporter_class:
               raise ValueError(
                   f'Formato no soportado: {format_type}. '
                   f'Formatos válidos: {list(cls._exporters.keys())}'
               )

           return exporter_class()

       @classmethod
       def register_exporter(cls, format_type, exporter_class):
           """Registrar nuevo exportador (extensibilidad)."""
           cls._exporters[format_type.lower()] = exporter_class

       @classmethod
       def get_supported_formats(cls):
           """Obtener formatos soportados."""
           return list(cls._exporters.keys())


   # Base para exportadores
   class BaseExporter(ABC):
       """Clase base para exportadores."""

       @abstractmethod
       def export(self, data):
           """Exportar datos al formato específico."""
           pass

       @abstractmethod
       def get_content_type(self):
           """Obtener content type HTTP."""
           pass


   # Implementaciones
   class CSVExporter(BaseExporter):
       def export(self, data):
           # Lógica CSV
           pass

       def get_content_type(self):
           return 'text/csv'


   # Uso
   from apps.reports.factories import ReportExporterFactory

   class CSVExportView(APIView):
       def post(self, request):
           format_type = request.data.get('format', 'csv')

           # Factory crea el exportador apropiado
           exporter = ReportExporterFactory.create_exporter(format_type)

           data = self._get_report_data()
           content = exporter.export(data)

           return Response(
               content,
               content_type=exporter.get_content_type()
           )

Patrón 4: Strategy Pattern
~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Definir familia de algoritmos intercambiables que pueden seleccionarse en tiempo de ejecución.

Cuándo Usar
^^^^^^^^^^^

- Múltiples algoritmos para misma tarea
- Necesidad de cambiar comportamiento dinámicamente
- Evitar condicionales complejos

Implementación
^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/analytics/aggregators.py

   from abc import ABC, abstractmethod
   from django.db.models import Sum, Avg, Count, Max, Min

   class AggregationStrategy(ABC):
       """Estrategia base de agregación."""

       @abstractmethod
       def aggregate(self, queryset):
           """Aplicar agregación al queryset."""
           pass

       @abstractmethod
       def get_name(self):
           """Nombre de la estrategia."""
           pass


   class HourlyAggregation(AggregationStrategy):
       """Agregación por hora."""

       def aggregate(self, queryset):
           return queryset.extra(
               select={'hour': "EXTRACT(hour FROM call_date)"}
           ).values('hour').annotate(
               total=Count('id'),
               avg_duration=Avg('duration')
           )

       def get_name(self):
           return 'hourly'


   class DailyAggregation(AggregationStrategy):
       """Agregación por día."""

       def aggregate(self, queryset):
           return queryset.extra(
               select={'day': "DATE(call_date)"}
           ).values('day').annotate(
               total=Count('id'),
               completed=Sum('completed'),
               avg_duration=Avg('duration')
           )

       def get_name(self):
           return 'daily'


   class QueueAggregation(AggregationStrategy):
       """Agregación por cola."""

       def aggregate(self, queryset):
           return queryset.values('queue_id').annotate(
               total=Count('id'),
               completed=Sum('completed'),
               abandoned=Sum('abandoned'),
               avg_wait=Avg('wait_time')
           )

       def get_name(self):
           return 'by_queue'


   class MetricsAggregator:
                           
       Contexto que usa estrategias de agregación.

       Permite cambiar estrategia dinámicamente.
                                                

       def __init__(self, strategy: AggregationStrategy):
           self.strategy = strategy

       def set_strategy(self, strategy: AggregationStrategy):
           """Cambiar estrategia de agregación."""
           self.strategy = strategy

       def aggregate_metrics(self, queryset):
           """Aplicar estrategia actual."""
           return self.strategy.aggregate(queryset)


   # Uso
   from apps.analytics.aggregators import (
       MetricsAggregator, HourlyAggregation, DailyAggregation
   )

   class CallAnalyticsView(APIView):
       def get(self, request):
           aggregation_type = request.query_params.get('aggregate_by', 'daily')

           # Seleccionar estrategia según parámetro
           strategies = {
               'hourly': HourlyAggregation(),
               'daily': DailyAggregation(),
               'queue': QueueAggregation(),
           }

           strategy = strategies.get(aggregation_type, DailyAggregation())
           aggregator = MetricsAggregator(strategy)

           queryset = IVRCall.objects.filter(
               call_date__range=[start_date, end_date]
           )

           results = aggregator.aggregate_metrics(queryset)

           return Response({
               'aggregation': strategy.get_name(),
               'data': results
           })

Patrón 5: Decorator Pattern
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Añadir funcionalidad a objetos dinámicamente sin modificar su estructura.

Cuándo Usar
^^^^^^^^^^^

- Añadir responsabilidades opcionales
- Evitar jerarquías de herencia complejas
- Combinar comportamientos

Implementación
^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/common/decorators.py

   from functools import wraps
   from django.core.cache import cache
   from apps.common.audit import UserActionLog
   import logging
   import time

   logger = logging.getLogger('api')

   def cached_response(timeout=300):
                                    
       Decorador para cachear respuestas de vistas.

       Args:
           timeout: Tiempo en segundos (default: 5 min)
                                                       
       def decorator(view_func):
           @wraps(view_func)
           def wrapper(self, request, *args, **kwargs):
               # Generar cache key
               cache_key = f'view_{view_func.__name__}_{request.GET.urlencode()}'

               # Intentar obtener de caché
               cached = cache.get(cache_key)
               if cached:
                   logger.debug(f'Cache hit: {cache_key}')
                   return cached

               # Ejecutar vista
               response = view_func(self, request, *args, **kwargs)

               # Guardar en caché
               cache.set(cache_key, response, timeout)
               logger.debug(f'Cache set: {cache_key}')

               return response
           return wrapper
       return decorator


   def audit_action(action_type):
                                 
       Decorador para auditar acciones.

       Args:
           action_type: Tipo de acción (ej: 'REPORT_GENERATE')
                                                              
       def decorator(view_func):
           @wraps(view_func)
           def wrapper(self, request, *args, **kwargs):
               start_time = time.time()
               result = 'SUCCESS'

               try:
                   response = view_func(self, request, *args, **kwargs)
                   return response
               except Exception as e:
                   result = 'FAILURE'
                   raise
               finally:
                   duration = time.time() - start_time

                   UserActionLog.record(
                       user_id=request.user.id,
                       action=action_type,
                       resource=request.path,
                       result=result,
                       details={
                           'duration_ms': int(duration * 1000),
                           'method': request.method
                       }
                   )
           return wrapper
       return decorator


   def measure_performance(view_func):
       """Decorador para medir rendimiento de vistas."""
       @wraps(view_func)
       def wrapper(self, request, *args, **kwargs):
           start = time.time()

           response = view_func(self, request, *args, **kwargs)

           duration = time.time() - start

           if duration > 1.0:  # Slow query warning
               logger.warning(
                   f'Slow view: {view_func.__name__} took {duration:.2f}s'
               )

           # Añadir header de rendimiento
           response['X-Response-Time'] = f'{duration:.3f}s'

           return response
       return wrapper


   # Uso combinado (composición de decoradores)
   class DailyMetricsReportView(APIView):
       @cached_response(timeout=600)
       @audit_action('REPORT_VIEW')
       @measure_performance
       def get(self, request):
           # Lógica del reporte
           pass

Patrón 6: Observer Pattern (Signals)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Descripción
^^^^^^^^^^^

Notificar múltiples objetos cuando cambia el estado de un objeto, usando Django signals.

Cuándo Usar
^^^^^^^^^^^

- Desacoplar componentes que reaccionan a eventos
- Múltiples acciones al guardar/actualizar modelo
- Auditoría y logging automático

Implementación
^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/analytics/signals.py

   from django.db.models.signals import post_save, pre_delete
   from django.dispatch import receiver
   from apps.analytics.models import CallMetric
   from apps.reports.models import GeneratedReport
   from apps.common.audit import UserActionLog
   from apps.common.notifications import notify_admins
   import logging

   logger = logging.getLogger('analytics')

   @receiver(post_save, sender=CallMetric)
   def audit_metric_creation(sender, instance, created, **kwargs):
                                                                  
       Auditar creación de métricas.

       Signal ejecutado automáticamente al guardar CallMetric.
                                                              
       if created:
           logger.info(
               f'Nueva métrica creada: Queue={instance.queue_id}, '
               f'Date={instance.metric_date}, Calls={instance.total_calls}'
           )

           # Verificar anomalías
           if instance.total_calls > 10000:  # Umbral alto
               notify_admins(
                   subject='Alto volumen de llamadas detectado',
                   body=f'Cola {instance.queue_id} registró '
                        f'{instance.total_calls} llamadas el {instance.metric_date}',
                   priority='MEDIUM'
               )


   @receiver(post_save, sender=GeneratedReport)
   def notify_report_completion(sender, instance, created, **kwargs):
       """Notificar cuando se completa un reporte."""
       if not created and instance.status == 'COMPLETED':
           logger.info(f'Reporte completado: ID={instance.id}')

           # Notificar al usuario que solicitó el reporte
           from apps.common.models import InternalMessage
           InternalMessage.objects.create(
               recipient=instance.created_by,
               subject='Reporte completado',
               body=f'Tu reporte "{instance.report_type}" está listo.'
           )


   @receiver(pre_delete, sender=CallMetric)
   def prevent_metric_deletion(sender, instance, **kwargs):
                                                           
       Prevenir eliminación de métricas.

       Las métricas son inmutables (CNST-009).
                                              
       raise PermissionError(
           'CNST-009: Las métricas no pueden eliminarse. '
           'Son parte del registro inmutable.'
       )


   # En apps.py - Registrar signals
   class AnalyticsConfig(AppConfig):
       name = 'apps.analytics'

       def ready(self):
           import apps.analytics.signals  # Importar signals


Validación en Desarrollo
------------------------

Pre-commit Checklist
~~~~~~~~~~~~~~~~~~~~

Antes de hacer commit, verificar:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - Ninguna clase supera 300 líneas
   * - [ ]
     - Ninguna función supera 30 líneas
   * - [ ]
     - No hay más de 3 niveles de anidación
   * - [ ]
     - No hay código duplicado (DRY)
   * - [ ]
     - No hay magic numbers/strings
   * - [ ]
     - Configuración en variables de entorno
   * - [ ]
     - Patrones recomendados aplicados cuando corresponde

Code Review Checklist
~~~~~~~~~~~~~~~~~~~~~

Durante code review, rechazar si:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - Se detecta God Class
   * - [ ]
     - Código spaghetti con anidación excesiva
   * - [ ]
     - Código duplicado sin extraer
   * - [ ]
     - Credenciales o URLs hardcoded
   * - [ ]
     - Optimizaciones sin justificación medible
   * - [ ]
     - Lógica de negocio en vistas (usar Service Layer)
   * - [ ]
     - Queries complejas sin Repository Pattern

Script de Validación
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   #!/bin/bash
   # scripts/validate_code_quality.sh

   echo "Validando calidad de código..."

   ERRORS=0

   # Verificar archivos muy largos (posible God Class)
   LONG_FILES=$(find api/apps -name "*.py" -exec wc -l {} \; | awk '$1 > 500 {print $2}')
   if [ -n "$LONG_FILES" ]; then
       echo "WARNING: Archivos con más de 500 líneas:"
       echo "$LONG_FILES"
   fi

   # Buscar credenciales hardcoded
   if grep -r "password\s*=\s*['\"]" api/apps/ --include="*.py" | grep -v "password=None\|password=''\|get_password"; then
       echo "ERROR: Posibles passwords hardcoded"
       ERRORS=$((ERRORS + 1))
   fi

   # Buscar magic numbers en condiciones
   if grep -rE "if.*==\s*[0-9]{2,}" api/apps/ --include="*.py" | grep -v "status_code\|HTTP_"; then
       echo "WARNING: Posibles magic numbers en condiciones"
   fi

   # Verificar que existe constants.py
   if [ ! -f "api/apps/common/constants.py" ]; then
       echo "WARNING: Archivo constants.py no encontrado"
   fi

   # Ejecutar flake8
   flake8 api/apps/ --max-line-length=100 --max-complexity=10

   # Verificar documentación de funciones complejas
   COMPLEX_FUNCS=$(grep -r "def.*(" api/apps/ --include="*.py" -A 20 | grep -B 5 "if.*if.*if" | grep "def " | wc -l)
   if [ $COMPLEX_FUNCS -gt 0 ]; then
       echo "INFO: $COMPLEX_FUNCS funciones complejas encontradas (verificar documentación)"
   fi

   if [ $ERRORS -eq 0 ]; then
       echo "OK: Validación de calidad pasada"
       exit 0
   else
       echo "FALLO: $ERRORS errores de calidad encontrados"
       exit 1
   fi

Herramientas Recomendadas
~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 20 30 50

   * - Herramienta
     - Propósito
     - Configuración
   * - flake8
     - Linting de Python
     - ``max-line-length=100, max-complexity=10``
   * - black
     - Formateo automático
     - ``line-length=100``
   * - pylint
     - Análisis estático
     - ``max-line-length=100``
   * - mypy
     - Type checking
     - ``strict=True``
   * - pytest
     - Testing
     - ``--cov=apps --cov-report=html``
   * - radon
     - Complejidad ciclomática
     - ``cc -s -a``

Métricas de Calidad
~~~~~~~~~~~~~~~~~~~

Umbrales recomendados:

.. list-table::
   :header-rows: 1
   :widths: 30 20 50

   * - Métrica
     - Umbral
     - Descripción
   * - Complejidad Ciclomática
     - < 10
     - Por función
   * - Líneas por Función
     - < 30
     - Funciones concisas
   * - Líneas por Clase
     - < 300
     - Clases enfocadas
   * - Cobertura de Tests
     - > 80%
     - Por módulo
   * - Duplicación de Código
     - < 5%
     - Del total
   * - Deuda Técnica
     - < 5%
     - Ratio vs total código

Referencias
-----------

Documentos Relacionados
~~~~~~~~~~~~~~~~~~~~~~~

- CNST-005: Seguridad Django REST Framework
- CNST-009: Logging y Auditoría Inmutable
- Modelo RBAC IACT v5.1.1 (44 funciones atómicas, 8 módulos)
- Guía de Clean Code (Robert C. Martin)
- Principios SOLID

Implementación de Referencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- ``api/apps/common/permissions.py`` - Permisos centralizados (FunctionPermissions)
- ``api/apps/common/constants.py`` - Constantes del sistema
- ``api/apps/analytics/repositories.py`` - Repository Pattern
- ``api/apps/reports/services.py`` - Service Layer
- ``api/apps/common/decorators.py`` - Decorator Pattern
- ``api/config/settings/`` - Configuración por ambiente

Libros y Recursos
~~~~~~~~~~~~~~~~~

- Clean Code: A Handbook of Agile Software Craftsmanship (Robert C. Martin)
- Refactoring: Improving the Design of Existing Code (Martin Fowler)
- Design Patterns: Elements of Reusable Object-Oriented Software (Gang of Four)
- Patterns of Enterprise Application Architecture (Martin Fowler)
- Django Design Patterns and Best Practices (Arun Ravindran)

Ejemplos de Código
~~~~~~~~~~~~~~~~~~

Todos los ejemplos de este documento están disponibles en:

- ``docs/examples/antipatterns/`` - Ejemplos de antipatrones
- ``docs/examples/patterns/`` - Ejemplos de patrones recomendados
- ``docs/examples/refactoring/`` - Casos de refactorización

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 50 20

   * - Versión
     - Fecha
     - Cambios
     - Autor
   * - 1.1.0
     - 2026-01-03
     - Actualización RBAC v5.1.1. Sección Patrones Recomendados. Clean Code en ejemplos: vistas específicas
     - Equipo IACT
   * - 1.0.0
     - 2025-12-17
     - Versión inicial con 10 antipatrones
     - Equipo IACT

Aprobaciones
------------

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Rol
     - Nombre
     - Firma / Fecha
   * - Tech Lead
     - [Nombre]
     - [Pendiente]
   * - Code Quality Lead
     - [Nombre]
     - [Pendiente]
   * - Arquitecto de Software
     - [Nombre]
     - [Pendiente]

----

**Fin del Documento CNST-006**
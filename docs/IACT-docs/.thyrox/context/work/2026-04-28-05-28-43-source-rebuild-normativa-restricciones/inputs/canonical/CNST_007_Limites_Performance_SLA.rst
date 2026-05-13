CNST-007: Límites de Performance y SLA
======================================

:ID: CNST-007
:Versión: 1.0.1
:Fecha: 2026-01-03
:Estado: VIGENTE
:Clasificación: CRÍTICO - NO NEGOCIABLE
:Origen: Requerimientos de rendimiento del cliente

----

Propósito
---------

Este documento establece los límites de rendimiento, tiempos de respuesta y acuerdos de nivel de servicio (SLA) obligatorios para el Sistema IACT - IVR Analytics & Customer Tracking.

Contexto
--------

Origen de la Restricción
~~~~~~~~~~~~~~~~~~~~~~~~

Requerimientos de rendimiento establecidos por el cliente para garantizar una experiencia de usuario aceptable y operación estable del sistema.

Justificación
~~~~~~~~~~~~~

- Garantizar experiencia de usuario fluida
- Prevenir timeouts y errores por lentitud
- Optimizar uso de recursos del servidor
- Establecer expectativas claras de rendimiento
- Facilitar monitoreo y alertas

Aplicable a
~~~~~~~~~~~

- Todas las APIs REST del sistema
- Dashboard y reportes
- Proceso ETL
- Consultas a base de datos
- Exportaciones de datos

Límites de Tiempo de Respuesta
------------------------------

APIs REST
~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 40 20 20 20

   * - Endpoint
     - Target
     - Máximo
     - Acción si excede
   * - GET (lectura simple)
     - < 200ms
     - 500ms
     - Optimizar query
   * - GET (con filtros)
     - < 500ms
     - 1s
     - Agregar índices
   * - POST/PUT/DELETE
     - < 300ms
     - 1s
     - Revisar lógica
   * - Reportes simples
     - < 2s
     - 5s
     - Paginar/limitar
   * - Reportes complejos
     - < 5s
     - 15s
     - Background job
   * - Exportaciones
     - < 10s
     - 30s
     - Async + notificación

Dashboard
~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 40 20 20 20

   * - Componente
     - Target
     - Máximo
     - Acción si excede
   * - Carga inicial
     - < 2s
     - 5s
     - Lazy loading
   * - Navegación entre vistas
     - < 500ms
     - 1s
     - Caché cliente
   * - Actualización de gráficos
     - < 1s
     - 3s
     - Optimizar queries
   * - Filtrado de datos
     - < 500ms
     - 2s
     - Índices/caché

Proceso ETL
~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 40 20 20 20

   * - Fase
     - Target
     - Máximo
     - Acción si excede
   * - Extracción (por día)
     - < 5min
     - 15min
     - Optimizar query IVR
   * - Transformación
     - < 10min
     - 30min
     - Batch processing
   * - Carga
     - < 5min
     - 15min
     - Bulk insert
   * - ETL completo
     - < 30min
     - 2h
     - Escalar/paralelizar

Límites de Consultas
--------------------

Rangos de Fechas
~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/validators.py

   from datetime import timedelta
   from rest_framework import serializers

   class DateRangeValidator:
                            
       Validador de rangos de fechas.

       Límites CNST-007:
       - Consultas normales: máximo 90 días
       - Exportaciones: máximo 365 días
       - Reportes complejos: máximo 30 días
                                           

       LIMITS = {
           'default': 90,
           'export': 365,
           'complex_report': 30,
           'dashboard': 90,
       }

       def __init__(self, limit_type='default'):
           self.max_days = self.LIMITS.get(limit_type, 90)

       def __call__(self, data):
           start_date = data.get('start_date')
           end_date = data.get('end_date')

           if start_date and end_date:
               delta = (end_date - start_date).days

               if delta > self.max_days:
                   raise serializers.ValidationError({
                       'date_range': f'Rango máximo permitido: {self.max_days} días. '
                                     f'Solicitado: {delta} días.'
                   })

           return data

Paginación Obligatoria
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/pagination.py

   from rest_framework.pagination import PageNumberPagination
   from rest_framework.response import Response

   class StandardPagination(PageNumberPagination):
                                                  
       Paginación estándar CNST-007.

       Límites:
       - page_size default: 50
       - page_size máximo: 200
                              

       page_size = 50
       page_size_query_param = 'page_size'
       max_page_size = 200

       def get_paginated_response(self, data):
           return Response({
               'pagination': {
                   'count': self.page.paginator.count,
                   'total_pages': self.page.paginator.num_pages,
                   'current_page': self.page.number,
                   'page_size': self.get_page_size(self.request),
                   'has_next': self.page.has_next(),
                   'has_previous': self.page.has_previous(),
               },
               'results': data
           })


   class ExportPagination(PageNumberPagination):
                                                
       Paginación para exportaciones CNST-007.

       Límites más amplios para exportaciones:
       - page_size default: 1000
       - page_size máximo: 5000
                               

       page_size = 1000
       page_size_query_param = 'page_size'
       max_page_size = 5000

Límites de Records
~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/constants.py

   class QueryLimits:
                     
       Límites de consultas CNST-007.

       Estos límites previenen queries que degraden el sistema.
                                                               

       # Máximo de registros por consulta
       MAX_RECORDS_DEFAULT = 10000
       MAX_RECORDS_EXPORT = 100000
       MAX_RECORDS_REPORT = 50000

       # Máximo de IDs en filtro IN
       MAX_IDS_IN_FILTER = 100

       # Timeout de queries (segundos)
       QUERY_TIMEOUT_DEFAULT = 30
       QUERY_TIMEOUT_REPORT = 120
       QUERY_TIMEOUT_EXPORT = 300

       # Límites de agregación
       MAX_GROUP_BY_COLUMNS = 5
       MAX_DISTINCT_VALUES = 1000

Implementación de Límites
-------------------------

Middleware de Timeout
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/middleware.py

   import time
   import logging
   from django.http import JsonResponse

   logger = logging.getLogger('performance')

   class RequestTimeoutMiddleware:
                                  
       Middleware que monitorea tiempo de respuesta.

       CNST-007: Log de requests lentos y timeout.
                                                  

       # Umbrales en segundos
       SLOW_REQUEST_THRESHOLD = 2.0
       VERY_SLOW_THRESHOLD = 5.0

       def __init__(self, get_response):
           self.get_response = get_response

       def __call__(self, request):
           start_time = time.time()

           response = self.get_response(request)

           duration = time.time() - start_time

           # Log de requests lentos
           if duration > self.VERY_SLOW_THRESHOLD:
               logger.warning(
                   f'VERY SLOW REQUEST: {duration:.2f}s - '
                   f'{request.method} {request.path} - '
                   f'User: {getattr(request.user, "username", "anonymous")}'
               )
           elif duration > self.SLOW_REQUEST_THRESHOLD:
               logger.info(
                   f'Slow request: {duration:.2f}s - '
                   f'{request.method} {request.path}'
               )

           # Header con tiempo de respuesta
           response['X-Response-Time'] = f'{duration:.3f}s'

           return response


   class QueryCountMiddleware:
                              
       Middleware que cuenta queries por request.

       CNST-007: Detectar N+1 queries.
                                      

       QUERY_WARNING_THRESHOLD = 10
       QUERY_ERROR_THRESHOLD = 50

       def __init__(self, get_response):
           self.get_response = get_response

       def __call__(self, request):
           from django.db import connection

           initial_queries = len(connection.queries)

           response = self.get_response(request)

           total_queries = len(connection.queries) - initial_queries

           if total_queries > self.QUERY_ERROR_THRESHOLD:
               logger.error(
                   f'EXCESSIVE QUERIES: {total_queries} - '
                   f'{request.method} {request.path}'
               )
           elif total_queries > self.QUERY_WARNING_THRESHOLD:
               logger.warning(
                   f'High query count: {total_queries} - '
                   f'{request.method} {request.path}'
               )

           response['X-Query-Count'] = str(total_queries)

           return response

Decorador de Timeout
~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/common/decorators.py

   import functools
   import signal
   import logging
   from django.http import JsonResponse

   logger = logging.getLogger('performance')

   class TimeoutError(Exception):
       pass


   def timeout(seconds):
                        
       Decorador para limitar tiempo de ejecución.

       CNST-007: Timeout obligatorio en operaciones costosas.

       Uso:
           @timeout(30)
           def generate_report(request):
               # Operación costosa
               pass
                   
       def decorator(func):
           @functools.wraps(func)
           def wrapper(*args, **kwargs):
               def handler(signum, frame):
                   raise TimeoutError(
                       f'Operación excedió timeout de {seconds}s'
                   )

               # Configurar alarma
               old_handler = signal.signal(signal.SIGALRM, handler)
               signal.alarm(seconds)

               try:
                   result = func(*args, **kwargs)
               except TimeoutError as e:
                   logger.error(f'Timeout en {func.__name__}: {e}')
                   return JsonResponse(
                       {
                           'error': 'Timeout',
                           'message': f'La operación excedió el límite de {seconds} segundos',
                           'code': 'TIMEOUT'
                       },
                       status=504
                   )
               finally:
                   signal.alarm(0)
                   signal.signal(signal.SIGALRM, old_handler)

               return result
           return wrapper
       return decorator

Optimización de Queries
-----------------------

Select Related y Prefetch
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/analytics/repositories.py

   from apps.analytics.models import CallMetric
   from django.db.models import Sum, Avg, Count, F

   class MetricsRepository:
                           
       Repositorio de métricas optimizado.

       CNST-007: Queries optimizados para cumplir SLA.
                                                      

       @staticmethod
       def get_summary(start_date, end_date, queue_ids=None):
                                                             
           Obtener resumen de métricas.

           Query optimizado con agregación en BD.
           Target: < 500ms
                          
           queryset = CallMetric.objects.filter(
               metric_date__range=[start_date, end_date]
           )

           if queue_ids:
               queryset = queryset.filter(queue_id__in=queue_ids[:100])

           return queryset.aggregate(
               total_calls=Sum('total_calls'),
               completed_calls=Sum('completed_calls'),
               abandoned_calls=Sum('abandoned_calls'),
               avg_duration=Avg('avg_duration'),
               avg_wait_time=Avg('avg_wait_time')
           )

       @staticmethod
       def get_daily_breakdown(start_date, end_date, queue_ids=None):
                                                                     
           Obtener desglose diario.

           Usa values() para evitar instanciar objetos.
           Target: < 1s
                       
           queryset = CallMetric.objects.filter(
               metric_date__range=[start_date, end_date]
           )

           if queue_ids:
               queryset = queryset.filter(queue_id__in=queue_ids[:100])

           return queryset.values('metric_date').annotate(
               total=Sum('total_calls'),
               completed=Sum('completed_calls'),
               abandoned=Sum('abandoned_calls'),
               avg_duration=Avg('avg_duration')
           ).order_by('metric_date')

       @staticmethod
       def get_queue_ranking(start_date, end_date, limit=20):
                                                             
           Ranking de colas por volumen.

           Limita resultados para performance.
           Target: < 500ms
                          
           return CallMetric.objects.filter(
               metric_date__range=[start_date, end_date]
           ).values('queue_id').annotate(
               total=Sum('total_calls'),
               completion_rate=Sum('completed_calls') * 100.0 / Sum('total_calls')
           ).order_by('-total')[:limit]

Índices Recomendados
~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/analytics/models.py

   from django.db import models

   class CallMetric(models.Model):
                                  
       Métricas de llamadas.

       Índices optimizados para consultas CNST-007.
                                                   

       metric_date = models.DateField()
       queue_id = models.IntegerField()
       total_calls = models.IntegerField(default=0)
       completed_calls = models.IntegerField(default=0)
       abandoned_calls = models.IntegerField(default=0)
       avg_duration = models.DecimalField(max_digits=10, decimal_places=2)
       avg_wait_time = models.DecimalField(max_digits=10, decimal_places=2)
       created_at = models.DateTimeField(auto_now_add=True)

       class Meta:
           db_table = 'call_metrics'

           # Índices para queries frecuentes
           indexes = [
               # Índice principal: búsqueda por fecha
               models.Index(
                   fields=['metric_date'],
                   name='idx_metrics_date'
               ),
               # Índice compuesto: fecha + cola
               models.Index(
                   fields=['metric_date', 'queue_id'],
                   name='idx_metrics_date_queue'
               ),
               # Índice para rankings
               models.Index(
                   fields=['queue_id', 'total_calls'],
                   name='idx_metrics_queue_total'
               ),
           ]

           # Constraint de unicidad
           constraints = [
               models.UniqueConstraint(
                   fields=['metric_date', 'queue_id'],
                   name='unique_metric_date_queue'
               )
           ]

Exportaciones Asíncronas
------------------------

Sistema de Exportación
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/exports/models.py

   from django.db import models
   from django.contrib.auth import get_user_model

   User = get_user_model()

   class ExportJob(models.Model):
                                 
       Job de exportación asíncrona.

       CNST-007: Exportaciones grandes deben ser asíncronas.
                                                            

       STATUS_CHOICES = [
           ('PENDING', 'Pendiente'),
           ('PROCESSING', 'Procesando'),
           ('COMPLETED', 'Completado'),
           ('FAILED', 'Fallido'),
       ]

       FORMAT_CHOICES = [
           ('csv', 'CSV'),
           ('excel', 'Excel'),
           ('json', 'JSON'),
       ]

       user = models.ForeignKey(
           User,
           on_delete=models.CASCADE,
           related_name='export_jobs'
       )
       status = models.CharField(
           max_length=20,
           choices=STATUS_CHOICES,
           default='PENDING'
       )
       export_type = models.CharField(max_length=50)
       format = models.CharField(
           max_length=10,
           choices=FORMAT_CHOICES,
           default='csv'
       )
       parameters = models.JSONField(default=dict)
       file_path = models.CharField(max_length=500, null=True, blank=True)
       file_size = models.BigIntegerField(null=True, blank=True)
       record_count = models.IntegerField(null=True, blank=True)
       error_message = models.TextField(null=True, blank=True)
       created_at = models.DateTimeField(auto_now_add=True)
       started_at = models.DateTimeField(null=True, blank=True)
       completed_at = models.DateTimeField(null=True, blank=True)

       class Meta:
           db_table = 'export_jobs'
           ordering = ['-created_at']

       @property
       def duration_seconds(self):
           if self.started_at and self.completed_at:
               return (self.completed_at - self.started_at).total_seconds()
           return None

Servicio de Exportación
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/exports/services.py

   import csv
   import os
   from datetime import datetime
   from django.conf import settings
   from django.utils import timezone
   from apps.exports.models import ExportJob
   from apps.analytics.repositories import MetricsRepository
   from apps.common.notifications import notify
   import logging

   logger = logging.getLogger('exports')

   class ReportExporter:
                        
       Servicio de exportación de reportes.

       CNST-007: Exportaciones asíncronas con límites.
                                                      

       EXPORT_DIR = os.path.join(settings.MEDIA_ROOT, 'exports')
       MAX_RECORDS = 100000

       def __init__(self, job: ExportJob):
           self.job = job
           self.user = job.user

       def execute(self):
           """Ejecutar exportación."""
           self.job.status = 'PROCESSING'
           self.job.started_at = timezone.now()
           self.job.save()

           try:
               # Obtener datos
               data = self._fetch_data()

               if len(data) > self.MAX_RECORDS:
                   raise ValueError(
                       f'Exportación excede límite de {self.MAX_RECORDS} registros'
                   )

               # Generar archivo
               file_path = self._generate_file(data)

               # Actualizar job
               self.job.status = 'COMPLETED'
               self.job.completed_at = timezone.now()
               self.job.file_path = file_path
               self.job.file_size = os.path.getsize(file_path)
               self.job.record_count = len(data)
               self.job.save()

               # Notificar usuario
               notify(
                   recipient=self.user,
                   subject='Exportación completada',
                   body=f'Tu exportación "{self.job.export_type}" está lista. '
                        f'Registros: {len(data)}',
                   priority='NORMAL'
               )

               logger.info(
                   f'Export {self.job.id} completado: {len(data)} registros'
               )

           except Exception as e:
               self.job.status = 'FAILED'
               self.job.completed_at = timezone.now()
               self.job.error_message = str(e)
               self.job.save()

               notify(
                   recipient=self.user,
                   subject='Exportación fallida',
                   body=f'Tu exportación "{self.job.export_type}" falló: {str(e)}',
                   priority='HIGH'
               )

               logger.error(f'Export {self.job.id} falló: {e}')
               raise

       def _fetch_data(self):
           """Obtener datos según parámetros."""
           params = self.job.parameters

           return list(MetricsRepository.get_daily_breakdown(
               start_date=params['start_date'],
               end_date=params['end_date'],
               queue_ids=params.get('queue_ids')
           ))

       def _generate_file(self, data):
           """Generar archivo de exportación."""
           os.makedirs(self.EXPORT_DIR, exist_ok=True)

           timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
           filename = f'export_{self.job.id}_{timestamp}.{self.job.format}'
           file_path = os.path.join(self.EXPORT_DIR, filename)

           if self.job.format == 'csv':
               self._write_csv(file_path, data)
           elif self.job.format == 'excel':
               self._write_excel(file_path, data)
           elif self.job.format == 'json':
               self._write_json(file_path, data)

           return file_path

       def _write_csv(self, file_path, data):
           """Escribir archivo CSV."""
           if not data:
               return

           with open(file_path, 'w', newline='', encoding='utf-8') as f:
               writer = csv.DictWriter(f, fieldnames=data[0].keys())
               writer.writeheader()
               writer.writerows(data)

       def _write_excel(self, file_path, data):
           """Escribir archivo Excel."""
           import openpyxl

           wb = openpyxl.Workbook()
           ws = wb.active

           if data:
               # Headers
               headers = list(data[0].keys())
               ws.append(headers)

               # Data
               for row in data:
                   ws.append([row.get(h) for h in headers])

           wb.save(file_path)

       def _write_json(self, file_path, data):
           """Escribir archivo JSON."""
           import json

           with open(file_path, 'w', encoding='utf-8') as f:
               json.dump(data, f, indent=2, default=str)

Monitoreo de Performance
------------------------

Métricas de Sistema
~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/monitoring/metrics.py

   from django.db import connection
   from django.core.cache import cache
   from django.utils import timezone
   import psutil
   import logging

   logger = logging.getLogger('monitoring')

   class SystemMetrics:
                                                   
       Métricas de sistema para monitoreo CNST-007.
                                                   

       @staticmethod
       def get_database_stats():
           """Estadísticas de base de datos."""
           with connection.cursor() as cursor:
               # Conexiones activas (PostgreSQL)
               cursor.execute("""
                   SELECT count(*)
                   FROM pg_stat_activity
                   WHERE state = 'active'
               """)
               active_connections = cursor.fetchone()[0]

               # Tamaño de BD
               cursor.execute("""
                   SELECT pg_database_size(current_database())
               """)
               db_size = cursor.fetchone()[0]

           return {
               'active_connections': active_connections,
               'database_size_mb': db_size / (1024 * 1024)
           }

       @staticmethod
       def get_server_stats():
           """Estadísticas del servidor."""
           return {
               'cpu_percent': psutil.cpu_percent(interval=1),
               'memory_percent': psutil.virtual_memory().percent,
               'disk_percent': psutil.disk_usage('/').percent
           }

       @staticmethod
       def get_api_stats():
           """Estadísticas de API desde caché."""
           return {
               'requests_last_hour': cache.get('api_requests_hour', 0),
               'avg_response_time': cache.get('api_avg_response', 0),
               'error_rate': cache.get('api_error_rate', 0)
           }


   class PerformanceAlert:
                                       
       Alertas de performance CNST-007.
                                       

       THRESHOLDS = {
           'cpu_percent': 80,
           'memory_percent': 85,
           'disk_percent': 90,
           'avg_response_time': 2.0,
           'error_rate': 5.0,
       }

       @classmethod
       def check_all(cls):
           """Verificar todas las métricas."""
           alerts = []

           server = SystemMetrics.get_server_stats()
           api = SystemMetrics.get_api_stats()

           if server['cpu_percent'] > cls.THRESHOLDS['cpu_percent']:
               alerts.append(f"CPU alto: {server['cpu_percent']}%")

           if server['memory_percent'] > cls.THRESHOLDS['memory_percent']:
               alerts.append(f"Memoria alta: {server['memory_percent']}%")

           if server['disk_percent'] > cls.THRESHOLDS['disk_percent']:
               alerts.append(f"Disco alto: {server['disk_percent']}%")

           if api['avg_response_time'] > cls.THRESHOLDS['avg_response_time']:
               alerts.append(f"Respuesta lenta: {api['avg_response_time']}s")

           if api['error_rate'] > cls.THRESHOLDS['error_rate']:
               alerts.append(f"Errores altos: {api['error_rate']}%")

           return alerts

Vista de Health Check
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/monitoring/views.py

   from rest_framework.views import APIView
   from rest_framework.response import Response
   from rest_framework.permissions import IsAuthenticated
   from apps.common.permissions import IsAdminUser
   from apps.monitoring.metrics import SystemMetrics, PerformanceAlert

   class HealthCheckView(APIView):
                                  
       Health check del sistema.

       GET /api/v1/health/
                          

       permission_classes = []  # Público para load balancers

       def get(self, request):
           return Response({
               'status': 'healthy',
               'timestamp': timezone.now().isoformat()
           })


   class PerformanceView(APIView):
                                  
       Métricas de performance (solo admin).

       GET /api/v1/performance/
                               

       permission_classes = [IsAuthenticated, IsAdminUser]

       def get(self, request):
           return Response({
               'server': SystemMetrics.get_server_stats(),
               'database': SystemMetrics.get_database_stats(),
               'api': SystemMetrics.get_api_stats(),
               'alerts': PerformanceAlert.check_all()
           })

Validación en Desarrollo
------------------------

Pre-commit Checklist
~~~~~~~~~~~~~~~~~~~~

Antes de hacer commit, verificar:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - Queries usan select_related/prefetch_related
   * - [ ]
     - Endpoints tienen paginación
   * - [ ]
     - Rangos de fecha validados (máx 90 días)
   * - [ ]
     - Exportaciones grandes son asíncronas
   * - [ ]
     - Índices definidos para queries frecuentes

Code Review Checklist
~~~~~~~~~~~~~~~~~~~~~

Durante code review, rechazar si:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - Query sin límite puede retornar millones de registros
   * - [ ]
     - N+1 queries detectados
   * - [ ]
     - Endpoint lento sin optimización
   * - [ ]
     - Exportación síncrona de más de 10k registros

Script de Validación
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   #!/bin/bash
   # scripts/validate_performance.sh

   echo "Validando configuración de performance..."

   ERRORS=0

   # Verificar paginación en settings
   if ! grep -q "DEFAULT_PAGINATION_CLASS" api/config/settings/base.py; then
       echo "ERROR: Paginación no configurada"
       ERRORS=$((ERRORS + 1))
   fi

   # Buscar queries sin límite
   if grep -r "\.all()" api/apps/ --include="*.py" | grep -v "test\|migration"; then
       echo "WARNING: Posibles queries sin límite (.all())"
   fi

   # Verificar índices en modelos
   if ! grep -q "indexes\s*=" api/apps/analytics/models.py; then
       echo "WARNING: Modelo CallMetric sin índices definidos"
   fi

   if [ $ERRORS -eq 0 ]; then
       echo "OK: Configuración de performance correcta"
       exit 0
   else
       echo "FALLO: $ERRORS errores de performance encontrados"
       exit 1
   fi

Referencias
-----------

Documentos Relacionados
~~~~~~~~~~~~~~~~~~~~~~~

- CNST-004: Actualización de Datos mediante ETL
- CNST-005: Seguridad Django REST Framework
- CNST-009: Logging y Auditoría Inmutable

Implementación de Referencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- ``api/apps/common/pagination.py`` - Paginadores
- ``api/apps/common/validators.py`` - Validadores de límites
- ``api/apps/analytics/repositories.py`` - Queries optimizados
- ``api/apps/exports/services.py`` - Exportaciones asíncronas
- ``api/apps/monitoring/metrics.py`` - Métricas de sistema

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
     - Versión inicial con límites SLA
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
   * - DBA
     - [Nombre]
     - [Pendiente]

----

**Fin del Documento CNST-007**
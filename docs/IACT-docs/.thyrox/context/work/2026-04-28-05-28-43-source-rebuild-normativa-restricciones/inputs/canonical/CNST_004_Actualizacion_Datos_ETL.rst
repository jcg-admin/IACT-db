CNST-004: Actualización de Datos mediante ETL
=============================================

:ID: CNST-004
:Versión: 1.0.1
:Fecha: 2026-01-03
:Estado: VIGENTE
:Clasificación: CRÍTICO - NO NEGOCIABLE
:Origen: Restricción del cliente

----

Propósito
---------

Este documento establece el mecanismo obligatorio de actualización de datos mediante proceso ETL programado en el Sistema IACT - IVR Analytics & Customer Tracking, prohibiendo cualquier forma de sincronización en tiempo real.

Contexto
--------

Origen de la Restricción
~~~~~~~~~~~~~~~~~~~~~~~~

Restricción de arquitectura impuesta por el cliente. Los datos del dashboard NO se actualizan en tiempo real. La sincronización se realiza mediante proceso ETL batch cada 6-12 horas.

Justificación del Cliente
~~~~~~~~~~~~~~~~~~~~~~~~~

- Minimizar carga en base de datos IVR legacy
- Evitar impacto en operación del call center
- Control de ventanas de mantenimiento
- Predictibilidad de uso de recursos
- Datos históricos y analíticos no requieren tiempo real

Aplicable a
~~~~~~~~~~~

- Sincronización de datos IVR a Analytics
- Todos los dashboards y reportes
- APIs de consulta de métricas
- Todas las fases del ciclo de vida

Restricciones
-------------

Prohibiciones Absolutas
~~~~~~~~~~~~~~~~~~~~~~~

Mecanismos de Tiempo Real Prohibidos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

PROHIBIDO bajo cualquier circunstancia:

- WebSockets para datos en vivo
- Server-Sent Events (SSE)
- Long polling para actualizaciones
- Triggers de base de datos para sincronización
- Change Data Capture (CDC) en tiempo real
- Streaming de datos
- Pub/Sub para notificaciones de cambios

Librerías Prohibidas
^^^^^^^^^^^^^^^^^^^^

Librerías de tiempo real en código:

- ``channels`` (Django Channels para WebSockets)
- ``socketio`` / ``python-socketio``
- ``asyncio`` para streaming de datos IVR
- ``kafka-python`` para streaming
- ``pika`` / RabbitMQ para eventos en tiempo real

Patrones Prohibidos
^^^^^^^^^^^^^^^^^^^

NO se permite:

- Consultas directas a IVR desde el frontend
- APIs que consulten IVR en cada request
- Caché que se invalide por eventos de IVR
- Polling frecuente (menos de 1 hora)

Consecuencias de Violación
~~~~~~~~~~~~~~~~~~~~~~~~~~

Consecuencias de violación de esta restricción:

- Rechazo inmediato en code review
- Posible degradación de base IVR del cliente
- Incidente de disponibilidad categoría Crítica
- Re-trabajo completo del módulo afectado

Mecanismo Obligatorio
---------------------

ETL Programado
~~~~~~~~~~~~~~

OBLIGATORIO: Proceso ETL batch ejecutado cada 6-12 horas.

Características:

- Frecuencia: Configurable entre 6 y 12 horas
- Horario recomendado: 02:00, 08:00, 14:00, 20:00
- Ventana de ejecución: Máximo 2 horas
- Reintentos: 3 intentos con backoff exponencial

Flujo ETL
~~~~~~~~~

.. code-block:: text

   ┌─────────────────────────────────────────────────────────────┐
   │                    PROCESO ETL IACT                         │
   │                                                             │
   │  ┌─────────┐    ┌─────────────┐    ┌─────────┐    ┌──────┐ │
   │  │ EXTRACT │───►│  TRANSFORM  │───►│  LOAD   │───►│ LOG  │ │
   │  │         │    │             │    │         │    │      │ │
   │  │ IVR DB  │    │  Agregación │    │Analytics│    │Audit │ │
   │  │ (READ)  │    │  Métricas   │    │  (WRITE)│    │      │ │
   │  └─────────┘    └─────────────┘    └─────────┘    └──────┘ │
   │       │                                               │     │
   │       │              6-12 horas                       │     │
   │       └───────────────────────────────────────────────┘     │
   │                                                             │
   └─────────────────────────────────────────────────────────────┘
   
   Scheduler: APScheduler (BackgroundScheduler)
   Trigger: CronTrigger cada 6 horas
   Retry: 3 intentos con exponential backoff

Configuración del Scheduler
---------------------------

APScheduler Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/etl/scheduler.py
   
   from apscheduler.schedulers.background import BackgroundScheduler
   from apscheduler.triggers.cron import CronTrigger
   from apscheduler.jobstores.sqlalchemy import SQLAlchemyJobStore
   from apscheduler.executors.pool import ThreadPoolExecutor
   from django.conf import settings
   import logging
   
   logger = logging.getLogger('etl')
   
   # Configuración del scheduler
   jobstores = {
       'default': SQLAlchemyJobStore(
           url=f"postgresql://{settings.DATABASES['default']['USER']}:"
               f"{settings.DATABASES['default']['PASSWORD']}@"
               f"{settings.DATABASES['default']['HOST']}:"
               f"{settings.DATABASES['default']['PORT']}/"
               f"{settings.DATABASES['default']['NAME']}"
       )
   }
   
   executors = {
       'default': ThreadPoolExecutor(max_workers=1)  # Un ETL a la vez
   }
   
   job_defaults = {
       'coalesce': True,      # Combinar ejecuciones perdidas
       'max_instances': 1,    # Solo una instancia simultánea
       'misfire_grace_time': 3600  # 1 hora de gracia
   }
   
   scheduler = BackgroundScheduler(
       jobstores=jobstores,
       executors=executors,
       job_defaults=job_defaults,
       timezone='America/Mexico_City'
   )


   def start_scheduler():
                         
       Iniciar scheduler con jobs ETL.
       
       CNST-004: ETL cada 6 horas (4 veces al día).
                                                   
       from apps.etl.tasks import run_etl_pipeline
       
       # Job principal: ETL cada 6 horas
       scheduler.add_job(
           run_etl_pipeline,
           trigger=CronTrigger(hour='2,8,14,20', minute=0),
           id='etl_pipeline_main',
           name='ETL Pipeline Principal',
           replace_existing=True
       )
       
       scheduler.start()
       logger.info('Scheduler ETL iniciado - Ejecución cada 6 horas')


   def stop_scheduler():
       """Detener scheduler."""
       scheduler.shutdown(wait=True)
       logger.info('Scheduler ETL detenido')

Integración con Django
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/etl/apps.py
   
   from django.apps import AppConfig
   import logging
   
   logger = logging.getLogger('etl')
   
   class ETLConfig(AppConfig):
       name = 'apps.etl'
       verbose_name = 'ETL Pipeline'
       
       def ready(self):
           """Iniciar scheduler al cargar la app."""
           import os
           
           # Solo iniciar en proceso principal (no en migrations, shell, etc.)
           if os.environ.get('RUN_MAIN') == 'true':
               from apps.etl.scheduler import start_scheduler
               
               try:
                   start_scheduler()
                   logger.info('ETL Scheduler iniciado correctamente')
               except Exception as e:
                   logger.error(f'Error iniciando ETL Scheduler: {e}')

Pipeline ETL Completo
---------------------

Orquestador del Pipeline
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/etl/tasks.py
   
   from datetime import datetime, timedelta
   from django.db import transaction
   from django.utils import timezone
   from apps.etl.extractors import IVRDataExtractor
   from apps.etl.transformers import CallMetricsTransformer
   from apps.etl.loaders import AnalyticsLoader
   from apps.etl.models import ETLExecution
   from apps.common.notifications import notify_admins
   import logging
   import time
   
   logger = logging.getLogger('etl')
   
   class ETLPipeline:
                     
       Pipeline ETL completo para sincronización IVR -> Analytics.
       
       CNST-003: Solo lectura de IVR.
       CNST-004: Ejecución programada cada 6-12 horas.
       
       Fases:
       1. EXTRACT: Leer datos de IVR (solo SELECT)
       2. TRANSFORM: Agregar en métricas
       3. LOAD: Guardar en Analytics
       4. LOG: Registrar ejecución
                                  
       
       MAX_RETRIES = 3
       RETRY_DELAY_BASE = 60  # segundos
       
       def __init__(self):
           self.extractor = IVRDataExtractor()
           self.transformer = CallMetricsTransformer()
           self.loader = AnalyticsLoader()
           self.execution = None
       
       def run(self, start_date=None, end_date=None):
                                                     
           Ejecutar pipeline ETL completo.
           
           Args:
               start_date: Fecha inicio (default: última ejecución)
               end_date: Fecha fin (default: ahora)
           
           Returns:
               ETLExecution con resultado
                                         
           # Crear registro de ejecución
           self.execution = ETLExecution.objects.create(
               status='RUNNING',
               started_at=timezone.now()
           )
           
           try:
               # Determinar rango de fechas
               if not start_date:
                   start_date = self._get_last_execution_date()
               if not end_date:
                   end_date = timezone.now()
               
               logger.info(
                   f'ETL iniciado: {start_date} a {end_date}'
               )
               
               # EXTRACT
               calls = self._extract_with_retry(start_date, end_date)
               
               if not calls:
                   self._complete_execution('SUCCESS', 0, 0, 0)
                   return self.execution
               
               # TRANSFORM
               metrics = self.transformer.transform(calls)
               
               # LOAD
               inserted, updated = self.loader.load(metrics)
               
               # Completar ejecución exitosa
               self._complete_execution(
                   'SUCCESS',
                   len(calls),
                   inserted,
                   updated
               )
               
               logger.info(
                   f'ETL completado: {len(calls)} llamadas, '
                   f'{inserted} insertadas, {updated} actualizadas'
               )
               
               return self.execution
               
           except Exception as e:
               self._complete_execution('FAILED', error=str(e))
               logger.error(f'ETL falló: {e}')
               
               # Notificar a administradores
               notify_admins(
                   subject='ETL Falló',
                   body=f'Error en ETL: {str(e)}\n'
                        f'Ejecución ID: {self.execution.id}',
                   priority='HIGH'
               )
               
               raise
       
       def _extract_with_retry(self, start_date, end_date):
           """Extraer datos con reintentos."""
           last_error = None
           
           for attempt in range(1, self.MAX_RETRIES + 1):
               try:
                   return self.extractor.extract_calls(start_date, end_date)
               except Exception as e:
                   last_error = e
                   delay = self.RETRY_DELAY_BASE * (2 ** (attempt - 1))
                   
                   logger.warning(
                       f'Extracción falló (intento {attempt}/{self.MAX_RETRIES}): {e}. '
                       f'Reintentando en {delay}s'
                   )
                   
                   if attempt < self.MAX_RETRIES:
                       time.sleep(delay)
           
           raise last_error
       
       def _get_last_execution_date(self):
           """Obtener fecha de última ejecución exitosa."""
           last = ETLExecution.objects.filter(
               status='SUCCESS'
           ).order_by('-finished_at').first()
           
           if last and last.finished_at:
               return last.finished_at
           
           # Default: últimas 24 horas
           return timezone.now() - timedelta(hours=24)
       
       def _complete_execution(self, status, records=0, inserted=0, updated=0, error=None):
           """Completar registro de ejecución."""
           self.execution.status = status
           self.execution.finished_at = timezone.now()
           self.execution.records_processed = records
           self.execution.records_inserted = inserted
           self.execution.records_updated = updated
           self.execution.error_message = error
           self.execution.save()


   def run_etl_pipeline():
                          
       Función wrapper para el scheduler.
       
       Esta función es llamada por APScheduler cada 6 horas.
                                                            
       pipeline = ETLPipeline()
       return pipeline.run()

Modelo de Ejecución ETL
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/etl/models.py
   
   from django.db import models
   
   class ETLExecution(models.Model):
                                    
       Registro de ejecuciones ETL.
       
       Almacena historial de todas las ejecuciones del pipeline
       para auditoría y monitoreo.
                                  
       
       STATUS_CHOICES = [
           ('PENDING', 'Pendiente'),
           ('RUNNING', 'Ejecutando'),
           ('SUCCESS', 'Exitoso'),
           ('FAILED', 'Fallido'),
       ]
       
       status = models.CharField(
           max_length=20,
           choices=STATUS_CHOICES,
           default='PENDING'
       )
       started_at = models.DateTimeField(null=True, blank=True)
       finished_at = models.DateTimeField(null=True, blank=True)
       records_processed = models.IntegerField(default=0)
       records_inserted = models.IntegerField(default=0)
       records_updated = models.IntegerField(default=0)
       error_message = models.TextField(null=True, blank=True)
       created_at = models.DateTimeField(auto_now_add=True)
       
       class Meta:
           db_table = 'etl_executions'
           ordering = ['-created_at']
           indexes = [
               models.Index(fields=['status', 'created_at']),
           ]
       
       def __str__(self):
           return f"ETL {self.id} - {self.status} ({self.created_at})"
       
       @property
       def duration_seconds(self):
           """Calcular duración en segundos."""
           if self.started_at and self.finished_at:
               return (self.finished_at - self.started_at).total_seconds()
           return None
       
       @classmethod
       def get_last_successful(cls):
           """Obtener última ejecución exitosa."""
           return cls.objects.filter(status='SUCCESS').order_by('-finished_at').first()

Comando de Ejecución Manual
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/etl/management/commands/run_etl.py
   
   from django.core.management.base import BaseCommand
   from django.utils import timezone
   from datetime import timedelta
   from apps.etl.tasks import ETLPipeline
   import logging
   
   logger = logging.getLogger('etl')
   
   class Command(BaseCommand):
       help = 'Ejecutar pipeline ETL manualmente'
       
       def add_arguments(self, parser):
           parser.add_argument(
               '--hours',
               type=int,
               default=24,
               help='Horas hacia atrás para extraer (default: 24)'
           )
           parser.add_argument(
               '--dry-run',
               action='store_true',
               help='Solo mostrar qué se procesaría'
           )
       
       def handle(self, *args, **options):
           hours = options['hours']
           dry_run = options['dry_run']
           
           end_date = timezone.now()
           start_date = end_date - timedelta(hours=hours)
           
           self.stdout.write(
               f'ETL: Procesando datos de {start_date} a {end_date}'
           )
           
           if dry_run:
               self.stdout.write('Modo DRY-RUN: No se guardarán datos')
               
               from apps.etl.extractors import IVRDataExtractor
               extractor = IVRDataExtractor()
               calls = extractor.extract_calls(start_date, end_date)
               
               self.stdout.write(f'Se procesarían {len(calls)} llamadas')
               return
           
           pipeline = ETLPipeline()
           execution = pipeline.run(start_date, end_date)
           
           if execution.status == 'SUCCESS':
               self.stdout.write(
                   self.style.SUCCESS(
                       f'ETL completado: {execution.records_processed} procesados, '
                       f'{execution.records_inserted} insertados, '
                       f'{execution.records_updated} actualizados'
                   )
               )
           else:
               self.stdout.write(
                   self.style.ERROR(f'ETL falló: {execution.error_message}')
               )

API de Estado ETL
-----------------

Vista de Estado
~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/etl/views.py
   
   from rest_framework.views import APIView
   from rest_framework.response import Response
   from rest_framework.permissions import IsAuthenticated
   from apps.etl.models import ETLExecution
   from django.utils import timezone
   
   class ETLStatusView(APIView):
                                
       Vista de estado del ETL.
       
       Retorna información sobre la última ejecución
       y próxima ejecución programada.
       
       Permissions: Solo usuarios autenticados.
                                               
       
       permission_classes = [IsAuthenticated]
       
       def get(self, request):
           # Última ejecución
           last_execution = ETLExecution.objects.order_by('-created_at').first()
           
           # Última exitosa
           last_success = ETLExecution.get_last_successful()
           
           # Calcular próxima ejecución (cada 6 horas: 2, 8, 14, 20)
           now = timezone.now()
           current_hour = now.hour
           schedule_hours = [2, 8, 14, 20]
           
           next_hour = None
           for h in schedule_hours:
               if h > current_hour:
                   next_hour = h
                   break
           
           if next_hour is None:
               next_hour = schedule_hours[0]
               next_run = now.replace(
                   hour=next_hour, minute=0, second=0, microsecond=0
               ) + timezone.timedelta(days=1)
           else:
               next_run = now.replace(
                   hour=next_hour, minute=0, second=0, microsecond=0
               )
           
           response_data = {
               'last_execution': None,
               'last_successful': None,
               'next_scheduled': next_run.isoformat(),
               'schedule': 'Cada 6 horas (02:00, 08:00, 14:00, 20:00)'
           }
           
           if last_execution:
               response_data['last_execution'] = {
                   'id': last_execution.id,
                   'status': last_execution.status,
                   'started_at': last_execution.started_at.isoformat() if last_execution.started_at else None,
                   'finished_at': last_execution.finished_at.isoformat() if last_execution.finished_at else None,
                   'records_processed': last_execution.records_processed,
                   'duration_seconds': last_execution.duration_seconds
               }
           
           if last_success:
               response_data['last_successful'] = {
                   'id': last_success.id,
                   'finished_at': last_success.finished_at.isoformat() if last_success.finished_at else None,
                   'records_processed': last_success.records_processed
               }
           
           return Response(response_data)


   class ETLHistoryView(APIView):
                                 
       Historial de ejecuciones ETL.
       
       Retorna las últimas N ejecuciones para monitoreo.
                                                        
       
       permission_classes = [IsAuthenticated]
       
       def get(self, request):
           limit = int(request.query_params.get('limit', 10))
           limit = min(limit, 100)  # Máximo 100
           
           executions = ETLExecution.objects.order_by('-created_at')[:limit]
           
           data = [
               {
                   'id': e.id,
                   'status': e.status,
                   'started_at': e.started_at.isoformat() if e.started_at else None,
                   'finished_at': e.finished_at.isoformat() if e.finished_at else None,
                   'records_processed': e.records_processed,
                   'records_inserted': e.records_inserted,
                   'records_updated': e.records_updated,
                   'duration_seconds': e.duration_seconds,
                   'error_message': e.error_message
               }
               for e in executions
           ]
           
           return Response({'executions': data})

URLs de la API ETL
~~~~~~~~~~~~~~~~~~

.. code-block:: python

   # api/apps/etl/urls.py
   
   from django.urls import path
   from apps.etl.views import ETLStatusView, ETLHistoryView
   
   urlpatterns = [
       path('status/', ETLStatusView.as_view(), name='etl-status'),
       path('history/', ETLHistoryView.as_view(), name='etl-history'),
   ]

Validación en Desarrollo
------------------------

Pre-commit Checklist
~~~~~~~~~~~~~~~~~~~~

Antes de hacer commit, verificar:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - NO existe ``channels`` en INSTALLED_APPS
   * - [ ]
     - NO existe WebSocket consumer
   * - [ ]
     - NO existe polling con intervalo < 1 hora
   * - [ ]
     - ETL configurado con APScheduler
   * - [ ]
     - Frecuencia ETL entre 6-12 horas

Code Review Checklist
~~~~~~~~~~~~~~~~~~~~~

Durante code review, rechazar si:

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - [ ]
     - Se implementa WebSocket para datos IVR
   * - [ ]
     - Se hace polling frecuente a IVR
   * - [ ]
     - APIs consultan IVR directamente en cada request
   * - [ ]
     - ETL corre más frecuente que cada 6 horas

Script de Validación
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   #!/bin/bash
   # scripts/validate_no_realtime.sh
   
   echo "Validando que no exista sincronización en tiempo real..."
   
   ERRORS=0
   
   # Buscar Django Channels
   if grep -r "channels" api/config/settings/base.py; then
       echo "ERROR: Encontrado 'channels' en settings"
       ERRORS=$((ERRORS + 1))
   fi
   
   # Buscar WebSocket
   if grep -r "WebSocket\|websocket" api/apps/; then
       echo "ERROR: Encontrada referencia a WebSocket"
       ERRORS=$((ERRORS + 1))
   fi
   
   # Buscar socket.io
   if grep -r "socketio\|socket.io" api/apps/; then
       echo "ERROR: Encontrada referencia a socket.io"
       ERRORS=$((ERRORS + 1))
   fi
   
   # Verificar que APScheduler está configurado
   if ! grep -q "BackgroundScheduler" api/apps/etl/scheduler.py; then
       echo "ERROR: APScheduler no está configurado"
       ERRORS=$((ERRORS + 1))
   fi
   
   if [ $ERRORS -eq 0 ]; then
       echo "OK: No se encontró sincronización en tiempo real"
       exit 0
   else
       echo "FALLO: $ERRORS violaciones de CNST-004 encontradas"
       exit 1
   fi

Monitoreo y Alertas
-------------------

Alertas Automáticas
~~~~~~~~~~~~~~~~~~~

El pipeline notifica automáticamente a administradores cuando:

- ETL falla (cualquier error)
- ETL tarda más de 2 horas
- No hay ejecución exitosa en 24 horas

.. code-block:: python

   # api/apps/etl/monitoring.py
   
   from django.utils import timezone
   from datetime import timedelta
   from apps.etl.models import ETLExecution
   from apps.common.notifications import notify_admins
   import logging
   
   logger = logging.getLogger('etl')
   
   def check_etl_health():
                          
       Verificar salud del proceso ETL.
       
       Llamar periódicamente (cada hora) para detectar problemas.
                                                                 
       now = timezone.now()
       
       # Verificar última ejecución exitosa
       last_success = ETLExecution.get_last_successful()
       
       if not last_success:
           notify_admins(
               subject='ETL: Sin ejecuciones exitosas',
               body='No se encontró ninguna ejecución ETL exitosa.',
               priority='HIGH'
           )
           return
       
       hours_since_success = (now - last_success.finished_at).total_seconds() / 3600
       
       if hours_since_success > 24:
           notify_admins(
               subject='ETL: Sin éxito en 24+ horas',
               body=f'Última ejecución exitosa: {last_success.finished_at}\n'
                    f'Horas transcurridas: {hours_since_success:.1f}',
               priority='HIGH'
           )
       
       # Verificar ejecuciones fallidas recientes
       recent_failures = ETLExecution.objects.filter(
           status='FAILED',
           created_at__gte=now - timedelta(hours=12)
       ).count()
       
       if recent_failures >= 3:
           notify_admins(
               subject='ETL: Múltiples fallos',
               body=f'{recent_failures} ejecuciones fallidas en las últimas 12 horas.',
               priority='HIGH'
           )

Excepciones
-----------

**NO EXISTEN EXCEPCIONES**

Esta restricción NO tiene excepciones.

Ningún módulo puede implementar sincronización en tiempo real con la base IVR.

Si surge un requerimiento de datos "en tiempo real":

1. Explicar que datos se actualizan cada 6 horas
2. Mostrar timestamp de última actualización en UI
3. Ofrecer ejecución manual de ETL (solo administradores)

Alternativas Evaluadas y Rechazadas
-----------------------------------

Alternativa 1: WebSockets
~~~~~~~~~~~~~~~~~~~~~~~~~

**Propuesta:** Usar WebSockets para actualizar dashboard en tiempo real.

**Rechazada porque:**

- Requiere conexión constante a IVR
- Impacta rendimiento de base legacy
- Cliente explícitamente prohibió tiempo real

Alternativa 2: Polling cada 5 minutos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Propuesta:** Hacer polling ligero cada 5 minutos.

**Rechazada porque:**

- Sigue siendo carga constante en IVR
- No cumple con restricción de 6-12 horas
- Riesgo de degradar sistema del cliente

Alternativa 3: CDC (Change Data Capture)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Propuesta:** Usar CDC para capturar cambios en IVR.

**Rechazada porque:**

- Requiere modificar base IVR (prohibido)
- Infraestructura adicional no disponible
- Complejidad innecesaria para el caso de uso

Referencias
-----------

Documentos Relacionados
~~~~~~~~~~~~~~~~~~~~~~~

- RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md
- CNST-003: Base de Datos Dual con Inmutabilidad IVR
- CNST-001: Comunicaciones Prohibidas (notify_admins)

Implementación de Referencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- ``api/apps/etl/scheduler.py`` - Configuración APScheduler
- ``api/apps/etl/tasks.py`` - Pipeline ETL
- ``api/apps/etl/models.py`` - Modelo ETLExecution
- ``api/apps/etl/views.py`` - APIs de estado

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
     - Versión inicial
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

**Fin del Documento CNST-004**

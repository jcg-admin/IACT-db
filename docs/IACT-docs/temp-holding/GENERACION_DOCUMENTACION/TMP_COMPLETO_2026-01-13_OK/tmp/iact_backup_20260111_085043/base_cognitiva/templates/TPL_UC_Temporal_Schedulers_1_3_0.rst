.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-MOD-NN
   :Titulo: Nombre del Use Case Temporal
   :Version: 4.0.0
   :Actor_Principal: Sistema (Scheduler)
   :Tipo: Temporal
   :Fecha: YYYY-MM-DD
   :Autor: Nombre del Business Analyst
   :Estado: DRAFT|REVIEW|APPROVED|IMPLEMENTED

======================================================================
UC-IACT-MOD-NN: Nombre del Use Case Temporal
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Actor Principal:** Sistema (Scheduler/Cron)  
**Tipo:** Temporal  
**Estado:** DRAFT|REVIEW|APPROVED|IMPLEMENTED  
**Prioridad:** Alta|Media|Baja  
**Clasificacion:** C2 - INTERNAL

----------------------------------------------------------------------
INTRODUCCION AL TEMPLATE
----------------------------------------------------------------------

Este template documenta Use Cases que se ejecutan automaticamente
por tiempo (schedulers, cron jobs) sin intervencion de usuario humano.

**Cuando Usar Este Template:**

Use este template cuando:

1. El UC se ejecuta automaticamente por horario
2. Actor principal es Sistema, no usuario humano
3. Usa cron, scheduler, timer
4. Proceso batch, limpieza, agregacion periodica
5. No requiere interaccion UI durante ejecucion

**Cuando NO Usar Este Template:**

NO use este template para:

- UC iniciados por usuarios
- UC con UI interactiva
- APIs que responden a requests (usar UC normal)

**Caracteristicas de UC Temporales:**

- Actor: Sistema, Scheduler, Cron Job
- Trigger: Temporal (cada N minutos/horas/dias, horario especifico)
- Sin interaccion humana durante ejecucion
- Logging extensivo para debugging
- Locks para evitar ejecuciones concurrentes
- Monitoreo y alertas criticos

**Diferencia vs UC Normal:**

UC Normal:
- Actor: Usuario humano
- Trigger: Accion de usuario
- Interaccion UI

UC Temporal:
- Actor: Sistema
- Trigger: Tiempo (cron)
- Sin UI, solo logs y monitoreo

----------------------------------------------------------------------
1. TRIGGER TEMPORAL
----------------------------------------------------------------------

**Proposito:**

Documentar cuando y como se ejecuta automaticamente el UC.

**Tipo de Trigger:**

- Cron Job
- Scheduler de aplicacion
- Timer de sistema operativo
- Event-driven temporal

**Frecuencia:**

- Cada N minutos
- Cada N horas
- Diariamente a hora especifica
- Semanalmente
- Mensualmente
- Otro

**Cron Expression:**

.. code-block:: text

   # Formato: minuto hora dia mes dia_semana
   
   * * * * *
   | | | | |
   | | | | +-- Dia de semana (0-6, 0=Domingo)
   | | | +---- Mes (1-12)
   | | +------ Dia del mes (1-31)
   | +-------- Hora (0-23)
   +---------- Minuto (0-59)

**Comando de Ejecucion:**

Comando exacto que ejecuta el cron

**Horario y Timezone:**

- Timezone: UTC|Local|America/Mexico_City|etc
- Horario especifico si aplica

**EJEMPLO COMPLETO (UC-AUTH-08):**

**Tipo de Trigger:**

Cron Job en servidor de aplicacion

**Frecuencia:**

Cada 1 minuto, 24/7, todo el ano

**Cron Expression:**

.. code-block:: text

   */1 * * * *
   
   Explicacion:
   - */1: Cada 1 minuto
   - *: Toda hora
   - *: Todo dia del mes
   - *: Todo mes
   - *: Todo dia de semana

**Comando de Ejecucion:**

.. code-block:: bash

   # Crontab entry
   */1 * * * * cd /app/iact && /usr/bin/python manage.py mark_expired_sessions >> /var/log/iact/cron_sessions.log 2>&1

**Desglose del Comando:**

- cd /app/iact: Cambiar a directorio de aplicacion
- /usr/bin/python: Interprete Python (ruta absoluta)
- manage.py mark_expired_sessions: Django management command
- Redireccion stdout a /var/log/iact/cron_sessions.log
- 2 mayor y 1: Redirigir stderr tambien al log

**Horario y Timezone:**

- Timezone: UTC
- Horario: Continuo, cada minuto sin restricciones
- Razon: Sesiones pueden expirar en cualquier momento, revision continua

**Usuario que Ejecuta:**

- User: iact-app (usuario de sistema con permisos limitados)
- Grupo: iact
- Permisos: Acceso a BD, logs, no sudo

----------------------------------------------------------------------
2. FLUJO AUTOMATICO
----------------------------------------------------------------------

**Proposito:**

Documentar paso a paso lo que hace el proceso automatico.

**Estructura Similar a Flujo Normal:**

Pero sin interaccion de usuario, el sistema hace todo.

**Consideraciones Especiales:**

- Locks: Evitar ejecuciones concurrentes
- Idempotencia: Ejecucion multiple no causa problemas
- Transaccionalidad: Todo o nada
- Logging: Extensivo para debugging
- Error handling: Robusto, no debe caer

**FLUJO AUTOMATICO:**

1. Sistema inicia ejecucion del cron job

2. Sistema intenta adquirir lock

3. Sistema valida precondiciones

4. Sistema ejecuta logica principal

...

N. Sistema libera lock y termina

**EJEMPLO COMPLETO (UC-AUTH-08):**

FLUJO AUTOMATICO - Marcar Sesiones Expiradas

1. Sistema (cron) inicia ejecucion de mark_expired_sessions command
   
   Timestamp: Se registra hora de inicio

2. Sistema intenta adquirir lock de ejecucion (FR-AUTH-08-01)
   
   .. code-block:: sql
   
      -- Advisory lock en PostgreSQL
      SELECT pg_try_advisory_lock(hashtext('mark_expired_sessions'));
   
   Si lock NO se puede adquirir (otra ejecucion en progreso):
   
   2a. Sistema registra en log: "Previous execution still running, skipping"
   
   2b. Sistema termina sin error, exit code 0
   
   Si lock SI se adquiere:
   
   2c. Continua al paso 3

3. Sistema registra inicio en log (FR-AUTH-08-02)
   
   .. code-block:: python
   
      logger.info({
          'event': 'mark_expired_sessions_start',
          'timestamp': datetime.now().isoformat()
      })

4. Sistema calcula cutoff timestamp (FR-AUTH-08-03)
   
   .. code-block:: python
   
      cutoff = datetime.now() - timedelta(minutes=15)
      # Sesiones con last_activity_at menor cutoff estan expiradas

5. Sistema identifica sesiones a expirar (FR-AUTH-08-04)
   
   .. code-block:: sql
   
      SELECT id, user_id, last_activity_at
      FROM ivr_sessions
      WHERE status = 'ACTIVE'
        AND last_activity_at < :cutoff
      FOR UPDATE SKIP LOCKED;
   
   Nota: FOR UPDATE SKIP LOCKED evita bloqueos

6. Sistema cuenta sesiones identificadas
   
   count_to_expire = len(sessions_to_expire)

7. Si count_to_expire = 0:
   
   7a. Sistema registra en log: "No sessions to expire"
   
   7b. Salta al paso 11 (cleanup)

8. Sistema marca sesiones como expiradas (FR-AUTH-08-05)
   
   Implementa BR-IACT-046: Marcar Sesiones Expiradas
   
   .. code-block:: sql
   
      UPDATE ivr_sessions
      SET status = 'EXPIRED',
          expired_at = NOW(),
          updated_at = NOW()
      WHERE id IN :session_ids;

9. Sistema verifica filas actualizadas
   
   rows_updated = cursor.rowcount
   
   Si rows_updated != count_to_expire:
   
   9a. Sistema registra WARNING: "Mismatch in expected vs actual updates"
   
   9b. Continua (no es error critico)

10. Sistema registra metricas (FR-AUTH-08-06)
    
    .. code-block:: python
    
       logger.info({
           'event': 'sessions_expired',
           'count': rows_updated,
           'cutoff': cutoff.isoformat(),
           'execution_time_ms': execution_time
       })
    
    Enviar metricas a Prometheus:
    
    .. code-block:: python
    
       sessions_expired_total.inc(rows_updated)
       session_expiry_duration.observe(execution_time)

11. Sistema libera lock (FR-AUTH-08-07)
    
    .. code-block:: sql
    
       SELECT pg_advisory_unlock(hashtext('mark_expired_sessions'));

12. Sistema registra fin exitoso
    
    .. code-block:: python
    
       logger.info({
           'event': 'mark_expired_sessions_success',
           'total_expired': rows_updated,
           'duration_ms': total_duration
       })

13. Proceso termina exitosamente, exit code 0

**Flujo de Excepcion:**

FE-1: Error de Base de Datos

En paso 8, si UPDATE falla por error de BD:

  8a. Sistema registra ERROR con stack trace
  
  8b. Sistema hace ROLLBACK de transaccion
  
  8c. Sistema libera lock
  
  8d. Sistema envia alerta a Slack canal alerts-database
  
  8e. Proceso termina con error, exit code 1

FE-2: Timeout de Query

En paso 5, si query SELECT tarda mayor 10 segundos:

  5a. Sistema cancela query
  
  5b. Sistema registra ERROR con timeout
  
  5c. Sistema libera lock
  
  5d. Proceso termina con error, exit code 1

----------------------------------------------------------------------
3. LOCKS Y CONCURRENCIA
----------------------------------------------------------------------

**Proposito:**

Evitar que multiples ejecuciones del mismo job corran simultaneamente.

**Tipos de Locks:**

1. Advisory Locks (PostgreSQL)
2. File Locks (lockfile en filesystem)
3. Distributed Locks (Redis, Memcached)
4. Database Row Locks

**Estrategia Recomendada:**

- PostgreSQL Advisory Locks para jobs de BD
- File locks para jobs de filesystem
- Redis locks para jobs distribuidos

**Comportamiento si Lock No Disponible:**

- Skip execution (recomendado para jobs frecuentes)
- Wait y retry (para jobs criticos poco frecuentes)
- Fail con error

**EJEMPLO COMPLETO (UC-AUTH-08):**

**Tipo de Lock:**

PostgreSQL Advisory Lock (nivel sesion)

**Lock Key:**

hashtext('mark_expired_sessions')

Genera integer hash consistente del string

**Implementacion en Python:**

.. code-block:: python

   import psycopg2
   import hashlib
   
   def acquire_lock(connection, lock_name):
       """
       Attempts to acquire advisory lock.
       
       Returns:
           bool: True if lock acquired, False otherwise
       """
       cursor = connection.cursor()
       
       # Hash del nombre a integer
       lock_key = hash(lock_name) % (2**31)
       
       cursor.execute(
           "SELECT pg_try_advisory_lock(%s)",
           [lock_key]
       )
       
       result = cursor.fetchone()[0]
       return result
   
   def release_lock(connection, lock_name):
       """Releases advisory lock."""
       cursor = connection.cursor()
       lock_key = hash(lock_name) % (2**31)
       
       cursor.execute(
           "SELECT pg_advisory_unlock(%s)",
           [lock_key]
       )

**Uso en Management Command:**

.. code-block:: python

   from django.core.management.base import BaseCommand
   from django.db import connection
   
   class Command(BaseCommand):
       help = 'Mark expired sessions'
       
       def handle(self, *args, **options):
           lock_acquired = acquire_lock(
               connection.connection,
               'mark_expired_sessions'
           )
           
           if not lock_acquired:
               self.stdout.write(
                   "Another execution running, skipping"
               )
               return
           
           try:
               # Ejecutar logica principal
               self.mark_sessions()
           finally:
               # SIEMPRE liberar lock
               release_lock(
                   connection.connection,
                   'mark_expired_sessions'
               )

**Ventajas de Advisory Locks:**

- No requiere tabla adicional
- Automaticamente liberado si proceso muere
- Muy rapido (in-memory)
- Nivel de sesion, no de transaccion

----------------------------------------------------------------------
4. CODIGO COMPLETO
----------------------------------------------------------------------

**Proposito:**

Codigo funcional completo del job/command.

**EJEMPLO COMPLETO (UC-AUTH-08):**

**Archivo:** management/commands/mark_expired_sessions.py

.. code-block:: python

   """
   Django management command: Mark expired sessions
   
   Implements UC-IACT-AUTH-08: Marcar Sesiones Expiradas
   Implements BR-IACT-046: Inferencia - Marcar Sesiones
   
   Usage:
       python manage.py mark_expired_sessions
   
   Cron:
       */1 * * * * cd /app && python manage.py mark_expired_sessions
   """
   
   import logging
   import time
   from datetime import datetime, timedelta
   from django.core.management.base import BaseCommand
   from django.db import connection, transaction
   from prometheus_client import Counter, Histogram
   
   logger = logging.getLogger('iact.cron.sessions')
   
   # Prometheus metrics
   sessions_expired_total = Counter(
       'sessions_expired_total',
       'Total sessions marked as expired'
   )
   
   session_expiry_duration = Histogram(
       'session_expiry_duration_seconds',
       'Time to mark expired sessions'
   )
   
   class Command(BaseCommand):
       help = 'Mark expired sessions (runs every minute)'
       
       INACTIVITY_TIMEOUT_MINUTES = 15
       LOCK_NAME = 'mark_expired_sessions'
       
       def handle(self, *args, **options):
           start_time = time.time()
           
           # Try to acquire lock
           if not self.acquire_lock():
               logger.info(
                   "Previous execution still running, skipping"
               )
               return
           
           try:
               # Main logic
               expired_count = self.mark_expired_sessions()
               
               # Success metrics
               duration = time.time() - start_time
               session_expiry_duration.observe(duration)
               
               logger.info({
                   'event': 'mark_expired_sessions_success',
                   'expired_count': expired_count,
                   'duration_seconds': round(duration, 3)
               })
               
           except Exception as e:
               logger.error(
                   "Error marking expired sessions",
                   exc_info=True
               )
               raise
               
           finally:
               # Always release lock
               self.release_lock()
       
       def acquire_lock(self):
           """Acquire PostgreSQL advisory lock."""
           cursor = connection.cursor()
           lock_key = hash(self.LOCK_NAME) % (2**31)
           
           cursor.execute(
               "SELECT pg_try_advisory_lock(%s)",
               [lock_key]
           )
           
           return cursor.fetchone()[0]
       
       def release_lock(self):
           """Release PostgreSQL advisory lock."""
           cursor = connection.cursor()
           lock_key = hash(self.LOCK_NAME) % (2**31)
           
           cursor.execute(
               "SELECT pg_advisory_unlock(%s)",
               [lock_key]
           )
       
       def mark_expired_sessions(self):
           """
           Mark sessions as expired if inactive > 15 minutes.
           
           Returns:
               int: Number of sessions marked as expired
           """
           cutoff = datetime.now() - timedelta(
               minutes=self.INACTIVITY_TIMEOUT_MINUTES
           )
           
           logger.info({
               'event': 'mark_expired_sessions_start',
               'cutoff': cutoff.isoformat()
           })
           
           with transaction.atomic():
               cursor = connection.cursor()
               
               # Update expired sessions
               query = """
                   UPDATE ivr_sessions
                   SET status = 'EXPIRED',
                       expired_at = NOW(),
                       updated_at = NOW()
                   WHERE status = 'ACTIVE'
                     AND last_activity_at < %s
               """
               
               cursor.execute(query, [cutoff])
               rows_updated = cursor.rowcount
               
               # Update metrics
               sessions_expired_total.inc(rows_updated)
               
               logger.info({
                   'event': 'sessions_marked_expired',
                   'count': rows_updated,
                   'cutoff': cutoff.isoformat()
               })
               
               return rows_updated

----------------------------------------------------------------------
5. MONITOREO Y ALERTAS
----------------------------------------------------------------------

**Proposito:**

Como se monitorea el job y cuando alertar.

**Metricas a Monitorear:**

1. Ejecuciones exitosas vs fallidas
2. Duracion de ejecucion
3. Numero de items procesados
4. Ultimo timestamp exitoso

**Alertas:**

Cuando alertar al equipo de operaciones

**Healthcheck:**

Como verificar que el job esta corriendo

**EJEMPLO COMPLETO (UC-AUTH-08):**

**Metricas Prometheus:**

.. code-block:: python

   # Contador de sesiones expiradas
   sessions_expired_total = Counter(
       'sessions_expired_total',
       'Total sessions marked as expired'
   )
   
   # Histograma de duracion
   session_expiry_duration = Histogram(
       'session_expiry_duration_seconds',
       'Time to mark expired sessions',
       buckets=[0.1, 0.5, 1.0, 2.0, 5.0]
   )
   
   # Gauge de ultimo timestamp exitoso
   from prometheus_client import Gauge
   
   last_success_timestamp = Gauge(
       'session_expiry_last_success_timestamp',
       'Timestamp of last successful execution'
   )

**Dashboard Grafana:**

Panel 1: Sesiones Expiradas por Minuto

.. code-block:: promql

   rate(sessions_expired_total[5m]) * 60

Panel 2: Duracion p95

.. code-block:: promql

   histogram_quantile(0.95, session_expiry_duration_seconds)

Panel 3: Tiempo Desde Ultimo Exito

.. code-block:: promql

   time() - last_success_timestamp

**Alertas (AlertManager):**

Alerta 1: Job No Ejecutado en 5 Minutos

.. code-block:: yaml

   - alert: SessionExpiryJobStalled
     expr: time() - last_success_timestamp > 300
     for: 1m
     labels:
       severity: critical
     annotations:
       summary: "Session expiry job has not run in 5 minutes"
       description: "Last successful run was {{ $value }} seconds ago"

Alerta 2: Duracion Excesiva

.. code-block:: yaml

   - alert: SessionExpiryJobSlow
     expr: session_expiry_duration_seconds > 10
     for: 2m
     labels:
       severity: warning
     annotations:
       summary: "Session expiry job taking too long"
       description: "Execution took {{ $value }} seconds"

Alerta 3: Alto Volumen de Expiraciones

.. code-block:: yaml

   - alert: HighSessionExpiryRate
     expr: rate(sessions_expired_total[5m]) > 100
     for: 5m
     labels:
       severity: warning
     annotations:
       summary: "High rate of session expiries"
       description: "{{ $value }} sessions/sec being expired"

**Healthcheck Endpoint:**

Crear endpoint HTTP que verifica ultimo run:

.. code-block:: python

   # views.py
   
   from django.http import JsonResponse
   from datetime import datetime, timedelta
   
   def healthcheck_session_expiry(request):
       """
       Healthcheck for session expiry job.
       
       Returns 200 if job ran in last 2 minutes.
       Returns 503 if job stalled.
       """
       # Query ultimo log exitoso
       last_run = get_last_successful_run()
       
       if not last_run:
           return JsonResponse({
               'status': 'error',
               'message': 'No successful runs found'
           }, status=503)
       
       time_since = datetime.now() - last_run
       
       if time_since > timedelta(minutes=2):
           return JsonResponse({
               'status': 'stalled',
               'last_run': last_run.isoformat(),
               'minutes_ago': time_since.total_seconds() / 60
           }, status=503)
       
       return JsonResponse({
           'status': 'healthy',
           'last_run': last_run.isoformat(),
           'seconds_ago': time_since.total_seconds()
       })

**Notificaciones:**

Cuando enviar notificaciones:

- Slack: Errores CRITICOS, alertas fires
- PagerDuty: Job stalled mayor 10 minutos
- Email: Resumen diario de metricas

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estandares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagogico:**

- PARTE_2_Documentar_Use_Cases_IACT_1_0_0.md

**Documentos Relacionados:**

- BR-IACT-046-Marcar-Sesiones-Expiradas-1-0-0.rst
- FR-AUTH-08-XX-Nombre-1-0-0.rst

**Cron Resources:**

- crontab.guru - Cron expression generator
- PostgreSQL Advisory Locks documentation

----------------------------------------------------------------------

.. note::
   CHECKLIST UC TEMPORAL:
   
   - Trigger temporal con cron expression completa
   - Comando exacto de ejecucion documentado
   - Flujo automatico con pasos detallados
   - Lock mechanism implementado
   - Codigo Python/script completo y funcional
   - Manejo de errores robusto
   - Logging extensivo
   - Metricas Prometheus definidas
   - Alertas configuradas
   - Healthcheck endpoint
   - Actor es Sistema, no usuario

----------------------------------------------------------------------

**Archivo:** TPL_UC_Temporal_Schedulers_1_3_0.rst  
**Version Template:** 1.3.0  
**Fecha Creacion Template:** 2026-01-11  
**Autor Template:** Sistema de Regeneracion IACT  
**Lineas Totales:** aproximadamente 550

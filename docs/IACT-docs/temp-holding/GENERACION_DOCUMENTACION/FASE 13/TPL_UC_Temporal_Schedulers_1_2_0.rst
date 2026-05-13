.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Titulo: [Nombre - Proceso Temporal]
   :Version: 4.0.0
   :Tipo: Temporal
   :Schedule: [Cron Expression]
   :Fecha: YYYY-MM-DD

======================================================================
UC-IACT-XXX-YY: [Nombre] (Proceso Temporal/Scheduler)
======================================================================

**Actor:** Sistema (Scheduler/Cron Job)

----------------------------------------------------------------------
INTRODUCCION
----------------------------------------------------------------------

**UC Temporal** se ejecuta automáticamente en horarios programados,
SIN intervención del usuario.

**Casos de uso:**
- Procesos nocturnos (ETL, backups, consolidación)
- Limpieza periódica (archivos temp, sesiones expiradas)
- Notificaciones programadas
- Sincronizaciones con sistemas externos

----------------------------------------------------------------------
1. TRIGGER TEMPORAL
----------------------------------------------------------------------

**Tipo de Schedule:**

- [ ] Cron Job (Linux crontab)
- [ ] Task Scheduler (Windows)
- [ ] Celery Beat (Python)
- [ ] Airflow DAG
- [ ] Otro: [especificar]

**Cron Expression:**

.. code-block:: text

   # Formato: minuto hora día mes día_semana
   
   0 2 * * *
   │ │ │ │ │
   │ │ │ │ └─── Día de semana (0-7, 0 y 7 = Domingo)
   │ │ │ └───── Mes (1-12)
   │ │ └─────── Día del mes (1-31)
   │ └───────── Hora (0-23)
   └─────────── Minuto (0-59)
   
   Ejemplo: 0 2 * * * = Todos los días a las 2:00 AM

**Interpretación:**

[Descripción en lenguaje natural de cuándo se ejecuta]

Ejemplo: "Todos los días a las 2:00 AM"

**Comando Ejecutado:**

.. code-block:: bash

   # En crontab
   0 2 * * * cd /home/iact && python manage.py run_nightly_process >> /var/log/iact/nightly.log 2>&1

**Horario Elegido - Justificación:**

[Por qué se eligió este horario específico]

Ejemplo:
- 2:00 AM porque es horario de menor uso
- No interfiere con backups (que corren a 1:00 AM)
- Termina antes de que usuarios inicien actividad (7:00 AM)

----------------------------------------------------------------------
2. PRECONDICIONES
----------------------------------------------------------------------

PC-1: Servidor activo y accesible

PC-2: Base de datos disponible

PC-3: No hay otro proceso bloqueante ejecutándose
     (verificar mediante lock)

PC-4: Espacio en disco suficiente (> 10 GB libre)

----------------------------------------------------------------------
3. FLUJO AUTOMATICO
----------------------------------------------------------------------

1. Cron ejecuta comando a hora programada

2. Sistema verifica precondiciones

3. Sistema adquiere LOCK para prevenir ejecución concurrente
   
   .. code-block:: sql
   
      SELECT pg_try_advisory_lock(123456789) as acquired;
      -- Si retorna TRUE: lock adquirido
      -- Si retorna FALSE: otro proceso está corriendo

4. Si lock NO adquirido → abortar ejecución (FA-1)

5. Sistema inicia logging
   
   .. code-block:: python
   
      logger.info(
          f"Nightly process started. "
          f"Timestamp: {datetime.now()}"
      )

6. Sistema ejecuta tarea principal:
   
   [Descripción específica de qué hace el proceso]
   
   Ejemplo:
   - Leer registros con status='PENDING'
   - Procesar cada registro
   - Actualizar status='PROCESSED'

7. Sistema registra estadísticas
   
   .. code-block:: python
   
      stats = {
          'total_processed': 1250,
          'successful': 1240,
          'failed': 10,
          'duration_seconds': 180
      }

8. Sistema libera LOCK
   
   .. code-block:: sql
   
      SELECT pg_advisory_unlock(123456789);

9. Sistema registra fin de proceso
   
   .. code-block:: python
   
      logger.info(
          f"Nightly process completed. "
          f"Stats: {stats}"
      )

10. Si hay errores críticos → enviar alerta

11. Proceso termina exitosamente

----------------------------------------------------------------------
4. FLUJOS ALTERNOS
----------------------------------------------------------------------

FA-1: Lock ya adquirido (otro proceso corriendo)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En paso 4, si lock no se puede adquirir:

  4a. Sistema registra WARNING:
      
      .. code-block:: python
      
         logger.warning(
             "Cannot acquire lock. "
             "Another instance is running. Aborting."
         )
  
  4b. Sistema aborta ejecución sin error
  
  4c. Proceso termina

FA-2: Error durante procesamiento
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En paso 6, si ocurre excepción:

  6a. Sistema captura excepción
  
  6b. Sistema ejecuta ROLLBACK (si hay transacción)
  
  6c. Sistema libera lock (importante)
  
  6d. Sistema registra ERROR:
      
      .. code-block:: python
      
         logger.error(
             f"Process failed. Error: {str(e)}",
             exc_info=True
         )
  
  6e. Sistema envía alerta a Slack #alerts
  
  6f. Proceso termina con código error 1

----------------------------------------------------------------------
5. MANEJO DE LOCKS
----------------------------------------------------------------------

**Lock Mechanism (PostgreSQL):**

.. code-block:: python

   import psycopg2
   
   def acquire_lock(conn, lock_id):
       """
       Adquiere advisory lock en PostgreSQL
       
       Returns:
           bool: True si adquirido, False si otro proceso lo tiene
       """
       cursor = conn.cursor()
       cursor.execute(
           "SELECT pg_try_advisory_lock(%s)",
           (lock_id,)
       )
       acquired = cursor.fetchone()[0]
       return acquired
   
   def release_lock(conn, lock_id):
       """Libera advisory lock"""
       cursor = conn.cursor()
       cursor.execute(
           "SELECT pg_advisory_unlock(%s)",
           (lock_id,)
       )

**Uso en Script:**

.. code-block:: python

   LOCK_ID = 123456789  # Número único para este proceso
   
   def run_nightly_process():
       conn = get_db_connection()
       
       try:
           # Intentar adquirir lock
           if not acquire_lock(conn, LOCK_ID):
               logger.warning("Lock not acquired. Aborting.")
               return
           
           # Ejecutar proceso
           process_data()
           
       except Exception as e:
           logger.error(f"Process failed: {e}")
           raise
       finally:
           # SIEMPRE liberar lock
           release_lock(conn, LOCK_ID)
           conn.close()

----------------------------------------------------------------------
6. MONITOREO Y ALERTAS
----------------------------------------------------------------------

**Logs a Revisar:**

.. code-block:: bash

   # Ver últimas ejecuciones
   tail -100 /var/log/iact/nightly.log
   
   # Buscar errores
   grep "ERROR" /var/log/iact/nightly.log
   
   # Ver tiempo de ejecución
   grep "duration_seconds" /var/log/iact/nightly.log

**Alertas Configuradas:**

1. **Si proceso falla:**
   - Canal: Slack #tech-alerts
   - Mensaje: "Nightly process FAILED. Check logs."

2. **Si proceso tarda >30 minutos:**
   - Canal: Slack #tech-alerts
   - Mensaje: "Nightly process exceeding 30 min"

3. **Si proceso NO ejecutó (>25 horas desde último):**
   - Canal: Slack #tech-alerts
   - Mensaje: "Nightly process MISSED. Last run: {timestamp}"

**Dashboard de Monitoreo:**

.. code-block:: text

   ╔═══════════════════════════════════════════════════╗
   ║       Nightly Process - Status Dashboard          ║
   ╠═══════════════════════════════════════════════════╣
   ║                                                   ║
   ║  Última ejecución:    2026-01-09 02:00:00        ║
   ║  Estado:              ✅ SUCCESS                  ║
   ║  Duración:            3 min 15 seg               ║
   ║  Registros procesados: 1,250                     ║
   ║  Errores:             10 (0.8%)                  ║
   ║                                                   ║
   ║  Próxima ejecución:   2026-01-10 02:00:00        ║
   ║                                                   ║
   ╚═══════════════════════════════════════════════════╝

----------------------------------------------------------------------
DERIVACION A FR
----------------------------------------------------------------------

Paso 6 → FR-XXX-01: Procesar Registros Pendientes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** Lógica principal del proceso nocturno

**Tipo:** Batch Processing

**Input:** Registros con status='PENDING'

**Output:** Registros actualizados a status='PROCESSED'

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

- STD_001_Estandares_Documentacion_1_1_0.rst
- PARTE_2E_Procesos_Temporales_IACT_1_0_0.md

**Cron Guides:**
- https://crontab.guru (validador de cron)

**Archivo:** TPL_UC_Temporal_Schedulers_1_2_0.rst  
**Líneas:** ~350


.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Tipo: Temporal
   :Version: 4.0.0

======================================================================
UC-IACT-XXX-YY: [Proceso Programado]
======================================================================

ACTOR PRINCIPAL: Sistema (Scheduler/Cron)

TRIGGER TEMPORAL
~~~~~~~~~~~~~~~~
**Tipo:** Cron Job
**Schedule:** 0 2 * * * (diario 2:00 AM)
**Comando:** python manage.py run_process

FLUJO AUTOMATICO
~~~~~~~~~~~~~~~~

1. Cron ejecuta script en horario programado
2. Sistema verifica lock (evitar doble ejecución)
3. Sistema crea lock temporal
4. Sistema consulta registros a procesar
5. Para cada registro:
   - Sistema aplica lógica [BR-XXX]
   - Sistema actualiza estado
6. Sistema libera lock
7. Sistema registra ejecución en log
8. Sistema envía resumen por email

MANEJO DE LOCKS
~~~~~~~~~~~~~~~

.. code-block:: sql

   -- Adquirir lock
   INSERT INTO process_locks (process_name, acquired_at)
   VALUES ('nombre_proceso', NOW())
   ON CONFLICT DO NOTHING
   
   -- Verificar lock
   SELECT 1 FROM process_locks
   WHERE process_name = 'nombre_proceso'
     AND acquired_at > NOW() - INTERVAL '1 hour'

MONITOREO
~~~~~~~~~

Logs: /var/log/iact/proceso.log
Alertas: Email si falla
Métricas: Duración, registros procesados

**Archivo:** TPL_UC_Temporal_Schedulers_1_1_0.rst
**Version:** 1.1.0

.. _uc-rpt-07-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 ScheduledReport
===================

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Notas
 * - id
   - uuid
   - PK
 * - actor_id
   - int
   -
 * - name
   - string
   -
 * - report_type
   - enum
   -
 * - filters
   - JSON
   -
 * - period_relative
   - enum
   - last_24h | last_7d | ...
 * - group_by
   - JSON
   -
 * - format
   - enum
   -
 * - schedule_frequency
   - enum
   - daily/weekly/monthly/cron
 * - schedule_params
   - JSON
   - hour, day_of_week, ...
 * - timezone
   - string
   - IANA tz
 * - status
   - active | paused
   -
 * - last_run_at
   - timestamp | null
   -
 * - next_run_at
   - timestamp
   -
 * - failure_count
   - int
   - reset al exito
 * - created_at
   - timestamp
   -

7.2 ScheduleExecutionLog
========================

::

   { id, scheduled_report_id,
     started_at, completed_at,
     status: ok | failed,
     export_job_id,
     error_code | null }

Retencion: 30 dias online.

7.3 Datos NO involucrados
=========================

- Email externo.
- BD operativa.

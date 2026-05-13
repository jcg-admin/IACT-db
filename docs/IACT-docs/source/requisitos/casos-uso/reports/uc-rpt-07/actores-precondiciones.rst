.. _uc-rpt-07-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User con funcion** ``schedule_reports``
- **Scheduler** (cron-like)
- **ExportWorker** (UC_RPT_04)
- **MailboxService**

2.2 Precondiciones
==================

- User autenticado.
- ``schedule_reports`` activa.
- Funcion ``export_reports`` tambien
  (porque cada ejecucion genera export).

2.3 Postcondiciones (creacion)
==============================

- ScheduledReport persistido.
- Audit SCHEDULED_REPORT_CREATED.
- Scheduler lo registra.

2.4 Postcondiciones (ejecucion automatica)
==========================================

- ExportJob creado y procesado.
- Mailbox notify del User.
- ScheduledReport.last_run_at actualizado.

2.5 Datos de entrada (creacion)
===============================

::

   POST /api/reports/scheduled/
   body: {
     name, report_type, filters,
     period_relative, group_by, format,
     schedule: {
       frequency: daily|weekly|monthly|cron,
       hour, day_of_week?, day_of_month?,
       cron_expr?,
       timezone
     }
   }

2.6 Datos de salida
===================

::

   {
     id, name, schedule, next_run_at,
     created_at
   }

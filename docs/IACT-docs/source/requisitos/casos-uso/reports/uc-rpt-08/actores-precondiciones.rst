.. _uc-rpt-08-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User con funcion**
  ``view_scheduled_reports``
- **ScheduledReportRepo**

2.2 Precondiciones
==================

- User autenticado, RBAC activo.

2.3 Postcondiciones
===================

- Sin escritura.

2.4 Datos de entrada (list)
===========================

::

   GET /api/reports/scheduled/
       ?status=active|paused|all
       &page_size=20

2.5 Datos de salida
===================

::

   {
     items: [
       { id, name, frequency, next_run_at,
         last_run_at, status,
         failure_count, format }, ...
     ],
     pagination: { page, page_size, total }
   }

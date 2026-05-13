.. _uc-rpt-13-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User con funcion** ``view_queue_reports``
- **AnalyticsRepo**

2.2 Precondiciones
==================

Auth + RBAC + segmento.

2.3 Postcondiciones
===================

Sin escrituras.

2.4 Datos de entrada
====================

::

   GET /api/reports/queues/
       ?period=last_30d
       &filter[queue_id]=...

Detalle:

::

   GET /api/reports/queues/{queue_id}/

2.5 Datos de salida
===================

::

   {
     period,
     items: [
       { queue_id, name,
         offered, answered, abandoned,
         asa_seconds, service_level_pct,
         abandon_rate_pct,
         max_wait_seconds,
         peak_queue_depth }, ...
     ],
     summary: { total_offered,
                total_answered,
                avg_sl }
   }

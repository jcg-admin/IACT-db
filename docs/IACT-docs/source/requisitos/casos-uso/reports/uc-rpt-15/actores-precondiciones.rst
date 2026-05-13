.. _uc-rpt-15-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User con funcion**
  ``view_transfer_reports``
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

   GET /api/reports/transfers/
       ?period=last_30d
       &filter[direction]=internal|external

2.5 Datos de salida
===================

::

   {
     period,
     totals: { transfers_in, transfers_out,
               avg_pre_transfer_seconds,
               resolved_post_transfer_pct,
               abandoned_post_transfer_pct },
     by_reason: [
       { reason, count }, ...
     ],
     top_origin_agents: [...],
     top_destination_queues: [...],
     inter_queue_heatmap: [
       { from_queue, to_queue, count }, ...
     ]
   }

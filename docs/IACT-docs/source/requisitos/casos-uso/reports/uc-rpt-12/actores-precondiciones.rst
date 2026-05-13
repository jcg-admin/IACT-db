.. _uc-rpt-12-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User con funcion**
  ``view_agent_reports``
- **AnalyticsRepo**
- **MetricsCache**

2.2 Precondiciones
==================

- Auth + RBAC + segmento.

2.3 Postcondiciones
===================

- Sin escrituras.
- Cache poblado.

2.4 Datos de entrada
====================

::

   GET /api/reports/agents/
       ?period=last_30d
       &filter[team]=...
       &sort_by=tmo&sort_order=asc
       &page=1&page_size=50

Para detalle:

::

   GET /api/reports/agents/{agent_id}/
       ?period=last_30d

(requiere ``view_agent_detail`` adicional)

2.5 Datos de salida (lista)
===========================

::

   {
     period,
     items: [
       { agent_id, display_name,
         calls_answered, abandoned,
         tmo, aht, occupancy_pct,
         adherence_pct,
         transfers, holds, acw }, ...
     ],
     pagination,
     summary: {team_aggregates}
   }

.. _uc-rpt-14-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User con funcion**
  ``view_campaign_reports``
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

   GET /api/reports/campaigns/
       ?period=last_30d
       &filter[campaign_type]=outbound

Detalle:

::

   GET /api/reports/campaigns/{campaign_id}/

2.5 Datos de salida
===================

::

   {
     period,
     items: [
       { campaign_id, name, type,
         attempted, reached,
         conversion_rate_pct,
         calls_per_hour, tmo,
         disposition_mix }, ...
     ],
     summary
   }

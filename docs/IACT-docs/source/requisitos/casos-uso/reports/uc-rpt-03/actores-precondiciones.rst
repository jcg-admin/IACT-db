.. _uc-rpt-03-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User con funcion**
  ``view_historical_reports``
- **Frontend**
- **AnalyticsRepo** (read replica)
- **MetricsCache** (TTL adaptativo)

2.2 Precondiciones
==================

- User autenticado.
- ``view_historical_reports`` activa.
- Segmento del User definido.

2.3 Postcondiciones
===================

- Sin escrituras a Analytics.
- Cache poblado.

2.4 Datos de entrada
====================

::

   GET /api/reports/historical/
       ?period=last_30d
       &group_by=day
       &filter[campaign]=...
       &page=1&page_size=50

2.5 Datos de salida
===================

::

   {
     period, group_by,
     filters_applied,
     buckets: [
       { bucket_key, kpis: {...} }, ...
     ],
     pagination: {
       page, page_size,
       total_buckets, has_next
     },
     comparative: {
       period_prior: { kpis_summary }
     },
     cache: bool
   }

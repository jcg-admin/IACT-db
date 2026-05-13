.. _uc-rpt-17-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User con funcion**
  ``view_unique_clients_reports``
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

   GET /api/reports/unique-clients/
       ?period=last_30d

2.5 Datos de salida
===================

::

   {
     period,
     distinct_clients_count,
     avg_calls_per_client,
     recurrencia_distribution: [
       { calls: 1, clients_count, pct },
       { calls: 2, clients_count, pct },
       { calls: "3+", clients_count, pct }
     ],
     new_vs_returning: {
       new_count, returning_count
     },
     top_volume_anonymized: [
       { client_hash_prefix,
         calls_count }, ...
     ]
   }

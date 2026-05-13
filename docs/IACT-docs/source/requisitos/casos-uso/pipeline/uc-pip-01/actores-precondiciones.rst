.. _uc-pip-01-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- **User con funcion** ``view_etl_supervision``
- **ETLMetadataRepo**

Auth + RBAC.

::

   GET /api/etl/supervision/

Response:

::

   {
     summary: {
       jobs_running, jobs_completed_24h,
       jobs_failed_24h,
       lag_max_seconds, total_throughput_rps
     },
     by_pipeline: [
       { pipeline_id, name,
         last_run, status,
         lag_seconds, throughput_rps,
         next_run }, ...
     ]
   }

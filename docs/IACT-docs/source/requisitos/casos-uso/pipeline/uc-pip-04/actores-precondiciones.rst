.. _uc-pip-04-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- **User con funcion**
  ``request_pipeline_retry``
- **PipelineExecutor**

::

   POST /api/etl/pipelines/{pipeline_id}/retry/
   body: {
     run_id?: uuid (opcional, retry de
                     run especifico),
     reason: string (≥ 20 char obligatoria),
     priority?: high|normal
   }

Response: nuevo run_id encolado.

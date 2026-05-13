.. _uc-pip-01-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades
=============

- **PipelineRun** (metadata ETL).
- **PipelineDefinition**.

7.2 Modelo
==========

::

   PipelineRun:
     id, pipeline_id,
     started_at, completed_at,
     status: running|success|failed,
     rows_processed, bytes_processed,
     error_summary?

7.3 Indices
===========

- ``PipelineRun(pipeline_id,
  started_at DESC)``.
- ``PipelineRun(status, started_at DESC)``.

.. _uc-pip-02-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 ETLError
============

::

   ETLError:
     id, pipeline_run_id, occurred_at,
     error_type, error_message,
     stack_trace_sanitized,
     correlation_id,
     payload_sample_sanitized

7.2 Indices
===========

- ``ETLError(pipeline_run_id)``.
- ``ETLError(error_type, occurred_at)``.

7.3 Sanitization
================

PIIScanner aplicado a stack y payload
antes de retornar.

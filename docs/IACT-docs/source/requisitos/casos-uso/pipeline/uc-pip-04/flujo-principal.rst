.. _uc-pip-04-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — POST.
PASO 2 — JWT.
PASO 3 — RBAC ``request_pipeline_retry``.
PASO 4 — Validar:

- pipeline existe
- reason ≥ 20 char
- pipeline no esta en running (no se
  re-encola sobre running)
- ultimo run failed (o run_id especifico
  failed)

PASO 5 — Encolar nuevo run con priority.
PASO 6 — Audit ``PIPELINE_RETRY_REQUESTED``
con actor + reason + run_id_origen.
PASO 7 — 202 Accepted con nuevo run_id.

3.1 Resumen
===========

.. list-table::
 :widths: 8 50 22 20

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1-3
   - POST + JWT + RBAC
   - Endpoint
   - 009
 * - 4
   - Validar
   - Validator
   - —
 * - 5
   - Encolar
   - PipelineExecutor
   - —
 * - 6
   - Audit P-39
   - UC_PERM_09
   - 025
 * - 7
   - 202
   - View
   - —

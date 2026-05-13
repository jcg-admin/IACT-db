.. _uc-alr-01-parte-03:

==========================
Parte 3 — Flujo principal
==========================

3.1 Crear
=========

PASO 1 — POST.
PASO 2 — JWT.
PASO 3 — RBAC.
PASO 4 — Validar:

- metric ∈ enum
- scope ⊆ segmento del owner
- condition coherente con metric
- actions validos (mailbox targets
  existen)

PASO 5 — INSERT AlertRule.
PASO 6 — Audit ALERT_RULE_CREATED.
PASO 7 — Notificar a Evaluator (reload).
PASO 8 — 201.

3.2 Update / Delete / Pause / Resume
====================================

CRUD estandar con audit por cada cambio.
Evaluator recarga.

3.3 Resumen
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
   - 008
 * - 5
   - INSERT
   - Repo
   - —
 * - 6
   - Audit
   - UC_PERM_09
   - 025
 * - 7
   - Reload
   - Evaluator
   - —
 * - 8
   - 201
   - View
   - —

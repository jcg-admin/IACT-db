.. _uc-rpt-10-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — POST.
PASO 2 — JWT.
PASO 3 — Validar:

- nombre unique por User
- columns ⊆ catalog del report_type
- filters validan contra segmento
- chart_config consistente

PASO 4 — Limite 30.
PASO 5 — INSERT SavedView.
PASO 6 — Audit ``VIEW_CREATED``.
PASO 7 — Response 201.

CRUD estandar para list / get / update /
delete.

Aplicar:

::

   GET /api/reports/{report_type}/?view_id=X

Backend resuelve, expande y ejecuta como
si los parametros vinieran del User.

3.1 Resumen
===========

.. list-table::
 :widths: 8 50 22 20

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1-2
   - POST + JWT
   - Endpoint
   - 009
 * - 3
   - Validar
   - Validator
   - 008
 * - 4
   - Limite
   - Limiter
   - —
 * - 5
   - INSERT
   - Repo
   - —
 * - 6
   - Audit
   - UC_PERM_09
   - 025
 * - 7
   - 201
   - View
   - —

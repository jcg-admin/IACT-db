.. _uc-opr-01-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — POST.
PASO 2 — JWT (CNST-009).
PASO 3 — Validar:

- new_state ∈ enum.
- transicion valida (1.3).
- reason si break/training (CNST-032
  reason-required).

PASO 4 — Cargar estado actual.
PASO 5 — Atomico:

- UPDATE estado.
- Audit ``AGENT_STATE_CHANGED`` con
  from, to, reason, duration.

PASO 6 — Notificar CallRouter
(post-COMMIT).
PASO 7 — Response 200.

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
   - Validar transicion
   - Validator
   - —
 * - 4
   - Cargar estado
   - Repo
   - —
 * - 5
   - UPDATE atomico + audit
   - Tx
   - 025
 * - 6
   - Notify router
   - EventBus
   - —
 * - 7
   - 200
   - View
   - —

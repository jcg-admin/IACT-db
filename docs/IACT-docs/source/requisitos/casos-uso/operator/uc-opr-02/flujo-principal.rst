.. _uc-opr-02-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — Llamada offered al agente
(via CallRouter event).
PASO 2 — Frontend muestra ringing.
PASO 3 — Agente clic answer (POST).
PASO 4 — JWT validar.
PASO 5 — Validar call_id pertenece a
oferta vigente al agente.
PASO 6 — Telephony.bridge(agent,
caller).
PASO 7 — Atomic: UPDATE state busy +
CallSession started + audit
``CALL_ANSWERED``.
PASO 8 — 200 con call info.

3.1 Resumen
===========

.. list-table::
 :widths: 8 50 22 20

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1-2
   - Offer + ring
   - CallRouter
   - —
 * - 3-4
   - POST + JWT
   - Endpoint
   - 009
 * - 5
   - Validar offer
   - Validator
   - —
 * - 6
   - Bridge
   - Telephony
   - —
 * - 7
   - Atomic state + audit
   - Tx
   - 025
 * - 8
   - 200
   - View
   - —

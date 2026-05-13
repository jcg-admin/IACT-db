.. _uc-opr-02-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Decline — agente rechaza oferta;
Router intenta otro agente.
FA-02: Timeout sin answer —
auto-decline + state inactive temporal.
FA-03: Caller cuelga durante ring —
oferta cancelada.
FA-04: Whisper info — UI muestra
info del caller (skill, motivo,
tiempo en cola) al ring.

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Decline
   - re-offer
   -
 * - FA-02
   - Timeout
   - auto-decline
   -
 * - FA-03
   - Caller hangup
   - cancel offer
   -
 * - FA-04
   - Whisper info
   - UI displays
   -

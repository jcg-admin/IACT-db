.. _uc-opr-03-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: No answer → estado available.
FA-02: Busy → retry policy.
FA-03: Auto-dial → predictive.
FA-04: Preview-dial → agente acepta.

.. list-table::
 :widths: 12 38 30 20
 :header-rows: 1

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - No answer
   - back to available
   -
 * - FA-02
   - Busy
   - retry
   -
 * - FA-03
   - Auto
   - predictive
   -
 * - FA-04
   - Preview
   - manual confirm
   -

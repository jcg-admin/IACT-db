.. _uc-opr-01-parte-05:

==========================
Parte 5 — Excepciones
==========================

EX-01: JWT — 401.
EX-02: new_state desconocido — 400.
EX-03: Transicion invalida — 409.
EX-04: Reason missing (break/training) — 400.
EX-05: Break exceeded — 409.
EX-06: BD timeout — 503.

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - Audit
 * - EX-01..06
   - varios
   - 401/400/409/503
   - middleware/validation

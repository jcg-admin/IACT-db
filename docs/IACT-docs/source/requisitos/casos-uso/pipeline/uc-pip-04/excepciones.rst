.. _uc-pip-04-parte-05:

==========================
Parte 5 — Excepciones
==========================

EX-01: JWT — 401.
EX-02: Sin permiso — 403.
EX-03: Validation — 400.
EX-04: Pipeline no existe — 404.
EX-05: Already running — 409.
EX-06: Reason missing — 400.
EX-07: Doble retry — 409.
EX-08: Audit fail — 500.
EX-09: BD timeout — 503.

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - Audit
 * - EX-01..09
   - varios
   - 401/403/400/404/409/500/503
   - middleware/validation/operacion FAILED

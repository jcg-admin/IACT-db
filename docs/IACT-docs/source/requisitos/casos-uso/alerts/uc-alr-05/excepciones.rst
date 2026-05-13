.. _uc-alr-05-parte-05:

==========================
Parte 5 — Excepciones
==========================

EX-01: JWT — 401.
EX-02: Sin permiso — 403.
EX-03: Validation — 400.
EX-04: Cross-segmento — 400.
EX-05: Sub duplicada — 409.
EX-06: Rule no existe — 404.
EX-07: BD timeout — 503.

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - Audit
 * - EX-01..07
   - varios
   - 401/403/400/409/404/503
   - middleware/validation

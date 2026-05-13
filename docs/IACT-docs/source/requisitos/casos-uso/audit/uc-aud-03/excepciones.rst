.. _uc-aud-03-parte-05:

==========================
Parte 5 — Excepciones
==========================

Identicas a UC_RPT_04:

EX-01: JWT — 401.
EX-02: Sin permiso — 403.
EX-03: Validation — 400.
EX-04: > 5M rows — 400.
EX-05: > 5 jobs — 429.
EX-06: Storage caido — failed.
EX-07: BD timeout — 503.
EX-08: Audit fail — 500.

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - Audit
 * - EX-01..08
   - varios
   - 401/403/400/429/503/500
   - middleware/validation

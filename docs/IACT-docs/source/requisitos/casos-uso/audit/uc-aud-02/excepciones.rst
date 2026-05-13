.. _uc-aud-02-parte-05:

==========================
Parte 5 — Excepciones
==========================

EX-01: JWT — 401.
EX-02: Sin permiso — 403.
EX-03: Validation — 400.
EX-04: Range > 90 dias — 400.
EX-05: Throttling — 429.
EX-06: Search engine timeout — 503.
EX-07: Meta-audit fail — 503.

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - Audit
 * - EX-01..07
   - varios
   - 401/403/400/429/503
   - middleware/validation

.. _uc-aud-04-parte-05:

==========================
Parte 5 — Excepciones
==========================

EX-01: JWT — 401.
EX-02: Sin permiso — 403.
EX-03: Template invalido — 400.
EX-04: Periodo invalido — 400.
EX-05: BD timeout — failed.
EX-06: Storage caido — failed.
EX-07: Signing fail — 500 (NO procede sin
firma — integridad obligatoria).
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
   - 401/403/400/500
   - middleware/validation/operacion

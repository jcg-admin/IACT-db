.. _uc-alr-01-parte-05:

==========================
Parte 5 — Excepciones
==========================

EX-01: JWT — 401.
EX-02: Sin permiso — 403.
EX-03: Validacion — 400.
EX-04: Cross-segmento — 400.
EX-05: Action invalido — 400.
EX-06: Rule no existe — 404.
EX-07: BD timeout — 503.

Resumen
=======

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - Audit
 * - EX-01..07
   - varios
   - 401/403/400/404/503
   - middleware/validation

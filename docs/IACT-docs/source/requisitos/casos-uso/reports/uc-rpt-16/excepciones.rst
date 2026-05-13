.. _uc-rpt-16-parte-05:

==========================
Parte 5 — Excepciones
==========================

EX-01: JWT — 401.
EX-02: Sin permiso — 403.
EX-03: ivr_id no existe — 404.
EX-04: Cross-segmento — 403.
EX-05: Periodo invalido — 400.
EX-06: BD timeout — 503.

Resumen
=======

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - Audit
 * - EX-01..06
   - varios
   - 401/403/404/400/503
   - middleware/validation

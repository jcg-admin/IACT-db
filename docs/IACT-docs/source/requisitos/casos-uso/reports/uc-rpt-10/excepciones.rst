.. _uc-rpt-10-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT — 401.
5.2 EX-02: Validation — 400.
5.3 EX-03: Nombre duplicado — 400.
5.4 EX-04: Cross-segmento — 400.
5.5 EX-05: > 30 vistas — 429.
5.6 EX-06: Columna invalida — 400.
5.7 EX-07: BD timeout — 503.

5.8 Resumen
===========

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - Audit
 * - EX-01
   - JWT
   - 401
   - middleware
 * - EX-02..06
   - Varias
   - 400 / 429
   - validation
 * - EX-07
   - BD timeout
   - 503
   - operacion FAILED

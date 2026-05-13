.. _uc-rpt-09-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT — 401.
5.2 EX-02: Validation — 400.
5.3 EX-03: Nombre duplicado — 400.
5.4 EX-04: Segmento violation — 400.
5.5 EX-05: > 50 filtros — 429.
5.6 EX-06: Filtro invalid (FA-03) — 400 al aplicar.
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
 * - EX-01..07
   - varias
   - 401/400/429/503
   - validation / middleware

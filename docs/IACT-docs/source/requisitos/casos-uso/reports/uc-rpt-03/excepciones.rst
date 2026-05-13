.. _uc-rpt-03-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT — 401.
5.2 EX-02: Sin permiso — 403 + audit.
5.3 EX-03: Sin segmento — 400.
5.4 EX-04: Periodo invalido — 400.
5.5 EX-05: Range > 2 anos — 400 RANGE_TOO_LARGE.
5.6 EX-06: group_by incompatible — 400.
5.7 EX-07: page_size > 200 — 400.
5.8 EX-08: BD timeout — 503.
5.9 EX-09: Throttling — 429.

5.10 Resumen
============

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
 * - EX-02
   - Sin permiso
   - 403
   - UNAUTHORIZED
 * - EX-03
   - Sin segmento
   - 400
   - validation
 * - EX-04
   - Periodo
   - 400
   - validation
 * - EX-05
   - Range > 2 anos
   - 400
   - validation
 * - EX-06
   - group_by
   - 400
   - validation
 * - EX-07
   - page_size
   - 400
   - validation
 * - EX-08
   - BD timeout
   - 503
   - operacion FAILED
 * - EX-09
   - Rate limit
   - 429
   - middleware

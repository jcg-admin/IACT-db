.. _uc-rpt-08-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT — 401.
5.2 EX-02: Sin permiso — 403.
5.3 EX-03: Schedule no existe — 404.
5.4 EX-04: BD timeout — 503.

5.5 Resumen
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
 * - EX-02
   - Sin permiso
   - 403
   - UNAUTHORIZED
 * - EX-03
   - No existe
   - 404
   - —
 * - EX-04
   - BD timeout
   - 503
   - operacion FAILED

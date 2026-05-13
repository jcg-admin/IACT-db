.. _uc-rpt-07-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT — 401.
5.2 EX-02: Sin schedule_reports — 403.
5.3 EX-03: Sin export_reports — 403.
5.4 EX-04: Cron invalido — 400.
5.5 EX-05: Frecuencia < 1h — 400.
5.6 EX-06: > 10 schedules — 429.
5.7 EX-07: Schedule no existe — 404.
5.8 EX-08: Update con schedule en running — 409.
5.9 EX-09: BD timeout — 503.

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
   - Sin schedule_reports
   - 403
   - UNAUTHORIZED
 * - EX-03
   - Sin export_reports
   - 403
   - UNAUTHORIZED
 * - EX-04
   - Cron invalido
   - 400
   - validation
 * - EX-05
   - Frecuencia
   - 400
   - validation
 * - EX-06
   - > 10
   - 429
   - middleware
 * - EX-07
   - No existe
   - 404
   - —
 * - EX-08
   - Update mientras running
   - 409
   - validation
 * - EX-09
   - BD timeout
   - 503
   - operacion FAILED

.. _uc-rpt-04-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT — 401.
5.2 EX-02: Sin export_reports — 403 + audit.
5.3 EX-03: report_type invalido — 400.
5.4 EX-04: format invalido — 400.
5.5 EX-05: Estimacion > 1M — 400 ROW_LIMIT_EXCEEDED.
5.6 EX-06: > 5 jobs — 429 EXPORT_LIMIT_EXCEEDED.
5.7 EX-07: Worker queue full — 503.
5.8 EX-08: Permiso revocado — failed PERMISSION_REVOKED.
5.9 EX-09: Archivo > 200 MB — failed TOO_LARGE.
5.10 EX-10: Storage caido — failed STORAGE_UNAVAILABLE.
5.11 EX-11: Audit fail — failed AUDIT_FAILED.
5.12 EX-12: BD timeout — failed BD_TIMEOUT.

5.13 Resumen
============

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status / job
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
   - report_type
   - 400
   - validation
 * - EX-04
   - format
   - 400
   - validation
 * - EX-05
   - > 1M
   - 400
   - validation
 * - EX-06
   - > 5 jobs
   - 429
   - middleware
 * - EX-07
   - Queue full
   - 503
   - operacion FAILED
 * - EX-08
   - Permiso revocado
   - failed
   - REPORT_EXPORT_FAILED
 * - EX-09
   - > 200 MB
   - failed
   - REPORT_EXPORT_FAILED
 * - EX-10
   - Storage caido
   - failed
   - REPORT_EXPORT_FAILED
 * - EX-11
   - Audit fail
   - failed
   - operacion FAILED
 * - EX-12
   - BD timeout
   - failed
   - REPORT_EXPORT_FAILED

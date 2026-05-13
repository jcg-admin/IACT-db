.. _uc-acc-04-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido
=========================

401 INVALID_TOKEN (PASO 5).

5.2 EX-02: Sin assign_function_groups
=====================================

403 FORBIDDEN (PASO 6). AuditEvent
UNAUTHORIZED_ACCESS_ATTEMPT.

5.3 EX-03: User no encontrado
=============================

404 USER_NOT_FOUND (PASO 7).

5.4 EX-04: User estado invalido
===============================

400 INVALID_USER_STATE (PASO 7) —
ELIMINATED/BLOCKED.

5.5 EX-05: Auto-asignacion (P-11)
=================================

400 SELF_ASSIGN_FORBIDDEN (PASO 8) si politica
activa. AuditEvent AGR_ASSIGN_FAILED ALERTA.

5.6 EX-06: AGR no existe
========================

400 ACCESS_GROUP_NOT_FOUND (PASO 9).

5.7 EX-07: AGR inactivo
=======================

400 ACCESS_GROUP_INACTIVE (PASO 9).

5.8 EX-08: SoD violation
========================

409 SOD_VIOLATION (PASO 12). All-or-nothing.
AuditEvent AGR_ASSIGN_FAILED.

5.9 EX-09: Payload invalido
===========================

400 VALIDATION_ERROR. Includes expires_at
out of bounds.

5.10 EX-10: BD timeout
======================

503 (PASOS 13-15).

5.11 EX-11: Audit fail
======================

500 AUDIT_FAILED.

5.12 EX-12: Throttling
======================

429 RATE_LIMIT.

5.13 Resumen
============

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - AuditEvent
 * - EX-01
   - Token invalido
   - 401
   - middleware
 * - EX-02
   - Sin permiso
   - 403
   - UNAUTHORIZED ALERTA
 * - EX-03
   - User no existe
   - 404
   - AGR_ASSIGN_FAILED
 * - EX-04
   - User estado invalido
   - 400
   - AGR_ASSIGN_FAILED
 * - EX-05
   - Auto-asignacion
   - 400
   - AGR_ASSIGN_FAILED ALERTA
 * - EX-06
   - AGR no existe
   - 400
   - AGR_ASSIGN_FAILED
 * - EX-07
   - AGR inactivo
   - 400
   - AGR_ASSIGN_FAILED
 * - EX-08
   - SoD violation
   - 409
   - AGR_ASSIGN_FAILED ALERTA
 * - EX-09
   - Payload invalido
   - 400
   - validacion
 * - EX-10
   - BD timeout
   - 503
   - AGR_ASSIGN_FAILED
 * - EX-11
   - Audit fail
   - 500
   - (no se emite)
 * - EX-12
   - Rate limit
   - 429
   - middleware

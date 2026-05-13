.. _uc-perm-06-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido
=========================

401.

5.2 EX-02: Sin manage_access_group_composition
==============================================

403 + AuditEvent UNAUTHORIZED ALERTA.

5.3 EX-03: AGR no existe
========================

404 ACCESS_GROUP_NOT_FOUND.

5.4 EX-04: AGR predefinido
==========================

400 PREDEFINED_NOT_MUTABLE.

5.5 EX-05: AGR RETIRED
======================

400 ACCESS_GROUP_RETIRED.

5.6 EX-06: Function no existe / inactiva
========================================

400 FUNCTION_NOT_FOUND / FUNCTION_INACTIVE.

5.7 EX-07: change_reason invalido
=================================

400 VALIDATION_ERROR.

5.8 EX-08: Cascade SoD violation (default strict)
=================================================

409 CASCADE_SOD_VIOLATION. Body lista
``violating_users`` (sample) + reglas
afectadas. AuditEvent
ACCESS_GROUP_COMPOSITION_FAILED.

5.9 EX-09: BD timeout
=====================

503.

5.10 EX-10: Audit fail
======================

500 AUDIT_FAILED.

5.11 EX-11: Throttling
======================

429.

5.12 Resumen
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
   - AGR no existe
   - 404
   - (sin audit)
 * - EX-04
   - Predefinido
   - 400
   - validation
 * - EX-05
   - RETIRED
   - 400
   - validation
 * - EX-06
   - Function invalida
   - 400
   - validation
 * - EX-07
   - reason invalido
   - 400
   - validation
 * - EX-08
   - Cascade SoD violation
   - 409
   - COMPOSITION_FAILED ALERTA
 * - EX-09
   - BD timeout
   - 503
   - COMPOSITION_FAILED
 * - EX-10
   - Audit fail
   - 500
   - (no se emite)
 * - EX-11
   - Rate limit
   - 429
   - middleware

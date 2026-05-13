.. _uc-perm-05-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido
=========================

401.

5.2 EX-02: Sin manage_access_groups
===================================

403 + AuditEvent UNAUTHORIZED.

5.3 EX-03: AGR no existe (PATCH/DELETE)
=======================================

404 ACCESS_GROUP_NOT_FOUND.

5.4 EX-04: Predefinido no mutable
=================================

400 PREDEFINED_NOT_MUTABLE para
PATCH/DELETE sobre AGR-001..010.

5.5 EX-05: AGR ya RETIRED (PATCH/DELETE)
========================================

400 ACCESS_GROUP_ALREADY_RETIRED.

5.6 EX-06: Code duplicado (CREATE)
==================================

409 CODE_DUPLICATE.

5.7 EX-07: Code formato invalido (CREATE)
=========================================

400 VALIDATION_ERROR. Regex
``^[a-z][a-z0-9_]+_group$``.

5.8 EX-08: retire_reason missing (DELETE)
=========================================

400 VALIDATION_ERROR.

5.9 EX-09: Retiro bloqueado por Users (FA-02 strict)
====================================================

409 RETIRE_HAS_USERS si politica strict.

5.10 EX-10: Code modificable (PATCH)
====================================

400 CODE_IMMUTABLE si PATCH incluye
``code``.

5.11 EX-11: BD timeout
======================

503.

5.12 EX-12: Audit fail
======================

500 AUDIT_FAILED.

5.13 EX-13: Throttling
======================

429.

5.14 Resumen
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
   - UNAUTHORIZED
 * - EX-03
   - AGR no existe
   - 404
   - (sin audit)
 * - EX-04
   - Predefinido no mutable
   - 400
   - (validation)
 * - EX-05
   - Ya RETIRED
   - 400
   - (validation)
 * - EX-06
   - Code duplicado
   - 409
   - CREATE_FAILED
 * - EX-07
   - Code formato
   - 400
   - validation
 * - EX-08
   - retire_reason missing
   - 400
   - validation
 * - EX-09
   - Retire con Users (strict)
   - 409
   - RETIRE_FAILED
 * - EX-10
   - Code immutable PATCH
   - 400
   - validation
 * - EX-11
   - BD timeout
   - 503
   - operacion FAILED
 * - EX-12
   - Audit fail
   - 500
   - (no se emite)
 * - EX-13
   - Rate limit
   - 429
   - middleware

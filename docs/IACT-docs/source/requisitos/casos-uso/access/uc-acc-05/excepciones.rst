.. _uc-acc-05-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido
=========================

401 INVALID_TOKEN.

5.2 EX-02: Sin la funcion correspondiente
=========================================

403 FORBIDDEN. Si lectura: sin
``view_separation_rules``. Si CRUD: sin
``manage_separation_rules``. AuditEvent
UNAUTHORIZED_ACCESS_ATTEMPT.

5.3 EX-03: Regla no existe (lectura/PATCH/DELETE)
=================================================

404 SOD_RULE_NOT_FOUND.

5.4 EX-04: Funcion referenciada no existe (CREATE)
==================================================

400 FUNCTION_NOT_FOUND. Lista
``missing_function_ids``.

5.5 EX-05: Funcion referenciada inactiva (CREATE)
=================================================

400 FUNCTION_INACTIVE.

5.6 EX-06: Regla duplicada (CREATE)
===================================

409 SOD_RULE_DUPLICATE. Body con
``existing_rule_id``.

5.7 EX-07: Regla ya RETIRED (PATCH/DELETE)
==========================================

400 SOD_RULE_ALREADY_RETIRED. Solo se opera
sobre reglas ACTIVE.

5.8 EX-08: retire_reason ausente (DELETE)
=========================================

400 VALIDATION_ERROR
``retire_reason_required``.

5.9 EX-09: Cambio de function_ids prohibido
===========================================

400 FUNCTION_IDS_IMMUTABLE. PATCH no permite
cambiar el conjunto de funciones (politica).
Migracion via RETIRE + CREATE.

5.10 EX-10: BD timeout
======================

503.

5.11 EX-11: Audit fail
======================

500 AUDIT_FAILED.

5.12 EX-12: Throttling
======================

429.

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
   - Sin funcion (read o CRUD)
   - 403
   - UNAUTHORIZED ALERTA
 * - EX-03
   - Regla no existe
   - 404
   - (sin audit lectura)
 * - EX-04
   - Funcion no existe
   - 400
   - SOD_RULE_CREATE_FAILED
 * - EX-05
   - Funcion inactiva
   - 400
   - SOD_RULE_CREATE_FAILED
 * - EX-06
   - Regla duplicada
   - 409
   - SOD_RULE_CREATE_FAILED
 * - EX-07
   - Ya RETIRED
   - 400
   - (validation)
 * - EX-08
   - retire_reason missing
   - 400
   - (validation)
 * - EX-09
   - function_ids immutable
   - 400
   - (validation)
 * - EX-10
   - BD timeout
   - 503
   - SOD_RULE_*_FAILED
 * - EX-11
   - Audit fail
   - 500
   - (no se emite)
 * - EX-12
   - Rate limit
   - 429
   - middleware

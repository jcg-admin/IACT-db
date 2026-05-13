.. _uc-acc-01-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Asignacion exitosa flujo principal
=============================================

**DADO** un invocante con funcion
``assign_functions`` y un User destino ACTIVE
sin ninguna funcion previa,

**CUANDO** envia POST con
``{function_ids:[1,2,3]}``,

**ENTONCES**:

- Status = 201
- 3 ``Assignment`` con
  ``state='ACTIVE'``,
  ``granted_by_admin_id == invoker.id``
- Body ``assigned`` lista las 3 funciones
- Body ``skipped == []``
- 1 ``AuditEvent FUNCTIONS_ASSIGNED`` con
  ``function_ids_assigned == [1,2,3]``
- Cache de permisos del User invalidada

9.2 CA-02: Asignacion temporal con expires_at (FA-02, BR-008)
=============================================================

**DADO** payload con
``expires_at='2026-12-31T23:59:59Z'``,

**ENTONCES**:

- Cada Assignment tiene ``expires_at``
  registrado
- AuditEvent payload incluye expires_at

9.3 CA-03: Idempotencia (FA-01)
===============================

**DADO** User ya tiene Assignment ACTIVE para
function_id=1,

**CUANDO** se envia POST con
``{function_ids:[1]}``,

**ENTONCES**:

- Status = 200 (no 201)
- Body ``assigned == []``,
  ``skipped == [{1, "already_active"}]``
- AuditEvent FUNCTIONS_ASSIGN_NOOP

9.4 CA-04: Mix nuevas + ya activas (FA-03)
==========================================

**DADO** User con function_id=1 ACTIVE,

**CUANDO** POST con
``{function_ids:[1,2]}``,

**ENTONCES**:

- Status = 201
- Body ``assigned == [{2, ...}]``,
  ``skipped == [{1, "already_active"}]``

9.5 CA-05: SoD violation bloquea (EX-08)
========================================

**DADO** SoDRule activa que prohibe coexistencia
de function_id=1 (modify_users) con
function_id=42 (audit_users), y User ya tiene
function_id=1 ACTIVE,

**CUANDO** POST con ``{function_ids:[42]}``,

**ENTONCES**:

- Status = 409
- Body ``error == 'SOD_VIOLATION'``
- Body contiene ``rule_id``,
  ``conflict_pair``
- ``Assignment`` no creado (rollback)
- AuditEvent FUNCTIONS_ASSIGN_FAILED
  ``reason='sod_violation'``

9.6 CA-06: SoD all-or-nothing
=============================

**DADO** payload con 3 funciones donde la 2ª
viola SoD,

**ENTONCES**:

- Status = 409 (rollback total)
- Cero Assignments creados (incluyendo la 1ª y
  3ª que individualmente eran validas)

9.7 CA-07: Auto-asignacion prohibida (EX-05, P-11)
==================================================

**DADO** politica
``ANTI_SELF_ASSIGN_FUNCTIONS=true`` y invoker
con assign_functions,

**CUANDO** POST sobre su propio user_id,

**ENTONCES**:

- Status = 400
- Body ``error == 'SELF_ASSIGN_FORBIDDEN'``
- AuditEvent FUNCTIONS_ASSIGN_FAILED ALERTA

9.8 CA-08: Sin permiso 403 (EX-02)
==================================

**DADO** invoker sin ``assign_functions``,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT
- Sin cambios en BD

9.9 CA-09: User no existe 404 (EX-03)
=====================================

**DADO** ``user_id`` inexistente,

**ENTONCES**:

- Status = 404 USER_NOT_FOUND

9.10 CA-10: User ELIMINATED rechaza (EX-04)
===========================================

**DADO** User con state ELIMINATED,

**ENTONCES**:

- Status = 400 INVALID_USER_STATE

9.11 CA-11: Funcion no existe (EX-06)
=====================================

**DADO** ``function_ids:[99999]`` (no existe),

**ENTONCES**:

- Status = 400 FUNCTION_NOT_FOUND
- Body lista los ``missing_ids``

9.12 CA-12: Funcion inactiva (EX-07)
====================================

**DADO** function existe con state INACTIVE,

**ENTONCES**:

- Status = 400 FUNCTION_INACTIVE

9.13 CA-13: Atomicidad ante falla audit (EX-10)
===============================================

**DADO** falla simulada en INSERT AuditEvent,

**ENTONCES**:

- Status = 500
- Cero Assignments creados (rollback)
- Cache no invalidada

9.14 CA-14: Cache invalidada post-COMMIT
========================================

**DADO** asignacion exitosa,

**CUANDO** target_user envia request
inmediatamente despues,

**ENTONCES**:

- Sus permisos efectivos reflejan las nuevas
  funciones (cache miss → recompute)

9.15 CA-15: Audit sin PII (CNST-026)
====================================

**DADO** AuditEvent FUNCTIONS_ASSIGNED,

**ENTONCES**:

- Payload no contiene email, full_name del
  User destino
- Payload contiene IDs y codigos de funciones

9.16 CA-16: Audit inmutable (CNST-025)
======================================

**DADO** AuditEvent emitido,

**ENTONCES**:

- BD rechaza UPDATE/DELETE

9.17 CA-17: expires_at validation (FA-02)
=========================================

**DADO** ``expires_at < NOW() + 1 hora``,

**ENTONCES**:

- Status = 400 VALIDATION_ERROR

9.18 CA-18: expires_at upper bound
==================================

**DADO** ``expires_at > NOW() + 1 anio``,

**ENTONCES**:

- Status = 400 VALIDATION_ERROR

9.19 CA-19: Performance P50 (1-3 funciones)
===========================================

**DADO** payload con 1-3 funciones y SoDRules
< 50,

**ENTONCES**:

- P50 ≤ 200 ms

9.20 CA-20: Throttling (EX-11)
==============================

**DADO** invoker > 30 POST/min,

**ENTONCES**:

- Status = 429

9.21 CA-21: Re-asignacion post-revocacion (FA-06)
=================================================

**DADO** Assignment(user, function, REVOKED) por
UC_ACC_02 previo,

**CUANDO** UC_ACC_01 con esa funcion,

**ENTONCES**:

- Status = 201
- NUEVO Assignment con state ACTIVE
- Assignment REVOKED previo preservado
  (historial)

9.22 CA-22: Frontend boton oculto sin la funcion
================================================

**DADO** invoker sin ``assign_functions``,

**CUANDO** abre detalle de User,

**ENTONCES**:

- Boton "Asignar funciones" no visible

9.23 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01
   - Asignacion exitosa
   - Funcional
 * - CA-02
   - Temporal con expires_at
   - Funcional / BR-008
 * - CA-03..04
   - Idempotencia parcial / total
   - Funcional / FA-01, FA-03
 * - CA-05..06
   - SoD violacion + all-or-nothing
   - Cumplimiento / CNST-005
 * - CA-07
   - Auto-asignacion prohibida (P-11)
   - Seguridad
 * - CA-08
   - Sin permiso → 403
   - Seguridad
 * - CA-09..10
   - User estado invalido / no existe
   - Funcional
 * - CA-11..12
   - Funcion no existe / inactiva
   - Funcional
 * - CA-13
   - Atomicidad
   - Confiabilidad
 * - CA-14
   - Cache invalidada post-COMMIT
   - Confiabilidad / Performance
 * - CA-15..16
   - Audit (sin PII + inmutable)
   - Cumplimiento
 * - CA-17..18
   - Bounds expires_at
   - Funcional
 * - CA-19
   - Performance P50
   - Performance
 * - CA-20
   - Rate limit
   - Seguridad
 * - CA-21
   - Re-asignacion post-revoke
   - Funcional / historial
 * - CA-22
   - UI boton oculto
   - Usabilidad / seguridad

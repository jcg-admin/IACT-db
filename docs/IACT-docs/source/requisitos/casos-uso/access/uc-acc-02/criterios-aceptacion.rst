.. _uc-acc-02-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Revocacion exitosa flujo principal
=============================================

**DADO** invocante con ``revoke_functions`` y
target con Assignments ACTIVE para function_ids
1, 2,

**CUANDO** envia DELETE con
``{function_ids:[1,2], revoke_reason:"X"}``,

**ENTONCES**:

- Status = 200
- Ambos Assignments con
  ``state='REVOKED'``,
  ``revoked_at`` no NULL,
  ``revoked_by_admin_id == invoker.id``,
  ``revoke_reason == "X"``
- AuditEvent FUNCTIONS_REVOKED con
  ``function_ids_revoked == [1,2]``
- Cache de permisos invalidada (post-COMMIT)

9.2 CA-02: Soft-delete (BR-009)
===============================

**DADO** revocacion exitosa,

**ENTONCES**:

- Assignments NO eliminados fisicamente
- ``Assignment.objects.filter(id=...).exists()
  == true`` (preservados)
- ``granted_at``, ``granted_by_admin_id``
  preservados (historial)

9.3 CA-03: revoke_reason obligatorio (EX-06)
============================================

**DADO** payload sin ``revoke_reason``,

**ENTONCES**:

- Status = 400 VALIDATION_ERROR
- Sin cambios en BD

9.4 CA-04: Idempotencia total (FA-01)
=====================================

**DADO** todas las funciones del payload ya
REVOKED o no existen como ACTIVE,

**ENTONCES**:

- Status = 200
- Body ``revoked == []``,
  ``skipped`` lista todas
- AuditEvent FUNCTIONS_REVOKE_NOOP

9.5 CA-05: Mix activas + ya revocadas
=====================================

**DADO** function_id 1 ACTIVE y function_id 2 ya
REVOKED,

**CUANDO** payload incluye ambas,

**ENTONCES**:

- Status = 200
- ``revoked == [{1, ...}]``
- ``skipped == [{2, "not_active"}]``
- 1 Assignment REVOKED nuevo (function_id=1)

9.6 CA-06: Auto-revocacion prohibida (EX-04, P-11)
==================================================

**DADO** politica
``ANTI_SELF_REVOKE_FUNCTIONS=true`` y invoker
con ``revoke_functions``,

**CUANDO** DELETE sobre su propio user_id,

**ENTONCES**:

- Status = 400 SELF_REVOKE_FORBIDDEN
- AuditEvent FUNCTIONS_REVOKE_FAILED ALERTA

9.7 CA-07: Sin permiso 403 (EX-02)
==================================

**DADO** invoker sin ``revoke_functions``,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT

9.8 CA-08: User no existe 404 (EX-03)
=====================================

**DADO** user_id inexistente,

**ENTONCES**:

- Status = 404 USER_NOT_FOUND

9.9 CA-09: User ELIMINATED 400 (EX-05)
======================================

**DADO** target con state ELIMINATED,

**ENTONCES**:

- Status = 400 INVALID_USER_STATE

9.10 CA-10: Warning no_functions (FA-03)
========================================

**DADO** target con solo 2 funciones ACTIVE,

**CUANDO** se revocan ambas,

**ENTONCES**:

- Status = 200
- ``warnings.no_functions == true``
- ``post_revoke_active_count == 0``

9.11 CA-11: Warning critical_revoked (FA-02)
============================================

**DADO** se revoca funcion en
``CRITICAL_FUNCTIONS``,

**ENTONCES**:

- Status = 200
- ``warnings.critical_revoked`` lista la
  funcion critica

9.12 CA-12: Warning last_holder (FA-04 default)
===============================================

**DADO** target es el ultimo holder de
``configure_sod`` y politica default
(warn-only),

**ENTONCES**:

- Status = 200
- ``warnings.last_holder`` lista la funcion
  con ``remaining_holders_after == 0``

9.13 CA-13: Last holder bloqueado strict (EX-09)
================================================

**DADO** politica
``BLOCK_LAST_HOLDER_REVOKE=true`` y target es
ultimo holder de funcion critica,

**ENTONCES**:

- Status = 409 LAST_HOLDER_PROTECTION
- Sin cambios en BD

9.14 CA-14: Atomicidad ante audit fail (EX-08)
==============================================

**DADO** AuditLog.emit lanza,

**ENTONCES**:

- Status = 500
- Assignments preservados (rollback)
- Cache no invalidada

9.15 CA-15: Cache invalidada post-COMMIT
========================================

**DADO** revocacion exitosa,

**CUANDO** target hace request inmediato,

**ENTONCES**:

- Sus permisos efectivos NO incluyen las
  funciones revocadas (cache miss → recompute)

9.16 CA-16: Audit sin PII (CNST-026)
====================================

**DADO** AuditEvent FUNCTIONS_REVOKED,

**ENTONCES**:

- Payload sin email, full_name del User
- Payload con IDs, codigos y revoke_reason

9.17 CA-17: Audit inmutable (CNST-025)
======================================

**DADO** AuditEvent emitido,

**ENTONCES**:

- BD rechaza UPDATE/DELETE

9.18 CA-18: Performance P50
===========================

**DADO** carga normal (1-3 funciones),

**ENTONCES**:

- P50 ≤ 150 ms

9.19 CA-19: Throttling (EX-10)
==============================

**DADO** invoker con > 30 DELETE/min,

**ENTONCES**:

- Status = 429

9.20 CA-20: notify_user respetado
=================================

**DADO** payload con ``notify_user=false``,

**ENTONCES**:

- Sin InternalMessage creado para target
- Body ``user_notified == false``

9.21 CA-21: Re-asignacion despues de revocar (FA-06 UC_ACC_01)
==============================================================

**DADO** UC_ACC_02 revoca function_id=1,

**CUANDO** UC_ACC_01 asigna function_id=1,

**ENTONCES**:

- Nuevo Assignment ACTIVE creado
- Assignment REVOKED previo preservado en BD
  (historial)

9.22 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01
   - Revocacion exitosa
   - Funcional
 * - CA-02
   - Soft-delete (BR-009)
   - Cumplimiento
 * - CA-03
   - revoke_reason obligatorio
   - Auditabilidad
 * - CA-04..05
   - Idempotencia total / mix
   - Funcional
 * - CA-06
   - Auto-revocacion prohibida (P-11)
   - Seguridad
 * - CA-07..09
   - Excepciones permisos / state / no
     existe
   - Seguridad / Funcional
 * - CA-10..12
   - Warnings (no_functions, critical,
     last_holder)
   - Auditabilidad / UX
 * - CA-13
   - Last holder bloqueado strict
   - Seguridad
 * - CA-14
   - Atomicidad
   - Confiabilidad
 * - CA-15
   - Cache post-COMMIT
   - Confiabilidad
 * - CA-16..17
   - Audit (sin PII + inmutable)
   - Cumplimiento
 * - CA-18
   - Performance
   - Performance
 * - CA-19
   - Rate limit
   - Seguridad
 * - CA-20
   - notify_user flag respetado
   - UX
 * - CA-21
   - Re-asignacion preservando historial
   - Funcional

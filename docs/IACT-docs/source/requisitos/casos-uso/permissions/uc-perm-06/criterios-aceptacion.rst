.. _uc-perm-06-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Add functions exitoso
================================

**DADO** invoker con permiso + AGR custom
ACTIVE,

**CUANDO** POST con
``add_function_ids: [10, 15]``,

**ENTONCES**:

- Status = 200
- 2 AccessGroupFunction creados
- AuditEvent COMPOSITION_CHANGED

9.2 CA-02: Remove functions exitoso
===================================

**DADO** AGR con functions [10, 15] + POST
con ``remove: [10]``,

**ENTONCES**:

- 1 AccessGroupFunction eliminado
- AGR queda con [15]

9.3 CA-03: Add + Remove combinado
=================================

**DADO** payload con add y remove no
vacios,

**ENTONCES**:

- Ambos cambios aplicados atomicamente
- Response detalla added + removed

9.4 CA-04: Idempotencia parcial (FA-03)
=======================================

**DADO** add con function ya en AGR,

**ENTONCES**:

- skipped_add la incluye

9.5 CA-05: AGR no existe 404
============================

**DADO** agr_id inexistente,

**ENTONCES**:

- Status = 404

9.6 CA-06: AGR predefinido bloqueado
====================================

**DADO** AGR-006 predefinido,

**ENTONCES**:

- Status = 400 PREDEFINED_NOT_MUTABLE

9.7 CA-07: AGR RETIRED bloqueado
================================

**DADO** AGR custom RETIRED,

**ENTONCES**:

- Status = 400 ACCESS_GROUP_RETIRED

9.8 CA-08: Function invalida 400
================================

**DADO** function_id no existe / inactiva,

**ENTONCES**:

- Status = 400

9.9 CA-09: change_reason obligatoria
====================================

**DADO** payload sin reason,

**ENTONCES**:

- Status = 400 VALIDATION_ERROR

9.10 CA-10: Cascade SoD strict (EX-08)
======================================

**DADO** politica strict + cambio crearia
SoD violation para algun User,

**ENTONCES**:

- Status = 409 CASCADE_SOD_VIOLATION
- Body lista violating_users sample

9.11 CA-11: Cascade SoD permissive (FA-04)
==========================================

**DADO** politica permissive + violacion,

**ENTONCES**:

- Status = 200 con warning
- AuditEvent registra violations count

9.12 CA-12: Cascade audit count
===============================

**DADO** AGR con N Users,

**ENTONCES**:

- AuditEvent.cascade_affected_user_count
  == N

9.13 CA-13: Sin permiso 403
===========================

**DADO** invoker sin
``manage_access_group_composition``,

**ENTONCES**:

- Status = 403 + AuditEvent UNAUTHORIZED

9.14 CA-14: Cache invalidate cascade
====================================

**DADO** cambio exitoso,

**ENTONCES**:

- PermissionCache.invalidate llamado
  para cada User con AGR (post-COMMIT)

9.15 CA-15: Atomicidad ante audit fail
======================================

**DADO** AuditLog.emit lanza,

**ENTONCES**:

- Status = 500
- AccessGroupFunction sin cambios
  (rollback)

9.16 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..03
   - Add / Remove / Combinado
   - Funcional
 * - CA-04
   - Idempotencia parcial
   - Funcional
 * - CA-05..08
   - AGR / Function invalidos
   - Funcional
 * - CA-09
   - change_reason obligatoria
   - Auditabilidad
 * - CA-10..11
   - Cascade SoD strict / permissive
   - Cumplimiento
 * - CA-12
   - Cascade audit count
   - Auditabilidad
 * - CA-13
   - Sin permiso
   - Seguridad
 * - CA-14
   - Cache cascade
   - Confiabilidad
 * - CA-15
   - Atomicidad
   - Confiabilidad

.. _uc-perm-05-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Crear AGR
====================

**DADO** invoker con manage_access_groups +
payload valido,

**ENTONCES**:

- Status = 201
- AccessGroup creado con state=ACTIVE,
  is_predefined=false
- AuditEvent ACCESS_GROUP_CREATED

9.2 CA-02: Code duplicado 409
=============================

**DADO** code ya existe en catalogo,

**ENTONCES**:

- Status = 409 CODE_DUPLICATE

9.3 CA-03: Code formato invalido
================================

**DADO** code no matching regex,

**ENTONCES**:

- Status = 400 VALIDATION_ERROR

9.4 CA-04: Crear con composicion (FA-01)
========================================

**DADO** payload con
``initial_function_ids``,

**ENTONCES**:

- AGR creado
- AccessGroupFunction inserted (delegado
  UC_PERM_06)

9.5 CA-05: Modificar PATCH parcial
==================================

**DADO** PATCH con display_name,

**ENTONCES**:

- Solo display_name actualizado
- AuditEvent ACCESS_GROUP_MODIFIED

9.6 CA-06: Code immutable
=========================

**DADO** PATCH con code,

**ENTONCES**:

- Status = 400 CODE_IMMUTABLE

9.7 CA-07: Predefinido no mutable
=================================

**DADO** PATCH/DELETE sobre AGR
predefinido,

**ENTONCES**:

- Status = 400 PREDEFINED_NOT_MUTABLE

9.8 CA-08: Retirar exitoso
==========================

**DADO** AGR custom ACTIVE + retire_reason,

**ENTONCES**:

- Status = 200
- state = RETIRED
- AuditEvent ACCESS_GROUP_RETIRED con
  ``users_with_agr_count``

9.9 CA-09: retire_reason obligatoria
====================================

**DADO** DELETE sin reason,

**ENTONCES**:

- Status = 400 VALIDATION_ERROR

9.10 CA-10: Ya RETIRED no operable
==================================

**DADO** AGR state=RETIRED,

**ENTONCES**:

- PATCH/DELETE = 400 ACCESS_GROUP_ALREADY_RETIRED

9.11 CA-11: Retirar con Users default warn
==========================================

**DADO** count > 0 + politica default,

**ENTONCES**:

- Status = 200 con warning
- response incluye ``users_with_agr_count``

9.12 CA-12: Retirar con Users strict block
==========================================

**DADO** count > 0 + politica strict,

**ENTONCES**:

- Status = 409 RETIRE_HAS_USERS

9.13 CA-13: Sin permiso 403
===========================

**DADO** invoker sin manage_access_groups,

**ENTONCES**:

- Status = 403 + AuditEvent UNAUTHORIZED

9.14 CA-14: Retirar preserva Assignments
========================================

**DADO** retiro exitoso de AGR con Users,

**ENTONCES**:

- Assignments con ese AGR permanecen
  ACTIVE (preservados — politica)

9.15 CA-15: AuditEvent inmutable + sin PII
==========================================

CNST-025 + CNST-026.

9.16 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..04
   - Crear (happy + duplicado + formato +
     con composicion)
   - Funcional
 * - CA-05..06
   - Modificar (PATCH + code immutable)
   - Funcional
 * - CA-07
   - Predefinido no mutable
   - Cumplimiento
 * - CA-08..12
   - Retirar (happy + reason + already +
     warn + strict)
   - Funcional / Auditabilidad
 * - CA-13
   - Sin permiso
   - Seguridad
 * - CA-14
   - Assignments preservados
   - Cumplimiento
 * - CA-15
   - Audit + sin PII
   - Cumplimiento

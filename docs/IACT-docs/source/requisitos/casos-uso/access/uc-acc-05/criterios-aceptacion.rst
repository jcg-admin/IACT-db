.. _uc-acc-05-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Listado paginado (sub-flujo 3.A)
===========================================

**DADO** invoker con
``view_separation_rules`` y 12 reglas
ACTIVE,

**ENTONCES**:

- Status = 200
- count = 12
- results paginados

9.2 CA-02: Detalle por id
=========================

**DADO** GET ``/api/access/sod-rules/{id}/``,

**ENTONCES**:

- Status = 200
- Body con datos completos de la regla

9.3 CA-03: Crear regla (sub-flujo 3.B)
======================================

**DADO** invoker con
``manage_separation_rules`` y payload valido,

**ENTONCES**:

- Status = 201
- Nueva SoDRule con state=ACTIVE
- AuditEvent SOD_RULE_CREATED
- Cache invalidada post-COMMIT

9.4 CA-04: Crear regla duplicada 409 (EX-06)
============================================

**DADO** ya existe regla ACTIVE con mismas
functions,

**ENTONCES**:

- Status = 409 SOD_RULE_DUPLICATE
- Body con ``existing_rule_id``

9.5 CA-05: Crear con violaciones existentes (FA-03)
===================================================

**DADO** Users tienen el par conflictivo,

**ENTONCES**:

- Status = 201 (no se bloquea)
- Body ``existing_violations_count > 0``
- Sample de ``violating_user_ids``

9.6 CA-06: Funcion no existe (EX-04)
====================================

**DADO** payload con function_id inexistente,

**ENTONCES**:

- Status = 400 FUNCTION_NOT_FOUND

9.7 CA-07: Modificar PATCH parcial (sub-flujo 3.C)
==================================================

**DADO** PATCH con solo ``display_name``,

**ENTONCES**:

- Status = 200
- ``display_name`` actualizado, otros
  preservados

9.8 CA-08: Modificar function_ids prohibido (EX-09)
===================================================

**DADO** PATCH con ``function_ids``,

**ENTONCES**:

- Status = 400 FUNCTION_IDS_IMMUTABLE

9.9 CA-09: Retirar regla (sub-flujo 3.D)
========================================

**DADO** DELETE con retire_reason valido,

**ENTONCES**:

- Status = 200
- ``state == RETIRED``
- ``retired_at``, ``retired_by_admin_id``,
  ``retire_reason`` registrados
- AuditEvent SOD_RULE_RETIRED
- Cache invalidada

9.10 CA-10: retire_reason obligatorio (EX-08)
=============================================

**DADO** DELETE sin retire_reason,

**ENTONCES**:

- Status = 400 VALIDATION_ERROR

9.11 CA-11: Retirar ya RETIRED (EX-07)
======================================

**DADO** regla con state=RETIRED,

**WHEN** DELETE,

**ENTONCES**:

- Status = 400 SOD_RULE_ALREADY_RETIRED

9.12 CA-12: Sin permiso lectura/CRUD (EX-02)
============================================

**DADO** invoker sin las funciones,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED

9.13 CA-13: Cache invalidate post-COMMIT
========================================

**DADO** create/modify/retire exitoso,

**ENTONCES**:

- Cache invalidate llamado DESPUES del COMMIT
- UC_ACC_01/04 next request recargan reglas

9.14 CA-14: Audit selectivo P-16 (FA-02)
========================================

**DADO** GET con filter rule_id,

**ENTONCES**:

- AuditEvent SOD_RULES_VIEWED con
  ``payload.target_rule_id``

9.15 CA-15: Audit listado amplio NO se emite
============================================

**DADO** GET sin filter rule_id,

**ENTONCES**:

- ZERO AuditEvent SOD_RULES_VIEWED

9.16 CA-16: Atomicidad ante audit fail
======================================

**DADO** AuditLog.emit lanza,

**ENTONCES**:

- Status = 500
- Sin cambios en SoDRule
- Cache no invalidada

9.17 CA-17: Audit inmutable (CNST-025)
======================================

**DADO** AuditEvent emitido,

**ENTONCES**:

- BD rechaza UPDATE/DELETE

9.18 CA-18: Audit sin PII (CNST-026)
====================================

**DADO** AuditEvent SOD_RULE_*,

**ENTONCES**:

- Payload sin email/full_name de admin
- Solo IDs y metadata de regla

9.19 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..02
   - Listado + detalle
   - Funcional
 * - CA-03..06
   - Crear (happy + duplicada + violations
     + funcion invalida)
   - Funcional / Cumplimiento
 * - CA-07..08
   - Modificar + immutable function_ids
   - Funcional
 * - CA-09..11
   - Retirar (happy + reason + already)
   - Funcional / Auditabilidad
 * - CA-12
   - Sin permiso
   - Seguridad
 * - CA-13
   - Cache post-COMMIT
   - Confiabilidad
 * - CA-14..15
   - Audit selectivo
   - Auditabilidad
 * - CA-16
   - Atomicidad
   - Confiabilidad
 * - CA-17..18
   - Audit (inmutable + sin PII)
   - Cumplimiento

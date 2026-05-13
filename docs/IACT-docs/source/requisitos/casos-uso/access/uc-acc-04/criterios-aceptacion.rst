.. _uc-acc-04-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Asignacion exitosa
=============================

**DADO** invoker con ``assign_function_groups``,
target ACTIVE, AGR con 8 funciones,

**CUANDO** POST con ``access_group_id``,

**ENTONCES**:

- Status = 201
- Assignment con
  ``target_type='AccessGroup'``,
  ``target_id=agr.id``,
  ``state='ACTIVE'``
- Body ``functions_count_added == 8``
  (asumiendo ninguna ya directa)
- AuditEvent AGR_ASSIGNED

9.2 CA-02: Idempotencia (FA-01)
===============================

**DADO** AGR ya asignado,

**ENTONCES**:

- Status = 200
- Body ``already_assigned == true``
- AuditEvent AGR_ASSIGN_NOOP

9.3 CA-03: SoD violation 409 (EX-08)
====================================

**DADO** AGR contiene funcion que viola SoD
con functions actuales del User,

**ENTONCES**:

- Status = 409 SOD_VIOLATION
- Sin Assignment creado

9.4 CA-04: Subset ya directo (FA-05)
====================================

**DADO** AGR de 8 funciones, User ya tiene 2
de ellas directas,

**ENTONCES**:

- Status = 201
- Body ``functions_count_added == 6``
- Body ``functions_already_present_count == 2``

9.5 CA-05: Auto-asignacion 400 (EX-05)
======================================

**DADO** politica anti-self activa,

**CUANDO** invoker se asigna AGR a si mismo,

**ENTONCES**:

- Status = 400 SELF_ASSIGN_FORBIDDEN
- Audit ALERTA

9.6 CA-06: AGR no existe 400 (EX-06)
====================================

**DADO** ``access_group_id`` inexistente,

**ENTONCES**:

- Status = 400 ACCESS_GROUP_NOT_FOUND

9.7 CA-07: AGR inactivo 400 (EX-07)
===================================

**DADO** AGR con state=INACTIVE,

**ENTONCES**:

- Status = 400 ACCESS_GROUP_INACTIVE

9.8 CA-08: Sin permiso 403 (EX-02)
==================================

**DADO** invoker sin
``assign_function_groups``,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED

9.9 CA-09: Asignacion temporal (FA-02)
======================================

**DADO** ``expires_at`` valido,

**ENTONCES**:

- Assignment creado con expires_at

9.10 CA-10: Cache invalidada post-COMMIT
========================================

**DADO** asignacion exitosa,

**ENTONCES**:

- Cache invalidada DESPUES del COMMIT

9.11 CA-11: Atomicidad (rollback ante audit fail)
=================================================

**DADO** AuditLog.emit lanza,

**ENTONCES**:

- Status = 500
- Sin Assignment creado

9.12 CA-12: Audit sin PII (CNST-026)
====================================

**DADO** AuditEvent emitido,

**ENTONCES**:

- Payload sin email/full_name
- Contiene IDs y codigos

9.13 CA-13: Re-asignacion post revoke (FA-04)
=============================================

**DADO** Assignment(user, AGR, REVOKED),

**CUANDO** UC_ACC_04 con ese AGR,

**ENTONCES**:

- Nuevo Assignment ACTIVE
- REVOKED previo preservado

9.14 CA-14: Performance P50
===========================

**DADO** AGR con < 10 funciones,

**ENTONCES**:

- P50 ≤ 250 ms

9.15 CA-15: Throttling
======================

**DADO** > 30 POST/min,

**ENTONCES**:

- Status = 429

9.16 Resumen
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
   - Idempotencia
   - Funcional
 * - CA-03
   - SoD violation
   - Cumplimiento
 * - CA-04
   - Subset ya directo
   - Funcional
 * - CA-05
   - Auto-asignacion (P-11)
   - Seguridad
 * - CA-06..07
   - AGR no existe / inactivo
   - Funcional
 * - CA-08
   - Sin permiso
   - Seguridad
 * - CA-09
   - Asignacion temporal
   - Funcional / BR-008
 * - CA-10..11
   - Cache + atomicidad
   - Confiabilidad
 * - CA-12
   - Audit sin PII
   - Cumplimiento
 * - CA-13
   - Re-asignacion preservando historial
   - Funcional
 * - CA-14
   - Performance
   - Performance
 * - CA-15
   - Throttling
   - Seguridad

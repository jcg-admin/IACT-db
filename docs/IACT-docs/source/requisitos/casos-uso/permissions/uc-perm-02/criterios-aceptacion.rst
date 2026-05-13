.. _uc-perm-02-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CAs heredados de UC_ACC_02
==============================

CA-01..21 de UC_ACC_02 aplican identicos
sobre Assignment AGR:

- Revocacion exitosa, soft-delete (BR-009),
  revoke_reason obligatoria, idempotencia,
  auto-revocacion P-11, sin permiso, user
  no existe / state, warnings, last holder,
  atomicidad, audit, performance, throttling.

9.2 CAs especificos PERM
========================

9.2.1 CA-PERM-01: AGR no asignado 404
-------------------------------------

**DADO** AGR nunca fue asignado al User,

**ENTONCES**:

- Status = 404 AGR_NOT_ASSIGNED

9.2.2 CA-PERM-02: Modal expandido muestra functions
---------------------------------------------------

**DADO** invoker abre modal de revocacion,

**ENTONCES**:

- Modal lista las functions efectivamente
  revocadas (display_names)

9.2.3 CA-PERM-03: Doble confirmacion ante warnings
--------------------------------------------------

**DADO** preview muestra
``warnings.critical_revoked`` no vacio,

**CUANDO** invoker click "Revocar",

**ENTONCES**:

- Modal pide escribir "REVOCAR" literal
- Si no escribe, boton confirmar
  deshabilitado

9.2.4 CA-PERM-04: Preview NO persiste
-------------------------------------

**DADO** preview-revoke ejecutado,

**ENTONCES**:

- Status = 200 con preview
- ZERO Assignment cambiado
- ZERO AuditEvent

9.2.5 CA-PERM-05: Refresh catalogo
----------------------------------

**DADO** revocacion exitosa,

**ENTONCES**:

- Catalogo PERM refleja
  ``users_count -= 1`` para el AGR

9.2.6 CA-PERM-06: Audit unificado ACC/PERM
==========================================

**DADO** revocaciones via ambas vistas,

**ENTONCES**:

- Ambos AuditEvents con
  ``event_type='AGR_REVOKED'``
- payload no distingue origen UI

9.3 Resumen
===========

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..21
   - Heredados UC_ACC_02
   - Funcional / cumplimiento
 * - CA-PERM-01
   - 404 AGR_NOT_ASSIGNED
   - Funcional
 * - CA-PERM-02
   - Modal expandido
   - UX
 * - CA-PERM-03
   - Doble confirmacion warnings
   - Seguridad UX
 * - CA-PERM-04
   - Preview NO persiste
   - Funcional
 * - CA-PERM-05
   - Refresh catalogo
   - UX consistencia
 * - CA-PERM-06
   - Audit unificado
   - Cumplimiento

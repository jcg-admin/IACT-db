.. _uc-perm-01-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

.. note::

 CAs backend heredados de UC_ACC_04 Parte 9
 (CA-01..15). Esta parte documenta CAs
 especificos de la vista PERM.

9.1 CAs heredados de UC_ACC_04
==============================

CA-01..15 de UC_ACC_04 aplican identicos:

- Asignacion exitosa, idempotencia, SoD,
  subset, auto-asignacion, AGR no existe /
  inactivo, sin permiso, expires_at,
  cache, atomicidad, audit sin PII,
  re-asignacion post revoke, performance,
  throttling.

9.2 CAs especificos de la vista PERM
====================================

9.2.1 CA-PERM-01: Catalogo lista AGRs
-------------------------------------

**DADO** invoker con permiso de lectura
RBAC,

**CUANDO** GET ``/api/access-groups/``,

**ENTONCES**:

- Status = 200
- Body con AGRs (predefinidos + custom),
  function_count, users_count

9.2.2 CA-PERM-02: Modal muestra composicion
-------------------------------------------

**DADO** invoker selecciona AGR,

**CUANDO** clickea "Asignar",

**ENTONCES**:

- Modal lista las funciones del AGR
  (display_names, no IDs internos)

9.2.3 CA-PERM-03: Preview NO persiste
-------------------------------------

**DADO** invoker pide preview-assign,

**ENTONCES**:

- Status = 200 con preview data
- ZERO Assignment creado
- ZERO AuditEvent generado

9.2.4 CA-PERM-04: Catalogo refresh post-asignacion
--------------------------------------------------

**DADO** asignacion exitosa,

**CUANDO** UI re-renderiza catalogo,

**ENTONCES**:

- ``users_count`` del AGR incrementado en 1

9.2.5 CA-PERM-05: Audit no distingue origen UI
==============================================

**DADO** asignacion via vista PERM,

**ENTONCES**:

- AuditEvent.event_type ==
  ``AGR_ASSIGNED`` (mismo que via ACC)
- payload NO contiene origen UI (
  irrelevante)

9.2.6 CA-PERM-06: Boton oculto sin permiso
==========================================

**DADO** invoker sin
``assign_function_groups``,

**ENTONCES**:

- Boton "Asignar" en catalogo no visible

9.3 Resumen
===========

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..15
   - Heredados UC_ACC_04
   - Funcional / segun cada uno
 * - CA-PERM-01
   - Catalogo lista AGRs
   - UX
 * - CA-PERM-02
   - Modal composicion
   - UX
 * - CA-PERM-03
   - Preview NO persiste
   - Funcional
 * - CA-PERM-04
   - Catalogo refresh
   - UX consistencia
 * - CA-PERM-05
   - Audit unificado
   - Cumplimiento
 * - CA-PERM-06
   - Boton oculto
   - Seguridad UX

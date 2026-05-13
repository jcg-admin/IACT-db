.. _uc-perm-01-parte-01:

============================================
Parte 1 — Informacion general de UC_PERM_01
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_PERM_01
 * - **Nombre**
   - Asignar Grupo a Usuario (vista PERM)
 * - **Version spec**
   - 5.0.0
 * - **Modulo**
   - MOD_Permissions (vista alternativa)
 * - **UC backing**
   - UC_ACC_04 (vista funcional)
 * - **WP**
   - ``2026-05-01-18-50-27-uc-perm-01-spec-completa``

1.2 Proposito
=============

UC_PERM_01 cubre la asignacion de grupos de
permisos (AGRs) a usuarios desde la
**perspectiva del modulo Permissions**. Es vista
alternativa de UC_ACC_04 — la operacion
subyacente, validaciones, side-effects y
restricciones son IDENTICAS.

**Razon de la coexistencia ACC ↔ PERM**
(ADR-GOB-008):

- **MOD_Access**: vista operacional del flujo
  de asignacion (admin de usuarios diariamente
  asigna AGRs a sus operadores).
- **MOD_Permissions**: vista de gobierno del
  catalogo de permisos (admin de seguridad
  define/audita la estructura RBAC y otorga
  AGRs en compliance reviews).

Ambas vistas usan la **misma funcion canonica**
``assign_function_groups`` y el mismo
endpoint backend. La diferencia es el enfoque
de la UI y la audiencia.

1.3 Alcance
===========

1.3.1 IN
--------

- Asignacion de un AGR a un User
  (delegado a UC_ACC_04 backing).
- Vista UI orientada al catalogo: explorar
  AGRs, ver composicion, asignar.
- Reportes de cobertura RBAC (que Users
  tienen tal AGR).

1.3.2 OUT
---------

- Implementacion del flujo backend → UC_ACC_04.
- Otros flujos de UC_ACC_* (revocar, ver
  efectivo) → equivalentes en PERM tienen
  sus propios UCs.

1.3.3 Posicion en el flujo
--------------------------

UC_PERM_01 es **vista UI alternativa**.
El backend ejecuta la misma logica que
UC_ACC_04. Los AuditEvents llevan el mismo
``event_type`` (AGR_ASSIGNED) — desde audit no
se distingue si la asignacion vino via vista
ACC o PERM (irrelevante para compliance).

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq satisfecho**
   - BReq-004 Cumplimiento de Seguridad
 * - **Origen legacy (vista PERM)**
   - PRIORIDAD_01 (Estructura base RBAC),
     RNF-002 (Control granular). Notar que el
     cluster PERM legacy NO uso convencion
     BRQ — usa PRIORIDAD/RNF/N. La spec
     reconcilia trazando explicitamente al
     BReq-004 canonico.
 * - **CNST**
   - identicas a UC_ACC_04: CNST-005, 009,
     013, 025, 026.
 * - **Funcion RBAC**
   - ``assign_function_groups`` (compartida)
 * - **AGR de conveniencia**
   - AGR-006 user_admin_group y AGR de
     compliance/seguridad la contienen.
 * - **UCs relacionados**
   - **UC_ACC_04** (backing — implementacion
     compartida);
     UC_PERM_02 (revocar AGR — vista PERM);
     UC_PERM_05 (crear/modificar AGRs);
     UC_PERM_06 (asignar funciones a AGR).

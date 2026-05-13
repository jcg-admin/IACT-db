.. _uc-acc-04-parte-01:

============================================
Parte 1 — Informacion general de UC_ACC_04
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_ACC_04
 * - **Nombre**
   - Asignar Agrupador a Usuario
 * - **Version spec**
   - 5.0.0
 * - **Modulo**
   - MOD_Access

1.2 Proposito
=============

UC_ACC_04 asigna un ``AccessGroup`` (AGR) a un
User. El efecto operacional es que el User
recibe (a traves del AGR) todas las funciones
que el AGR contiene. Es la **operacion masiva**
preferida cuando un User asume un rol
predefinido (operador basico, admin,
auditor, etc.).

Diferencia con UC_ACC_01:

- **UC_ACC_01**: asigna funciones individuales
  (granularidad atomica). Caso: roles
  irregulares, ajustes finos.
- **UC_ACC_04**: asigna AGR completo
  (granularidad de rol). Caso: onboarding
  rapido, asignacion de roles estandar.

Ambas convergen en UC_ACC_03 (vista efectiva)
y respetan SoD (UC_ACC_05).

1.3 Alcance
===========

1.3.1 IN
--------

- Asignacion de un AGR a un User.
- Validacion SoD considerando todas las
  funciones del AGR contra el conjunto
  efectivo actual del User (write-time —
  CNST-005).
- Idempotencia: re-asignar AGR ya activo es
  no-op.
- Asignacion temporal opcional con
  ``expires_at`` (BR-008).
- AuditEvent ``AGR_ASSIGNED``.

1.3.2 OUT
---------

- Asignacion granular → UC_ACC_01.
- Revocacion de AGR → UC_ACC_02 sobre el
  Assignment del AGR.
- Modificacion de las funciones contenidas
  en un AGR → UC_PERM_06 (Asignar funciones
  a grupo) — manipula la composicion del AGR
  mismo, no quien lo tiene.

1.3.3 Posicion en el flujo
--------------------------

UC_ACC_04 es la operacion **mas frecuente** en
onboarding. Tipico: UC_USR_01 crea User,
inmediatamente UC_ACC_04 le asigna AGR
predefinido (e.g. ``basic_operator_group``).

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq**
   - BReq-004
 * - **BRQ legacy**
   - BRQ-ACC-004
 * - **Reglas**
   - BR-006 RBAC Flat NIST, BR-007 SoD,
     BR-008 Permisos con vencimiento, BR-010
     Auditoria
 * - **CNST**
   - CNST-005 SoD enforcement, CNST-009,
     CNST-013, CNST-025, CNST-026
 * - **Funcion RBAC**
   - ``assign_function_groups``
 * - **AGR de conveniencia**
   - AGR-006 contiene la funcion
 * - **UCs relacionados**
   - UC_ACC_01 (asignar funciones),
     UC_ACC_02 (revocar — opera tambien
     sobre AGR Assignments),
     UC_ACC_03 (consultar efectivos),
     UC_ACC_05 (configurar SoD que se
     valida),
     UC_PERM_05/06 (administracion del
     catalogo de AGRs).
 * - **Clase primaria**
   - ``Assignment`` (target_type=AGR)
 * - **Clases secundarias**
   - ``User``, ``AccessGroup``,
     ``Function``, ``SoDRule``,
     ``AuditEvent``

.. _uc-perm-06-parte-01:

============================================
Parte 1 — Informacion general de UC_PERM_06
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_PERM_06
 * - **Nombre**
   - Asignar Funciones a Grupo (composicion AGR)
 * - **Funcion RBAC**
   - ``manage_access_group_composition``

1.2 Proposito
=============

UC_PERM_06 modifica la composicion de un AGR
agregando o quitando funciones de la tabla
pivote ``AccessGroupFunction``. Es operacion
critica:

- Agregar funcion → todos los Users con el
  AGR la reciben automaticamente.
- Quitar funcion → todos los Users con el
  AGR la pierden (excepto si tienen otro
  source: directa, otro AGR, excepcional).

Cambios en composicion son CASCADE — afectan
inmediatamente el effective set de todos los
Users con el AGR. Defensa: validacion SoD
write-time considerando el delta.

1.3 Alcance
===========

1.3.1 IN
--------

- ``add_function_ids``: lista a agregar al
  AGR (idempotente — skip ya presentes).
- ``remove_function_ids``: lista a quitar.
- Validacion SoD para Users con el AGR
  (puede crear/resolver conflictos).
- AuditEvent
  ``ACCESS_GROUP_COMPOSITION_CHANGED``
  con cascade_affected_user_count.

1.3.2 OUT
---------

- Crear AGR → UC_PERM_05.
- Modificar predefinidos AGR-001..010 →
  prohibido.
- Asignar AGR a User → UC_PERM_01.

1.3.3 Posicion en flujo
-----------------------

Operacion de governance. Disparada por:

- Refinamiento de un perfil custom.
- Compliance review identifica funcion
  faltante o extra en AGR.
- Onboarding de nueva capacidad agregada
  al perfil.

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq**
   - BReq-004
 * - **Origen legacy**
   - PRIORIDAD_01 + RNF-002
 * - **Reglas**
   - BR-006 RBAC Flat NIST, BR-007 SoD,
     BR-010 Auditoria
 * - **CNST**
   - CNST-005 SoD enforcement,
     CNST-009/013/025/026
 * - **Funcion RBAC**
   - ``manage_access_group_composition``
 * - **AGR de conveniencia**
   - AGR de seguridad / governance
 * - **UCs relacionados**
   - UC_PERM_05 (CRUD AGR como entidad),
     UC_PERM_01 / UC_ACC_04 (asignar AGR
     compuesto), UC_ACC_03 (vista efectiva
     muestra cascade).
 * - **Clase primaria**
   - ``AccessGroupFunction`` (tabla pivote)

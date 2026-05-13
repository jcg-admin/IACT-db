.. _uc-perm-05-parte-01:

============================================
Parte 1 — Informacion general de UC_PERM_05
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_PERM_05
 * - **Nombre**
   - Crear/Modificar/Retirar Grupo de Permisos
 * - **Funcion RBAC**
   - ``manage_access_groups``

1.2 Proposito
=============

CRUD del catalogo de AGRs custom (codigo
distinto de ``AGR-001..010`` predefinidos).
Casos:

- Onboarding de un nuevo perfil
  organizacional (e.g. ``soporte_n2_group``).
- Refinamiento de roles existentes con
  composicion personalizada.
- Retiro de AGRs ya no utilizados (state
  ACTIVE → RETIRED, soft-delete).

Diferencia con UC_PERM_06: UC_PERM_05 maneja
el ciclo de vida del AGR como entidad
(crear/modificar atributos/retirar).
UC_PERM_06 maneja la composicion (que
funciones contiene).

1.3 Alcance
===========

1.3.1 IN
--------

- Crear AGR custom con: code, display_name,
  description, severity.
- Modificar atributos descriptivos
  (display_name, description).
- Retirar AGR (state RETIRED, soft).
- Validacion: code unico, no colisiona con
  predefinidos AGR-001..010.

1.3.2 OUT
---------

- Composicion (functions del AGR) →
  UC_PERM_06.
- Asignar AGR a Users → UC_PERM_01 / UC_ACC_04.
- Modificar predefinidos → prohibido.

1.3.3 Posicion en flujo
-----------------------

Operacion de governance. Tipica audiencia:
admin de seguridad cuando se introduce un
nuevo perfil organizacional.

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
   - BR-006 RBAC Flat NIST, BR-009 Bajas
     Logicas, BR-010 Auditoria
 * - **CNST**
   - CNST-009/013/025/026
 * - **Funcion RBAC**
   - ``manage_access_groups`` (P-15
     distinta de assign / revoke / view)
 * - **AGR de conveniencia**
   - AGR de seguridad / governance
 * - **UCs relacionados**
   - UC_PERM_06 (composicion), UC_PERM_01 /
     UC_ACC_04 (asignar AGR creado),
     UC_PERM_02 (revocar AGR de Users).
 * - **Clase primaria**
   - ``AccessGroup``

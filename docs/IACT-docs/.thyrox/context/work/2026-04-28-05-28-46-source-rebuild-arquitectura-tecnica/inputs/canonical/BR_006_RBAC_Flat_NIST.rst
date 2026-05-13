.. meta::
   :artefacto: BR_006
   :tipo: Business Rule
   :subtipo: Hecho
   :modalidad: Aletica
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-006:

==============================================================================
BR_006: Modelo RBAC Flat NIST
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   El sistema IACT implementa el modelo RBAC (Role-Based Access Control)
   en su nivel Flat segun NIST, sin herencia de roles. Los permisos
   de un usuario son la union de los permisos de todos sus roles
   asignados, sin jerarquia.

**Enunciado SBVR:**

   IACT system uses NIST Flat RBAC model.
   A user's effective permissions are the union of permissions
   from all assigned roles without role hierarchy.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Hecho (Fact)
   * - **Modalidad**
     - Aletica (verdad estructural del sistema)
   * - **Estatica/Dinamica**
     - Estatica (decision arquitectonica fundamental)

**Nota:** Es un HECHO porque define una verdad estructural del sistema.
No es una restriccion que pueda violarse; es como esta construido el
modelo de seguridad.

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - NIST RBAC Model, Decision Arquitectonica
   * - **Documento**
     - ADR_003 RBAC Flat vs Hierarchical
   * - **Referencia Externa**
     - NIST INCITS 359-2004
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Simplicidad:** Flat RBAC es mas facil de entender, implementar
   y auditar que RBAC jerarquico.

2. **Explicitud:** Los permisos son explicitos; no hay confusion
   sobre que permisos hereda un rol de otro.

3. **Mantenibilidad:** Cambiar permisos de un rol no tiene efectos
   en cascada a otros roles.

4. **Auditoria:** Mas facil determinar por que un usuario tiene
   cierto permiso.

5. **Alcance del proyecto:** Para 50-100 usuarios y 18 roles,
   Flat RBAC es suficiente y apropiado.

----

Niveles NIST RBAC
-----------------

.. code-block:: text

   NIST RBAC tiene 4 niveles:

   Level 0: Flat RBAC    <-- IACT USA ESTE
   - Usuarios, roles, permisos
   - Asignacion usuario-rol
   - SIN herencia de roles

   Level 1: Hierarchical RBAC
   - Herencia de roles
   - Roles padre/hijo

   Level 2: Constrained RBAC
   - Separacion de Funciones (SoD)
   - Restricciones estaticas/dinamicas
   - IACT implementa SoD de este nivel (BR_007)

   Level 3: Symmetric RBAC
   - Revision de permisos
   - Auditoria completa

----

Modelo de Entidades
-------------------

Diagrama ER
^^^^^^^^^^^

.. code-block:: text

   +----------+       +------------+       +-----------+
   |  Usuario |       | user_roles |       |    Rol    |
   +----------+       +------------+       +-----------+
   | user_id  |<----->| user_id    |<----->| role_id   |
   | username |  N:N  | role_id    |  N:N  | codigo    |
   | email    |       +------------+       | nombre    |
   +----------+                            +-----------+
                                                 |
                                                 | 1:N
                                                 v
                                           +------------+
                                           | role_perms |
                                           +------------+
                                           | role_id    |
                                           | perm_id    |
                                           +-----+------+
                                                 |
                                                 | N:1
                                                 v
                                           +-----------+
                                           |  Permiso  |
                                           +-----------+
                                           | perm_id   |
                                           | nombre    |
                                           | recurso   |
                                           | accion    |
                                           +-----------+

Sin Herencia
^^^^^^^^^^^^

.. code-block:: text

   HERENCIA (NO IMPLEMENTADO):

   Si existiera herencia:
   Rol_Admin hereda de Rol_Viewer
   -> Admin tendria automaticamente permisos de Viewer

   EN FLAT RBAC (IMPLEMENTADO):

   No hay herencia.
   Si Admin necesita permisos de Viewer,
   esos permisos se asignan explicitamente a Admin.

   Rol_Admin: [perm_A, perm_B, perm_C, perm_D]
   Rol_Viewer: [perm_A, perm_B]

   Admin tiene perm_A y perm_B NO por herencia,
   sino por asignacion explicita.

----

Calculo de Permisos Efectivos
-----------------------------

Algoritmo
^^^^^^^^^

.. code-block:: text

   Permisos_Efectivos(usuario) = UNION de:
       - Permisos de Rol_1 del usuario
       - Permisos de Rol_2 del usuario
       - ...
       - Permisos de Rol_N del usuario

   Es una UNION simple, sin jerarquia ni herencia.

Ejemplo
^^^^^^^

.. code-block:: text

   Usuario: Juan
   Roles asignados: [REPORTS_VIEWER, DASHBOARD_VIEWER]

   Permisos de REPORTS_VIEWER:
   - reports.view
   - reports.filter
   - reports.export.csv

   Permisos de DASHBOARD_VIEWER:
   - dashboard.view
   - dashboard.filter

   Permisos_Efectivos(Juan):
   - reports.view
   - reports.filter
   - reports.export.csv
   - dashboard.view
   - dashboard.filter

   (Union simple de ambos conjuntos)

Implementacion SQL
^^^^^^^^^^^^^^^^^^

.. code-block:: sql

   -- Obtener permisos efectivos de un usuario
   SELECT DISTINCT p.nombre
   FROM users u
   JOIN user_roles ur ON u.id = ur.user_id
   JOIN role_permissions rp ON ur.role_id = rp.role_id
   JOIN permissions p ON rp.permission_id = p.id
   WHERE u.id = :user_id;

   -- Nota: DISTINCT porque un permiso puede estar
   -- en multiples roles del usuario

----

Catalogo de Roles
-----------------

El modelo define exactamente 18 roles (catalogo cerrado):

.. list-table::
   :header-rows: 1
   :widths: 10 30 30 30

   * - Codigo
     - Nombre
     - Categoria
     - Permisos Aprox.
   * - R001
     - USERS_FULL_MANAGER
     - Gestion Usuarios
     - 28
   * - R002
     - USERS_VIEWER
     - Gestion Usuarios
     - 7
   * - R003
     - USERS_TEAM_MANAGER
     - Gestion Usuarios
     - 15
   * - R004
     - REPORTS_VIEWER
     - Reportes
     - 12
   * - R005
     - REPORTS_EXPORTER
     - Reportes
     - 18
   * - R006
     - REPORTS_ADVANCED_VIEWER
     - Reportes
     - 22
   * - R007
     - REPORTS_CREATOR
     - Reportes
     - 25
   * - R008
     - DASHBOARD_VIEWER
     - Visualizacion
     - 8
   * - R009
     - DASHBOARD_CUSTOMIZER
     - Visualizacion
     - 12
   * - R010
     - DATA_ANALYST
     - Analisis
     - 30
   * - R011
     - ALERTS_VIEWER
     - Alertas
     - 5
   * - R012
     - ALERTS_CONFIGURATOR
     - Alertas
     - 15
   * - R013
     - ALERTS_TEAM_MANAGER
     - Alertas
     - 18
   * - R014
     - ALERTS_GLOBAL_ADMIN
     - Alertas
     - 22
   * - R015
     - MODULES_ADMIN
     - Administracion
     - 20
   * - R016
     - SYSTEM_ADMIN
     - Administracion
     - 35
   * - R017
     - AUDIT_VIEWER
     - Administracion
     - 10
   * - R018
     - SECURITY_ADMIN
     - Administracion
     - 25

----

Requisitos Derivados
--------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-ACC.01
     - Sistema DEBE implementar relacion N:N entre usuarios y roles
   * - FR-ACC.02
     - Sistema DEBE implementar relacion 1:N entre roles y permisos
   * - FR-ACC.03
     - Sistema DEBE calcular permisos efectivos como UNION de roles
   * - FR-ACC.04
     - Sistema NO DEBE implementar herencia entre roles
   * - FR-ACC.05
     - Sistema DEBE exponer catalogo cerrado de 18 roles

----

Casos de Uso Relacionados
-------------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Relacion con BR_006
   * - UC_010
     - Asignar Roles
     - Asigna roles del catalogo
   * - UC_011
     - Gestionar Permisos por Rol
     - Modifica permisos de rol
   * - UC_044
     - Consultar Permisos Efectivos
     - Calcula UNION de permisos
   * - UC_045
     - Gestionar Catalogo Roles
     - Administra los 18 roles

----

Restricciones Relacionadas
--------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - CNST
     - Nombre
     - Relacion
   * - CNST_005
     - Seguridad DRF Checklist
     - Define implementacion RBAC

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. No existe tabla de herencia de roles en BD
2. Permisos efectivos son UNION de permisos de roles
3. Catalogo tiene exactamente 18 roles
4. Roles no tienen campo "parent_role" o similar

Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^

- Inspeccion de esquema de BD
- Tests de calculo de permisos efectivos
- Query que verifique ausencia de herencia

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`mtm-03` - MTM_03 Metamodelo RBAC
- :ref:`br-007` - BR_007 Separacion de Funciones SoD
- :ref:`cnst-005` - CNST_005 Seguridad DRF
- ADR_003 - Decision RBAC Flat vs Hierarchical

Fuentes Externas
^^^^^^^^^^^^^^^^

- NIST INCITS 359-2004: RBAC Standard
- Ferraiolo, Sandhu, Kuhn: "RBAC Model"

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-03
     - Equipo IACT
     - Version inicial aprobada

----

**Trazabilidad:**

- Origen: NIST RBAC, ADR_003
- Tipo: Hecho (define estructura, no genera UC)
- Implementa: CNST_005 (parcialmente)
- Deriva: FR-ACC.01 a FR-ACC.05
- Modulo: MOD_Access

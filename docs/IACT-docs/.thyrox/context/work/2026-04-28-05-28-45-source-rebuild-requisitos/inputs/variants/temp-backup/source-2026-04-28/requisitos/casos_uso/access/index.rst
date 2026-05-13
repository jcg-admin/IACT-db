.. meta::
   :artefacto: index_access
   :tipo: Indice
   :dominio: requisitos
   :subdominio: casos_uso/access
   :estado: Completado
   :version: 2.0.0
   :fecha_creacion: 2026-01-06
   :autor: Equipo IACT

.. _casos-uso-access-index:

====================================================
MOD_Access: Casos de Uso de Control de Acceso (RBAC)
====================================================

Modulo de Control de Acceso - Version 2.0 con diagramas PlantUML.

----

Resumen
-------

.. list-table::
   :widths: 30 70
   :header-rows: 0

   * - **Modulo**
     - MOD_Access
   * - **UC Documentados**
     - 9 (UC-010, UC-011, UC-041 a UC-047)
   * - **Version**
     - 2.0.0 (con PlantUML)
   * - **Estado**
     - Completado
   * - **BReq Origen**
     - BReq-004: Cumplimiento de Seguridad
   * - **BR Aplicables**
     - BR_008, BR_009, BR_010

----

Casos de Uso
------------

.. list-table::
   :widths: 12 35 12 12 29
   :header-rows: 1

   * - ID
     - Nombre
     - Complej.
     - Diag.
     - Estado
   * - UC-010
     - Asignar Funciones a Usuario
     - Alta
     - 3
     - Completado
   * - UC-011
     - Revocar Funciones a Usuario
     - Media
     - 3
     - Completado
   * - UC-041
     - Asignar Segmento de Datos
     - Media
     - 3
     - Completado
   * - UC-042
     - Revocar Segmento de Datos
     - Baja
     - 3
     - Completado
   * - UC-043
     - Configurar Restricciones SoD
     - Alta
     - 3
     - Completado
   * - UC-044
     - Consultar Permisos Efectivos
     - Media
     - 3
     - Completado
   * - UC-045
     - Gestionar Catalogo Agrupadores
     - Media
     - 3
     - Completado
   * - UC-046
     - Gestionar Catalogo Funciones
     - Media
     - 3
     - Completado
   * - UC-047
     - Auditar Cambios de Permisos
     - Media
     - 3
     - Completado

----

Descripcion de Casos de Uso
---------------------------

UC-010: Asignar Funciones
^^^^^^^^^^^^^^^^^^^^^^^^^

Asigna funciones atomicas del catalogo RBAC a un usuario validando
restricciones SoD.

- **Actor:** Administrador de Seguridad
- **FR Derivados:** 10
- **Funcion RBAC:** ACC-001

UC-011: Revocar Funciones
^^^^^^^^^^^^^^^^^^^^^^^^^

Revoca funciones previamente asignadas con motivo obligatorio.

- **Actor:** Administrador de Seguridad
- **FR Derivados:** 9
- **Funcion RBAC:** ACC-002

UC-041/042: Asignar/Revocar Segmentos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Gestionan acceso a datos por centro de costo (segmentacion).

- **Actor:** Administrador de Seguridad
- **Funciones RBAC:** ACC-003, ACC-004

UC-043: Configurar SoD
^^^^^^^^^^^^^^^^^^^^^^

Define reglas de Segregacion de Funciones (combinaciones prohibidas).

- **Actor:** Administrador de Seguridad
- **Funcion RBAC:** ACC-005

UC-044: Consultar Permisos
^^^^^^^^^^^^^^^^^^^^^^^^^^

Visualiza permisos efectivos de un usuario (funciones + segmentos).

- **Actor:** Cualquier usuario (propios) o Admin (otros)
- **Funcion RBAC:** ACC-006

UC-045/046: Gestionar Agrupadores/Funciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Administran el catalogo RBAC (roles y permisos atomicos).

- **Actor:** Administrador de Seguridad
- **Funciones RBAC:** ACC-007, ACC-008

UC-047: Auditar Permisos
^^^^^^^^^^^^^^^^^^^^^^^^

Consulta historial de cambios en permisos con filtros y exportacion.

- **Actor:** Auditor / Admin Seguridad
- **Funcion RBAC:** ACC-009, AUD-002

----

Metricas
--------

.. list-table::
   :widths: 40 30 30
   :header-rows: 1

   * - Metrica
     - Valor
     - Notas
   * - UC Documentados
     - 9
     - 100%
   * - FR Derivados
     - ~75
     - ~8 por UC
   * - Diagramas PlantUML
     - 27
     - 3 por UC
   * - Lineas de documentacion
     - ~3,400
     - Total modulo

----

Funciones RBAC del Modulo
-------------------------

.. list-table::
   :widths: 12 35 53
   :header-rows: 1

   * - Codigo
     - Nombre
     - UC que Requiere
   * - ACC-001
     - Asignar Funciones
     - UC-010
   * - ACC-002
     - Revocar Funciones
     - UC-011
   * - ACC-003
     - Asignar Segmentos
     - UC-041
   * - ACC-004
     - Revocar Segmentos
     - UC-042
   * - ACC-005
     - Configurar SoD
     - UC-043
   * - ACC-006
     - Consultar Permisos
     - UC-044
   * - ACC-007
     - Gestionar Agrupadores
     - UC-045
   * - ACC-008
     - Gestionar Funciones
     - UC-046
   * - ACC-009
     - Auditar Permisos
     - UC-047

----

Trazabilidad BR -> UC
---------------------

.. list-table::
   :widths: 12 30 58
   :header-rows: 1

   * - BR
     - Nombre
     - UC que Implementan
   * - BR_008
     - Auditoria
     - Todos (registran cambios)
   * - BR_009
     - Segmentacion
     - UC-041, UC-042
   * - BR_010
     - SoD
     - UC-010, UC-043

----

.. toctree::
   :maxdepth: 1
   :caption: Control de Acceso RBAC

   UC_ACC_01_Asignar_Funciones
   UC_ACC_02_Revocar_Funciones
   UC_ACC_03_Consultar_Permisos
   UC_ACC_04_Asignar_Agrupador
   UC_ACC_05_Gestionar_SoD
   UC_ACC_06_Gestionar_Segmentos
   UC_ACC_07_Asignar_Segmento
   UC_ACC_08_Permiso_Temporal
   UC_ACC_09_Auditar_Cambios_Acceso

----

Historial de Cambios
--------------------

.. list-table::
   :widths: 12 12 76
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 2.0.0
     - 2026-01-06
     - Fase 3 completada: 9 UC con PlantUML embebido

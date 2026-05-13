.. meta::
   :artefacto: index_access
   :tipo: Indice
   :dominio: requisitos
   :subdominio: casos_uso/access
   :estado: Completado
   :version: 4.0.0
   :fecha_creacion: 2026-01-06
   :fecha_actualizacion: 2026-01-07
   :autor: Equipo IACT

.. _casos-uso-access-index:

==============================================================================
MOD_Access: Casos de Uso de Control de Acceso (RBAC)
==============================================================================

Modulo de Control de Acceso - Version 4.0.0 con nomenclatura actualizada.

.. contents:: Contenido
   :local:
   :depth: 2

----

Resumen
-------

.. list-table::
   :widths: 30 70
   :header-rows: 0

   * - **Modulo**
     - MOD_Access
   * - **UC Documentados**
     - 9 (UC_ACC_01 a UC_ACC_09)
   * - **Version**
     - 4.0.0 (nomenclatura actualizada)
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
   :widths: 15 35 12 12 26
   :header-rows: 1

   * - ID
     - Nombre
     - Complej.
     - Diag.
     - Estado
   * - UC_ACC_01
     - Asignar Funciones
     - Alta
     - 3
     - Completado
   * - UC_ACC_02
     - Revocar Funciones
     - Media
     - 3
     - Completado
   * - UC_ACC_03
     - Consultar Permisos
     - Media
     - 3
     - Completado
   * - UC_ACC_04
     - Asignar Agrupador
     - Alta
     - 3
     - Completado
   * - UC_ACC_05
     - Gestionar SoD
     - Alta
     - 3
     - Completado
   * - UC_ACC_06
     - Gestionar Segmentos
     - Media
     - 3
     - Completado
   * - UC_ACC_07
     - Asignar Segmento
     - Media
     - 3
     - Completado
   * - UC_ACC_08
     - Permiso Temporal
     - Media
     - 3
     - Completado
   * - UC_ACC_09
     - Auditar Cambios Acceso
     - Media
     - 3
     - Completado

----

Descripcion de Casos de Uso
---------------------------

UC_ACC_01: Asignar Funciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Asigna funciones atomicas del catalogo RBAC a un usuario validando
restricciones SoD.

- **Actor:** AGR-007 (Administrador de Acceso)
- **FR Derivados:** 10
- **Funcion RBAC:** ACC-001

UC_ACC_02: Revocar Funciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Revoca funciones previamente asignadas con motivo obligatorio.

- **Actor:** AGR-007 (Administrador de Acceso)
- **FR Derivados:** 9
- **Funcion RBAC:** ACC-002

UC_ACC_03: Consultar Permisos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Visualiza permisos efectivos de un usuario (funciones + segmentos).

- **Actor:** Cualquier usuario (propios) o AGR-007 (otros)
- **Funcion RBAC:** ACC-003

UC_ACC_04: Asignar Agrupador
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Asigna un agrupador completo (conjunto de funciones) a un usuario.

- **Actor:** AGR-007 (Administrador de Acceso)
- **Funcion RBAC:** ACC-004
- **Nuevo en v4.0**

UC_ACC_05: Gestionar SoD
^^^^^^^^^^^^^^^^^^^^^^^^

Define reglas de Segregacion de Funciones (combinaciones prohibidas).

- **Actor:** AGR-007 (Administrador de Acceso)
- **Funcion RBAC:** ACC-005

UC_ACC_06: Gestionar Segmentos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Administra el catalogo de segmentos de datos (particiones).

- **Actor:** AGR-007 (Administrador de Acceso)
- **Funcion RBAC:** ACC-006

UC_ACC_07: Asignar Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Asigna un segmento de datos específico a un usuario.

- **Actor:** AGR-007 (Administrador de Acceso)
- **Funcion RBAC:** ACC-007

UC_ACC_08: Permiso Temporal
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Otorga permisos temporales con caducidad automática.

- **Actor:** AGR-007 (Administrador de Acceso)
- **Funcion RBAC:** ACC-008
- **Nuevo en v4.0**

UC_ACC_09: Auditar Cambios Acceso
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Consulta historial de cambios en permisos con filtros y exportacion.

- **Actor:** AGR-008 (Auditor) / AGR-007 (Admin Seguridad)
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
     - ~80
     - ~9 por UC
   * - Diagramas PlantUML
     - 27
     - 3 por UC
   * - Lineas de documentacion
     - ~4,500
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
     - UC_ACC_01
   * - ACC-002
     - Revocar Funciones
     - UC_ACC_02
   * - ACC-003
     - Consultar Permisos
     - UC_ACC_03
   * - ACC-004
     - Asignar Agrupador
     - UC_ACC_04
   * - ACC-005
     - Gestionar SoD
     - UC_ACC_05
   * - ACC-006
     - Gestionar Segmentos
     - UC_ACC_06
   * - ACC-007
     - Asignar Segmento
     - UC_ACC_07
   * - ACC-008
     - Permiso Temporal
     - UC_ACC_08
   * - ACC-009
     - Auditar Cambios Acceso
     - UC_ACC_09

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
     - UC_ACC_06, UC_ACC_07
   * - BR_010
     - SoD
     - UC_ACC_01, UC_ACC_05

----

.. toctree::
   :maxdepth: 1
   :caption: Casos de Uso

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
   * - 4.0.0
     - 2026-01-07
     - Actualización a nomenclatura v4.0: UC_ACC_01 a UC_ACC_09. Agregados UC_ACC_04 y UC_ACC_08
   * - 2.0.0
     - 2026-01-06
     - Fase 3 completada: 9 UC con PlantUML embebido

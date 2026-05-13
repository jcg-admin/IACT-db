.. _reglas-negocio:

=================
Reglas de Negocio
=================

Propósito
=========

Este subdominio contiene las **Reglas de Negocio (BR)** del proyecto IACT,
estableciendo políticas, restricciones y principios fundamentales que rigen el sistema.

Las reglas de negocio son el nivel más alto de análisis y derivan en casos de uso.

Contenido
=========

Las reglas de negocio incluyen:

* Políticas del negocio
* Restricciones operativas
* Principios de diseño (ej: roles funcionales, RBAC flat)
* Reglas de integridad de datos

Prefijo
=======

Los artefactos de este subdominio usan el prefijo **BR_** (Business Rule).

Ejemplo: ``BR_001_Fuente_Operacional_Inmutable.rst``

----

Estado del Catálogo
===================

.. list-table::
   :widths: 30 70
   :header-rows: 0

   * - **Total BR**
     - 20
   * - **Estado**
     - CONGELADO
   * - **Última Actualización**
     - 2026-01-07
   * - **Versión Catálogo**
     - 2.0.0

----

Clasificación por Tipo
======================

Según TXM_03 (Taxonomía de Reglas de Negocio):

.. list-table::
   :widths: 20 15 65
   :header-rows: 1

   * - Tipo
     - Cantidad
     - BR Incluidas
   * - **Restricción**
     - 10
     - BR_001, BR_004, BR_005, BR_007, BR_008, BR_009, BR_010, BR_011, BR_019, BR_020
   * - **Desencadenador**
     - 3
     - BR_002, BR_014, BR_015
   * - **Hecho**
     - 3
     - BR_006, BR_012, BR_013
   * - **Inferencia**
     - 1
     - BR_003
   * - **Cálculo**
     - 3
     - BR_016, BR_017, BR_018

----

Catálogo de BR
==============

Restricciones (10)
------------------

.. list-table::
   :widths: 12 38 15 35
   :header-rows: 1

   * - ID
     - Nombre
     - CNST
     - Descripción
   * - BR_001
     - Fuente Operacional Inmutable
     - CNST_003
     - No modificar datos en base IVR
   * - BR_004
     - Comunicaciones Internas Only
     - CNST_001
     - Solo notificaciones in-app
   * - BR_005
     - Sesión Única por Usuario
     - CNST_002
     - Una sesión activa por usuario
   * - BR_007
     - Separación de Funciones SoD
     - CNST_005
     - Funciones mutuamente excluyentes
   * - BR_008
     - Auditoría de Accesos
     - CNST_005
     - Registrar todas las acciones
   * - BR_009
     - Bajas Lógicas
     - CNST_005
     - No eliminar, solo desactivar
   * - BR_010
     - Auditoría Inmutable
     - CNST_009
     - Logs no modificables
   * - BR_011
     - Límites de Exportación
     - CNST_007
     - Máximo 100,000 registros
   * - BR_019
     - Retención de Datos 2 Años
     - CNST_006
     - Política de retención
   * - BR_020
     - Clasificación de Datos
     - CNST_010
     - 4 niveles de sensibilidad

Desencadenadores (3)
--------------------

.. list-table::
   :widths: 12 38 15 35
   :header-rows: 1

   * - ID
     - Nombre
     - CNST
     - Descripción
   * - BR_002
     - ETL Batch Nocturno
     - CNST_004
     - Sincronización 2:00 AM
   * - BR_014
     - Alerta por Umbral
     - —
     - SI métrica > umbral ENTONCES alerta
   * - BR_015
     - Bloqueo Intentos Fallidos
     - CNST_005
     - 5 intentos = bloqueo 30 min

Hechos (3)
----------

.. list-table::
   :widths: 12 38 15 35
   :header-rows: 1

   * - ID
     - Nombre
     - CNST
     - Descripción
   * - BR_006
     - RBAC Flat NIST
     - CNST_005
     - Modelo sin jerarquía de roles
   * - BR_012
     - Usuario-Segmento Único
     - —
     - Relación N:M usuario-centro
   * - BR_013
     - Username Único
     - —
     - Cardinalidad 1:1

Inferencia (1)
--------------

.. list-table::
   :widths: 12 38 15 35
   :header-rows: 1

   * - ID
     - Nombre
     - CNST
     - Descripción
   * - BR_003
     - Usuario Inactivo 90 Días
     - —
     - Sin login en 90d = inactivo

Cálculos (3)
------------

.. list-table::
   :widths: 12 30 28 30
   :header-rows: 1

   * - ID
     - Nombre
     - Fórmula
     - Umbral Alerta
   * - BR_016
     - Tasa de Abandono
     - (Abandonadas/Total) × 100
     - > 15%
   * - BR_017
     - Tiempo Promedio Espera
     - AVG(tiempo_espera)
     - > 120 seg
   * - BR_018
     - Índice de Eficiencia
     - (Atendidas/Total) × 100
     - < 85%

----

Matriz BR → CNST
================

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - CNST
     - BR que implementa
   * - CNST_001
     - BR_004 (Comunicaciones Internas)
   * - CNST_002
     - BR_005 (Sesión Única)
   * - CNST_003
     - BR_001 (Fuente Inmutable)
   * - CNST_004
     - BR_002 (ETL Batch)
   * - CNST_005
     - BR_006, BR_007, BR_008, BR_009, BR_015
   * - CNST_006
     - BR_019 (Retención 2 Años)
   * - CNST_007
     - BR_011 (Límites Exportación)
   * - CNST_009
     - BR_010 (Auditoría Inmutable)
   * - CNST_010
     - BR_020 (Clasificación Datos)

----

Árbol de Archivos
=================

.. code-block:: text

   reglas_negocio/
   ├── index.rst                                    ← Este archivo
   ├── BR_001_Fuente_Operacional_Inmutable.rst      [Restricción]
   ├── BR_002_ETL_Batch_Nocturno.rst                [Desencadenador]
   ├── BR_003_Usuario_Inactivo_90_Dias.rst          [Inferencia]
   ├── BR_004_Comunicaciones_Internas_Only.rst      [Restricción]
   ├── BR_005_Sesion_Unica_Por_Usuario.rst          [Restricción]
   ├── BR_006_RBAC_Flat_NIST.rst                    [Hecho]
   ├── BR_007_Separacion_Funciones_SoD.rst          [Restricción]
   ├── BR_008_Auditoria_Accesos.rst                 [Restricción]
   ├── BR_009_Bajas_Logicas.rst                     [Restricción]
   ├── BR_010_Auditoria_Inmutable.rst               [Restricción]
   ├── BR_011_Limites_Exportacion.rst               [Restricción]
   ├── BR_012_Usuario_Segmento_Unico.rst            [Hecho]
   ├── BR_013_Username_Unico.rst                    [Hecho]
   ├── BR_014_Alerta_Por_Umbral.rst                 [Desencadenador]
   ├── BR_015_Bloqueo_Intentos_Fallidos.rst         [Desencadenador]
   ├── BR_016_Tasa_Abandono.rst                     [Cálculo]
   ├── BR_017_Tiempo_Promedio_Espera.rst            [Cálculo]
   ├── BR_018_Indice_Eficiencia.rst                 [Cálculo]
   ├── BR_019_Retencion_2_Anios.rst                 [Restricción]
   └── BR_020_Clasificacion_Datos.rst               [Restricción]

----

Toctree
=======

.. toctree::
   :maxdepth: 1
   :caption: Reglas de Negocio

   BR_001_Fuente_Operacional_Inmutable
   BR_002_ETL_Batch_Nocturno
   BR_003_Usuario_Inactivo_90_Dias
   BR_004_Comunicaciones_Internas_Only
   BR_005_Sesion_Unica_Por_Usuario
   BR_006_RBAC_Flat_NIST
   BR_007_Separacion_Funciones_SoD
   BR_008_Auditoria_Accesos
   BR_009_Bajas_Logicas
   BR_010_Auditoria_Inmutable
   BR_011_Limites_Exportacion
   BR_012_Usuario_Segmento_Unico
   BR_013_Username_Unico
   BR_014_Alerta_Por_Umbral
   BR_015_Bloqueo_Intentos_Fallidos
   BR_017_Tiempo_Promedio_Espera
   BR_018_Indice_Eficiencia
   BR_019_Retencion_2_Anios
   BR_020_Clasificacion_Datos

----

Referencias
===========

- FND_02: Reglas de Negocio (definición conceptual)
- TXM_03: Taxonomía de Reglas de Negocio (5 tipos)
- CNST_001-010: Restricciones Arquitectónicas relacionadas

----

Historial de Cambios
====================

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Versión
     - Fecha
     - Descripción
   * - 1.0.0
     - 2025-12-22
     - Versión inicial (estructura base)
   * - 1.1.0
     - 2025-12-28
     - BR_001 a BR_010 documentadas
   * - 2.0.0
     - 2026-01-07
     - Catálogo completo 20 BR (BR_011 a BR_020)
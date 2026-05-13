.. meta::
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: En Desarrollo
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :autor: Equipo IACT

.. _reglas-negocio-index:

==============================================================================
Reglas de Negocio - Indice
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Proposito
---------

Este subdominio contiene las **Business Rules (BR)** del proyecto IACT.
Las BR son politicas, restricciones y hechos del dominio que existen
independientemente del sistema y que el sistema DEBE cumplir.

----

Organizacion por Tipo
---------------------

Segun la taxonomia TXM_03, las BR se clasifican en 5 tipos:

Tipo 1: Restriccion (Deontica)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Limitaciones obligatorias sobre lo que DEBE o NO DEBE ocurrir.

.. list-table::
   :header-rows: 1
   :widths: 15 50 35

   * - ID
     - Nombre
     - CNST Relacionado
   * - BR_001
     - Fuente Operacional Inmutable
     - CNST_003
   * - BR_004
     - Comunicaciones Solo Internas
     - CNST_001
   * - BR_005
     - Sesion Unica por Usuario
     - CNST_002
   * - BR_007
     - Separacion de Funciones SoD
     - CNST_005
   * - BR_008
     - Permisos Directos con Vencimiento
     - CNST_005
   * - BR_009
     - Bajas Siempre Logicas
     - CNST_005
   * - BR_010
     - Auditoria Inmutable
     - CNST_009
   * - BR_011
     - Limites de Exportacion por Rol
     - CNST_007

Tipo 2: Hecho (Aletica)
^^^^^^^^^^^^^^^^^^^^^^^

Verdades estructurales del dominio que definen el modelo.

.. list-table::
   :header-rows: 1
   :widths: 15 50 35

   * - ID
     - Nombre
     - Impacto
   * - BR_006
     - Modelo RBAC Flat NIST
     - Arquitectura seguridad
   * - BR_012
     - Usuario Pertenece a Un Segmento
     - FK NOT NULL
   * - BR_013
     - Username es Unico
     - UNIQUE constraint

Tipo 3: Desencadenador (Deontica)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Reglas SI-ENTONCES con accion OBSERVABLE externamente.
Generan Casos de Uso completos.

.. list-table::
   :header-rows: 1
   :widths: 15 50 35

   * - ID
     - Nombre
     - UC Generado
   * - BR_002
     - ETL Batch Nocturno
     - UC_050
   * - BR_014
     - Alerta por Umbral Superado
     - UC_036, UC_037
   * - BR_015
     - Bloqueo por Intentos Fallidos
     - Flujo alterno UC_001

Tipo 4: Inferencia (Aletica)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Reglas SI-ENTONCES con cambio de estado INTERNO (no observable).

.. list-table::
   :header-rows: 1
   :widths: 15 50 35

   * - ID
     - Nombre
     - Impacto
   * - BR_003
     - Usuario Inactivo por 90 Dias
     - Flag estado usuario

Tipo 5: Calculo (Aletica)
^^^^^^^^^^^^^^^^^^^^^^^^^

Formulas y algoritmos de negocio.

.. list-table::
   :header-rows: 1
   :widths: 15 50 35

   * - ID
     - Nombre
     - Formula
   * - BR_016
     - Tasa de Abandono
     - (Abandonadas / Total) * 100
   * - BR_017
     - Tiempo Promedio de Espera
     - SUM(espera) / COUNT(llamadas)
   * - BR_018
     - Indice de Eficiencia
     - Completadas/Total * (1-TasaTransf)

----

Estadisticas
------------

.. list-table::
   :header-rows: 1
   :widths: 30 20 50

   * - Tipo
     - Cantidad
     - Porcentaje
   * - Restriccion
     - 8
     - 44%
   * - Hecho
     - 3
     - 17%
   * - Desencadenador
     - 3
     - 17%
   * - Inferencia
     - 1
     - 5%
   * - Calculo
     - 3
     - 17%
   * - **TOTAL**
     - **18**
     - **100%**

----

Trazabilidad
------------

Relacion con CNST
^^^^^^^^^^^^^^^^^

.. code-block:: text

   CNST_001 (No email)      --> BR_004
   CNST_002 (Sesiones BD)   --> BR_005
   CNST_003 (BD readonly)   --> BR_001
   CNST_004 (ETL batch)     --> BR_002
   CNST_005 (RBAC)          --> BR_006, BR_007, BR_008, BR_009, BR_015
   CNST_007 (Limites)       --> BR_011
   CNST_009 (Auditoria)     --> BR_010

Relacion con Modulos
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   MOD_Auth     --> BR_001, BR_005, BR_015
   MOD_Users    --> BR_003, BR_004, BR_009, BR_012, BR_013
   MOD_Access   --> BR_006, BR_007, BR_008
   MOD_Pipeline --> BR_002
   MOD_Reports  --> BR_011, BR_016, BR_017, BR_018
   MOD_Alerts   --> BR_004, BR_014
   MOD_Audit    --> BR_010
   MOD_Logs     --> (ninguna BR especifica)

----

Lista de Documentos
-------------------

.. toctree::
   :maxdepth: 1

   BR_001_Fuente_Inmutable
   BR_002_ETL_Batch_Nocturno
   BR_003_Usuario_Inactivo_90d
   BR_004_Comunicaciones_Internas
   BR_005_Sesion_Unica
   BR_006_RBAC_Flat_NIST
   BR_007_Separacion_Funciones_SoD
   BR_008_Permisos_Vencimiento
   BR_009_Bajas_Logicas
   BR_010_Auditoria_Inmutable
   BR_011_Limites_Exportacion
   BR_012_Usuario_Segmento_Unico
   BR_013_Username_Unico
   BR_014_Alerta_Umbral
   BR_015_Bloqueo_Intentos_Fallidos
   BR_016_Tasa_Abandono
   BR_017_Tiempo_Promedio_Espera
   BR_018_Indice_Eficiencia

----

Referencias
-----------

- :ref:`fnd-02` - Fundamentos de Reglas de Negocio
- :ref:`txm-03` - Taxonomia de Reglas de Negocio
- :ref:`mtm-01` - Metamodelo de Requisitos

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
     - Version inicial con 18 BR identificadas

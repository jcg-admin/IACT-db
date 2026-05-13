.. meta::
   :artefacto: index
   :tipo: Indice
   :dominio: requisitos
   :subdominio: objetivos
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-06
   :ultimo_cambio: 2026-01-06
   :autor: Equipo IACT
   :clasificacion: Interno

.. _objetivos-index:

=====================================
Indice de Objetivos de Negocio (BReq)
=====================================

Nivel 1 de la Jerarquia de Requisitos IACT.

----

Proposito
---------

Este directorio contiene los Business Requirements (BReq) del proyecto IACT.
Los BReq representan los objetivos de alto nivel que justifican la existencia
del sistema y son la base para derivar los Casos de Uso (Nivel 2).

----

Resumen
-------

.. list-table::
   :widths: 30 70
   :header-rows: 0

   * - **Total BReq**
     - 5
   * - **Documentos**
     - 5 archivos individuales
   * - **UC Generados**
     - 49
   * - **BR que Influyen**
     - 20
   * - **Cobertura BReq-UC**
     - 100%

----

Catalogo de BReq
----------------

.. list-table::
   :header-rows: 1
   :widths: 12 30 38 20

   * - ID
     - Nombre
     - Metrica de Exito
     - UC Generados
   * - BReq-001
     - Visibilidad Metricas IVR
     - Dashboard actualizado cada 5 min, D+1
     - 10 UC
   * - BReq-002
     - Reduccion Tiempo Incidentes
     - Reduccion >= 40% vs baseline
     - 5 UC
   * - BReq-003
     - Decisiones Informadas
     - 100% decisiones con datos
     - 8 UC
   * - BReq-004
     - Cumplimiento Seguridad
     - 0 accesos no autorizados
     - 22 UC
   * - BReq-005
     - Integridad Datos Operacionales
     - 0 escrituras no autorizadas en IVR
     - 4 UC

----

Documentos
----------

.. list-table::
   :header-rows: 1
   :widths: 40 15 15 30

   * - Archivo
     - Version
     - Lineas
     - Categoria
   * - BReq_001_Visibilidad_Metricas.rst
     - 1.0.0
     - 223
     - Analitica Operacional
   * - BReq_002_Reduccion_Incidentes.rst
     - 1.0.0
     - 154
     - Eficiencia Operacional
   * - BReq_003_Decisiones_Informadas.rst
     - 1.0.0
     - 173
     - Inteligencia de Negocio
   * - BReq_004_Cumplimiento_Seguridad.rst
     - 1.0.0
     - 204
     - Seguridad y Compliance
   * - BReq_005_Integridad_Datos.rst
     - 1.0.0
     - 197
     - Integridad de Datos

----

Jerarquia de Requisitos
-----------------------

::

   NIVEL 0              NIVEL 1              NIVEL 2           NIVEL 3
   +---------+         +---------+          +---------+       +---------+
   |   BR    |--influye-->| BReq  |---genera--->|   UC    |--deriva-->|   FR    |
   | (20)    |         |  (5)    |          |  (49)   |       | (~400)  |
   +---------+         +---------+          +---------+       +---------+

----

Trazabilidad BR -> BReq
-----------------------

::

   BR_001 (Fuente Inmutable)     --> BReq-005
   BR_002 (ETL Nocturno)         --> BReq-001
   BR_004-BR_010 (Seguridad)     --> BReq-004
   BR_011, BR_012, BR_020        --> BReq-003
   BR_014 (Alerta Umbral)        --> BReq-002
   BR_016, BR_017 (Calculos)     --> BReq-001
   BR_018, BR_019 (Compliance)   --> BReq-004

----

Trazabilidad BReq -> UC
-----------------------

::

   BReq-001 --> UC-025 a UC-030, UC-050 a UC-053 (10 UC)
   BReq-002 --> UC-036 a UC-040 (5 UC)
   BReq-003 --> UC-017 a UC-024 (8 UC)
   BReq-004 --> UC-001 a UC-011, UC-041 a UC-047, UC-060 a UC-073 (22 UC)
   BReq-005 --> UC-050 a UC-053 (4 UC compartidos)

----

Referencias
-----------

- FND_05: Jerarquia de 4 Niveles (definicion de BReq)
- META_04: Contexto del Proyecto (ambiente, NO objetivos)
- reglas_negocio/index.rst: 20 BR que influyen en BReq
- casos_uso/index.rst: 49 UC generados por BReq

----

Historial de Cambios
--------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Descripcion del Cambio
   * - 1.0.0
     - 2026-01-06
     - Equipo IACT
     - Version inicial con 5 BReq documentados individualmente


.. toctree::
   :hidden:
   :maxdepth: 1

   BReq_001_Visibilidad_Metricas
   BReq_002_Reduccion_Incidentes
   BReq_003_Decisiones_Informadas
   BReq_004_Cumplimiento_Seguridad
   BReq_005_Integridad_Datos

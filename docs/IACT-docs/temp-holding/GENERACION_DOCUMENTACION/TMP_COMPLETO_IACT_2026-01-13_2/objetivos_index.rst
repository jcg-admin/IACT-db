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

==============================================================================
Indice de Objetivos de Negocio (BReq)
==============================================================================

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
   * - **Documento**
     - BReq_001_Objetivos_IACT.rst
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
     - Dashboard actualizado cada 5 min
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

Jerarquia de Requisitos
-----------------------

::

   NIVEL 0              NIVEL 1              NIVEL 2           NIVEL 3
   +---------+         +---------+          +---------+       +---------+
   |   BR    |--influye-->| BReq  |---genera--->|   UC    |--deriva-->|   FR    |
   | (20)    |         |  (5)    |          |  (49)   |       | (~400)  |
   +---------+         +---------+          +---------+       +---------+

----

Documentos
----------

.. list-table::
   :header-rows: 1
   :widths: 40 15 15 30

   * - Archivo
     - Version
     - Estado
     - Descripcion
   * - BReq_001_Objetivos_IACT.rst
     - 1.0.0
     - Aprobado
     - Documento consolidado con 5 BReq

----

Referencias
-----------

- FND_05: Jerarquia de 4 Niveles (definicion de BReq)
- META_04: Contexto del Proyecto (ambiente, NO objetivos)
- reglas_negocio/index.rst: 20 BR que influyen en BReq

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
     - Version inicial con 5 BReq documentados

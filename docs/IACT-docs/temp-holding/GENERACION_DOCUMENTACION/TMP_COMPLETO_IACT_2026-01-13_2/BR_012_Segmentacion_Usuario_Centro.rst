.. meta::
   :artefacto: BR_012
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-012:

==============================================================================
BR_012: Segmentacion Usuario-Centro
==============================================================================

----

Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_012
   * - **Nombre**
     - Segmentacion Usuario-Centro
   * - **Tipo**
     - Hecho
   * - **Categoria**
     - Operacional
   * - **Criticidad**
     - Media
   * - **Estado**
     - Vigente

----

1. Definicion Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

Cada usuario TIENE asignado uno o mas Centros de Atencion. El usuario
solo PUEDE ver datos de los centros asignados. Esta segmentacion
aplica a reportes, dashboards y alertas.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   VOCABULARIO:
     - Centro: Ubicacion fisica de call center
     - Segmento: Conjunto de centros asignados a usuario
     - Filtro de segmento: Restriccion automatica de datos

   REGLA:
     Es obligatorio que cada usuario tenga al menos un centro asignado.
     Es obligatorio que consultas filtren por centros del usuario.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

Permite que supervisores vean solo datos de sus centros asignados,
manteniendo segregacion de informacion entre unidades operativas.

----

2. Clasificacion
----------------

- **Tipo**: Hecho
- **Naturaleza**: Dinamica (asignaciones cambian)
- **Automatizable**: Si

----

3. Aplicacion en Sistema
------------------------

- MOD_Access: Gestiona asignacion usuario-centro
- MOD_Reports: Aplica filtro de segmento en consultas
- UC-041: Asignar Segmento de Datos

----

4. Trazabilidad
---------------

- BReq-003: Decisiones Informadas (datos relevantes por centro)
- UC-017 a UC-030: Reportes y Dashboards filtrados

----

5. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Descripcion del Cambio
   * - 1.0.0
     - 2026-01-04
     - Equipo IACT
     - Version inicial

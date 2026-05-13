.. meta::
   :artefacto: BR_020
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-020:

==============================================================================
BR_020: Rango Temporal de Reportes
==============================================================================

----

Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_020
   * - **Nombre**
     - Rango Temporal de Reportes
   * - **Tipo**
     - Restriccion
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

Los reportes NO PUEDEN consultar datos con rango temporal mayor a
12 meses en una sola consulta. Para rangos mayores, se requiere
generar reportes parciales o solicitar exportacion batch.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   REGLA:
     Es prohibido que reportes consulten mas de 12 meses de datos.
     Es obligatorio segmentar consultas que excedan el limite.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

Protege rendimiento del sistema, evita queries que consuman
excesivos recursos, y asegura tiempos de respuesta aceptables.

----

2. Clasificacion
----------------

- **Tipo**: Restriccion
- **Naturaleza**: Estatica
- **Automatizable**: Si

----

3. Aplicacion en Sistema
------------------------

- MOD_Reports: Valida rango temporal en consultas
- UC-017 a UC-024: Aplican restriccion de rango
- UC-020: Filtrar Reportes por Fecha

----

4. Trazabilidad
---------------

- BReq-003: Decisiones Informadas (datos accesibles)

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

.. meta::
   :artefacto: BR_019
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-019:

==============================================================================
BR_019: Clasificacion de Datos
==============================================================================

----

Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_019
   * - **Nombre**
     - Clasificacion de Datos
   * - **Tipo**
     - Hecho
   * - **Categoria**
     - Compliance
   * - **Criticidad**
     - Alta
   * - **Estado**
     - Vigente

----

1. Definicion Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

Los datos del sistema SE CLASIFICAN en tres niveles: PUBLICO, INTERNO,
y CONFIDENCIAL. El nivel de clasificacion determina los controles de
acceso y proteccion aplicables.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   VOCABULARIO:
     - PUBLICO: Sin restricciones de acceso
     - INTERNO: Solo usuarios autenticados
     - CONFIDENCIAL: Solo roles con permiso especifico

   REGLA:
     Es obligatorio que cada dato tenga clasificacion asignada.
     Es obligatorio aplicar controles segun nivel de clasificacion.

----

2. Clasificacion
----------------

- **Tipo**: Hecho
- **Naturaleza**: Estatica
- **Automatizable**: Si

----

3. Origen y Autoridad
---------------------

- **Documento**: CNST_010_Clasificacion_Proteccion_Datos
- **Tipo Fuente**: CNST

----

4. Aplicacion en Sistema
------------------------

- Todos los modulos: Aplican controles segun clasificacion
- Datos IVR: CONFIDENCIAL
- Reportes agregados: INTERNO
- Documentacion publica: PUBLICO

----

5. Trazabilidad
---------------

- CNST_010: Define politica de clasificacion
- BReq-004: Cumplimiento de Seguridad

----

6. Historial de Cambios
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

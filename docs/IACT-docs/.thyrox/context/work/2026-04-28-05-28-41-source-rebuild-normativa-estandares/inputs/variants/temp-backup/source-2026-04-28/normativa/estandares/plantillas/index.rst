.. meta::
   :artefacto: INDEX_plantillas
   :tipo: Indice
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Activo
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT

.. _index-plantillas:

================
Plantillas (TPL)
================


Descripcion
-----------

Este subdominio contiene las **17 plantillas estandar** del proyecto IACT.
Cada plantilla define la estructura obligatoria para crear artefactos
de documentacion consistentes y trazables.

**Nomenclatura:**

::

   TPL_[PREFIJO]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst

----

Metricas
--------

.. list-table::
   :widths: 40 30 30
   :header-rows: 1

   * - Categoria
     - Cantidad
     - Estado
   * - Criticos (P0)
     - 4
     - Completo
   * - Requisitos (P1)
     - 3
     - Completo
   * - Arquitectura (P2)
     - 6
     - Completo
   * - Gobernanza (P3)
     - 4
     - Completo
   * - **Total**
     - **17**
     - **Completo**

**Estadisticas:**

.. list-table::
   :widths: 50 50
   :header-rows: 0

   * - **Total Lineas**
     - 9,498
   * - **Promedio por TPL**
     - 559 lineas
   * - **Ultimo Actualizado**
     - 2026-01-07

----

Plantillas Criticas (P0)
------------------------

Plantillas necesarias para la fase actual de generacion de artefactos.

.. toctree::
   :maxdepth: 1
   :caption: P0 - Criticos

   TPL_FR_Requisitos_Funcionales_1_0_0
   TPL_BR_Business_Rules_1_0_0
   TPL_PROC_Procedimientos_1_0_0
   TPL_TST_Pruebas_1_0_0

----

Plantillas de Requisitos (P1)
-----------------------------

Plantillas para documentar requisitos del sistema.

.. toctree::
   :maxdepth: 1
   :caption: P1 - Requisitos

   TPL_BReq_Objetivos_Negocio_1_0_0
   TPL_NFR_No_Funcionales_1_0_0
   TPL_UC_Casos_de_Uso_2_0_0

----

Plantillas de Arquitectura (P2)
-------------------------------

Plantillas para documentar arquitectura tecnica.

.. toctree::
   :maxdepth: 1
   :caption: P2 - Arquitectura

   TPL_CNST_Restricciones_1_0_0
   TPL_MOD_Modulos_1_0_0
   TPL_ADR_Decisiones_Arquitectonicas_1_0_0
   TPL_FD_Flujos_Datos_1_0_0
   TPL_VIEW_Vistas_Arquitectonicas_1_0_0
   TPL_API_Documentacion_API_1_1_0

----

Plantillas de Gobernanza (P3)
-----------------------------

Plantillas para documentar normativa y evidencia.

.. toctree::
   :maxdepth: 1
   :caption: P3 - Gobernanza

   TPL_STD_Estandares_1_0_0
   TPL_POL_Politicas_1_0_0
   TPL_RTM_Trazabilidad_1_0_0
   TPL_INDEX_Indices_1_0_0

----

Catalogo Completo
-----------------

.. list-table::
   :widths: 5 40 15 15 25
   :header-rows: 1

   * - #
     - Plantilla
     - Version
     - Lineas
     - Para Artefacto
   * - 1
     - TPL_FR_Requisitos_Funcionales
     - 1.0.0
     - 428
     - FR_xxx
   * - 2
     - TPL_BR_Business_Rules
     - 1.0.0
     - 531
     - BR_xxx
   * - 3
     - TPL_PROC_Procedimientos
     - 1.0.0
     - 577
     - PROC_xxx
   * - 4
     - TPL_TST_Pruebas
     - 1.0.0
     - 587
     - TST_xxx
   * - 5
     - TPL_BReq_Objetivos_Negocio
     - 1.0.0
     - 539
     - BReq_xxx
   * - 6
     - TPL_NFR_No_Funcionales
     - 1.0.0
     - 577
     - NFR_xxx
   * - 7
     - TPL_UC_Casos_de_Uso
     - 2.0.0
     - 493
     - UC_xxx
   * - 8
     - TPL_CNST_Restricciones
     - 1.0.0
     - 522
     - CNST_xxx
   * - 9
     - TPL_MOD_Modulos
     - 1.0.0
     - 570
     - MOD_xxx
   * - 10
     - TPL_ADR_Decisiones_Arquitectonicas
     - 1.0.0
     - 512
     - ADR_xxx
   * - 11
     - TPL_FD_Flujos_Datos
     - 1.0.0
     - 562
     - FD_xxx
   * - 12
     - TPL_VIEW_Vistas_Arquitectonicas
     - 1.0.0
     - 528
     - VIEW_xxx
   * - 13
     - TPL_API_Documentacion_API
     - 1.1.0
     - 893
     - API_xxx
   * - 14
     - TPL_STD_Estandares
     - 1.0.0
     - 499
     - STD_xxx
   * - 15
     - TPL_POL_Politicas
     - 1.0.0
     - 553
     - POL_xxx
   * - 16
     - TPL_RTM_Trazabilidad
     - 1.0.0
     - 573
     - RTM_xxx
   * - 17
     - TPL_INDEX_Indices
     - 1.0.0
     - 554
     - index.rst

----

Uso de Plantillas
-----------------

Para usar una plantilla:

1. Identificar el tipo de artefacto a crear
2. Localizar la TPL correspondiente en este indice
3. Copiar la seccion "Plantilla" del archivo TPL
4. Crear nuevo archivo con nomenclatura correcta
5. Reemplazar todos los [PLACEHOLDER]
6. Validar con sphinx-build

**Ejemplo:**

::

   # Para crear una nueva Business Rule
   1. Abrir TPL_BR_Business_Rules_1_0_0.rst
   2. Copiar seccion "Plantilla"
   3. Crear BR_021_Nueva_Regla.rst
   4. Completar contenido
   5. Validar

----

Trazabilidad
------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **STD Relacionado**
     - STD_002: Nomenclatura de Artefactos
   * - **PROC Relacionado**
     - PROC_004 a PROC_011: Procedimientos de Generacion
   * - **Ubicacion**
     - normativa/estandares/plantillas/

----

Historial de Cambios
--------------------

.. list-table::
   :widths: 12 12 20 56
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Version inicial con 17 plantillas completas

----

*Indice version 1.0.0 - Proyecto IACT Dashboard Analytics*


.. toctree::
   :hidden:
   :maxdepth: 1

   TPL_002_Plantilla_UC_v2

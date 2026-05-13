.. meta::
   :artefacto: PROC_Crear_Plan_Analisis
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Generacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT

.. _proc-crear-plan-analisis:

======================================================
PROC_Crear_Plan_Analisis: Crear Documentos de Analisis
======================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Crear_Plan_Analisis
   * - **Nombre**
     - Crear Documentos de Analisis y Planificacion
   * - **Categoria**
     - Generacion
   * - **Duracion**
     - 15-45 minutos

----

1. Proposito
------------

Crear documentos de analisis (.md) para planificar sesiones de generacion.

----

2. Alcance
----------

**Aplica A:** Planes, analisis, reportes, inventarios.

**No Aplica A:** Artefactos formales del modelo documental.

----

3. Tipos de Documentos
----------------------

.. list-table::
   :header-rows: 1

   * - Tipo
     - Nomenclatura
     - Uso
   * - Plan
     - PLAN_[Tema]_vX_Y_Z.md
     - Planificar actividades
   * - Analisis
     - ANALISIS_[Tema]_vX_Y_Z.md
     - Documentar hallazgos
   * - Reporte
     - REPORTE_[Tema].md
     - Resumir resultados

----

4. Procedimiento
----------------

**Paso 1: Definir Nomenclatura**

Formato: ``[TIPO]_[Tema]_v[X]_[Y]_[Z].md``

**Paso 2: Crear Estructura**

Secciones obligatorias: Titulo, Fecha, Version, Resumen, Contenido, Conclusiones.

**Paso 3: Agregar Metricas**

Tablas con datos cuantitativos y tracking de progreso.

**Paso 4: Guardar en /tmp**

.. code-block:: bash

   /tmp/PLAN_FR_GENERACION_v1_0_0.md

**Paso 5: Copiar a outputs**

Ejecutar PROC_Copiar_Tmp_Outputs.

----

5. Artefactos de Salida
-----------------------

.. list-table::
   :header-rows: 1

   * - Artefacto
     - Ubicacion
   * - [TIPO]_[Tema]_vX_Y_Z.md
     - /tmp/ -> /outputs/

----

6. Verificacion
---------------

- [ ] Nombre sigue nomenclatura
- [ ] Secciones completas
- [ ] Metricas incluidas

----

7. Referencias
--------------

- PROC_Copiar_Tmp_Outputs

----

8. Historial
------------

.. list-table::
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Version inicial

----

*Documento version 1.0.0 - Proyecto IACT*

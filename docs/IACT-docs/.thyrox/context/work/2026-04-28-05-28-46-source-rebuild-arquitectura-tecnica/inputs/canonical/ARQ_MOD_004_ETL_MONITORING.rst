.. =============================================================================
.. ARQ_MOD_004_ETL_MONITORING.rst
.. Modulo Funcional: Supervision del ETL, Calidad y Disponibilidad de Datos
.. Version: 1.0.0
.. =============================================================================

=========================================================
ARQ_MOD_004: Supervision ETL y Calidad (ETL_MONITORING)
=========================================================

.. metadata::
   :id: ARQ_MOD_004
   :codigo: ETL_MONITORING
   :nombre: Supervision del ETL, Calidad y Disponibilidad de Datos
   :version: 1.0.0
   :estado: APROBADO
   :fecha_creacion: 2025-12-22

.. contents:: Contenido
   :local:
   :depth: 2

----

1. Proposito
============

El modulo ETL_MONITORING **supervisa el pipeline ETL** sin ejecutarlo.
Permite ver el estado de las cargas, disponibilidad de datos, y errores
de transformacion.

**Pregunta clave que responde:**

   *"¿El ETL esta bien, cuando corrio, que datos tengo disponibles y que fallo?"*

**NO ejecuta ETL** desde la UI. El ETL corre como job nocturno automatizado.

----

2. Alcance
==========

2.1 Incluye
-----------

- Consultar historico de ejecuciones ETL (jobs, duracion, resultado)
- Ver detalle de una ejecucion (tablas, metricas, errores)
- Consultar disponibilidad de datos por periodo (trimestres completos/parciales)
- Consultar incidencias de calidad (nulos, duplicados, inconsistencias)
- Reintentar procesamiento logico sobre datos ya extraidos

2.2 Excluye (NO incluye)
------------------------

- Ejecutar ETL manualmente → Job nocturno automatizado
- Generar reportes de negocio → **ARQ_MOD_005_VIS_REPORTS**
- Exponer logs tecnicos crudos → **ARQ_MOD_008_SYS_LOGS**
- Consultas directas a BD IVR (mas alla de vw_llamadas) → CNST_003

----

3. Responsabilidades
====================

3.1 PUEDE Hacer
---------------

.. list-table::
   :widths: 55 20 25
   :header-rows: 1

   * - Responsabilidad
     - UC Relacionado
     - CNST
   * - Listar ejecuciones ETL historicas
     - UC_051
     - -
   * - Mostrar duracion, resultado, volumen
     - UC_051
     - -
   * - Ver detalle de ejecucion (errores, metricas)
     - UC_052
     - CNST_004
   * - Consultar que fechas/trimestres estan disponibles
     - UC_053
     - CNST_003
   * - Listar incidencias de calidad de datos
     - UC_054
     - -
   * - Reintentar transformacion sobre datos ya extraidos
     - UC_055
     - CNST_004

3.2 NO PUEDE Hacer (Violaciones)
--------------------------------

.. warning::

   Las siguientes acciones **violan la separacion de responsabilidades**:

- **Generar tablas/graficos operativos para usuario final**
  
  - Ejemplo: Dashboard de llamadas por centro
  - Eso es responsabilidad de → **ARQ_MOD_005_VIS_REPORTS**

- **Exponer logs tecnicos crudos del sistema**
  
  - Ejemplo: Stack traces, errores de servidor
  - Eso es responsabilidad de → **ARQ_MOD_008_SYS_LOGS**

- **Consultar BD IVR directamente**
  
  - Solo puede usar vista vw_llamadas
  - Viola → **CNST_003** (BD dual inmutable)

- **Definir reglas de seguridad**
  
  - Ejemplo: "Si falla N veces, bloquear algo"
  - Eso es responsabilidad de → **ARQ_MOD_003_RBAC_CORE** (enforcers)

----

4. Dependencias
===============

4.1 Depende de
--------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_001_AUTH
     - Requiere sesion autenticada
   * - ARQ_MOD_003_RBAC_CORE
     - Verifica permisos de supervision ETL

4.2 Es Requerido por
--------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_005_VIS_REPORTS
     - Consulta disponibilidad de datos antes de mostrar
   * - ARQ_MOD_006_ALERTS
     - Puede generar alertas por fallos ETL

----

5. Componentes Tecnicos
=======================

5.1 Apps Django
---------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - App
     - Descripcion
   * - apps.etl
     - Modelos ETLExecution, vistas de supervision
   * - apps.monitoring
     - Metricas de calidad de datos

5.2 Modelos de Datos
--------------------

- **DSC_MOD_005_ETLExecution** - Registro de ejecuciones

.. code-block:: python

   class ETLExecution(models.Model):
       job_id = models.CharField(max_length=50, unique=True)
       started_at = models.DateTimeField()
       finished_at = models.DateTimeField(null=True)
       status = models.CharField(choices=ETL_STATUS)  # RUNNING, SUCCESS, FAILED
       records_extracted = models.IntegerField(default=0)
       records_transformed = models.IntegerField(default=0)
       records_loaded = models.IntegerField(default=0)
       error_message = models.TextField(null=True)
       date_range_start = models.DateField()
       date_range_end = models.DateField()
       
   class DataAvailability(models.Model):
       period_type = models.CharField()  # TRIMESTRE, MES, DIA
       period_value = models.CharField()  # Q1-2024, 2024-01
       status = models.CharField()  # COMPLETO, PARCIAL, FALTANTE
       record_count = models.IntegerField()
       last_updated = models.DateTimeField()

5.3 APIs Expuestas
------------------

- **API_004_ETL_Endpoints**

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - Metodo
     - Endpoint
     - Descripcion
   * - GET
     - /api/v1/etl/executions
     - Listar ejecuciones
   * - GET
     - /api/v1/etl/executions/{id}
     - Detalle de ejecucion
   * - GET
     - /api/v1/etl/availability
     - Disponibilidad por periodo
   * - GET
     - /api/v1/etl/quality-issues
     - Incidencias de calidad
   * - POST
     - /api/v1/etl/retry/{id}
     - Reintentar procesamiento

----

6. Restricciones Aplicables
===========================

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - CNST
     - Descripcion y Aplicacion
   * - CNST_003
     - **BD Dual Inmutable**: Solo lectura de IVR via vw_llamadas.
       Analytics es la unica BD escribible.
   * - CNST_004
     - **Actualizacion Datos ETL**: ETL nocturno, no manual.
       Sin TRUNCATE, solo INSERT/UPDATE controlado.

----

7. Casos de Uso Asociados
=========================

.. list-table::
   :widths: 12 40 48
   :header-rows: 1

   * - UC ID
     - Nombre
     - Descripcion
   * - UC_051
     - Consultar_Ejecuciones_ETL
     - Historico de jobs con duracion y resultado
   * - UC_052
     - Ver_Detalle_Ejecucion_ETL
     - Metricas, errores, rangos de fecha
   * - UC_053
     - Consultar_Disponibilidad_Datos
     - Trimestres completos/parciales/faltantes
   * - UC_054
     - Consultar_Incidencias_Calidad
     - Nulos, duplicados, inconsistencias
   * - UC_055
     - Reintentar_Procesamiento
     - Reprocesar metricas sin tocar origen

----

8. Requisitos Funcionales Derivados
===================================

.. list-table::
   :widths: 12 45 20 23
   :header-rows: 1

   * - FR ID
     - Nombre
     - Deriva de
     - Descripcion
   * - FR_016
     - Listar_Ejecuciones_ETL
     - UC_051
     - Paginacion, filtros por fecha
   * - FR_017
     - Cargar_Detalle_ETL
     - UC_052
     - Incluir metricas y errores
   * - FR_018
     - Consultar_Disponibilidad
     - UC_053
     - Por trimestre, mes, dia
   * - FR_019
     - Listar_Incidencias_Calidad
     - UC_054
     - Filtrar por tipo y severidad

----

9. Flujo ETL (Solo Supervision)
===============================

.. code-block:: text

   +----------------+          +------------------+
   |  BD IVR        |          |  BD Analytics    |
   |  (MySQL)       |          |  (PostgreSQL)    |
   |  SOLO LECTURA  |          |  ESCRIBIBLE      |
   +-------+--------+          +--------+---------+
           |                            ^
           | vw_llamadas (vista)        |
           |                            |
           v                            |
   +-------+----------------------------+--------+
   |              ETL NOCTURNO                    |
   |   (Job automatizado, NO manual desde UI)    |
   |                                             |
   |   1. Extract: SELECT FROM vw_llamadas       |
   |   2. Transform: Calcular metricas           |
   |   3. Load: INSERT INTO analytics            |
   +---------------------------------------------+
           |
           | (registra ejecucion)
           v
   +-------+--------+
   | ETL_MONITORING |
   | (SUPERVISION)  |
   +----------------+

----

10. Historial de Cambios
========================

.. list-table::
   :widths: 12 15 73
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 1.0.0
     - 2025-12-22
     - Version inicial

----

*Documento de Arquitectura - ARQ_MOD_004_ETL_MONITORING*
*Proyecto IACT Dashboard Analytics*
*Version 1.0.0*

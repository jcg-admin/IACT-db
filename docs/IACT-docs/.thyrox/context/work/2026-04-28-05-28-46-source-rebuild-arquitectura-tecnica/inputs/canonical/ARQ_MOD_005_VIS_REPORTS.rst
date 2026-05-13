.. =============================================================================
.. ARQ_MOD_005_VIS_REPORTS.rst
.. Modulo Funcional: Visualizacion y Reportes Operativos del IVR
.. Version: 1.0.0
.. =============================================================================

=========================================================
ARQ_MOD_005: Visualizacion y Reportes (VIS_REPORTS)
=========================================================

.. metadata::
   :id: ARQ_MOD_005
   :codigo: VIS_REPORTS
   :nombre: Visualizacion y Reportes Operativos del IVR
   :version: 1.0.0
   :estado: APROBADO
   :fecha_creacion: 2025-12-22

.. contents:: Contenido
   :local:
   :depth: 2

----

1. Proposito
============

El modulo VIS_REPORTS es el **punto unico** para dashboards, reportes tabulares
y exportaciones del sistema IACT. Consume datos ya procesados por el ETL y
aplica permisos de RBAC_CORE.

**Pregunta clave que responde:**

   *"¿Que ve el usuario y que puede descargar, segun sus permisos, con datos del ETL?"*

----

2. Alcance
==========

2.1 Incluye
-----------

**Reportes Tabulares:**

- Reporte trimestral consolidado
- Reporte de problemas de menu/errores
- Reporte de transferencias y rutas de llamada

**Filtros y Criterios:**

- Filtros de fecha (presets, rango personalizado, limite 2 anos)
- Filtros por centro, servicio, cola, otros campos de negocio

**Exportaciones:**

- Exportar a CSV
- Exportar a Excel
- Exportar a PDF
- (Con limites diarios segun CNST_007)

**Dashboards:**

- Dashboard principal del IVR
- Widgets de resumen operativo
- Graficos por hora/dia
- Distribucion por centro/servicio/menu
- Personalizacion de layout (max 10 widgets)

2.2 Excluye (NO incluye)
------------------------

- Ejecutar ETL o agendar jobs → **ARQ_MOD_004_ETL_MONITORING**
- Implementar logica RBAC → **ARQ_MOD_003_RBAC_CORE**
- Real-time (WebSockets, SSE, auto-refresh) → **CNST_003**
- Consultas directas a BD IVR → **CNST_003**

----

3. Responsabilidades
====================

3.1 PUEDE Hacer
---------------

.. list-table::
   :widths: 50 15 15 20
   :header-rows: 1

   * - Responsabilidad
     - UC
     - CNST
     - Subcategoria
   * - Mostrar reporte trimestral consolidado
     - UC_017
     - -
     - Reportes
   * - Mostrar reporte de errores/menu
     - UC_018
     - -
     - Reportes
   * - Mostrar reporte de transferencias
     - UC_019
     - -
     - Reportes
   * - Aplicar filtros de fecha (max 2 anos)
     - UC_020
     - CNST_007
     - Filtros
   * - Aplicar filtros de negocio
     - UC_021
     - -
     - Filtros
   * - Exportar a CSV
     - UC_022
     - CNST_007
     - Export
   * - Exportar a Excel
     - UC_023
     - CNST_007
     - Export
   * - Exportar a PDF
     - UC_024
     - CNST_007
     - Export
   * - Mostrar dashboard principal
     - UC_025
     - -
     - Dashboard
   * - Mostrar widgets de resumen
     - UC_026
     - -
     - Dashboard
   * - Mostrar graficos por hora
     - UC_027
     - -
     - Dashboard
   * - Mostrar graficos por dia
     - UC_028
     - -
     - Dashboard
   * - Mostrar distribucion por centro
     - UC_029
     - -
     - Dashboard
   * - Personalizar layout (max 10 widgets)
     - UC_030
     - -
     - Dashboard

3.2 NO PUEDE Hacer (Violaciones)
--------------------------------

.. warning::

   Las siguientes acciones **violan la separacion de responsabilidades**:

- **Ejecutar ETL o agendar jobs**
  
  - Eso es responsabilidad de → **ARQ_MOD_004_ETL_MONITORING** / Backend
  - El ETL es nocturno y automatizado

- **Implementar logica de RBAC**
  
  - Ejemplo: Resolver roles, calcular precedencia
  - Eso es responsabilidad de → **ARQ_MOD_003_RBAC_CORE**
  - VIS_REPORTS solo **consume** permisos ya calculados

- **Usar real-time (WebSockets, SSE, auto-refresh)**
  
  - Viola → **CNST_003** (no tiempo real)
  - Los datos se actualizan con el ETL nocturno

- **Consultar BD IVR directamente**
  
  - Solo puede usar datos de BD Analytics
  - Viola → **CNST_003** (BD dual inmutable)

----

4. Flujo de Acceso
==================

.. code-block:: text

   1. Usuario entra a VIS_REPORTS
          |
          v
   2. Sistema consulta RBAC_CORE
      "¿Que dashboards/reportes puede ver?"
      "¿Tiene permiso de exportacion?"
          |
          v
   3. Aplicar filtro de segmentos
      (Centro, Servicio, Region segun RBAC)
          |
          v
   4. Mostrar interfaz filtrada:
      - Si tiene 'view' → ve tablas/graficas
      - Si tiene 'export' → ve botones CSV/Excel/PDF
          |
          v
   5. Si exporta → validar limites diarios (CNST_007)

----

5. Dependencias
===============

5.1 Depende de
--------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_001_AUTH
     - Requiere sesion autenticada
   * - ARQ_MOD_003_RBAC_CORE
     - Obtiene permisos efectivos y segmentos
   * - ARQ_MOD_004_ETL_MONITORING
     - Consulta disponibilidad de datos

5.2 Es Requerido por
--------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_006_ALERTS
     - Puede usar metricas para configurar alertas
   * - ARQ_MOD_007_AUDIT
     - Registra exportaciones realizadas

----

6. Componentes Tecnicos
=======================

6.1 Apps Django
---------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - App
     - Descripcion
   * - apps.analytics
     - Modelos de metricas, repositorios de consulta
   * - apps.reports
     - Vistas y serializadores de reportes
   * - apps.exports
     - Servicios de generacion CSV/Excel/PDF

6.2 Modelos de Datos
--------------------

- **DSC_MOD_006_DailyMetrics** - Metricas diarias agregadas

.. code-block:: python

   class DailyMetrics(models.Model):
       date = models.DateField()
       center_code = models.CharField(max_length=50)
       service_code = models.CharField(max_length=50)
       total_calls = models.IntegerField()
       avg_duration = models.DecimalField()
       successful_calls = models.IntegerField()
       failed_calls = models.IntegerField()
       transfers = models.IntegerField()
       
       class Meta:
           unique_together = ['date', 'center_code', 'service_code']

6.3 APIs Expuestas
------------------

- **API_005_Dashboard_Endpoints**
- **API_006_Reports_Endpoints**

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - Metodo
     - Endpoint
     - Descripcion
   * - GET
     - /api/v1/dashboard
     - Dashboard principal
   * - GET
     - /api/v1/dashboard/widgets
     - Widgets disponibles
   * - GET
     - /api/v1/reports/quarterly
     - Reporte trimestral
   * - GET
     - /api/v1/reports/errors
     - Reporte de errores
   * - GET
     - /api/v1/reports/transfers
     - Reporte transferencias
   * - POST
     - /api/v1/exports/csv
     - Exportar CSV
   * - POST
     - /api/v1/exports/excel
     - Exportar Excel
   * - POST
     - /api/v1/exports/pdf
     - Exportar PDF

----

7. Restricciones Aplicables
===========================

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - CNST
     - Descripcion y Aplicacion
   * - CNST_003
     - **BD Dual Inmutable**: Solo consume datos de Analytics. 
       NO consulta IVR directamente. NO real-time.
   * - CNST_007
     - **Limites Performance SLA**: Max 10,000 registros por consulta.
       Max 5 exportaciones/dia por usuario. Timeout 30s.

----

8. Casos de Uso Asociados (14 UC)
=================================

.. list-table::
   :widths: 12 40 48
   :header-rows: 1

   * - UC ID
     - Nombre
     - Descripcion
   * - UC_017
     - Consultar_Reporte_Trimestral
     - Consolidado por trimestre
   * - UC_018
     - Consultar_Reporte_Errores
     - Problemas de menu IVR
   * - UC_019
     - Consultar_Reporte_Transferencias
     - Rutas de llamada
   * - UC_020
     - Aplicar_Filtros_Fecha
     - Presets y rangos (max 2 anos)
   * - UC_021
     - Aplicar_Filtros_Negocio
     - Centro, servicio, cola
   * - UC_022
     - Exportar_Reporte_CSV
     - Formato CSV
   * - UC_023
     - Exportar_Reporte_Excel
     - Formato XLSX
   * - UC_024
     - Exportar_Reporte_PDF
     - Formato PDF
   * - UC_025
     - Consultar_Dashboard_Principal
     - Vista principal IVR
   * - UC_026
     - Consultar_Widgets_Resumen
     - KPIs operativos
   * - UC_027
     - Ver_Graficos_Hora
     - Temporal por hora
   * - UC_028
     - Ver_Graficos_Dia
     - Temporal por dia
   * - UC_029
     - Ver_Distribucion_Centro
     - Por centro/servicio
   * - UC_030
     - Personalizar_Layout_Dashboard
     - Max 10 widgets

----

9. Requisitos Funcionales Derivados
===================================

.. list-table::
   :widths: 12 45 20 23
   :header-rows: 1

   * - FR ID
     - Nombre
     - Deriva de
     - Descripcion
   * - FR_020
     - Cargar_Dashboard
     - UC_025
     - Widgets priorizados
   * - FR_021
     - Aplicar_Filtros
     - UC_020, UC_021
     - Fecha y negocio
   * - FR_022
     - Generar_CSV
     - UC_022
     - Con limites
   * - FR_023
     - Generar_Excel
     - UC_023
     - Con limites
   * - FR_024
     - Generar_PDF
     - UC_024
     - Con limites
   * - FR_025
     - Renderizar_Widgets
     - UC_026-029
     - Graficos y tablas
   * - FR_026
     - Guardar_Layout_Personalizado
     - UC_030
     - Max 10 widgets

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
     - Version inicial. 14 UC, punto unico de visualizacion.

----

*Documento de Arquitectura - ARQ_MOD_005_VIS_REPORTS*
*Proyecto IACT Dashboard Analytics*
*Version 1.0.0*

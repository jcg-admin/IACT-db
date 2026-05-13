.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_14
   :normativa: CNST-003, CNST-004

===============================
UC_RPT_14: Ver Reporte Campanas
===============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_14
   * - **Nombre**
     - Ver Reporte Campanas
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-014: ve_campanas
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-RPT-014

2. Descripcion
--------------

Reporte especializado de rendimiento de campanas de llamadas salientes
o entrantes especiales. Muestra metricas de efectividad y conversion.

**Metricas de Campanas:**

- Llamadas realizadas/recibidas
- Contactos efectivos
- Tasa de conversion
- Tiempo promedio de llamada
- Resultado por agente

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_14

   @startuml
   left to right direction
   actor "AGR-003\nagr_supervisor" as USER
   rectangle "MOD_Reports" {
     usecase "UC_RPT_14\nVer Reporte Campanas" as UC14
     usecase "Ver Detalle\nCampana" as DET
     usecase "Comparar\nCampanas" as COMP
   }
   USER --> UC14
   UC14 --> DET : extend
   UC14 --> COMP : extend
   @enduml

4. Contexto de Ejecucion
------------------------

4.1 Precondiciones
^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Precondicion
   * - PRE-01
     - Usuario tiene funcion RPT-014
   * - PRE-02
     - Existen campanas en el segmento

4.2 Trigger
^^^^^^^^^^^

Usuario accede a reporte de campanas.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra reporte de campanas del segmento

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Usuario
     - Accede a reporte de campanas
   * - 2
     - Sistema
     - Valida RPT-014
   * - 3
     - Sistema
     - Consulta campanas del segmento
   * - 4
     - Sistema
     - Calcula metricas de efectividad
   * - 5
     - Sistema
     - Renderiza tabla y graficos
   * - 6
     - Usuario
     - Selecciona campana para detalle

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_14

   @startuml
   actor "Usuario" as U
   participant "Frontend" as FE
   participant "ReportController" as RC
   participant "CampaignReportService" as CRS
   database "Analytics" as DB

   U -> FE: Reporte Campanas
   FE -> RC: GET /api/reports/campaigns
   RC -> RC: verify_function(RPT-014)
   RC -> RC: get_user_segment()
   RC -> CRS: get_campaign_metrics(segmento)
   CRS -> DB: SELECT campana, metricas\nFROM vista_campanas\nWHERE segmento_id = ?
   note right: CNST-003
   DB --> CRS: campaign_data
   CRS -> CRS: calculate_conversion_rates()
   CRS --> RC: report_data
   RC --> FE: 200 OK
   FE --> U: Reporte de campanas
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Comparar Campanas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Usuario
     - Selecciona dos campanas a comparar
   * - 6b
     - Sistema
     - Muestra comparativa lado a lado

8. Excepciones
--------------

8.1 EX-01: Sin Campanas
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Condicion**
     - No hay campanas en el segmento
   * - **Mensaje**
     - No hay campanas registradas en su segmento

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_14

   @startuml
   start
   if (Tiene RPT-014?) then (no)
     stop
   else (si)
   endif
   :Consultar campanas del segmento;
   note right: CNST-004
   if (Hay campanas?) then (no)
     :Mostrar Sin campanas;
     stop
   else (si)
   endif
   :Calcular metricas;
   :Calcular conversion;
   :Renderizar reporte;
   if (Comparar?) then (si)
     :Mostrar comparativa;
   endif
   stop
   @enduml

10. Reglas de Negocio
---------------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - ID
     - Regla
     - Descripcion
   * - BR-RPT-130
     - Por Segmento
     - Solo campanas del segmento
   * - BR-RPT-131
     - Conversion
     - Tasa = contactos exitosos / total intentos

**Metricas de Campanas:**

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Metrica
     - Descripcion
   * - Intentos
     - Total llamadas realizadas
   * - Contactos
     - Llamadas contestadas
   * - Exitosos
     - Contactos con resultado positivo
   * - Conversion
     - Porcentaje de exito
   * - Duracion
     - Tiempo promedio de llamada

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion
   * - CNST-003
     - BD Dual
     - Datos de BD Analytics
   * - CNST-004
     - Segmentos
     - Solo campanas del segmento

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-130
     - Mostrar metricas de campanas
     - Tabla con metricas por campana
   * - FR-RPT-131
     - Comparar campanas
     - Vista lado a lado con variaciones

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-014
   * - **Restricciones**
     - CNST-003, CNST-004
   * - **UC Relacionados**
     - UC_RPT_12, UC_RPT_13
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Funcion RBAC**
     - RPT-014: ve_campanas

14. Historial de Cambios
------------------------

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 4.0.0
     - 2026-01-06
     - Version inicial v4.0
.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_12
   :normativa: CNST-003, CNST-004

==============================
UC_RPT_12: Ver Reporte Agentes
==============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_12
   * - **Nombre**
     - Ver Reporte Agentes
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-012: ve_agentes
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-RPT-012

2. Descripcion
--------------

Reporte especializado de rendimiento de agentes del call center.
Muestra metricas individuales y comparativas por agente.

**Metricas de Agentes:**

- Llamadas atendidas
- TMO por agente
- Tiempo en pausa
- Tiempo disponible
- Tasa de resolucion

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_12

   @startuml
   left to right direction
   actor "AGR-003\nagr_supervisor" as USER
   rectangle "MOD_Reports" {
     usecase "UC_RPT_12\nVer Reporte Agentes" as UC12
     usecase "Ver Detalle\nAgente" as DET
     usecase "Comparar\nAgentes" as COMP
   }
   USER --> UC12
   UC12 --> DET : extend
   UC12 --> COMP : extend
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
     - Usuario tiene funcion RPT-012
   * - PRE-02
     - Existen datos de agentes en el segmento

4.2 Trigger
^^^^^^^^^^^

Usuario accede a reporte de agentes.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra reporte de agentes del segmento

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
     - Accede a reporte de agentes
   * - 2
     - Sistema
     - Valida RPT-012
   * - 3
     - Sistema
     - Consulta metricas de agentes del segmento
   * - 4
     - Sistema
     - Calcula ranking por metricas
   * - 5
     - Sistema
     - Renderiza tabla comparativa
   * - 6
     - Usuario
     - Selecciona agente para detalle

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_12

   @startuml
   actor "Usuario" as U
   participant "Frontend" as FE
   participant "ReportController" as RC
   participant "AgentReportService" as ARS
   database "Analytics" as DB

   U -> FE: Reporte Agentes
   FE -> RC: GET /api/reports/agents
   RC -> RC: verify_function(RPT-012)
   RC -> RC: get_user_segment()
   RC -> ARS: get_agent_metrics(segmento)
   ARS -> DB: SELECT agente, metricas\nFROM vista_agentes\nWHERE segmento_id = ?
   note right: CNST-003
   DB --> ARS: agent_data
   ARS -> ARS: calculate_rankings()
   ARS --> RC: report_data
   RC --> FE: 200 OK
   FE --> U: Reporte de agentes
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Ver Detalle de Agente
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Usuario
     - Hace clic en agente
   * - 6b
     - Sistema
     - Muestra metricas detalladas del agente
   * - 6c
     - Sistema
     - Muestra tendencia historica

8. Excepciones
--------------

8.1 EX-01: Sin Agentes en Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Condicion**
     - No hay agentes en el segmento
   * - **Mensaje**
     - No hay agentes registrados en su segmento

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_12

   @startuml
   start
   if (Tiene RPT-012?) then (no)
     stop
   else (si)
   endif
   :Consultar agentes del segmento;
   note right: CNST-004
   if (Hay agentes?) then (no)
     :Mostrar Sin agentes;
     stop
   else (si)
   endif
   :Calcular metricas;
   :Generar ranking;
   :Renderizar reporte;
   if (Ver detalle?) then (si)
     :Mostrar detalle agente;
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
   * - BR-RPT-110
     - Por Segmento
     - Solo agentes del segmento
   * - BR-RPT-111
     - Ranking
     - Ordenamiento por metrica seleccionada

**Metricas de Agentes:**

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Metrica
     - Descripcion
   * - Llamadas
     - Total llamadas atendidas
   * - TMO
     - Tiempo medio de operacion
   * - Ocupacion
     - Porcentaje tiempo en llamada
   * - Disponibilidad
     - Porcentaje tiempo disponible

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
     - Solo agentes del segmento

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-110
     - Mostrar metricas de agentes
     - Tabla con metricas por agente
   * - FR-RPT-111
     - Ver detalle de agente
     - Metricas individuales y tendencia

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-012
   * - **Restricciones**
     - CNST-003, CNST-004
   * - **UC Relacionados**
     - UC_RPT_13, UC_RPT_14
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Funcion RBAC**
     - RPT-012: ve_agentes

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

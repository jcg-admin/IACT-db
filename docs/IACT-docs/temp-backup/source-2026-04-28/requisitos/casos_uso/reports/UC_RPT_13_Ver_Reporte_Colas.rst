.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_13
   :normativa: CNST-003, CNST-004

============================
UC_RPT_13: Ver Reporte Colas
============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_13
   * - **Nombre**
     - Ver Reporte Colas
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-013: ve_colas
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-RPT-013

2. Descripcion
--------------

Reporte especializado de rendimiento de colas de llamadas. Muestra
metricas de cada cola y permite analizar tiempos de espera y abandono.

**Metricas de Colas:**

- Llamadas recibidas
- Llamadas atendidas vs abandonadas
- Tiempo promedio de espera
- Nivel de servicio
- Picos de demanda

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_13

   @startuml
   left to right direction
   actor "AGR-003\nagr_supervisor" as USER
   rectangle "MOD_Reports" {
     usecase "UC_RPT_13\nVer Reporte Colas" as UC13
     usecase "Ver Detalle\nCola" as DET
     usecase "Ver\nTendencia" as TEND
   }
   USER --> UC13
   UC13 --> DET : extend
   UC13 --> TEND : extend
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
     - Usuario tiene funcion RPT-013
   * - PRE-02
     - Existen datos de colas en el segmento

4.2 Trigger
^^^^^^^^^^^

Usuario accede a reporte de colas.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra reporte de colas del segmento

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
     - Accede a reporte de colas
   * - 2
     - Sistema
     - Valida RPT-013
   * - 3
     - Sistema
     - Consulta metricas de colas del segmento
   * - 4
     - Sistema
     - Calcula nivel de servicio por cola
   * - 5
     - Sistema
     - Renderiza tabla y graficos
   * - 6
     - Usuario
     - Selecciona cola para detalle

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_13

   @startuml
   actor "Usuario" as U
   participant "Frontend" as FE
   participant "ReportController" as RC
   participant "QueueReportService" as QRS
   database "Analytics" as DB

   U -> FE: Reporte Colas
   FE -> RC: GET /api/reports/queues
   RC -> RC: verify_function(RPT-013)
   RC -> RC: get_user_segment()
   RC -> QRS: get_queue_metrics(segmento)
   QRS -> DB: SELECT cola, metricas\nFROM vista_colas\nWHERE segmento_id = ?
   note right: CNST-003
   DB --> QRS: queue_data
   QRS -> QRS: calculate_sla()
   QRS --> RC: report_data
   RC --> FE: 200 OK
   FE --> U: Reporte de colas
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Ver Tendencia Horaria
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Usuario
     - Selecciona Ver Tendencia
   * - 6b
     - Sistema
     - Muestra grafico de llamadas por hora

8. Excepciones
--------------

8.1 EX-01: Sin Colas en Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Condicion**
     - No hay colas en el segmento
   * - **Mensaje**
     - No hay colas registradas en su segmento

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_13

   @startuml
   start
   if (Tiene RPT-013?) then (no)
     stop
   else (si)
   endif
   :Consultar colas del segmento;
   note right: CNST-004
   if (Hay colas?) then (no)
     :Mostrar Sin colas;
     stop
   else (si)
   endif
   :Calcular metricas;
   :Calcular SLA;
   :Renderizar reporte;
   if (Ver tendencia?) then (si)
     :Mostrar grafico horario;
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
   * - BR-RPT-120
     - Por Segmento
     - Solo colas del segmento
   * - BR-RPT-121
     - SLA
     - Nivel de servicio = atendidas en umbral / total

**Metricas de Colas:**

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Metrica
     - Descripcion
   * - Recibidas
     - Total llamadas ingresadas a cola
   * - Atendidas
     - Llamadas contestadas
   * - Abandonadas
     - Llamadas abandonadas por cliente
   * - Tiempo Espera
     - Promedio de espera en cola
   * - SLA
     - Porcentaje atendidas en umbral

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
     - Solo colas del segmento

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-120
     - Mostrar metricas de colas
     - Tabla con metricas por cola
   * - FR-RPT-121
     - Ver tendencia horaria
     - Grafico de demanda por hora

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-013
   * - **Restricciones**
     - CNST-003, CNST-004
   * - **UC Relacionados**
     - UC_RPT_12, UC_RPT_14
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Funcion RBAC**
     - RPT-013: ve_colas

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
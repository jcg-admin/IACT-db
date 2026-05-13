.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_01
   :normativa: CNST-003, CNST-004

========================
UC_RPT_01: Ver Dashboard
========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_01
   * - **Nombre**
     - Ver Dashboard
   * - **Actor Principal**
     - AGR-001: agr_operador_basico
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-001: ve_reportes
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-RPT-001

2. Descripcion
--------------

Este caso de uso permite visualizar el dashboard principal con metricas
consolidadas del call center. Los datos mostrados estan filtrados
automaticamente por el segmento del usuario (CNST-004).

**Caracteristicas principales:**

- Vista consolidada de KPIs principales
- Filtrado automatico por segmento del usuario
- Datos leidos exclusivamente de BD Analytics (CNST-003)
- Auto-refresh cada 30 segundos
- Graficos de tendencia del dia

**KPIs Mostrados:**

- Total llamadas recibidas
- Llamadas atendidas / abandonadas
- Tiempo Medio de Operacion (TMO)
- Nivel de Servicio (%)
- Tiempo promedio de espera

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_01

   @startuml
   left to right direction
   actor "AGR-001\nagr_operador_basico" as USER

   rectangle "MOD_Reports" {
     usecase "UC_RPT_01\nVer Dashboard" as UC01
     usecase "Cargar KPIs" as KPI
     usecase "Filtrar por\nSegmento" as SEG
     usecase "Auto Refresh" as REF
     usecase "Ver Tendencias" as TEND
   }

   USER --> UC01
   UC01 --> KPI : include
   UC01 --> SEG : include
   UC01 --> REF : include
   UC01 --> TEND : extend
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
     - El usuario tiene sesion activa con funcion RPT-001
   * - PRE-02
     - El usuario tiene un segmento asignado
   * - PRE-03
     - Existen datos en BD Analytics para el segmento

4.2 Trigger
^^^^^^^^^^^

El usuario accede al modulo de reportes o al dashboard principal.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra dashboard con datos del segmento del usuario
   * - POST-02
     - El dashboard se actualiza automaticamente cada 30 segundos

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
     - Accede al dashboard
   * - 2
     - Sistema
     - Valida funcion RPT-001
   * - 3
     - Sistema
     - Obtiene segmento del usuario
   * - 4
     - Sistema
     - Consulta KPIs de BD Analytics con filtro de segmento
   * - 5
     - Sistema
     - Consulta tendencias del dia
   * - 6
     - Sistema
     - Renderiza dashboard con graficos
   * - 7
     - Sistema
     - Inicia temporizador de auto-refresh (30s)
   * - 8
     - Usuario
     - Visualiza metricas y tendencias

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_01

   @startuml
   actor "AGR-001 Usuario" as U
   participant "Frontend" as FE
   participant "ReportController" as RC
   participant "DashboardService" as DS
   participant "SegmentFilter" as SF
   database "Analytics" as DB

   U -> FE: Accede a Dashboard
   FE -> RC: GET /api/dashboard
   RC -> RC: verify_function(RPT-001)

   RC -> SF: get_user_segment(user)
   SF --> RC: segmento_id

   RC -> DS: get_dashboard_data(segmento_id)

   DS -> DB: SELECT\n  COUNT(*) as total_llamadas,\n  SUM(CASE WHEN atendida THEN 1 END) as atendidas,\n  AVG(duracion) as tmo\nFROM llamadas\nWHERE segmento_id = ?\nAND fecha = CURRENT_DATE
   note right of DB
     CNST-003: Solo lectura
     desde BD Analytics
   end note
   DB --> DS: kpis

   DS -> DB: SELECT hora, COUNT(*)\nFROM llamadas\nWHERE segmento_id = ?\nGROUP BY hora
   DB --> DS: tendencias

   DS --> RC: dashboard_data
   RC --> FE: 200 OK + data
   FE --> U: Dashboard renderizado

   loop cada 30 segundos
     FE -> RC: GET /api/dashboard
     RC --> FE: updated_data
     FE --> U: Dashboard actualizado
   end
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Sin Datos para el Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Sistema
     - No encuentra datos para el segmento del usuario
   * - 4b
     - Sistema
     - Muestra dashboard con valores en cero
   * - 4c
     - Sistema
     - Muestra mensaje: Sin datos disponibles para hoy

7.2 FA-02: Ver Detalle de KPI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 8a
     - Usuario
     - Hace clic en un KPI especifico
   * - 8b
     - Sistema
     - Navega a reporte detallado del KPI

8. Excepciones
--------------

8.1 EX-01: Sin Permiso RPT-001
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Usuario no tiene funcion RPT-001
   * - **Accion Sistema**
     - Rechaza acceso al dashboard
   * - **Mensaje Usuario**
     - No tiene permisos para ver reportes
   * - **Codigo Error**
     - RPT-001

8.2 EX-02: Usuario Sin Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 3
   * - **Condicion**
     - Usuario no tiene segmento asignado
   * - **Accion Sistema**
     - Rechaza acceso
   * - **Mensaje Usuario**
     - Usuario sin segmento asignado. Contacte al administrador.
   * - **Codigo Error**
     - RPT-002

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_01

   @startuml
   start
   :Usuario accede a Dashboard;

   if (Tiene RPT-001?) then (no)
     :Error permisos;
     stop
   else (si)
   endif

   :Obtener segmento del usuario;
   note right: CNST-004

   if (Tiene segmento?) then (no)
     :Error sin segmento;
     stop
   else (si)
   endif

   :Consultar KPIs de Analytics;
   note right: CNST-003

   :Consultar tendencias;

   if (Hay datos?) then (no)
     :Mostrar dashboard vacio;
   else (si)
     :Renderizar KPIs y graficos;
   endif

   :Iniciar auto-refresh 30s;

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
   * - BR-RPT-01
     - Filtro por Segmento
     - El usuario solo ve datos de su segmento asignado (CNST-004)
   * - BR-RPT-02
     - Auto Refresh
     - El dashboard se actualiza automaticamente cada 30 segundos
   * - BR-RPT-03
     - Solo Lectura
     - El dashboard es de solo lectura, no permite modificaciones
   * - BR-RPT-04
     - Datos del Dia
     - Por defecto muestra datos del dia actual

**Formulas de KPIs:**

.. code-block:: text

   TMO = SUM(duracion_llamadas) / COUNT(llamadas_atendidas)

   Nivel_Servicio = (llamadas_atendidas_en_umbral / total_llamadas) * 100

   Tasa_Abandono = (llamadas_abandonadas / total_llamadas) * 100

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-003
     - BD Dual
     - Los datos del dashboard se leen exclusivamente de BD Analytics. No se accede a BD IVR.
   * - CNST-004
     - Segmentos
     - El filtro por segmento se aplica automaticamente a todas las consultas. El usuario no puede ver datos de otros segmentos.

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-001
     - El sistema debe mostrar KPIs principales
     - Llamadas, TMO, abandono, nivel servicio visibles
   * - FR-RPT-002
     - El sistema debe filtrar por segmento automaticamente
     - Solo datos del segmento del usuario mostrados
   * - FR-RPT-003
     - El sistema debe auto-refrescar cada 30s
     - Datos actualizados sin recargar pagina
   * - FR-RPT-004
     - El sistema debe mostrar tendencias
     - Grafico de llamadas por hora del dia

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-001: Permitir visualizacion de dashboard principal
   * - **Reglas de Negocio**
     - BR-RPT-01 a BR-RPT-04
   * - **Restricciones**
     - CNST-003 (BD Dual), CNST-004 (Segmentos)
   * - **UC Relacionados**
     - UC_RPT_02 (Metricas RT), UC_RPT_03 (Historicos)
   * - **Actor Principal**
     - AGR-001: agr_operador_basico
   * - **Funcion RBAC**
     - RPT-001: ve_reportes

14. Historial de Cambios
------------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 4.0.0
     - 2026-01-06
     - Equipo IACT
     - Version inicial v4.0 con CNST-003 y CNST-004
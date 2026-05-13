.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_03
   :normativa: CNST-003, CNST-004, CNST-006

==================================
UC_RPT_03: Ver Reportes Historicos
==================================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_03
   * - **Nombre**
     - Ver Reportes Historicos
   * - **Actor Principal**
     - AGR-002: agr_operador_reportes
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-003: ve_historicos
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-RPT-003

2. Descripcion
--------------

Este caso de uso permite consultar reportes historicos con datos agregados
por periodo. Permite analizar tendencias, comparar periodos y generar
informes para toma de decisiones.

**Caracteristicas principales:**

- Consulta de datos historicos por rango de fechas
- Rango maximo de 2 anios (CNST-006)
- Agregaciones por dia, semana, mes
- Comparacion entre periodos
- Filtrado por segmento automatico (CNST-004)
- Multiples dimensiones de analisis

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_03

   @startuml
   left to right direction
   actor "AGR-002\nagr_operador_reportes" as USER

   rectangle "MOD_Reports" {
     usecase "UC_RPT_03\nVer Historicos" as UC03
     usecase "Seleccionar\nRango" as RANGO
     usecase "Seleccionar\nAgregacion" as AGG
     usecase "Comparar\nPeriodos" as COMP
     usecase "Ver\nGraficos" as GRAF
   }

   USER --> UC03
   UC03 --> RANGO : include
   UC03 --> AGG : include
   UC03 --> COMP : extend
   UC03 --> GRAF : extend
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
     - El usuario tiene sesion activa con funcion RPT-003
   * - PRE-02
     - Existen datos historicos en el rango solicitado
   * - PRE-03
     - El rango solicitado no excede 2 anios

4.2 Trigger
^^^^^^^^^^^

El usuario accede a reportes historicos desde el menu.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestran datos historicos del periodo seleccionado
   * - POST-02
     - Los datos estan filtrados por segmento del usuario

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
     - Accede a reportes historicos
   * - 2
     - Sistema
     - Valida funcion RPT-003
   * - 3
     - Sistema
     - Muestra formulario con ultimo mes por defecto
   * - 4
     - Usuario
     - Selecciona fecha inicio y fecha fin
   * - 5
     - Sistema
     - Valida rango no excede 2 anios (CNST-006)
   * - 6
     - Usuario
     - Selecciona tipo de agregacion (dia/semana/mes)
   * - 7
     - Sistema
     - Consulta datos con filtro de segmento
   * - 8
     - Sistema
     - Calcula agregaciones segun periodo
   * - 9
     - Sistema
     - Renderiza tabla y graficos
   * - 10
     - Usuario
     - Visualiza reporte historico

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_03

   @startuml
   actor "AGR-002 Usuario" as U
   participant "Frontend" as FE
   participant "ReportController" as RC
   participant "HistoricalService" as HS
   database "Analytics" as DB

   U -> FE: Accede a Historicos
   FE -> RC: GET /api/reports/historical/form
   RC -> RC: verify_function(RPT-003)
   RC --> FE: form_config
   FE --> U: Formulario de filtros

   U -> FE: fecha_inicio, fecha_fin, agregacion
   FE -> RC: GET /api/reports/historical?start=X&end=Y&agg=Z

   RC -> RC: validate_date_range(start, end)
   note right: CNST-006 max 2 anios

   alt rango > 2 anios
     RC --> FE: 400 Bad Request
     FE --> U: Error: Rango maximo 2 anios
   end

   RC -> HS: get_historical_data(params, segmento)

   HS -> DB: SELECT\n  DATE_TRUNC(agregacion, fecha) as periodo,\n  SUM(llamadas) as total,\n  AVG(tmo) as tmo_prom\nFROM metricas_diarias\nWHERE segmento_id = ?\nAND fecha BETWEEN ? AND ?\nGROUP BY periodo\nORDER BY periodo
   note right of DB: CNST-003 Analytics
   DB --> HS: historical_data

   HS -> HS: calculate_trends()
   HS -> HS: calculate_variations()

   HS --> RC: report_data
   RC --> FE: 200 OK
   FE --> U: Reporte con tabla y graficos
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Comparar Periodos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Usuario
     - Activa opcion Comparar Periodos
   * - 6b
     - Usuario
     - Selecciona segundo periodo a comparar
   * - 9a
     - Sistema
     - Muestra ambos periodos lado a lado
   * - 9b
     - Sistema
     - Calcula y muestra variaciones porcentuales

7.2 FA-02: Cambiar Agregacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 10a
     - Usuario
     - Cambia tipo de agregacion
   * - 10b
     - Sistema
     - Recalcula datos con nueva agregacion
   * - 10c
     - Sistema
     - Actualiza tabla y graficos

8. Excepciones
--------------

8.1 EX-01: Rango Excede 2 Anios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 5
   * - **Condicion**
     - Diferencia entre fechas mayor a 730 dias
   * - **Accion Sistema**
     - Rechaza consulta
   * - **Mensaje Usuario**
     - Rango maximo permitido es 2 anios. Ajuste las fechas.
   * - **Codigo Error**
     - RPT-020

8.2 EX-02: Sin Datos en Rango
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 7
   * - **Condicion**
     - No existen datos para el rango y segmento
   * - **Accion Sistema**
     - Muestra reporte vacio
   * - **Mensaje Usuario**
     - No hay datos disponibles para el periodo seleccionado
   * - **Codigo Error**
     - RPT-021

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_03

   @startuml
   start
   :Usuario accede a Historicos;

   if (Tiene RPT-003?) then (no)
     :Error permisos;
     stop
   else (si)
   endif

   :Mostrar formulario;
   :Seleccionar rango de fechas;

   if (Rango > 2 anios?) then (si)
     :Error rango excedido;
     note right: CNST-006
     stop
   else (no)
   endif

   :Seleccionar agregacion;

   if (Comparar periodos?) then (si)
     :Seleccionar segundo periodo;
   endif

   :Consultar datos historicos;
   note right: Filtro segmento CNST-004

   :Calcular agregaciones;
   :Calcular tendencias;

   if (Hay datos?) then (no)
     :Mostrar reporte vacio;
   else (si)
     :Renderizar tabla;
     :Renderizar graficos;
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
   * - BR-RPT-20
     - Rango Maximo
     - Solo se pueden consultar datos de los ultimos 2 anios (CNST-006)
   * - BR-RPT-21
     - Agregaciones
     - Disponibles: diaria, semanal, mensual
   * - BR-RPT-22
     - Segmento
     - Datos siempre filtrados por segmento del usuario
   * - BR-RPT-23
     - Comparacion
     - Permite comparar dos periodos de igual duracion

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
     - Datos historicos de BD Analytics exclusivamente
   * - CNST-004
     - Segmentos
     - Filtro automatico por segmento
   * - CNST-006
     - Retencion
     - Maximo 2 anios de datos historicos consultables

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-020
     - El sistema debe permitir seleccionar rango de fechas
     - Selector de fechas funcional
   * - FR-RPT-021
     - El sistema debe validar rango maximo 2 anios
     - Rechazo si excede limite
   * - FR-RPT-022
     - El sistema debe permitir comparar periodos
     - Vista lado a lado con variaciones
   * - FR-RPT-023
     - El sistema debe mostrar graficos de tendencia
     - Graficos de linea renderizados

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-003: Reportes historicos
   * - **Reglas de Negocio**
     - BR-RPT-20 a BR-RPT-23
   * - **Restricciones**
     - CNST-003, CNST-004, CNST-006
   * - **UC Relacionados**
     - UC_RPT_01, UC_RPT_04 (Exportar)
   * - **Actor Principal**
     - AGR-002: agr_operador_reportes
   * - **Funcion RBAC**
     - RPT-003: ve_historicos

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
     - Version inicial v4.0

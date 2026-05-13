.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_02
   :normativa: CNST-003, CNST-004

===================================
UC_RPT_02: Ver Metricas Tiempo Real
===================================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_02
   * - **Nombre**
     - Ver Metricas Tiempo Real
   * - **Actor Principal**
     - AGR-001: agr_operador_basico
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-002: ve_dashboard
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-RPT-002

2. Descripcion
--------------

Este caso de uso permite visualizar metricas operativas en tiempo real
con actualizacion frecuente. Muestra estado actual de colas, agentes
y llamadas en curso filtrados por segmento (CNST-004).

**Caracteristicas principales:**

- Metricas en tiempo real (refresh cada 10 segundos)
- Estado de colas de llamadas
- Estado de agentes (disponible, en llamada, pausa)
- Llamadas en espera y en curso
- Alertas visuales por umbrales
- Datos de BD Analytics (CNST-003)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_02

   @startuml
   left to right direction
   actor "AGR-001\nagr_operador_basico" as USER
   actor "Sistema" as SYS

   rectangle "MOD_Reports" {
     usecase "UC_RPT_02\nVer Metricas RT" as UC02
     usecase "Ver Estado\nColas" as COLAS
     usecase "Ver Estado\nAgentes" as AGENTES
     usecase "Evaluar\nUmbrales" as UMB
     usecase "Mostrar\nAlertas" as ALERTAS
   }

   USER --> UC02
   UC02 --> COLAS : include
   UC02 --> AGENTES : include
   UC02 --> UMB : include
   UMB --> ALERTAS : extend
   SYS --> UMB
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
     - El usuario tiene sesion activa con funcion RPT-002
   * - PRE-02
     - El usuario tiene un segmento asignado
   * - PRE-03
     - Existen vistas materializadas de tiempo real en Analytics

4.2 Trigger
^^^^^^^^^^^

El usuario accede a la vista de metricas en tiempo real.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestran metricas RT del segmento del usuario
   * - POST-02
     - Las metricas se actualizan cada 10 segundos

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
     - Accede a metricas tiempo real
   * - 2
     - Sistema
     - Valida funcion RPT-002
   * - 3
     - Sistema
     - Obtiene segmento del usuario
   * - 4
     - Sistema
     - Consulta estado actual de colas
   * - 5
     - Sistema
     - Consulta estado de agentes
   * - 6
     - Sistema
     - Consulta llamadas en curso
   * - 7
     - Sistema
     - Evalua umbrales configurados
   * - 8
     - Sistema
     - Renderiza panel con indicadores
   * - 9
     - Sistema
     - Inicia auto-refresh cada 10 segundos

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_02

   @startuml
   actor "AGR-001 Usuario" as U
   participant "Frontend" as FE
   participant "ReportController" as RC
   participant "RealTimeService" as RTS
   participant "ThresholdService" as TS
   database "Analytics" as DB

   U -> FE: Accede a Metricas RT
   FE -> RC: GET /api/reports/realtime
   RC -> RC: verify_function(RPT-002)
   RC -> RC: get_user_segment()

   RC -> RTS: get_realtime_metrics(segmento)

   RTS -> DB: SELECT * FROM vista_colas_rt\nWHERE segmento_id = ?
   note right of DB: CNST-003 Analytics
   DB --> RTS: colas_data

   RTS -> DB: SELECT * FROM vista_agentes_rt\nWHERE segmento_id = ?
   DB --> RTS: agentes_data

   RTS -> DB: SELECT * FROM vista_llamadas_rt\nWHERE segmento_id = ?
   DB --> RTS: llamadas_data

   RC -> TS: evaluate_thresholds(metrics, segmento)
   TS -> DB: SELECT * FROM alert_thresholds\nWHERE segmento_id = ?
   DB --> TS: thresholds
   TS -> TS: compare(metrics, thresholds)
   TS --> RC: alerts[]

   RC --> FE: 200 OK + metrics + alerts
   FE --> U: Panel tiempo real

   loop cada 10 segundos
     FE -> RC: GET /api/reports/realtime
     RC --> FE: updated_data
     FE --> U: Panel actualizado
   end
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Umbral Superado
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 7a
     - Sistema
     - Detecta metrica sobre umbral de advertencia
   * - 7b
     - Sistema
     - Marca indicador en amarillo
   * - 7c
     - Sistema
     - Continua con paso 8

7.2 FA-02: Umbral Critico Superado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 7a
     - Sistema
     - Detecta metrica sobre umbral critico
   * - 7b
     - Sistema
     - Marca indicador en rojo
   * - 7c
     - Sistema
     - Genera alerta visual prominente
   * - 7d
     - Sistema
     - Continua con paso 8

8. Excepciones
--------------

8.1 EX-01: Sin Permiso RPT-002
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Usuario no tiene funcion RPT-002
   * - **Accion Sistema**
     - Rechaza acceso
   * - **Mensaje Usuario**
     - No tiene permisos para ver metricas en tiempo real
   * - **Codigo Error**
     - RPT-010

8.2 EX-02: Vistas RT No Disponibles
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 4
   * - **Condicion**
     - Vistas materializadas no responden
   * - **Accion Sistema**
     - Muestra ultimo estado conocido
   * - **Mensaje Usuario**
     - Datos pueden estar desactualizados
   * - **Codigo Error**
     - RPT-011

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_02

   @startuml
   start
   :Usuario accede a Metricas RT;

   if (Tiene RPT-002?) then (no)
     :Error permisos;
     stop
   else (si)
   endif

   :Obtener segmento;
   note right: CNST-004

   fork
     :Consultar estado colas;
   fork again
     :Consultar estado agentes;
   fork again
     :Consultar llamadas en curso;
   end fork

   :Evaluar umbrales;

   switch (Estado metricas?)
   case (Normal)
     :Indicadores verdes;
   case (Advertencia)
     :Indicadores amarillos;
   case (Critico)
     :Indicadores rojos;
     :Generar alerta visual;
   endswitch

   :Renderizar panel;
   :Auto-refresh 10s;

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
   * - BR-RPT-10
     - Refresh 10s
     - Las metricas RT se actualizan cada 10 segundos
   * - BR-RPT-11
     - Umbrales por Segmento
     - Cada segmento puede tener umbrales diferentes
   * - BR-RPT-12
     - Indicadores Visuales
     - Verde (normal), Amarillo (advertencia), Rojo (critico)
   * - BR-RPT-13
     - Solo Segmento
     - Usuario solo ve datos de su segmento

**Metricas en Tiempo Real:**

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Metrica
     - Descripcion
   * - Llamadas en Cola
     - Numero de llamadas esperando ser atendidas
   * - Tiempo Espera Actual
     - Tiempo de la llamada mas antigua en cola
   * - Agentes Disponibles
     - Agentes listos para recibir llamadas
   * - Agentes en Llamada
     - Agentes actualmente atendiendo
   * - Agentes en Pausa
     - Agentes en break o pausa
   * - Llamadas Activas
     - Total de llamadas en curso

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
     - Datos de vistas materializadas en BD Analytics que se refrescan frecuentemente desde IVR
   * - CNST-004
     - Segmentos
     - Filtro automatico por segmento del usuario

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-010
     - El sistema debe mostrar estado de colas
     - Llamadas en espera, tiempo espera visible
   * - FR-RPT-011
     - El sistema debe mostrar estado de agentes
     - Disponibles, en llamada, en pausa visible
   * - FR-RPT-012
     - El sistema debe alertar por umbrales
     - Indicador visual cuando se supera umbral
   * - FR-RPT-013
     - El sistema debe refrescar cada 10s
     - Datos actualizados automaticamente

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-002: Metricas en tiempo real
   * - **Reglas de Negocio**
     - BR-RPT-10 a BR-RPT-13
   * - **Restricciones**
     - CNST-003, CNST-004
   * - **UC Relacionados**
     - UC_RPT_01 (Dashboard), UC_ALR_01 (Umbrales), UC_ALR_02 (Alertas)
   * - **Actor Principal**
     - AGR-001: agr_operador_basico
   * - **Funcion RBAC**
     - RPT-002: ve_dashboard

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
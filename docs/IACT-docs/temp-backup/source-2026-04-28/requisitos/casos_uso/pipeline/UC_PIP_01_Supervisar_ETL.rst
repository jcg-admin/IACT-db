.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Pipeline
   :uc_id: UC_PIP_01
   :normativa: CNST-003, CNST-009

=========================
UC_PIP_01: Supervisar ETL
=========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_PIP_01
   * - **Nombre**
     - Supervisar ETL
   * - **Actor Principal**
     - AGR-009: agr_admin_pipeline
   * - **Actor Secundario**
     - Sistema (monitoreo automatico)
   * - **Modulo**
     - MOD_Pipeline
   * - **Funcion RBAC**
     - PIP-001: ve_estado_etl
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-PIP-001

2. Descripcion
--------------

Este caso de uso permite al administrador del pipeline (AGR-009) supervisar
el estado del proceso ETL que sincroniza datos desde la base IVR hacia la
base Analytics. Muestra metricas de ejecucion, estado actual y alertas.

**Caracteristicas principales:**

- Ver estado actual del pipeline (corriendo, pausado, error)
- Ver ultima ejecucion exitosa y su timestamp
- Ver metricas: registros procesados, tiempo de ejecucion
- Ver proxima ejecucion programada
- Detectar retrasos o fallos
- Solo lectura desde BD IVR (CNST-003)

**Arquitectura de Datos (CNST-003):**

.. note::
   El ETL lee desde BD IVR (solo lectura) y escribe en BD Analytics.
   Este UC solo muestra informacion, no modifica el pipeline.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_PIP_01

   @startuml
   left to right direction
   actor "AGR-009\nagr_admin_pipeline" as ADMIN
   actor "Sistema" as SYS

   rectangle "MOD_Pipeline" {
     usecase "UC_PIP_01\nSupervisar ETL" as UC01
     usecase "Ver Estado\nActual" as STATE
     usecase "Ver Metricas\nEjecucion" as METRICS
     usecase "Ver Proxima\nEjecucion" as NEXT
   }

   ADMIN --> UC01
   UC01 --> STATE : include
   UC01 --> METRICS : include
   UC01 --> NEXT : include
   SYS --> STATE
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
     - El administrador tiene sesion activa con funcion PIP-001
   * - PRE-02
     - El servicio de monitoreo de ETL esta operativo

4.2 Trigger
^^^^^^^^^^^

El administrador accede al dashboard de supervision del pipeline.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra el estado actual del pipeline
   * - POST-02
     - La consulta no modifica ningun dato

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Admin
     - Accede al dashboard de pipeline
   * - 2
     - Sistema
     - Valida funcion PIP-001
   * - 3
     - Sistema
     - Consulta estado actual del ETL
   * - 4
     - Sistema
     - Consulta ultima ejecucion exitosa
   * - 5
     - Sistema
     - Consulta metricas de ejecucion
   * - 6
     - Sistema
     - Calcula proxima ejecucion programada
   * - 7
     - Sistema
     - Presenta dashboard con toda la informacion
   * - 8
     - Sistema
     - Actualiza automaticamente cada 60 segundos

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_PIP_01

   @startuml
   actor "AGR-009 Admin" as A
   participant "Frontend" as FE
   participant "PipelineController" as PC
   participant "ETLMonitorService" as EMS
   database "Analytics" as ADB
   database "IVR\n(readonly)" as IVR

   A -> FE: Accede a Dashboard Pipeline
   FE -> PC: GET /api/pipeline/status
   PC -> PC: verify_function(PIP-001)

   PC -> EMS: get_pipeline_status()

   EMS -> ADB: SELECT * FROM etl_executions\nORDER BY started_at DESC LIMIT 1
   ADB --> EMS: last_execution

   EMS -> ADB: SELECT * FROM etl_executions\nWHERE status = 'SUCCESS'\nORDER BY completed_at DESC LIMIT 1
   ADB --> EMS: last_success

   EMS -> ADB: SELECT COUNT(*), SUM(records_processed)\nFROM etl_executions\nWHERE DATE(started_at) = CURRENT_DATE
   ADB --> EMS: today_metrics

   note right of IVR
     CNST-003: Solo lectura
     No se consulta IVR
     directamente desde UI
   end note

   EMS -> EMS: calculate_next_run()

   EMS --> PC: pipeline_status
   PC --> FE: 200 OK + status
   FE --> A: Dashboard con metricas

   loop cada 60 segundos
     FE -> PC: GET /api/pipeline/status
     PC --> FE: updated_status
     FE --> A: Actualiza dashboard
   end
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Pipeline en Error
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 7a
     - Sistema
     - Detecta estado ERROR en ultima ejecucion
   * - 7b
     - Sistema
     - Muestra alerta visual prominente
   * - 7c
     - Sistema
     - Ofrece enlace a UC_PIP_02 (ver errores)

7.2 FA-02: Pipeline Pausado
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 7a
     - Sistema
     - Detecta estado PAUSED
   * - 7b
     - Sistema
     - Muestra indicador amarillo
   * - 7c
     - Sistema
     - Muestra razon de pausa si existe

8. Excepciones
--------------

8.1 EX-01: Sin Permiso PIP-001
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Usuario no tiene funcion PIP-001
   * - **Accion Sistema**
     - Rechaza acceso
   * - **Mensaje Usuario**
     - No tiene permisos para supervisar el pipeline
   * - **Codigo Error**
     - PIP-001

8.2 EX-02: Servicio No Disponible
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 3
   * - **Condicion**
     - Servicio de monitoreo no responde
   * - **Accion Sistema**
     - Muestra ultimo estado conocido
   * - **Mensaje Usuario**
     - Informacion puede estar desactualizada
   * - **Codigo Error**
     - PIP-002

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_PIP_01

   @startuml
   start
   :Admin accede a Dashboard Pipeline;
   if (Tiene PIP-001?) then (no)
     :Error permisos;
     stop
   else (si)
   endif

   fork
     :Consultar estado actual;
   fork again
     :Consultar ultima ejecucion;
   fork again
     :Consultar metricas;
   fork again
     :Calcular proxima ejecucion;
   end fork

   :Renderizar dashboard;

   switch (Estado?)
   case (RUNNING)
     :Indicador verde animado;
   case (SUCCESS)
     :Indicador verde;
   case (ERROR)
     :Indicador rojo + alerta;
   case (PAUSED)
     :Indicador amarillo;
   endswitch

   :Auto-refresh cada 60s;

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
   * - BR-PIP-01
     - Solo Lectura
     - Este UC es solo de visualizacion, no permite modificar el pipeline
   * - BR-PIP-02
     - Auto Refresh
     - El dashboard se actualiza automaticamente cada 60 segundos
   * - BR-PIP-03
     - Alertas Visuales
     - Estados ERROR y PAUSED generan alertas visuales prominentes

**Estados del Pipeline:**

.. list-table::
   :widths: 20 20 60
   :header-rows: 1

   * - Estado
     - Indicador
     - Descripcion
   * - RUNNING
     - Verde animado
     - ETL en ejecucion actualmente
   * - SUCCESS
     - Verde
     - Ultima ejecucion exitosa
   * - ERROR
     - Rojo
     - Ultima ejecucion fallo
   * - PAUSED
     - Amarillo
     - Pipeline pausado manualmente
   * - PENDING
     - Gris
     - Esperando proxima ejecucion

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
     - Las metricas se leen de BD Analytics (etl_executions). No se accede directamente a BD IVR desde este UC.
   * - CNST-009
     - Auditoria Inmutable
     - El acceso al dashboard no se audita individualmente para evitar sobrecarga.

**Metricas Mostradas:**

.. code-block:: python

   {
       "current_state": "SUCCESS",
       "last_execution": {
           "id": 12345,
           "started_at": "2026-01-06T10:00:00Z",
           "completed_at": "2026-01-06T10:05:23Z",
           "status": "SUCCESS",
           "records_processed": 45678,
           "duration_seconds": 323
       },
       "today_metrics": {
           "executions": 24,
           "total_records": 1234567,
           "success_rate": 100.0,
           "avg_duration_seconds": 312
       },
       "next_scheduled": "2026-01-06T11:00:00Z"
   }

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-PIP-001
     - El sistema debe mostrar estado actual del ETL
     - Indicador visual segun estado
   * - FR-PIP-002
     - El sistema debe mostrar metricas de ejecucion
     - Registros procesados, duracion, tasa de exito
   * - FR-PIP-003
     - El sistema debe auto-refrescar cada 60s
     - Dashboard actualizado sin recargar pagina

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-PIP-001: Permitir supervision del pipeline ETL
   * - **Reglas de Negocio**
     - BR-PIP-01 a BR-PIP-03
   * - **Restricciones**
     - CNST-003 (BD Dual), CNST-009
   * - **UC Relacionados**
     - UC_PIP_02, UC_PIP_03, UC_PIP_04
   * - **Actor Principal**
     - AGR-009: agr_admin_pipeline
   * - **Funcion RBAC**
     - PIP-001: ve_estado_etl

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

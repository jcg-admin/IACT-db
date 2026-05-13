.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Logs
   :uc_id: UC_LOG_02
   :normativa: CNST-003, CNST-008

=============================
UC_LOG_02: Consultar Logs ETL
=============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_LOG_02
   * - **Nombre**
     - Consultar Logs ETL
   * - **Actor Principal**
     - AGR-007: agr_operador_logs
   * - **Modulo**
     - MOD_Logs
   * - **Funcion RBAC**
     - LOG-002: consulta_logs_etl
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-LOG-002

2. Descripcion
--------------

Este caso de uso permite consultar los logs especificos del proceso
ETL que sincroniza datos desde BD IVR hacia BD Analytics (CNST-003).
Fundamental para diagnosticar problemas de carga de datos.

**Caracteristicas principales:**

- Logs especificos del proceso ETL
- Monitoreo de sincronizacion IVR -> Analytics
- Estado de cada ejecucion (exito, error, parcial)
- Metricas de registros procesados
- Formato JSON estructurado (CNST-008)

**Restriccion CNST-003:**

.. note::
   El ETL es el UNICO mecanismo de transferencia de datos desde
   BD IVR hacia BD Analytics. Estos logs documentan ese proceso.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_LOG_02

   @startuml
   left to right direction
   actor "AGR-007\nagr_operador_logs" as USER

   rectangle "MOD_Logs" {
     usecase "UC_LOG_02\nConsultar Logs ETL" as UC02
     usecase "Ver Estado\nEjecuciones" as EST
     usecase "Ver Metricas\nCarga" as MET
     usecase "Diagnosticar\nErrores" as DIAG
   }

   USER --> UC02
   UC02 --> EST : include
   UC02 --> MET : extend
   UC02 --> DIAG : extend
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
     - El usuario tiene sesion activa con funcion LOG-002
   * - PRE-02
     - El proceso ETL ha ejecutado al menos una vez

4.2 Trigger
^^^^^^^^^^^

El operador accede al visor de logs ETL.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestran logs de ejecuciones ETL
   * - POST-02
     - La consulta es de solo lectura

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Operador
     - Accede a logs ETL
   * - 2
     - Sistema
     - Valida funcion LOG-002
   * - 3
     - Sistema
     - Muestra ultimas 24 horas de ejecuciones
   * - 4
     - Sistema
     - Presenta lista de ejecuciones con estado
   * - 5
     - Operador
     - Selecciona ejecucion para ver detalle
   * - 6
     - Sistema
     - Muestra logs detallados de la ejecucion
   * - 7
     - Sistema
     - Muestra metricas: registros leidos, insertados, errores

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_LOG_02

   @startuml
   actor "AGR-007 Operador" as O
   participant "Frontend" as FE
   participant "LogController" as LC
   participant "ETLLogService" as ELS
   database "LogStore" as DB

   O -> FE: Accede a Logs ETL
   FE -> LC: GET /api/logs/etl/executions
   LC -> LC: verify_function(LOG-002)

   LC -> ELS: get_etl_executions(last_24h)
   ELS -> DB: SELECT * FROM etl_executions\nWHERE started_at >= NOW() - INTERVAL '24h'\nORDER BY started_at DESC
   DB --> ELS: executions
   ELS --> LC: executions
   LC --> FE: 200 OK
   FE --> O: Lista de ejecuciones

   note right of FE
     Estado por ejecucion:
     - SUCCESS (verde)
     - PARTIAL (amarillo)
     - FAILED (rojo)
     - RUNNING (azul)
   end note

   O -> FE: Click en ejecucion
   FE -> LC: GET /api/logs/etl/executions/{id}
   LC -> ELS: get_execution_detail(id)
   ELS -> DB: SELECT logs, metrics\nFROM etl_logs\nWHERE execution_id = ?
   DB --> ELS: detail
   ELS --> LC: detail
   LC --> FE: 200 OK
   FE --> O: Detalle con logs y metricas

   note right of FE
     CNST-003: IVR -> Analytics
     CNST-008: Formato JSON

     Metricas mostradas:
     - registros_leidos
     - registros_insertados
     - registros_actualizados
     - registros_error
     - duracion_segundos
   end note
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Ver Ejecucion con Errores
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Operador
     - Selecciona ejecucion con estado FAILED o PARTIAL
   * - 6a
     - Sistema
     - Resalta logs de nivel ERROR
   * - 6b
     - Sistema
     - Muestra detalle de registros fallidos

7.2 FA-02: Filtrar por Estado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 3a
     - Operador
     - Filtra por estado (SUCCESS, FAILED, etc.)
   * - 4a
     - Sistema
     - Muestra solo ejecuciones del estado seleccionado

7.3 FA-03: Ver Tendencia de Ejecuciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Operador
     - Hace clic en Ver Tendencia
   * - 4b
     - Sistema
     - Muestra grafico de exitos/fallos por dia

8. Excepciones
--------------

8.1 EX-01: Sin Ejecuciones
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 3
   * - **Condicion**
     - No hay ejecuciones en el periodo
   * - **Accion Sistema**
     - Muestra mensaje informativo
   * - **Mensaje Usuario**
     - No hay ejecuciones ETL en las ultimas 24 horas

8.2 EX-02: Ejecucion No Encontrada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 6
   * - **Condicion**
     - ID de ejecucion no existe
   * - **Accion Sistema**
     - Muestra error
   * - **Mensaje Usuario**
     - Ejecucion no encontrada
   * - **Codigo Error**
     - LOG-010

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_LOG_02

   @startuml
   start
   :Operador accede a Logs ETL;

   if (Tiene LOG-002?) then (no)
     :Error permisos;
     stop
   else (si)
   endif

   :Consultar ejecuciones ultimas 24h;

   if (Hay ejecuciones?) then (no)
     :Mostrar Sin ejecuciones;
     stop
   else (si)
   endif

   :Mostrar lista con estados;

   if (Ver detalle?) then (si)
     :Obtener logs de ejecucion;
     :Mostrar logs JSON;
     note right: CNST-008
     :Mostrar metricas de carga;
     note right: CNST-003

     if (Tiene errores?) then (si)
       :Resaltar errores;
       :Mostrar registros fallidos;
     endif
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
   * - BR-LOG-10
     - Flujo ETL
     - ETL transfiere datos IVR -> Analytics (CNST-003)
   * - BR-LOG-11
     - Estados
     - SUCCESS, PARTIAL, FAILED, RUNNING
   * - BR-LOG-12
     - Metricas
     - Cada ejecucion registra metricas de procesamiento
   * - BR-LOG-13
     - Formato
     - Logs en formato JSON (CNST-008)

**Estructura de Log ETL (CNST-008):**

.. code-block:: json

   {
     "execution_id": "etl-2026-01-06-001",
     "timestamp": "2026-01-06T02:00:00Z",
     "level": "INFO",
     "component": "ETLService",
     "phase": "EXTRACT",
     "message": "Extrayendo datos de IVR",
     "context": {
       "source": "BD_IVR",
       "target": "BD_Analytics",
       "table": "llamadas",
       "records_read": 15000
     }
   }

**Metricas por Ejecucion:**

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Metrica
     - Descripcion
   * - registros_leidos
     - Total leidos de BD IVR
   * - registros_insertados
     - Nuevos registros en Analytics
   * - registros_actualizados
     - Registros existentes actualizados
   * - registros_error
     - Registros que fallaron
   * - duracion_segundos
     - Tiempo total de ejecucion

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
     - ETL es el unico mecanismo IVR -> Analytics
   * - CNST-008
     - Logs JSON
     - Formato JSON estructurado

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-LOG-010
     - Listar ejecuciones ETL
     - Lista con estado visible
   * - FR-LOG-011
     - Ver detalle de ejecucion
     - Logs y metricas completas
   * - FR-LOG-012
     - Diagnosticar errores
     - Detalle de registros fallidos

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-LOG-002
   * - **Restricciones**
     - CNST-003, CNST-008
   * - **UC Relacionados**
     - UC_LOG_01, UC_PIP_01 (Monitorear ETL)
   * - **Funcion RBAC**
     - LOG-002: consulta_logs_etl

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
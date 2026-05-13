.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Logs
   :uc_id: UC_LOG_01
   :normativa: CNST-008

=================================
UC_LOG_01: Consultar Logs Sistema
=================================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_LOG_01
   * - **Nombre**
     - Consultar Logs Sistema
   * - **Actor Principal**
     - AGR-007: agr_operador_logs
   * - **Modulo**
     - MOD_Logs
   * - **Funcion RBAC**
     - LOG-001: consulta_logs_sistema
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-LOG-001

2. Descripcion
--------------

Este caso de uso permite consultar los logs de aplicacion del sistema
IACT. Los logs siguen formato JSON estructurado (CNST-008) para
facilitar su procesamiento y analisis.

**Caracteristicas principales:**

- Consultar logs de aplicacion en tiempo real
- Filtrar por nivel (DEBUG, INFO, WARNING, ERROR, CRITICAL)
- Filtrar por componente/modulo
- Formato JSON estructurado (CNST-008)
- Visualizacion con resaltado de sintaxis

**Restriccion CNST-008:**

.. note::
   Todos los logs del sistema utilizan formato JSON estructurado
   con campos estandar: timestamp, level, component, message, context.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_LOG_01

   @startuml
   left to right direction
   actor "AGR-007\nagr_operador_logs" as USER

   rectangle "MOD_Logs" {
     usecase "UC_LOG_01\nConsultar Logs\nSistema" as UC01
     usecase "Filtrar por\nNivel" as NIV
     usecase "Filtrar por\nComponente" as COMP
     usecase "Ver en\nTiempo Real" as RT
   }

   USER --> UC01
   UC01 --> NIV : include
   UC01 --> COMP : extend
   UC01 --> RT : extend
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
     - El usuario tiene sesion activa con funcion LOG-001
   * - PRE-02
     - El sistema de logging esta operativo
   * - PRE-03
     - Existen logs en el periodo consultado

4.2 Trigger
^^^^^^^^^^^

El operador accede al visor de logs del sistema.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestran logs filtrados segun criterios
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
     - Accede al visor de logs del sistema
   * - 2
     - Sistema
     - Valida funcion LOG-001
   * - 3
     - Sistema
     - Muestra logs de ultima hora por defecto
   * - 4
     - Operador
     - Opcionalmente aplica filtros (nivel, componente)
   * - 5
     - Sistema
     - Ejecuta consulta con filtros
   * - 6
     - Sistema
     - Presenta logs en formato JSON resaltado
   * - 7
     - Operador
     - Navega por los logs o activa modo tiempo real

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_LOG_01

   @startuml
   actor "AGR-007 Operador" as O
   participant "Frontend" as FE
   participant "LogController" as LC
   participant "LogService" as LS
   database "LogStore" as DB

   O -> FE: Accede a Logs Sistema
   FE -> LC: GET /api/logs/system
   LC -> LC: verify_function(LOG-001)

   LC -> LS: get_system_logs(filters)
   LS -> DB: SELECT * FROM system_logs\nWHERE timestamp >= NOW() - INTERVAL '1h'\nORDER BY timestamp DESC\nLIMIT 1000
   DB --> LS: logs
   LS --> LC: logs
   LC --> FE: 200 OK
   FE --> O: Logs en formato JSON

   note right of FE
     CNST-008: JSON estructurado
     {
       "timestamp": "2026-01-06T10:30:00Z",
       "level": "ERROR",
       "component": "AuthService",
       "message": "Login failed",
       "context": {...}
     }
   end note

   O -> FE: Aplica filtro nivel=ERROR
   FE -> LC: GET /api/logs/system?level=ERROR
   LC -> LS: get_system_logs(level='ERROR')
   LS -> DB: SELECT con filtro level
   DB --> LS: filtered_logs
   LS --> LC: logs
   LC --> FE: 200 OK
   FE --> O: Logs filtrados

   == Modo Tiempo Real ==

   O -> FE: Activa tiempo real
   FE -> LC: WebSocket /ws/logs/system
   loop cada nuevo log
     DB -> LS: new_log_event
     LS -> LC: push(log)
     LC -> FE: WebSocket message
     FE -> O: Log en pantalla
   end
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Filtrar por Nivel
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Operador
     - Selecciona nivel (ERROR, WARNING, etc.)
   * - 5a
     - Sistema
     - Filtra logs por nivel seleccionado

7.2 FA-02: Filtrar por Componente
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Operador
     - Selecciona componente (AuthService, ReportService, etc.)
   * - 5a
     - Sistema
     - Filtra logs por componente

7.3 FA-03: Modo Tiempo Real
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 7a
     - Operador
     - Activa modo tiempo real
   * - 7b
     - Sistema
     - Establece conexion WebSocket
   * - 7c
     - Sistema
     - Muestra nuevos logs conforme llegan

8. Excepciones
--------------

8.1 EX-01: Sin Permiso LOG-001
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Usuario no tiene funcion LOG-001
   * - **Accion Sistema**
     - Rechaza acceso
   * - **Mensaje Usuario**
     - No tiene permisos para consultar logs del sistema
   * - **Codigo Error**
     - LOG-001

8.2 EX-02: Servicio de Logs No Disponible
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 5
   * - **Condicion**
     - El sistema de logs no responde
   * - **Accion Sistema**
     - Muestra error de disponibilidad
   * - **Mensaje Usuario**
     - Servicio de logs temporalmente no disponible
   * - **Codigo Error**
     - LOG-002

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_LOG_01

   @startuml
   start
   :Operador accede a Logs Sistema;

   if (Tiene LOG-001?) then (no)
     :Error permisos;
     stop
   else (si)
   endif

   :Mostrar logs ultima hora;

   if (Aplica filtros?) then (si)
     :Aplicar filtro nivel;
     :Aplicar filtro componente;
   endif

   :Ejecutar consulta;
   :Formatear JSON con resaltado;
   note right: CNST-008

   :Mostrar resultados;

   if (Modo tiempo real?) then (si)
     :Establecer WebSocket;
     :Mostrar logs en streaming;
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
   * - BR-LOG-01
     - Formato JSON
     - Todos los logs usan formato JSON estructurado (CNST-008)
   * - BR-LOG-02
     - Niveles Estandar
     - DEBUG, INFO, WARNING, ERROR, CRITICAL
   * - BR-LOG-03
     - Retencion
     - Logs disponibles por 30 dias por defecto
   * - BR-LOG-04
     - Limite Consulta
     - Maximo 10,000 logs por consulta

**Estructura JSON de Log (CNST-008):**

.. code-block:: json

   {
     "timestamp": "2026-01-06T10:30:00.123Z",
     "level": "ERROR",
     "component": "AuthService",
     "correlation_id": "abc-123-def",
     "message": "Login failed for user",
     "context": {
       "user": "john.doe",
       "ip": "192.168.1.100",
       "reason": "invalid_password"
     },
     "stack_trace": "..."
   }

**Componentes del Sistema:**

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Componente
     - Descripcion
   * - AuthService
     - Autenticacion y sesiones
   * - UserService
     - Gestion de usuarios
   * - ReportService
     - Generacion de reportes
   * - AlertService
     - Motor de alertas
   * - ETLService
     - Proceso de carga de datos

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-008
     - Logs JSON
     - Todos los logs del sistema utilizan formato JSON estructurado con campos estandar para facilitar parsing y analisis.

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-LOG-001
     - Consultar logs del sistema
     - Lista de logs visible con formato JSON
   * - FR-LOG-002
     - Filtrar por nivel
     - Filtro funcional por nivel de severidad
   * - FR-LOG-003
     - Filtrar por componente
     - Filtro funcional por componente
   * - FR-LOG-004
     - Modo tiempo real
     - Logs mostrados en streaming via WebSocket

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-LOG-001: Consultar logs de aplicacion
   * - **Reglas de Negocio**
     - BR-LOG-01 a BR-LOG-04
   * - **Restricciones**
     - CNST-008 (Logs JSON)
   * - **UC Relacionados**
     - UC_LOG_02 (ETL), UC_LOG_03 (Buscar), UC_LOG_04 (Exportar)
   * - **Actor Principal**
     - AGR-007: agr_operador_logs
   * - **Funcion RBAC**
     - LOG-001: consulta_logs_sistema

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
     - Version inicial v4.0 con CNST-008
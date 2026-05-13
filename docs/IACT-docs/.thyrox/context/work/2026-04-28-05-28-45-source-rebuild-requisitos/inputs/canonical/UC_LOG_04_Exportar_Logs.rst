.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Logs
   :uc_id: UC_LOG_04
   :normativa: CNST-008, CNST-009

========================
UC_LOG_04: Exportar Logs
========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_LOG_04
   * - **Nombre**
     - Exportar Logs
   * - **Actor Principal**
     - AGR-007: agr_operador_logs
   * - **Modulo**
     - MOD_Logs
   * - **Funcion RBAC**
     - LOG-004: exporta_logs
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Baja
   * - **BReq Origen**
     - BRQ-LOG-004

2. Descripcion
--------------

Este caso de uso permite exportar logs del sistema a formatos externos
para analisis offline o archivo. La exportacion se registra en
auditoria (CNST-009). Limite de 500,000 registros por exportacion.

**Caracteristicas principales:**

- Exportar a JSON, CSV o texto plano
- Exportar logs filtrados o resultados de busqueda
- Limite 500,000 registros por exportacion
- Registro de exportacion en auditoria
- Mantiene formato JSON estructurado (CNST-008)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_LOG_04

   @startuml
   left to right direction
   actor "AGR-007\nagr_operador_logs" as USER

   rectangle "MOD_Logs" {
     usecase "UC_LOG_04\nExportar Logs" as UC04
     usecase "Exportar\nJSON" as JSON
     usecase "Exportar\nCSV" as CSV
     usecase "Registrar\nAuditoria" as AUD
   }

   USER --> UC04
   UC04 --> JSON : extend
   UC04 --> CSV : extend
   UC04 --> AUD : include
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
     - El usuario tiene sesion activa con funcion LOG-004
   * - PRE-02
     - Existen logs para exportar

4.2 Trigger
^^^^^^^^^^^

El operador hace clic en Exportar desde la vista de logs.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se genera archivo con logs exportados
   * - POST-02
     - Se registra LOG_EXPORT en auditoria (CNST-009)

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
     - Aplica filtros a los logs
   * - 2
     - Operador
     - Hace clic en Exportar
   * - 3
     - Sistema
     - Valida funcion LOG-004
   * - 4
     - Sistema
     - Cuenta registros a exportar
   * - 5
     - Sistema
     - Valida limite 500,000 registros
   * - 6
     - Sistema
     - Muestra opciones de formato
   * - 7
     - Operador
     - Selecciona formato (JSON, CSV, TXT)
   * - 8
     - Sistema
     - Genera archivo con logs
   * - 9
     - Sistema
     - Registra LOG_EXPORT en auditoria
   * - 10
     - Sistema
     - Inicia descarga del archivo

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_LOG_04

   @startuml
   actor "AGR-007 Operador" as O
   participant "Frontend" as FE
   participant "LogController" as LC
   participant "ExportService" as ES
   participant "UserActionLog" as UAL
   database "LogStore" as DB

   O -> FE: Click Exportar
   FE -> LC: POST /api/logs/export
   LC -> LC: verify_function(LOG-004)

   LC -> ES: export_logs(filters, format)

   ES -> DB: SELECT COUNT(*) FROM logs\nWHERE (filters)
   DB --> ES: count

   alt count > 500000
     ES --> LC: ExportLimitExceeded
     LC --> FE: 400 Bad Request
     FE --> O: Error: Limite 500,000 excedido
   end

   ES -> DB: SELECT * FROM logs\nWHERE (filters)\nLIMIT 500000
   DB --> ES: logs

   alt formato JSON
     ES -> ES: generate_json(logs)
     note right: CNST-008 mantiene estructura
   else formato CSV
     ES -> ES: flatten_to_csv(logs)
   else formato TXT
     ES -> ES: format_as_text(logs)
   end

   ES -> UAL: record(LOG_EXPORT)
   note right of UAL
     CNST-009: Registra
     - usuario
     - filtros
     - cantidad
     - formato
   end note
   UAL -> DB: INSERT user_action_log

   ES --> LC: file
   LC --> FE: 200 OK + file
   FE --> O: Descarga archivo
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Exportar a JSON
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 7a
     - Operador
     - Selecciona formato JSON
   * - 8a
     - Sistema
     - Genera archivo JSON con estructura original

7.2 FA-02: Exportar a CSV
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 7a
     - Operador
     - Selecciona formato CSV
   * - 8a
     - Sistema
     - Aplana estructura JSON a columnas CSV

7.3 FA-03: Exportar Busqueda
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Operador
     - Realiza busqueda primero
   * - 2a
     - Operador
     - Exporta resultados de busqueda

8. Excepciones
--------------

8.1 EX-01: Limite Excedido
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 5
   * - **Condicion**
     - Mas de 500,000 registros a exportar
   * - **Accion Sistema**
     - Rechaza exportacion
   * - **Mensaje Usuario**
     - Limite de exportacion es 500,000 registros. Aplique mas filtros.
   * - **Codigo Error**
     - LOG-030

8.2 EX-02: Sin Logs
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 4
   * - **Condicion**
     - No hay logs para los filtros
   * - **Accion Sistema**
     - Informa al usuario
   * - **Mensaje Usuario**
     - No hay logs para exportar

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_LOG_04

   @startuml
   start
   :Operador aplica filtros;
   :Click en Exportar;

   if (Tiene LOG-004?) then (no)
     :Error permisos;
     stop
   else (si)
   endif

   :Contar registros;

   if (Count > 500,000?) then (si)
     :Error limite excedido;
     stop
   else (no)
   endif

   :Seleccionar formato;

   switch (Formato?)
   case (JSON)
     :Generar JSON estructurado;
     note right: CNST-008
   case (CSV)
     :Aplanar a CSV;
   case (TXT)
     :Formatear texto plano;
   endswitch

   :Registrar en auditoria;
   note right: CNST-009

   :Descargar archivo;

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
   * - BR-LOG-30
     - Limite Exportacion
     - Maximo 500,000 registros por exportacion
   * - BR-LOG-31
     - Auditoria
     - Toda exportacion se registra en auditoria (CNST-009)
   * - BR-LOG-32
     - Formatos
     - Soportados: JSON, CSV, TXT
   * - BR-LOG-33
     - Estructura JSON
     - Formato JSON mantiene estructura original (CNST-008)

**Formatos de Exportacion:**

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - Formato
     - Descripcion
   * - JSON
     - Array de objetos JSON con estructura original completa
   * - CSV
     - Columnas aplanadas: timestamp, level, component, message, context_json
   * - TXT
     - Formato legible: [timestamp] [LEVEL] component: message

**Registro de Auditoria (CNST-009):**

.. code-block:: python

   UserActionLog.record(
       user=current_user,
       action='LOG_EXPORT',
       resource='system_logs',
       result='SUCCESS',
       details={
           'filters': applied_filters,
           'record_count': count,
           'format': 'JSON' | 'CSV' | 'TXT',
           'file_size_bytes': size,
           'date_range': {
               'start': start_date,
               'end': end_date
           }
       }
   )

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion
   * - CNST-008
     - Logs JSON
     - Exportacion JSON mantiene estructura original
   * - CNST-009
     - Auditoria
     - Registro de exportacion en user_action_log

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-LOG-030
     - Exportar a multiples formatos
     - JSON, CSV, TXT funcionales
   * - FR-LOG-031
     - Validar limite 500k
     - Rechazo si excede
   * - FR-LOG-032
     - Auditar exportacion
     - Registro en user_action_log

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-LOG-004
   * - **Restricciones**
     - CNST-008, CNST-009
   * - **UC Relacionados**
     - UC_LOG_01, UC_LOG_03
   * - **Funcion RBAC**
     - LOG-004: exporta_logs

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
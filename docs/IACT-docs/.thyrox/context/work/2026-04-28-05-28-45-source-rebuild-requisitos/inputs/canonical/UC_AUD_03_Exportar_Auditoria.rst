.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Audit
   :uc_id: UC_AUD_03
   :normativa: CNST-007, CNST-009, CNST-010

=============================
UC_AUD_03: Exportar Auditoria
=============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_AUD_03
   * - **Nombre**
     - Exportar Auditoria
   * - **Actor Principal**
     - AGR-006: agr_auditor
   * - **Modulo**
     - MOD_Audit
   * - **Funcion RBAC**
     - AUD-003: exporta_auditoria
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-AUD-003

2. Descripcion
--------------

Este caso de uso permite exportar registros de auditoria a formatos
CSV o Excel para analisis externo o archivo. La exportacion esta
limitada a 100,000 registros (CNST-007) y se registra en auditoria.

**Caracteristicas principales:**

- Exportar a CSV o Excel
- Limite 100,000 registros (CNST-007)
- Exportar resultados filtrados o busquedas
- La propia exportacion se registra en auditoria
- Solo lectura de datos (CNST-009)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_AUD_03

   @startuml
   left to right direction
   actor "AGR-006\nagr_auditor" as USER

   rectangle "MOD_Audit" {
     usecase "UC_AUD_03\nExportar Auditoria" as UC03
     usecase "Exportar\nCSV" as CSV
     usecase "Exportar\nExcel" as XLS
     usecase "Registrar\nExportacion" as REG
   }

   USER --> UC03
   UC03 --> CSV : extend
   UC03 --> XLS : extend
   UC03 --> REG : include
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
     - El usuario tiene sesion activa con funcion AUD-003
   * - PRE-02
     - El usuario cumple con SoD-003
   * - PRE-03
     - Existen registros para exportar

4.2 Trigger
^^^^^^^^^^^

El auditor hace clic en Exportar desde la vista de auditoria.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se genera archivo con datos exportados
   * - POST-02
     - Se registra AUDIT_EXPORT en auditoria

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Auditor
     - Aplica filtros a registros de auditoria
   * - 2
     - Auditor
     - Hace clic en Exportar
   * - 3
     - Sistema
     - Valida funcion AUD-003
   * - 4
     - Sistema
     - Valida cumplimiento SoD-003
   * - 5
     - Sistema
     - Cuenta registros a exportar
   * - 6
     - Sistema
     - Valida limite 100,000 (CNST-007)
   * - 7
     - Sistema
     - Muestra opciones de formato
   * - 8
     - Auditor
     - Selecciona formato (CSV o Excel)
   * - 9
     - Sistema
     - Genera archivo con registros
   * - 10
     - Sistema
     - Registra AUDIT_EXPORT en auditoria
   * - 11
     - Sistema
     - Inicia descarga del archivo

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_AUD_03

   @startuml
   actor "AGR-006 Auditor" as A
   participant "Frontend" as FE
   participant "AuditController" as AC
   participant "SoDValidator" as SOD
   participant "ExportService" as ES
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   A -> FE: Click Exportar
   FE -> AC: POST /api/audit/export
   AC -> AC: verify_function(AUD-003)
   AC -> SOD: validate_sod(user, 'SoD-003')
   SOD --> AC: sod_valid

   AC -> ES: export_audit(filters, format)

   ES -> DB: SELECT COUNT(*) FROM user_action_log\nWHERE (filters)
   DB --> ES: count

   alt count > 100000
     note right of ES: CNST-007
     ES --> AC: ExportLimitExceeded
     AC --> FE: 400 Bad Request
     FE --> A: Error: Limite 100,000 excedido
   end

   ES -> DB: SELECT * FROM user_action_log\nWHERE (filters)\nLIMIT 100000
   note right of DB: CNST-009 Solo SELECT
   DB --> ES: records

   ES -> ES: generate_file(records, format)

   ES -> UAL: record(AUDIT_EXPORT)
   note right of UAL
     Registra: usuario,
     filtros, cantidad,
     formato, timestamp
   end note
   UAL -> DB: INSERT user_action_log

   ES --> AC: file
   AC --> FE: 200 OK + file
   FE --> A: Descarga archivo
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Exportar a CSV
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 8a
     - Auditor
     - Selecciona formato CSV
   * - 9a
     - Sistema
     - Genera archivo CSV con delimitador coma

7.2 FA-02: Exportar a Excel
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 8a
     - Auditor
     - Selecciona formato Excel
   * - 9a
     - Sistema
     - Genera archivo XLSX con formato

7.3 FA-03: Exportar Busqueda
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Auditor
     - Realiza busqueda avanzada primero
   * - 2a
     - Auditor
     - Exporta resultados de la busqueda

8. Excepciones
--------------

8.1 EX-01: Limite Excedido
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 6
   * - **Condicion**
     - Mas de 100,000 registros a exportar
   * - **Accion Sistema**
     - Rechaza exportacion
   * - **Mensaje Usuario**
     - Limite de exportacion es 100,000 registros. Aplique mas filtros.
   * - **Codigo Error**
     - AUD-020

8.2 EX-02: Sin Registros
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 5
   * - **Condicion**
     - No hay registros para los filtros
   * - **Accion Sistema**
     - Informa al usuario
   * - **Mensaje Usuario**
     - No hay registros para exportar
   * - **Codigo Error**
     - AUD-021

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_AUD_03

   @startuml
   start
   :Auditor aplica filtros;
   :Click en Exportar;

   if (Tiene AUD-003?) then (no)
     stop
   else (si)
   endif

   if (Cumple SoD-003?) then (no)
     :Error SoD;
     stop
   else (si)
   endif

   :Contar registros;

   if (Count > 100,000?) then (si)
     :Error limite;
     note right: CNST-007
     stop
   else (no)
   endif

   :Seleccionar formato;
   :Generar archivo;
   :Registrar exportacion en auditoria;
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
   * - BR-AUD-20
     - Limite Exportacion
     - Maximo 100,000 registros por exportacion (CNST-007)
   * - BR-AUD-21
     - Auditoria de Exportacion
     - Toda exportacion se registra en user_action_log
   * - BR-AUD-22
     - Formatos
     - Soportados: CSV y Excel (XLSX)

**Registro de Auditoria de Exportacion:**

.. code-block:: python

   UserActionLog.record(
       user=current_user,
       action='AUDIT_EXPORT',
       resource='user_action_log',
       result='SUCCESS',
       details={
           'filters': applied_filters,
           'record_count': count,
           'format': 'CSV' | 'XLSX',
           'file_size_bytes': size
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
   * - CNST-007
     - Exportaciones
     - Limite 100,000 registros
   * - CNST-009
     - Inmutable
     - Solo SELECT para obtener datos
   * - CNST-010
     - SoD
     - Validar SoD-003 antes de exportar

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-AUD-020
     - Exportar a CSV/Excel
     - Archivo descargable generado
   * - FR-AUD-021
     - Validar limite 100k
     - Rechazo si excede
   * - FR-AUD-022
     - Auditar exportacion
     - Registro en user_action_log

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-AUD-003
   * - **Restricciones**
     - CNST-007, CNST-009, CNST-010
   * - **UC Relacionados**
     - UC_AUD_01, UC_AUD_02
   * - **Funcion RBAC**
     - AUD-003: exporta_auditoria

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
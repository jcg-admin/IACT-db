.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Pipeline
   :uc_id: UC_PIP_02
   :normativa: CNST-003, CNST-009

================================
UC_PIP_02: Consultar Errores ETL
================================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_PIP_02
   * - **Nombre**
     - Consultar Errores ETL
   * - **Actor Principal**
     - AGR-009: agr_admin_pipeline
   * - **Modulo**
     - MOD_Pipeline
   * - **Funcion RBAC**
     - PIP-002: ve_errores_etl
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-PIP-002

2. Descripcion
--------------

Este caso de uso permite consultar el historial de errores del proceso ETL,
incluyendo detalles de cada fallo, registros afectados y trazas de error
para diagnostico.

**Caracteristicas principales:**

- Listar ejecuciones fallidas
- Ver detalle de cada error (mensaje, traza, timestamp)
- Ver registros afectados por el error
- Filtrar por fecha, tipo de error, severidad
- Exportar log de errores

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_PIP_02

   @startuml
   left to right direction
   actor "AGR-009\nagr_admin_pipeline" as ADMIN

   rectangle "MOD_Pipeline" {
     usecase "UC_PIP_02\nConsultar Errores" as UC02
     usecase "Listar Errores" as LIST
     usecase "Ver Detalle" as DET
     usecase "Filtrar" as FILT
     usecase "Exportar Log" as EXP
   }

   ADMIN --> UC02
   UC02 --> LIST : include
   UC02 --> DET : extend
   UC02 --> FILT : extend
   UC02 --> EXP : extend
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
     - El administrador tiene sesion activa con funcion PIP-002
   * - PRE-02
     - Existen registros de ejecuciones ETL

4.2 Trigger
^^^^^^^^^^^

El administrador accede al modulo de errores ETL o hace clic en una alerta.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra el historial de errores filtrado
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
     - Accede a consulta de errores ETL
   * - 2
     - Sistema
     - Valida funcion PIP-002
   * - 3
     - Sistema
     - Consulta ejecuciones con status ERROR
   * - 4
     - Sistema
     - Presenta lista con: fecha, tipo error, registros afectados
   * - 5
     - Admin
     - Selecciona un error para ver detalle
   * - 6
     - Sistema
     - Muestra detalle: mensaje, stack trace, contexto
   * - 7
     - Admin
     - Opcionalmente exporta log

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_PIP_02

   @startuml
   actor "AGR-009 Admin" as A
   participant "Frontend" as FE
   participant "PipelineController" as PC
   participant "ETLErrorService" as EES
   database "Analytics" as DB

   A -> FE: Accede a Errores ETL
   FE -> PC: GET /api/pipeline/errors?days=30
   PC -> PC: verify_function(PIP-002)

   PC -> EES: get_errors(filters)
   EES -> DB: SELECT * FROM etl_executions\nWHERE status = 'ERROR'\nORDER BY started_at DESC
   DB --> EES: error_executions

   EES -> DB: SELECT * FROM etl_error_details\nWHERE execution_id IN (...)
   DB --> EES: error_details

   EES --> PC: errors_with_details
   PC --> FE: 200 OK + errors
   FE --> A: Lista de errores

   A -> FE: Click en error
   FE -> PC: GET /api/pipeline/errors/{id}
   PC -> EES: get_error_detail(id)
   EES -> DB: SELECT full_trace, context\nFROM etl_error_details
   DB --> EES: full_detail
   EES --> PC: error_detail
   PC --> FE: 200 OK
   FE --> A: Panel de detalle
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Sin Errores
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Sistema
     - No encuentra errores en el periodo
   * - 4b
     - Sistema
     - Muestra mensaje: Sin errores en el periodo

7.2 FA-02: Exportar Log
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 7a
     - Admin
     - Hace clic en Exportar
   * - 7b
     - Sistema
     - Genera archivo con errores filtrados
   * - 7c
     - Sistema
     - Descarga archivo

8. Excepciones
--------------

8.1 EX-01: Sin Permiso PIP-002
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Usuario no tiene funcion PIP-002
   * - **Accion Sistema**
     - Rechaza acceso
   * - **Mensaje Usuario**
     - No tiene permisos para ver errores ETL
   * - **Codigo Error**
     - PIP-010

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_PIP_02

   @startuml
   start
   :Admin accede a Errores ETL;
   if (Tiene PIP-002?) then (no)
     :Error permisos;
     stop
   else (si)
   endif
   :Consultar ejecuciones con ERROR;
   if (Hay errores?) then (no)
     :Mostrar Sin errores;
     stop
   else (si)
   endif
   :Mostrar lista de errores;
   if (Ver detalle?) then (si)
     :Consultar detalle completo;
     :Mostrar mensaje, trace, contexto;
   endif
   if (Exportar?) then (si)
     :Generar archivo;
     :Descargar;
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
   * - BR-PIP-10
     - Retencion Errores
     - Los errores se retienen por 90 dias para analisis
   * - BR-PIP-11
     - Solo Lectura
     - No se pueden modificar ni eliminar registros de error
   * - BR-PIP-12
     - Stack Trace Completo
     - Se almacena el stack trace completo para diagnostico

**Tipos de Errores ETL:**

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Tipo
     - Descripcion
   * - CONNECTION_ERROR
     - Fallo de conexion a BD IVR o Analytics
   * - VALIDATION_ERROR
     - Datos no cumplen validaciones
   * - TRANSFORM_ERROR
     - Error en transformacion de datos
   * - LOAD_ERROR
     - Error al cargar en Analytics
   * - TIMEOUT_ERROR
     - Ejecucion excedio tiempo limite

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
     - Los errores se leen de BD Analytics (etl_error_details). Los errores pueden originarse en lectura de IVR o escritura en Analytics.
   * - CNST-009
     - Auditoria Inmutable
     - Los registros de error son inmutables, no pueden modificarse.

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-PIP-010
     - El sistema debe listar errores ETL
     - Lista paginada con filtros
   * - FR-PIP-011
     - El sistema debe mostrar detalle de error
     - Mensaje, stack trace, contexto, registros afectados
   * - FR-PIP-012
     - El sistema debe permitir exportar errores
     - Archivo descargable con filtros aplicados

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-PIP-002: Permitir consulta de errores ETL
   * - **Reglas de Negocio**
     - BR-PIP-10 a BR-PIP-12
   * - **Restricciones**
     - CNST-003, CNST-009
   * - **UC Relacionados**
     - UC_PIP_01, UC_PIP_04
   * - **Actor Principal**
     - AGR-009: agr_admin_pipeline
   * - **Funcion RBAC**
     - PIP-002: ve_errores_etl

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

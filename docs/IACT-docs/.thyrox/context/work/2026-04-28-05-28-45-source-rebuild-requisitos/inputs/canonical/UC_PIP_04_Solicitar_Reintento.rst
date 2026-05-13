.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Pipeline
   :uc_id: UC_PIP_04
   :normativa: CNST-003, CNST-009

==============================
UC_PIP_04: Solicitar Reintento
==============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_PIP_04
   * - **Nombre**
     - Solicitar Reintento
   * - **Actor Principal**
     - AGR-009: agr_admin_pipeline
   * - **Actor Secundario**
     - Sistema (ejecuta reintento)
   * - **Modulo**
     - MOD_Pipeline
   * - **Funcion RBAC**
     - PIP-004: solicita_reintento_etl
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Alta
   * - **BReq Origen**
     - BRQ-PIP-004

2. Descripcion
--------------

Este caso de uso permite solicitar un reintento del proceso ETL para una
fecha o rango de fechas especifico. Util para recuperar datos despues de
un fallo o para llenar gaps detectados.

**Caracteristicas principales:**

- Solicitar reintento para fecha especifica
- Solicitar reintento para rango de fechas
- Justificacion obligatoria
- El reintento se encola para ejecucion asincrona
- Registro completo en auditoria (CNST-009)

**Restriccion SoD:**

.. warning::
   AGR-009 (admin_pipeline) es INCOMPATIBLE con AGR-008 (auditor).
   Quien opera el pipeline NO puede auditar el sistema.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_PIP_04

   @startuml
   left to right direction
   actor "AGR-009\nagr_admin_pipeline" as ADMIN
   actor "Sistema" as SYS

   rectangle "MOD_Pipeline" {
     usecase "UC_PIP_04\nSolicitar Reintento" as UC04
     usecase "Seleccionar Fechas" as SEL
     usecase "Encolar Reintento" as ENQ
     usecase "Ejecutar ETL" as EXEC
     usecase "Registrar Auditoria" as AUD
   }

   ADMIN --> UC04
   UC04 --> SEL : include
   UC04 --> ENQ : include
   UC04 --> AUD : include
   SYS --> EXEC
   SYS --> AUD
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
     - El administrador tiene sesion activa con funcion PIP-004
   * - PRE-02
     - No hay un reintento en curso para las mismas fechas
   * - PRE-03
     - Las fechas solicitadas estan dentro del rango permitido (max 2 anios)

4.2 Trigger
^^^^^^^^^^^

El administrador solicita reintento desde errores o disponibilidad.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se crea registro de solicitud de reintento
   * - POST-02
     - El reintento se encola para ejecucion
   * - POST-03
     - Se registra RETRY_REQUEST en auditoria (CNST-009)

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
     - Accede a solicitar reintento
   * - 2
     - Sistema
     - Valida funcion PIP-004
   * - 3
     - Admin
     - Selecciona fecha o rango de fechas
   * - 4
     - Sistema
     - Valida que fechas esten en rango permitido
   * - 5
     - Sistema
     - Verifica que no haya reintento en curso
   * - 6
     - Admin
     - Ingresa justificacion (obligatoria)
   * - 7
     - Admin
     - Confirma solicitud
   * - 8
     - Sistema
     - Crea registro de solicitud de reintento
   * - 9
     - Sistema
     - Encola reintento para ejecucion asincrona
   * - 10
     - Sistema
     - Registra RETRY_REQUEST en auditoria
   * - 11
     - Sistema
     - Muestra confirmacion con ID de solicitud
   * - 12
     - Sistema
     - El ETL se ejecuta asincronamente

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_PIP_04

   @startuml
   actor "AGR-009 Admin" as A
   participant "Frontend" as FE
   participant "PipelineController" as PC
   participant "RetryService" as RS
   participant "ETLQueue" as Q
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   A -> FE: Solicitar Reintento
   FE --> A: Formulario
   A -> FE: fecha_inicio, fecha_fin, justificacion
   A -> FE: Confirma

   FE -> PC: POST /api/pipeline/retry
   PC -> PC: verify_function(PIP-004)

   PC -> RS: request_retry(dates, justification, admin)

   RS -> RS: validate_date_range()
   note right: Max 2 anios CNST-006

   RS -> DB: SELECT * FROM etl_retry_requests\nWHERE status = 'PENDING'\nAND dates OVERLAP
   DB --> RS: existing_requests

   alt reintento en curso
     RS --> PC: RetryInProgressError
     PC --> FE: 409 Conflict
     FE --> A: Error: Ya hay reintento en curso
   end

   RS -> DB: INSERT INTO etl_retry_requests\n(dates, justification, requested_by, status)
   DB --> RS: request_id

   RS -> Q: enqueue(retry_request)
   Q --> RS: queued

   RS -> UAL: record(RETRY_REQUEST, admin, dates)
   UAL -> DB: INSERT audit
   note right of UAL
     CNST-009: Auditoria
     Incluye fechas y justificacion
   end note

   RS --> PC: {request_id, status: 'QUEUED'}
   PC --> FE: 202 Accepted
   FE --> A: Confirmacion: Reintento encolado #ID

   ... Ejecucion Asincrona ...

   Q -> Q: process_retry()
   Q -> DB: UPDATE etl_retry_requests\nSET status = 'COMPLETED'
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Reintento para Fecha Unica
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 3a
     - Admin
     - Selecciona una sola fecha
   * - 4a
     - Sistema
     - Valida fecha
   * - 5a
     - Sistema
     - Procede con flujo normal

7.2 FA-02: Desde Consulta de Errores
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Admin
     - Hace clic en Reintentar desde lista de errores
   * - 3a
     - Sistema
     - Pre-selecciona fecha del error
   * - 6a
     - Sistema
     - Pre-llena justificacion: Reintento por error ID X

8. Excepciones
--------------

8.1 EX-01: Sin Permiso PIP-004
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Usuario no tiene funcion PIP-004
   * - **Accion Sistema**
     - Rechaza solicitud
   * - **Mensaje Usuario**
     - No tiene permisos para solicitar reintentos
   * - **Codigo Error**
     - PIP-030

8.2 EX-02: Reintento en Curso
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 5
   * - **Condicion**
     - Ya existe reintento pendiente para las fechas
   * - **Accion Sistema**
     - Rechaza solicitud
   * - **Mensaje Usuario**
     - Ya existe un reintento en curso para estas fechas
   * - **Codigo Error**
     - PIP-031

8.3 EX-03: Fechas Fuera de Rango
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 4
   * - **Condicion**
     - Fechas mayores a 2 anios
   * - **Accion Sistema**
     - Rechaza solicitud
   * - **Mensaje Usuario**
     - Solo se pueden reintentar datos de los ultimos 2 anios
   * - **Codigo Error**
     - PIP-032

8.4 EX-04: Sin Justificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 6
   * - **Condicion**
     - Campo justificacion vacio
   * - **Accion Sistema**
     - Rechaza solicitud
   * - **Mensaje Usuario**
     - Justificacion es obligatoria
   * - **Codigo Error**
     - PIP-033

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_PIP_04

   @startuml
   start
   :Admin solicita reintento;
   if (Tiene PIP-004?) then (no)
     :Error permisos;
     stop
   else (si)
   endif
   :Seleccionar fechas;
   if (Fechas > 2 anios?) then (si)
     :Error fuera de rango;
     stop
   else (no)
   endif
   if (Reintento en curso?) then (si)
     :Error ya en curso;
     stop
   else (no)
   endif
   :Ingresar justificacion;
   if (Justificacion vacia?) then (si)
     :Error justificacion requerida;
     stop
   else (no)
   endif
   :Crear solicitud de reintento;
   :Encolar para ejecucion;
   :Registrar en auditoria;
   note right: CNST-009
   :Mostrar confirmacion;
   :Ejecutar ETL asincronamente;
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
   * - BR-PIP-30
     - Rango Maximo
     - Solo se pueden reintentar datos de los ultimos 2 anios
   * - BR-PIP-31
     - Sin Duplicados
     - No puede haber dos reintentos en curso para las mismas fechas
   * - BR-PIP-32
     - Justificacion Obligatoria
     - Todo reintento requiere justificacion para auditoria
   * - BR-PIP-33
     - Ejecucion Asincrona
     - El reintento se encola y ejecuta asincronamente

**Estados de Solicitud de Reintento:**

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - Estado
     - Descripcion
   * - PENDING
     - Solicitud creada, esperando en cola
   * - RUNNING
     - Reintento en ejecucion
   * - COMPLETED
     - Reintento completado exitosamente
   * - FAILED
     - Reintento fallo
   * - CANCELLED
     - Reintento cancelado por admin

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
     - El reintento lee de IVR (readonly) y escribe en Analytics. La solicitud se almacena en Analytics.
   * - CNST-009
     - Auditoria Inmutable
     - Se registra RETRY_REQUEST con fechas, justificacion, admin solicitante y resultado.

**Implementacion CNST-009:**

.. code-block:: python

   UserActionLog.record(
       user=admin,
       action='RETRY_REQUEST',
       resource='ETL',
       result='QUEUED',
       ip=request.META.get('REMOTE_ADDR'),
       details={
           'request_id': request_id,
           'date_start': date_start.isoformat(),
           'date_end': date_end.isoformat(),
           'justification': justification,
           'triggered_from': 'manual|error|gap'
       }
   )

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-PIP-030
     - El sistema debe permitir solicitar reintento por fecha
     - Solicitud creada con fecha especifica
   * - FR-PIP-031
     - El sistema debe validar rango de 2 anios
     - Rechazo si fechas fuera de rango
   * - FR-PIP-032
     - El sistema debe requerir justificacion
     - Campo obligatorio no vacio
   * - FR-PIP-033
     - El sistema debe ejecutar reintento asincronamente
     - Respuesta 202 Accepted inmediata

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-PIP-004: Permitir solicitud de reintentos ETL
   * - **Reglas de Negocio**
     - BR-PIP-30 a BR-PIP-33
   * - **Restricciones**
     - CNST-003, CNST-009
   * - **UC Relacionados**
     - UC_PIP_01, UC_PIP_02, UC_PIP_03
   * - **Actor Principal**
     - AGR-009: agr_admin_pipeline
   * - **Funcion RBAC**
     - PIP-004: solicita_reintento_etl

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
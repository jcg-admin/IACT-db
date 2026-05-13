.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Audit
   :uc_id: UC_AUD_04
   :normativa: CNST-009, CNST-010

=====================================
UC_AUD_04: Generar Reporte Compliance
=====================================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_AUD_04
   * - **Nombre**
     - Generar Reporte Compliance
   * - **Actor Principal**
     - AGR-006: agr_auditor
   * - **Modulo**
     - MOD_Audit
   * - **Funcion RBAC**
     - AUD-004: genera_compliance
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Alta
   * - **BReq Origen**
     - BRQ-AUD-004

2. Descripcion
--------------

Este caso de uso permite generar reportes predefinidos de compliance
y cumplimiento normativo. Incluye reportes de accesos, cambios de
permisos, acciones administrativas y otros requeridos por regulaciones.

**Caracteristicas principales:**

- Reportes predefinidos de compliance
- Formatos PDF y Excel con formato corporativo
- Periodos configurables (mensual, trimestral, anual)
- Incluye estadisticas y graficos
- Datos de auditoria inmutables (CNST-009)
- Acceso restringido a auditor (CNST-010)

**Reportes Disponibles:**

- Reporte de Accesos: Logins exitosos y fallidos
- Reporte de Cambios de Permisos: Modificaciones RBAC
- Reporte de Acciones Administrativas: CREATE, UPDATE, DELETE
- Reporte de Exportaciones: Todas las exportaciones de datos
- Reporte de Alertas: Alertas generadas y reconocidas

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_AUD_04

   @startuml
   left to right direction
   actor "AGR-006\nagr_auditor" as USER

   rectangle "MOD_Audit" {
     usecase "UC_AUD_04\nGenerar Reporte\nCompliance" as UC04
     usecase "Seleccionar\nTipo Reporte" as TIPO
     usecase "Configurar\nPeriodo" as PER
     usecase "Generar\nPDF/Excel" as GEN
   }

   USER --> UC04
   UC04 --> TIPO : include
   UC04 --> PER : include
   UC04 --> GEN : include
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
     - El usuario tiene sesion activa con funcion AUD-004
   * - PRE-02
     - El usuario cumple con SoD-003
   * - PRE-03
     - Existen datos de auditoria para el periodo

4.2 Trigger
^^^^^^^^^^^

El auditor accede a generacion de reportes de compliance.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se genera reporte en formato seleccionado
   * - POST-02
     - Se registra COMPLIANCE_REPORT en auditoria

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
     - Accede a reportes de compliance
   * - 2
     - Sistema
     - Valida funcion AUD-004
   * - 3
     - Sistema
     - Valida cumplimiento SoD-003
   * - 4
     - Sistema
     - Muestra tipos de reportes disponibles
   * - 5
     - Auditor
     - Selecciona tipo de reporte
   * - 6
     - Auditor
     - Selecciona periodo (mes, trimestre, anio)
   * - 7
     - Auditor
     - Selecciona formato de salida (PDF o Excel)
   * - 8
     - Sistema
     - Consulta datos del periodo
   * - 9
     - Sistema
     - Calcula estadisticas y genera graficos
   * - 10
     - Sistema
     - Genera documento con formato corporativo
   * - 11
     - Sistema
     - Registra COMPLIANCE_REPORT en auditoria
   * - 12
     - Sistema
     - Descarga documento

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_AUD_04

   @startuml
   actor "AGR-006 Auditor" as A
   participant "Frontend" as FE
   participant "AuditController" as AC
   participant "SoDValidator" as SOD
   participant "ComplianceService" as CS
   participant "ReportGenerator" as RG
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   A -> FE: Accede a Reportes Compliance
   FE -> AC: GET /api/audit/compliance/types
   AC -> AC: verify_function(AUD-004)
   AC -> SOD: validate_sod(user, 'SoD-003')
   SOD --> AC: sod_valid
   AC --> FE: report_types
   FE --> A: Lista de reportes

   A -> FE: tipo, periodo, formato
   FE -> AC: POST /api/audit/compliance/generate

   AC -> CS: generate_compliance_report(params)

   CS -> DB: SELECT datos segun tipo de reporte\nFROM user_action_log\nWHERE created_at BETWEEN ? AND ?
   note right of DB: CNST-009 Solo SELECT
   DB --> CS: audit_data

   CS -> CS: calculate_statistics()
   CS -> CS: detect_anomalies()

   CS -> RG: generate_report(data, format)
   RG -> RG: add_corporate_header()
   RG -> RG: add_summary_section()
   RG -> RG: add_charts()
   RG -> RG: add_detail_tables()
   RG -> RG: add_conclusions()
   RG --> CS: document

   CS -> UAL: record(COMPLIANCE_REPORT)
   UAL -> DB: INSERT user_action_log

   CS --> AC: report_file
   AC --> FE: 200 OK + file
   FE --> A: Descarga reporte
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Reporte de Accesos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Auditor
     - Selecciona Reporte de Accesos
   * - 8a
     - Sistema
     - Consulta LOGIN_SUCCESS, LOGIN_FAILURE, LOGOUT
   * - 9a
     - Sistema
     - Calcula: total logins, tasa de fallo, usuarios mas activos

7.2 FA-02: Reporte de Cambios de Permisos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Auditor
     - Selecciona Reporte de Cambios de Permisos
   * - 8a
     - Sistema
     - Consulta ROLE_ASSIGN, ROLE_REVOKE, PERMISSION_CHANGE
   * - 9a
     - Sistema
     - Lista usuarios afectados, cambios por administrador

7.3 FA-03: Reporte en PDF
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 7a
     - Auditor
     - Selecciona formato PDF
   * - 10a
     - Sistema
     - Genera PDF con graficos embebidos

8. Excepciones
--------------

8.1 EX-01: Sin Datos en Periodo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 8
   * - **Condicion**
     - No hay datos de auditoria para el periodo
   * - **Accion Sistema**
     - Genera reporte vacio con nota
   * - **Mensaje Usuario**
     - Reporte generado sin datos para el periodo

8.2 EX-02: Error Generacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 10
   * - **Condicion**
     - Error al generar documento
   * - **Accion Sistema**
     - Informa error
   * - **Mensaje Usuario**
     - Error al generar reporte. Intente nuevamente.
   * - **Codigo Error**
     - AUD-030

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_AUD_04

   @startuml
   start
   :Auditor accede a Reportes Compliance;

   if (Tiene AUD-004?) then (no)
     stop
   else (si)
   endif

   if (Cumple SoD-003?) then (no)
     :Error SoD;
     stop
   else (si)
   endif

   :Seleccionar tipo de reporte;
   :Seleccionar periodo;
   :Seleccionar formato;

   :Consultar datos de auditoria;
   note right: CNST-009 Solo lectura

   :Calcular estadisticas;
   :Detectar anomalias;
   :Generar graficos;
   :Compilar documento;

   :Registrar generacion en auditoria;
   :Descargar documento;

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
   * - BR-AUD-30
     - Reportes Predefinidos
     - Solo tipos de reportes predefinidos disponibles
   * - BR-AUD-31
     - Periodos Estandar
     - Mensual, trimestral, semestral, anual
   * - BR-AUD-32
     - Formato Corporativo
     - Reportes incluyen logo y formato estandar
   * - BR-AUD-33
     - Auditoria de Generacion
     - Cada generacion se registra en auditoria

**Tipos de Reportes:**

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Tipo
     - Contenido
   * - ACCESOS
     - Logins exitosos/fallidos, patrones de acceso, IPs
   * - PERMISOS
     - Cambios de roles, asignaciones, revocaciones
   * - ADMINISTRATIVO
     - Creaciones, modificaciones, eliminaciones
   * - EXPORTACIONES
     - Todas las exportaciones de datos del sistema
   * - ALERTAS
     - Alertas generadas, reconocidas, tiempos de respuesta

**Secciones del Reporte:**

1. Portada con periodo y tipo
2. Resumen ejecutivo
3. Estadisticas principales
4. Graficos de tendencias
5. Detalle de eventos
6. Anomalias detectadas
7. Conclusiones y recomendaciones

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion
   * - CNST-009
     - Inmutable
     - Datos de auditoria no se modifican al generar
   * - CNST-010
     - SoD
     - Solo auditor puede generar reportes compliance

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-AUD-030
     - Generar reportes compliance
     - Documento PDF/Excel generado
   * - FR-AUD-031
     - Incluir estadisticas
     - Metricas y graficos presentes
   * - FR-AUD-032
     - Formato corporativo
     - Logo y estructura estandar
   * - FR-AUD-033
     - Auditar generacion
     - Registro en user_action_log

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-AUD-004
   * - **Restricciones**
     - CNST-009, CNST-010
   * - **UC Relacionados**
     - UC_AUD_01, UC_AUD_03
   * - **Funcion RBAC**
     - AUD-004: genera_compliance

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
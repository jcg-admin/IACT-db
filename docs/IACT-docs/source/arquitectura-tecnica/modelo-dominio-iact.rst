.. meta::
 :artefacto: MODELO_DOMINIO_IACT
 :tipo: Modelo Arquitectonico
 :dominio: arquitectura_tecnica
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Critico

.. _modelo-dominio-iact:

===================
MODELO DOMINIO IACT
===================

.. note::

 **Modelo conceptual canonico del dominio IACT**, complementario a
 :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`. Producido por
 el WP ``2026-05-01-02-01-06-domain-model-canonization`` aplicando el
 filtro de Abbott + IEEE 830 sobre el corpus vigente (61 UCs, 61
 funciones RBAC v5.4.0, BR/CNST en sus versiones vigentes).

 **Convencion de nombres**: identificadores (clases, atributos,
 operaciones, valores de enum) en **ingles** por consistencia con el
 modelo RBAC v5.4.0 y NOM_001 § 2.3. La prosa, los comentarios y las
 notas de los diagramas estan en **espanol**.

----

1. Proposito y alcance
======================

Este documento materializa las **25 clases canonicas** del dominio
IACT distribuidas en **siete bounded contexts** (Auth, RBAC, Calls,
Reports & Metrics, Pipeline ETL, Alerts, Audit, Logs). Cada clase
incluye atributos relevantes, operaciones de negocio, restricciones
canonicas (BR/CNST en versiones vigentes) y trazabilidad a los UCs
del catalogo.

El alcance del modelo cubre los conceptos persistentes con identidad
propia y operaciones de negocio. Roles operativos
(Operator/Supervisor/Administrator/Auditor) NO son clases — se
modelan como pertenencia del usuario a un AccessGroup. El concepto
``DataSegment`` que aparecio en versiones historicas fue descartado
por Z.1.C (Camino C) y no aparece en este modelo.

----

2. Convenciones aplicadas
=========================

2.1 Identificadores en ingles
-----------------------------

- **Clases** en PascalCase (``User``, ``Session``, ``ETLExecution``).
- **Atributos** en snake_case (``user_id``, ``started_at``,
  ``last_login_at``).
- **Operaciones** en snake_case (``deactivate``, ``acknowledge``,
  ``schedule_report``).
- **Valores de enum** en UPPER_SNAKE (``ACTIVE``, ``ACKNOWLEDGED``).

Justificacion: el modelo RBAC v5.4.0 ya usa ingles para nombres de
funciones tras la correccion aplicada por Z.1.C. Mantener una
unica convencion idiomatica para todos los identificadores formales
del dominio reduce el costo cognitivo y el riesgo de mismatches que
documentaron las iteraciones previas v5.0..v5.2.x.

2.2 Versiones canonicas de constraints
--------------------------------------

Todas las restricciones citadas en este documento son las versiones
vigentes tras el programa Z (modelo-rbac-improvement):

.. list-table::
 :widths: 30 15 55
 :header-rows: 1

 * - Constraint
   - Version
   - Alcance
 * - BR-009 — Bajas logicas
   - v2.0.0
   - Global; toda entidad con ciclo de vida desactiva, no elimina
 * - BR-011 — Limites de exportacion
   - v2.0.0
   - Delega a CNST-019 / CNST-020; sin cifras embebidas
 * - CNST-001 — Buzon interno
   - vigente
   - Entrega de notificaciones via ``InternalMailbox``, no email
 * - CNST-002 — Caducidad de sesion
   - vigente
   - Timeout de sesion configurable
 * - CNST-003 — Sesion unica
   - vigente
   - Una sesion activa por usuario
 * - CNST-006 / 007 / 008 — Ventana ETL
   - vigente
   - Ventana de carga, BD operativa de solo lectura, BD analitica
 * - CNST-019 — Exportaciones asincronas
   - v3.0.0
   - Cola asincrona abstracta; sin acoplamiento a tecnologia
 * - CNST-020 — Throttling de exportaciones
   - v3.0.0
   - Throttling abstracto por recursos; cifras en ADR de
     implementacion
 * - CNST-024 — Retencion de logs
   - vigente
   - Periodo de retencion para los logs y snapshots de salud
 * - CNST-025 — Auditoria inmutable
   - vigente
   - Append-only en ``AuditEvent``; sin UPDATE ni DELETE
 * - CNST-030 — Separacion de funciones (SoD)
   - vigente
   - Reglas de exclusion mutua entre funciones
 * - CNST-031 — Rango temporal de permisos
   - vigente
   - Permisos excepcionales con ventana ``granted_at..expires_at``

----

3. Vista global — bounded contexts y puentes
============================================

Diagrama de overview con los siete bounded contexts y las
relaciones estructurales que cruzan los limites de contexto. Para
el detalle de cada contexto ver § 4.

.. uml::
 :caption: Overview del modelo de dominio IACT — siete bounded
           contexts y puentes inter-contexto.

 @startuml
 !include ../_static/plantuml-styles.puml

 skinparam package {
   BackgroundColor #F8F8F8
   BorderColor #888
 }

 package "Auth" as A {
   class User
   class Session
   class InternalMailbox
 }

 package "RBAC (subsume PERM)" as R {
   class Function
   class FunctionGroup
   class AccessGroup
   class Assignment
   class ExceptionalPermission
   class SeparationRule
 }

 package "Calls" as C {
   class Call
   class Campaign
 }

 package "Reports & Metrics" as P {
   class Report
   class Metric
   class ExportJob
   class ScheduledReport
   class SavedView
 }

 package "Pipeline ETL" as E {
   class ETLExecution
   class ETLError
 }

 package "Alerts" as L {
   class Alert
   class Threshold
   class Subscription
 }

 package "Audit" as D {
   class AuditEvent
 }

 package "Logs" as G {
   class ApplicationLog
   class ETLLog
   class InfrastructureLog
   class SystemHealth
   class TechnicalMetric
 }

 ' Puentes estructurales entre contextos
 User      "1" -- "*"   Session
 User      "1" -- "1"   InternalMailbox
 User      "1" -- "*"   Assignment
 Function  "*" -- "*"   FunctionGroup        : (via Assignment)
 Report    "1" -- "*"   Metric                : compone
 Report    "1" -- "*"   ExportJob
 Report    "1" -- "*"   ScheduledReport
 Report    "1" -- "*"   SavedView
 Report    "*" .. "*"   Call                  : agrega
 ETLExecution "1" -- "*" ETLError
 ETLExecution "1" .. "*" Call                 : carga
 Alert     "*" -- "1"   Threshold
 Alert     "1" -- "*"   Subscription
 Subscription "*" -- "1" User

 note right of D
   Toda operacion de escritura en
   cualquier contexto produce 1 o mas
   AuditEvent (CNST-025: inmutable,
   append-only).
 end note

 @enduml

----

4. Bounded contexts
===================

4.1 Auth
--------

Tres clases: ``User``, ``Session`` y ``InternalMailbox``. La clase
``User`` es la entidad central; ``Session`` representa una sesion
activa con caducidad; ``InternalMailbox`` es el canal de
notificacion interno (sin email externo, CNST-001).

.. uml::
 :caption: Bounded context Auth — usuarios, sesiones y buzon
           interno.

 @startuml
 !include ../_static/plantuml-styles.puml

 class User {
   + user_id : UUID
   + username : String
   + email : String
   + full_name : String
   + state : UserState
   + created_at : DateTime
   + last_login_at : DateTime
   + primary_access_group_id : String
   --
   + create()
   + deactivate()       <<BR-009 v2.0.0>>
   + modify()
   + view()
   + recover_password()
 }

 class Session {
   + session_id : UUID
   + user_id : UUID
   + started_at : DateTime
   + last_activity_at : DateTime
   + expires_at : DateTime
   + state : SessionState
   + client_info : String
   --
   + open()
   + close()              <<sesion propia>>
   + close_all()          <<admin: AUTH-004>>
   + view_own_sessions()  <<AUTH-001>>
 }

 class InternalMailbox {
   + mailbox_id : UUID
   + owner_user_id : UUID
   + last_read_at : DateTime
   --
   + deliver_message()
   + view_messages()
   + mark_read()
 }

 enum UserState {
   ACTIVE
   INACTIVE
   BLOCKED
 }

 enum SessionState {
   ACTIVE
   CLOSED
   EXPIRED
 }

 User "1" -- "0..*" Session            : posee
 User "1" -- "1"    InternalMailbox    : posee
 User -- UserState
 Session -- SessionState

 note bottom of Session
   CNST-002: timeout de sesion.
   CNST-003: una sola sesion activa por usuario.
 end note

 note bottom of InternalMailbox
   CNST-001: buzon interno unicamente,
   sin canal de email externo.
 end note

 @enduml

4.2 RBAC (subsume PERM)
-----------------------

Seis clases: ``Function``, ``FunctionGroup``, ``AccessGroup``,
``Assignment``, ``ExceptionalPermission`` y ``SeparationRule``. Por
ADR-GOB-008 el cluster PERM es una vista tecnica sobre estas
mismas entidades; no introduce clases adicionales.

.. uml::
 :caption: Bounded context RBAC — modelo de control de acceso
           basado en funciones atomicas.

 @startuml
 !include ../_static/plantuml-styles.puml

 class Function {
   + function_id : String   <<p.ej. RPT-001>>
   + name : String          <<p.ej. view_reports>>
   + description : String
   + module : Module
   --
   + register()             <<sistema>>
   + view()                 <<ACC-003>>
 }

 class FunctionGroup {
   + group_id : UUID
   + name : String
   + description : String
   --
   + create_function_group()       <<ACC-006>>
   + assign_functions_to_group()   <<ACC-007>>
   + revoke_function_group()       <<ACC-008>>
 }

 class AccessGroup {
   + agr_id : String          <<AGR-001..010>>
   + name : String            <<p.ej. agr_supervisor>>
   + profile_description : String
   --
   + assign_to_user()        <<ACC-004>>
   + revoke_from_user()
 }

 class Assignment {
   + assignment_id : UUID
   + user_id : UUID
   + group_ref : String       <<FunctionGroup o AccessGroup>>
   + assigned_by : UUID
   + assigned_at : DateTime
   + expires_at : DateTime
   + state : AssignmentState
   --
   + create()
   + revoke()
 }

 class ExceptionalPermission {
   + permission_id : UUID
   + user_id : UUID
   + function_id : String
   + granted_by : UUID
   + granted_at : DateTime
   + expires_at : DateTime
   + justification : String
   + state : PermissionState
   --
   + grant()           <<ACC-009>>
   + revoke()          <<ACC-010>>
 }

 class SeparationRule {
   + rule_id : UUID
   + name : String
   + conflicting_functions : List<String>
   + rule_group : String
   + state : RuleState
   --
   + create()                  <<ACC-005>>
   + view()                    <<ACC-005 view_separation_rules>>
   + update_separation_rule()  <<ACC-011>>
   + disable_separation_rule() <<ACC-012>>
 }

 enum Module {
   AUTH
   USR
   ACC
   PIP
   RPT
   ALR
   AUD
   LOG
 }

 enum AssignmentState { ACTIVE EXPIRED REVOKED }
 enum PermissionState { ACTIVE EXPIRED REVOKED }
 enum RuleState { ENABLED DISABLED }

 FunctionGroup "*" -- "*" Function : contiene
 Assignment "*" -- "1" FunctionGroup : (cuando group_ref = grupo)
 Assignment "*" -- "1" AccessGroup   : (cuando group_ref = AGR)
 ExceptionalPermission "*" -- "1" Function
 SeparationRule "1" -- "*" Function : (lista funciones en conflicto)
 Function -- Module

 note right of SeparationRule
   BR-009 v2.0.0: desactivar, no eliminar.
   CNST-030: enforcement SoD.
 end note

 note right of ExceptionalPermission
   CNST-031: rango temporal
   (granted_at .. expires_at).
 end note

 @enduml

4.3 Calls
---------

Dos clases: ``Call`` y ``Campaign``. Datos de solo lectura
provenientes de la base de datos operativa (CNST-007). El corpus
IACT no realiza operaciones de escritura sobre estas entidades.

.. uml::
 :caption: Bounded context Calls — datos operativos del call
           center (solo lectura).

 @startuml
 !include ../_static/plantuml-styles.puml

 class Call {
   + call_id : String
   + started_at : DateTime
   + duration_seconds : Integer
   + agent_id : String
   + campaign_id : String
   + center : String
   + region : String
   + abandoned : Boolean
   + transferred : Boolean
 }

 class Campaign {
   + campaign_id : String
   + name : String
   + service_type : String
   + region : String
 }

 Call "*" -- "1" Campaign

 note bottom of Call
   CNST-007: BD operativa de solo lectura.
 end note

 @enduml

4.4 Reports & Metrics
---------------------

Cinco clases: ``Report``, ``Metric``, ``ExportJob``,
``ScheduledReport`` y ``SavedView``. Por D-10 (Z.2 decision log) los
distintos tipos de reporte se modelan como instancias de ``Report``
con un atributo ``scope`` enumerado, no como subclases.

.. uml::
 :caption: Bounded context Reports & Metrics — reportes,
           metricas, exportacion asincrona, programacion y
           vistas guardadas.

 @startuml
 !include ../_static/plantuml-styles.puml

 class Report {
   + report_id : UUID
   + scope : ReportScope
   + filters : List<Filter>
   + owner_user_id : UUID
   + state : ReportState
   --
   + view()                <<RPT-001>>
   + filter()              <<RPT-003>>
   + share()               <<RPT-010 share_report>>
   + export()              <<delega en ExportJob>>
 }

 class Metric {
   + metric_id : UUID
   + name : MetricName
   + formula : String
   + unit : String
   --
   + compute()
   + view()                <<RPT-002>>
 }

 class ExportJob {
   + job_id : UUID
   + requested_by : UUID
   + report_id : UUID
   + format : ExportFormat
   + state : JobState
   + enqueued_at : DateTime
   + completed_at : DateTime
   + artifact_path : String
   --
   + enqueue()
   + process()
   + complete()
   + fail()
 }

 class ScheduledReport {
   + schedule_id : UUID
   + report_id : UUID
   + owner_user_id : UUID
   + schedule_expression : String   <<cron>>
   + next_run_at : DateTime
   + last_run_at : DateTime
   + state : ScheduleState
   --
   + create()             <<RPT-009 schedule_report>>
   + modify()
   + disable()            <<BR-009>>
 }

 class SavedView {
   + view_id : UUID
   + owner_user_id : UUID
   + report_id : UUID
   + filters_snapshot : List<Filter>
   + name : String
   + state : ViewState
   --
   + save()               <<RPT-010 save_view>>
   + load()
   + deactivate()         <<BR-009>>
 }

 enum ReportScope {
   GENERAL
   TRANSFERENCES
   IVR_MENUS
   UNIQUE_CLIENTS
   AGENTS
   QUEUES
   CAMPAIGNS
 }

 enum ReportState { DRAFT PUBLISHED ARCHIVED }
 enum JobState { QUEUED PROCESSING DONE FAILED }
 enum ScheduleState { ACTIVE DISABLED }
 enum ViewState { ACTIVE INACTIVE }
 enum ExportFormat { CSV EXCEL PDF }

 enum MetricName {
   ABANDONMENT_RATE
   AVG_WAIT_TIME
   EFFICIENCY_INDEX
   ANSWERED_RATE
 }

 Report "1" *-- "1..*" Metric            : compone
 Report "1" -- "0..*" ExportJob
 Report "1" -- "0..*" ScheduledReport
 Report "1" -- "0..*" SavedView
 Report -- ReportScope
 ExportJob -- ExportFormat
 ExportJob -- JobState
 Metric -- MetricName

 note right of ExportJob
   CNST-019 v3.0.0: cola asincrona abstracta.
   CNST-020 v3.0.0: throttling abstracto.
   BR-011 v2.0.0: limites delegados a CNST.
   Cifras concretas y stack tecnologico viven
   en el ADR de implementacion.
 end note

 note right of Report
   D-10: scope es atributo, no subclase.
   Los siete scope canonicos cubren los
   17 UCs del cluster RPT.
 end note

 @enduml

4.5 Pipeline ETL
----------------

Dos clases: ``ETLExecution`` y ``ETLError``. La clase
``LoadedRow`` que aparece en versiones historicas no es una clase
del dominio — es dato operativo transitorio. ``Scheduler`` es
infraestructura, no dominio (vive en el ADR de despliegue
ADR-DEVOPS-001).

.. uml::
 :caption: Bounded context Pipeline ETL — ejecuciones y errores
           del proceso de carga.

 @startuml
 !include ../_static/plantuml-styles.puml

 class ETLExecution {
   + execution_id : UUID
   + started_at : DateTime
   + completed_at : DateTime
   + status : ExecutionStatus
   + source_window_start : DateTime
   + source_window_end : DateTime
   + rows_loaded : Integer
   --
   + start()
   + complete()
   + fail()
   + retry()             <<PIP-004 request_retry>>
 }

 class ETLError {
   + error_id : UUID
   + execution_id : UUID
   + error_type : String
   + error_message : String
   + occurred_at : DateTime
   + classified_severity : Severity
   + resolved : Boolean
   --
   + record()
   + classify()
   + mark_resolved()
 }

 enum ExecutionStatus {
   RUNNING
   COMPLETED
   FAILED
   RETRYING
 }

 enum Severity { INFO WARN ERROR FATAL }

 ETLExecution "1" *-- "0..*" ETLError
 ETLExecution -- ExecutionStatus

 note right of ETLExecution
   CNST-006: ventana de carga.
   CNST-007: BD operativa de solo lectura.
   CNST-008: BD analitica con ventana de
   escritura.
 end note

 @enduml

4.6 Alerts
----------

Tres clases: ``Alert``, ``Threshold`` y ``Subscription``. La
maquina de estados de ``Alert`` incluye la transicion
ACTIVE → ACKNOWLEDGED introducida por D-02 (closed-loop alerts).
Por D-03 las operaciones de suscripcion se separan en tres
funciones RBAC distintas para permitir SoD.

.. uml::
 :caption: Bounded context Alerts — alertas, umbrales y
           suscripciones.

 @startuml
 !include ../_static/plantuml-styles.puml

 class Alert {
   + alert_id : UUID
   + threshold_id : UUID
   + triggered_at : DateTime
   + value : Double
   + state : AlertState
   + acknowledged_by : UUID
   + acknowledged_at : DateTime
   --
   + configure()         <<ALR-001>>
   + acknowledge()       <<ALR-007>>
   + disable()           <<ALR-005 disable_alerts>>
 }

 class Threshold {
   + threshold_id : UUID
   + metric_id : UUID
   + comparison_operator : CompOp
   + value : Double
   + severity : Severity
   --
   + configure()         <<ALR-002 configure_thresholds>>
 }

 class Subscription {
   + subscription_id : UUID
   + alert_id : UUID
   + subscriber_user_id : UUID
   + severity_filter : Severity
   + state : SubscriptionState
   --
   + subscribe()              <<ALR-008>>
   + unsubscribe()            <<ALR-009>>
   + configure_severity()     <<ALR-010>>
 }

 enum AlertState {
   ACTIVE
   ACKNOWLEDGED
   DISABLED
 }

 enum CompOp { GT GE LT LE EQ NE }
 enum SubscriptionState { ACTIVE INACTIVE }

 Alert "*" -- "1" Threshold
 Alert "1" -- "0..*" Subscription
 Alert -- AlertState

 note right of Alert
   D-02: closed-loop alerts.
   La transicion ACTIVE -> ACKNOWLEDGED
   queda auditada (CNST-025).
 end note

 note right of Subscription
   D-03: tres operaciones separadas
   (subscribe / unsubscribe / configure_severity)
   para SoD a nivel RBAC.
 end note

 @enduml

4.7 Audit
---------

Una clase: ``AuditEvent``. Append-only, inmutable (CNST-025). Las
especializaciones historicas ``PermissionAudit`` y ``AccessAudit``
se realizan como valores del enum ``event_type``, no como subclases.

.. uml::
 :caption: Bounded context Audit — registro inmutable de eventos.

 @startuml
 !include ../_static/plantuml-styles.puml

 class AuditEvent {
   + event_id : UUID                 <<inmutable>>
   + actor_user_id : UUID
   + event_type : EventType
   + target_entity_type : String
   + target_entity_id : String
   + occurred_at : DateTime
   + details : JSON
   --
   + record()                <<sistema; inmutable per CNST-025>>
   + view()                  <<AUD-001>>
   + search()                <<AUD-002>>
   + export()                <<AUD-003>>
   + generate_compliance_report()  <<AUD-004>>
 }

 enum EventType {
   LOGIN
   LOGOUT
   ACCESS_CHANGE
   PERMISSION_GRANT
   PERMISSION_REVOKE
   EXPORT_REQUESTED
   ALERT_ACKNOWLEDGED
   ETL_RETRY
   SCHEDULE_MODIFIED
   CONFIG_CHANGED
 }

 AuditEvent -- EventType

 note right of AuditEvent
   CNST-025: append-only, inmutable.
   Sin UPDATE, sin DELETE.
   Toda operacion de escritura en el
   dominio emite uno o mas AuditEvent.
 end note

 @enduml

4.8 Logs
--------

Cinco clases: ``ApplicationLog``, ``ETLLog``, ``InfrastructureLog``,
``SystemHealth`` y ``TechnicalMetric``. Las dos ultimas no son logs
en sentido estricto (D-05): ``SystemHealth`` es un snapshot de
estado, ``TechnicalMetric`` es una agregacion. Viven en este
contexto por cohesion del modulo MOD_Logs y porque comparten la
politica de retencion CNST-024.

``TechnicalMetric`` es distinta de la clase ``Metric`` del contexto
Reports & Metrics: aquella mide infraestructura (response time,
throughput, error rate, CPU, memoria); esta mide negocio
(abandonment_rate, avg_wait_time, efficiency_index).

.. uml::
 :caption: Bounded context Logs — logs aplicativos, ETL e
           infraestructura, mas snapshot de salud y metricas
           tecnicas.

 @startuml
 !include ../_static/plantuml-styles.puml

 class ApplicationLog {
   + log_id : UUID
   + level : LogLevel
   + message : String
   + source_module : String
   + occurred_at : DateTime
   + user_id : UUID
   --
   + record()              <<sistema>>
   + view()                <<LOG-001 view_application_logs>>
   + search()              <<LOG-003 search_logs>>
   + export()              <<LOG-002 export_logs>>
 }

 class ETLLog {
   + log_id : UUID
   + execution_id : UUID
   + level : LogLevel
   + message : String
   + occurred_at : DateTime
   --
   + record()
   + view()                <<LOG-004 view_etl_logs>>
 }

 class InfrastructureLog {
   + log_id : UUID
   + host : String
   + level : LogLevel
   + message : String
   + occurred_at : DateTime
   --
   + record()
   + view()                <<LOG-005 view_infrastructure_logs>>
 }

 class SystemHealth {
   + snapshot_id : UUID
   + captured_at : DateTime
   + cpu_usage_pct : Double
   + memory_usage_pct : Double
   + disk_usage_pct : Double
   + services_status : Map<String,String>
   --
   + snapshot()           <<sistema>>
   + view()               <<LOG-006 view_system_health>>
 }

 class TechnicalMetric {
   + metric_id : UUID
   + name : TechMetricName
   + value : Double
   + sampled_at : DateTime
   + period : String
   --
   + aggregate()          <<sistema>>
   + view()               <<LOG-007 view_technical_metrics>>
 }

 enum LogLevel { TRACE DEBUG INFO WARN ERROR FATAL }

 enum TechMetricName {
   RESPONSE_TIME
   THROUGHPUT
   ERROR_RATE
   CPU
   MEMORY
 }

 ApplicationLog -- LogLevel
 ETLLog -- LogLevel
 InfrastructureLog -- LogLevel
 TechnicalMetric -- TechMetricName

 note right of SystemHealth
   D-05: NO es un log; snapshot
   efimero de estado. Retencion
   per CNST-024.
 end note

 note right of TechnicalMetric
   D-05: NO es un log; agregacion.
   Distinta de Metric (negocio) del
   contexto Reports & Metrics.
 end note

 note bottom of ApplicationLog
   CNST-024: retencion de logs.
 end note

 @enduml

----

5. Cobertura UC × clase
=======================

El WP que produjo este modelo verifico cobertura **bidireccional al
100 %**:

- **UC -> clase**: los 61 UCs vigentes en
  ``source/requisitos/casos-uso/`` operan sobre al menos una clase
  del modelo.
- **Clase -> UC**: las 25 clases del modelo aparecen como sujeto u
  objeto en al menos un UC.

La matriz detallada vive en el WP
``2026-05-01-02-01-06-domain-model-canonization/pilot/uc-vs-domain-validation.md``
con mapeo completo (cluster por cluster, categoria Z.2.A por UC,
funcion RBAC v5.4.0 por UC).

Resumen de actividad por clase:

.. list-table::
 :widths: 30 15 55
 :header-rows: 1

 * - Clase
   - UCs que la tocan
   - Comentario
 * - User
   - 17
   - Entidad central; aparece en Auth, USR, ACC, PERM, ALR
 * - Report
   - 14
   - Concentra los 15 UCs del cluster RPT
 * - AuditEvent
   - 10
   - Producida por toda escritura en el sistema
 * - Function
   - 9
   - Catalogo RBAC consumido transversalmente
 * - Assignment
   - 9
   - Vinculo User-Group / User-AccessGroup
 * - Call
   - 6 explicito
   - Fuente de datos para los 17 UCs RPT (lectura indirecta)
 * - Session
   - 5
   - Operada por AUTH y USR
 * - ETLExecution
   - 5
   - Cluster PIP completo + LOG-02 cross-context
 * - ExceptionalPermission, FunctionGroup, Alert
   - 4 c/u
   - Operaciones especificas con SoD via RBAC

----

6. Decisiones canonicas heredadas (D-01..D-11)
==============================================

Once decisiones del WP cerrado
``rbac-modelo-conceptual-cleanup`` (programa Z.2) son vinculantes
para este modelo. Resumen de su impacto sobre las clases:

.. list-table::
 :widths: 8 35 57
 :header-rows: 1

 * - ID
   - Decision Z.2
   - Impacto en este modelo
 * - D-01
   - Renames ``delete_*`` a ``deactivate_*`` / ``disable_*``;
     BR-009 alcance global
   - Toda clase con ciclo de vida tiene atributo ``state`` y
     operacion soft-delete; cero clases con ``delete``
 * - D-02
   - Agregar ``acknowledge_alert`` (ALR-007)
   - ``Alert`` tiene maquina de estados con transicion ACKNOWLEDGED
 * - D-03
   - Split de suscripcion en subscribe / unsubscribe /
     configure_severity
   - ``Subscription`` es entidad de primera clase con tres
     operaciones distintas
 * - D-04
   - Un solo UC con flujos alternativos para las tres operaciones
   - Capa de UC y capa RBAC son ortogonales
 * - D-05
   - Logs en application / etl / infrastructure + system_health +
     technical_metrics
   - 5 clases distintas en bounded context Logs; Health y
     TechnicalMetric NO son logs
 * - D-06
   - Auditoria SRP preventiva
   - Una sola responsabilidad por clase; particionado SRP aplicado
 * - D-07
   - Larman para UCs, SRP para funciones RBAC (capas ortogonales)
   - Las clases modelan conceptos de negocio; las funciones RBAC
     no son clases
 * - D-08
   - CNST-020 abstracto sin cuotas por formato
   - ``ExportJob`` cita CNST como nota; numeros viven en ADR
 * - D-09
   - Quota anti-abuse generica
   - ``ExportJob`` tiene atributos de recursos, no de formato
 * - D-10
   - Tres tipos de reporte como instancias de ``view_reports``
   - ``Report`` tiene atributo ``scope`` con siete valores; sin
     subclases
 * - D-11
   - BR-011 reescrita como regla de negocio
   - ``ExportJob`` referencia BR/CNST; sin numeros embebidos

----

7. Trazabilidad y referencias
=============================

7.1 WPs que produjeron este modelo
----------------------------------

- WP actual:
  ``.thyrox/context/work/2026-05-01-02-01-06-domain-model-canonization/``
  con seis analisis registrados (inventario de temp-holding,
  historia de elicitacion, riesgos historicos, criterios de
  calidad, fixes ya aplicados en WPs previos, estado canonico del
  programa Z) y los entregables de Stage 1 / 3 / 7 / 9.

7.2 WPs cerrados que aportaron decisiones canonicas
---------------------------------------------------

- ``2026-04-29-17-52-15-modelo-rbac-improvement`` (programa Z
  padre).
- ``2026-04-30-00-07-08-rbac-functions-count-audit`` (Z.1.C):
  conteo de funciones reconciliado, concepto Segmento descartado.
- ``2026-04-30-00-37-45-rbac-modelo-conceptual-cleanup`` (Z.2):
  bump del modelo RBAC a v5.4.0 con 61 funciones, decisiones
  D-01..D-11.
- ``2026-04-30-00-44-07-rbac-missing-ucs-discovery`` (Z.2.A):
  clasificacion de los 61 UCs en cinco categorias.
- ``2026-04-29-14-56-40-std007-rename-cleanup``: migracion de
  nomenclatura kebab-case en 315 archivos del corpus.

7.3 Documentos relacionados
---------------------------

- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` — modelo RBAC
  v5.4.0 con las 61 funciones que operan sobre las clases
  declaradas aqui.
- ``source/requisitos/_metodologia-aplicacion/analisis-dominio.rst``
  — guia metodologica del modelado del dominio. La cifra "97 UCs"
  citada en su § 11 debe corregirse a 61 (cifra vigente al cierre
  del WP que produjo este modelo, susceptible de evolucion en WPs
  posteriores).

----

8. Evolucion del modelo
=======================

Este es el **primer modelo de dominio canonico** del proyecto. Se
versionara con SemVer 2.0.0 a partir de v1.0.0:

- Bump **MAJOR** cuando se elimine o renombre una clase, o cambie
  un atributo identificador.
- Bump **MINOR** cuando se agregue una clase nueva, una operacion o
  un atributo.
- Bump **PATCH** para correcciones documentales sin cambios
  estructurales.

Cualquier cambio futuro al modelo debe verificar:

- Cobertura UC × clase 100 % (ningun UC sin clase, ninguna clase
  sin UC).
- Cumplimiento de las decisiones D-01..D-11 vigentes (o registro
  formal de su superseding).
- Build de Sphinx con 0 warnings y 0 errors antes de publicar.

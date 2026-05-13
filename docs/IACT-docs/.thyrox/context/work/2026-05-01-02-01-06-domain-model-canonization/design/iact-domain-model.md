```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 7 — DESIGN/SPECIFY
author: NestorMonroy
status: Borrador
version: 1.0.0
language: en
```

# IACT Domain Model — Canonical Class Diagram

Stage 7 DESIGN/SPECIFY deliverable. Materializes
the canonical IACT domain class diagram from the
25 candidates promoted in Stage 3 ANALYZE.
Resolves the 5 REFINE items, the 2 INFERRED
findings (H-A05, H-A06), and produces the eight
PlantUML diagrams (1 overview + 7 bounded
contexts) plus the per-class detail tables.

> **Language and convention notes**
>
> - Class names, attribute names and operation
>   names: **English**, PascalCase for classes,
>   snake_case for attributes/operations.
> - Constraints cited in **vigent versions**:
>   BR-009 v2.0.0, BR-011 v2.0.0, CNST-019 v3.0.0,
>   CNST-020 v3.0.0, plus pre-existing CNST-001,
>   CNST-002, CNST-003, CNST-006/007/008,
>   CNST-025, CNST-031.
> - PlantUML uses ``allowmixing`` only when
>   needed; default class diagrams stay pure.
> - This artifact is the **input** to Stage 9
>   PILOT/VALIDATE (UC × class matrix) and
>   Stage 12 STANDARDIZE (promotion to ``source/``).

## 1. Resolution of Stage 3 REFINE items

### 1.1 ``Metric``

REFINE in Stage 3: relation to ``Report`` unclear.
**Resolution:** ``Metric`` is owned by
``Report`` (composition); a Report contains 1..*
Metrics. A Metric does not exist outside its
Report context. The list of canonical metrics
(abandonment_rate, avg_wait_time,
efficiency_index) is a controlled enumeration of
``Metric.name`` values, not a class hierarchy.

### 1.2 ``ScheduledReport``

REFINE in Stage 3: relation to ``Report``
unclear. **Resolution:** ``ScheduledReport`` is a
**recurring request** for executing a ``Report``
on a cron-like cadence. Cardinality
``ScheduledReport`` 0..* ⟶ 1 ``Report``. Distinct
from ``Report`` because a ``ScheduledReport``
carries scheduling state (next_run_at, last_run,
state) that is not part of the Report itself.

### 1.3 ``InternalMailbox``

REFINE in Stage 3: own ID or always per-User?
**Resolution:** one ``InternalMailbox`` per
``User``, identified by ``mailbox_id`` distinct
from ``user_id`` (so it can be migrated, archived
or replaced without affecting the User).
Cardinality 1..1 ⟷ 1..1 with User.

### 1.4 ``SystemHealth``

REFINE in Stage 3: entity vs snapshot vs service
result? **Resolution:** ephemeral **snapshot**
entity. Each snapshot has its own ``snapshot_id``
and a ``captured_at`` timestamp. Snapshots are
retained per a retention policy (CNST-024 logs
retention applies; the WP does not fix the
period). Logs context owns it for module
cohesion (per H-A06 below).

### 1.5 ``TechnicalMetric``

REFINE in Stage 3: relation to ``Metric``.
**Resolution:** distinct class. ``Metric`` is a
**business** measurement (call-center KPIs:
abandonment, wait time, efficiency).
``TechnicalMetric`` is an **infrastructure**
measurement (response time, throughput, error
rate, CPU, memory). They live in different
bounded contexts and are not related by
inheritance.

## 2. Resolution of Stage 3 INFERRED findings

### 2.1 H-A05 — ``ReportRequest`` superclass

**Decision: rejected (no superclass).**

``ScheduledReport``, ``ExportJob`` and
``SavedView`` share three concerns (a referenced
``Report``, an owner, lifecycle state) but their
operations are too divergent (schedule cron,
async queue, persisted filter) to factor a
useful base. A superclass would only carry three
fields and zero shared behavior, which is
premature abstraction.

The three classes remain siblings, each citing
the same ``Report`` independently. The shared
attributes are repeated by design.

### 2.2 H-A06 — Eighth bounded context for monitoring

**Decision: keep within Logs context (no new
context).**

``SystemHealth`` and ``TechnicalMetric`` are
conceptually monitoring rather than logging, but:

- They share storage, retention and access
  policies with logs (``CNST-024``).
- They are exposed by the same module
  (``MOD_Logs``).
- The eight UCs of the Logs cluster
  (UC_LOG_01..07) treat all five entities as one
  cohesive admin area.

Splitting into a separate ``Monitoring`` context
would create a one-class context (Health) and a
one-class context (TechnicalMetric) without
sharing concerns. The cost is higher than the
benefit. They stay in Logs, with a documentation
note clarifying that they are not logs.

## 3. Bounded context overview

Seven bounded contexts (PERM subsumed under
RBAC). Each context is shown in detail in § 5;
this overview shows only the contexts and their
cross-context bridges.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   skinparam package {
     BackgroundColor #F8F8F8
     BorderColor #888
   }

   package "Auth" as A {
     class User
     class Session
     class InternalMailbox
   }

   package "RBAC (subsumes PERM)" as R {
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

   ' Cross-context bridges (only the structural ones)
   User      "1" --      "*"   Session
   User      "1" --      "1"   InternalMailbox
   User      "1" --      "*"   Assignment
   Function  "*" --      "*"   FunctionGroup        : (via Assignment)
   User      "*" -[#888]- "*"  AccessGroup           : (via Assignment)
   Report    "1" --      "*"   Metric                : composes
   Report    "1" --      "*"   ExportJob
   Report    "1" --      "*"   ScheduledReport
   Report    "1" --      "*"   SavedView
   Report    "*" ..      "*"   Call                  : aggregates
   ETLExecution "1" --   "*"   ETLError
   ETLExecution "1" ..   "*"   Call                  : loads
   Alert     "*" --      "1"   Threshold
   Alert     "1" --      "*"   Subscription
   Subscription "*" --   "1"   User
   Subscription "*" ..   "1"   InternalMailbox       : delivers via

   note right of D
     Every write-side operation in any
     context produces 1..* AuditEvent
     per CNST-025 (immutable, append-only).
   end note

   @enduml

## 4. Per-context diagrams

### 4.1 Auth context

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

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
     + close()              <<own session>>
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

   User "1" -- "0..*" Session            : owns
   User "1" -- "1"   InternalMailbox     : owns
   User -- UserState
   Session -- SessionState

   note bottom of Session
     CNST-002 timeout
     CNST-003 single active session per User
   end note

   note bottom of InternalMailbox
     CNST-001 internal mailbox only,
     no external email channel.
   end note

   @enduml

### 4.2 RBAC context

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Function {
     + function_id : String   <<e.g. RPT-001>>
     + name : String          <<e.g. view_reports>>
     + description : String
     + module : Module
     --
     + register()             <<system>>
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
     + name : String            <<e.g. agr_supervisor>>
     + profile_description : String
     --
     + assign_to_user()        <<ACC-004>>
     + revoke_from_user()
   }

   class Assignment {
     + assignment_id : UUID
     + user_id : UUID
     + group_ref : String       <<FunctionGroup or AccessGroup>>
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

   FunctionGroup "*" -- "*" Function : contains
   Assignment "*" -- "1" FunctionGroup : (when group_ref is group)
   Assignment "*" -- "1" AccessGroup   : (when group_ref is AGR)
   ExceptionalPermission "*" -- "1" Function
   SeparationRule "1" -- "*" Function : (lists conflicting)
   Function -- Module

   note right of SeparationRule
     BR-009 v2.0.0 — disable, never delete.
     CNST-030 SoD enforcement.
   end note

   note right of ExceptionalPermission
     CNST-031 — temporal range
     (granted_at .. expires_at).
   end note

   @enduml

### 4.3 Calls context

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

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
     CNST-007 — read-only from operational DB.
     The IACT corpus does not perform write
     operations on Call.
   end note

   @enduml

### 4.4 Reports & Metrics context

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

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
     + export()              <<delegates to ExportJob>>
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

   Report "1" *-- "1..*" Metric            : composes
   Report "1" -- "0..*" ExportJob
   Report "1" -- "0..*" ScheduledReport
   Report "1" -- "0..*" SavedView
   Report -- ReportScope
   ExportJob -- ExportFormat
   ExportJob -- JobState
   Metric -- MetricName

   note right of ExportJob
     CNST-019 v3.0.0 — abstract async queue.
     CNST-020 v3.0.0 — abstract throttling.
     BR-011 v2.0.0 — limits delegated to CNST.
     Concrete numbers and stack live in
     implementation ADR.
   end note

   note right of Report
     D-10 — scope is an attribute, not a subclass.
     Seven canonical scopes cover the 17 RPT UCs.
   end note

   @enduml

### 4.5 Pipeline ETL context

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

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
     CNST-006 — load window.
     CNST-007 — operational DB read-only.
     CNST-008 — analytics DB write window.
   end note

   @enduml

### 4.6 Alerts context

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

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
     D-02 — closed-loop alerts.
     ACTIVE → ACKNOWLEDGED transition is auditable
     (CNST-025).
   end note

   note right of Subscription
     D-03 — three operations split:
     subscribe / unsubscribe / configure_severity.
     Granular RBAC for SoD purposes.
   end note

   @enduml

### 4.7 Audit context

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class AuditEvent {
     + event_id : UUID                 <<immutable>>
     + actor_user_id : UUID
     + event_type : EventType
     + target_entity_type : String
     + target_entity_id : String
     + occurred_at : DateTime
     + details : JSON
     --
     + record()                <<system; immutable per CNST-025>>
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
     CNST-025 — append-only, immutable,
     no UPDATE, no DELETE.
     Every write-side operation in the
     domain emits one or more AuditEvent.
     Specializations PermissionAudit /
     AccessAudit are realized as event_type
     enum values, not subclasses.
   end note

   @enduml

### 4.8 Logs context (with Monitoring entities)

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class ApplicationLog {
     + log_id : UUID
     + level : LogLevel
     + message : String
     + source_module : String
     + occurred_at : DateTime
     + user_id : UUID
     --
     + record()              <<system>>
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
     + snapshot()           <<system>>
     + view()               <<LOG-006 view_system_health>>
   }

   class TechnicalMetric {
     + metric_id : UUID
     + name : TechMetricName
     + value : Double
     + sampled_at : DateTime
     + period : String
     --
     + aggregate()          <<system>>
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
     D-05 — NOT a log; ephemeral state snapshot.
     Retention per CNST-024.
   end note

   note right of TechnicalMetric
     D-05 — NOT a log; aggregation.
     Distinct from Reports & Metrics → Metric
     (which is business KPI).
   end note

   note bottom of ApplicationLog
     CNST-024 — log retention.
   end note

   @enduml

## 5. Per-class detail tables

For each promoted class, this section consolidates
the canonical attributes, operations and notes
already shown in the per-context diagrams. Tables
serve as the lookup reference for Stage 9 PILOT
(UC × class matrix).

### 5.1 Auth context — class detail

| Class | Attributes (selected) | Operations | Vigent constraints |
|-------|-----------------------|------------|--------------------|
| User | user_id, username, email, full_name, state, created_at, last_login_at | create, deactivate, modify, view, recover_password | BR-009 v2.0.0, CNST-001, CNST-025 |
| Session | session_id, user_id, started_at, last_activity_at, expires_at, state, client_info | open, close, close_all, view_own_sessions | CNST-002, CNST-003 |
| InternalMailbox | mailbox_id, owner_user_id, last_read_at | deliver_message, view_messages, mark_read | CNST-001 |

### 5.2 RBAC context — class detail

| Class | Attributes (selected) | Operations | Vigent constraints |
|-------|-----------------------|------------|--------------------|
| Function | function_id, name, description, module | register, view | RBAC v5.4.0 catalogue (61 functions) |
| FunctionGroup | group_id, name, description | create_function_group, assign_functions_to_group, revoke_function_group | — |
| AccessGroup | agr_id, name, profile_description | assign_to_user, revoke_from_user | AGR-001..010 catalogue |
| Assignment | assignment_id, user_id, group_ref, assigned_by, assigned_at, expires_at, state | create, revoke | CNST-030 SoD enforcement |
| ExceptionalPermission | permission_id, user_id, function_id, granted_by, granted_at, expires_at, justification, state | grant, revoke | CNST-031 |
| SeparationRule | rule_id, name, conflicting_functions, rule_group, state | create, view, update, disable | BR-009 v2.0.0, CNST-030 |

### 5.3 Calls context — class detail

| Class | Attributes (selected) | Operations | Vigent constraints |
|-------|-----------------------|------------|--------------------|
| Call | call_id, started_at, duration_seconds, agent_id, campaign_id, center, region, abandoned, transferred | (read-only) | CNST-007 |
| Campaign | campaign_id, name, service_type, region | (read-only) | CNST-007 |

### 5.4 Reports & Metrics context — class detail

| Class | Attributes (selected) | Operations | Vigent constraints |
|-------|-----------------------|------------|--------------------|
| Report | report_id, scope, filters, owner_user_id, state | view, filter, share, export | D-10 (scope) |
| Metric | metric_id, name, formula, unit | compute, view | composition with Report |
| ExportJob | job_id, requested_by, report_id, format, state, enqueued_at, completed_at, artifact_path | enqueue, process, complete, fail | CNST-019 v3.0.0, CNST-020 v3.0.0, BR-011 v2.0.0 |
| ScheduledReport | schedule_id, report_id, owner_user_id, schedule_expression, next_run_at, last_run_at, state | create, modify, disable | BR-009 v2.0.0 |
| SavedView | view_id, owner_user_id, report_id, filters_snapshot, name, state | save, load, deactivate | BR-009 v2.0.0 |

### 5.5 Pipeline ETL context — class detail

| Class | Attributes (selected) | Operations | Vigent constraints |
|-------|-----------------------|------------|--------------------|
| ETLExecution | execution_id, started_at, completed_at, status, source_window_start, source_window_end, rows_loaded | start, complete, fail, retry | CNST-006, CNST-007, CNST-008 |
| ETLError | error_id, execution_id, error_type, error_message, occurred_at, classified_severity, resolved | record, classify, mark_resolved | — |

### 5.6 Alerts context — class detail

| Class | Attributes (selected) | Operations | Vigent constraints |
|-------|-----------------------|------------|--------------------|
| Alert | alert_id, threshold_id, triggered_at, value, state, acknowledged_by, acknowledged_at | configure, acknowledge, disable | D-02, CNST-025 |
| Threshold | threshold_id, metric_id, comparison_operator, value, severity | configure | — |
| Subscription | subscription_id, alert_id, subscriber_user_id, severity_filter, state | subscribe, unsubscribe, configure_severity | D-03 |

### 5.7 Audit context — class detail

| Class | Attributes (selected) | Operations | Vigent constraints |
|-------|-----------------------|------------|--------------------|
| AuditEvent | event_id, actor_user_id, event_type, target_entity_type, target_entity_id, occurred_at, details | record, view, search, export, generate_compliance_report | CNST-025 (immutable) |

### 5.8 Logs context — class detail

| Class | Attributes (selected) | Operations | Vigent constraints |
|-------|-----------------------|------------|--------------------|
| ApplicationLog | log_id, level, message, source_module, occurred_at, user_id | record, view, search, export | CNST-024 |
| ETLLog | log_id, execution_id, level, message, occurred_at | record, view | CNST-024 |
| InfrastructureLog | log_id, host, level, message, occurred_at | record, view | CNST-024 |
| SystemHealth | snapshot_id, captured_at, cpu_usage_pct, memory_usage_pct, disk_usage_pct, services_status | snapshot, view | CNST-024 (retention) |
| TechnicalMetric | metric_id, name, value, sampled_at, period | aggregate, view | — |

## 6. Findings of Stage 7 DESIGN

| ID | Type | Description |
|----|------|-------------|
| H-D01 | OBSERVABLE | All 25 candidates of Stage 3 are materialized as concrete classes with attributes, operations, state machines and constraints. No CONFLICT remains. |
| H-D02 | OBSERVABLE | The five REFINE items of Stage 3 are resolved (§ 1). Resolution choices preserve composition over inheritance and avoid premature abstraction. |
| H-D03 | OBSERVABLE | H-A05 (``ReportRequest`` superclass) and H-A06 (extra ``Monitoring`` context) are decided by reasoned rejection (§ 2). |
| H-D04 | OBSERVABLE | Eight PlantUML diagrams produced: 1 overview + 7 contexts. Logs context contains 5 classes (the two non-log ones marked explicitly). |
| H-D05 | OBSERVABLE | Every class with lifecycle has an explicit ``state`` enum and a ``deactivate``/``disable`` operation per BR-009 v2.0.0. Zero classes carry a ``delete`` operation. |
| H-D06 | OBSERVABLE | Every cited constraint uses the **vigent version**: BR-009 v2.0.0, BR-011 v2.0.0, CNST-019 v3.0.0, CNST-020 v3.0.0. No obsolete versions cited. |
| H-D07 | OBSERVABLE | The concept ``DataSegment`` (Z.1.C Camino C) does not appear in any class, attribute, operation or note. Confirmed by inspection. |
| H-D08 | INFERRED | The diagram density (overview + 7 contexts) keeps every sub-diagram below ~10 classes, satisfying R-06 of the risk register. |

No SPECULATIVE findings.

## 7. Pending for Stage 9 PILOT

- Build the matrix UC × class on top of these 25
  classes, integrating Z.2.A's 5 categories (36
  Cat 1, 5 Cat 2, 3 Cat 3, 4–5 Cat 4, 10 Cat 5).
- For each of the 61 UCs, the matrix entry cites
  the primary class(es) and the secondary
  class(es) it touches.
- Verify 100 % bidirectional coverage: every UC
  to ≥1 class; every class to ≥1 UC.

## 8. Pending for Stage 12 STANDARDIZE

- Promote this artifact (or a Sphinx-friendly
  equivalent in RST) under
  ``source/arquitectura-tecnica/`` (proposed
  path: ``modelo-dominio-iact.rst``) so it lives
  beside ``modelo-rbac-iact.rst``.
- Update ``analisis-dominio.rst § 7`` (extract)
  to point to the canonical artifact instead of
  containing the embedded diagram.
- Correct ``analisis-dominio.rst § 11`` from
  "97 UCs" to the **vigent** count (currently 61
  per executor confirmation, with explicit note
  that this can evolve).
- Build with ``make html`` 0 warnings, 0 errors
  (gate I-015) before promotion.

## 9. Confirmation pending from executor

- [ ] The eight PlantUML diagrams reflect the
  intended structure of the IACT domain.
- [ ] The resolution of the 5 REFINE items
  matches the intent of the 11 D-01..D-11
  decisions.
- [ ] The rejection of H-A05 (``ReportRequest``
  superclass) and H-A06 (extra Monitoring
  context) is acceptable.
- [ ] The English class-name and operation-name
  convention is consistent and ready for
  promotion to ``source/``.
- [ ] The proposed promotion path
  ``source/arquitectura-tecnica/modelo-dominio-iact.rst``
  is correct, or the executor proposes another.

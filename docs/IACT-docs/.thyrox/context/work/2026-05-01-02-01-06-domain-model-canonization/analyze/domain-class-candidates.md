```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
language: en
```

# Domain Class Candidates — IACT

Stage 3 ANALYZE deliverable. Identifies the
candidate classes for the canonical IACT domain
model by harvesting nouns from the vigent corpus,
applying the Abbott filter, and verifying each
candidate against IEEE 830 quality criteria.
Imports the eleven decisions D-01..D-11 of the
closed WP Z.2 as binding precedent.

> **Language note (executor decision 2026-05-01):**
> class names, attribute names and operation names
> are written in **English** for consistency with
> the RBAC model v5.4.0 (already English) and with
> NOM_001 § 2.3 (formal identifiers in English).
> Prose of this analysis is also written in English.

## 1. Method

### 1.1 Sources consulted

Vigent corpus only — no historical material from
``temp-holding/`` is treated as authoritative:

- ``source/arquitectura-tecnica/rbac/modelo-rbac-iact.rst``
  v5.4.0 (61 RBAC functions across 8 modules).
- ``source/requisitos/casos-uso/`` (61 use cases
  across 9 clusters).
- ``source/requisitos/business-requirements/``
  (vigent BRs, including BR-009 v2.0.0,
  BR-011 v2.0.0).
- ``source/normativa/restricciones/`` (vigent
  CNSTs, including CNST-019 v3.0.0,
  CNST-020 v3.0.0).
- ``source/requisitos/_metodologia-aplicacion/analisis-dominio.rst``
  § 3.1 (noun list) and § 12 (Abbott method) — used
  as **methodological reference**, not as a
  canonical source for class identity.
- Z.2 ``analyze/srp-audit/decisions-log.md``
  (11 decisions D-01..D-11) — imported as
  binding.

### 1.2 Abbott filter

A noun is promoted to a class only if it satisfies
the three Abbott criteria:

1. **Persistent identity**: the concept survives
   beyond a single operation; it has an identifier
   that persists in storage.
2. **Business operations**: the concept is the
   subject or direct object of at least one
   business action declared in a UC, BR or RBAC
   function.
3. **Independent meaning**: the concept is
   meaningful without its container; it is not
   merely a property of another concept.

Nouns that fail the filter are catalogued as
attributes, events, value objects, or
relationships, not as classes.

### 1.3 IEEE 830 quality criteria per candidate

Each candidate is checked against:

- **Completeness** — has at least one declared
  attribute and one declared operation.
- **Consistency** — does not contradict another
  candidate or a vigent decision (D-01..D-11,
  Z.2.A categories).
- **Unambiguity** — has a single canonical name
  and definition; not a synonym of another
  candidate.
- **Verifiability** — appears in at least one UC
  flow as subject or object.
- **Traceability** — links to ≥1 UC, ≥1 RBAC
  function or ≥1 BR/CNST.

A candidate that fails any criterion is either
rejected, refined, or marked PENDING for Stage 7
DESIGN clarification.

### 1.4 Imported decisions (D-01..D-11)

The eleven Z.2 decisions are imported as binding
precedent for naming, responsibility allocation
and scope of operations. Summary in this WP's
language (English):

| ID | Z.2 decision | Implication for class model |
|----|--------------|------------------------------|
| D-01 | Renames ``delete_*`` → ``deactivate_*``/``disable_*``; BR-009 global "no delete" | Every entity with lifecycle has an explicit ``state`` attribute and soft-delete operations only |
| D-02 | Add ``acknowledge_alert`` (ALR-007) | ``Alert`` has a state machine including ACKNOWLEDGED transition |
| D-03 | Subscription split into subscribe / unsubscribe / configure_severity | ``Subscription`` is a first-class entity, not a field on ``Alert`` |
| D-04 | One UC with alternative flows for the three subscription operations | Layer separation: business UC ≠ RBAC granularity |
| D-05 | Logs split into application / etl / infrastructure + system_health + technical_metrics | Logs are heterogeneous; ``SystemHealth`` and ``TechnicalMetric`` are NOT log entities |
| D-06 | Preventive SRP audit philosophy | One responsibility per class; if a class accumulates > 3-5 responsibilities, split it |
| D-07 | Larman applies to business UCs; SRP applies to RBAC functions (orthogonal layers) | Class diagram models business concepts; RBAC functions are not classes |
| D-08 | CNST-020 abstract throttling (no per-format quotas) | ``ExportJob`` cites CNST constraints; numbers live in implementation ADR |
| D-09 | Generic anti-abuse quota (concurrent jobs / daily total, no per-format) | ``ExportJob`` has resource attributes (concurrent count, daily count), not format-specific quota |
| D-10 | Three new report types (uc-rpt-15/16/17) as instances of ``view_reports`` | ``Report`` has a ``scope`` attribute (transferences, ivr_menus, unique_clients...); not subclasses |
| D-11 | BR-011 rewritten as business rule (delegates to CNST) | ``ExportJob`` references BR/CNST as notes, not embedded numbers |

## 2. Noun harvest from vigent corpus

### 2.1 Harvested nouns (English equivalents)

Source: cross-check between vigent UCs (61),
RBAC v5.4.0 functions (61), and
``analisis-dominio.rst`` § 3.1 (Spanish source
list translated). Language convention: domain
class names in PascalCase English.

Auth & access:

- User, Operator, Supervisor, Administrator,
  Auditor (the last four are roles → not
  classes; see § 3.2).
- Session
- ~~DataSegment~~ — REJECTED. Discarded by Z.1.C
  Camino C; the concept does not appear in vigent
  source/.
- Function (RBAC function definition)
- FunctionGroup
- AccessGroup (AGR-001..010, "agrupador" in
  Spanish)
- Assignment (User-Group association)
- ExceptionalPermission (granted/revoked
  individually)
- SeparationRule (SoD rule)

Calls / IVR:

- Call
- Center
- Campaign
- Service
- Region

Reports & metrics:

- Report
- Dashboard
- Metric
- Filter
- View (saved view per uc-rpt-10)
- Schedule (per ALR-007 via uc-rpt-07
  ``schedule_report`` per Z.2.A § Cat 3)
- ExportJob (per CNST-019/020 v3.0.0)

Pipeline ETL:

- ETLExecution
- ETLError
- LoadedRow
- Scheduler (process, may be infrastructure not
  domain — verify in § 3)

Alerts & notifications:

- Alert
- Threshold
- Subscription
- InternalMailbox
- Message

Audit:

- AuditEvent (canonical, per CNST-025 immutable)
- PermissionAudit / AccessAudit (specializations
  of AuditEvent — verify need)

Logs (per D-05):

- ApplicationLog (LOG-001)
- ETLLog (LOG-004)
- InfrastructureLog (LOG-005)
- SystemHealth (LOG-006) — NOT a log per D-05
- TechnicalMetric (LOG-007) — NOT a log per D-05

### 2.2 Translation table — Spanish corpus → English class

When a class name needs to migrate from the
Spanish noun harvested in
``analisis-dominio.rst`` § 3.1 to the English
canonical name of this analysis:

| Spanish (corpus / analisis-dominio) | English (canonical class) | Rationale |
|-------------------------------------|---------------------------|-----------|
| Usuario | User | Direct cognate; consistent with USR-* RBAC functions |
| Sesion | Session | Direct cognate; consistent with AUTH-001 ``view_own_sessions`` |
| Funcion | Function | Direct cognate; consistent with the RBAC ``functions`` table name |
| Grupo | FunctionGroup | Disambiguation: "Grupo" is overloaded; English distinguishes ``FunctionGroup`` (RBAC) from ``AccessGroup`` (AGR) |
| PermisoExcepcional | ExceptionalPermission | Direct translation; consistent with ACC-008/009 |
| SegmentoDatos | (REJECTED — Z.1.C Camino C) | Concept eliminated |
| Llamada | Call | Direct cognate |
| Centro | Center | Direct cognate |
| Campaña | Campaign | Direct cognate |
| Servicio | Service | Direct cognate |
| Region | Region | Same word |
| Reporte | Report | Direct cognate |
| Metrica | Metric | Direct cognate |
| Filtro | Filter | Direct cognate |
| Dashboard | Dashboard | English already in Spanish source |
| EjecucionETL | ETLExecution | PascalCase; direct translation |
| ErrorETL | ETLError | PascalCase; direct translation |
| FilaCargada | LoadedRow | Direct translation |
| Scheduler | Scheduler | English already |
| Alerta | Alert | Direct cognate |
| Umbral | Threshold | Direct translation |
| Suscripcion | Subscription | Direct cognate |
| BuzonInterno | InternalMailbox | Translated; consistent with CNST-001 |
| Mensaje | Message | Direct cognate |
| EventoAuditoria | AuditEvent | PascalCase translation |

## 3. Abbott filter applied

### 3.1 Promoted to class (passes the filter)

Each row passes the three Abbott criteria. The
"Operations" column lists at least one operation;
the "Source" column lists the UC or function
that justifies the class.

| Class | Persistent ID | Operations (sample) | Source (vigent) |
|-------|---------------|---------------------|-----------------|
| User | ``user_id`` | create, deactivate, modify, view | UC_USR_01..04, USR-001..009 |
| Session | ``session_id`` | open, close, view | UC_AUTH_01..05, AUTH-001..004 |
| Function | ``function_id`` (e.g. ``RPT-001``) | view, assign, revoke | UC_ACC_01..05, modelo-rbac v5.4.0 |
| FunctionGroup | ``group_id`` | create, assign_functions, view | UC_PERM_05/06, ACC-006/007 |
| AccessGroup | ``agr_id`` (e.g. ``AGR-001``) | assign_to_user, revoke_from_user | UC_ACC_04, ACC-004 |
| ExceptionalPermission | ``permission_id`` | grant, revoke, expire | UC_PERM_03/04, ACC-008/009 |
| SeparationRule | ``rule_id`` | create, view, update, disable (D-01) | UC_ACC_05, ACC-005/011/012 |
| Call | ``call_id`` | (read-only from operational DB) | RPT-001..017 cite Call as data source |
| Report | ``report_id`` + ``scope`` (D-10) | view, filter, export, share, schedule, save_view | UC_RPT_01..17, RPT-001..008 |
| Metric | ``metric_id`` | compute, view | UC_RPT_02, BR rules cite metrics |
| ExportJob | ``job_id`` | enqueue, process, complete, fail | UC_RPT_04 (Larman consolidated), CNST-019/020 v3.0.0 |
| ScheduledReport | ``schedule_id`` | create, modify, disable | uc-rpt-07-programar-reporte, RPT-009 (restored per Z.2.A § Cat 3) |
| SavedView | ``view_id`` | save, load, delete (deactivate per D-01) | uc-rpt-10-guardar-vista, RPT-010 (new per Z.2.A § Cat 3) |
| ETLExecution | ``execution_id`` + ``status`` (per D-01) | start, complete, fail, retry | UC_PIP_01..04, PIP-001..004 |
| ETLError | ``error_id`` | record, classify, mark_resolved | UC_PIP_02 |
| Alert | ``alert_id`` + ``state`` (per D-02) | configure, acknowledge (D-02), disable (D-01) | UC_ALR_01..04, ALR-001..010 |
| Threshold | ``threshold_id`` | configure, evaluate | UC_ALR_01, ALR-002 |
| Subscription | ``subscription_id`` | subscribe (D-03), unsubscribe (D-03), configure_severity (D-03) | UC_ALR_05, ALR-008/009/010 |
| InternalMailbox | (per User) | deliver, view | UC_AUTH_03, CNST-001 |
| AuditEvent | ``event_id`` | record (immutable per CNST-025), view, export | UC_AUD_01..04, AUD-001..004 |
| ApplicationLog | ``log_id`` + ``level`` | record, view, search, export | uc-log-01, LOG-001 (renamed per D-05) |
| ETLLog | ``log_id`` | record, view | uc-log-02, LOG-004 (per D-05) |
| InfrastructureLog | ``log_id`` | record, view | uc-log-05, LOG-005 (per D-05) |
| SystemHealth | (snapshot, per timestamp) | snapshot, view | uc-log-06, LOG-006 (per D-05; NOT a log, is state) |
| TechnicalMetric | ``metric_id`` | aggregate, view | uc-log-07, LOG-007 (per D-05; NOT a log, is aggregation) |

**Class count after Abbott filter: 25 candidates.**

### 3.2 Rejected — promoted to attribute, role, value object, or event

| Noun | Filter outcome | Where it lives |
|------|----------------|----------------|
| Operator, Supervisor, Administrator, Auditor | **Role** (specialization of User by AccessGroup membership) | Modelled as a User-AccessGroup association, not as separate classes |
| ~~DataSegment~~ | **Discarded concept** (Z.1.C Camino C) | Removed entirely |
| AbandonmentRate, AvgWaitTime, EfficiencyIndex | **Attribute / metric instance** | Members or values of ``Metric`` |
| Filter | **Value object** | Configuration on ``Report`` (filters list) |
| Dashboard | **View / aggregate** | Specialization of ``Report`` (kind=dashboard) — verify in § 5 |
| LoadedRow | **Operational data** (transient) | Belongs to ``Call`` semantics, not a separate class |
| Message | **Value object** | Body of an ``InternalMailbox`` delivery |
| PermissionAudit, AccessAudit | **Specialization of AuditEvent** by ``event_type`` | Modelled as ``AuditEvent.event_type`` attribute, not subclasses |
| Scheduler | **Infrastructure component** | Not a domain class; belongs to deployment view (ADR-DEVOPS-001) |
| Service | **Specialization of Campaign or attribute** | Verify in § 5 — pending |
| Center | **Reference data** | Read-only attribute on ``Call`` |

### 3.3 PENDING for Stage 7 DESIGN

| Noun | Reason for pending |
|------|--------------------|
| Service | Insufficient operations cited in vigent UCs; could be a Campaign attribute or a separate class. Decide when modelling Calls in detail. |
| Dashboard | Probably a specialized ``Report`` view; pending whether it merits its own class or is a kind/category of Report. |
| Region | Reference data with no operations in vigent UCs. Probably attribute on ``Call`` / ``Campaign``. |

## 4. IEEE 830 quality check per promoted class

For each of the 25 promoted classes, the four
key IEEE 830 criteria are evaluated. Verifiability
and traceability are inherited from § 3.1's
"Source" column (each class has at least one UC
and one RBAC function citing it). The matrix
below reports Completeness, Consistency,
Unambiguity per class.

Status legend: **OK** = all four criteria pass;
**REFINE** = at least one criterion needs
clarification in Stage 7 DESIGN; **CONFLICT** =
contradiction with a vigent decision (must be
resolved before Stage 7).

| Class | Compl. | Consist. | Unambig. | Status |
|-------|:------:|:--------:|:--------:|:------:|
| User | OK | OK | OK | OK |
| Session | OK | OK | OK | OK |
| Function | OK | OK | OK | OK |
| FunctionGroup | OK | OK | OK | OK |
| AccessGroup | OK | OK | OK | OK |
| ExceptionalPermission | OK | OK | OK | OK |
| SeparationRule | OK | OK (D-01 split into 4 ops) | OK | OK |
| Call | OK | OK | OK | OK |
| Report | OK | OK (scope per D-10) | OK | OK |
| Metric | OK | OK | refine | REFINE — relation to ``Report`` (1:* via scope?) needs clarification |
| ExportJob | OK | OK (CNST-019/020 v3.0.0) | OK | OK |
| ScheduledReport | OK | OK (RPT-009 restored) | refine | REFINE — relation to ``Report`` (Schedule of what?) |
| SavedView | OK | OK | OK | OK |
| ETLExecution | OK | OK (state per D-01) | OK | OK |
| ETLError | OK | OK | OK | OK |
| Alert | OK | OK (state machine per D-02) | OK | OK |
| Threshold | OK | OK | OK | OK |
| Subscription | OK | OK (split per D-03) | OK | OK |
| InternalMailbox | refine | OK | OK | REFINE — does it have its own ID or is it always per-User? |
| AuditEvent | OK | OK (immutable CNST-025) | OK | OK |
| ApplicationLog | OK | OK (D-05 rename) | OK | OK |
| ETLLog | OK | OK (D-05 split) | OK | OK |
| InfrastructureLog | OK | OK (D-05 new) | OK | OK |
| SystemHealth | refine | OK (D-05 not a log) | OK | REFINE — entity vs snapshot vs service result |
| TechnicalMetric | refine | OK (D-05 aggregate) | refine | REFINE — relation to ``Metric``: same? subtype? distinct? |

**Result:** 20 of 25 candidates fully pass IEEE
830 (OK). 5 are REFINE — to clarify in Stage 7
DESIGN. 0 CONFLICT.

## 5. Bounded contexts

The seven bounded contexts derived from the nine
UC clusters (PERM is subsumed under RBAC per
Z.2.A § Cat 5). Each class assigned to exactly
one context. Cross-context relationships are
listed at the end.

### 5.1 Auth context

Classes: ``User``, ``Session``,
``InternalMailbox``.

Notes: ``User`` is the central entity.
``InternalMailbox`` lives here because CNST-001
is an Auth-side restriction (mailbox = user
notification channel for password recovery,
export readiness, etc.). Cross-context use of
``InternalMailbox`` is via reference, not
ownership.

### 5.2 RBAC context (subsumes PERM)

Classes: ``Function``, ``FunctionGroup``,
``AccessGroup``, ``Assignment`` (User-Group
relation), ``ExceptionalPermission``,
``SeparationRule``.

Notes: 10 PERM UCs are technical views over the
classes here. Per ADR-GOB-008 the RBAC bounded
context is the canonical one; PERM is a view
exposed to the user-level perspective.

### 5.3 Calls context

Classes: ``Call``, ``Campaign`` (and pending
``Service``, ``Center``, ``Region``).

Notes: Read-only data sourced from operational
DB (CNST-007). The classes here have no
write-side business operations in vigent UCs.

### 5.4 Reports & metrics context

Classes: ``Report``, ``Metric``, ``Filter``
(value object on Report), ``ExportJob``,
``ScheduledReport``, ``SavedView``.

Notes: ``Report`` carries a ``scope`` attribute
per D-10 (one of: ``transferences``,
``ivr_menus``, ``unique_clients``, ``general``,
...). The 17 RPT UCs map to operations on these
classes, not to subclasses.

### 5.5 Pipeline ETL context

Classes: ``ETLExecution``, ``ETLError``.

Notes: ``LoadedRow`` is operational data (rejected
in § 3.2). ``Scheduler`` is infrastructure
(rejected). The vigent ETL operations
(supervise, view errors, check availability,
retry) operate on these two classes.

### 5.6 Alerts context

Classes: ``Alert``, ``Threshold``,
``Subscription``.

Notes: ``Alert`` has the state machine introduced
by D-02 (ACTIVE → ACKNOWLEDGED). ``Subscription``
is first-class per D-03/D-04. Notification
delivery references ``InternalMailbox`` from the
Auth context.

### 5.7 Audit context

Classes: ``AuditEvent``.

Notes: Append-only, immutable per CNST-025. The
historical specializations ``PermissionAudit``
and ``AccessAudit`` are modelled as
``AuditEvent.event_type`` enum values, not
subclasses (per § 3.2).

### 5.8 Logs context

Classes: ``ApplicationLog``, ``ETLLog``,
``InfrastructureLog``, ``SystemHealth``,
``TechnicalMetric``.

Notes: D-05 separated logs by type. The last two
are NOT logs (state and aggregation respectively)
but live in this context for module cohesion
(MOD_Logs).

### 5.9 Cross-context relationships (preview)

For Stage 7 DESIGN to elaborate. Provisional list:

- ``Session`` ⟶ ``User`` (1..1 ownership).
- ``Assignment`` ⟶ ``User``, ``FunctionGroup``,
  ``AccessGroup``.
- ``Report`` ⟶ ``Metric`` (1..*, contains).
- ``Report`` ⟶ ``Call`` (*..*, aggregates from
  operational data).
- ``ExportJob`` ⟶ ``Report`` (n..1, exports a
  report).
- ``ScheduledReport`` ⟶ ``Report`` (n..1).
- ``ETLExecution`` ⟶ ``Call`` (1..*, loads data
  rows that materialize into Calls).
- ``ETLExecution`` ⟶ ``ETLError`` (1..*).
- ``Alert`` ⟶ ``Threshold`` (1..1).
- ``Alert`` ⟶ ``Subscription`` (1..*).
- ``Subscription`` ⟶ ``User`` (n..1, subscriber).
- ``InternalMailbox`` ⟵ ``Subscription`` (1..*,
  notification channel).
- ``AuditEvent`` ⟶ ``User`` (n..1, actor).
- All write-side operations across all contexts
  produce one or more ``AuditEvent`` per
  CNST-025.

## 6. Findings

| ID | Type | Description |
|----|------|-------------|
| H-A01 | OBSERVABLE | 25 classes promoted by Abbott filter from the vigent corpus; 6 nouns rejected (rule/role/value object/event/infrastructure); 3 PENDING for Stage 7. |
| H-A02 | OBSERVABLE | 20 of 25 classes pass IEEE 830 fully; 5 are REFINE (Metric, ScheduledReport, InternalMailbox, SystemHealth, TechnicalMetric). |
| H-A03 | OBSERVABLE | The seven bounded contexts (Auth, RBAC, Calls, Reports, ETL, Alerts, Audit, Logs) cover all 61 UCs; UC_PERM cluster maps entirely under RBAC context. |
| H-A04 | OBSERVABLE | The 11 D-01..D-11 decisions of Z.2 are imported as binding precedent; each class affected cites the decision in its operations or attributes. |
| H-A05 | INFERRED | The triplet ``ScheduledReport`` / ``Report`` / ``ExportJob`` likely shares a common ``ReportRequest`` superclass — to validate in Stage 7. |
| H-A06 | INFERRED | ``SystemHealth`` and ``TechnicalMetric`` are placed in the Logs context for module cohesion, but conceptually belong to a separate ``Monitoring`` context. Stage 7 may consider an eighth bounded context if the cross-references warrant it. |
| H-A07 | OBSERVABLE | The concept ``DataSegment`` does NOT appear among any of the 25 candidates, confirming Z.1.C Camino C; vigent corpus is consistent with the discard. |
| H-A08 | OBSERVABLE | Spanish-to-English class name translation table (§ 2.2) covers 24 nouns from ``analisis-dominio.rst`` § 3.1; one (``DataSegment``) is rejected outright. |

No SPECULATIVE findings (gate I-012 satisfied for
this stage).

## 7. Implications for Stage 7 DESIGN

- Build the PlantUML class diagram in **eight
  parts**: one overview + seven bounded contexts
  (Auth / RBAC / Calls / Reports & Metrics / ETL /
  Alerts / Audit / Logs).
- Resolve the 5 REFINE candidates with explicit
  attribute and operation lists.
- Decide on H-A05 (``ReportRequest`` superclass)
  and H-A06 (potential Monitoring context).
- For each class, attach a note citing:
  - the vigent UC(s) that justify it;
  - the vigent RBAC function(s) that operate on
    it;
  - the BR/CNST notes (using the **vigent
    versions**: BR-009 v2.0.0, BR-011 v2.0.0,
    CNST-019 v3.0.0, CNST-020 v3.0.0,
    CNST-001, CNST-007, CNST-025, etc.).

## 8. Confirmation pending from executor

- [ ] The 25 promoted classes are an acceptable
  starting set for Stage 7 DESIGN.
- [ ] The 6 rejections (roles, ``DataSegment``,
  attributes, value objects, infrastructure
  components) are correct.
- [ ] The 3 PENDING (Service, Dashboard, Region)
  are deferred to Stage 7 without blocking.
- [ ] The 5 REFINE candidates can advance to
  Stage 7 with the noted clarification needs.
- [ ] The English class-name convention is
  applied consistently throughout the model.

After confirmation, Stage 7 DESIGN produces the
canonical ``design/iact-domain-model.md`` with
the eight PlantUML diagrams and full attribute /
operation lists.

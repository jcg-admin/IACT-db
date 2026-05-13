```yml
created_at: 2026-04-26 02:15:00
project: IACT-docs
work_package: 2026-04-25-22-13-43-iact-project-state-assessment
phase: Phase 10 — EXECUTE (Phase D: PlantUML Implementation)
author: Claude
status: Aprobado
version: 1.0.0
```

# Task Plan — Phase D: PlantUML Implementation

## Objective

Implement production-ready PlantUML diagrams for `requisitos/casos_uso/` using the consolidated style system (v2.0.0) created in Phase C. Create use case diagrams for all IACT modules, sequence diagrams for key workflows, and activity diagrams for critical processes.

---

## Scope Summary

**In Scope:**
- 8 module-specific use case diagrams (auth, users, access, pipeline, reports, alerts, audit, logs)
- 4 key workflow sequence diagrams (authentication flow, call processing, reporting, alerting)
- 3 critical process activity diagrams (onboarding, permission grant, incident response)
- RST documentation files integrating diagrams into casos_uso/ structure
- Build validation and diagram rendering verification

**Out of Scope:**
- State machine diagrams (deferred to Phase E)
- Deployment architecture diagrams (separate initiative)
- ER/database diagrams (separate initiative)

**Diagram Count Target:** 15 diagrams total (8 usecase + 4 sequence + 3 activity)

---

## Task Breakdown

### Block 1: Module-Specific Use Case Diagrams (8 tasks)

Each use case diagram illustrates:
- Module actors (internal roles: admin, operator, auditor)
- External actors (users, systems, integrations)
- Primary use cases (main module features)
- Relationships (include, extend, generalization)

#### T-D01: AUTH Module Use Case Diagram
- **Description:** Authentication & Login services use cases
- **File:** `source/requisitos/casos_uso/AUTH_diagrama_casos_uso.rst`
- **Actors:** User, Admin, AuthService, LDAP/SSO
- **Use Cases:** Login, Logout, Multi-Factor Auth, Token Refresh, Password Reset
- **Colors:** COLOR_AUTH #3B82F6
- **Estimated Time:** 30 minutes

#### T-D02: USERS Module Use Case Diagram
- **Description:** User Management use cases
- **File:** `source/requisitos/casos_uso/USERS_diagrama_casos_uso.rst`
- **Actors:** Admin, Operator, UserService, Directory
- **Use Cases:** Create User, Edit Profile, Deactivate User, Bulk Import, Password Policy
- **Colors:** COLOR_USERS #8B5CF6
- **Estimated Time:** 30 minutes

#### T-D03: ACCESS Module Use Case Diagram
- **Description:** Access Control & Permissions use cases
- **File:** `source/requisitos/casos_uso/ACCESS_diagrama_casos_uso.rst`
- **Actors:** Admin, Auditor, PermissionService, RBAC Engine
- **Use Cases:** Grant Permission, Revoke Access, Audit Access, Create Group, Assign Role
- **Colors:** COLOR_ACCESS #EC4899
- **Estimated Time:** 35 minutes

#### T-D04: PIPELINE Module Use Case Diagram
- **Description:** Data Pipeline & Integration use cases
- **File:** `source/requisitos/casos_uso/PIPELINE_diagrama_casos_uso.rst`
- **Actors:** Operator, DataService, PBX/IVR, CRM, ETL Engine
- **Use Cases:** Ingest Data, Transform Data, Validate Quality, Route Data, Archive Data
- **Colors:** COLOR_PIPELINE #F59E0B
- **Estimated Time:** 35 minutes

#### T-D05: REPORTS Module Use Case Diagram
- **Description:** Analytics & Reporting use cases
- **File:** `source/requisitos/casos_uso/REPORTS_diagrama_casos_uso.rst`
- **Actors:** Analyst, Supervisor, Client, ReportingService, DataWarehouse
- **Use Cases:** Generate Report, Schedule Report, Export Data, Create Dashboard, Share Report
- **Colors:** COLOR_REPORTS #10B981
- **Estimated Time:** 35 minutes

#### T-D06: ALERTS Module Use Case Diagram
- **Description:** Alert System use cases
- **File:** `source/requisitos/casos_uso/ALERTS_diagrama_casos_uso.rst`
- **Actors:** Operator, Supervisor, AlertService, Notification Engine
- **Use Cases:** Create Alert, Trigger Alert, Escalate Alert, Acknowledge Alert, Close Alert
- **Colors:** COLOR_ALERTS #EF4444
- **Estimated Time:** 30 minutes

#### T-D07: AUDIT Module Use Case Diagram
- **Description:** Audit & Compliance use cases
- **File:** `source/requisitos/casos_uso/AUDIT_diagrama_casos_uso.rst`
- **Actors:** Auditor, Compliance Officer, AuditService, Log Store
- **Use Cases:** Review Audit Log, Generate Compliance Report, Verify Access, Export Evidence, Archive Log
- **Colors:** COLOR_AUDIT #6366F1
- **Estimated Time:** 30 minutes

#### T-D08: LOGS Module Use Case Diagram
- **Description:** Logging & Monitoring use cases
- **File:** `source/requisitos/casos_uso/LOGS_diagrama_casos_uso.rst`
- **Actors:** DevOps, Operator, LogService, Monitoring Dashboard
- **Use Cases:** Collect Logs, Parse Logs, Store Logs, Search Logs, Alert on Pattern
- **Colors:** COLOR_LOGS #64748B
- **Estimated Time:** 30 minutes

**Subtotal Block 1:** 255 minutes (4.25 hours)

---

### Block 2: Workflow Sequence Diagrams (4 tasks)

Each sequence diagram illustrates:
- Temporal interaction between modules/components
- Message flow (synchronous/asynchronous)
- Error handling paths
- Integration points

#### T-D09: Authentication Workflow Sequence Diagram
- **Description:** End-to-end authentication flow
- **File:** `source/requisitos/casos_uso/WORKFLOW_authentication_sequence.rst`
- **Participants:** User, Frontend, API, AuthService, LDAP, TokenStore
- **Flow:** Login → Credential Validate → MFA → Token Generate → Store → Return
- **Error Paths:** Invalid Credentials, MFA Failed, Service Down
- **Stereotypes:** Frontend<<Frontend>>, API<<Backend>>, AuthService<<Service>>
- **Estimated Time:** 45 minutes

#### T-D10: Call Processing Workflow Sequence Diagram
- **Description:** PBX/IVR integration and call data processing
- **File:** `source/requisitos/casos_uso/WORKFLOW_call_processing_sequence.rst`
- **Participants:** PBX/IVR, API, Pipeline, DataWarehouse, ReportingService
- **Flow:** Call Event → Ingest → Transform → Validate → Store → Index
- **Error Paths:** Data Quality Fail, Pipeline Error, Storage Full
- **Stereotypes:** PBX<<External>>, Pipeline<<Backend>>, DataWarehouse<<Database>>
- **Estimated Time:** 50 minutes

#### T-D11: Report Generation Workflow Sequence Diagram
- **Description:** On-demand and scheduled report creation
- **File:** `source/requisitos/casos_uso/WORKFLOW_reporting_sequence.rst`
- **Participants:** User, ReportingService, DataWarehouse, Scheduler, EmailService
- **Flow:** Request Report → Query Data → Generate → Format → Schedule/Send → Store
- **Error Paths:** Data Not Available, Generation Timeout, Send Failed
- **Stereotypes:** ReportingService<<Service>>, DataWarehouse<<Database>>
- **Estimated Time:** 45 minutes

#### T-D12: Alerting Workflow Sequence Diagram
- **Description:** Alert detection, routing, and escalation
- **File:** `source/requisitos/casos_uso/WORKFLOW_alerting_sequence.rst`
- **Participants:** Monitoring, AlertService, RuleEngine, Notification, Escalation
- **Flow:** Metric Event → Evaluate Rule → Create Alert → Route → Notify → Track
- **Error Paths:** Rule Failed, No Handler, Delivery Failed, Max Escalation
- **Stereotypes:** AlertService<<Service>>, Notification<<Backend>>
- **Estimated Time:** 45 minutes

**Subtotal Block 2:** 185 minutes (3.08 hours)

---

### Block 3: Critical Process Activity Diagrams (3 tasks)

Each activity diagram illustrates:
- Sequential and parallel process steps
- Decision points and branching
- Swimlanes for actor responsibilities
- Exception handling

#### T-D13: User Onboarding Activity Diagram
- **Description:** Multi-step user creation and provisioning process
- **File:** `source/requisitos/casos_uso/PROCESS_user_onboarding_activity.rst`
- **Swimlanes:** Admin (initiates) | UserService (creates) | AccessService (provisions) | EmailService (notifies)
- **Steps:** 
  - Start → Create Account → Generate Credentials → Assign Default Group → Provision Access → Send Welcome Email → End
  - Decision: Approve? Yes→Continue, No→Reject
  - Exception: User Already Exists → Warn & Exit
- **Colors:** COLOR_USERS (primary)
- **Estimated Time:** 40 minutes

#### T-D14: Permission Grant Activity Diagram
- **Description:** RBAC-based permission assignment with approval workflow
- **File:** `source/requisitos/casos_uso/PROCESS_permission_grant_activity.rst`
- **Swimlanes:** Requester | AccessService (validates) | Approver (reviews) | AuditService (logs)
- **Steps:**
  - Start → Request Permission → Validate Request → Check Rules → Route for Approval → Review → Approve/Deny → Update ACL → Audit Log → Notify → End
  - Decision: Rule Satisfied? Yes→Approve Path, No→Deny Path
  - Exception: System Down → Retry
- **Colors:** COLOR_ACCESS (primary)
- **Estimated Time:** 45 minutes

#### T-D15: Critical Incident Response Activity Diagram
- **Description:** Escalation, investigation, and resolution workflow
- **File:** `source/requisitos/casos_uso/PROCESS_incident_response_activity.rst`
- **Swimlanes:** AlertSystem | Operator (responds) | Supervisor (escalates) | Auditor (investigates)
- **Steps:**
  - Start → Alert Triggered → Operator Notified → Investigate → Classify Severity → (Parallel: Escalate + Audit Log) → Remediate → Close → Post-Mortem → End
  - Decision: Critical? Yes→Escalate, No→Standard Path
  - Exception: Timeout → Force Escalate
- **Colors:** COLOR_ALERTS (primary)
- **Estimated Time:** 45 minutes

**Subtotal Block 3:** 130 minutes (2.17 hours)

---

### Block 4: Integration & Documentation (3 tasks)

#### T-D16: Create casos_uso Index RST
- **Description:** Main index file that lists and introduces all diagrams
- **File:** `source/requisitos/casos_uso/index.rst`
- **Content:**
  - Overview of IACT modules and use cases
  - Links to all 8 module-specific diagrams (Block 1)
  - Links to all 4 workflow diagrams (Block 2)
  - Links to all 3 process diagrams (Block 3)
  - Legend for colors and stereotypes
  - Navigation to GUIDELINES.rst for styling info
- **Estimated Time:** 30 minutes

#### T-D17: Build Validation & Diagram Rendering Test
- **Description:** Full Sphinx build with PlantUML diagram compilation
- **Tasks:**
  - Run `make clean && make html`
  - Verify all 15 diagrams compile without errors
  - Check diagram PNG/SVG generation in build/html output
  - Verify colors render correctly
  - Test HTML navigation (click links between diagrams)
  - Screenshot sample diagrams for documentation
- **Estimated Time:** 30 minutes

#### T-D18: Phase D Completion & Commit
- **Description:** Finalize Phase D implementation
- **Tasks:**
  - Create Phase D changelog (metrics, before/after, diagrams count)
  - Create Phase D lessons learned (patterns, reusable templates)
  - Commit all diagram RST files
  - Commit index file
  - Commit changelog and lessons learned
  - Push to remote
  - Verify git history
- **Estimated Time:** 30 minutes

**Subtotal Block 4:** 90 minutes (1.5 hours)

---

## Total Effort Estimate

| Block | Tasks | Estimated Time |
|-------|-------|-----------------|
| Block 1: Module Use Cases | T-D01 to T-D08 | 255 min (4h 15m) |
| Block 2: Workflow Sequences | T-D09 to T-D12 | 185 min (3h 05m) |
| Block 3: Process Activities | T-D13 to T-D15 | 130 min (2h 10m) |
| Block 4: Integration & Docs | T-D16 to T-D18 | 90 min (1h 30m) |
| **TOTAL** | **18 tasks** | **660 minutes (11 hours)** |

**Aggressive Execution:** 1-2 sessions (sequential)
**Conservative Execution:** 2-3 sessions (with breaks/reviews)

---

## Dependencies & Prerequisites

✅ **All Prerequisites Met:**
- Consolidated PlantUML style system (Phase C) — ready
- Architecture diagrams migrated to centralized styles (Phase C) — done
- GUIDELINES.rst with stereotype documentation (Phase C) — available
- Build system validated (Phase C exit code 0) — functional
- Git repository and branching (feature/project-setup) — active

**No Blockers Identified.**

---

## Execution Notes

### Diagram Creation Pattern (for each use case/sequence/activity)

1. **Create RST file** in `source/requisitos/casos_uso/`
2. **Add metadata** (@IACT-DIAGRAM marker)
3. **Include consolidated styles** — `!include ../../../_static/plantuml-styles.puml`
4. **Design diagram** using module-specific colors and stereotypes from GUIDELINES.rst
5. **Test locally** with `make html` (if possible) or validate syntax
6. **Commit** with conventional message: `feat(phase-d): add {module} {diagram-type}`

### Color & Stereotype Reference (from Phase C)

**Module Colors:**
- AUTH: COLOR_AUTH #3B82F6
- USERS: COLOR_USERS #8B5CF6
- ACCESS: COLOR_ACCESS #EC4899
- PIPELINE: COLOR_PIPELINE #F59E0B
- REPORTS: COLOR_REPORTS #10B981
- ALERTS: COLOR_ALERTS #EF4444
- AUDIT: COLOR_AUDIT #6366F1
- LOGS: COLOR_LOGS #64748B

**Useful Stereotypes:**
- RBAC Actors: `<<AGR_ADMIN>>`, `<<AGR_OPERADOR>>`, `<<AGR_AUDITOR>>`
- Sequence Participants: `<<Frontend>>`, `<<Backend>>`, `<<Service>>`, `<<Database>>`, `<<External>>`
- Note Types: `<<CNST>>` (constraint), `<<INFO>>` (info), `<<SUCCESS>>` (success)

See `source/plantuml-guide/GUIDELINES.rst` for complete reference.

---

## Success Criteria

**Phase D is COMPLETE when:**

- ✅ All 8 module use case diagrams created and rendering
- ✅ All 4 workflow sequence diagrams created and rendering
- ✅ All 3 process activity diagrams created and rendering
- ✅ casos_uso/index.rst created with links to all diagrams
- ✅ Full build validation: `make clean && make html` exits 0
- ✅ All 15 diagrams compile without PlantUML errors
- ✅ Colors render correctly (verified visually)
- ✅ Stereotypes applied appropriately
- ✅ Phase D changelog created with metrics
- ✅ All changes committed and pushed to remote

**Deliverables:** 15 production diagrams + 1 index + 2 documentation files

---

## Risk Register

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|-----------|
| PlantUML syntax errors | Medium | Medium | Test each diagram locally; refer to GUIDELINES.rst examples |
| Color rendering issues | Low | Low | Phase C testing validates all colors; reuse patterns |
| RST formatting errors | Low | Low | Follow existing requisitos/ structure; validate with make html |
| Scope creep (more diagrams) | Medium | Low | Stick to 15-diagram scope; defer state/deployment to Phase E |
| Build time increase | Low | Low | Expected; 15 new diagrams will increase build time ~2-3 minutes |

---

## Next Phase (Phase E — Optional)

After Phase D completion, candidates for Phase E:

1. **State Machine Diagrams** — System states and transitions
2. **Deployment Architecture** — Infrastructure and service placement
3. **ER/Database Diagrams** — Schema design and relationships
4. **Decision Matrices** — Cross-module interaction tables
5. **Integration Patterns** — Message flows between modules

---

**Task Plan Created:** 2026-04-26 02:15:00
**Approval Status:** Ready to execute
**Estimated Duration:** 11 hours (660 minutes)
**Readiness:** 100% — All prerequisites met, no blockers

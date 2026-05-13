====================================================
AUDIT Module — Use Case Diagram
====================================================

:module: AUDIT
:diagram_type: use-case
:color: COLOR_AUDIT (#6366F1)
:actors: Auditor, Compliance Officer, AuditService, Log Store
:created: 2026-04-26
:status: Production

Overview
========

The AUDIT (Audit & Compliance) module maintains immutable audit trails of system events, user actions, and access changes for compliance verification and forensic investigation.

Use Case Diagram
================

.. uml::

   @startuml audit_use_cases
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: use-case
   ' description: AUDIT module audit and compliance use cases

   actor "Auditor" as auditor <<AGR_AUDITOR>>
   actor "Compliance Officer" as compliance <<AGR_AUDITOR>>
   actor "AuditService" as audit_svc <<SISTEMA>>

   usecase "Review\nAudit Log" as review_log
   usecase "Generate\nCompliance Report" as gen_compliance
   usecase "Verify\nAccess" as verify_access
   usecase "Export\nEvidence" as export_evidence
   usecase "Archive\nLog" as archive_log
   usecase "Search\nLog" as search_log

   usecase "Validate\nIntegrity" as validate_integrity
   usecase "Generate\nHash" as gen_hash

   auditor --> review_log
   auditor --> verify_access
   auditor --> search_log

   compliance --> gen_compliance
   compliance --> export_evidence

   review_log --> search_log: <<include>>
   gen_compliance --> validate_integrity: <<include>>
   export_evidence --> validate_integrity: <<include>>
   archive_log --> gen_hash: <<include>>

   note right of review_log
     Browse audit trail
     for specific events
   end note

   note right of validate_integrity
     Verify logs not tampered
     using cryptographic hashing
   end note

   @enduml

**Actors:**
- Auditor: Reviews logs, verifies access, searches events
- Compliance Officer: Generates compliance reports, exports evidence
- AuditService: Logs all system events immutably

**Use Cases:**

1. **Review Audit Log** - Browse and analyze audit trail for specific events or time periods
2. **Generate Compliance Report** - Create report documenting compliance with regulations (SOX, HIPAA, GDPR)
3. **Verify Access** - Audit access logs to confirm authorization and detect unauthorized access
4. **Export Evidence** - Extract audit data for legal/regulatory purposes with hash verification
5. **Archive Log** - Move old logs to long-term storage with integrity preserved
6. **Search Log** - Query audit trail by user, action, resource, timestamp

**Constraints:**
- CNST-AUDIT-001: Audit logs immutable; no modification/deletion permitted
- CNST-AUDIT-002: Log retention 7 years minimum
- CNST-AUDIT-003: Log entries include: timestamp, user, action, resource, result, IP address
- CNST-AUDIT-004: Backup copy maintained in separate location (geo-redundant)

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Module Color:** COLOR_AUDIT (#6366F1)

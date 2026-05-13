====================================================
ACCESS Module — Use Case Diagram
====================================================

:module: ACCESS
:diagram_type: use-case
:color: COLOR_ACCESS (#EC4899)
:actors: Admin, Auditor, PermissionService, RBAC Engine
:created: 2026-04-26
:status: Production

Overview
========

The ACCESS (Access Control & Permissions) module implements role-based access control (RBAC) for the IACT system. It manages permission assignment, revocation, group management, and access auditing.

This diagram illustrates:

- **Primary Actors:** Admin (grants/revokes), Auditor (reviews access)
- **Secondary Actors:** PermissionService (system component), RBAC Engine
- **Use Cases:** Grant Permission, Revoke Access, Audit Access, Create Group, Assign Role
- **Relationships:** Includes permission validation and audit logging

Use Case Diagram
================

.. uml::

   @startuml access_use_cases
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: use-case
   ' description: ACCESS module role-based access control use cases

   ' Actors
   actor "Admin" as admin <<AGR_ADMIN>>
   actor "Auditor" as auditor <<AGR_AUDITOR>>
   actor "PermissionService" as perm_svc <<SISTEMA>>

   ' Primary use cases
   usecase "Grant\nPermission" as grant_perm
   usecase "Revoke\nAccess" as revoke_access
   usecase "Audit\nAccess" as audit_access
   usecase "Create\nGroup" as create_group
   usecase "Assign\nRole" as assign_role

   ' Support use cases
   usecase "Validate\nRequest" as validate_req
   usecase "Check\nRules" as check_rules
   usecase "Update\nACL" as update_acl
   usecase "Log\nEvent" as log_event
   usecase "Verify\nUser Identity" as verify_id

   ' Relationships
   admin --> grant_perm
   admin --> revoke_access
   admin --> assign_role
   admin --> create_group

   auditor --> audit_access

   grant_perm --> validate_req: <<include>>
   grant_perm --> check_rules: <<include>>
   grant_perm --> update_acl: <<include>>
   grant_perm --> log_event: <<include>>

   revoke_access --> verify_id: <<include>>
   revoke_access --> update_acl: <<include>>
   revoke_access --> log_event: <<include>>

   assign_role --> validate_req: <<include>>
   assign_role --> update_acl: <<include>>
   assign_role --> log_event: <<include>>

   audit_access --> log_event: <<include>>

   create_group --> log_event: <<include>>

   note right of grant_perm
     RBAC: Assign permission
     to user or group
     with approval workflow
   end note

   note right of audit_access
     Review access logs
     and verify compliance
   end note

   @enduml

Actors
======

**Admin (Internal Actor - AGR_ADMIN)**
- Grants/revokes permissions to users
- Assigns roles to users and groups
- Creates and manages groups
- Reviews access requests

**Auditor (Internal Actor - AGR_AUDITOR)**
- Audits access logs
- Generates compliance reports
- Verifies access against policy
- Cannot grant/revoke (read-only)

**PermissionService (System Component)**
- Manages ACL (Access Control List)
- Validates permission requests
- Updates role/permission mappings
- Logs all access changes

**RBAC Engine (System Component)**
- Evaluates access rules
- Checks permission inheritance
- Enforces group-based permissions

Use Cases
=========

**Core Use Cases:**

1. **Grant Permission** (Primary - Admin Initiated)
   - Actor: Admin
   - Description: Assign permission/role to user or group
   - Precondition: User/group exists, permission exists
   - Main Flow:

     a. Admin selects user/group
     b. Admin selects permission/resource
     c. System validates request (include Validate Request)
     d. System checks RBAC rules (include Check Rules)
     e. If approval required, route to approver
     f. System updates ACL (include Update ACL)
     g. System logs event (include Log Event)

   - Post-condition: User has permission; effective immediately
   - Constraint: CNST-ACCESS-002: Requires approval for sensitive permissions

2. **Revoke Access** (Primary - Admin Initiated)
   - Actor: Admin
   - Description: Remove user/group permissions
   - Reason: Role change, termination, security incident
   - Main Flow:

     a. Admin selects user/group
     b. Admin selects permissions to revoke
     c. System verifies identity (include Verify User Identity)
     d. System removes from ACL (include Update ACL)
     e. System logs event (include Log Event)
     f. Active sessions with revoked permission are terminated

   - Alternative: Revoke all permissions for user (complete access removal)

3. **Audit Access** (Primary - Auditor Initiated)
   - Actor: Auditor
   - Description: Review and verify access logs for compliance
   - Main Flow:

     a. Auditor selects time period and filters (user/resource/action)
     b. System retrieves access logs
     c. Auditor reviews entries for anomalies
     d. System generates compliance report (include Log Event)

   - Output: Access log report with timestamp, user, action, resource, status
   - Use Case: Compliance verification, incident investigation

4. **Create Group** (Primary - Admin Initiated)
   - Actor: Admin
   - Description: Create permission group (logical grouping of users)
   - Example Groups: Department groups (Finance, HR, Engineering)
   - Main Flow:

     a. Admin creates group name and description
     b. Admin assigns initial members (users/groups)
     c. System creates group in RBAC engine
     d. System logs event (include Log Event)

   - Post-condition: Group can have permissions assigned
   - Alternative: Create group as delegation (manager can manage group membership)

5. **Assign Role** (Primary - Admin Initiated)
   - Actor: Admin
   - Description: Assign predefined role to user/group
   - Example Roles: Operator, Analyst, Manager, Auditor
   - Role Benefits: Simplified permission management (one-click vs. individual permissions)
   - Main Flow:

     a. Admin selects user/group
     b. Admin selects role
     c. System validates request (include Validate Request)
     d. System updates ACL with all role permissions (include Update ACL)
     e. System logs event (include Log Event)

   - Post-condition: User inherits all role permissions
   - Alternative: Role can be time-limited (temporary elevated access)

6. **Validate Request** (Support)
   - Actor: PermissionService
   - Description: Check grant/revoke request for completeness
   - Validation:

     - User/group exists
     - Permission/role exists
     - Requester (Admin) has authority to grant
     - No circular group memberships

   - Output: Valid/Invalid

7. **Check Rules** (Support)
   - Actor: RBAC Engine
   - Description: Evaluate RBAC rules for permission grant
   - Rules:

     - User cannot grant permission higher than own level
     - Sensitive permissions require approval chain
     - Group inheritance rules (nested groups)
     - Conflicting permissions (mutually exclusive roles)

   - Output: Allowed/Denied with reason

8. **Update ACL** (Support)
   - Actor: PermissionService
   - Description: Modify access control list
   - Operations: Add, remove, modify entries
   - Atomic: All or nothing (transaction)
   - Persistence: Replicated across RBAC cache

9. **Log Event** (Support)
   - Actor: PermissionService
   - Description: Audit log entry for access change
   - Logged Info: Timestamp, actor, action, user/group, permission, result
   - Immutable: Cannot be modified (audit trail)
   - Retention: 7 years (compliance)

10. **Verify User Identity** (Support)
    - Actor: PermissionService
    - Description: Confirm identity before revoking access
    - Method: Admin password re-entry or MFA
    - Purpose: Security check before destructive action

Constraints
===========

.. list-table::
   :header-rows: 1
   :widths: 20 60 20

   * - Constraint ID
     - Description
     - Severity
   * - CNST-ACCESS-001
     - RBAC model: No hierarchy; flat structure with group inheritance
     - High
   * - CNST-ACCESS-002
     - Sensitive permissions require Admin+Auditor approval (two-person rule)
     - High
   * - CNST-ACCESS-003
     - Permission changes effective immediately; no staging/scheduling
     - Medium
   * - CNST-ACCESS-004
     - Revoked permission terminates active sessions within 60 seconds
     - High
   * - CNST-ACCESS-005
     - Cannot revoke last Admin user's admin permission
     - High
   * - CNST-ACCESS-006
     - ACL updates must be atomic (all-or-nothing transaction)
     - Medium

Related Use Cases
=================

- **AUTH Module:** User login (checked against current ACL)
- **USERS Module:** User deactivation (removes all permissions)
- **AUDIT Module:** Access event audit trail
- **LOGS Module:** Permission change logging and monitoring

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Module Color:** COLOR_ACCESS (#EC4899)

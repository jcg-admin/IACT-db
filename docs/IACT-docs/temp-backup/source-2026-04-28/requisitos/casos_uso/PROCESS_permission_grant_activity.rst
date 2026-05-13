====================================================
Permission Grant Process — Activity Diagram
====================================================

:module: requisitos
:diagram_type: activity
:description: RBAC-based permission assignment with approval workflow
:created: 2026-04-26
:status: Production

Process Overview
================

This activity diagram shows the workflow for granting permissions to users, including validation, rule checking, approval routing, and audit logging.

Activity Diagram
================

.. uml::

   @startuml permission_grant
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: activity
   ' description: Permission grant workflow with approval

   start
   :Requester initiates\npermission request;
   :Select user/group;
   :Select permission/resource;
   :Validate request\n(user exists, permission exists);
   if (Valid?) then (no)
     :Return error;
     stop
   else (yes)
   endif
   :Check RBAC rules\n(elevation limit, conflicts);
   if (Rules satisfied?) then (no)
     :Deny request;
     :Notify requester;
     stop
   else (yes)
   endif
   if (Sensitive permission?) then (yes)
     :Route to approver\n(Admin + Auditor);
     :Approver reviews request;
     if (Approved?) then (no)
       :Deny and log;
       stop
     else (yes)
     endif
   else (no)
   endif
   :Update ACL\n(add permission entry);
   :Log event\n(timestamp, actor, action, result);
   :Notify user\n(permission granted);
   :Mark as effective;
   end

   note right
     Swimlanes:
     - Requester: Initiates
     - AccessService: Validates/updates
     - Approver: Reviews sensitive grants
     - AuditService: Logs all changes
   end note

**Process Steps:**

1. **Initiation** - User/Admin requests permission grant
2. **User Selection** - Choose target user or group
3. **Permission Selection** - Choose permission/resource to grant
4. **Validation** - Verify user and permission exist
5. **RBAC Rules Check** - Verify elevation rules (user can't grant > own perms)
6. **Sensitivity Check** - Is this a sensitive permission?
   - **YES:** Route to approvers (Admin + Auditor)
   - **NO:** Proceed to ACL update
7. **Approval (if sensitive)** - Approvers review and decide
8. **ACL Update** - Add permission entry atomically
9. **Audit Logging** - Log change with all metadata
10. **Notification** - Notify user of grant
11. **Activation** - Permission effective immediately

**Sensitive Permissions Requiring Approval:**
- Admin role assignment
- Auditor role assignment
- Access to PII/sensitive data
- Cross-department permissions

**Error Handling:**
- Validation fails → Return error, stop
- Rule violation → Deny with explanation
- Approval denied → Log and notify requester
- ACL update fails → Retry with exponential backoff; alert ops

**SLA:**
- Permission grant (non-sensitive): <1 minute
- Permission grant (sensitive, approved): <5 minutes
- Approval response time: 24 hours SLA

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Related Module:** ACCESS

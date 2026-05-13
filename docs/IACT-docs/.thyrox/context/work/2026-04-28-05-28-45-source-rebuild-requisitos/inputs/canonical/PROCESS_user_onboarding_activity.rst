====================================================
User Onboarding Process — Activity Diagram
====================================================

:module: requisitos
:diagram_type: activity
:description: Multi-step user creation and provisioning process
:created: 2026-04-26
:status: Production

Process Overview
================

This activity diagram illustrates the sequential and parallel steps involved in onboarding a new user account to the IACT system, including account creation, credential generation, access provisioning, and notification.

Activity Diagram
================

.. uml::

   @startuml user_onboarding
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: activity
   ' description: User onboarding process with parallel provisioning

   start
   :Admin initiates user creation;
   :Enter user details\n(email, name, dept, manager);
   :Validate email not duplicate;
   if (Email exists?) then (yes)
     :Reject - Email in use;
     stop
   else (no)
   endif
   :Create account in LDAP;
   :Generate default password;
   :Assign default group/role;
   fork
     :Provision access permissions;
     :Sync to directory;
   fork again
     :Create in reporting system;
   end fork
   :Send welcome email\n(with temp password);
   :Mark account active;
   :Return to admin;
   end

   note right
     Swimlanes (implied):
     - Admin: Initiates
     - UserService: Creates/provisions
     - EmailService: Sends notification
   end note

**Process Steps:**

1. **Admin Initiation** - Administrator clicks "Create User"
2. **Data Entry** - Admin enters user details (email, full name, department, manager)
3. **Validation** - Check if email already registered
4. **Account Creation** - Create account in LDAP/AD directory
5. **Password Generation** - Generate temporary 12+ char password
6. **Default Group Assignment** - Assign user to department group
7. **Parallel Processing:**
   - Provision access permissions (based on role/group)
   - Sync to directory systems
   - Create in reporting/analytics system
8. **Notification** - Send welcome email with temporary password
9. **Activation** - Mark account as active/ready for login
10. **Completion** - Return success to admin

**Swimlanes (Actor Responsibilities):**

.. list-table::
   :header-rows: 1

   * - Phase
     - Responsible Actor
   * - Initiation
     - Admin
   * - Validation
     - UserService
   * - Account Creation
     - UserService + LDAP
   * - Group Assignment
     - UserService
   * - Provisioning
     - PermissionService + UserService
   * - Notification
     - EmailService
   * - Completion
     - UserService


**Decision Points:**

- **Email Duplicate?** → Reject and stop, return error
- **LDAP Available?** → Fallback to local provisioning, queue sync
- **Permission Provisioning Fails?** → Log error, continue (manual remediation)

**SLA:**
- User onboarding completion: <5 minutes from creation to active account

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Related Module:** USERS

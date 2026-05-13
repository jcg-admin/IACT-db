====================================================
USERS Module — Use Case Diagram
====================================================

:module: USERS
:diagram_type: use-case
:color: COLOR_USERS (#8B5CF6)
:actors: Admin, Operator, UserService, Directory
:created: 2026-04-26
:status: Production

Overview
========

The USERS (User Management) module handles user account creation, profile management, deactivation, bulk operations, and directory integration.

This diagram illustrates:

- **Primary Actors:** Admin (account creation), Operator (profile management)
- **Secondary Actors:** UserService (system component), Directory (LDAP/AD)
- **Use Cases:** Create User, Edit Profile, Deactivate User, Bulk Import, Password Policy Configuration
- **Relationships:** Includes, extensions, and dependencies

Use Case Diagram
================

.. uml::

   @startuml users_use_cases
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: use-case
   ' description: USERS module user management use cases

   ' Actors
   actor "Admin" as admin <<AGR_ADMIN>>
   actor "Operator" as operator <<AGR_OPERADOR>>
   actor "UserService" as user_svc <<SISTEMA>>
   actor "Directory" as directory <<Externo>>

   ' Primary use cases
   usecase "Create\nUser" as create_user
   usecase "Edit\nProfile" as edit_profile
   usecase "Deactivate\nUser" as deactivate_user
   usecase "Bulk\nImport" as bulk_import
   usecase "View User\nDetails" as view_user

   ' Support use cases
   usecase "Validate\nAccount" as validate_acct
   usecase "Generate\nDefault Password" as gen_pwd
   usecase "Sync to\nDirectory" as sync_dir
   usecase "Check Password\nPolicy" as check_policy
   usecase "Send\nNotification" as send_notif

   ' Actors and relationships
   admin --> create_user
   admin --> bulk_import
   admin --> deactivate_user

   operator --> view_user
   operator --> edit_profile

   create_user --> validate_acct: <<include>>
   create_user --> gen_pwd: <<include>>
   create_user --> sync_dir: <<include>>
   create_user --> send_notif: <<include>>

   edit_profile --> sync_dir: <<include>>
   edit_profile --> send_notif: <<include>>

   bulk_import --> create_user: <<include>>

   deactivate_user --> sync_dir: <<include>>
   deactivate_user --> send_notif: <<include>>

   gen_pwd --> check_policy: <<include>>

   note right of create_user
     Standard account creation
     with auto-generated password
     and notification
   end note

   note right of bulk_import
     Supports CSV/Excel import
     Max 10,000 users per batch
   end note

   note right of deactivate_user
     User marked inactive
     not deleted; reversible
   end note

   @enduml

Actors
======

**Admin (Internal Actor - AGR_ADMIN)**
- Creates new user accounts
- Performs bulk user imports
- Deactivates/removes users
- Configures password policies
- Views all user profiles

**Operator (Internal Actor - AGR_OPERADOR)**
- Views user profile information
- Edits own profile or limited user profiles
- Cannot create or deactivate accounts

**UserService (System Component)**
- Manages user account lifecycle
- Validates account data
- Syncs with LDAP/AD directory
- Generates credentials
- Sends notifications

**Directory (External - LDAP/Active Directory)**
- Authoritative user store
- Receives sync updates
- Provides user group membership

Use Cases
=========

**Core Use Cases:**

1. **Create User** (Primary - Admin Initiated)
   - Actor: Admin
   - Description: Create new user account with initial credentials
   - Precondition: User email not already registered
   - Main Flow:

     a. Admin enters user details (name, email, department, role)
     b. System validates account data (include Validate Account)
     c. System generates default password (include Generate Default Password)
     d. System syncs to LDAP/AD (include Sync to Directory)
     e. System sends welcome email with credentials (include Send Notification)
     f. Account created and ready for first login

   - Post-condition: User can login with default password (will be forced to change)
   - Alternative: Invite user to set own password via email link

2. **Edit Profile** (Primary - Operator or Self-Service Initiated)
   - Actor: Operator, User (self-service)
   - Description: Update user profile information
   - Editable Fields: Phone, Department, Manager, Location, Contact Preferences
   - Non-Editable: Email, Username (immutable identifiers)
   - Main Flow:

     a. Operator/User enters profile changes
     b. System validates changes
     c. System syncs to Directory (include Sync to Directory)
     d. System sends confirmation notification (include Send Notification)

   - Alternative: Admin can force profile updates (compliance, reorganization)

3. **Deactivate User** (Primary - Admin Initiated)
   - Actor: Admin
   - Description: Mark user as inactive (reversible)
   - Reason: Termination, leave of absence, security breach
   - Main Flow:

     a. Admin selects user to deactivate
     b. System marks account inactive
     c. System disables all active sessions/tokens
     d. System syncs to Directory (include Sync to Directory)
     e. System sends notification to user and manager (include Send Notification)

   - Post-condition: User cannot login; account can be reactivated
   - Constraint: Cannot deactivate currently logged-in user

4. **Bulk Import** (Primary - Admin Initiated)
   - Actor: Admin
   - Description: Import multiple users from CSV/Excel file
   - File Format: CSV with columns (email, name, department, role, manager)
   - Max Size: 10,000 users per import
   - Main Flow:

     a. Admin uploads file
     b. System parses and validates file
     c. System creates user accounts for each row (include Create User)
     d. System generates import report (success/failure counts)
     e. System sends batch notification email

   - Alternative Flows:
     - File format error → Return error report → Provide sample template
     - Duplicate email → Skip row, continue with others
     - Validation failure → Pause, allow manual review and retry

5. **View User Details** (Primary - Operator Initiated)
   - Actor: Operator
   - Description: Retrieve and display user profile information
   - Access Control: Operator can view users in same department/group
   - Information Returned: Name, email, department, manager, last login, status
   - Use Case: Lookup user during support/troubleshooting

6. **Validate Account** (Support)
   - Actor: UserService
   - Description: Check account data for completeness and uniqueness
   - Validation Rules:

     - Email format valid and unique
     - Name not empty
     - Department exists
     - Manager (if specified) exists
     - Role valid

   - Output: Valid/Invalid with error list

7. **Generate Default Password** (Support)
   - Actor: UserService
   - Description: Create temporary password for new account
   - Requirements:

     - 12+ characters
     - Complexity: uppercase, lowercase, number, special char
     - Not reusable (user must change on first login)

   - Includes: Check Password Policy

8. **Sync to Directory** (Support)
   - Actor: UserService
   - Description: Synchronize user changes to LDAP/AD
   - Trigger: Create, Edit, Deactivate
   - Sync Type: Real-time (blocking call within 5 sec timeout)
   - Failure Handling: Log error, queue for retry, notify admin
   - One-way sync: IACT → Directory

9. **Send Notification** (Support)
   - Actor: UserService
   - Description: Notify user or manager of account changes
   - Templates:

     - Welcome (with credentials)
     - Profile update confirmation
     - Deactivation notice
     - Password reset

   - Channel: Email (SMS optional)
   - Constraint: Respect user notification preferences

10. **Check Password Policy** (Support)
    - Actor: UserService
    - Description: Validate passwords against org policy (shared with AUTH)
    - See AUTH module for details

Constraints
===========

.. list-table::
   :header-rows: 1
   :widths: 20 60 20

   * - Constraint ID
     - Description
     - Severity
   * - CNST-USERS-001
     - Email is unique identifier; cannot be reused
     - High
   * - CNST-USERS-002
     - Default password must be changed on first login
     - High
   * - CNST-USERS-003
     - Bulk import max 10,000 users; no nested groups
     - Medium
   * - CNST-USERS-004
     - LDAP sync timeout: 5 seconds; fallback to queue if timeout
     - High
   * - CNST-USERS-005
     - Deactivated user accounts retained for 1 year before archival
     - Medium
   * - CNST-USERS-006
     - Cannot deactivate last Admin user
     - High

Related Use Cases
=================

- **AUTH Module:** Login (depends on user account creation)
- **ACCESS Module:** Permission assignment during user creation
- **AUDIT Module:** User lifecycle events logged
- **LOGS Module:** User management operations tracked

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Module Color:** COLOR_USERS (#8B5CF6)

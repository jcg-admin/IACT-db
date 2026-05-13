====================================================
AUTH Module — Use Case Diagram
====================================================

:module: AUTH
:diagram_type: use-case
:color: COLOR_AUTH (#3B82F6)
:actors: User, Admin, AuthService, LDAP/SSO System
:created: 2026-04-26
:status: Production

Overview
========

The AUTH (Authentication & Login Services) module manages user authentication, credential validation, multi-factor authentication, token management, and password policies.

This diagram illustrates:

- **Primary Actors:** User (external), Admin (internal operator)
- **Secondary Actors:** AuthService (system component), LDAP/SSO (external integration)
- **Use Cases:** Login, Logout, Multi-Factor Auth, Token Refresh, Password Reset, Account Lockout
- **Relationships:** Include/extend dependencies between use cases

Use Case Diagram
================

.. uml::

   @startuml auth_use_cases
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: use-case
   ' description: AUTH module authentication and login use cases

   ' Actors
   actor "User" as user <<Usuario>>
   actor "Admin" as admin <<AGR_ADMIN>>
   actor "AuthService" as auth_svc <<SISTEMA>>

   ' Primary use cases
   usecase "Login" as login
   usecase "Logout" as logout
   usecase "Multi-Factor\nAuthentication" as mfa

   ' Support use cases
   usecase "Validate\nCredentials" as validate
   usecase "Generate\nToken" as gen_token
   usecase "Refresh\nToken" as refresh_token
   usecase "Reset\nPassword" as reset_pwd
   usecase "Account\nLockout" as lockout
   usecase "Check Password\nPolicy" as check_policy

   ' Relationships
   user --> login
   user --> logout
   user --> reset_pwd

   admin --> reset_pwd
   admin --> lockout

   login --> validate: <<include>>
   login --> mfa: <<include>>
   login --> gen_token: <<include>>

   validate --> check_policy: <<include>>

   user --> refresh_token
   logout --> gen_token: <<exclude>>

   mfa --> validate: <<include>>

   note right of login
     Two-step process:
     1. Validate credentials
     2. Perform MFA
     3. Generate token
   end note

   note right of lockout
     CNST: Max 5 failed attempts
     within 15 minutes
   end note

   @enduml

Actors
======

**User (External Actor)**
- Initiates login/logout
- Requests password reset
- Performs multi-factor authentication

**Admin (Internal Actor - AGR_ADMIN)**
- Resets passwords for users
- Manages account lockouts
- Configures password policy

**AuthService (System Component)**
- Validates credentials against LDAP/Directory
- Generates and manages tokens (JWT/OAuth)
- Enforces password policies
- Tracks failed login attempts

**LDAP/SSO System (External Integration)**
- Provides credential validation
- Supplies user directory information

Use Cases
=========

**Core Use Cases:**

1. **Login** (Primary - User Initiated)
   - Actor: User
   - Description: User authenticates and receives session token
   - Precondition: Valid account exists
   - Main Flow:

     a. User enters credentials
     b. System validates credentials (include Validate Credentials)
     c. System initiates MFA if required (include Multi-Factor Auth)
     d. System generates token (include Generate Token)
     e. System returns token to User

   - Alternative Flows:
     - Invalid credentials → Increment failed attempts → Check lockout
     - MFA timeout → Request retry
     - Service unavailable → Return error

2. **Logout** (Primary - User Initiated)
   - Actor: User
   - Description: User terminates session and invalidates token
   - Main Flow:

     a. User requests logout
     b. System invalidates current token
     c. System clears session

   - Result: User returns to anonymous state

3. **Multi-Factor Authentication (MFA)** (Support)
   - Actor: User, AuthService
   - Description: Secondary verification using email, SMS, or authenticator app
   - Triggered By: Login use case
   - Main Flow:

     a. System sends MFA challenge (email/SMS code or prompt)
     b. User responds with code/approval
     c. System validates response

   - Alternative Flows:
     - Invalid code → Request retry (max 3 attempts)
     - Timeout → Return to login

4. **Password Reset** (Primary - User or Admin Initiated)
   - Actor: User (self-service), Admin (for users)
   - Description: Change or recover forgotten password
   - Main Flow:

     a. User/Admin initiates reset
     b. System sends reset link/code via email
     c. User clicks link and enters new password
     d. System checks policy compliance (include Check Password Policy)
     e. System updates password in LDAP/Directory

   - Security: Reset link expires after 24 hours

5. **Validate Credentials** (Support)
   - Actor: AuthService (system component)
   - Description: Check username/password against LDAP/SSO system
   - Input: Username, Password
   - Output: Valid/Invalid
   - Includes: Check Password Policy

6. **Generate Token** (Support)
   - Actor: AuthService
   - Description: Create JWT or OAuth token for authenticated session
   - Input: User ID, Roles
   - Output: Token (exp, iss, aud, roles)
   - Expiration: Configurable (default 8 hours)

7. **Refresh Token** (Primary - User Initiated)
   - Actor: User
   - Description: Extend session without re-authenticating
   - Precondition: Valid refresh token exists
   - Main Flow:

     a. User sends refresh token
     b. System validates token
     c. System generates new access token

   - Expiration: Refresh token valid for 30 days

8. **Account Lockout** (Primary - Admin Initiated)
   - Actor: Admin
   - Description: Temporarily or permanently disable account
   - Reason: Security breach, policy violation
   - Duration: Manual unlock by Admin or time-based unlock (24h default)
   - Constraint: CNST-AUTH-003: Max 5 failed login attempts within 15 minutes triggers automatic lockout

9. **Check Password Policy** (Support)
   - Actor: AuthService
   - Description: Validate password against org policy
   - Rules:

     - Minimum 12 characters
     - Must include: uppercase, lowercase, number, special char
     - Cannot reuse last 5 passwords
     - Cannot contain username

   - Triggered By: Reset Password, Validate Credentials

Constraints
===========

.. list-table::
   :header-rows: 1
   :widths: 20 60 20

   * - Constraint ID
     - Description
     - Severity
   * - CNST-AUTH-001
     - Token expiration: 8 hours for access token, 30 days for refresh token
     - High
   * - CNST-AUTH-002
     - MFA timeout: 5 minutes for user response
     - Medium
   * - CNST-AUTH-003
     - Account lockout: Max 5 failed login attempts within 15 minutes triggers automatic 1-hour lockout
     - High
   * - CNST-AUTH-004
     - Password policy: Min 12 chars, 1 uppercase, 1 lowercase, 1 number, 1 special char
     - Medium
   * - CNST-AUTH-005
     - LDAP integration: Max 2 seconds response time, fallback to local cache if unavailable
     - High

Related Use Cases
=================

- **USERS Module:** User account creation (triggers default password policy)
- **ACCESS Module:** Permission assignment after login (depends on validated user identity)
- **AUDIT Module:** Login attempt logging and reporting
- **LOGS Module:** Authentication event logging and monitoring

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Module Color:** COLOR_AUTH (#3B82F6)

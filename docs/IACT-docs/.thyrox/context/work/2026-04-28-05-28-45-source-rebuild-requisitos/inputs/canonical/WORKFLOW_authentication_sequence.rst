====================================================
Authentication Workflow — Sequence Diagram
====================================================

:module: requisitos
:diagram_type: sequence
:description: End-to-end authentication flow from user login to token generation
:created: 2026-04-26
:status: Production

Overview
========

This sequence diagram illustrates the complete authentication workflow when a user logs in to IACT. It shows the message flow between frontend, API gateway, authentication service, and directory (LDAP/AD), including success and error paths.

Sequence Diagram
================

.. uml::

   @startuml auth_workflow
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: requisitos
   ' type: sequence
   ' description: Authentication workflow from login to token generation

   participant "User" as user <<Frontend>>
   participant "Frontend\nApplication" as fe <<Frontend>>
   participant "API\nGateway" as api <<Backend>>
   participant "AuthService" as auth <<Service>>
   participant "LDAP/AD" as ldap <<External>>
   participant "Token\nStore" as token <<Database>>

   autonumber
   user -> fe: Enter credentials (email, password)
   fe -> api: POST /auth/login {email, password}
   api -> auth: Validate credentials
   auth -> ldap: Query user entry
   ldap --> auth: User found / not found
   alt User not found or password invalid
     auth --> api: 401 Unauthorized
     api --> fe: Error: Invalid credentials
     fe --> user: Display error message
   else Valid credentials
     auth -> auth: Check if MFA required
     alt MFA required
       auth --> api: 202 MFA required
       api --> fe: Request MFA code
       fe --> user: Enter MFA code (email/SMS/app)
       user -> fe: Provide MFA code
       fe -> api: POST /auth/mfa-verify {code}
       api -> auth: Verify MFA code
       auth -> auth: Validate code within 5-minute window
       alt MFA code expired or invalid
         auth --> api: 401 MFA failed
         api --> fe: Error: Invalid code
         fe --> user: Request retry
       else MFA valid
         note right of auth
           Proceed to token generation
         end note
       end
     else No MFA required
       note right of auth
         Skip MFA, proceed to token
       end note
     end
     auth -> auth: Generate JWT token\n(exp: 8h, roles, perms)
     auth -> token: Store refresh token\n(exp: 30d)
     token --> auth: Stored
     auth --> api: 200 OK {access_token, refresh_token}
     api --> fe: Token response
     fe -> fe: Store token in secure storage
     fe --> user: Login successful\nRedirect to dashboard
   end

   note over fe,token
     Token used for all subsequent requests
     in Authorization header
   end note

Participants
============

- **User:** External actor initiating login
- **Frontend Application:** Web or mobile client
- **API Gateway:** Entry point for authentication requests
- **AuthService:** Validates credentials and generates tokens
- **LDAP/AD:** External directory system (user credentials store)
- **TokenStore:** Database storing refresh tokens

Sequence Steps
==============

1. User submits login credentials (email, password) via UI
2. Frontend sends credentials to API endpoint
3. API forwards validation request to AuthService
4. AuthService queries LDAP/AD to verify credentials
5. **Decision Point:** Credentials valid?
   - **NO:** Return 401 error; user retries
   - **YES:** Check MFA requirement
6. **Decision Point:** Is MFA required?
   - **YES:** Send MFA challenge; user provides code

     - **Sub-decision:** Code valid and not expired?
       - **NO:** Request retry
       - **YES:** Proceed to token generation

   - **NO:** Proceed directly to token generation
7. AuthService generates JWT token with 8-hour expiration
8. AuthService stores refresh token in TokenStore (30-day expiration)
9. API returns tokens to Frontend
10. Frontend stores tokens securely (localStorage/sessionStorage/Secure cookie)
11. User logged in; redirected to dashboard

Error Handling
==============

- **Invalid Credentials:** Increment failed attempt counter; show error after 3 attempts, lock account after 5 within 15 minutes
- **MFA Timeout:** Code expires after 5 minutes; user must request new code
- **LDAP Unavailable:** Fallback to cached credentials if recently verified (max 1 hour old)
- **Token Generation Failure:** Return 500; user must retry login

Security Notes
==============

- Credentials transmitted over HTTPS only (TLS 1.2+)
- Password never logged or cached
- Token stored securely (Secure + HttpOnly cookies recommended)
- Refresh token only used for getting new access tokens
- CORS headers configured to prevent cross-site attacks

---

**Diagram Status:** ✅ Production
**Last Updated:** 2026-04-26
**Related Module:** AUTH

.. _uc-auth-01-parte-09:

==================================
Parte 9 — Criterios de aceptacion
==================================

Cada escenario del UC (1 nominal + 4 alternos +
8 excepciones de Partes 3, 4 y 5) tiene su
criterio de aceptacion en formato
**DADO / CUANDO / ENTONCES**, con asserts
verificables y trazabilidad al test
correspondiente de Parte 12.

9.1 Criterios del flujo principal
=================================

CA-01: Login exitoso de User ACTIVE sin Sessions previas
--------------------------------------------------------

::

   DADO   un User U con state=ACTIVE,
          first_login=false,
          password no proximo a expirar,
          sin Sessions con state=ACTIVE,
          dentro del limite de throttling
   CUANDO el cliente envia POST /api/auth/login/
          con username y password correctos via HTTPS
   ENTONCES la respuesta tiene status 200 OK
     Y el body contiene tokens.access y tokens.refresh
       no vacios
     Y el body contiene user.user_id == U.user_id
     Y el body contiene session.session_id no vacio
     Y el body contiene next_step == null
     Y el body contiene warning == null
     Y existe en BD una Session nueva con
       state='ACTIVE', user_id=U.user_id,
       expires_at = started_at + 15 min
     Y existe en BD un AuditEvent con
       event_type='LOGIN', actor_user_id=U.user_id
     Y User.last_login_at fue actualizado a una
       fecha cercana a NOW()
     Y el payload del AuditEvent NO contiene password
       ni tokens (CNST-026)

   TEST: test_login_happy_path

CA-02: Login exitoso con Sessions previas (CNST-004)
----------------------------------------------------

::

   DADO   un User U con state=ACTIVE
     Y    una Session S1 previa con state=ACTIVE,
          user_id=U.user_id
   CUANDO el cliente envia login correcto via HTTPS
   ENTONCES status 200 OK
     Y existe Session nueva S2 con state='ACTIVE'
     Y la Session S1 ahora tiene state='CLOSED',
       close_reason='SUPERSEDED', closed_at no vacio
     Y existe AuditEvent SESSION_CLOSED para S1
     Y existe AuditEvent LOGIN para S2
     Y existe mensaje en InternalMailbox del User
       (si client_info de S1 != client_info de S2)

   TEST: test_login_supersedes_previous_session

CA-03: Atomicidad de la transaccion (paso 10-14)
------------------------------------------------

::

   DADO   un User U con state=ACTIVE
   CUANDO la BD falla durante el INSERT del AuditEvent
          (paso 13) DESPUES del INSERT de la Session
          (paso 11)
   ENTONCES status 503 DB_TRANSIENT_ERROR
     Y NO existe Session nueva en BD (rollback)
     Y NO existe AuditEvent LOGIN en BD
     Y la transaccion completa fue revertida
     Y NO se emitieron tokens JWT al cliente

   TEST: test_login_rollback_on_db_failure

9.2 Criterios de flujos alternos
================================

CA-04: FA-01 primer login fuerza UC_AUTH_04
-------------------------------------------

::

   DADO   un User U con state=ACTIVE,
          first_login=true,
          password correcto
   CUANDO el cliente envia login correcto
   ENTONCES status 200 OK
     Y next_step == "change_password"
     Y la Session creada tiene scope reducido
       (solo permite invocar UC_AUTH_04 y UC_AUTH_02)
     Y existe AuditEvent LOGIN con payload
       {first_login: true}
     Y User.first_login permanece true hasta que
       UC_AUTH_04 complete con exito

   TEST: test_login_first_login_redirects_to_change_password

CA-05: FA-02 password proximo a expirar (opcional)
--------------------------------------------------

::

   DADO   un User U con state=ACTIVE,
          first_login=false,
          password_expires_at dentro de la ventana
          de aviso definida en ADR
   CUANDO el cliente envia login correcto
   ENTONCES status 200 OK
     Y warning.type == "password_expiring"
     Y warning.days_remaining > 0
     Y la Session creada tiene scope pleno (no reducido)
     Y el cliente puede declinar el cambio y operar
       normalmente

   TEST: test_login_warns_when_password_expiring

CA-06: FA-04 User sin permisos
------------------------------

::

   DADO   un User U con state=ACTIVE,
          sin Assignments con state=ACTIVE
   CUANDO el cliente envia login correcto
   ENTONCES status 200 OK
     Y warning.type == "no_permissions"
     Y existe AuditEvent extra LOGIN_NO_PERMISSIONS
       (para alertar a AGR-006 user_admin_group)
     Y la Session se crea con scope normal
       pero la UI no tiene contenido funcional

   TEST: test_login_warns_when_no_permissions

9.3 Criterios de excepciones
============================

CA-07: EX-01 username inexistente
---------------------------------

::

   DADO   ningun User con username 'nonexistent'
   CUANDO el cliente envia POST /api/auth/login/
          con username='nonexistent'
   ENTONCES status 401 Unauthorized
     Y error.code == "INVALID_CREDENTIALS"
     Y error.message es generico (no revela
       enumeracion)
     Y existe AuditEvent LOGIN_FAILED con
       payload.cause == "USER_NOT_FOUND"
     Y NO se crea Session
     Y el contador de throttling por IP se incrementa

   TEST: test_login_user_not_found

CA-08: EX-02 password incorrecto
--------------------------------

::

   DADO   un User U con state=ACTIVE
   CUANDO el cliente envia username correcto
          pero password incorrecto
   ENTONCES status 401 Unauthorized
     Y error.code == "INVALID_CREDENTIALS"
     Y existe AuditEvent LOGIN_FAILED con
       payload.cause == "BAD_PASSWORD"
     Y los contadores de throttling por IP **y**
       por user_id se incrementan
     Y NO se crea Session

   TEST: test_login_bad_password

CA-09: EX-03 cuenta bloqueada
-----------------------------

::

   DADO   un User U con state=BLOCKED
   CUANDO el cliente envia login (incluso con
          credenciales correctas)
   ENTONCES status 403 Forbidden
     Y error.code == "ACCOUNT_BLOCKED"
     Y existe AuditEvent LOGIN_BLOCKED
     Y NO se valida el password (paso 9 no se
       ejecuta — fail-fast)

   TEST: test_login_blocked_account

CA-10: EX-04 cuenta inactiva (BR-009 v2.0.0)
--------------------------------------------

::

   DADO   un User U con state=INACTIVE
          (soft-delete BR-009 v2.0.0)
   CUANDO el cliente envia login
   ENTONCES status 403 Forbidden
     Y error.code == "ACCOUNT_INACTIVE"
     Y existe AuditEvent LOGIN_INACTIVE

   TEST: test_login_inactive_account

CA-11: EX-05 throttling excedido (CNST-011)
-------------------------------------------

::

   DADO   un IP que ya excedio el limite de
          intentos definido en CNST-011
   CUANDO el cliente envia un nuevo login
   ENTONCES status 429 Too Many Requests
     Y error.code == "RATE_LIMITED"
     Y header Retry-After presente con segundos
     Y existe AuditEvent LOGIN_THROTTLED
     Y el contador NO se incrementa adicionalmente

   TEST: test_login_rate_limited

CA-12: EX-06 datos malformados
------------------------------

::

   DADO   un cliente que envia body invalido
          (e.g. username vacio o password de
          longitud < 8)
   CUANDO el endpoint procesa el request
   ENTONCES status 400 Bad Request
     Y error.code == "VALIDATION_ERROR"
     Y error.fields contiene detalle por campo
     Y NO se emite AuditEvent (no hay User
       identificado)
     Y el contador de throttling por IP se
       incrementa (anti-fuzzing)

   TEST: test_login_validation_error

9.4 Criterios transversales
===========================

CA-13: HTTPS obligatorio
------------------------

::

   DADO   un cliente que intenta POST por HTTP
          (no HTTPS)
   CUANDO el request llega al servidor
   ENTONCES la respuesta es 403 Forbidden
          o un redirect 301/308 a HTTPS
     Y NO se procesa el body en HTTP plano
     Y la password nunca se loguea
     Y header HSTS presente en respuesta HTTPS

   TEST: test_login_https_required

CA-14: AuditEvent inmutable (CNST-025)
--------------------------------------

::

   DADO   un AuditEvent LOGIN ya emitido
   CUANDO un actor intenta UPDATE o DELETE
          sobre la tabla audit_event
   ENTONCES la BD rechaza la operacion
     Y el evento permanece intacto
     Y existe trigger / constraint que enforce
       append-only

   TEST: test_audit_event_immutable

CA-15: PII no aparece en logs ni audit (CNST-026)
-------------------------------------------------

::

   DADO   un login (exitoso o fallido)
   CUANDO se inspeccionan logs aplicativos
          (CNST-024) y AuditEvent payload
   ENTONCES NUNCA aparece la password en plano
     Y NUNCA aparecen los tokens JWT en plano
     Y NUNCA aparecen datos personales sensibles
       en contextos no autorizados

   TEST: test_no_pii_in_logs
   TEST: test_no_pii_in_audit_payload

CA-16: Performance < SLA CNST-017
---------------------------------

::

   DADO   el endpoint corriendo en condiciones
          normales (BD operativa, sin saturacion
          de throttling)
   CUANDO se mide la latencia de login en P95
          sobre 1000 requests
   ENTONCES la latencia P95 esta dentro del SLA
          declarado en CNST-017
     Y la latencia P99 no excede 2x el P95
     Y el bcrypt domina la latencia (es esperado
       y aceptable)

   TEST: test_login_performance_sla

9.5 Resumen de cobertura
========================

.. list-table::
 :widths: 20 32 25 23
 :header-rows: 1

 * - ID
   - Escenario
   - Tipo
   - Test mapeado
 * - CA-01
   - Login exitoso sin Session previa
   - Flujo principal
   - test_login_happy_path
 * - CA-02
   - Login con Session previa CNST-004
   - Principal + FA-03
   - test_login_supersedes_previous_session
 * - CA-03
   - Atomicidad transaccion
   - Resiliencia
   - test_login_rollback_on_db_failure
 * - CA-04
   - FA-01 primer login
   - Alterno
   - test_login_first_login
 * - CA-05
   - FA-02 password proximo a expirar
   - Alterno
   - test_login_warns_password_expiring
 * - CA-06
   - FA-04 sin permisos
   - Alterno
   - test_login_warns_no_permissions
 * - CA-07
   - EX-01 username inexistente
   - Excepcion
   - test_login_user_not_found
 * - CA-08
   - EX-02 password incorrecto
   - Excepcion
   - test_login_bad_password
 * - CA-09
   - EX-03 cuenta bloqueada
   - Excepcion
   - test_login_blocked_account
 * - CA-10
   - EX-04 cuenta inactiva
   - Excepcion
   - test_login_inactive_account
 * - CA-11
   - EX-05 throttling
   - Excepcion
   - test_login_rate_limited
 * - CA-12
   - EX-06 datos malformados
   - Excepcion
   - test_login_validation_error
 * - CA-13
   - HTTPS obligatorio
   - Transversal
   - test_login_https_required
 * - CA-14
   - AuditEvent inmutable
   - Transversal
   - test_audit_event_immutable
 * - CA-15
   - PII no en logs/audit
   - Transversal
   - test_no_pii_in_logs / payload
 * - CA-16
   - Performance SLA
   - Transversal
   - test_login_performance_sla

Total: **16 criterios de aceptacion** que mapean
1:1 a tests de Parte 12.

.. _uc-auth-02-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

Cada CA esta en formato DADO/CUANDO/ENTONCES con
asserts verificables (Given-When-Then). Los CA
constituyen la fuente de verdad para test de
aceptacion automatizados.

9.1 CA-01: Logout exitoso flujo principal
=========================================

**DADO** un usuario con Session ACTIVE y access
token valido,

**CUANDO** envia ``POST /api/auth/logout/`` con
header ``Authorization: Bearer <token>`` y body
``{refresh_token: ...}``,

**ENTONCES**:

- Status response = 200
- ``Session.state == 'CLOSED'``
- ``Session.close_reason == 'USER_LOGOUT'``
- ``Session.closed_at`` no NULL
- 2 entries en ``BlacklistedToken`` (access +
  refresh)
- 1 ``AuditEvent`` con
  ``event_type='LOGOUT'``,
  ``actor_user_id`` correcto
- Body response contiene ``message`` y
  ``logout_at``

9.2 CA-02: Logout idempotente (FA-02)
=====================================

**DADO** una Session ya CLOSED (close_reason
``USER_LOGOUT``),

**CUANDO** se envia un segundo logout con el
mismo (ahora invalido) token,

**ENTONCES**:

- Status response = 401 (token en blacklist)

  *Alternativa segun politica*: 200 con mensaje
  "Sesion ya estaba cerrada" si el token aun no
  esta blacklisteado.

- ``Session.close_reason`` permanece
  ``USER_LOGOUT`` (no sobrescrito)
- AuditEvent ``LOGOUT_REPLAY`` emitido

9.3 CA-03: Logout sin refresh token (FA-01)
===========================================

**DADO** un usuario con Session ACTIVE,

**CUANDO** envia logout sin body (solo header),

**ENTONCES**:

- Status response = 200
- ``Session.state == 'CLOSED'``
- 1 entry en ``BlacklistedToken`` (solo access)
- AuditEvent payload incluye
  ``refresh_token_invalidated: false``

9.4 CA-04: Token invalido rechazado (EX-01)
===========================================

**DADO** un token JWT con firma invalida o
expirado,

**CUANDO** se envia logout,

**ENTONCES**:

- Status response = 401
- Body ``error == 'INVALID_TOKEN'``
- Sin cambios en BD

9.5 CA-05: User mismatch detectado (EX-03)
==========================================

**DADO** un token cuyo ``user_id`` no matchea
con el ``Session.user_id``,

**CUANDO** se envia logout,

**ENTONCES**:

- Status response = 401
- Body ``error == 'USER_MISMATCH'``
- AuditEvent ``LOGOUT_FAILED`` con
  ``reason='user_mismatch'``
- Alerta de seguridad disparada (UC_ALR_*)

9.6 CA-06: Atomicidad ante falla de blacklist (EX-05)
=====================================================

**DADO** un sistema donde la tabla
``BlacklistedToken`` es inalcanzable,

**CUANDO** se envia logout,

**ENTONCES**:

- Status response = 500
- ``Session.state`` permanece ``ACTIVE``
- Sin AuditEvent ``LOGOUT`` exitoso (solo
  ``LOGOUT_FAILED``)

9.7 CA-07: Atomicidad ante falla de audit (EX-06)
=================================================

**DADO** un sistema donde el INSERT en
AuditEvent falla,

**CUANDO** se envia logout,

**ENTONCES**:

- Status response = 500
- ``Session.state`` permanece ``ACTIVE``
- Tokens NO blacklisteados (rollback completo)

9.8 CA-08: Rate limit (EX-07)
=============================

**DADO** una IP que ya envio mas de N requests
en la ventana,

**CUANDO** envia el N+1,

**ENTONCES**:

- Status response = 429
- Header ``Retry-After`` presente
- Sin tocar BD

9.9 CA-09: Frontend cleanup
===========================

**DADO** una respuesta 200 OK del backend,

**CUANDO** el frontend recibe la respuesta,

**ENTONCES**:

- ``localStorage.access_token`` removido
- ``localStorage.refresh_token`` removido
- Redux ``state.auth.isAuthenticated == false``
- Navegacion a ``/login`` ejecutada
- Mensaje "Tu sesion fue cerrada" visible

9.10 CA-10: Token rechazado post-logout
=======================================

**DADO** un logout exitoso,

**CUANDO** el cliente intenta usar el access
token contra cualquier endpoint protegido,

**ENTONCES**:

- Status response = 401
- DRF middleware detecta blacklist y rechaza

9.11 CA-11: Performance P50
===========================

**DADO** carga normal (10 req/seg sostenidos),

**CUANDO** se mide el tiempo end-to-end,

**ENTONCES**:

- Mediana ≤ 80 ms (request → 200 OK)

9.12 CA-12: Performance P99
===========================

**DADO** carga sostenida con pico de 100 req/seg,

**CUANDO** se mide P99 sobre 1000 requests,

**ENTONCES**:

- P99 ≤ 250 ms

9.13 CA-13: Auditabilidad inmutable (CNST-025)
==============================================

**DADO** un AuditEvent LOGOUT emitido,

**CUANDO** se intenta UPDATE o DELETE,

**ENTONCES**:

- BD rechaza (trigger / constraint
  append-only)
- AuditEvent intacto

9.14 CA-14: Sin PII en payload (CNST-026)
=========================================

**DADO** un AuditEvent LOGOUT,

**CUANDO** se inspecciona ``payload``,

**ENTONCES**:

- No contiene email, RUT, nombre completo
- Solo IDs (user_id, session_id), IP,
  user_agent, close_reason

9.15 CA-15: HTTPS obligatorio
=============================

**DADO** un request HTTP plano (no HTTPS),

**CUANDO** llega al endpoint,

**ENTONCES**:

- Apache redirige a HTTPS o devuelve 403

9.16 CA-16: AGR no requerido
============================

**DADO** un User sin Assignments AGR,

**CUANDO** ejecuta logout,

**ENTONCES**:

- Logout exitoso (sesion propia no requiere
  AGR explicito)

9.17 Resumen de CA
==================

.. list-table::
 :widths: 10 50 40
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01
   - Flujo principal
   - Funcional
 * - CA-02
   - Idempotencia
   - Funcional
 * - CA-03
   - Sin refresh token
   - Funcional
 * - CA-04
   - Token invalido
   - Funcional / seguridad
 * - CA-05
   - User mismatch
   - Seguridad
 * - CA-06
   - Atomicidad blacklist
   - Confiabilidad
 * - CA-07
   - Atomicidad audit
   - Confiabilidad
 * - CA-08
   - Rate limit
   - Seguridad
 * - CA-09
   - Frontend cleanup
   - Funcional
 * - CA-10
   - Token rechazado post-logout
   - Seguridad
 * - CA-11
   - P50 latencia
   - Performance
 * - CA-12
   - P99 latencia
   - Performance
 * - CA-13
   - Audit inmutable
   - CNST-025
 * - CA-14
   - Sin PII
   - CNST-026
 * - CA-15
   - HTTPS
   - Seguridad
 * - CA-16
   - Sin AGR requerido
   - RBAC

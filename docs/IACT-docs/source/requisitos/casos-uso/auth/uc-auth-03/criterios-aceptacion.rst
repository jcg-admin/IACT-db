.. _uc-auth-03-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Reset exitoso flujo principal
========================================

**DADO** un admin con AGR-006 user_admin_group y
un User destino valido,

**CUANDO** envia ``POST /api/users/{id}/reset-password/``,

**ENTONCES**:

- Status response = 200
- ``User.password_hash`` cambia (verificable
  con bcrypt.checkpw del temp_pwd nuevo)
- ``User.first_login == true``
- ``User.password_changed_at`` no NULL y
  reciente
- 1 ``InternalMessage`` en buzon del User con
  subject "Contrasena temporal" y body que
  contiene la contrasena
- 1 ``AuditEvent`` con
  ``event_type='PASSWORD_RESET'``,
  ``actor_user_id=admin``,
  ``payload.target_user_id=user``
- Body response NO contiene la contrasena
  temporal

9.2 CA-02: Sin contrasena en response
=====================================

**DADO** cualquier reset exitoso,

**CUANDO** se inspecciona la response,

**ENTONCES**:

- ``temp_password`` ausente en cualquier campo
- ``password``, ``new_password``, ``temp`` no
  aparecen como keys

9.3 CA-03: Sin contrasena en logs
=================================

**DADO** un reset exitoso,

**CUANDO** se inspecciona el log de la
aplicacion,

**ENTONCES**:

- La contrasena temporal NO aparece en ningun
  log line

9.4 CA-04: Sessions cerradas
============================

**DADO** un User con N Sessions ACTIVE,

**CUANDO** se le resetea la contrasena,

**ENTONCES**:

- N Sessions con
  ``state == 'CLOSED'`` y
  ``close_reason == 'PASSWORD_RESET'``
- Tokens correspondientes blacklisteados

9.5 CA-05: First login forzado
==============================

**DADO** un reset exitoso,

**CUANDO** el User intenta UC_AUTH_01 con la
contrasena temporal,

**ENTONCES**:

- Login exitoso pero ``next_step ==
  'change_password'`` en response
- UC_AUTH_04 obligatorio antes de operar

9.6 CA-06: Auto-reset rechazado (EX-04)
=======================================

**DADO** un admin con AGR-006,

**CUANDO** intenta resetearse a si mismo,

**ENTONCES**:

- Status = 400
- Body ``error == 'SELF_RESET_FORBIDDEN'``
- Sin cambios en BD
- AuditEvent ``PASSWORD_RESET_FAILED`` con
  ``reason='self_reset_attempt'``

9.7 CA-07: Sin permiso (EX-02)
==============================

**DADO** un admin sin la funcion
``reset_password``,

**CUANDO** intenta el reset,

**ENTONCES**:

- Status = 403
- AuditEvent ``UNAUTHORIZED_ACCESS_ATTEMPT``
- Sin cambios en BD

9.8 CA-08: User no existe (EX-03)
=================================

**DADO** un user_id inexistente,

**CUANDO** se invoca el endpoint,

**ENTONCES**:

- Status = 404
- AuditEvent ``PASSWORD_RESET_FAILED``

9.9 CA-09: User ELIMINATED (EX-05)
==================================

**DADO** un User con state ELIMINATED,

**CUANDO** se invoca,

**ENTONCES**:

- Status = 400
- Body ``error == 'USER_ELIMINATED'``

9.10 CA-10: User BLOCKED (FA-01)
================================

**DADO** un User con state BLOCKED,

**CUANDO** se le resetea,

**ENTONCES**:

- Status = 200
- ``User.password_hash`` cambia
- ``User.state == 'BLOCKED'`` permanece
- Body incluye ``warning: "User BLOCKED..."``

9.11 CA-11: Atomicidad mailbox (EX-07)
======================================

**DADO** una falla en INSERT InternalMessage,

**CUANDO** se procesa el reset,

**ENTONCES**:

- Status = 500
- ``User.password_hash`` SIN cambiar (rollback)
- Sessions intactas

9.12 CA-12: Atomicidad audit (EX-09)
====================================

**DADO** una falla en INSERT AuditEvent,

**CUANDO** se procesa el reset,

**ENTONCES**:

- Status = 500
- ``User.password_hash`` SIN cambiar
- Sin InternalMessage creado

9.13 CA-13: CNST-001 prohibicion email
======================================

**DADO** un reset exitoso,

**CUANDO** se monitorean las llamadas a
librerias de email/SMTP,

**ENTONCES**:

- ZERO llamadas a ``smtplib``,
  ``django.core.mail.send_mail``, webhooks
- El test debe fallar si alguien introduce un
  ``send_mail`` accidentalmente

9.14 CA-14: CNST-002 mailbox obligatorio
========================================

**DADO** un reset exitoso,

**CUANDO** se cuenta InternalMessage del User,

**ENTONCES**:

- Existe exactamente 1 mensaje recien creado
  con la contrasena en el body

9.15 CA-15: CNST-025 audit inmutable
====================================

**DADO** un AuditEvent PASSWORD_RESET emitido,

**CUANDO** se intenta UPDATE/DELETE,

**ENTONCES**:

- BD rechaza (constraint append-only)

9.16 CA-16: CNST-026 sin PII
============================

**DADO** un AuditEvent PASSWORD_RESET,

**CUANDO** se inspecciona payload,

**ENTONCES**:

- No contiene email, full_name, RUT del User
  destino
- Solo IDs, IP, user_agent, contadores

9.17 CA-17: Throttling (EX-08)
==============================

**DADO** un admin que ejecuto 10 resets en
5 min,

**CUANDO** intenta el 11°,

**ENTONCES**:

- Status = 429
- ``Retry-After`` header presente

9.18 CA-18: Performance P50
===========================

**DADO** un reset normal,

**CUANDO** se mide tiempo end-to-end,

**ENTONCES**:

- P50 ≤ 250 ms (incluyendo bcrypt cost 12)

9.19 CA-19: Frontend no muestra contrasena
==========================================

**DADO** un reset exitoso,

**CUANDO** se renderiza el feedback al admin,

**ENTONCES**:

- DOM no contiene la cadena de la contrasena
  temporal

9.20 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..05
   - Flujo principal + first_login
   - Funcional
 * - CA-06..09
   - Excepciones (self, perm, user)
   - Funcional / seguridad
 * - CA-10
   - FA-01 BLOCKED
   - Funcional
 * - CA-11..12
   - Atomicidad transaccion
   - Confiabilidad
 * - CA-13..16
   - CNSTs (no email, mailbox, audit, PII)
   - Cumplimiento
 * - CA-17
   - Rate limit
   - Seguridad
 * - CA-18
   - P50 latencia
   - Performance
 * - CA-19
   - No leak en UI
   - Seguridad

.. _uc-usr-01-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Creacion exitosa flujo principal
===========================================

**DADO** un admin con AGR-006 y datos validos
``{first:Ana, last:Gomez, email:ana.gomez@empresa.com,
agr_id:6}``,

**CUANDO** envia POST,

**ENTONCES**:

- Status = 201
- ``User.username == 'ana.gomez.0001'``
- ``User.first_login == true``
- ``User.state == 'ACTIVE'``
- ``User.password_hash`` no vacio (bcrypt valido)
- 1 ``Assignment`` activo con AGR-006
- 1 ``InternalMessage`` en buzon del nuevo User
- 1 ``AuditEvent USER_CREATED``
- Body NO contiene contrasena

9.2 CA-02: Sin contrasena en response
=====================================

**DADO** cualquier creacion exitosa,

**ENTONCES**:

- Body 201 NO contiene ``password``,
  ``temp_password``, ``new_password``

9.3 CA-03: Sin contrasena en logs
=================================

**DADO** una creacion exitosa,

**ENTONCES**:

- La contrasena temporal NO aparece en ningun
  log line

9.4 CA-04: First login forzado
==============================

**DADO** un User creado por UC_USR_01,

**CUANDO** intenta UC_AUTH_01 con la contrasena
temporal,

**ENTONCES**:

- Login exitoso pero ``next_step ==
  'change_password'``
- UC_AUTH_04 obligatorio antes de operar

9.5 CA-05: Sin AGR (FA-01)
==========================

**DADO** request sin ``access_group_id``,

**ENTONCES**:

- Status = 201
- ``Assignment.count() == 0`` para el nuevo
  user
- AuditEvent payload ``has_initial_agr=false``

9.6 CA-06: Username CNST-029
============================

**DADO** request ``{first:Ana, last:Gomez}``,

**ENTONCES**:

- Username generado matchea regex
  ``^[a-z]+\.[a-z]+\.[0-9]{4}$``
- Si ya existe ``ana.gomez.0001``, sufijo
  incremental

9.7 CA-07: Sin permiso (EX-01)
==============================

**DADO** admin sin ``create_users``,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT
- Sin cambios en BD

9.8 CA-08: Email duplicado (EX-02)
==================================

**DADO** email ya registrado,

**ENTONCES**:

- Status = 409
- Sin cambios en BD

9.9 CA-09: Email malformado (EX-03)
===================================

**DADO** ``email='ana.gomez'`` (sin dominio),

**ENTONCES**:

- Status = 400
- Body ``error == 'VALIDATION_ERROR'``

9.10 CA-10: Atomicidad mailbox (EX-06)
======================================

**DADO** falla en INSERT InternalMessage,

**ENTONCES**:

- Status = 500
- ``User.objects.filter(email=...).exists() ==
  False`` (rollback)
- Sin Assignment, sin AuditEvent USER_CREATED

9.11 CA-11: CNST-001 prohibicion email
======================================

**DADO** una creacion exitosa,

**CUANDO** se monitorean librerias de
email/SMTP,

**ENTONCES**:

- ZERO llamadas a ``smtplib``,
  ``django.core.mail.send_mail``, webhooks

9.12 CA-12: CNST-002 mailbox obligatorio
========================================

**DADO** una creacion exitosa,

**ENTONCES**:

- Existe exactamente 1 InternalMessage para el
  nuevo user con la contrasena en el body

9.13 CA-13: CNST-025 audit inmutable
====================================

**DADO** AuditEvent USER_CREATED emitido,

**ENTONCES**:

- BD rechaza UPDATE/DELETE

9.14 CA-14: CNST-026 sin PII
============================

**DADO** AuditEvent payload,

**ENTONCES**:

- No contiene email, full_name del nuevo user
- Solo IDs, IP, user_agent, contadores

9.15 CA-15: Performance P50
===========================

**DADO** carga normal,

**ENTONCES**:

- P50 ≤ 250 ms

9.16 CA-16: Throttling (CNST-011)
=================================

**DADO** admin con 60 creaciones en 1min,

**CUANDO** intenta la 61°,

**ENTONCES**:

- Status = 429

9.17 CA-17: Frontend NO muestra contrasena
==========================================

**DADO** creacion exitosa,

**CUANDO** se renderiza el feedback,

**ENTONCES**:

- DOM no contiene la contrasena temporal

9.18 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..06
   - Flujo principal + first_login + username
   - Funcional
 * - CA-07..09
   - Excepciones permisos / datos
   - Seguridad / Funcional
 * - CA-10
   - Atomicidad
   - Confiabilidad
 * - CA-11..14
   - CNSTs (no email, mailbox, audit, PII)
   - Cumplimiento
 * - CA-15
   - Performance P50
   - Performance
 * - CA-16
   - Rate limit
   - Seguridad
 * - CA-17
   - No leak en UI
   - Seguridad

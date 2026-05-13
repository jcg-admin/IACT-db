.. _uc-usr-03-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Modificacion de datos personales (FA-04)
===================================================

**DADO** un admin con ``modify_users`` y un User
existente,

**CUANDO** envia ``PATCH`` con
``{first_name:'Ana Maria'}``,

**ENTONCES**:

- Status = 200
- ``User.first_name == 'Ana Maria'``
- ``User.last_name`` sin cambio
- ``Session`` ACTIVES del User intactas (no
  side-effect)
- 1 ``AuditEvent USER_MODIFIED`` con
  ``payload.fields_changed == ['first_name']``

9.2 CA-02: Bloqueo (state → BLOCKED, FA-01)
===========================================

**DADO** admin + User con state ACTIVE y 2
Sessions activas,

**CUANDO** envia ``PATCH`` con
``{state:'BLOCKED'}``,

**ENTONCES**:

- Status = 200
- ``User.state == 'BLOCKED'``
- 2 Sessions con ``state='CLOSED'``,
  ``close_reason='ADMIN_BLOCKED'``
- 2 BlacklistedToken creados
- AuditEvent payload incluye
  ``state_transition.{from:'ACTIVE',to:'BLOCKED'}``
  y ``sessions_closed_count == 2``

9.3 CA-03: Desbloqueo (FA-02)
=============================

**DADO** User con state BLOCKED,

**CUANDO** envia ``PATCH``
``{state:'ACTIVE'}``,

**ENTONCES**:

- Status = 200
- ``User.state == 'ACTIVE'``
- AuditEvent state_transition
  ``BLOCKED → ACTIVE``
- Sin cierre adicional de Sessions (no aplica)

9.4 CA-04: Auto-state-change prohibido (EX-04, P-11)
====================================================

**DADO** admin con ``modify_users``,

**CUANDO** envia ``PATCH`` con ``state``
sobre su propio ``user_id``,

**ENTONCES**:

- Status = 400
- ``error == 'SELF_STATE_CHANGE_FORBIDDEN'``
- Sin cambios en BD
- AuditEvent USER_MODIFY_FAILED con
  ``reason='self_state_change'``

9.5 CA-05: Sin permiso 403 (EX-02)
==================================

**DADO** admin sin ``modify_users``,

**CUANDO** envia ``PATCH``,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT
- Sin cambios

9.6 CA-06: User no existe 404 (EX-03)
=====================================

**DADO** ``user_id`` inexistente,

**ENTONCES**:

- Status = 404

9.7 CA-07: Email duplicado 409 (EX-05)
======================================

**DADO** ``email`` provisto ya existe en otro
User,

**ENTONCES**:

- Status = 409 EMAIL_EXISTS
- Sin cambios

9.8 CA-08: Transicion invalida (EX-06)
======================================

**DADO** User con ``state='ELIMINATED'``,

**CUANDO** ``PATCH`` con ``state='ACTIVE'``,

**ENTONCES**:

- Status = 400 INVALID_STATE_TRANSITION

9.9 CA-09: PATCH parcial preserva campos no mencionados
=======================================================

**DADO** User con
``first_name='Ana', last_name='Gomez'``,

**CUANDO** PATCH con solo ``first_name``,

**ENTONCES**:

- ``User.first_name`` cambio
- ``User.last_name == 'Gomez'`` (preservado)

9.10 CA-10: PATCH idempotente
=============================

**DADO** envio el mismo payload dos veces,

**ENTONCES**:

- Estado final del User identico
- 2 AuditEvents emitidos (cada invocacion es
  un evento)
- ``fields_changed`` puede estar vacio en la
  segunda invocacion (nada cambio)

9.11 CA-11: Atomicidad ante falla
=================================

**DADO** falla simulada en el cierre de
Sessions durante ``state → BLOCKED``,

**ENTONCES**:

- Status = 500
- ``User.state`` permanece ACTIVE (rollback)
- Sessions intactas

9.12 CA-12: Audit Event registra fields_changed
===============================================

**DADO** PATCH con ``{first_name, last_name,
state}``,

**ENTONCES**:

- AuditEvent payload contiene
  ``fields_changed == ['first_name',
  'last_name', 'state']``
- payload sin email/full_name del User
  (CNST-026)

9.13 CA-13: AuditEvent inmutable (CNST-025)
===========================================

**DADO** AuditEvent USER_MODIFIED emitido,

**ENTONCES**:

- BD rechaza UPDATE/DELETE

9.14 CA-14: Sin PII en payload (CNST-026)
=========================================

**DADO** AuditEvent USER_MODIFIED,

**ENTONCES**:

- Payload no contiene ``email``, ``full_name``
- Payload contiene IDs y banderas

9.15 CA-15: Performance P50 sin cierre
======================================

**DADO** PATCH sin state cambio,

**ENTONCES**:

- P50 ≤ 120 ms

9.16 CA-16: Performance P50 con BLOCKED
=======================================

**DADO** PATCH con ``state → BLOCKED``,

**ENTONCES**:

- P50 ≤ 250 ms (incluyendo cerrar Sessions)

9.17 CA-17: Throttling (EX-10)
==============================

**DADO** admin con > 60 PATCH/min,

**ENTONCES**:

- Status = 429

9.18 CA-18: Frontend confirmacion para state
============================================

**DADO** admin edita state via UI,

**CUANDO** intenta guardar sin confirmar,

**ENTONCES**:

- Modal de confirmacion robusto antes del
  PATCH
- Si cancela, no se envia request

9.19 CA-19: Notificacion al User si state cambio
================================================

**DADO** politica ``NOTIFY_USER_ON_MODIFY=true``
y state cambio,

**ENTONCES**:

- 1 InternalMessage en buzon del User con
  subject "Tu cuenta fue actualizada"

9.20 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01
   - Modificacion datos personales
   - Funcional
 * - CA-02..03
   - Bloqueo y desbloqueo (state machine)
   - Funcional / state machine
 * - CA-04
   - Auto-state-change prohibido
   - Seguridad / P-11
 * - CA-05..08
   - Excepciones permisos / datos / state
   - Seguridad / Funcional
 * - CA-09..10
   - PATCH semantica (parcial + idempotente)
   - Funcional
 * - CA-11
   - Atomicidad
   - Confiabilidad
 * - CA-12..14
   - Audit + sin PII
   - Cumplimiento
 * - CA-15..16
   - Performance
   - Performance
 * - CA-17
   - Rate limit
   - Seguridad
 * - CA-18..19
   - Usabilidad: confirmacion + notificacion
   - Usabilidad

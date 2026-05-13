.. _uc-usr-04-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Eliminacion exitosa flujo principal
==============================================

**DADO** un invocante con funcion
``deactivate_users`` y un User con state
ACTIVE, 2 Sessions activas, 3 Assignments
activos,

**CUANDO** envia DELETE
``/api/users/{user_id}/``,

**ENTONCES**:

- Status = 200
- ``User.state == 'ELIMINATED'``
- ``User.eliminated_at`` no NULL
- ``User.eliminated_by_admin_id`` == invoker.id
- 3 ``Assignment`` con
  ``state='REVOKED'``,
  ``revoke_reason='USER_ELIMINATED'``
- 2 ``Session`` con
  ``state='CLOSED'``,
  ``close_reason='USER_ELIMINATED'``
- 2 ``BlacklistedToken`` creados
- 1 ``AuditEvent USER_ELIMINATED`` con
  ``payload.sessions_closed_count == 2``,
  ``assignments_revoked_count == 3``
- Body NO contiene PII directa del User

9.2 CA-02: Sin DELETE fisico (BR-009)
=====================================

**DADO** una eliminacion exitosa,

**ENTONCES**:

- ``User.objects.filter(id=target_id).exists()
  == true`` (registro preservado)
- ``User.email`` y ``User.username`` no liberados

9.3 CA-03: Auto-eliminacion prohibida (CA-04 / EX-04)
=====================================================

**DADO** invocante con
``deactivate_users``,

**CUANDO** envia DELETE sobre
``/api/users/{invoker.id}/``,

**ENTONCES**:

- Status = 400
- Body ``error == 'SELF_ELIMINATION_FORBIDDEN'``
- Sin cambios en BD
- AuditEvent USER_ELIMINATE_FAILED con
  ``reason='self_elimination'``

9.4 CA-04: Sin la funcion 403 (EX-02)
=====================================

**DADO** un invocante sin
``deactivate_users``,

**CUANDO** envia DELETE,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT
- Sin cambios

9.5 CA-05: User no encontrado 404 (EX-03)
=========================================

**DADO** ``user_id`` inexistente,

**ENTONCES**:

- Status = 404 USER_NOT_FOUND

9.6 CA-06: Idempotencia default (FA-02)
=======================================

**DADO** User ya con state ELIMINATED,

**CUANDO** se envia segundo DELETE,

**ENTONCES**:

- Status = 200
- Body ``already_eliminated == true``
- ``original_eliminated_at`` preservado
- AuditEvent USER_ELIMINATE_NOOP

9.7 CA-07: Politica strict (opcional)
=====================================

**DADO** setting ``STRICT_ELIMINATION=true`` y
User ya ELIMINATED,

**CUANDO** se envia DELETE,

**ENTONCES**:

- Status = 409 USER_ALREADY_ELIMINATED

9.8 CA-08: Sessions cerradas y tokens blacklisted
=================================================

**DADO** una eliminacion exitosa,

**CUANDO** un cliente intenta usar uno de los
tokens del User eliminado,

**ENTONCES**:

- Status = 401 (token blacklisteado)

9.9 CA-09: Login post-eliminacion rechazado
===========================================

**DADO** User eliminado,

**CUANDO** intenta UC_AUTH_01 con sus
credenciales,

**ENTONCES**:

- Status = 401
- Body indica ``reason='account_eliminated'``
- AuditEvent LOGIN_FAILED

9.10 CA-10: Atomicidad ante falla
=================================

**DADO** simulacion de falla en cierre de
Sessions o INSERT AuditEvent,

**ENTONCES**:

- Status = 500
- ``User.state`` permanece anterior (rollback)
- Assignments intactos
- Sessions intactas

9.11 CA-11: Mailbox-or-abort softer (EX-09)
===========================================

**DADO** falla simulada en INSERT
InternalMessage y politica notify=true,

**ENTONCES**:

- Status = 200 (operacion procede)
- Body ``mailbox_failed == true``,
  ``user_notified == false``
- ``User.state == 'ELIMINATED'``
- Sessions cerradas
- Assignments revocados
- AuditEvent emitido

9.12 CA-12: Audit sin PII (CNST-026)
====================================

**DADO** AuditEvent USER_ELIMINATED,

**ENTONCES**:

- Payload no contiene ``email``,
  ``full_name``
- Payload contiene IDs y contadores

9.13 CA-13: Audit inmutable (CNST-025)
======================================

**DADO** AuditEvent emitido,

**ENTONCES**:

- BD rechaza UPDATE/DELETE

9.14 CA-14: Email no reutilizable (DEC-USR04-05)
================================================

**DADO** User ELIMINATED con email X,

**CUANDO** otro admin invoca UC_USR_01 con
email X,

**ENTONCES**:

- Status = 409 EMAIL_EXISTS (UC_USR_01 EX-02)
- email del User ELIMINATED preservado

9.15 CA-15: Performance P50
===========================

**DADO** User tipico (1-3 Sessions, 1-5
Assignments),

**ENTONCES**:

- P50 ≤ 300 ms

9.16 CA-16: Throttling (EX-08)
==============================

**DADO** invocante con > 30 DELETE/min,

**ENTONCES**:

- Status = 429

9.17 CA-17: Frontend modal robusto
==================================

**DADO** invocante en UI,

**CUANDO** intenta eliminar sin escribir
"ELIMINAR" literal,

**ENTONCES**:

- Boton "Confirmar" deshabilitado
- Sin DELETE request

9.18 CA-18: Boton oculto sin la funcion
=======================================

**DADO** invocante sin
``deactivate_users``,

**CUANDO** abre detalle de un User,

**ENTONCES**:

- Boton "Eliminar" no es visible (ni
  habilitado)

9.19 CA-19: Resumen post-eliminacion
====================================

**DADO** eliminacion exitosa con N=2,M=3,

**CUANDO** se renderiza el feedback,

**ENTONCES**:

- Toast incluye "{N} sesiones cerradas, {M}
  permisos revocados"

9.20 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01
   - Eliminacion exitosa
   - Funcional
 * - CA-02
   - Sin DELETE fisico (BR-009)
   - Cumplimiento
 * - CA-03
   - Auto-eliminacion prohibida (P-11)
   - Seguridad
 * - CA-04
   - Sin la funcion → 403
   - Seguridad
 * - CA-05
   - User no existe → 404
   - Funcional
 * - CA-06..07
   - Idempotencia default vs strict
   - Funcional / configurable
 * - CA-08
   - Tokens blacklisteados rechazados
   - Seguridad
 * - CA-09
   - Login post-eliminacion rechazado
   - Seguridad
 * - CA-10
   - Atomicidad
   - Confiabilidad
 * - CA-11
   - Mailbox-or-abort softer
   - Confiabilidad
 * - CA-12..13
   - Audit (sin PII + inmutable)
   - Cumplimiento
 * - CA-14
   - Email no reutilizable
   - Seguridad / DEC-USR04-05
 * - CA-15
   - Performance P50
   - Performance
 * - CA-16
   - Rate limit
   - Seguridad
 * - CA-17..19
   - UX (modal, visibilidad, feedback)
   - Usabilidad

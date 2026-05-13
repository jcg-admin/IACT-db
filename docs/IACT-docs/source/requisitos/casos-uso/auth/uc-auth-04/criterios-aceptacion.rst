.. _uc-auth-04-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Cambio exitoso flujo principal
=========================================

**DADO** un User autenticado con
``current_password=Pass123!``,

**CUANDO** envia POST con ``new_password=
MiNueva2026!@`` (cumple politica),

**ENTONCES**:

- Status = 200
- ``User.password_hash`` cambia
- ``User.first_login == false``
- 1 nueva entry en PasswordHistory
- 1 AuditEvent PASSWORD_CHANGED
- Body NO contiene la contrasena nueva

9.2 CA-02: Password actual incorrecto (EX-02)
=============================================

**DADO** ``current_password`` incorrecto,

**ENTONCES**:

- Status = 400, error WRONG_CURRENT_PASSWORD
- ``User`` sin cambios
- Tiempo de respuesta no es claramente menor
  que el caso valido (defensa timing)

9.3 CA-03: Politica violada (EX-03)
===================================

**DADO** ``new_password=abc``,

**ENTONCES**:

- Status = 400, error WEAK_PASSWORD
- ``violations`` lista al menos
  ``min_length``, ``missing_uppercase``,
  ``missing_digit``, ``missing_symbol``

9.4 CA-04: Reuso (EX-04)
========================

**DADO** un User con N=5 cambios anteriores,

**CUANDO** intenta cambiar a la misma que tenia
hace 3 cambios,

**ENTONCES**:

- Status = 400, error PASSWORD_REUSED

9.5 CA-05: Igual a actual (EX-05)
=================================

**DADO** ``new_password == current_password``,

**ENTONCES**:

- Status = 400, error SAME_AS_CURRENT

9.6 CA-06: Mismatch (EX-06)
===========================

**DADO** ``new_password != confirmation``,

**ENTONCES**:

- Status = 400, error MISMATCH

9.7 CA-07: Brute force lockout (EX-08)
======================================

**DADO** 5 intentos fallidos de current_password
en 5min,

**CUANDO** el 6° llega,

**ENTONCES**:

- Status = 429 TOO_MANY_ATTEMPTS
- AuditEvent SUSPICIOUS_PASSWORD_CHANGE_ATTEMPTS

9.8 CA-08: Sesion scope upgrade (FA-01)
=======================================

**DADO** un User con
``first_login=true`` y Session scope reducido,

**CUANDO** UC_AUTH_04 exitoso,

**ENTONCES**:

- ``User.first_login == false``
- Body ``scope_upgraded == true``
- Subsequent requests al backend con permisos
  plenos

9.9 CA-09: Otras sesiones cerradas
==================================

**DADO** un User con 3 sesiones (incluyendo la
actual) y setting CLOSE_OTHER_SESSIONS=true,

**CUANDO** UC_AUTH_04 exitoso,

**ENTONCES**:

- Las 2 otras Sessions con
  ``state=CLOSED``,
  ``close_reason='PASSWORD_CHANGED'``
- Sus tokens en blacklist
- La Session actual NO cerrada
- Body ``other_sessions_closed == 2``

9.10 CA-10: Politica laxa (FA-02)
=================================

**DADO** setting CLOSE_OTHER_SESSIONS=false,

**CUANDO** UC_AUTH_04 exitoso,

**ENTONCES**:

- Otras Sessions intactas
- ``other_sessions_closed == 0``

9.11 CA-11: Atomicidad
======================

**DADO** una falla en INSERT PasswordHistory,

**CUANDO** se procesa el cambio,

**ENTONCES**:

- Status = 500
- ``User.password_hash`` SIN cambiar (rollback)
- ``User.first_login`` SIN cambiar

9.12 CA-12: Sin contrasena en logs
==================================

**DADO** un cambio (exitoso o fallido),

**CUANDO** se inspecciona el log,

**ENTONCES**:

- ``current_password`` y ``new_password`` no
  aparecen en ningun mensaje de log

9.13 CA-13: Sin contrasena en payload de audit
==============================================

**DADO** un AuditEvent PASSWORD_CHANGED,

**ENTONCES**:

- ``payload`` no contiene la contrasena
  (ni hash) ni email/full_name del User
  (CNST-026)

9.14 CA-14: Performance P50
===========================

**DADO** carga normal,

**ENTONCES**:

- P50 ≤ 350 ms

9.15 CA-15: Audit inmutable (CNST-025)
======================================

**DADO** un AuditEvent emitido,

**CUANDO** se intenta UPDATE/DELETE,

**ENTONCES**:

- BD rechaza

9.16 CA-16: BLOCKED puede cambiar (FA-04)
=========================================

**DADO** un User con state=BLOCKED,

**CUANDO** invoca UC_AUTH_04 con credentials
correctas,

**ENTONCES**:

- Status = 200
- ``User.state == 'BLOCKED'`` permanece

9.17 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01
   - Flujo principal
   - Funcional
 * - CA-02..06
   - Excepciones validacion
   - Funcional / seguridad
 * - CA-07
   - Brute force
   - Seguridad
 * - CA-08
   - Scope upgrade FA-01
   - Funcional
 * - CA-09..10
   - Politica de cierre other sessions
   - Funcional
 * - CA-11
   - Atomicidad
   - Confiabilidad
 * - CA-12..13
   - No-leak (logs, audit payload)
   - Cumplimiento
 * - CA-14
   - P50
   - Performance
 * - CA-15
   - Audit inmutable
   - CNST-025
 * - CA-16
   - BLOCKED
   - Funcional

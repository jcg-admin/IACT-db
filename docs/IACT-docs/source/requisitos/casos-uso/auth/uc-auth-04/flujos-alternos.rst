.. _uc-auth-04-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Cambio post first_login
==================================

**Activador**: el User llega a este UC porque
``User.first_login=true`` (UC_AUTH_01 lo
redirigio).

**Justificacion**: la Session emitida por
UC_AUTH_01 + FA-01 tiene scope reducido — solo
permite UC_AUTH_04 + UC_AUTH_02. Tras el cambio
exitoso debe pasar a scope pleno.

**Diferencia con flujo principal**: PASO 10 +
PASO 14.

**Pasos:**

::

   PASO 10A          User.first_login = False
                     dispara la transicion de
                     scope reducido → scope
                     pleno en la Session
                     actual. La Session
                     mantiene su session_id pero
                     el campo "scope" se
                     actualiza.

   PASO 14A          Response incluye
                     "next_step": "landing" y
                     "scope_upgraded": true.

**Postcondiciones especiales:**

- Session actual con scope pleno.
- AuditEvent payload incluye
  ``scope_upgrade=true``.

4.2 FA-02: Cambio voluntario sin cierre de otras sessions
=========================================================

**Activador**: la setting
``CLOSE_OTHER_SESSIONS_ON_PASSWORD_CHANGE``
esta False (politica laxa).

**Diferencia**: PASO 12 se omite. Otras
Sessions del User permanecen ACTIVE pero los
tokens emitidos para ellas siguen valiendo
hasta su expiracion natural.

**Postcondiciones especiales:**

- Otras Sessions intactas.
- AuditEvent payload incluye
  ``other_sessions_closed_count: 0`` y
  ``policy: 'lax'``.

4.3 FA-03: Cambio post UC_AUTH_03 (reset admin)
===============================================

**Activador**: el User llega aqui porque un
admin ejecuto UC_AUTH_03 sobre su cuenta. El
``current_password`` que el User ingresa es la
contrasena temporal del InternalMessage.

**Diferencia con flujo principal**: ninguna
desde el punto de vista del flujo. Solo el
contexto temporal lo distingue.

**Pasos extras (post-procesamiento):**

::

   PASO 13A   AuditEvent payload incluye
              {prior_first_login: true,
               likely_post_admin_reset: true}
              — heuristica: si
              password_changed_at del User es
              < 24h y no hay AuditEvent
              voluntario reciente.

4.4 FA-04: Cambio mientras BLOCKED
==================================

**Activador**: User con
``state='BLOCKED'`` invoca UC_AUTH_04.

**Justificacion**: cambiar la contrasena no
desbloquea. Pero permitimos la operacion para
que cuando el admin desbloquee
(UC_USR_06) el User ya tenga contrasena
recordable.

**Diferencia**: la transaccion ejecuta
normalmente; ``User.state`` permanece
``BLOCKED``.

**Postcondiciones**: identicas al flujo
principal pero sin desbloquear.

4.5 FA-05: Cambio durante expiracion proxima
============================================

**Activador**: el User responde al warning de
"password expira en N dias" emitido por
UC_AUTH_01 FA-02.

**Diferencia**: ninguna en el procesamiento.
Es una motivacion del invocante.

**Postcondiciones especiales:**

- ``User.password_changed_at = NOW()`` reinicia
  la ventana de expiracion.
- Si la setting de expiracion es 90 dias, el
  proximo aviso sera dentro de ~83 dias.

4.6 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia clave
   - Status
 * - FA-01
   - first_login=true
   - Scope upgrade
   - 200 OK
 * - FA-02
   - Setting laxa
   - PASO 12 omitido
   - 200 OK
 * - FA-03
   - Post admin reset
   - AuditEvent flag
   - 200 OK
 * - FA-04
   - User BLOCKED
   - State preservado
   - 200 OK
 * - FA-05
   - Pre-expiracion
   - (sin cambio)
   - 200 OK

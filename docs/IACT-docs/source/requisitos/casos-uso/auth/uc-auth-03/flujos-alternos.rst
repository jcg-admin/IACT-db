.. _uc-auth-03-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

Variaciones legitimas del flujo principal sin
falla de sistema. Las fallas viven en Parte 5.

4.1 FA-01: User en estado BLOCKED
=================================

**Activador**: PASO 8 — el ``User`` destino
existe pero ``state='BLOCKED'`` (UC_USR_05 lo
bloqueo previamente).

**Justificacion**: el reset de contrasena no
desbloquea al user automaticamente. Permitimos
el reset (el user podra recibir la contrasena
en su buzon) pero el state permanece BLOCKED y
el proximo login fallara hasta que un admin
desbloquee via UC_USR_06.

**Punto de divergencia**: PASO 10.

**Pasos:**

::

   PASO 10A (FA-01)  Backend ejecuta UPDATE de
                     password_hash y first_login
                     pero NO modifica
                     User.state (permanece
                     BLOCKED).

   PASO 14A          Response 200 OK con campo
                     extra "warning":
                     "El usuario esta BLOCKED.
                     No podra acceder hasta que
                     sea desbloqueado."

**Postcondiciones especiales:**

- ``User.password_hash`` actualizado.
- ``User.state = 'BLOCKED'`` permanece.
- AuditEvent payload incluye ``user_state =
  'BLOCKED'``.

4.2 FA-02: User con first_login ya true
=======================================

**Activador**: PASO 8 — el User destino tiene
``first_login=true`` (un reset anterior ya
ocurrio y el user nunca completo UC_AUTH_04).

**Justificacion**: el admin esta haciendo un
segundo reset porque el user no actuo sobre el
primero (vacaciones, contrasena temporal vencida
por politica, etc.).

**Diferencia con flujo principal**: ``first_login``
ya estaba true; el flujo es identico pero el
AuditEvent payload incluye un flag.

**Pasos extras:**

::

   PASO 13B          AuditEvent payload incluye
                     {"prior_first_login": true}
                     para que el auditor pueda
                     correlacionar resets
                     repetidos.

4.3 FA-03: Reset masivo (un admin → varios users)
=================================================

**Activador**: el admin ejecuta UC_AUTH_03 sobre
N users en sucesion (no concurrencia tecnica;
serie temporal — p.ej. tras filtracion de hashes
y se requiere reset preventivo).

**Justificacion**: caso operacional. No es
batch endpoint en este UC (eso seria un UC
distinto), pero documentamos el patron.

**Diferencia con flujo principal**: ninguna a
nivel de UC. Cada invocacion es independiente.

**Postcondiciones especiales:**

- N InternalMessages, N AuditEvents.
- Si supera N > 10 en 5 minutos, el rate
  limiter (CNST-011) puede bloquear al admin
  → EX-08 throttling.

4.4 FA-04: Operacion sin concurrencia (lock acquired)
=====================================================

**Activador**: PASO 10 — el User destino esta
siendo modificado simultaneamente por otro
admin via UC_USR_03 (modificar usuario).

**Justificacion**: lock de fila MySQL (SELECT
... FOR UPDATE) puede causar espera. El UC
debe tolerar la espera y proceder cuando el
lock se libera.

**Diferencia con flujo principal**: latencia
mayor a la P50 esperada — la operacion sigue
siendo correcta, solo mas lenta.

**Postcondiciones**: identicas al flujo
principal. Si el lock excede el timeout de BD,
EX-06.

4.5 Resumen de flujos alternos
==============================

.. list-table::
 :widths: 12 35 30 23
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia clave
   - Status
 * - FA-01
   - User BLOCKED
   - Reset OK pero state preservado
   - 200 + warning
 * - FA-02
   - User con first_login=true
   - AuditEvent payload extra
   - 200 OK
 * - FA-03
   - Admin reseteando varios
   - N invocaciones serial; rate limit aplica
   - 200 OK / 429
 * - FA-04
   - Lock contention
   - Latencia mayor; resultado correcto
   - 200 OK (lento)

.. _uc-auth-04-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo
=====================

::

   PASO 1   User abre form "Cambiar contrasena"   (Frontend)
   PASO 2   User ingresa actual + nueva + confirm (Frontend)
   PASO 3   Frontend valida client-side basico    (Frontend)
   PASO 4   POST /api/auth/change-password/       (Frontend → Backend)
   PASO 5   Backend valida JWT (CNST-009)         (Backend)
   PASO 6   Backend localiza User                 (Backend → BD)
   PASO 7   Backend valida password actual        (Backend)
   PASO 8   Backend valida complejidad nueva      (Backend)
   PASO 9   Backend valida no-reuso (history)     (Backend → BD)
   PASO 10  Backend hashea + UPDATE User          (Backend → BD)
   PASO 11  Backend INSERT en PasswordHistory     (Backend → BD)
   PASO 12  Backend cierra otras Sessions         (Backend → BD)
   PASO 13  Backend emite AuditEvent              (Backend → BD)
   PASO 14  Backend retorna 200 OK                (Backend → Frontend)
   PASO 15  Frontend muestra exito + navega       (Frontend)

3.2 Detalle paso a paso
=======================

PASO 1 — Form abierto
---------------------

User llega al form ya sea por:

- Navegacion voluntaria (boton "Cambiar
  contrasena" en su perfil).
- Redirect forzado de UC_AUTH_01 FA-01 a
  ``/change-password``.

PASO 2 — User ingresa
---------------------

3 campos:

- ``current_password`` (input type=password)
- ``new_password``
- ``new_password_confirmation``

PASO 3 — Validacion client-side
-------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Frontend**
   - Verifica
     ``new_password === new_password_confirmation``
     y longitud minima visible. Otras reglas
     se validan en backend (no se exponen
     completas en cliente — defensa contra
     enumeracion).

PASO 4 — POST /api/auth/change-password/
----------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Request**
   - HTTP POST con header
     ``Authorization: Bearer <token>`` y body
     JSON con ``current_password``,
     ``new_password``,
     ``new_password_confirmation``
 * - **CNST**
   - HTTPS, CNST-009, CNST-013

PASO 5 — Validar JWT
--------------------

DRF middleware valida firma, expiracion,
blacklist. Extrae ``user_id``, ``session_id``.
Si invalido, EX-01 (401).

PASO 6 — Localizar User
-----------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``User.objects.select_for_update().get(
     id=user_id)``
 * - **Sistema**
   - Si existe, sigue. Si no (caso anomalo
     porque token es valido), EX-01.
 * - **Clase**
   - ``User`` (lectura con lock)

PASO 7 — Validar password actual
--------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``bcrypt.checkpw(current_password,
     user.password_hash)``
 * - **Sistema**
   - Si OK, sigue. Si no, EX-02 (400). Aplicar
     constant-time check + delay defensivo.

PASO 8 — Validar complejidad nueva
----------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``PasswordPolicyValidator.validate(
     new_password)`` — verifica longitud ≥12,
     1 mayuscula, 1 minuscula, 1 digito, 1
     simbolo, no en diccionario top-1000, no
     coincide con username/email.
 * - **Sistema**
   - Si OK, sigue. Si no, EX-03 (400) con lista
     de violaciones.

PASO 9 — Validar no-reuso
-------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``recent =
     PasswordHistory.objects.filter(
     user=user).order_by('-changed_at')[:5]``;
     para cada hash en recent:
     ``bcrypt.checkpw(new_password, hash)``
 * - **Sistema**
   - Si alguna coincide, EX-04 (400).
 * - **Tambien**
   - Verifica que la nueva no coincide con la
     actual: ``bcrypt.checkpw(new_password,
     user.password_hash) == False``. Si
     coincide → EX-05 (400).

PASO 10 — Hashear y UPDATE User
-------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``user.password_hash = bcrypt.hashpw(
     new_password, gensalt(12))``;
     ``user.first_login = False``;
     ``user.password_changed_at = NOW()``;
     ``user.save()``
 * - **Clase**
   - ``User`` (escritura)

PASO 11 — INSERT en PasswordHistory
-----------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``PasswordHistory.objects.create(
     user=user,
     password_hash=user.password_hash,
     changed_at=NOW())``;
     luego purge entries con ``rank > 5``.
 * - **Clase**
   - ``PasswordHistory`` (escritura
     append-only + cleanup limitado)

PASO 12 — Cerrar otras Sessions
-------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``Session.objects.filter(user=user,
     state='ACTIVE').exclude(
     session_id=current_session_id).update(
     state='CLOSED',
     close_reason='PASSWORD_CHANGED',
     closed_at=NOW())``;
     blacklistea sus tokens.
 * - **Politica**
   - Configurable via setting
     ``CLOSE_OTHER_SESSIONS_ON_PASSWORD_CHANGE``
     (default True). El default cumple
     defensa-en-profundidad.
 * - **Clase**
   - ``Session`` (escritura masiva),
     ``BlacklistedToken`` (INSERT)

PASO 13 — AuditEvent
--------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``AuditEvent.objects.create(
     event_type='PASSWORD_CHANGED',
     actor_user_id=user.id,
     occurred_at=NOW(),
     payload={ip, user_agent,
     prior_first_login,
     other_sessions_closed_count})``
 * - **CNST**
   - CNST-025; CNST-026 sin PII

PASO 14 — Response 200 OK
-------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - Body
     ``{"message": "Contrasena actualizada",
     "changed_at": "...",
     "next_step": "landing"}``
 * - **Politica**
   - ``next_step`` puede ser ``landing`` (caso
     general) o ``re_login`` si la politica
     requiere reautenticacion (no default).

PASO 15 — Frontend
------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - Toast "Contrasena actualizada
     correctamente"; navega a ``next_step``.
     Si ``re_login``, ejecuta logout local +
     redirect a /login.

3.3 Atomicidad
==============

Pasos 10-13 dentro de transaccion atomica:

::

   BEGIN
     UPDATE user SET password_hash=?,
       first_login=false, password_changed_at=NOW()
       WHERE id=user_id;
     INSERT INTO password_history (...);
     UPDATE session SET state='CLOSED',
       close_reason='PASSWORD_CHANGED'
       WHERE user_id=? AND state='ACTIVE'
       AND session_id != current;
     INSERT INTO blacklisted_token (N rows);
     INSERT INTO audit_event (PASSWORD_CHANGED);
   COMMIT

Si cualquier paso falla, ROLLBACK. La purga de
entries antiguas en PasswordHistory (rank > 5)
es secundaria — puede correr fuera de la
transaccion.

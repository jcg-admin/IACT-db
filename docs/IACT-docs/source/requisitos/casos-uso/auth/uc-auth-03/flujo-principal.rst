.. _uc-auth-03-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

Secuencia normal cuando un admin con AGR-006
resetea la contrasena de un User valido.

3.1 Resumen del flujo
=====================

::

   PASO 1   Admin abre lista de usuarios            (Frontend)
   PASO 2   Admin selecciona User afectado          (Frontend)
   PASO 3   Admin clickea "Resetear contrasena"     (Frontend)
   PASO 4   Frontend muestra modal de confirmacion  (Frontend)
   PASO 5   Admin confirma                          (Frontend)
   PASO 6   Frontend POST /api/users/{id}/
            reset-password/                         (Frontend → Backend)
   PASO 7   Backend valida token + RBAC             (Backend)
   PASO 8   Backend valida User destino             (Backend → BD)
   PASO 9   Backend genera password temporal        (Backend)
   PASO 10  Backend hashea bcrypt + UPDATE User     (Backend → BD)
   PASO 11  Backend cierra Sessions del User        (Backend → BD)
   PASO 12  Backend crea InternalMessage            (Backend → BD)
   PASO 13  Backend emite AuditEvent PASSWORD_RESET (Backend → BD)
   PASO 14  Backend retorna 200 OK (sin password)   (Backend → Frontend)
   PASO 15  Frontend muestra confirmacion al admin  (Frontend)

3.2 Detalle paso a paso
=======================

PASO 1 — Admin abre lista de usuarios
-------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Admin
 * - **Accion**
   - Navega a la pagina de gestion de usuarios
 * - **Sistema responde**
   - Frontend renderiza tabla de Users (filtrada
     y paginada)

PASO 2 — Admin selecciona User
------------------------------

Admin localiza el User a resetear (busqueda por
username, email parcial, o nombre).

PASO 3 — Click "Resetear contrasena"
------------------------------------

Boton visible solo si el admin tiene AGR-006.

PASO 4 — Modal de confirmacion
------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Sistema**
   - Frontend muestra modal con: nombre del User
     a afectar, advertencia "Esta accion cerrara
     todas sus sesiones y forzara cambio de
     contrasena. La contrasena temporal se enviara
     a SU buzon interno."
 * - **Botones**
   - "Confirmar" (destructivo) / "Cancelar"

PASO 5 — Confirmacion
---------------------

Admin clickea "Confirmar".

PASO 6 — POST /api/users/{id}/reset-password/
---------------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Frontend
 * - **Request**
   - HTTP POST a
     ``/api/users/{user_id}/reset-password/``
     con header
     ``Authorization: Bearer <admin-token>``
 * - **Body**
   - vacio (la accion no requiere parametros
     extra)
 * - **CNST**
   - HTTPS, CNST-009, CNST-013

PASO 7 — Validar token + RBAC
-----------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - DRF middleware valida JWT (firma,
     blacklist, expiracion). Permission class
     ``HasResetPasswordFunction`` verifica que
     ``request.user`` tenga AGR-006 o la funcion
     ``reset_password``.
 * - **Sistema responde**
   - Si OK, sigue. Si falla token, EX-01
     (401). Si falta funcion, EX-02 (403).
 * - **CNST**
   - CNST-009

PASO 8 — Validar User destino
-----------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``User.objects.get(id=user_id)``;
     verifica ``user.id != admin.id`` (no
     auto-reset);
     verifica ``user.state != 'ELIMINATED'``
 * - **Sistema responde**
   - Si OK, sigue. Si no existe, EX-03 (404).
     Si auto-reset, EX-04 (400). Si eliminado,
     EX-05 (400).
 * - **Clase tocada**
   - ``User`` (lectura)

PASO 9 — Generar password temporal
----------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``PasswordGenerator.generate(length=12)`` —
     produce string con minimo 1 mayuscula, 1
     minuscula, 1 digito, 1 simbolo.
     ``secrets.SystemRandom`` para entropia.
 * - **Sistema responde**
   - ``temp_password`` en memoria (nunca en
     log)
 * - **BR**
   - BR-AUTH-21 (12+ chars mixtos)

PASO 10 — Hashear y UPDATE User
-------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``user.password_hash =
     bcrypt.hashpw(temp_password, gensalt(12))``;
     ``user.first_login = True``;
     ``user.password_changed_at = NOW()``;
     ``user.save()``
 * - **Clase tocada**
   - ``User`` (escritura)

PASO 11 — Cerrar Sessions del User
----------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``Session.objects.filter(user=user,
     state='ACTIVE').update(
     state='CLOSED',
     close_reason='PASSWORD_RESET',
     closed_at=NOW())``;
     blacklistea los JWTs activos asociados.
 * - **Clase tocada**
   - ``Session`` (escritura masiva),
     ``BlacklistedToken`` (INSERT)

PASO 12 — Crear InternalMessage
-------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``InternalMessage.objects.create(
     recipient=user, sender=None,
     subject='Contrasena temporal',
     body='Tu contrasena fue reseteada por un
     administrador. Contrasena temporal: {temp}.
     Debes cambiarla en tu proximo inicio.',
     created_at=NOW())``
 * - **Sistema**
   - Mensaje persistido en buzon
 * - **CNST**
   - CNST-001 (no envio externo);
     CNST-002 (buzon obligatorio)

PASO 13 — Emitir AuditEvent PASSWORD_RESET
------------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``AuditEvent.objects.create(
     event_type='PASSWORD_RESET',
     actor_user_id=admin.id,
     occurred_at=NOW(),
     payload={target_user_id, ip, user_agent,
     sessions_closed_count})``
 * - **CNST**
   - CNST-025; CNST-026 sin PII (no incluir
     email ni nombre del user destino — solo
     id)

PASO 14 — 200 OK (sin password en response)
-------------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Response**
   - 200 OK,
     ``{"message": "Contrasena reseteada.
     Notificacion enviada al buzon del usuario.",
     "target_user_id": ..., "reset_at": "..."}``
 * - **Critico**
   - La contrasena temporal NO va en la
     response. Solo en el InternalMessage.

PASO 15 — Confirmacion al admin
-------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Frontend
 * - **Accion**
   - Toast/snackbar: "Contrasena reseteada.
     El usuario recibira la nueva contrasena en
     su buzon interno."
 * - **NO**
   - No muestra la contrasena. Si el admin la
     necesita debe pedirle al user que se la
     comunique presencialmente (politica de
     producto).

3.3 Atomicidad
==============

Los pasos 10-13 viven dentro de una transaccion
atomica:

::

   BEGIN
     UPDATE user SET
       password_hash=?, first_login=true,
       password_changed_at=NOW()
       WHERE id=user_id;
     UPDATE session SET state='CLOSED',
       close_reason='PASSWORD_RESET',
       closed_at=NOW()
       WHERE user_id=user_id AND state='ACTIVE';
     INSERT INTO blacklisted_token (jti, ...);
     INSERT INTO internal_message (
       recipient_id=user_id, body=...);
     INSERT INTO audit_event (
       event_type='PASSWORD_RESET', ...);
   COMMIT

Si cualquier paso falla, ROLLBACK. La operacion
es **todo o nada** — no aceptamos un User con
password reseteado pero sin notificacion en
buzon (CNST-002 dejaria al user sin manera de
conocer su nuevo password).

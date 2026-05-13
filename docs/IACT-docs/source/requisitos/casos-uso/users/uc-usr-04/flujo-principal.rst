.. _uc-usr-04-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo
=====================

::

   PASO 1   Admin localiza User en lista          (Frontend)
   PASO 2   Click "Eliminar"                      (Frontend)
   PASO 3   Modal robusto + doble confirmacion    (Frontend)
   PASO 4   Admin confirma                        (Frontend)
   PASO 5   DELETE /api/users/{id}/               (FE → BE)
   PASO 6   Validar JWT + RBAC deactivate_users   (Backend)
   PASO 7   Validar User existe + no ELIMINATED   (Backend → BD)
   PASO 8   Validar P-11 anti-self-elimination    (Backend)
   PASO 9   UPDATE User → ELIMINATED              (Backend → BD)
   PASO 10  UPDATE Assignment activos → REVOKED   (Backend → BD)
   PASO 11  UPDATE Sessions activas → CLOSED      (Backend → BD)
   PASO 12  INSERT BlacklistedToken (N)           (Backend → BD)
   PASO 13  (Opcional) INSERT InternalMessage     (Backend → BD)
   PASO 14  INSERT AuditEvent USER_ELIMINATED     (Backend → BD)
   PASO 15  204 No Content (o 200 con resumen)    (BE → FE)
   PASO 16  Frontend muestra confirmacion         (Frontend)

3.2 Detalle paso a paso
=======================

PASO 1 — Localizar User
-----------------------

Admin usa la lista (UC_USR_02) para localizar
el target. Tipicamente filtra por state ACTIVE
y busqueda por nombre/email.

PASO 2 — Click "Eliminar"
-------------------------

Boton ``Eliminar`` (estilo destructivo, color
rojo). Visible SOLO si ``deactivate_users``
(P-15 RBAC granular). Si admin tiene solo
``modify_users``, el boton no aparece.

PASO 3 — Modal robusto
----------------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Frontend**
   - Modal con titulo "ELIMINAR USUARIO" en
     rojo, texto: "Esta accion ELIMINARA
     LOGICAMENTE al usuario {username}. Sus
     sesiones se cerraran inmediatamente,
     sus permisos se revocaran y no podra
     volver a iniciar sesion."
 * - **Doble confirmacion**
   - Campo input que requiere escribir
     literalmente "ELIMINAR" para habilitar
     el boton de submit. Defensa contra
     clicks accidentales.
 * - **Botones**
   - "Confirmar eliminacion" (destructivo) /
     "Cancelar"

PASO 4 — Confirmacion
---------------------

Admin escribe "ELIMINAR" + click Confirmar.

PASO 5 — DELETE request
-----------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Request**
   - HTTP DELETE
     ``/api/users/{user_id}/`` con
     ``Authorization: Bearer <admin-token>``
 * - **Body**
   - vacio
 * - **Semantica**
   - DELETE indica baja logica per BR-009;
     internamente es UPDATE state.

PASO 6 — Validar JWT + RBAC
---------------------------

Middleware de autenticacion valida el JWT del
invocante. Una ``AuthorizationGuard`` verifica
que el invocante posee la funcion
``deactivate_users`` (sin importar via que
AGR la haya obtenido). Si falla la
autenticacion, EX-01 (401); si la funcion
falta, EX-02 (403).

PASO 7 — Validar User
---------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``UserRepository.get_by_id_for_update(
     user_id)``;
     verifica existencia y
     ``state != 'ELIMINATED'``
 * - **Sistema**
   - Si no existe, EX-03 (404). Si ya
     ELIMINATED, EX-05 (idempotente — 200 OK
     informativo o 409 segun politica).
 * - **Clase**
   - ``User`` (lectura con lock pesimista)

PASO 8 — Validar P-11 anti-self-elimination
-------------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - verificar ``user_id != admin.id``
 * - **Justificacion**
   - admin no puede eliminarse a si mismo.
     Defensa contra escalada y lockout
     accidental. Para auto-eliminacion debe
     pedirse a otro admin con
     ``deactivate_users``.
 * - **Sistema**
   - Si auto-elimina, EX-04 (400) +
     AuditEvent ALERTA.

PASO 9 — UPDATE User → ELIMINATED
---------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``user.state = 'ELIMINATED'``;
     ``user.eliminated_at = NOW()``;
     ``user.eliminated_by_admin_id =
     admin.id``;
     ``user.save()``
 * - **Clase**
   - ``User`` (escritura)
 * - **CNST**
   - BR-009 (soft-delete via state, NO DELETE
     fisico)

PASO 10 — Revocar Assignments
-----------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``Assignment.objects.filter(
     user=target, state='ACTIVE').update(
     state='REVOKED',
     revoked_at=NOW(),
     revoked_by_admin_id=admin.id,
     revoke_reason='USER_ELIMINATED')``
 * - **Clase**
   - ``Assignment`` (escritura masiva)

PASO 11 — Cerrar Sessions
-------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``Session.objects.filter(
     user=target, state='ACTIVE').update(
     state='CLOSED',
     close_reason='USER_ELIMINATED',
     closed_at=NOW(),
     closed_by_admin_id=admin.id)``
 * - **Clase**
   - ``Session`` (escritura masiva)

PASO 12 — Blacklist tokens
--------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - Por cada Session cerrada, INSERT en
     ``BlacklistedToken`` con su ``access_jti``
     y ``expires_at`` original.
 * - **Clase**
   - ``BlacklistedToken`` (INSERT N)

PASO 13 — InternalMessage opcional
----------------------------------

Si politica
``NOTIFY_USER_ON_ELIMINATION=true``:

::

   InternalMessage.create(
     recipient=target,
     subject="Tu cuenta fue eliminada",
     body="Tu cuenta IACT fue eliminada por
           un administrador. Si requieres
           acceso, contacta a tu jefatura.")

Politica configurable. Default: ``true`` para
trazabilidad.

PASO 14 — AuditEvent USER_ELIMINATED
------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``AuditEvent.objects.create(
     event_type='USER_ELIMINATED',
     actor_user_id=admin.id,
     occurred_at=NOW(),
     payload={target_user_id, ip, user_agent,
     sessions_closed_count,
     assignments_revoked_count,
     prior_state})``
 * - **CNST**
   - CNST-025; CNST-026 sin PII (no email
     ni nombre del User en payload).

PASO 15 — Response
------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Response**
   - 200 OK con resumen:
     ``{"target_user_id":42,
     "state":"ELIMINATED",
     "eliminated_at":"...",
     "sessions_closed":2,
     "assignments_revoked":3,
     "user_notified":true}``
 * - **Alternativa**
   - 204 No Content si se prefiere semantica
     pura DELETE (sin body).

PASO 16 — Confirmacion al admin
-------------------------------

Frontend muestra toast: "Usuario eliminado.
{N} sesiones cerradas, {M} permisos
revocados." y refresca la lista (el User
ahora aparece con state ELIMINATED si el
filtro lo permite).

3.3 Atomicidad
==============

PASOS 9-14 dentro de una transaccion atomica:

::

   BEGIN
     UPDATE user SET state='ELIMINATED',
       eliminated_at=NOW(),
       eliminated_by_admin_id=admin.id
       WHERE id=target.id;
     UPDATE assignment SET state='REVOKED',
       revoked_at=NOW(), revoked_by=admin.id,
       revoke_reason='USER_ELIMINATED'
       WHERE user_id=target.id
         AND state='ACTIVE';
     UPDATE session SET state='CLOSED',
       close_reason='USER_ELIMINATED',
       closed_at=NOW(), closed_by=admin.id
       WHERE user_id=target.id
         AND state='ACTIVE';
     INSERT INTO blacklisted_token (...) FOR EACH closed_session;
     [opcional] INSERT INTO internal_message (...);
     INSERT INTO audit_event (
       event_type='USER_ELIMINATED', ...);
   COMMIT

Si cualquier paso falla, ROLLBACK total. **No
se acepta un User parcialmente eliminado** (state
ELIMINATED pero con Sessions abiertas, o
Assignments activos).

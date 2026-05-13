.. _uc-usr-04-parte-12:

==========================
Parte 12 — Testing
==========================

.. note::

 Tests en pseudocodigo Given/When/Then alineado
 con CA. Stack-agnostico.

12.1 Pyramid
============

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Capa
   - Cantidad
   - Cobertura objetivo
 * - Unit
   - 13
   - ≥ 90% lineas / ≥ 85% branches
 * - Integration
   - 11
   - sub-flujos + EXs + CNSTs
 * - E2E
   - 4
   - flujos administrativos completos

12.2 Tests unitarios
====================

12.2.1 Soft-delete obligatorio (CA-02, BR-009)
----------------------------------------------

::

   GIVEN un User existente
   WHEN  UserRepository expone metodos
   THEN  no existe metodo delete_physical
   AND   solo existe update_to_eliminated

12.2.2 AntiSelfActionPolicy bloquea (CA-03)
-------------------------------------------

::

   GIVEN invoker.id == target.user_id
   WHEN  AntiSelfActionPolicy.allows(
           invoker, target, 'eliminate')
   THEN  raise SelfElimination

12.2.3 IdempotencyPolicy default — User ya ELIMINATED (CA-06)
-------------------------------------------------------------

::

   GIVEN politica idempotente (default)
     AND target.state == ELIMINATED
   WHEN  handle_already_eliminated(target,
                                    invoker)
   THEN  no lanza
   AND   return informativo con
         already_eliminated=true

12.2.4 IdempotencyPolicy strict (CA-07)
---------------------------------------

::

   GIVEN politica strict
     AND target.state == ELIMINATED
   WHEN  handle_already_eliminated
   THEN  raise AlreadyEliminatedStrict

12.2.5 eliminate_user happy path (CA-01)
----------------------------------------

::

   GIVEN invoker con deactivate_users
     AND target con state ACTIVE,
         2 Sessions, 3 Assignments
   WHEN  eliminate_user(target.id, invoker)
   THEN  User.state == ELIMINATED
   AND   Assignments REVOKED == 3
   AND   Sessions CLOSED == 2
   AND   2 BlacklistedToken creadas
   AND   AuditEvent USER_ELIMINATED con
         payload.sessions_closed_count == 2

12.2.6 prior_state preservado en audit
--------------------------------------

::

   GIVEN target con state BLOCKED
   WHEN  eliminate_user
   THEN  AuditEvent.payload.prior_state ==
         'BLOCKED'

12.2.7 Sin Sessions → contador 0 (FA-03)
----------------------------------------

::

   GIVEN target sin Sessions activas
   WHEN  eliminate_user
   THEN  Sessions CLOSED == 0
   AND   AuditEvent.sessions_closed_count == 0

12.2.8 Sin Assignments → contador 0
-----------------------------------

::

   GIVEN target sin Assignments activos
   WHEN  eliminate_user
   THEN  AuditEvent.assignments_revoked_count == 0

12.2.9 Mailbox-or-abort softer (CA-11)
--------------------------------------

::

   GIVEN politica MailboxFailurePolicy=softer
     AND InternalMailbox.send lanza MailboxError
   WHEN  eliminate_user
   THEN  no se propaga la excepcion
   AND   result.mailbox_failed == true
   AND   result.user_notified == false
   AND   User.state == ELIMINATED (no rollback)

12.2.10 Mailbox-or-abort hard (alternativa)
-------------------------------------------

::

   GIVEN politica MailboxFailurePolicy=hard
     AND InternalMailbox.send lanza
   WHEN  eliminate_user
   THEN  excepcion propagada
   AND   ROLLBACK — User.state preservado

12.2.11 Atomicidad — falla en revoke Assignments
------------------------------------------------

::

   GIVEN AssignmentRepository
         .revoke_all_active_for_user lanza
   WHEN  eliminate_user
   THEN  excepcion propagada
   AND   User.state preservado (rollback)
   AND   Sessions intactas

12.2.12 Audit sin PII (CA-12)
-----------------------------

::

   GIVEN eliminate_user exitoso
   WHEN  inspecciono AuditEvent.payload
   THEN  payload no contiene email,
         full_name del target
   AND   payload contiene IDs y contadores

12.2.13 Email reservado post-eliminacion (CA-14)
------------------------------------------------

::

   GIVEN User ELIMINATED con email X
   WHEN  buscar User.objects.filter(email=X)
         .exists()
   THEN  result == true (preservado)

12.3 Tests de integracion
=========================

12.3.1 Endpoint DELETE 200 (CA-01)
----------------------------------

::

   GIVEN invoker autenticado con
         deactivate_users
   WHEN  DELETE /api/users/{id}/
   THEN  status == 200
   AND   body.state == 'ELIMINATED'
   AND   body.sessions_closed >= 0

12.3.2 Sin la funcion 403 (CA-04)
---------------------------------

::

   GIVEN invoker sin deactivate_users
   WHEN  DELETE /api/users/{id}/
   THEN  status == 403
   AND   AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT

12.3.3 User no existe 404 (CA-05)
---------------------------------

::

   GIVEN user_id 99999 no existe
   WHEN  DELETE /api/users/99999/
   THEN  status == 404 USER_NOT_FOUND

12.3.4 Auto-eliminacion 400 (CA-03)
-----------------------------------

::

   GIVEN invoker con deactivate_users
   WHEN  DELETE /api/users/{invoker.id}/
   THEN  status == 400
         SELF_ELIMINATION_FORBIDDEN
   AND   AuditEvent USER_ELIMINATE_FAILED
         ALERTA

12.3.5 Idempotente default (CA-06)
----------------------------------

::

   GIVEN User ya ELIMINATED
   WHEN  segundo DELETE
   THEN  status == 200
   AND   body.already_eliminated == true
   AND   AuditEvent USER_ELIMINATE_NOOP

12.3.6 Strict 409 (CA-07)
-------------------------

::

   GIVEN setting STRICT_ELIMINATION=true
     AND User ya ELIMINATED
   WHEN  DELETE
   THEN  status == 409 USER_ALREADY_ELIMINATED

12.3.7 Token rechazado post-eliminacion (CA-08)
-----------------------------------------------

::

   GIVEN admin elimina User X
   WHEN  cliente con token activo de X
         intenta GET cualquier endpoint
   THEN  status == 401 (token blacklisteado)

12.3.8 Login post-eliminacion rechazado (CA-09)
-----------------------------------------------

::

   GIVEN User ELIMINATED
   WHEN  intenta UC_AUTH_01 con sus
         credenciales
   THEN  status == 401
   AND   body indica account_eliminated

12.3.9 Email no reutilizable (CA-14)
------------------------------------

::

   GIVEN User ELIMINATED con email X
   WHEN  invocar UC_USR_01 con email X
   THEN  status == 409 EMAIL_EXISTS

12.3.10 Audit fail rollback (CA-10)
-----------------------------------

::

   GIVEN AuditLog.emit lanza
   WHEN  DELETE
   THEN  status == 500 AUDIT_FAILED
   AND   User.state preservado (rollback)
   AND   Assignments intactos
   AND   Sessions intactas

12.3.11 Throttling 429 (CA-16)
------------------------------

::

   GIVEN invoker con > 30 DELETE/min
   WHEN  envia DELETE 31
   THEN  status == 429

12.4 Tests E2E
==============

12.4.1 Eliminacion via UI con doble confirmacion
------------------------------------------------

::

   GIVEN admin con deactivate_users en UI
   WHEN  abre detalle del User, click
         "Eliminar", modal aparece, escribe
         "ELIMINAR", click Confirmar
   THEN  toast confirma con resumen
   AND   tabla muestra User como ELIMINATED

12.4.2 Boton oculto sin la funcion (CA-18)
------------------------------------------

::

   GIVEN admin con solo modify_users
         (sin deactivate_users) en UI
   WHEN  abre detalle del User
   THEN  boton "Eliminar" no es visible

12.4.3 Modal robusto requiere literal (CA-17)
---------------------------------------------

::

   GIVEN admin abre modal de eliminacion
   WHEN  intenta confirmar sin escribir
         "ELIMINAR"
   THEN  boton Confirmar deshabilitado
   AND   sin DELETE request

12.4.4 User eliminado no puede iniciar sesion (CA-09)
-----------------------------------------------------

::

   GIVEN admin elimina User X via UI
   WHEN  X intenta loguearse
   THEN  rechazo con mensaje "cuenta
         eliminada"

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente logico
   - Lineas
   - Branches
 * - UserService.eliminate_user
   - ≥ 95%
   - ≥ 90%
 * - AssignmentRepository.revoke_all_active_for_user
   - 100%
   - 100%
 * - AntiSelfActionPolicy
   - 100%
   - 100%
 * - IdempotencyPolicy (default + strict)
   - 100%
   - 100%
 * - MailboxFailurePolicy (softer + hard)
   - 100%
   - 100%
 * - HTTPDeleteEndpoint
   - ≥ 90%
   - ≥ 85%
 * - AuthorizationGuard deactivate_users
   - 100%
   - 100%

12.6 Resumen
============

.. list-table::
 :widths: 15 35 50
 :header-rows: 1

 * - Capa
   - Test
   - CA cubierto
 * - Unit
   - soft-delete obligatorio
   - CA-02 / BR-009
 * - Unit
   - AntiSelfAction bloquea
   - CA-03
 * - Unit
   - IdempotencyPolicy default vs strict
   - CA-06, CA-07
 * - Unit
   - eliminate_user happy
   - CA-01
 * - Unit
   - prior_state en audit
   - CA-12 (correlacion)
 * - Unit
   - sin Sessions / sin Assignments
   - FA-03
 * - Unit
   - Mailbox-or-abort softer / hard
   - CA-11
 * - Unit
   - atomicidad rollback
   - CA-10
 * - Unit
   - audit sin PII
   - CA-12
 * - Unit
   - email reservado
   - CA-14
 * - Integration
   - endpoint DELETE 200
   - CA-01
 * - Integration
   - sin la funcion 403
   - CA-04
 * - Integration
   - user no existe 404
   - CA-05
 * - Integration
   - auto-eliminacion 400
   - CA-03
 * - Integration
   - idempotente default
   - CA-06
 * - Integration
   - strict 409
   - CA-07
 * - Integration
   - token post-eliminacion 401
   - CA-08
 * - Integration
   - login post-eliminacion 401
   - CA-09
 * - Integration
   - email no reutilizable
   - CA-14
 * - Integration
   - audit fail rollback
   - CA-10
 * - Integration
   - throttling 429
   - CA-16
 * - E2E
   - eliminacion via UI doble confirmacion
   - CA-17, CA-19
 * - E2E
   - boton oculto sin funcion
   - CA-18
 * - E2E
   - modal robusto literal
   - CA-17
 * - E2E
   - login post-eliminacion
   - CA-09 visual

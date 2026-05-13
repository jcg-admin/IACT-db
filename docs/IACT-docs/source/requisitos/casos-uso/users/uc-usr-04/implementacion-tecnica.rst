.. _uc-usr-04-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 **Especificacion abstracta** — contratos +
 pseudocodigo + responsabilidades. Sin atadura
 a un stack concreto. Aplica DEC-USR01-03.

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPDeleteEndpoint**
   - Recibir DELETE ``/api/users/{id}/``
 * - **AuthenticationGuard**
   - Validar token (CNST-009)
 * - **AuthorizationGuard**
   - Verificar funcion ``deactivate_users``
     (independiente del AGR de origen — ver
     DEC-USR04-01)
 * - **ThrottlePolicy**
   - 30 DELETE/min/admin
 * - **AntiSelfActionPolicy**
   - Validar ``invoker.id != target.user_id``
     (P-11)
 * - **UserRepository**
   - get_by_id_for_update,
     update_to_eliminated
 * - **AssignmentRepository**
   - revoke_all_active_for_user
 * - **SessionService**
   - close_all_active_for_user (con blacklist)
 * - **InternalMailbox**
   - send (notificacion opcional)
 * - **AuditLog**
   - emit_user_eliminated
 * - **TransactionManager**
   - Atomicidad pasos 9-14
 * - **IdempotencyPolicy**
   - default | strict
 * - **NotifyOnEliminationStrategy**
   - notify yes | no
 * - **MailboxFailurePolicy**
   - softer (default — registra warning, no
     aborta)

11.2 Contratos
==============

::

   contract UserService:
     eliminate_user(target_user_id: int,
                    invoker: AuthenticatedUser,
                    context: RequestContext)
       returns: EliminateUserOutput
       throws: SinPermiso (sin deactivate_users),
               UserNotFound,
               SelfElimination,
               AlreadyEliminatedStrict,
               BDTimeout, AuditFalla

   data EliminateUserOutput:
     target_user_id: int
     username: string
     state: enum {ELIMINATED}
     eliminated_at: timestamp
     eliminated_by_admin_id: int
     prior_state: enum
     sessions_closed: int
     assignments_revoked: int
     user_notified: bool
     mailbox_failed: bool
     # Si idempotente y ya estaba ELIMINATED:
     already_eliminated: bool (default false)
     original_eliminated_at: opt[timestamp]

   contract AntiSelfActionPolicy:
     allows(invoker, target,
            action='eliminate') returns bool
       throws: SelfElimination si
               invoker.id == target.id

   contract AssignmentRepository:
     revoke_all_active_for_user(user, admin,
                                 reason)
       returns: revoked_count

   contract SessionService:
     close_all_active_for_user(user, admin,
                                close_reason)
       returns: closed_count
       guarantee: tokens activos blacklisted

   contract IdempotencyPolicy:
     handle_already_eliminated(target, invoker)
       returns: opt[EliminateUserOutput]
       throws: AlreadyEliminatedStrict (si
               politica strict)

   contract MailboxFailurePolicy:
     on_mailbox_failure(error,
                       elimination_state)
       returns: bool — continue?
     # Default softer: returns true
     #                 (continue with flag)
     # Hard: returns false → propaga excepcion

11.3 Pseudocodigo del flujo principal
=====================================

::

   procedure eliminate_user(target_user_id,
                            invoker, ctx):

       # PASO 6
       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker, 'deactivate_users')
       require ThrottlePolicy.is_allowed(invoker)

       # PASO 9-14 atomico
       result = TransactionManager.atomic(():

           # PASO 7
           target = UserRepository.get_by_id_for_update(
                      target_user_id)
           if target is None:
               raise UserNotFound

           # FA-02 idempotencia
           if target.state == ELIMINATED:
               return IdempotencyPolicy
                        .handle_already_eliminated(
                          target, invoker)

           # PASO 8 — P-11
           require AntiSelfActionPolicy.allows(
             invoker, target, action='eliminate')

           prior_state = target.state

           # PASO 9
           UserRepository.update_to_eliminated(
             target,
             eliminated_at = now(),
             eliminated_by_admin_id = invoker.id)

           # PASO 10
           assignments_revoked_count =
             AssignmentRepository
               .revoke_all_active_for_user(
                 target, invoker,
                 reason='USER_ELIMINATED')

           # PASOS 11-12
           sessions_closed_count =
             SessionService
               .close_all_active_for_user(
                 target, invoker,
                 close_reason='USER_ELIMINATED')

           # PASO 13 — opcional
           user_notified = false
           mailbox_failed = false
           if NotifyOnEliminationStrategy
                .should_notify():
               try:
                   InternalMailbox.send(
                     recipient_id = target.id,
                     subject = 'Tu cuenta fue '
                               'eliminada',
                     body = build_elimination_body())
                   user_notified = true
               except MailboxError as e:
                   if not MailboxFailurePolicy
                            .on_mailbox_failure(
                              e, elimination_state):
                       raise  # politica hard
                   mailbox_failed = true  # softer

           # PASO 14
           AuditLog.emit(
             event_type = 'USER_ELIMINATED',
             actor_id = invoker.id,
             payload = {
               target_user_id: target.id,
               prior_state: prior_state,
               sessions_closed_count:
                 sessions_closed_count,
               assignments_revoked_count:
                 assignments_revoked_count,
               user_notified: user_notified,
               mailbox_failed: mailbox_failed,
               ip: ctx.ip,
               user_agent: ctx.user_agent})

           return {
             target,
             prior_state,
             sessions_closed_count,
             assignments_revoked_count,
             user_notified,
             mailbox_failed}
       )

       # Si fue idempotente, result es output
       # informativo (already_eliminated=true)
       if result.already_eliminated:
           return result

       return EliminateUserOutput(
         target_user_id = result.target.id,
         username = result.target.username,
         state = 'ELIMINATED',
         eliminated_at =
           result.target.eliminated_at,
         eliminated_by_admin_id = invoker.id,
         prior_state = result.prior_state,
         sessions_closed =
           result.sessions_closed_count,
         assignments_revoked =
           result.assignments_revoked_count,
         user_notified = result.user_notified,
         mailbox_failed = result.mailbox_failed)

11.4 Mapeo excepcion → respuesta HTTP
=====================================

.. list-table::
 :widths: 35 30 35
 :header-rows: 1

 * - Excepcion
   - Status
   - Body code
 * - sin token
   - 401
   - INVALID_TOKEN
 * - SinPermiso
   - 403
   - FORBIDDEN
 * - UserNotFound
   - 404
   - USER_NOT_FOUND
 * - SelfElimination
   - 400
   - SELF_ELIMINATION_FORBIDDEN
 * - AlreadyEliminatedStrict
   - 409
   - USER_ALREADY_ELIMINATED
 * - BDTimeout
   - 503
   - DB_TIMEOUT
 * - AuditFalla
   - 500
   - AUDIT_FAILED
 * - throttle exceeded
   - 429
   - RATE_LIMIT

11.5 Restricciones cross-cutting
================================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Restriccion
   - Implementacion
 * - **Soft-delete obligatorio (BR-009)**
   - UserRepository expone solo
     ``update_to_eliminated``, no
     ``delete_physical``. ORM/repo nivel
     impide DELETE fisico.
 * - **Audit obligatorio (CNST-025)**
   - AuditLog.emit dentro del bloque atomico.
     Sin audit, no operacion.
 * - **PII fuera del payload (CNST-026)**
   - AuditEvent.payload contiene solo IDs y
     contadores. Validable por test.
 * - **Atomicidad**
   - TransactionManager.atomic envuelve PASOS
     9-14. Si cualquiera lanza, ROLLBACK total.
 * - **Identidad reservada (P-24)**
   - El UNIQUE constraint en
     ``users.email`` y ``users.username``
     incluye registros ELIMINATED — el email
     no se libera.

11.6 Stack-agnostico
====================

Cualquier stack que respete los contratos
satisface el UC. Implementaciones concretas
viven en ``arquitectura-tecnica/`` o en los
modulos del backend.

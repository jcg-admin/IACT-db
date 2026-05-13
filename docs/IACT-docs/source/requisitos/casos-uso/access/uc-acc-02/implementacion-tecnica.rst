.. _uc-acc-02-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 **Especificacion abstracta** — contratos +
 pseudocodigo + responsabilidades. Aplica
 DEC-USR01-03.

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPDeleteEndpoint**
   - DELETE ``/api/users/{id}/functions/``
     con body
 * - **AuthenticationGuard**
   - JWT (CNST-009)
 * - **AuthorizationGuard**
   - Verificar ``revoke_functions``
 * - **ThrottlePolicy**
   - 30 DELETE/min/invoker
 * - **PayloadValidator**
   - Tipos, tamano,
     ``revoke_reason`` obligatorio
 * - **AntiSelfActionPolicy**
   - P-11 anti-self-revoke
 * - **AssignmentRepository**
   - list_active, update_to_revoked
 * - **WarningsCalculator**
   - Calcula no_functions, critical,
     last_holder
 * - **LastHolderPolicy**
   - warn-only vs block
 * - **PermissionCache**
   - invalidate post-COMMIT
 * - **InternalMailbox**
   - notify (opcional)
 * - **AuditLog**
   - emit append-only
 * - **TransactionManager**
   - Atomicidad

11.2 Contratos
==============

::

   contract AccessService:
     revoke_functions(target_user_id: int,
                      function_ids: list[int],
                      revoke_reason: string,
                      notify_user: opt[bool],
                      invoker: AuthenticatedUser,
                      context: RequestContext)
       returns: RevokeFunctionsOutput
       throws: SinPermiso, UserNotFound,
               InvalidUserState,
               SelfRevokeForbidden,
               LastHolderProtection,
               BDTimeout, AuditFalla

   data RevokeFunctionsInput:
     function_ids: list[int]  # 1..50
     revoke_reason: string  # required, non-empty
     notify_user: opt[bool]  # default per policy

   data RevokeFunctionsOutput:
     target_user_id: int
     username: string
     revoked: list[RevokedDetail]
     skipped: list[SkippedDetail]
     revoke_reason: string
     post_revoke_active_count: int
     warnings: WarningsBundle
     user_notified: bool
     revoked_at: timestamp

   data WarningsBundle:
     no_functions: bool
     critical_revoked: list[FunctionRef]
     last_holder: list[LastHolderInfo]

   data LastHolderInfo:
     function_id: int
     function_code: string
     remaining_holders_after: int

   contract WarningsCalculator:
     compute(target_user, current_active_set,
             to_revoke_ids, critical_set,
             last_holder_threshold)
       returns: WarningsBundle

   contract LastHolderPolicy:
     should_block(warnings) returns bool
     # warn-only: false; block: true si
     # warnings.last_holder tiene
     # remaining_holders_after == 0

11.3 Pseudocodigo del flujo principal
=====================================

::

   procedure revoke_functions(
             target_user_id, function_ids,
             revoke_reason, notify_user,
             invoker, ctx):

       # PASOS 5-6
       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker, 'revoke_functions')
       require ThrottlePolicy.is_allowed(invoker)

       # PASO 4
       PayloadValidator.validate(
         function_ids, revoke_reason)
       # raise ValidationError si
       # revoke_reason vacio o size invalido

       target = UserRepository
                  .get_by_id_for_update(
                    target_user_id)
       if target is None:
           raise UserNotFound
       if target.state == ELIMINATED:
           raise InvalidUserState

       require AntiSelfActionPolicy.allows(
                 invoker, target,
                 action='revoke')

       # PASO 9
       active_assignments =
         AssignmentRepository
           .list_active_matching(
             user=target,
             function_ids=function_ids)

       # PASO 10
       active_function_ids =
         {a.function_id for a in active_assignments}
       to_revoke_ids = active_function_ids
       skipped_ids =
         set(function_ids) - active_function_ids

       if not to_revoke_ids:
           # FA-01 idempotencia total
           AuditLog.emit(
             event_type='FUNCTIONS_REVOKE_NOOP',
             actor_id=invoker.id,
             payload={target_user_id: target.id,
                      function_ids_skipped:
                        list(skipped_ids)})
           return RevokeFunctionsOutput(
             target_user_id=target.id,
             username=target.username,
             revoked=[],
             skipped=[...],
             revoke_reason=revoke_reason,
             post_revoke_active_count=
               count_active(target),
             warnings=empty_bundle,
             user_notified=false)

       # PASO 11
       current_active_count =
         AssignmentRepository
           .count_active(target)
       post_revoke_active_count =
         current_active_count - len(to_revoke_ids)
       warnings = WarningsCalculator.compute(
         target, current_active_set,
         to_revoke_ids, critical_set,
         last_holder_threshold)

       if LastHolderPolicy.should_block(warnings):
           AuditLog.emit(
             event_type='FUNCTIONS_REVOKE_FAILED',
             reason='last_holder_protection',
             ...)
           raise LastHolderProtection(warnings)

       # PASOS 12-15 atomico
       result =
         TransactionManager.atomic(():

           # PASO 12
           AssignmentRepository
             .update_to_revoked(
               assignment_ids=
                 [a.id for a in active_assignments
                  if a.function_id in to_revoke_ids],
               revoked_at=now(),
               revoked_by_admin_id=invoker.id,
               revoke_reason=revoke_reason)

           # PASO 14
           AuditLog.emit(
             event_type='FUNCTIONS_REVOKED',
             actor_id=invoker.id,
             payload={
               target_user_id: target.id,
               function_ids_revoked:
                 list(to_revoke_ids),
               function_ids_skipped:
                 list(skipped_ids),
               revoke_reason: revoke_reason,
               post_revoke_active_count:
                 post_revoke_active_count,
               warnings: warnings,
               ip: ctx.ip,
               user_agent: ctx.user_agent})

           # PASO 15 — opcional
           user_notified = false
           should_notify = notify_user if
             notify_user is not None else
             NotifyOnRevokeStrategy
               .should_notify_default()
           if should_notify:
               function_display_names =
                 FunctionRepository
                   .get_display_names(
                     to_revoke_ids)
               InternalMailbox.send(
                 recipient_id=target.id,
                 subject='Capacidades revocadas',
                 body=build_revoke_body(
                   function_display_names,
                   revoke_reason))
               user_notified = true

           return {to_revoke_ids,
                   skipped_ids,
                   warnings,
                   user_notified,
                   post_revoke_active_count}
       )

       # PASO 13 — post-COMMIT
       PermissionCache.invalidate(target.id)

       # PASO 16
       return RevokeFunctionsOutput(...)

11.4 Mapeo excepcion → respuesta HTTP
=====================================

.. list-table::
 :widths: 40 20 40
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
 * - InvalidUserState
   - 400
   - INVALID_USER_STATE
 * - SelfRevokeForbidden
   - 400
   - SELF_REVOKE_FORBIDDEN
 * - ValidationError
   - 400
   - VALIDATION_ERROR
 * - LastHolderProtection
   - 409
   - LAST_HOLDER_PROTECTION
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
 * - **Soft-delete (BR-009)**
   - AssignmentRepository expone solo
     ``update_to_revoked``, no delete fisico.
 * - **Atomicidad**
   - TransactionManager.atomic envuelve
     PASOS 12-15. Cache post-COMMIT (P-29).
 * - **Audit obligatorio**
   - AuditLog.emit dentro del bloque atomico.
 * - **PII fuera del payload**
   - AuditEvent payload con IDs, codigos,
     reason — sin email/full_name.
 * - **Reason-required (P-32)**
   - PayloadValidator rechaza payloads sin
     ``revoke_reason``.

11.6 Stack-agnostico
====================

Cualquier stack que respete los contratos
satisface el UC.

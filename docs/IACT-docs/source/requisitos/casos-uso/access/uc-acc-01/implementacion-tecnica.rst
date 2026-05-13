.. _uc-acc-01-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 **Especificacion abstracta** — contratos +
 pseudocodigo + responsabilidades. Aplica
 DEC-USR01-03: el UC NO se casa con un stack
 concreto. Las implementaciones (Python/Django,
 Node, Java, .NET) son informativas y viven
 en ``arquitectura-tecnica/``.

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPPostEndpoint**
   - Recibir POST
     ``/api/users/{id}/functions/``
 * - **AuthenticationGuard**
   - Validar token (CNST-009)
 * - **AuthorizationGuard**
   - Verificar funcion ``assign_functions``
     (independiente del AGR de origen)
 * - **ThrottlePolicy**
   - 30 POST/min/invoker
 * - **PayloadValidator**
   - Tipos, tamano, expires_at bounds
 * - **UserRepository**
   - get_by_id_for_update
 * - **FunctionRepository**
   - list_by_ids, validate_state
 * - **AssignmentRepository**
   - list_active_for_user,
     bulk_insert
 * - **SoDRuleRepository**
   - list_active_rules
 * - **SoDValidator**
   - is_set_compliant(set, rules);
     find_first_violation
 * - **AntiSelfActionPolicy**
   - configurable (P-11)
 * - **PermissionCache**
   - invalidate(user_id) post-COMMIT
 * - **InternalMailbox**
   - send (notificacion opcional)
 * - **AuditLog**
   - emit append-only (CNST-025)
 * - **TransactionManager**
   - Atomicidad pasos 11-13
 * - **IdempotencyPolicy**
   - default NOOP vs strict 409
 * - **ExpirationPolicy**
   - bounds y default expiration

11.2 Contratos
==============

::

   contract AccessService:
     assign_functions(target_user_id: int,
                      function_ids: list[int],
                      expires_at: opt[timestamp],
                      invoker: AuthenticatedUser,
                      context: RequestContext)
       returns: AssignFunctionsOutput
       throws: SinPermiso, UserNotFound,
               InvalidUserState,
               SelfAssignForbidden,
               FunctionNotFound,
               FunctionInactive,
               SoDViolation, ValidationError,
               BDTimeout, AuditFalla

   data AssignFunctionsInput:
     function_ids: list[int]  # 1..50
     expires_at: opt[timestamp]
       # NOW()+1h <= x <= NOW()+1y

   data AssignFunctionsOutput:
     target_user_id: int
     username: string
     assigned: list[AssignmentDetail]
     skipped: list[SkippedDetail]
     sod_rules_evaluated: int
     user_notified: bool
     assigned_at: timestamp

   data AssignmentDetail:
     function_id: int
     function_code: string
     expires_at: opt[timestamp]

   data SkippedDetail:
     function_id: int
     function_code: string
     reason: enum {already_active}

   contract SoDValidator:
     validate(effective_set: set[int],
              rules: list[SoDRule])
       returns: ValidationResult
       throws: SoDViolation
                (rule_id, conflict_pair)

   contract SoDRule:
     id: int
     name: string
     state: enum
     is_violated_by(function_set: set[int])
       returns: bool
     find_conflict(function_set: set[int])
       returns: opt[Pair[FunctionRef]]

   contract IdempotencyPolicy:
     handle_all_already_assigned(target,
                                  function_ids,
                                  invoker)
       returns: AssignFunctionsOutput
                (con assigned=[],
                 skipped=full_list)

   contract PermissionCache:
     invalidate(user_id: int)
       guarantee: post-COMMIT semantics

11.3 Pseudocodigo del flujo principal
=====================================

::

   procedure assign_functions(
             target_user_id, function_ids,
             expires_at, invoker, ctx):

       # PASOS 5-6
       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker, 'assign_functions')
       require ThrottlePolicy.is_allowed(invoker)

       # PASO 4 — validacion payload
       PayloadValidator.validate(
         function_ids, expires_at)

       # PASO 7
       target = UserRepository
                  .get_by_id_for_update(
                    target_user_id)
       if target is None:
           raise UserNotFound
       if target.state in {ELIMINATED, BLOCKED}:
           raise InvalidUserState(target.state)
       if politica_INACTIVE_strict and
          target.state == INACTIVE:
           raise InvalidUserState(target.state)
       require AntiSelfActionPolicy.allows(
                 invoker, target,
                 action='assign')

       # PASO 8
       functions = FunctionRepository
                     .list_by_ids(function_ids)
       missing = function_ids - {f.id for f in functions}
       if missing:
           raise FunctionNotFound(missing)
       inactive = {f.id for f in functions
                   if f.state != ACTIVE}
       if inactive:
           raise FunctionInactive(inactive)

       # PASO 9 — filtrar idempotente
       active_assignments =
         AssignmentRepository
           .list_active_for_user(target)
       already_assigned_ids =
         {a.function_id for a in active_assignments
          if a.function_id in function_ids}
       new_function_ids =
         set(function_ids) - already_assigned_ids

       if not new_function_ids:
           # FA-01 idempotencia total
           return IdempotencyPolicy
                    .handle_all_already_assigned(
                      target, function_ids,
                      invoker)

       # PASO 10 — SoD validation
       current_function_ids =
         {a.function_id for a in active_assignments}
       effective_set =
         current_function_ids | new_function_ids
       sod_rules =
         SoDRuleRepository.list_active_rules()
       SoDValidator.validate(
         effective_set, sod_rules)
       # raise SoDViolation si viola

       # PASOS 11-13 atomico
       result =
         TransactionManager.atomic(():

           # PASO 11
           new_assignments =
             AssignmentRepository.bulk_insert([
               Assignment(
                 user_id=target.id,
                 function_id=fid,
                 state=ACTIVE,
                 granted_at=now(),
                 granted_by_admin_id=invoker.id,
                 expires_at=expires_at)
               for fid in new_function_ids])

           # PASO 13
           AuditLog.emit(
             event_type='FUNCTIONS_ASSIGNED',
             actor_id=invoker.id,
             payload={
               target_user_id: target.id,
               function_ids_assigned:
                 list(new_function_ids),
               function_ids_skipped:
                 list(already_assigned_ids),
               expires_at: expires_at,
               sod_rules_evaluated_count:
                 len(sod_rules),
               ip: ctx.ip,
               user_agent: ctx.user_agent})

           # PASO 14 — opcional
           user_notified = false
           if NotifyOnAssignStrategy
                .should_notify():
               function_display_names =
                 [f.display_name for f
                  in functions
                  if f.id in new_function_ids]
               InternalMailbox.send(
                 recipient_id=target.id,
                 subject='Nuevas capacidades',
                 body=build_assign_body(
                   function_display_names,
                   expires_at))
               user_notified = true

           return {new_assignments,
                   already_assigned_ids,
                   user_notified,
                   sod_rules_count:
                     len(sod_rules)}
       )

       # PASO 12 — post-COMMIT
       PermissionCache.invalidate(target.id)

       # PASO 15
       return AssignFunctionsOutput(
         target_user_id=target.id,
         username=target.username,
         assigned=[
           AssignmentDetail(
             function_id=a.function_id,
             function_code=
               functions_by_id[a.function_id]
                 .code,
             expires_at=a.expires_at)
           for a in result.new_assignments],
         skipped=[
           SkippedDetail(
             function_id=fid,
             function_code=
               functions_by_id[fid].code,
             reason='already_active')
           for fid in result.already_assigned_ids],
         sod_rules_evaluated=
           result.sod_rules_count,
         user_notified=result.user_notified,
         assigned_at=now())

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
 * - SelfAssignForbidden
   - 400
   - SELF_ASSIGN_FORBIDDEN
 * - FunctionNotFound
   - 400
   - FUNCTION_NOT_FOUND
 * - FunctionInactive
   - 400
   - FUNCTION_INACTIVE
 * - SoDViolation
   - 409
   - SOD_VIOLATION
 * - ValidationError
   - 400
   - VALIDATION_ERROR
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
 * - **Atomicidad**
   - TransactionManager.atomic envuelve
     PASOS 11-13. Cache invalidate
     post-COMMIT (P-29).
 * - **All-or-nothing SoD (P-28)**
   - SoDValidator.validate lanza ANTES de la
     transaccion (PASO 10). Si lanza,
     ROLLBACK no es necesario porque no se
     inicio la TX.
 * - **Audit obligatorio (CNST-025)**
   - AuditLog.emit dentro del bloque atomico.
     Sin audit, no operacion.
 * - **PII fuera del payload (CNST-026)**
   - AuditEvent.payload contiene solo IDs y
     codigos. Validable por test.
 * - **SoD write-time (P-27, CNST-005)**
   - Validacion en PASO 10 — no diferido.
 * - **Cache post-COMMIT (P-29)**
   - PermissionCache.invalidate FUERA del
     bloque transaccional, despues del COMMIT
     exitoso.

11.6 Stack-agnostico
====================

Cualquier stack que respete los contratos
satisface el UC. La implementacion concreta
(Django/DRF, Express, Spring, ASP.NET Core)
NO pertenece al UC; vive en
``arquitectura-tecnica/`` y en los modulos del
backend.

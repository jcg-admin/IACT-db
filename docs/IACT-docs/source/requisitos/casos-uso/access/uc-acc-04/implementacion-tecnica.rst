.. _uc-acc-04-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 Especificacion abstracta. Aplica
 DEC-USR01-03.

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPPostEndpoint**
   - POST ``/api/users/{id}/access-groups/``
 * - **AuthenticationGuard / AuthorizationGuard**
   - Auth + ``assign_function_groups``
 * - **ThrottlePolicy**
   - 30/min/invoker
 * - **PayloadValidator**
   - tipos, expires_at bounds
 * - **UserRepository**
   - get_by_id_for_update
 * - **AccessGroupRepository**
   - get, list_functions
 * - **AssignmentRepository**
   - exists_active_for_user_and_agr,
     bulk_insert, list_active_for_user
 * - **EffectivePermissionsAggregator**
   - reutilizado de UC_ACC_03 para
     calcular current_effective
 * - **SoDValidator**
   - validate_set_against_rules
 * - **PermissionCache**
   - invalidate post-COMMIT
 * - **AuditLog**
   - emit
 * - **TransactionManager**
   - Atomicidad

11.2 Contratos
==============

::

   contract AccessService:
     assign_access_group(target_user_id,
                         access_group_id,
                         expires_at: opt,
                         invoker, ctx)
       returns: AssignAGROutput
       throws: SinPermiso, UserNotFound,
               InvalidUserState,
               SelfAssignForbidden,
               AccessGroupNotFound,
               AccessGroupInactive,
               SoDViolation,
               BDTimeout, AuditFalla

   data AssignAGROutput:
     target_user_id, username
     access_group_id, access_group_code,
     access_group_type
     assignment_id
     expires_at: opt
     agr_total_functions: int
     functions_count_added: int
     functions_already_present_count: int
     sod_rules_evaluated: int
     user_notified: bool
     assigned_at

   contract AccessGroupRepository:
     get(id) returns opt[AccessGroup]
     list_functions(agr_id) returns list[Function]
     # solo funciones state=ACTIVE del AGR

11.3 Pseudocodigo
=================

::

   procedure assign_access_group(
             target_user_id, access_group_id,
             expires_at, invoker, ctx):

       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker, 'assign_function_groups')
       require ThrottlePolicy.is_allowed(invoker)
       PayloadValidator.validate(expires_at)

       target = UserRepository.get_by_id_for_update(
                  target_user_id)
       if target is None: raise UserNotFound
       if target.state in {ELIMINATED, BLOCKED}:
           raise InvalidUserState
       require AntiSelfActionPolicy.allows(
                 invoker, target,
                 action='assign_agr')

       agr = AccessGroupRepository.get(access_group_id)
       if agr is None: raise AccessGroupNotFound
       if agr.state != ACTIVE:
           raise AccessGroupInactive

       # Idempotencia
       if AssignmentRepository
          .exists_active_for_user_and_agr(
            target, agr.id):
           AuditLog.emit(
             event_type='AGR_ASSIGN_NOOP',
             actor_id=invoker.id,
             payload={target_user_id: target.id,
                      access_group_id: agr.id,
                      original_granted_at: ...})
           return AssignAGROutput(
             ..., already_assigned=True)

       # Expandir
       agr_functions = AccessGroupRepository
                         .list_functions(agr.id)
       agr_function_ids = {f.id for f in agr_functions}

       # SoD
       current_effective_set =
         EffectivePermissionsAggregator
           .compute_set_only(target)
       effective_post_assign =
         current_effective_set | agr_function_ids
       sod_rules = SoDRuleRepository.list_active()
       SoDValidator.validate(
         effective_post_assign, sod_rules)
       # raise SoDViolation si viola

       functions_already_present_count =
         len(current_effective_set & agr_function_ids)
       functions_count_added =
         len(agr_function_ids - current_effective_set)

       # Atomico
       result = TransactionManager.atomic(():
         assignment = AssignmentRepository.create(
           user_id=target.id,
           target_type='AccessGroup',
           target_id=agr.id,
           state='ACTIVE',
           granted_at=now(),
           granted_by_admin_id=invoker.id,
           expires_at=expires_at)

         AuditLog.emit(
           event_type='AGR_ASSIGNED',
           actor_id=invoker.id,
           payload={
             target_user_id: target.id,
             access_group_id: agr.id,
             access_group_code: agr.code,
             access_group_type:
               'predefined' if agr.is_predefined
               else 'custom',
             agr_total_functions:
               len(agr_function_ids),
             functions_count_added:
               functions_count_added,
             functions_already_present_count:
               functions_already_present_count,
             expires_at: expires_at,
             sod_rules_evaluated: len(sod_rules),
             ip: ctx.ip,
             user_agent: ctx.user_agent})

         user_notified = false
         if NotifyOnAssignAGRStrategy.should_notify():
             InternalMailbox.send(
               recipient_id=target.id,
               subject='Nuevo grupo de capacidades',
               body=build_agr_body(agr, agr_functions))
             user_notified = true

         return assignment, user_notified
       )

       # post-COMMIT
       PermissionCache.invalidate(target.id)

       return AssignAGROutput(...)

11.4 Mapeo excepcion → HTTP
===========================

.. list-table::
 :widths: 35 25 40
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
 * - AccessGroupNotFound
   - 400
   - ACCESS_GROUP_NOT_FOUND
 * - AccessGroupInactive
   - 400
   - ACCESS_GROUP_INACTIVE
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

- Atomicidad PASOS 13-16.
- Audit obligatorio.
- PII fuera del payload.
- SoD evaluado sobre funciones expandidas
  (P-35).
- Cache post-COMMIT (P-29).

11.6 Stack-agnostico
====================

Cualquier stack que respete los contratos.

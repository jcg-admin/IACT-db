.. _uc-perm-06-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPCompositionEndpoint**
   - POST ``/api/access-groups/{id}/functions/``
 * - **AuthorizationGuard**
   - Verificar
     ``manage_access_group_composition``
 * - **AccessGroupRepository**
   - get, validate state + custom
 * - **FunctionRepository**
   - validate functions
 * - **AccessGroupFunctionRepository**
   - bulk_insert, bulk_delete
 * - **CascadeUsersFinder**
   - users_with_active_agr_assignment
 * - **CascadeSoDValidator**
   - per User SoD validation
 * - **CascadePolicy**
   - strict vs permissive
 * - **PermissionCache**
   - invalidate cascade post-COMMIT
 * - **AuditLog**
   - emit COMPOSITION_CHANGED
 * - **TransactionManager**
   - Atomicidad

11.2 Contratos
==============

::

   contract AccessGroupCompositionService:
     change_composition(
       agr_id: int,
       add_function_ids: list[int],
       remove_function_ids: list[int],
       change_reason: string,
       cascade_policy: enum,
       invoker: AuthenticatedUser,
       context: RequestContext)
       returns: ChangeCompositionOutput
       throws: SinPermiso, NotFound,
               PredefinedNotMutable,
               AccessGroupRetired,
               FunctionNotFound,
               FunctionInactive,
               ValidationError,
               CascadeSoDViolation,
               BDTimeout, AuditFalla

   data ChangeCompositionOutput:
     agr_id: int
     agr_code: string
     added: list[FunctionRef]
     removed: list[FunctionRef]
     skipped_add: list[SkippedDetail]
     skipped_remove: list[SkippedDetail]
     cascade_affected_user_count: int
     cascade_violations: list[ViolationDetail]
     change_reason: string
     changed_at: timestamp

   contract CascadeSoDValidator:
     validate(agr_id, delta_added,
              delta_removed, sod_rules)
       returns: ValidationResult
       throws: CascadeSoDViolation
                (violating_users_sample)

11.3 Pseudocodigo
=================

::

   procedure change_composition(...):
       require AuthenticationGuard
                 .is_valid(invoker)
       require AuthorizationGuard
                 .has_function(invoker,
                   'manage_access_group_composition')
       require ThrottlePolicy.is_allowed(invoker)

       PayloadValidator.validate(
         add_ids, remove_ids, change_reason)

       agr = AccessGroupRepository.get(agr_id)
       if not agr: raise NotFound
       if agr.is_predefined:
           raise PredefinedNotMutable
       if agr.state == RETIRED:
           raise AccessGroupRetired

       FunctionRepository.validate_active(
         add_ids + remove_ids)

       # Filtrar idempotencia
       current_function_ids =
         AccessGroupFunctionRepository
           .list_function_ids(agr_id)
       to_add =
         set(add_ids) - current_function_ids
       skipped_add =
         set(add_ids) & current_function_ids
       to_remove =
         set(remove_ids) & current_function_ids
       skipped_remove =
         set(remove_ids) - current_function_ids

       # Cascade users + SoD
       users_with_agr =
         CascadeUsersFinder
           .users_with_active_agr_assignment(
             agr_id)
       cascade_count = len(users_with_agr)

       if to_add or to_remove:
           sod_rules = SoDRuleRepository
                         .list_active()
           try:
               CascadeSoDValidator.validate(
                 agr_id, to_add, to_remove,
                 users_with_agr, sod_rules)
           except CascadeSoDViolation as e:
               if cascade_policy == STRICT:
                   AuditLog.emit(
                     event_type=
                       'ACCESS_GROUP_COMPOSITION_FAILED',
                     ...)
                   raise
               # else permissive: track and continue
               cascade_violations =
                 e.violating_users_sample

       result = TransactionManager.atomic(():
         AccessGroupFunctionRepository
           .bulk_insert([
             (agr_id, fid) for fid in to_add])
         AccessGroupFunctionRepository
           .bulk_delete([
             (agr_id, fid) for fid in to_remove])

         AuditLog.emit(
           event_type=
             'ACCESS_GROUP_COMPOSITION_CHANGED',
           actor_id=invoker.id,
           payload={
             agr_id, agr_code: agr.code,
             functions_added: list(to_add),
             functions_removed: list(to_remove),
             skipped_add: list(skipped_add),
             skipped_remove: list(skipped_remove),
             change_reason,
             cascade_affected_user_count:
               cascade_count,
             cascade_violations_count:
               len(cascade_violations),
             ip, user_agent})

         return {to_add, to_remove,
                 skipped_add, skipped_remove,
                 cascade_count,
                 cascade_violations}
       )

       # Cache invalidate cascade post-COMMIT
       for user in users_with_agr:
           PermissionCache.invalidate(user.id)

       return ChangeCompositionOutput(...)

11.4 Mapeo excepcion → HTTP
===========================

.. list-table::
 :widths: 40 20 40
 :header-rows: 1

 * - Excepcion
   - Status
   - Body code
 * - SinPermiso
   - 403
   - FORBIDDEN
 * - NotFound
   - 404
   - ACCESS_GROUP_NOT_FOUND
 * - PredefinedNotMutable
   - 400
   - PREDEFINED_NOT_MUTABLE
 * - AccessGroupRetired
   - 400
   - ACCESS_GROUP_RETIRED
 * - FunctionNotFound
   - 400
   - FUNCTION_NOT_FOUND
 * - FunctionInactive
   - 400
   - FUNCTION_INACTIVE
 * - ValidationError
   - 400
   - VALIDATION_ERROR
 * - CascadeSoDViolation (strict)
   - 409
   - CASCADE_SOD_VIOLATION

11.5 Restricciones cross-cutting
================================

- Atomicidad PASOS 12-15.
- Audit obligatorio (CNST-025).
- Cascade SoD obligatoria (P-48).
- Cache cascade post-COMMIT (P-29 escalado).
- Predefined inmutable (P-46).
- Sin PII en payload (CNST-026).

11.6 Stack-agnostico
====================

Cualquier stack que respete los contratos.

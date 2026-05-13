.. _uc-perm-05-parte-11:

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
 * - **HTTPCreateEndpoint**
   - POST ``/api/access-groups/``
 * - **HTTPPatchEndpoint**
   - PATCH ``/api/access-groups/{id}/``
 * - **HTTPDeleteEndpoint**
   - DELETE ``/api/access-groups/{id}/``
 * - **AuthorizationGuard**
   - Verificar ``manage_access_groups``
 * - **CodeValidator**
   - Regex + uniqueness
 * - **PredefinedGuard**
   - Bloquear PATCH/DELETE en predefinidos
 * - **AccessGroupRepository**
   - CRUD
 * - **UsersWithAGRCounter**
   - Contar Users con AGR ACTIVE (RETIRE)
 * - **RetirePolicy**
   - warn vs block
 * - **AGRViewCache**
   - invalidate post-COMMIT
 * - **AuditLog**
   - emit
 * - **TransactionManager**
   - Atomicidad

11.2 Contratos
==============

::

   contract AccessGroupAdminService:
     create(payload, invoker)
       returns: AccessGroup
       throws: SinPermiso, CodeDuplicate,
               ValidationError

     modify(agr_id, patch, invoker)
       returns: AccessGroup
       throws: SinPermiso, NotFound,
               PredefinedNotMutable,
               AlreadyRetired,
               CodeImmutable

     retire(agr_id, retire_reason, invoker)
       returns: AccessGroup
       throws: SinPermiso, NotFound,
               PredefinedNotMutable,
               AlreadyRetired,
               ValidationError,
               RetireHasUsers (strict only)

11.3 Pseudocodigo (crear)
=========================

::

   procedure create(payload, invoker, ctx):
       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker, 'manage_access_groups')

       CodeValidator.validate_format(payload.code)
       if AccessGroupRepository
            .exists_by_code(payload.code):
           raise CodeDuplicate

       result = TransactionManager.atomic(():
         agr = AccessGroupRepository.insert(
           code=payload.code,
           display_name=payload.display_name,
           description=payload.description,
           severity=payload.severity,
           is_predefined=False,
           state=ACTIVE,
           created_at=now(),
           created_by_admin_id=invoker.id)

         if payload.initial_function_ids:
             # FA-01 — delegar a UC_PERM_06
             AccessGroupFunctionService
               .bulk_assign(agr.id,
                            payload.initial_function_ids,
                            invoker)

         AuditLog.emit(
           event_type='ACCESS_GROUP_CREATED',
           actor_id=invoker.id,
           payload={agr_id, code, display_name,
                    severity, ip, user_agent})

         return agr
       )

       AGRViewCache.invalidate()
       return result

11.4 Pseudocodigo (retirar)
===========================

::

   procedure retire(agr_id, retire_reason,
                    invoker, ctx):
       require AuthorizationGuard...
       PayloadValidator.validate_reason(
         retire_reason, min=20)

       agr = AccessGroupRepository.get(agr_id)
       if not agr: raise NotFound
       if agr.is_predefined:
           raise PredefinedNotMutable
       if agr.state == RETIRED:
           raise AlreadyRetired

       (count, sample) =
         UsersWithAGRCounter
           .count_and_sample(agr_id,
                              sample_size=10)

       if RetirePolicy.is_strict() and count > 0:
           raise RetireHasUsers(count, sample)

       result = TransactionManager.atomic(():
         AccessGroupRepository.update(
           agr_id,
           state=RETIRED,
           retired_at=now(),
           retired_by_admin_id=invoker.id,
           retire_reason=retire_reason)

         AuditLog.emit(
           event_type='ACCESS_GROUP_RETIRED',
           actor_id=invoker.id,
           payload={agr_id, code: agr.code,
                    retire_reason,
                    users_with_agr_count: count,
                    ip, user_agent})

         return agr
       )

       AGRViewCache.invalidate()
       return result

11.5 Mapeo excepcion → HTTP
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
 * - AlreadyRetired
   - 400
   - ACCESS_GROUP_ALREADY_RETIRED
 * - CodeDuplicate
   - 409
   - CODE_DUPLICATE
 * - CodeImmutable
   - 400
   - CODE_IMMUTABLE
 * - ValidationError
   - 400
   - VALIDATION_ERROR
 * - RetireHasUsers
   - 409
   - RETIRE_HAS_USERS

11.6 Restricciones cross-cutting
================================

- Atomicidad por operacion.
- Audit obligatorio (CNST-025).
- PII fuera del payload (CNST-026).
- Cache post-COMMIT.
- Predefined inmutable (P-46).
- Retire-without-cascade (P-47).

11.7 Stack-agnostico
====================

Cualquier stack que respete los contratos.

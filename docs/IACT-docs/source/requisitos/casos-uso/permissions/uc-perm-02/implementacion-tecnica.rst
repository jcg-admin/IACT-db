.. _uc-perm-02-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 Implementacion abstracta. Aplica
 DEC-USR01-03. Backend logica delegada a
 :doc:`/requisitos/casos-uso/access/uc-acc-02/index`
 sobre Assignment AGR.

11.1 Componentes logicos
========================

Backend (heredados de UC_ACC_02):

- HTTPDeleteEndpoint, AuthenticationGuard,
  AuthorizationGuard, AssignmentRepository,
  WarningsCalculator, LastHolderPolicy,
  PermissionCache, AuditLog,
  TransactionManager.

Componentes vista PERM:

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPPreviewRevokeEndpoint**
   - GET preview-revoke (no persiste)
 * - **RevokePreviewService**
   - calcular impact + warnings sin
     persistir
 * - **AGRViewCache**
   - invalidar catalogo + counts post-revoke

11.2 Contratos
==============

::

   contract AccessService:
     revoke_access_group(target_user_id,
                         access_group_id,
                         revoke_reason,
                         notify_user: opt,
                         invoker, ctx)
       returns: RevokeAGROutput
       throws: SinPermiso, UserNotFound,
               InvalidUserState,
               SelfRevokeForbidden,
               AGRNotAssigned,
               LastHolderProtection,
               BDTimeout, AuditFalla

   data RevokeAGROutput:
     target_user_id, username
     access_group_id, access_group_code
     revoke_reason
     functions_count_revoked: int
     post_revoke_active_count: int
     warnings: WarningsBundle
     user_notified: bool
     revoked_at: timestamp

   contract RevokePreviewService:
     preview(target_user_id, agr_id, invoker)
       returns: RevokePreview
       # NO persiste

11.3 Pseudocodigo
=================

::

   procedure revoke_access_group(...):

       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard
                 .has_function(invoker,
                   'revoke_function_groups')
       require ThrottlePolicy.is_allowed(invoker)

       PayloadValidator.validate_revoke_reason(
         revoke_reason)

       target = UserRepository
                  .get_by_id_for_update(target_user_id)
       if not target: raise UserNotFound
       if target.state == ELIMINATED:
           raise InvalidUserState
       require AntiSelfActionPolicy.allows(
                 invoker, target, 'revoke_agr')

       assignment = AssignmentRepository
                      .find_active(
                        user_id=target.id,
                        target_type='AccessGroup',
                        target_id=access_group_id)
       if assignment is None:
           raise AGRNotAssigned

       # FA-02 idempotencia opcional segun politica

       # Calcular impact
       agr_function_ids =
         AccessGroupRepository
           .list_function_ids(access_group_id)
       current_effective =
         EffectivePermissionsAggregator
           .compute_set_only(target)
       functions_count_revoked =
         len(agr_function_ids - other_sources_set)
       post_revoke_active_count =
         len(current_effective) - functions_count_revoked

       warnings = WarningsCalculator.compute(...)

       if LastHolderPolicy.should_block(warnings):
           AuditLog.emit(AGR_REVOKE_FAILED, ...)
           raise LastHolderProtection

       result = TransactionManager.atomic(():
         AssignmentRepository.update_to_revoked(
           assignment.id,
           revoked_at=now(),
           revoked_by_admin_id=invoker.id,
           revoke_reason=revoke_reason)

         AuditLog.emit(
           event_type='AGR_REVOKED',
           actor_id=invoker.id,
           payload={target_user_id, agr_id,
                    access_group_code,
                    functions_count_revoked,
                    revoke_reason,
                    post_revoke_active_count,
                    warnings, ip, user_agent})

         if should_notify:
             InternalMailbox.send(...)

         return assignment, warnings
       )

       PermissionCache.invalidate(target.id)

       return RevokeAGROutput(...)

11.4 Mapeo excepcion → HTTP
===========================

Heredados de UC_ACC_02 + adicional:

.. list-table::
 :widths: 35 25 40
 :header-rows: 1

 * - Excepcion
   - Status
   - Body code
 * - AGRNotAssigned
   - 404
   - AGR_NOT_ASSIGNED

11.5 Restricciones cross-cutting
================================

Heredadas de UC_ACC_02. Adicional:

- Catalogo PERM cache invalidation
  post-COMMIT.

11.6 Stack-agnostico
====================

Cualquier stack que respete los contratos.

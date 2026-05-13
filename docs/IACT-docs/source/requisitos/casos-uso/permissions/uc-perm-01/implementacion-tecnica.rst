.. _uc-perm-01-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 **Implementacion abstracta**. Aplica
 DEC-USR01-03. Backend logica delegada a
 :doc:`/requisitos/casos-uso/access/uc-acc-04/index`
 (UC_ACC_04 backing). Esta parte documenta los
 componentes UI especificos de la vista PERM.

11.1 Componentes logicos
========================

Backend (heredados de UC_ACC_04):

- HTTPPostEndpoint, AuthenticationGuard,
  AuthorizationGuard, AccessGroupRepository,
  AssignmentRepository,
  EffectivePermissionsAggregator,
  SoDValidator, PermissionCache, AuditLog,
  TransactionManager.

Componentes adicionales para vista PERM:

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPListAGREndpoint**
   - GET ``/api/access-groups/`` (catalogo)
 * - **HTTPDetailAGREndpoint**
   - GET ``/api/access-groups/{id}/``
 * - **HTTPUsersByAGREndpoint**
   - GET ``/api/access-groups/{id}/users/``
 * - **HTTPPreviewAssignEndpoint**
   - GET preview-assign sin persistir
 * - **AGRCatalogService**
   - listar, detalle, count Users-por-AGR
 * - **AssignPreviewService**
   - calcula impact sin persistir
 * - **AGRViewCache**
   - cache de catalogo + counts
     (invalidate post-asignacion)

11.2 Contratos especificos PERM
===============================

::

   contract AGRCatalogService:
     list(filters, pagination, invoker)
       returns: PaginatedResult<AGRCatalogEntry>

     get_detail(agr_id, invoker)
       returns: AGRDetail (con composicion +
                user_count)

     list_users_for_agr(agr_id, pagination,
                        invoker)
       returns: PaginatedResult<UserBrief>

   contract AssignPreviewService:
     preview(target_user_id, agr_id, invoker)
       returns: AssignPreview
       # NO persiste, NO genera AuditEvent

   data AssignPreview:
     agr_id, target_user_id
     agr_total_functions: int
     functions_already_present_count: int
     functions_to_add_count: int
     estimated_sod_violations: int
     warnings: list[Warning]

11.3 Pseudocodigo (preview)
===========================

::

   procedure preview(target_user_id,
                     agr_id, invoker):
       require AuthorizationGuard
                 .has_function(invoker,
                   'assign_function_groups')
       # NO require ThrottlePolicy estricto
       # (read-only, low cost)

       target = UserRepository.get(target_user_id)
       agr = AccessGroupRepository.get(agr_id)
       if not target or not agr or
          agr.state != ACTIVE:
           raise PreviewError

       agr_function_ids =
         AccessGroupRepository
           .list_function_ids(agr_id)
       current_effective =
         EffectivePermissionsAggregator
           .compute_set_only(target)

       to_add = agr_function_ids - current_effective
       already = agr_function_ids ∩ current_effective

       sod_violations =
         SoDValidator
           .find_violations_info_mode(
             current_effective | agr_function_ids)

       return AssignPreview(...)

11.4 Mapeo excepcion → HTTP
===========================

Heredado de UC_ACC_04. Adicional:

.. list-table::
 :widths: 35 25 40
 :header-rows: 1

 * - Excepcion
   - Status
   - Body code
 * - PreviewError (User/AGR invalido)
   - 404
   - PREVIEW_TARGET_INVALID

11.5 Restricciones cross-cutting
================================

Backend: heredadas de UC_ACC_04
(atomicidad, audit, sin PII, cache
post-COMMIT, P-27 SoD write-time).

Vista PERM:

- Catalogo cache invalidacion
  post-asignacion.
- Preview sin side-effects.

11.6 Stack-agnostico
====================

Cualquier stack que respete los contratos.

.. _uc-perm-03-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 Backend logica delegada a
 :doc:`/requisitos/casos-uso/access/uc-acc-08/index`.

11.1 Componentes vista PERM
===========================

Backend (heredados UC_ACC_08):

- HTTPPostEndpoint, AuthenticationGuard,
  AuthorizationGuard,
  JustificationValidator,
  ExpirationPolicy, AntiSelfActionPolicy,
  ExceptionalPermissionRepository,
  SoDValidator, MailboxFailurePolicy=HARD,
  AuditLog (high-priority),
  TransactionManager.

Componentes UI especificos:

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPPreviewExcEndpoint**
   - GET preview sin persistir
 * - **GrantPreviewService**
   - calculo SoD impact + duration estimate
 * - **FunctionCatalogCache**
   - cache de funciones + counts
     excepcionales vigentes

11.2 Contratos
==============

::

   contract AccessService:
     grant_exceptional_permission(...)
       (heredado de UC_ACC_08)

   contract GrantPreviewService:
     preview(target_user_id, function_ids,
             expires_at, invoker)
       returns: GrantPreview
       # NO persiste

   data GrantPreview:
     target_user_id: int
     function_ids: list[int]
     duration_days: int
     estimated_sod_violations: int
     warnings: list[Warning]

11.3 Pseudocodigo
=================

Identico a UC_ACC_08 Parte 11.3 — sin cambios
backend.

UI agrega:

::

   procedure preview(target_user_id,
                     function_ids,
                     expires_at, invoker):
       # NO require throttle estricto
       require AuthorizationGuard.has_function(
                 invoker,
                 'grant_exceptional_permission')

       target = UserRepository.get(target_user_id)
       if not target: raise PreviewError

       current_effective =
         EffectivePermissionsAggregator
           .compute_set_only(target)
       effective_post_grant =
         current_effective | function_ids

       sod_violations =
         SoDValidator
           .find_violations_info_mode(
             effective_post_grant, rules)

       duration_days =
         (expires_at - now()).days

       return GrantPreview(...)

11.4 Restricciones cross-cutting
================================

Heredadas de UC_ACC_08 (atomicidad, mailbox
HARD, audit reforzado, PII fuera, time-
bounded grants).

11.5 Stack-agnostico
====================

Cualquier stack que respete los contratos.

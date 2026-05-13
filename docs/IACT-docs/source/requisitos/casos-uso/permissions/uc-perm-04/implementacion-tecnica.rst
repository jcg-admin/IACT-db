.. _uc-perm-04-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 Implementacion abstracta. Aplica
 DEC-USR01-03.

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPDeleteEndpoint**
   - DELETE
     ``/api/users/{id}/exceptional-permissions/{id}/``
 * - **AuthenticationGuard**
   - JWT (CNST-009)
 * - **AuthorizationGuard**
   - Verificar
     ``revoke_exceptional_permission``
 * - **AntiSelfActionPolicy**
   - P-11 configurable
 * - **ExceptionalPermissionRepository**
   - get, update_to_revoked
 * - **PayloadValidator**
   - reason ≥ 20 chars
 * - **PermissionCache**
   - invalidate post-COMMIT
 * - **InternalMailbox**
   - send obligatorio (HARD)
 * - **AuditLog**
   - emit high-priority
 * - **TransactionManager**
   - Atomicidad

11.2 Contratos
==============

::

   contract AccessService:
     revoke_exceptional_permission(
       target_user_id, permission_id,
       revoke_reason, invoker, ctx)
       returns: RevokeExceptionalOutput
       throws: SinPermiso, PermissionNotFound,
               InvalidState, URLMismatch,
               SelfRevokeForbidden,
               ValidationError,
               MailboxFailure,
               BDTimeout, AuditFalla

   data RevokeExceptionalOutput:
     permission_id: int
     target_user_id: int
     function_id: int
     function_code: string
     state: enum {REVOKED}
     revoked_at: timestamp
     revoked_by_admin_id: int
     revoke_reason: string
     previous_expires_at: timestamp
     user_notified: bool

   contract ExceptionalPermissionRepository:
     get_by_id(permission_id)
       returns: opt[ExceptionalPermission]
     update_to_revoked(permission_id,
                       revoked_at,
                       revoked_by_admin_id,
                       revoke_reason)

11.3 Pseudocodigo
=================

::

   procedure revoke_exceptional_permission(
             target_user_id, permission_id,
             revoke_reason, invoker, ctx):

       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker,
                 'revoke_exceptional_permission')
       require ThrottlePolicy.is_allowed(invoker)

       PayloadValidator.validate_reason(
         revoke_reason, min_length=20)

       permission = ExceptionalPermissionRepository
                      .get_by_id(permission_id)
       if permission is None:
           raise PermissionNotFound

       if permission.user_id != target_user_id:
           raise URLMismatch

       if permission.state == REVOKED:
           # FA-01 idempotencia
           AuditLog.emit(
             event_type=
               'EXCEPTIONAL_PERMISSION_REVOKE_NOOP',
             actor_id=invoker.id,
             payload={
               permission_id: permission.id,
               original_revoked_at:
                 permission.revoked_at,
               original_revoked_by_admin_id:
                 permission.revoked_by_admin_id,
               original_revoke_reason:
                 permission.revoke_reason})
           return RevokeExceptionalOutput(
             ..., already_revoked=True)

       if permission.state == EXPIRED:
           raise InvalidState

       require AntiSelfActionPolicy.allows(
                 invoker, permission.user,
                 'revoke_exceptional')

       result = TransactionManager.atomic(():
         ExceptionalPermissionRepository
           .update_to_revoked(
             permission_id=permission.id,
             revoked_at=now(),
             revoked_by_admin_id=invoker.id,
             revoke_reason=revoke_reason)

         try:
             InternalMailbox.send(
               recipient_id=permission.user_id,
               subject='Permiso temporal revocado',
               body=build_revoke_body(
                 permission, revoke_reason))
         except MailboxError:
             raise MailboxFailure

         AuditLog.emit(
           event_type=
             'EXCEPTIONAL_PERMISSION_REVOKED',
           actor_id=invoker.id,
           payload={
             permission_id: permission.id,
             target_user_id: permission.user_id,
             function_id: permission.function_id,
             function_code:
               permission.function.code,
             revoke_reason: revoke_reason,
             previous_expires_at:
               permission.expires_at,
             ip: ctx.ip,
             user_agent: ctx.user_agent})

         return permission
       )

       PermissionCache.invalidate(
         result.user_id)

       return RevokeExceptionalOutput(...)

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
 * - PermissionNotFound
   - 404
   - PERMISSION_NOT_FOUND
 * - InvalidState (EXPIRED)
   - 400
   - INVALID_STATE
 * - URLMismatch
   - 400
   - URL_MISMATCH
 * - SelfRevokeForbidden
   - 400
   - SELF_REVOKE_FORBIDDEN
 * - ValidationError
   - 400
   - VALIDATION_ERROR
 * - MailboxFailure
   - 500
   - MAILBOX_FAILED
 * - BDTimeout
   - 503
   - DB_TIMEOUT
 * - AuditFalla
   - 500
   - AUDIT_FAILED

11.5 Restricciones cross-cutting
================================

- Atomicidad PASOS 11-14.
- Mailbox HARD (P-10).
- Audit obligatorio + high-priority.
- PII fuera del payload (CNST-026).
- Cache post-COMMIT (P-29).
- Reason-required ≥ 20 chars (P-32).

11.6 Stack-agnostico
====================

Cualquier stack que respete los contratos.

.. _uc-acc-08-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 Especificacion abstracta. Aplica
 DEC-USR01-03.

11.1 Componentes logicos
========================

Similar a UC_ACC_01 pero:

- ``ExceptionalPermissionRepository`` (no
  Assignment).
- ``ExpirationPolicy`` con bounds estrictos
  (NOW()+1h ≤ x ≤ NOW()+30d).
- ``MailboxFailurePolicy = HARD`` (vs softer
  en UC_USR_04).
- ``JustificationValidator`` (≥ 20 chars +
  ticket_reference si politica).

11.2 Contratos
==============

::

   contract AccessService:
     grant_exceptional_permission(
       target_user_id, function_ids,
       expires_at, justification,
       ticket_reference: opt,
       invoker, ctx)
       returns: GrantExceptionalOutput
       throws: SinPermiso, UserNotFound,
               InvalidUserState,
               SelfGrantForbidden,
               ValidationError,
               FunctionNotFound,
               FunctionInactive,
               SoDViolation,
               MailboxFailure,
               TicketReferenceRequired,
               BDTimeout, AuditFalla

   data GrantExceptionalOutput:
     target_user_id, username
     granted: list[ExceptionalDetail]
     skipped: list[SkippedDetail]
     justification: string
     ticket_reference: opt[string]
     user_notified: bool
     sod_rules_evaluated: int
     granted_at

   contract ExceptionalPermissionRepository:
     list_active_for_user(user, NOW())
     bulk_insert(...)

11.3 Pseudocodigo
=================

Similar a UC_ACC_01 pero con:

- PASO 9: validar justification ≥ 20 chars
  + expires_at bounds estrictos (1h-30d) +
  ticket_reference si politica.
- PASO 13: INSERT en ExceptionalPermission.
- PASO 15: InternalMailbox.send con
  MailboxFailurePolicy=HARD (lanza si falla).
- PASO 16: AuditEvent payload reforzado con
  justification, ticket_reference, expires_at.

11.4 Mapeo excepcion → HTTP
===========================

Igual a UC_ACC_01 + EX-XX especificas:

.. list-table::
 :widths: 40 20 40
 :header-rows: 1

 * - Excepcion
   - Status
   - Body code
 * - SelfGrantForbidden
   - 400
   - SELF_GRANT_FORBIDDEN
 * - ValidationError (justification corta)
   - 400
   - VALIDATION_ERROR
 * - ValidationError (expires_at bounds)
   - 400
   - VALIDATION_ERROR
 * - TicketReferenceRequired
   - 400
   - TICKET_REFERENCE_REQUIRED
 * - MailboxFailure
   - 500
   - MAILBOX_FAILED

11.5 Restricciones cross-cutting
================================

- Atomicidad PASOS 13-16.
- Mailbox HARD (P-10).
- Audit reforzado.
- PII fuera (CNST-026).
- Cache post-COMMIT.
- Time-bounded grants (P-38) — bounds en
  validator.

11.6 Stack-agnostico
====================

Cualquier stack que respete los contratos.

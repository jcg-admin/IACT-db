.. _uc-acc-08-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF
=================

- **Strategy**: ExpirationPolicy bounds.
- **Repository**:
  ExceptionalPermissionRepository.
- **Specification**: SoDRule reused de
  UC_ACC_05.
- **Chain of Responsibility**: pipeline.
- **Observer**: AuditLog.
- **Template Method**: flujo + sub-flujos.

10.2 Patrones IACT
==================

- P-08 Fail-closed.
- P-09 Audit-or-abort.
- P-10 Mailbox-or-abort HARD (vs softer en
  UC_USR_04).
- P-11 Anti-self-action.
- P-15 RBAC granular
  ``grant_exceptional_permission`` distinta y
  mas restringida que ``assign_functions``.
- P-22 Idempotencia parcial.
- P-27 SoD write-time.
- P-28 All-or-nothing.
- P-29 Cache post-COMMIT.
- P-32 Reason-required (justification + ≥ 20
  chars).
- P-38 Time-bounded grants: expires_at
  obligatorio (BR-008 estricto). No hay
  permisos excepcionales permanentes.
- P-39 Audit reforzado: payload incluye
  justification + ticket_reference para
  trazabilidad de compliance.

10.3 Anti-patrones evitados
===========================

- Permiso excepcional permanente (P-38 hard).
- Grant sin justification (P-32 + EX-06).
- Auto-grant (P-11 + EX-05).
- Mailbox softer (P-10 hard — la notificacion
  al User es parte del compliance).

10.4 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - Strategy
   - GoF
   - ExpirationPolicy
 * - Repository
   - GoF
   - ExceptionalPermission
 * - Specification
   - GoF
   - SoDRule
 * - Chain of Responsibility
   - GoF
   - Pipeline
 * - Observer
   - GoF
   - AuditLog
 * - Template Method
   - GoF
   - Flujo
 * - P-08 Fail-closed
   - IACT
   - Transaccion
 * - P-09 Audit-or-abort
   - IACT
   - EX-13
 * - P-10 Mailbox-or-abort HARD
   - IACT
   - EX-11
 * - P-11 Anti-self-action
   - IACT
   - EX-05
 * - P-15 RBAC granular
   - IACT
   - grant_exceptional_permission
 * - P-22 Idempotencia parcial
   - IACT
   - FA-02
 * - P-27 SoD write-time
   - IACT
   - PASO 12
 * - P-28 All-or-nothing
   - IACT
   - EX-09
 * - P-29 Cache post-COMMIT
   - IACT
   - PermissionCache
 * - P-32 Reason-required
   - IACT
   - justification
 * - P-38 Time-bounded grants
   - IACT
   - expires_at obligatorio
 * - P-39 Audit reforzado
   - IACT
   - justification + ticket_reference

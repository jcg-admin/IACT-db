.. _uc-acc-02-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF aplicables
============================

10.1.1 Repository / DAO
-----------------------

``AssignmentRepository`` con metodos
``list_active``, ``update_to_revoked``.
``UserRepository`` para validacion del target.

10.1.2 Strategy
---------------

- ``LastHolderPolicy`` (warn-only vs block).
- ``NotifyOnRevokeStrategy`` (notify yes/no
  default).

10.1.3 Specification
--------------------

``CriticalFunctionSpec`` y ``LastHolderSpec``
componibles para evaluar warnings post-revoke.

10.1.4 Chain of Responsibility
------------------------------

Pipeline:
authentication → permission(revoke_functions)
→ throttle → request validator → user
existence → user state → P-11 anti-self →
matched assignments → warnings → persistence.

10.1.5 Observer
---------------

AuditLog observa
FUNCTIONS_REVOKED/NOOP/FAILED.

10.1.6 Template Method
----------------------

Secuencia rigida del flujo. Sub-flujos (FA-01
NOOP, FA-04 last-holder) sobreescriben
sub-pasos.

10.1.7 Composite of Side-Effects
--------------------------------

UPDATE masivo + AuditEvent + InternalMessage
opcional + cache invalidate.

10.2 Patrones IACT especificos
==============================

10.2.1 P-08 Fail-closed en transacciones
----------------------------------------

PASOS 12-15 atomicos. Si alguno falla,
ROLLBACK total.

10.2.2 P-09 Audit-or-abort
--------------------------

EX-08 — sin AuditEvent no se acepta la
revocacion.

10.2.3 P-11 Anti-self-action
----------------------------

EX-04 — invocante no puede auto-revocar.
Defensa fundamental contra lockout
(especialmente revoke_functions).

10.2.4 P-15 RBAC granular
-------------------------

``revoke_functions`` distinta de
``assign_functions`` (UC_ACC_01) y de
``deactivate_users`` (UC_USR_04).

10.2.5 P-22 Idempotencia parcial
--------------------------------

Re-revocar funcion ya REVOKED es no-op.
Permite retries seguros.

10.2.6 P-23 Soft-delete obligatorio (BR-009)
--------------------------------------------

``Assignment.state ACTIVE → REVOKED`` (no
DELETE). Historial preservado.

10.2.7 P-29 Cache invalidation post-COMMIT
------------------------------------------

PermissionCache.invalidate FUERA de la TX.

10.2.8 P-30 Notif legible
-------------------------

InternalMessage usa display_names.

10.2.9 P-31 Warnings post-revoke
--------------------------------

**Aplica a**: PASO 11. La operacion no se
bloquea (excepto last_holder strict) pero se
calculan warnings:

- ``no_functions``: User queda sin nada.
- ``critical_revoked``: revoca funcion en
  CRITICAL_FUNCTIONS (politica).
- ``last_holder``: User era de los pocos que
  tenian la funcion.

Warnings se entregan en response y AuditEvent
para visibilidad. Decisiones operacionales
informadas, no decisiones bloqueadas (default).

10.2.10 P-32 Reason-required
----------------------------

``revoke_reason`` obligatorio. Defensa
auditabilidad — toda revocacion documentada
con motivo. Defensa contra revocaciones
"silenciosas" sin justificacion.

10.3 Anti-patrones evitados
===========================

10.3.1 DELETE fisico de Assignments
-----------------------------------

**No aplica**: BR-009 + P-23. UPDATE state.

10.3.2 Revocacion sin reason
----------------------------

**No aplica**: P-32. EX-06 bloquea.

10.3.3 Auto-revoke permitido
----------------------------

**No aplica**: P-11. Lockout protection.

10.3.4 Last holder revoke silencioso
------------------------------------

**No aplica**: P-31 warns; politica strict
bloquea.

10.4 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - Repository
   - GoF
   - Assignment / User
 * - Strategy
   - GoF
   - LastHolder / Notify
 * - Specification
   - GoF
   - CriticalFunctionSpec, LastHolderSpec
 * - Chain of Responsibility
   - GoF
   - Pipeline middleware
 * - Observer
   - GoF
   - AuditLog
 * - Template Method
   - GoF
   - Flujo + sub-flujos
 * - Composite Side-Effects
   - GoF
   - UPDATE + audit + cache + notify
 * - P-08 Fail-closed
   - IACT
   - Transaccion
 * - P-09 Audit-or-abort
   - IACT
   - EX-08
 * - P-11 Anti-self-action
   - IACT
   - EX-04
 * - P-15 RBAC granular
   - IACT
   - revoke_functions atomica
 * - P-22 Idempotencia parcial
   - IACT
   - FA-01
 * - P-23 Soft-delete
   - IACT
   - BR-009
 * - P-29 Cache post-COMMIT
   - IACT
   - PermissionCache.invalidate
 * - P-30 Notif legible
   - IACT
   - display_names
 * - P-31 Warnings post-revoke
   - IACT
   - no_functions / critical / last_holder
 * - P-32 Reason-required
   - IACT
   - revoke_reason obligatorio

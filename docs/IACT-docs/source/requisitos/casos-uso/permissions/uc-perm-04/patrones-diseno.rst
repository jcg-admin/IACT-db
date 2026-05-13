.. _uc-perm-04-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF
=================

- Repository (ExceptionalPermission).
- Strategy (NotifyOnRevoke).
- Chain of Responsibility (pipeline).
- Observer (AuditLog).
- Template Method (flujo + sub-flujos).

10.2 Patrones IACT
==================

- P-08 Fail-closed.
- P-09 Audit-or-abort.
- P-10 Mailbox-or-abort HARD (notificacion
  obligatoria por compliance).
- P-11 Anti-self-action (configurable).
- P-15 RBAC granular
  (revoke_exceptional_permission distinta de
  grant_exceptional_permission).
- P-22 Idempotencia (FA-01).
- P-23 Soft-delete (state=REVOKED, no
  DELETE).
- P-29 Cache post-COMMIT.
- P-32 Reason-required.
- P-39 Audit reforzado high-priority.

10.3 Patrones especificos
=========================

10.3.1 P-45 Distincion explicita REVOKED vs EXPIRED
---------------------------------------------------

**Aplica a**: la maquina de estados
ExceptionalPermission distingue dos vias de
salida:

- REVOKED: explicito por admin
  (``revoked_by_admin_id != NULL``).
- EXPIRED: automatico por cron
  (``revoked_by_admin_id == NULL``).

AuditEvent diferenciado preserva razones
operacionales: REVOKED por intervencion
correctiva vs EXPIRED por completion del
ciclo.

10.4 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - GoF estandar
   - GoF
   - Repository, Strategy, etc.
 * - P-08..32, P-39
   - IACT
   - heredados
 * - P-45 REVOKED vs EXPIRED
   - IACT
   - Distincion explicita en estado

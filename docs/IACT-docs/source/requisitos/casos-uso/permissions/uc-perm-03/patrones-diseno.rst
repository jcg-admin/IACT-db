.. _uc-perm-03-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Heredados de UC_ACC_08
===========================

GoF: Strategy (ExpirationPolicy),
Repository, Specification (SoDRule),
Chain of Responsibility, Observer,
Template Method.

IACT: P-08 fail-closed, P-09 audit-or-abort,
P-10 mailbox-or-abort HARD, P-11
anti-self-action, P-15 RBAC granular, P-22
idempotencia parcial, P-27 SoD write-time,
P-28 all-or-nothing, P-29 cache post-COMMIT,
P-32 reason-required, P-38 time-bounded
grants, P-39 audit reforzado.

10.2 Especificos vista PERM
===========================

10.2.1 P-41 Vista alternativa con backing
-----------------------------------------

Coexistencia ACC↔PERM (ADR-GOB-008).

10.2.2 P-42 Preview pre-write
-----------------------------

GET preview-exceptional sin persistir.

10.2.3 P-44 Visibility de high-priority audit
---------------------------------------------

**Aplica a**: la UI PERM expone explicitamente
al invocante "esta operacion sera auditada
con visibilidad alta" en el modal de
confirmacion. Defensa contra usos abusivos —
el invocante decide informadamente sabiendo
que la operacion sera escrutinada.

10.3 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - GoF + IACT heredados
   - varios
   - de UC_ACC_08 backing
 * - P-41 Vista alternativa
   - IACT
   - coexistencia ACC↔PERM
 * - P-42 Preview pre-write
   - IACT
   - GET preview
 * - P-44 Visibility audit prio
   - IACT
   - banner en modal

.. _uc-perm-02-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Heredados de UC_ACC_02
===========================

GoF: Repository, Strategy
(LastHolderPolicy, NotifyOnRevoke),
Specification, Chain of Responsibility,
Observer, Template Method.

IACT: P-08 fail-closed, P-09 audit-or-abort,
P-11 anti-self-action, P-15 RBAC granular,
P-22 idempotencia parcial, P-23 soft-delete,
P-29 cache post-COMMIT, P-30 notif legible,
P-31 warnings post-revoke, P-32
reason-required.

10.2 Especificos vista PERM
===========================

10.2.1 P-41 Vista alternativa con backing
-----------------------------------------

Coexistencia ACC↔PERM. Backend compartido.
ADR-GOB-008.

10.2.2 P-42 Preview pre-write
-----------------------------

GET preview-revoke sin persistir.

10.2.3 P-43 Doble confirmacion ante warnings
--------------------------------------------

**Aplica a**: cuando preview detecta warnings
criticos (no_functions, critical_revoked,
last_holder), modal pide confirmacion
literal ("REVOCAR"). Defensa contra
revocaciones impulsivas con impact alto.

10.3 Anti-patrones evitados
===========================

- Backend duplicado (P-41).
- Preview que persiste (P-42).
- Confirmacion simple ante operaciones
  destructivas con warning critico (P-43).

10.4 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - GoF heredados
   - GoF
   - de UC_ACC_02 backing
 * - IACT heredados
   - IACT
   - P-08, P-09, P-11, P-15, P-22, P-23,
     P-29, P-30, P-31, P-32
 * - P-41 Vista alternativa
   - IACT
   - coexistencia ACC↔PERM
 * - P-42 Preview pre-write
   - IACT
   - GET preview-revoke
 * - P-43 Doble confirmacion warnings
   - IACT
   - modal con literal "REVOCAR"

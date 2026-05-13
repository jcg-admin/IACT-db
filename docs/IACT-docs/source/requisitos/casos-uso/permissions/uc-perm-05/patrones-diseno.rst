.. _uc-perm-05-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF
=================

- Repository (AccessGroup).
- Strategy (RetirePolicy warn vs block).
- Chain of Responsibility (pipeline).
- Observer (AuditLog).
- Template Method (CRUD esqueleto).

10.2 Patrones IACT
==================

- P-08 Fail-closed (atomic).
- P-09 Audit-or-abort.
- P-15 RBAC granular
  (manage_access_groups distinta de assign).
- P-23 Soft-delete (RETIRED).
- P-29 Cache post-COMMIT.
- P-32 Reason-required.
- P-36 Immutable critical fields (``code``).

10.3 Especificos
================

10.3.1 P-46 Predefined Inmutable
--------------------------------

**Aplica a**: AGRs ``is_predefined=true``
NO se modifican via UC_PERM_05. Defensa
contra alteracion accidental del catalogo
estandar (AGR-001..010 son contrato del
sistema).

10.3.2 P-47 Retire-without-cascade
----------------------------------

**Aplica a**: retirar AGR del catalogo NO
cascade-revoke los Assignments existentes.
Defensa contra revocaciones masivas
silenciosas. Los Users con AGR retirado lo
mantienen hasta revocacion explicita.

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
 * - IACT heredados
   - IACT
   - P-08, P-09, P-15, P-23, P-29, P-32,
     P-36
 * - P-46 Predefined Inmutable
   - IACT
   - AGR-001..010 inmutable
 * - P-47 Retire-without-cascade
   - IACT
   - retiro NO revoca Assignments

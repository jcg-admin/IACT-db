.. _uc-acc-04-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF
=================

10.1.1 Composite (AGR como agregacion)
--------------------------------------

AGR contiene N funciones via tabla pivote
``AccessGroupFunction``. UC_ACC_04 asigna el
AGR como un todo, pero la evaluacion SoD se
hace sobre el conjunto de funciones
expandido.

10.1.2 Strategy
---------------

- ``AGRExpansionStrategy``: como expandir el
  AGR (eager vs lazy).
- ``IdempotencyPolicy``.
- ``NotifyOnAssignAGRStrategy``.

10.1.3 Repository
-----------------

``AssignmentRepository``,
``AccessGroupRepository``.

10.1.4 Chain of Responsibility
------------------------------

Pipeline middleware estandar.

10.1.5 Observer
---------------

AuditLog.

10.1.6 Template Method
----------------------

Flujo + sub-flujos (FA-01 NOOP, FA-04
re-asignacion).

10.2 Patrones IACT
==================

10.2.1 P-08 Fail-closed
-----------------------

PASOS 13-15 atomicos.

10.2.2 P-09 Audit-or-abort
--------------------------

Sin AuditEvent no se acepta.

10.2.3 P-11 Anti-self-action
----------------------------

EX-05 configurable.

10.2.4 P-15 RBAC granular
-------------------------

``assign_function_groups`` distinta de
``assign_functions``.

10.2.5 P-22 Idempotencia
------------------------

FA-01 NOOP.

10.2.6 P-27 SoD write-time
--------------------------

CNST-005.

10.2.7 P-28 All-or-nothing SoD
------------------------------

Si CUALQUIER funcion del AGR viola SoD, el
AGR no se asigna (rollback total). NO se
asignan parcialmente las funciones que no
violan.

10.2.8 P-29 Cache post-COMMIT
-----------------------------

PermissionCache.invalidate post-COMMIT.

10.2.9 P-35 AGR como unidad de granularidad
-------------------------------------------

**Aplica a**: el UC trabaja sobre AGR como
unidad. La SoD se evalua sobre las funciones
expandidas (no sobre el AGR como entidad).
La trazabilidad de origen de cada funcion en
UC_ACC_03 distingue ``via_agr:{agr_id}``,
permitiendo reverse lookup desde funcion a
AGR origen.

10.3 Anti-patrones evitados
===========================

- DELETE fisico (BR-009 / P-23).
- Asignacion parcial silenciosa (P-28).
- AGR como unidad de SoD (la SoD es entre
  funciones, no entre AGRs).
- Auto-asignacion permitida sin politica.

10.4 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - Composite
   - GoF
   - AGR ⇒ funciones
 * - Strategy
   - GoF
   - Expansion / Idempotency / Notify
 * - Repository
   - GoF
   - Assignment / AGR
 * - Chain of Responsibility
   - GoF
   - Pipeline
 * - Observer
   - GoF
   - AuditLog
 * - Template Method
   - GoF
   - Flujo + sub-flujos
 * - P-08 Fail-closed
   - IACT
   - Transaccion
 * - P-09 Audit-or-abort
   - IACT
   - EX-11
 * - P-11 Anti-self-action
   - IACT
   - EX-05
 * - P-15 RBAC granular
   - IACT
   - assign_function_groups atomica
 * - P-22 Idempotencia
   - IACT
   - FA-01
 * - P-27 SoD write-time
   - IACT
   - PASO 12
 * - P-28 All-or-nothing
   - IACT
   - rollback ante SoD
 * - P-29 Cache post-COMMIT
   - IACT
   - PermissionCache.invalidate
 * - P-35 AGR como unidad
   - IACT
   - granularidad de asignacion

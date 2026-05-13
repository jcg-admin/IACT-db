.. _uc-acc-05-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF
=================

10.1.1 Specification
--------------------

``SoDRule`` es una Specification que evalua
si un set de funciones la viola.

10.1.2 Repository
-----------------

``SoDRuleRepository``,
``FunctionRepository``.

10.1.3 Strategy
---------------

- ``ImmutabilityPolicy`` para function_ids
  (immutable post-create vs migracion explicita).
- ``CacheInvalidationStrategy``.

10.1.4 Chain of Responsibility
------------------------------

Pipeline middleware estandar.

10.1.5 Observer
---------------

AuditLog + SoDRuleCache observers que se
notifican post-CRUD.

10.1.6 Template Method
----------------------

Sub-flujos con esqueleto comun (auth → RBAC
→ validar → persistir → cache → audit).

10.2 Patrones IACT
==================

10.2.1 P-08 Fail-closed
-----------------------

Sub-flujos atomicos (CRUD + audit + cache).

10.2.2 P-09 Audit-or-abort
--------------------------

Sin AuditEvent no se acepta el cambio
(CNST-025).

10.2.3 P-15 RBAC granular
-------------------------

``view_separation_rules`` (lectura) distinta
de ``manage_separation_rules`` (CRUD). El
auditor puede tener solo lectura.

10.2.4 P-16 Audit selectivo
---------------------------

Listado amplio NO se audita; lectura
focalizada (filter rule_id) SI.

10.2.5 P-23 Soft-delete (BR-009)
--------------------------------

DELETE → ``state=RETIRED`` (no DELETE fisico).

10.2.6 P-29 Cache post-COMMIT
-----------------------------

SoDRuleCache.invalidate post-COMMIT para
notificar a UC_ACC_01/04/PERM_03.

10.2.7 P-32 Reason-required
---------------------------

``retire_reason`` obligatorio (EX-08).

10.2.8 P-36 Immutable critical fields
-------------------------------------

``function_ids`` de SoDRule es inmutable
post-create. Modificacion de la composicion
de la regla requiere migracion explicita
(RETIRE old + CREATE new). Defensa contra
cambios silenciosos que afectarian
enforcement retroactivamente sin trazabilidad.

10.2.9 P-37 Visibility de impact retroactivo
--------------------------------------------

Crear regla nueva calcula
``existing_violations_count`` y entrega
sample. Permite al admin entender el impact
de la nueva politica antes de comunicarla.

10.3 Anti-patrones evitados
===========================

10.3.1 Cambiar function_ids in-place
------------------------------------

**No aplica**: P-36. Requiere migracion
explicita.

10.3.2 DELETE fisico
--------------------

**No aplica**: P-23.

10.3.3 Auditar listado amplio
-----------------------------

**No aplica**: P-16.

10.3.4 Bloquear creacion de regla con violations
------------------------------------------------

**No aplica**: FA-03 — la regla es politica
nueva, debe entrar; las violaciones se
resuelven aparte (UC_ACC_02).

10.4 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - Specification
   - GoF
   - SoDRule.is_violated_by
 * - Repository
   - GoF
   - SoDRule / Function
 * - Strategy
   - GoF
   - ImmutabilityPolicy
 * - Chain of Responsibility
   - GoF
   - Pipeline
 * - Observer
   - GoF
   - AuditLog + Cache
 * - Template Method
   - GoF
   - Sub-flujos comunes
 * - P-08 Fail-closed
   - IACT
   - Transaccion
 * - P-09 Audit-or-abort
   - IACT
   - CNST-025
 * - P-15 RBAC granular
   - IACT
   - view vs manage
 * - P-16 Audit selectivo
   - IACT
   - filter rule_id
 * - P-23 Soft-delete
   - IACT
   - state=RETIRED
 * - P-29 Cache post-COMMIT
   - IACT
   - SoDRuleCache.invalidate
 * - P-32 Reason-required
   - IACT
   - retire_reason
 * - P-36 Immutable critical fields
   - IACT
   - function_ids inmutable
 * - P-37 Visibility retroactiva
   - IACT
   - existing_violations_count

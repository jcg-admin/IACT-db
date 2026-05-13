.. _uc-perm-06-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF
=================

- Repository (AccessGroupFunction).
- Strategy (CascadePolicy strict vs
  permissive).
- Specification (SoDRule).
- Visitor (cascade per User).
- Chain of Responsibility (pipeline).
- Observer (AuditLog).
- Template Method.

10.2 Patrones IACT
==================

- P-08 Fail-closed.
- P-09 Audit-or-abort.
- P-15 RBAC granular
  (manage_access_group_composition distinta
  de manage_access_groups).
- P-22 Idempotencia parcial.
- P-27 SoD write-time.
- P-28 All-or-nothing escalado a cascade.
- P-29 Cache post-COMMIT (cascade).
- P-32 Reason-required (change_reason).
- P-46 Predefined Inmutable.

10.3 Especificos
================

10.3.1 P-48 Cascade SoD Validation
----------------------------------

**Aplica a**: cuando un cambio en composicion
de AGR afecta N Users con AGR ACTIVE, SoD
debe validarse para cada User considerando
su effective_set + delta. Defensa
fundamental contra violaciones masivas
silenciosas.

10.3.2 P-49 Composition-Affects-Cascade
---------------------------------------

**Aplica a**: cambios en AccessGroupFunction
afectan inmediatamente todos los Users con
AGR ACTIVE. AuditEvent documenta
cascade_affected_user_count para
trazabilidad.

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
   - varios
 * - IACT heredados
   - IACT
   - P-08, P-09, P-15, P-22, P-27, P-29,
     P-32, P-46
 * - P-28 escalado a cascade
   - IACT
   - rollback total ante cascade SoD
 * - P-48 Cascade SoD Validation
   - IACT
   - validacion per User con AGR
 * - P-49 Composition-Affects-Cascade
   - IACT
   - effective sets propagation

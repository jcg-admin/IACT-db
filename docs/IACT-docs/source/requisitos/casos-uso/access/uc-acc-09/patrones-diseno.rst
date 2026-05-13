.. _uc-acc-09-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF
=================

- **Repository**: AuditEventRepository.
- **Specification**: filtros componibles.
- **Strategy**: AggregationStrategy
  (group_by event_type vs actor vs target).
- **Visitor**: para mascarado / formato
  por event_type.
- **Chain of Responsibility**: pipeline.

10.2 Patrones IACT
==================

- P-15 RBAC granular: ``view_access_audit``
  (lectura) distinta de
  ``manage_separation_rules``,
  ``view_assignments``.
- P-16 Audit selectivo: solo se audita
  consultas focalizadas (target_user_id).
- P-19 Field masking en listados.
- P-20 Whitelist anti-SQLi (filtros y
  ordering).
- P-40 Subset audit view: el UC pre-filtra
  por ``ACCESS_EVENT_TYPES`` para que el
  invocante solo vea eventos del modulo
  Access (defensa principio least
  privilege — auditor de Access no ve
  events de RPT u otros modulos sin
  privilegio adicional).

10.3 Anti-patrones evitados
===========================

- Vista de todos los eventos sin filtro
  (P-40 evita esto).
- Auditar listado amplio (P-16).
- Filtros sin whitelist (P-20).

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
   - AuditEvent
 * - Specification
   - GoF
   - Filtros
 * - Strategy
   - GoF
   - Aggregations
 * - Visitor
   - GoF
   - Mascarado por event_type
 * - Chain of Responsibility
   - GoF
   - Pipeline
 * - P-15 RBAC granular
   - IACT
   - view_access_audit
 * - P-16 Audit selectivo
   - IACT
   - filter target_user_id
 * - P-19 Field masking
   - IACT
   - sin email/full_name
 * - P-20 Whitelist anti-SQLi
   - IACT
   - filtros + ordering
 * - P-40 Subset audit view
   - IACT
   - pre-filtro ACCESS_EVENT_TYPES

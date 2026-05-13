.. _uc-perm-01-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF
=================

Heredados del backing UC_ACC_04 (Composite,
Strategy, Repository, Chain of
Responsibility, Observer, Template Method).

10.2 Patrones IACT
==================

Heredados de UC_ACC_04: P-08 fail-closed,
P-09 audit-or-abort, P-11 anti-self-action,
P-15 RBAC granular, P-22 idempotencia, P-27
SoD write-time, P-28 all-or-nothing, P-29
cache post-COMMIT, P-35 AGR como unidad de
granularidad.

10.3 Patrones especificos vista PERM
====================================

10.3.1 P-41 Vista alternativa con backing comun
-----------------------------------------------

**Aplica a**: la coexistencia ACC↔PERM
documentada en ADR-GOB-008. Dos vistas UI
distintas con backend compartido. Beneficios:

- Flexibilidad de UX por audiencia (operacion
  vs governance).
- Auditoria unificada (mismo
  ``event_type`` AGR_ASSIGNED — no se
  distingue origen UI).
- Mantenimiento minimizado (un backend
  compartido vs dos paralelos).

10.3.2 P-42 Preview pre-write
-----------------------------

**Aplica a**: GET preview-assign sin
persistir. Permite al invocante (audiencia
de governance) decidir informadamente sin
side-effects.

10.3.3 P-30 Notif legible
-------------------------

Heredado: el modal de la vista PERM expone
display_names de funciones (no IDs).

10.4 Anti-patrones evitados
===========================

- Backend duplicado por vista. Se evita —
  P-41.
- Preview que persiste. Se evita — P-42.
- Audit con metadata de UI origen. Se evita
  (irrelevante para compliance).

10.5 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - GoF heredados
   - GoF
   - de UC_ACC_04 backing
 * - IACT heredados
   - IACT
   - P-08, P-09, P-11, P-15, P-22, P-27,
     P-28, P-29, P-35
 * - P-41 Vista alternativa
   - IACT
   - coexistencia ACC↔PERM
 * - P-42 Preview pre-write
   - IACT
   - GET preview-assign
 * - P-30 Notif legible
   - IACT
   - display_names en modal

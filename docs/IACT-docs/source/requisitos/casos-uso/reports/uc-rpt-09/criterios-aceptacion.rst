.. _uc-rpt-09-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Crear basico
=======================

POST → 201.

9.2 CA-02: Nombre duplicado
===========================

400 NAME_DUPLICATE.

9.3 CA-03: Cross-segmento bloqueado
===================================

400 SEGMENT_VIOLATION.

9.4 CA-04: > 50 filtros
=======================

429.

9.5 CA-05: Update funciona
==========================

PATCH funciona.

9.6 CA-06: Delete funciona
==========================

DELETE funciona.

9.7 CA-07: List solo propios
============================

User ve solo sus filtros.

9.8 CA-08: Apply en historico
=============================

GET con saved_filter_id → filtros aplicados.

9.9 CA-09: Default filter
=========================

is_default=true unico por report_type.

9.10 CA-10: Filter invalid si segmentos cambian
===============================================

Cuando User pierde segmento, filtro
marca invalid. Aplicarlo da error.

9.11 Resumen
============

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..06
   - CRUD
   - Funcional
 * - CA-07
   - Ownership
   - Seguridad
 * - CA-08
   - Aplicar
   - Funcional
 * - CA-09
   - Default
   - UX
 * - CA-10
   - Invalid si segmentos
   - Cumplimiento

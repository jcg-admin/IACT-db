.. _uc-rpt-10-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Crear con todas las opciones
=======================================

POST con filters + columns + chart →
201.

9.2 CA-02: Cross-segmento
=========================

400.

9.3 CA-03: Columna invalida
===========================

400.

9.4 CA-04: > 30 vistas
======================

429.

9.5 CA-05: Default por report_type
==================================

is_default unico por report_type.

9.6 CA-06: Apply
================

GET con view_id → ejecuta.

9.7 CA-07: Clone
================

POST clone → vista copia derivada.

9.8 CA-08: Columna deprecada
============================

Vista con col removida → unavailable.

9.9 CA-09: CRUD
===============

Update / delete funcionan.

9.10 Resumen
============

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..04
   - Crear + validacion
   - Funcional
 * - CA-05..06
   - Default + apply
   - UX
 * - CA-07
   - Clone
   - UX
 * - CA-08
   - Degradacion
   - Robustez
 * - CA-09
   - CRUD completo
   - Funcional

.. _uc-rpt-08-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Sin schedules
========================

200 con items=[] + mensaje frontend.

4.2 FA-02: Filtros
==================

status=active → solo activos.

4.3 FA-03: Auditor vista global
===============================

User con scope amplio (auditor) ve todos
los schedules de su scope, no solo propios.

4.4 FA-04: Detalle con ultimo run
=================================

Detalle incluye snapshot del ultimo run
(success / failed + error_code).

4.5 Resumen
===========

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Sin schedules
   - items=[]
   - mensaje
 * - FA-02
   - Filtros
   - subset
   - status
 * - FA-03
   - Auditor scope
   - global view
   - condition
 * - FA-04
   - Detalle
   - ultimo run inline
   - convenience

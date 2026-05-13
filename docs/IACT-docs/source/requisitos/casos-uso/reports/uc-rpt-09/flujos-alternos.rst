.. _uc-rpt-09-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Nombre duplicado
===========================

400 NAME_DUPLICATE.

4.2 FA-02: Cross-segmento bloqueado
===================================

Filtro intenta segmento que el User no
tiene → 400 SEGMENT_VIOLATION.

4.3 FA-03: Update aplica nuevo segmento
=======================================

Si los segmentos del User cambian, filtros
guardados que ya no son validos se
mantienen pero se marcan ``invalid``;
aplicarlos da error.

4.4 FA-04: Default filter
=========================

User puede marcar 1 filtro como default
para un report_type. Frontend lo aplica
automaticamente al abrir el reporte.

4.5 FA-05: Rapida aplicacion
============================

UI lista filtros guardados como chips;
click aplica.

4.6 Resumen
===========

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Nombre dup
   - 400
   - validation
 * - FA-02
   - Cross-segmento
   - 400
   - CNST-008
 * - FA-03
   - Segmento revocado
   - marca invalid
   - degradado
 * - FA-04
   - Default
   - auto-aplica
   - UX
 * - FA-05
   - Aplicacion rapida
   - chips
   - UI

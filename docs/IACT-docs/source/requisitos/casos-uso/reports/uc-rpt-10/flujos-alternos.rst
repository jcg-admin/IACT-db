.. _uc-rpt-10-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Default view por report_type
=======================================

User puede marcar una vista como default;
abrir el reporte aplica esa vista
automaticamente.

4.2 FA-02: Columna catalog cambia
=================================

Si una columna fue removida del catalog
(deprecation), vista marca columna como
``unavailable``; UI ignora.

4.3 FA-03: Cross-segmento blocked
=================================

Igual que UC_RPT_09 — vista no puede
romper CNST-008.

4.4 FA-04: Vista compartida (UC_RPT_11)
=======================================

Vista compartida pero el receptor no
tiene segmento → recibe ``access_denied``
al aplicar.

4.5 FA-05: Clone
================

User puede clonar otra vista propia o
publica → nueva vista derivada.

4.6 Resumen
===========

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Default
   - auto-aplica
   - UX
 * - FA-02
   - Columna deprecada
   - unavailable
   - degradado
 * - FA-03
   - Cross-segmento
   - 400
   - CNST-008
 * - FA-04
   - Compartida
   - access_denied al apply
   - segmento
 * - FA-05
   - Clone
   - copia
   - convenience

.. _uc-rpt-14-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Sin campanas → items=[].
FA-02: Filtro por type (outbound/inbound).
FA-03: Drill por campana → trends + disposition.
FA-04: Sort por conversion rate.
FA-05: Comparativo periodo.
FA-06: Export CSV (UC_RPT_04).

Resumen
=======

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Sin datos
   - items=[]
   - mensaje
 * - FA-02
   - Filtro type
   - subset
   - filter
 * - FA-03
   - Drill
   - detail
   -
 * - FA-04
   - Sort
   - ranking
   -
 * - FA-05
   - Comparativo
   - prior auto
   - P-63
 * - FA-06
   - Export
   - UC_RPT_04
   -

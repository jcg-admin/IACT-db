.. _uc-rpt-12-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Sin agentes con datos
================================

200 con items=[]; mensaje frontend.

4.2 FA-02: Filtro por team
==========================

filter[team]=X → solo agentes del team X.

4.3 FA-03: Sort por columna
===========================

sort_by=tmo asc → ranking.

4.4 FA-04: Detalle agente cross-segmento
========================================

User intenta ver agente fuera de su
segmento → 403.

4.5 FA-05: Comparativo
======================

Vista UI compara N agentes seleccionados
contra el promedio del team.

4.6 Resumen
===========

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
   - Filtro team
   - subset
   - filter
 * - FA-03
   - Sort
   - ordenado
   - param
 * - FA-04
   - Cross-segmento
   - 403
   - CNST-008
 * - FA-05
   - Comparativo
   - vista UI
   - usa list endpoint

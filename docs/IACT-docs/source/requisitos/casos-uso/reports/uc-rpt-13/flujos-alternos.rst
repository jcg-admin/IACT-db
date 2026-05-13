.. _uc-rpt-13-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Sin colas con datos
==============================

items=[].

4.2 FA-02: Filtro multi-cola
============================

filter[queue_id]=A,B,C → solo esas.

4.3 FA-03: Drill por cola
=========================

Click en cola → detalle con trends por
hora.

4.4 FA-04: Sort por SL
======================

Identificar colas con peor SL.

4.5 FA-05: Comparativo periodo
==============================

Como UC_RPT_03 P-63: prior period auto.

4.6 Resumen
===========

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Sin colas
   - items=[]
   - mensaje
 * - FA-02
   - Multi-cola
   - subset
   - filter
 * - FA-03
   - Drill
   - detail con trends
   -
 * - FA-04
   - Sort
   - ranking
   -
 * - FA-05
   - Comparativo
   - prior auto
   - P-63

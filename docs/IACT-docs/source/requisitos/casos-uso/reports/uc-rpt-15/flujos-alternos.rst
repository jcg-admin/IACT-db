.. _uc-rpt-15-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Sin transferencias → totales en 0.
FA-02: Filtro direction.
FA-03: Drill por agente: ranking de
agentes con mas transfers-out.
FA-04: Drill por reason: detalle de
transfers por reason especifica.
FA-05: Heatmap inter-queue: identifica
loops circulares.

Resumen
=======

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Sin transfers
   - 0s
   - mensaje
 * - FA-02
   - Filtro direction
   - subset
   - filter
 * - FA-03
   - Drill agente
   - ranking
   -
 * - FA-04
   - Drill reason
   - breakdown
   -
 * - FA-05
   - Heatmap
   - matriz
   - circular detection

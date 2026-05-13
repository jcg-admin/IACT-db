.. _uc-rpt-03-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Range > 2 anos
=========================

400 RANGE_TOO_LARGE con sugerencia
"use export with archive".

4.2 FA-02: Sin datos para periodo
=================================

200 con buckets vacios. Frontend muestra
"Sin datos en este periodo".

4.3 FA-03: Comparative no disponible
====================================

Periodo prior no tiene datos suficientes:
``comparative.period_prior.kpis_summary``
con flag ``insufficient_data``.

4.4 FA-04: Cache hit
====================

PASO 6 hit → response inmediato.

4.5 FA-05: Drill-down a dimension
=================================

Click en bucket → frontend abre vista
detalle con filtro adicional. Backend
sirve via mismo endpoint con filtros
extendidos.

4.6 FA-06: Multi-dimension
==========================

group_by puede ser lista
(``group_by=day,campaign``). Buckets
2D. Limite: max 2 dimensiones.

4.7 FA-07: Periodo custom muy estrecho
======================================

range < 1h → group_by=minute permitido
solo si rango ≤ 6h.

4.8 Resumen
===========

.. list-table::
 :widths: 12 38 30 20
 :header-rows: 1

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - > 2 anos
   - 400 + sugerencia
   - export
 * - FA-02
   - Sin datos
   - buckets vacios
   - mensaje frontend
 * - FA-03
   - Comparative N/A
   - flag
   - degradado
 * - FA-04
   - Cache hit
   - respuesta rapida
   - mayoritario
 * - FA-05
   - Drill-down
   - filtros extendidos
   - mismo endpoint
 * - FA-06
   - Multi-dimension
   - 2D
   - limite 2
 * - FA-07
   - Estrecho
   - minute granularity
   - ≤ 6h

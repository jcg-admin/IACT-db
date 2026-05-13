.. _uc-rpt-03-parte-03:

==========================
Parte 3 — Flujo principal
==========================

3.1 Pasos
=========

**PASO 1** — GET con filtros + periodo +
paginacion.

**PASO 2** — JWT.

**PASO 3** — RBAC ``view_historical_reports``.

**PASO 4** — Resolver segmento.

**PASO 5** — Validar:

- periodo en enum o date range valido.
- date range ≤ 2 anos.
- group_by compatible con periodo.
- page_size ≤ 200.

**PASO 6** — Cache lookup
(``key = filters_hash + segments_hash +
page``).

**PASO 7** — Query AnalyticsRepo:

- Aggregate principal por buckets.
- Aggregate periodo anterior (para
  comparativo).

**PASO 8** — Calcular KPIs derivados por
bucket.

**PASO 9** — Construir comparative
(diff / pct_change).

**PASO 10** — Cache write con TTL adaptativo:

- last_24h: 60s
- last_7d: 5 min
- last_30d / last_90d / custom: 15 min

**PASO 11** — Response 200.

3.2 Resumen
===========

.. list-table::
 :widths: 8 50 22 20
 :header-rows: 1

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1-3
   - GET + JWT + RBAC
   - View / Guard
   - 009
 * - 4
   - Segmento
   - SegmentResolver
   - 008
 * - 5
   - Validar
   - Validator
   - —
 * - 6
   - Cache
   - MetricsCache
   - —
 * - 7
   - Query (current + prior)
   - AnalyticsRepo
   - 007
 * - 8
   - KPIs
   - Calculator
   - —
 * - 9
   - Comparative
   - Calculator
   - —
 * - 10
   - Cache write
   - Cache
   - —
 * - 11
   - 200
   - View
   - —

.. _uc-rpt-03-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes logicos
========================

- **HistoricalReportEndpoint**
- **AuthorizationGuard**
- **FilterValidator**
- **PeriodResolver** (current + prior)
- **MetricsCache** (TTL adaptativo)
- **AnalyticsRepo**
- **KPICalculator**
- **ComparativeBuilder**

11.2 Contratos
==============

::

   contract HistoricalReportService:
     get(filters: HistoricalFilters,
         period: PeriodSpec,
         group_by: list[Dimension],
         page: int,
         page_size: int,
         invoker, ctx)
       returns: HistoricalReport
       throws: SinPermiso,
               UserWithoutSegment,
               ValidationError,
               BDTimeout

   data HistoricalReport:
     period, group_by,
     filters_applied,
     buckets: list[Bucket],
     pagination: Pagination,
     comparative: Comparative

11.3 Pseudocodigo
=================

::

   procedure get_historical(filters,
                              period,
                              group_by,
                              page,
                              page_size,
                              invoker, ctx):
       require AuthorizationGuard.has(
                 invoker,
                 'view_historical_reports')
       segments = SegmentResolver.for(
                    invoker.id)
       if not segments:
           raise UserWithoutSegment
       FilterValidator.validate(
         filters, period, group_by,
         page_size)
       prior = PeriodResolver.prior(period)

       key = build_cache_key(
         filters, segments, period,
         group_by, page)

       cached = MetricsCache.get(key)
       if cached:
           return cached + cache: true

       try:
           current_rows =
             AnalyticsRepo.aggregate(
               filters, segments,
               period, group_by,
               page=page,
               page_size=page_size)
           prior_rows =
             AnalyticsRepo.aggregate(
               filters, segments,
               prior, group_by=null,
               summary_only=true)
       except BDTimeout:
           raise

       buckets = [
         Bucket(b.key,
                KPICalculator.derive(b))
         for b in current_rows]

       comparative =
         ComparativeBuilder.build(
           current_rows, prior_rows)

       report = HistoricalReport(
         period, group_by,
         filters_applied=filters,
         buckets=buckets,
         pagination=...,
         comparative=comparative,
         cache=false)

       ttl = ttl_for_period(period)
       MetricsCache.set(key, report, ttl)
       return report

11.4 Mapeo excepcion
====================

.. list-table::
 :widths: 40 20 40
 :header-rows: 1

 * - Excepcion
   - Status
   - Body
 * - SinPermiso
   - 403
   - FORBIDDEN
 * - UserWithoutSegment
   - 400
   - USER_WITHOUT_SEGMENT
 * - ValidationError
   - 400
   - VALIDATION_ERROR
 * - RangeTooLarge
   - 400
   - RANGE_TOO_LARGE
 * - BDTimeout
   - 503
   - SERVICE_UNAVAILABLE

11.5 Restricciones cross-cutting
================================

- CNST-007 read-only Analytics.
- CNST-008 segmento.
- P-29 cache invalidate por evento ETL.
- P-62 TTL adaptativo.
- P-63 comparative auto-derived.

11.6 Stack-agnostico
====================

- BD: RDBMS particionado o columnar.
- Cache: Redis / Memcached / in-process.

.. _uc-rpt-01-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **DashboardEndpoint**
   - GET /api/dashboard/
 * - **AuthorizationGuard**
   - JWT + view_reports
 * - **SegmentResolver**
   - segmentos del User
 * - **PeriodValidator**
   - validar param
 * - **MetricsCache**
   - get / set / invalidate
 * - **AnalyticsRepo**
   - query agregada (read replica)
 * - **KPICalculator**
   - derivar TMO, SL, abandono
 * - **TrendBuilder**
   - construir buckets
 * - **StalenessChecker**
   - comparar last_etl vs threshold

11.2 Contratos
==============

::

   contract DashboardService:
     get(user_id: int,
         period: enum,
         context: RequestContext)
       returns: DashboardOutput
       throws: SinPermiso,
               UserWithoutSegment,
               ValidationError,
               BDTimeout

   data DashboardOutput:
     period, refreshed_at,
     kpis: KPISet,
     trend: TrendSet,
     segments_applied: list[code],
     cache: bool,
     staleness_minutes: int | null

11.3 Pseudocodigo
=================

::

   procedure get_dashboard(user_id, period,
                            ctx):
       require AuthorizationGuard
                 .has_function(invoker,
                   'view_reports')

       segments =
         SegmentResolver.for(user_id)
       if not segments:
           raise UserWithoutSegment

       PeriodValidator.validate(period)

       segments_hash = hash(segments)
       key = "dashboard:" + user_id + ":"
                          + period + ":"
                          + segments_hash

       cached = MetricsCache.get(key)
       if cached:
           return cached + cache: true

       try:
           agg =
             AnalyticsRepo.aggregate(
               segments=segments,
               period=period)
       except BDTimeout:
           raise

       kpis =
         KPICalculator.derive(agg)
       trend =
         TrendBuilder.build(agg.buckets,
                              period)
       staleness =
         StalenessChecker.compute(agg)

       response = DashboardOutput(
         period, now(), kpis, trend,
         segments_applied=segments,
         cache=false,
         staleness_minutes=staleness)

       ttl = ttl_for(period)
       MetricsCache.set(key, response, ttl)

       return response

11.4 Mapeo excepcion → HTTP
===========================

.. list-table::
 :widths: 40 20 40
 :header-rows: 1

 * - Excepcion
   - Status
   - Body code
 * - SinPermiso
   - 403
   - FORBIDDEN
 * - UserWithoutSegment
   - 400
   - USER_WITHOUT_SEGMENT
 * - ValidationError
   - 400
   - VALIDATION_ERROR
 * - BDTimeout
   - 503
   - SERVICE_UNAVAILABLE

11.5 Restricciones cross-cutting
================================

- Read-only Analytics (CNST-007).
- Filtro segmento (CNST-008).
- Sin audit por invocacion (P-51).
- Cache TTL adaptativo segun periodo.

11.6 Stack-agnostico
====================

- BD: cualquier columnar / OLAP
  (BigQuery, Snowflake, ClickHouse,
  PostgreSQL particionado).
- Cache: Redis / Memcached / in-process.
- Frontend: cualquier framework con
  polling timer y Visibility API.

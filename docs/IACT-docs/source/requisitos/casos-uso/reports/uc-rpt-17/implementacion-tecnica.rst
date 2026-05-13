.. _uc-rpt-17-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes:

- UniqueClientsEndpoint
- AuthorizationGuard
- DistinctCounter (exact + HLL)
- RecurrenceCalculator
- ComparativeCalculator (new vs returning)
- MetricsCache

Contrato:

::

   contract UniqueClientsService:
     get(filters, period, invoker, ctx)
       returns: UniqueClientsReport

Pseudocodigo:

::

   procedure get(filters, period,
                  invoker, ctx):
       require AuthorizationGuard.has(
                 invoker,
                 'view_unique_clients_reports')
       segments = SegmentResolver.for(
                    invoker.id)
       cached = cache_get(...)
       if cached: return cached

       if estimated_volume(period) > 10M:
           distinct_count =
             HLL.estimate(segments, period)
           method = 'hll'
       else:
           distinct_count =
             SQLDistinct.count(
               segments, period)
           method = 'exact'

       recurrence =
         RecurrenceCalculator.compute(
           segments, period)
       comparative =
         ComparativeCalculator.new_vs_returning(
           segments, period, prior(period))
       top = TopNAnonymized.compute(
         segments, period, n=10)

       result = UniqueClientsReport(
         period,
         distinct_clients_count=distinct_count,
         method=method,
         recurrencia_distribution=recurrence,
         new_vs_returning=comparative,
         top_volume_anonymized=top)
       cache_set(...)
       return result

Stack-agnostico:

- Exact distinct: cualquier RDBMS.
- HLL: nativo en PostgreSQL,
  Redis, ClickHouse, BigQuery.

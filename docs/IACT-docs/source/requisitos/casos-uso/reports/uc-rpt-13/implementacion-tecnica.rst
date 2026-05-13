.. _uc-rpt-13-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes
================

- QueueReportEndpoint
- AuthorizationGuard
- SegmentResolver
- QueueDailyStatRepo
- KPICalculator
- MetricsCache

11.2 Contratos
==============

::

   contract QueueReportService:
     list(filters, period, page,
          invoker, ctx)
       returns: QueueList
     detail(queue_id, period,
            invoker, ctx)
       returns: QueueDetail

11.3 Pseudocodigo
=================

Identico estructura a UC_RPT_12 pero con
``QueueDailyStatRepo`` y queue_id como key
de aggregation:

::

   procedure list(filters, period, page,
                  invoker, ctx):
       require AuthorizationGuard.has(
                 invoker,
                 'view_queue_reports')
       segments = SegmentResolver.for(
                    invoker.id)
       cached = cache_get(...)
       if cached: return cached
       rows = QueueDailyStatRepo.aggregate(
                filters, segments, period)
       items = [
         compute_queue_kpis(r)
         for r in rows]
       summary = compute_summary(rows)
       result = QueueList(period, items,
                            summary)
       cache_set(...)
       return result

11.4 Stack-agnostico
====================

Cualquier RDBMS / OLAP particionado.

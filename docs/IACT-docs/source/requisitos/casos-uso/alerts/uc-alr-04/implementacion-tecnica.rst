.. _uc-alr-04-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: AlertHistoryEndpoint,
AuthorizationGuard, SegmentResolver,
AlertRepo, TimingCalculator, MetricsCache.

::

   contract AlertHistoryService:
     get(filters, period, page,
         invoker, ctx)
       returns: AlertHistoryReport

Pseudocodigo similar a UC_RPT_03.
Stack-agnostico.

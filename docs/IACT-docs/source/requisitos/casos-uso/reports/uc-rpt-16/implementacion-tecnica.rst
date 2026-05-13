.. _uc-rpt-16-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: IVRReportEndpoint,
AuthorizationGuard, IVRSessionEventRepo,
PathMiner, HeatmapBuilder, MetricsCache.

::

   contract IVRReportService:
     get(filters, period, invoker, ctx)
       returns: IVRReport

Pseudocodigo: similar a UC_RPT_15. Path
mining bounded a top N=10 por costo.

Stack-agnostico.

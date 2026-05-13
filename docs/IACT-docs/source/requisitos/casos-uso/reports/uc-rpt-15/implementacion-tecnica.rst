.. _uc-rpt-15-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: TransferReportEndpoint,
AuthorizationGuard, TransferEventRepo,
HeatmapBuilder, MetricsCache.

Contrato:

::

   contract TransferReportService:
     get(filters, period, invoker, ctx)
       returns: TransferReport

Pseudocodigo: identico a UC_RPT_12; con
HeatmapBuilder adicional.

Stack-agnostico.

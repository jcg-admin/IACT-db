.. _uc-rpt-14-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes
================

- CampaignReportEndpoint
- AuthorizationGuard
- CampaignDailyStatRepo
- KPICalculator (conversion, per-hour)
- MetricsCache

11.2 Contratos
==============

::

   contract CampaignReportService:
     list, detail

11.3 Pseudocodigo
=================

Estructuralmente identico a UC_RPT_12/13.
Dimension: campaign_id.

::

   procedure list(filters, period, page,
                  invoker, ctx):
       require AuthorizationGuard.has(
                 invoker,
                 'view_campaign_reports')
       segments = SegmentResolver.for(
                    invoker.id)
       rows = CampaignDailyStatRepo
                .aggregate(
                  filters, segments, period)
       items = [
         compute_campaign_kpis(r)
         for r in rows]
       return CampaignList(period, items)

11.4 Stack-agnostico
====================

Cualquier RDBMS / OLAP.

.. _uc-rpt-12-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes
================

- **AgentReportEndpoint** (list + detail)
- **AuthorizationGuard**
- **SegmentResolver**
- **AgentDailyStatRepo**
- **KPICalculator**
- **MetricsCache**

11.2 Contratos
==============

::

   contract AgentReportService:
     list(filters, period, page,
          invoker, ctx)
       returns: AgentList
     detail(agent_id, period,
            invoker, ctx)
       returns: AgentDetail

11.3 Pseudocodigo
=================

::

   procedure list(filters, period, page,
                  invoker, ctx):
       require AuthorizationGuard.has(
                 invoker,
                 'view_agent_reports')
       segments =
         SegmentResolver.for(invoker.id)
       key = build_cache_key(
         filters, segments, period, page)
       cached = MetricsCache.get(key)
       if cached: return cached

       rows =
         AgentDailyStatRepo
           .aggregate_by_agent(
             filters, segments, period,
             pagination=page)
       items = [
         to_agent_kpis(r)
         for r in rows]
       summary =
         compute_team_summary(rows)
       result = AgentList(
         period, items, pagination,
         summary)
       MetricsCache.set(key, result,
                          ttl=900)
       return result

   procedure detail(agent_id, period,
                    invoker, ctx):
       require AuthorizationGuard.has(
                 invoker,
                 'view_agent_detail')
       segments =
         SegmentResolver.for(invoker.id)
       agent = AgentRepo.get(agent_id)
       if agent.segment_code not in segments:
           raise SinPermiso

       stats =
         AgentDailyStatRepo
           .stream_by_agent(agent_id, period)
       kpis = KPICalculator.derive(stats)
       trend = build_trend(stats)

       AuditService.emit(
         'AGENT_DETAIL_VIEWED',
         actor_id=invoker.id,
         target_type='agent',
         target_id=agent_id,
         payload={period},
         context=ctx)

       return AgentDetail(
         agent_id,
         display_name=agent.display_name,
         period, kpis, trend)

11.4 Stack-agnostico
====================

Cualquier RDBMS / OLAP.

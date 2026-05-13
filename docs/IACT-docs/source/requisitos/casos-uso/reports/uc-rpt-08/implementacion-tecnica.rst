.. _uc-rpt-08-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes logicos
========================

- **ScheduledReportListEndpoint**
- **AuthorizationGuard**
- **ScheduledReportRepo** (read replica)
- **ScopeFilter**
- **ScheduleExecutionLogRepo**

11.2 Contratos
==============

::

   contract ScheduledReportListService:
     list(actor_id, filters, pagination,
          invoker, ctx)
       returns: ListOutput
     detail(id, invoker, ctx)
       returns: ScheduledReportDetail
     runs(id, pagination, invoker, ctx)
       returns: RunsList

11.3 Pseudocodigo (list)
========================

::

   procedure list(filters, pagination,
                  invoker, ctx):
       require AuthorizationGuard.has(
                 invoker,
                 'view_scheduled_reports')
       scope = ScopeFilter.for(invoker)
       items =
         ScheduledReportRepo
           .list_by_actor_with_scope(
             invoker.id, scope, filters,
             pagination)
       return ListOutput(items, pagination)

11.4 Stack-agnostico
====================

- BD: cualquier RDBMS con read replica.

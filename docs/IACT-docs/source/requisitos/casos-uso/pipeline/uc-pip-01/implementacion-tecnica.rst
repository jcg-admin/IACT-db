.. _uc-pip-01-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: ETLSupervisionEndpoint,
AuthorizationGuard, PipelineRunRepo,
MetricsCache, SummaryBuilder.

::

   contract ETLSupervisionService:
     get(invoker, ctx)
       returns: ETLSupervisionReport

Pseudocodigo: query ultimas runs por
pipeline + estado actual; build summary.

Stack-agnostico (cualquier metadata store
que ETL use: Airflow, Prefect, custom).

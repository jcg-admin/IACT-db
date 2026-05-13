.. _uc-pip-03-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: DataAvailabilityEndpoint,
AuthorizationGuard, DatasetMetadataRepo,
StatusCalculator, MetricsCache.

::

   contract DataAvailabilityService:
     get(invoker, ctx)
       returns: DataAvailabilityReport

Pseudocodigo: query metadata + calcular
status.
Stack-agnostico.

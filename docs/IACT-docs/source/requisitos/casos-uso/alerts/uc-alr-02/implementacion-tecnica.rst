.. _uc-alr-02-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: ActiveAlertsEndpoint,
AuthorizationGuard, SegmentResolver,
AlertRepo (read replica).

::

   contract ActiveAlertsService:
     list(filters, invoker, ctx)
       returns: ActiveAlertsList

Pseudocodigo: query indexado por
``(state, severity, fired_at)`` con WHERE
state ∈ {firing, ack} y scope ⊆ segmentos.

Stack-agnostico.

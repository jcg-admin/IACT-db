.. _uc-alr-05-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: SubscriptionEndpoint,
AuthorizationGuard, SubscriptionRepo,
SegmentChangeListener (auto-pause),
AuditService.

::

   contract SubscriptionService:
     create, list, delete,
     mute_all(user_id, invoker)
     bulk_add(subscriptions, target_user_id,
              invoker)

Pseudocodigo: validar own vs admin path,
INSERT, audit. Listener auto-pause cuando
segmento revoke.

Stack-agnostico.

.. _uc-opr-03-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: OutboundEndpoint,
DialValidator (allowlist),
TelephonyClient, AuditService.

::

   contract OutboundCallService:
     dial(destination, campaign_id,
          callback_id, mode,
          invoker, ctx)
       returns: CallSessionOutput

Stack-agnostico.

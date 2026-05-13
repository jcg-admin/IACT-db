.. _uc-opr-02-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: AnswerCallEndpoint,
CallOfferRepo, CallSessionRepo,
TelephonyClient (SIP / WebRTC),
CallRouterClient, AuditService.

::

   contract CallAnswerService:
     answer(call_id, invoker, ctx)
       returns: CallSessionOutput

Stack-agnostico (telephony layer
reemplazable: Asterisk, FreeSWITCH,
Twilio, custom).

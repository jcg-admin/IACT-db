.. _uc-opr-04-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: HoldEndpoint,
TelephonyClient, CallSessionRepo,
LongHoldDetector (timer post-hold),
AuditService.

::

   contract HoldService:
     hold(call_id, invoker, ctx)
     unhold(call_id, invoker, ctx)

.. _uc-opr-05-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: TransferEndpoint,
TelephonyClient, TransferEventRepo,
LoopDetector, AuditService.

::

   contract TransferService:
     transfer(call_id, target,
              mode, reason,
              invoker, ctx)
       returns: TransferOutput

Stack-agnostico.

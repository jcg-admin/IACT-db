.. _uc-aud-04-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes:

- ComplianceEndpoint
- AuthorizationGuard
- TemplateValidator
- ComplianceWorker (per-template
  strategy)
- HMACSigner (KMS integration)
- StorageGateway
- VerifyEndpoint
- AuditService
- MailboxService

::

   contract ComplianceService:
     queue(template, period, format,
           invoker, ctx)
       returns: jobRef
     verify(job_id)
       returns: VerifyResult

Stack-agnostico (KMS API estandar
HSM-compatible).

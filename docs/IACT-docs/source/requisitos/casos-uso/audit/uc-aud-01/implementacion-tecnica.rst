.. _uc-aud-01-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: GeneralAuditEndpoint,
AuthorizationGuard, AuditRepo, CursorEncoder,
PayloadSanitizer, AuditService.

::

   contract GeneralAuditService:
     list(filters, cursor, page_size,
          invoker, ctx)
       returns: AuditList

Pseudocodigo: identico a UC_PERM_10 pero
SIN filtro restrictivo a eventos RBAC
(incluye TODOS).

Stack-agnostico.

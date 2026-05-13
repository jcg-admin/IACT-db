.. _uc-aud-02-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: SearchEndpoint,
AuthorizationGuard, ThrottlePolicy,
AuditSearchEngine (FTS), Sanitizer,
AuditService.

::

   contract AuditSearchService:
     search(query, period, filters,
            cursor, page_size,
            invoker, ctx)
       returns: SearchResults

Stack-agnostico (FTS engine separado).

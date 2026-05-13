.. _uc-pip-02-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: ETLErrorEndpoint, AuthorizationGuard,
ETLErrorRepo, PIIScanner.

::

   contract ETLErrorService:
     get(filters, period, page,
         invoker, ctx)
       returns: ETLErrorList

Pseudocodigo: query + sanitize.
Stack-agnostico.

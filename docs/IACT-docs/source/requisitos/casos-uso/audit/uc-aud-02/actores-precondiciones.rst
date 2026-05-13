.. _uc-aud-02-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- **User con funcion** ``search_audit``
- **AuditSearchEngine** (FTS)

::

   POST /api/audit/search/
   body: {
     query: string,
     period: {date_from, date_to},
     filters: {module, event_type, ...},
     page_size, cursor
   }

Date range obligatorio. Max 90 dias.

.. _uc-opr-06-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- Agente en estado after_call_work.
- DispositionCatalog.

::

   POST /api/me/calls/{call_id}/disposition/
   body: {
     code: enum,
     notes?: string (≤500)
   }

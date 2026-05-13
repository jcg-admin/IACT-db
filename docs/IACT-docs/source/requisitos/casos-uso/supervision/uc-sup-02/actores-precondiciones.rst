.. _uc-sup-02-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- Supervisor con ``barge_in_calls``.
- Agente, caller.

::

   POST /api/supervisor/barge-in/{call_id}/
   body: { reason: string ≥ 20 }

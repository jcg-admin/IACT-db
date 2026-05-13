.. _uc-sup-03-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- Supervisor con
  ``broadcast_team_messages``.
- MailboxService.

::

   POST /api/supervisor/broadcast/
   body: {
     target: { team_id?, segment_codes? },
     subject, body, urgency
   }

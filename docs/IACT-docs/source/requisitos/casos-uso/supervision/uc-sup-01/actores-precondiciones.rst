.. _uc-sup-01-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- Supervisor con
  ``monitor_live_calls``.
- Agente target (en llamada).
- TelephonyClient.

::

   POST /api/supervisor/monitor/{call_id}/
   body: {
     mode: silent|whisper,
     reason: string ≥ 20
   }

.. _uc-opr-05-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- Agente origen.
- Agente / cola destino.
- TelephonyClient.

::

   POST /api/me/calls/{call_id}/transfer/
   body: {
     target_type: agent|queue|external,
     target_id: id | phone,
     mode: warm|cold,
     reason: string (≥10)
   }

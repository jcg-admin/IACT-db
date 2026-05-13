.. _uc-opr-02-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- Agente (estado available).
- CallRouter (oferente).
- Telephony channel.

Precondiciones:

- Sesion activa.
- Agente en available.
- Llamada offered.

::

   POST /api/me/calls/{call_id}/answer/

Response: call info + session_id.

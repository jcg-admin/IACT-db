.. _uc-cli-01-parte-07:

================================
Parte 7 — Datos involucrados
================================

CallSession (creacion):
  id, started_at, caller_hash,
  did_id (DID dialed),
  language_detected, status=ringing.

DNCList: para excluir caller_hash
de outbound.

DID: configuracion de numero
entrante (idioma, IVR asociado).

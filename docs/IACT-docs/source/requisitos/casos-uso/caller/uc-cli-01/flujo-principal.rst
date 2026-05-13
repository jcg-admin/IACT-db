.. _uc-cli-01-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — Llamada llega al DID.
PASO 2 — TelephonyClient acepta.
PASO 3 — Caller_id capturado +
hasheado (PII pipeline).
PASO 4 — INSERT CallSession con
caller_hash.
PASO 5 — Reproducir greeting audio.
PASO 6 — Pasar a IVR (UC_CLI_02) o
direct queue.
PASO 7 — Audit ``CALL_STARTED``
con caller_hash + DID.

Sin response HTTP — el cliente
oye audio.

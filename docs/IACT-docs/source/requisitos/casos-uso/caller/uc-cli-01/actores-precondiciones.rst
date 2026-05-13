.. _uc-cli-01-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- Cliente / Caller (humano externo).
- TelephonyClient (PBX / SIP
  trunk).
- IVRRunner (UC_CLI_02).

Precondiciones:

- DID configurado.
- IVR cargado.
- Capacidad de canales disponible.

Postcondiciones:

- CallSession creada con
  caller_hash.
- IVR Runner toma control.
- Greeting reproducido.

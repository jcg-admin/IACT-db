.. _uc-cli-04-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — Sistema ofrece callback
(prompt audio).
PASO 2 — Cliente confirma (DTMF).
PASO 3 — Capturar numero de
callback (default = caller_id;
opcion ingresar otro).
PASO 4 — Hash + persist
CallbackEntry.
PASO 5 — Audit ``CALLBACK_REQUESTED``.
PASO 6 — Mensaje confirmacion.
PASO 7 — Hangup.

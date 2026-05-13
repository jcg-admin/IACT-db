.. _uc-cli-02-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — IVRRunner toma control de
sesion.
PASO 2 — Cargar IVRDefinition para
DID/idioma.
PASO 3 — Reproducir nodo raiz
(audio).
PASO 4 — Esperar input cliente (DTMF
o voz, timeout configurado).
PASO 5 — Match input con opcion del
nodo:

- Si nodo hijo, repetir PASO 3.
- Si accion, ejecutarla (transfer a
  cola, info, etc.).

PASO 6 — Emitir IVRSessionEvent por
cada interaccion (UC_RPT_16).
PASO 7 — Llegar a salida → siguiente
UC.

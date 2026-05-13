.. _uc-cli-05-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — Agente cuelga, sistema
mantiene caller en linea.
PASO 2 — SurveyRunner reproduce
prompt.
PASO 3 — Por cada pregunta:

- reproducir
- esperar DTMF (timeout)
- registrar respuesta o skip

PASO 4 — INSERT SurveyResponse.
PASO 5 — Mensaje agradecimiento.
PASO 6 — Hangup.

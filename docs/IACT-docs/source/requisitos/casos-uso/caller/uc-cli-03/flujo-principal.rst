.. _uc-cli-03-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — INSERT en QueueEntry.
PASO 2 — Posicion calculada.
PASO 3 — Reproducir music on hold +
mensaje de bienvenida + estimacion
de espera.
PASO 4 — Cada N min: actualizar
mensaje "estamos atendiendo / X
adelante".
PASO 5 — CallRouter intenta asignar
a agente available.
PASO 6 — Cuando agente acepta
(UC_OPR_02): bridge + DELETE
QueueEntry.

Eventos: QueueEvent (entered,
position_changed, exited,
abandoned).

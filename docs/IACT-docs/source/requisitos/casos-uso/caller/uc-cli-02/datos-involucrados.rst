.. _uc-cli-02-parte-07:

================================
Parte 7 — Datos involucrados
================================

IVRDefinition: arbol de menus
(nodos + opciones + acciones).

IVRSessionEvent (consumido por
UC_RPT_16): event_type
(entry|node_visit|option_selected|
complete|drop|timeout),
ivr_id, node_id, option_selected,
time_in_node_seconds.

CallSession.path: secuencia de
opciones recorridas.

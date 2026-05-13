.. _uc-opr-08-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — GET.
PASO 2 — JWT.
PASO 3 — Cache (TTL 30s).
PASO 4 — Query AgentDailyStat WHERE
agent_id = invoker.id.
PASO 5 — Calcular KPIs derivados.
PASO 6 — Si opt-in ranking, fetch
ranking team (anonimizado).
PASO 7 — 200.

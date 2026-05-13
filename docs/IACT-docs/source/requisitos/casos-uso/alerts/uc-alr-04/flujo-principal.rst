.. _uc-alr-04-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — GET con filtros + period.
PASO 2 — JWT.
PASO 3 — RBAC view_alert_history.
PASO 4 — Resolver segmento.
PASO 5 — Validar (range ≤ 1 ano).
PASO 6 — Cache lookup.
PASO 7 — Query Alert WHERE state ∈
{resolved, closed} + filtros.
PASO 8 — Calcular time-to-ack /
time-to-resolve por row.
PASO 9 — Build summary.
PASO 10 — Cache write.
PASO 11 — 200.

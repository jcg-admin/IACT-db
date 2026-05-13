.. _uc-rpt-13-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — GET con filtros + period.
PASO 2 — JWT.
PASO 3 — RBAC view_queue_reports.
PASO 4 — Resolver segmento.
PASO 5 — Validar.
PASO 6 — Cache lookup.
PASO 7 — Query QueueDailyStat agregado.
PASO 8 — Calcular KPIs (ASA, SL,
abandono).
PASO 9 — Construir summary.
PASO 10 — Cache write.
PASO 11 — 200.

Detalle: query mas granular con trends por
hora.

3.1 Resumen
===========

Identico estructuralmente a UC_RPT_12; la
diferencia es la dimension principal
(queue_id en vez de agent_id).

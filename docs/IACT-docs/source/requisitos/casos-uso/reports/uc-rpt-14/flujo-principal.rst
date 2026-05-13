.. _uc-rpt-14-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — GET con filtros + period.
PASO 2 — JWT.
PASO 3 — RBAC view_campaign_reports.
PASO 4 — Resolver segmento.
PASO 5 — Validar.
PASO 6 — Cache lookup.
PASO 7 — Query CampaignDailyStat.
PASO 8 — Calcular conversion / per-hour.
PASO 9 — Build summary.
PASO 10 — Cache write.
PASO 11 — 200.

Detalle: trends por dia + breakdown
disposition.

3.1 Resumen
===========

Estructuralmente identico a UC_RPT_12/13.
Dimension: campaign_id.

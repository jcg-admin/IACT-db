.. _uc-rpt-12-parte-03:

==========================
Parte 3 — Flujo principal
==========================

3.1 List
========

PASO 1 — GET con filtros + period.
PASO 2 — JWT.
PASO 3 — RBAC ``view_agent_reports``.
PASO 4 — Resolver segmento.
PASO 5 — Validar params.
PASO 6 — Cache lookup.
PASO 7 — Query AnalyticsRepo:
``AgentDailyStat`` agregado por agente
en periodo, filtrado por segmento.
PASO 8 — Calcular KPIs derivados (TMO,
AHT, occupancy, adherence).
PASO 9 — Construir summary del team
(agregados).
PASO 10 — Cache write TTL adaptativo.
PASO 11 — 200 OK.

3.2 Detalle por agente
======================

PASO D1 — GET /agents/{agent_id}/.
PASO D2 — JWT.
PASO D3 — RBAC ``view_agent_detail``.
PASO D4 — Verificar agent_id ∈ segmento
del invoker (CNST-008).
PASO D5 — Query detallada (por dia +
trends).
PASO D6 — P-44 audit
``AGENT_DETAIL_VIEWED``.
PASO D7 — 200 OK.

3.3 Resumen
===========

.. list-table::
 :widths: 8 50 22 20

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1-3
   - GET + JWT + RBAC
   - Endpoint
   - 009
 * - 4-5
   - Segmento + validacion
   - Resolver/Validator
   - 008
 * - 6
   - Cache
   - MetricsCache
   - —
 * - 7-9
   - Query + KPIs + summary
   - Repo + Calculator
   - 007
 * - 10
   - Cache write
   - Cache
   - —
 * - 11
   - 200
   - View
   - —
 * - D1-D7
   - Detalle por agente
   - varios
   - 008, P-44

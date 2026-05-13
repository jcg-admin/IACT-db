.. _uc-rpt-03-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades leidas
====================

- **CallSummary** (Analytics) — buckets
  por hora / dia.
- **AgentDailyStat** — agregados por
  agente.
- **CampaignSummary** — agregados por
  campana.
- **QueueSummary** — agregados por cola.
- **SegmentDimension** — filtro CNST-008.

7.2 Indices criticos
====================

- ``CallSummary(segment_code,
  time_bucket DESC)``.
- ``CampaignSummary(campaign_id,
  time_bucket DESC)``.
- Particionamiento trimestral.

7.3 Cache
=========

- key incluye filters_hash.
- TTL adaptativo segun rango.
- Invalidate on ETL completion (UC_PIP_*
  emite evento).

7.4 Particionamiento online vs archive
======================================

- Online: ultimos 2 anos.
- Archive: > 2 anos (acceso via UC_RPT_04
  export only).

7.5 Datos NO involucrados
=========================

- BD operativa.
- PII.
- Audio / transcripciones.

.. _uc-rpt-14-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades
=============

- **CampaignDailyStat** (Analytics).
- **Campaign** (catalog).

7.2 Modelo
==========

::

   CampaignDailyStat:
     campaign_id, date, segment_code,
     attempted, reached,
     conversions,
     sum_handle_seconds,
     active_hours,
     disposition_counts: JSON

7.3 Indices
===========

- ``CampaignDailyStat(campaign_id,
  date DESC)``.

7.4 Datos NO involucrados
=========================

- Listas de contactos (PII).
- Audio.

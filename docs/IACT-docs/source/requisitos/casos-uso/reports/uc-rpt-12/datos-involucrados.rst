.. _uc-rpt-12-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades leidas
====================

- **AgentDailyStat** (Analytics):
  agregado por agente y dia.
- **Agent** (Users): display_name + team.
- **Schedule** (opcional): para adherence.

7.2 Indices
===========

- ``AgentDailyStat(agent_id, date DESC)``.
- ``AgentDailyStat(team_id, date)``.

7.3 Modelo
==========

::

   AgentDailyStat:
     agent_id, date, segment_code,
     calls_answered,
     calls_abandoned,
     sum_handle_seconds,
     sum_busy_seconds,
     sum_acw_seconds,
     transfers_in, transfers_out,
     holds_count

7.4 Datos NO involucrados
=========================

- PII (telefono, email del agente).
- Audio.

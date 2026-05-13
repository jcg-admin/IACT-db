.. _uc-opr-01-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 AgentState
==============

::

   AgentState:
     agent_id (PK)
     current_state: enum
     since_at: timestamp
     last_reason: string
     in_call_id: uuid | null
       (set when busy)

7.2 AgentStateHistory
=====================

::

   AgentStateHistory:
     id, agent_id, from_state,
     to_state, transition_at, reason,
     duration_in_from_state_seconds

Para adherence reporting (UC_RPT_12).

7.3 Indices
===========

- ``AgentState(agent_id)`` PK.
- ``AgentStateHistory(agent_id,
  transition_at DESC)``.

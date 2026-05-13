.. _uc-opr-01-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **Agente** (User con perfil de
  operador)
- **AgentStateRepo**
- **CallRouter** (consume estado para
  routing)
- **AuditService**

2.2 Precondiciones
==================

- Agente autenticado.
- Sesion activa.
- Estado actual conocido.

2.3 Postcondiciones
===================

- Estado actualizado.
- Audit ``AGENT_STATE_CHANGED`` emitido
  con from / to.
- CallRouter notificado (eventbus o
  trigger).

2.4 Datos de entrada
====================

::

   POST /api/me/agent-state/
   body: {
     new_state: enum,
     reason?: string (≥10 char si break/
              training)
   }

2.5 Datos de salida
===================

::

   {
     state: enum,
     since_at: timestamp,
     time_in_previous_state_seconds: int
   }

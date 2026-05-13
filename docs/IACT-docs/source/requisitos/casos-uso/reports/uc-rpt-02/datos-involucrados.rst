.. _uc-rpt-02-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Stream consumido
====================

**AnalyticsStream** (canal pub/sub):

- topic: ``call_state_changes``
- topic: ``agent_state_changes``
- topic: ``queue_state_snapshots``

UC_RPT_02 lee, NO produce.

7.2 Producer del stream
=======================

UC_PIP_* y MOD_IVR producen eventos al
stream. UC_RPT_02 los consume.

7.3 Esquema de evento del stream
================================

::

   { event_type, timestamp, segment_code,
     queue_id?, agent_id?, payload }

7.4 Mensaje agregado al frontend
================================

(Ver Parte 2.5).

Generado en backend cada 5s a partir del
ultimo snapshot consumido del stream.

7.5 Estado de conexion (en memoria)
===================================

::

   Connection {
     id: uuid
     user_id, segments
     opened_at, last_event_id
     event_count
     last_emit_at
   }

No persiste — efimero a la conexion.

7.6 Cache
=========

NO se cachea — es realtime. Cualquier
cache > 5s defeats el proposito.

7.7 Datos NO involucrados
=========================

- BD operativa (CNST-007).
- Datos historicos.
- PII de llamadas individuales.

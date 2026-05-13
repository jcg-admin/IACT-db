.. _uc-rpt-02-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Actor
   - Tipo
   - Rol
 * - **User con funcion**
     ``view_realtime_metrics``
   - Humano
   - supervisor / lider
 * - **Frontend**
   - Sistema
   - mantiene conexion stream
 * - **StreamGateway**
   - Sistema
   - emite eventos al frontend
 * - **AnalyticsStream**
   - Sistema
   - source de datos near-realtime

2.2 Precondiciones
==================

- User autenticado.
- ``view_realtime_metrics`` activa.
- Segmento del User definido.
- AnalyticsStream operativo.

2.3 Postcondiciones
===================

- Conexion abierta hasta cierre del User.
- Stream de eventos cada ≤ 5s.

2.4 Datos de entrada
====================

::

   GET /api/realtime/metrics/
       (Connection: SSE)
   Authorization: Bearer <token>

Headers Accept:

- ``text/event-stream`` (SSE)
- alternativos para WS / long-poll

2.5 Datos de salida (mensaje)
=============================

::

   event: metrics
   data: {
     timestamp,
     queue_count,
     agents_busy,
     agents_idle,
     answered_per_hour,
     abandon_rate_5min,
     service_level_15min,
     lag_seconds,
     segments_applied
   }

Cada 5s mientras la conexion este abierta.

Eventos especiales:

- ``event: heartbeat`` (cada 30s sin data)
- ``event: error`` (con codigo)
- ``event: close`` (servidor cierra)

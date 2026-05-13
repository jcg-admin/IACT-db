.. _uc-rpt-02-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **StreamGateway**
   - endpoint de conexion (SSE / WS)
 * - **AuthorizationGuard**
   - JWT + view_realtime_metrics
 * - **SegmentResolver**
   - segmento del User
 * - **StreamSubscriber**
   - subscribe al pub/sub
 * - **Throttler**
   - max 1 mensaje / 5s
 * - **HeartbeatTimer**
   - emit heartbeat 30s
 * - **ConnectionRegistry**
   - estado de conexiones activas
 * - **AuditService**
   - STREAM_OPENED / CLOSED

11.2 Contratos
==============

::

   contract StreamGateway:
     open(user_id, segments, accept_type)
       returns: ConnectionHandle
     send(handle, snapshot)
     heartbeat(handle)
     close(handle, reason)

   data Snapshot:
     timestamp,
     queue_count, agents_busy,
     agents_idle,
     answered_per_hour,
     abandon_rate_5min,
     service_level_15min,
     lag_seconds,
     segments_applied,
     schema_version

11.3 Pseudocodigo
=================

::

   on_handshake(request):
       user = AuthorizationGuard.validate(
                request.jwt)
       require user.has_function(
                 'view_realtime_metrics')
       segments =
         SegmentResolver.for(user.id)
       if not segments: raise USERLESS

       conn = ConnectionRegistry.register(
         user.id, segments,
         accept=request.accept)

       AuditService.emit(
         'REALTIME_STREAM_OPENED',
         actor=user, payload={segments,
                                accept})

       SubscriberPool.attach(
         conn, segments)

       return conn

   on_stream_event(conn, event):
       Throttler.maybe_emit(
         conn,
         lambda: send_snapshot(conn))

   def send_snapshot(conn):
       snapshot = build_snapshot(
         conn.last_state, now())
       Gateway.write(conn,
                       'metrics', snapshot)

   on_heartbeat_tick(conn):
       if (now - conn.last_emit) > 30:
           Gateway.write(conn,
                          'heartbeat', {})

   on_close(conn, reason):
       SubscriberPool.detach(conn)
       AuditService.emit(
         'REALTIME_STREAM_CLOSED',
         actor=conn.user,
         payload={reason,
                   duration: now - conn.opened_at,
                   event_count: conn.event_count})
       ConnectionRegistry.remove(conn)

11.4 Mapeo excepcion
====================

.. list-table::
 :widths: 40 30 30
 :header-rows: 1

 * - Excepcion
   - HTTP / event
   - Audit
 * - SinPermiso
   - 403
   - UNAUTHORIZED
 * - UserWithoutSegment
   - 400
   - validation
 * - StreamUnavailable
   - 503 / event:error
   - operacion FAILED
 * - ConnectionLimit
   - 429
   - middleware

11.5 Restricciones cross-cutting
================================

- Read-only AnalyticsStream (CNST-007).
- Filtro segmento (CNST-008).
- TLS obligatorio.
- Audit STREAM_OPENED/CLOSED.

11.6 Stack-agnostico
====================

- Pub/sub: Kafka, Redis Streams, NATS,
  RabbitMQ.
- Stream gateway: cualquier servidor con
  soporte SSE/WS (Node, ASGI, Akka HTTP).
- TLS: cualquier reverse proxy / native.

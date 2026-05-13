.. _uc-rpt-02-parte-03:

==========================
Parte 3 — Flujo principal
==========================

3.1 Pasos
=========

**PASO 1 — Handshake**

Frontend abre conexion SSE/WS con JWT.

**PASO 2 — Autenticacion**

Validar JWT (CNST-009). Falla → 401 +
cierre.

**PASO 3 — RBAC**

``view_realtime_metrics``. Falla → 403 +
UNAUTHORIZED audit + cierre.

**PASO 4 — Resolver segmento**

Como UC_RPT_01.

**PASO 5 — Subscribirse a stream**

Backend se suscribe a AnalyticsStream
filtrado por segmento del User. Recibe
eventos a medida que llegan.

**PASO 6 — Buffering y throttling**

Para evitar floods, throttle a max 1
mensaje cada 5s al frontend (incluso si el
stream emite mas).

**PASO 7 — Emitir mensaje**

Construir snapshot:

::

   {
     timestamp: now(),
     queue_count, agents_*, ...,
     lag_seconds: now -
                 stream.last_event_time
   }

Push al frontend.

**PASO 8 — Heartbeat**

Si no hay datos en 30s, emitir
``event: heartbeat`` para mantener vivo
el conexion (proxies cierran idle > 60s).

**PASO 9 — Reconnect handling**

Frontend reconecta automaticamente con
``Last-Event-ID`` (SSE estandar). Backend
puede resumir.

**PASO 10 — Cierre**

User cierra pestana o pierde sesion →
backend cierra suscripcion a stream y
libera recursos.

3.2 Resumen
===========

.. list-table::
 :widths: 8 50 22 20
 :header-rows: 1

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1
   - Handshake stream
   - StreamGateway
   - 009
 * - 2
   - JWT
   - Middleware
   - 009
 * - 3
   - RBAC
   - Guard
   - —
 * - 4
   - Segmento
   - SegmentResolver
   - 008
 * - 5
   - Suscribir
   - StreamSubscriber
   - 007
 * - 6
   - Throttle
   - Throttler
   - —
 * - 7
   - Emit
   - Gateway
   - —
 * - 8
   - Heartbeat
   - Gateway
   - —
 * - 9
   - Reconnect
   - Gateway
   - —
 * - 10
   - Cierre
   - Gateway
   - —

.. _uc-rpt-02-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Reconnect
====================

Cliente reabre conexion con Last-Event-ID.
Backend resume desde ese punto. SSE estandar.

4.2 FA-02: Stream lag alto
==========================

``lag_seconds > threshold (30s)``: Frontend
muestra banner "Datos atrasados". Backend
sigue emitiendo (no oculta).

4.3 FA-03: Segmento sin actividad
=================================

Sin eventos en el stream para el segmento.
Heartbeats cada 30s; queue_count=0,
agents_*=0.

4.4 FA-04: Backpressure
=======================

Cliente lento (slow consumer) — TCP buffer
lleno. Backend dropea events viejos
(no-buffering); ultimo snapshot siempre es
el mas reciente.

4.5 FA-05: Desconexion abrupta
==============================

Cliente cierra sin handshake graceful.
Backend detecta heartbeat timeout (60s) y
limpia suscripcion.

4.6 FA-06: Multi-pestana del mismo User
=======================================

Cada pestana abre su conexion. Backend
multiplexa eficientemente o crea N
suscripciones segun arquitectura. Sin
restriccion en numero, salvo limite
operacional.

4.7 FA-07: Filtros adicionales (futuro)
=======================================

WebSocket bidireccional permite enviar
filtros dinamicos (e.g. solo cola X)
sin reconectar. NO en scope inicial; UC
documenta como extensible.

4.8 Resumen
===========

.. list-table::
 :widths: 12 38 30 20
 :header-rows: 1

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Reconnect
   - resume con Last-Event-ID
   - SSE
 * - FA-02
   - Lag alto
   - banner staleness
   - sigue emitiendo
 * - FA-03
   - Sin actividad
   - heartbeats + 0s
   - vacio
 * - FA-04
   - Slow consumer
   - drop viejos
   - latest-only
 * - FA-05
   - Desconexion abrupta
   - timeout cleanup
   - 60s
 * - FA-06
   - Multi-pestana
   - multiplex
   - limites op
 * - FA-07
   - Filtros dinamicos
   - WS bidireccional
   - extensible

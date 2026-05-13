.. _uc-rpt-02-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Stream basico
========================

Conexion abre, mensajes cada ≤ 5s.

9.2 CA-02: Filtro segmento (CNST-008)
=====================================

Datos solo de segmentos del User.

9.3 CA-03: Reconnect con Last-Event-ID
======================================

Tras corte, reabre y resume sin gap.

9.4 CA-04: Heartbeat
====================

Sin data en 30s → ``event: heartbeat``.

9.5 CA-05: Throttle
===================

Stream a 100/s → max 1/5s al frontend.

9.6 CA-06: Lag reporting
========================

``lag_seconds`` en cada mensaje.

9.7 CA-07: Sin permiso 403
==========================

User sin
``view_realtime_metrics`` → 403 + audit.

9.8 CA-08: Sin segmento 400
===========================

User sin segmento → 400.

9.9 CA-09: Stream caido
=======================

Backend caido → ``event: error`` + cierre.

9.10 CA-10: Audit apertura / cierre
===================================

Cada conexion emite STREAM_OPENED y
STREAM_CLOSED.

9.11 CA-11: Limite conexiones
=============================

User abre 11ª → 429.

9.12 CA-12: Slow consumer
=========================

Cliente lento → drop viejos, ultimo
snapshot siempre el mas reciente.

9.13 CA-13: JWT expirado
========================

Stream cierra con ``token_expired``.

9.14 CA-14: TLS obligatorio
===========================

Conexiones sin TLS rechazadas.

9.15 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..06
   - Stream basico
   - Funcional
 * - CA-07..08
   - Auth/RBAC/segmento
   - Seguridad
 * - CA-09
   - Stream caido
   - Robustez
 * - CA-10
   - Audit
   - Compliance
 * - CA-11
   - Limite
   - Operacional
 * - CA-12
   - Slow consumer
   - Rendimiento
 * - CA-13
   - JWT expira
   - Seguridad
 * - CA-14
   - TLS
   - Seguridad

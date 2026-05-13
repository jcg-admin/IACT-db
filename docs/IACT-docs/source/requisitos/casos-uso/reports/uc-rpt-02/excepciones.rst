.. _uc-rpt-02-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT invalido
=======================

401 + cierre.

5.2 EX-02: Sin permiso
======================

403 + UNAUTHORIZED audit + cierre.

5.3 EX-03: User sin segmento
============================

400 USER_WITHOUT_SEGMENT + cierre.

5.4 EX-04: Stream backend caido
===============================

503 SERVICE_UNAVAILABLE en handshake o
mensaje ``event: error`` durante
stream + cierre.

5.5 EX-05: Limite de conexiones excedido
========================================

429 si User excede limite (10 simultaneas
default). Frontend muestra "Cierre otras
pestanas".

5.6 EX-06: Heartbeat timeout
============================

Backend cierra conexion si no recibe ack /
respuesta en > 60s.

5.7 EX-07: JWT expirado durante stream
======================================

Servidor cierra con ``event: token_expired``.
Frontend re-autentica y reconecta.

5.8 Resumen
===========

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status / event
   - Audit
 * - EX-01
   - JWT
   - 401
   - middleware
 * - EX-02
   - Sin permiso
   - 403
   - UNAUTHORIZED
 * - EX-03
   - Sin segmento
   - 400
   - validation
 * - EX-04
   - Stream caido
   - 503
   - operacion FAILED
 * - EX-05
   - Conexiones excedido
   - 429
   - middleware
 * - EX-06
   - Heartbeat timeout
   - close
   - —
 * - EX-07
   - JWT expirado
   - close + event
   - re-auth

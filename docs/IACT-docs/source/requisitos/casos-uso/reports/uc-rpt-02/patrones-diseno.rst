.. _uc-rpt-02-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

.. list-table::
 :widths: 18 32 50
 :header-rows: 1

 * - Patron
   - Nombre
   - Aplicacion
 * - **P-15**
   - RBAC granular
   - view_realtime_metrics
 * - **P-44**
   - Visibility audit prio
   - audit apertura / cierre stream
 * - **P-58**
   - Segment-bound
   - filtro al subscribir
 * - **P-60** (nuevo)
   - Latest-snapshot delivery
   - drop old events para slow
     consumer
 * - **P-61** (nuevo)
   - Transport-agnostic streaming
   - SSE/WS/poll intercambiables

10.2 P-60: Latest-snapshot delivery
===================================

**Problema**: clientes lentos crean
backpressure; bufferear todos los eventos
en TCP buffer agota memoria; los eventos
viejos pierden valor para realtime.

**Solucion**: solo guardar el ultimo
snapshot. Cuando el buffer del cliente se
libera, recibe el ultimo conocido (no la
secuencia historica). Apropiado para
realtime — no para event sourcing.

10.3 P-61: Transport-agnostic streaming
=======================================

**Problema**: SSE / WebSocket / long-poll
tienen trade-offs; clientes con proxies
restrictivos solo soportan algunos.

**Solucion**: el contrato del UC es del
**mensaje**, no del transport. Backend
implementa varios y negocia segun
``Accept`` / WS handshake.

10.4 Trazabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Origen
   - Implementado en
 * - P-15
   - PASO 3
 * - P-44
   - NFR 6.4
 * - P-58
   - PASO 5
 * - P-60
   - PASO 6, FA-04
 * - P-61
   - 1.4, NFR 6.6

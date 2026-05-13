.. _uc-rpt-02-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

- **Unit**: Throttler, HeartbeatTimer,
  Snapshot builder.
- **Integration**: stream subscribe, drop
  old (slow consumer), reconnect.
- **E2E**: User login → ve metricas RT.
- **Load**: 10K conexiones por nodo.

12.2 Tests unitarios
====================

UT-01: Throttler max 1/5s.
UT-02: Throttler con burst → solo 1 emit.
UT-03: HeartbeatTimer dispara a 30s.
UT-04: HeartbeatTimer NO dispara si hubo
emit reciente.
UT-05: Snapshot incluye lag_seconds.
UT-06: Snapshot con schema_version.

12.3 Tests de integracion
=========================

IT-01: Stream basico — conexion + 5
mensajes en 30s.
IT-02: Filtro segmento: User con seg_a
no recibe seg_b.
IT-03: Reconnect con Last-Event-ID.
IT-04: Slow consumer drop old.
IT-05: Sin actividad → heartbeats.
IT-06: Audit STREAM_OPENED/CLOSED
emitidos.
IT-07: Limite 10 conexiones por User → 11ª
recibe 429.
IT-08: Stream backend caido → event:error
+ cierre.

12.4 Tests E2E
==============

E2E-01: Supervisor login → vista realtime
con datos.
E2E-02: Cambio en cola refleja en < 5s.
E2E-03: Caida del nodo → frontend
reconecta auto.
E2E-04: User sin permiso → 403.

12.5 Tests de carga
===================

LOAD-01: 10K conexiones SSE simultaneas
estables 30 min.
LOAD-02: 100K eventos/s entrada → throttle
emite 1/5s correctamente sin memory leak.

12.6 Tests de seguridad
=======================

SEC-01: User con seg_a manipula param de
URL → no recibe datos cross-segmento.
SEC-02: Conexion sin TLS rechazada.
SEC-03: JWT firmado mal → handshake falla.

12.7 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 12 35 53
 :header-rows: 1

 * - CA
   - Concepto
   - Tests
 * - CA-01
   - Stream basico
   - IT-01, E2E-01
 * - CA-02
   - Segmento
   - IT-02, SEC-01
 * - CA-03
   - Reconnect
   - IT-03, E2E-03
 * - CA-04
   - Heartbeat
   - UT-03, IT-05
 * - CA-05
   - Throttle
   - UT-01, UT-02, LOAD-02
 * - CA-06
   - Lag
   - UT-05
 * - CA-07
   - 403
   - E2E-04
 * - CA-08
   - Sin segmento
   - (auth path)
 * - CA-09
   - Stream caido
   - IT-08
 * - CA-10
   - Audit
   - IT-06
 * - CA-11
   - Limite conexiones
   - IT-07
 * - CA-12
   - Slow consumer
   - IT-04
 * - CA-13
   - JWT expirado
   - integration test
 * - CA-14
   - TLS
   - SEC-02

12.8 Cobertura
==============

- 6 unit tests
- 8 integration tests
- 4 E2E tests
- 2 load tests
- 3 security tests
- 100% de los 14 CAs cubiertos

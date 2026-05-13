.. _uc-rpt-02-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Metrica
   - Target
   - Notas
 * - Frecuencia mensaje
   - 1 / 5s
   - throttled
 * - Lag end-to-end
   - ≤ 5s P95
   - desde evento real al UI
 * - Conexiones simultaneas
   - ≥ 10K por nodo
   - SSE/WS escalable
 * - CPU por conexion
   - ≤ 0.1%
   - eficiencia
 * - Heartbeat overhead
   - despreciable
   - cada 30s

6.2 Confiabilidad
=================

- Disponibilidad ≥ 99.5%.
- Reconnect automatico tras caida del
  backend (con jitter para evitar storm).
- Stream replicado para HA.

6.3 Seguridad
=============

- ``view_realtime_metrics`` enforcement.
- Filtro segmento (CNST-008) en server-side.
- TLS obligatorio para stream.

6.4 Auditabilidad
=================

- Apertura de conexion audited
  ``REALTIME_STREAM_OPENED`` (acceso
  privilegiado P-44).
- Cierre audited
  ``REALTIME_STREAM_CLOSED`` con
  duracion + event_count.

6.5 Usabilidad
==============

- Banner cuando lag > threshold.
- Indicador de conexion (verde / rojo).
- Recovery transparente.

6.6 Mantenibilidad
==================

- Transport modular (SSE / WS / poll
  intercambiables).
- Esquema de mensaje versionado
  (``schema_version`` en payload).

.. _uc-rpt-04-parte-06:

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
 * - Encolar
   - ≤ 200 ms
   -
 * - Job 100K rows
   - ≤ 2 min
   -
 * - Job 1M rows
   - ≤ 30 min
   -
 * - Status check
   - ≤ 50 ms
   -

6.2 Confiabilidad
=================

- Worker pool con autoscaling.
- Retry con backoff (3 retries).
- Audit-or-abort en queueing
  (si audit fail, no se encola).

6.3 Seguridad
=================

- ``export_reports`` enforcement.
- Sin PII en archivo (sanitizer en
  worker).
- URL firmado con TTL 24h.
- File path no predecible (uuid).
- TLS para download.

6.4 Auditabilidad
=================

- P-39 audit reforzado en cada estado.
- Mailbox notify (CNST-002).

6.5 Usabilidad
==============

- Indicador de progreso en UI
  (progress_pct).
- Notificacion mailbox al completar.
- Re-encolar tras expiracion.

6.6 Mantenibilidad
==================

- Worker stateless (escalable horizontal).
- Queue con prioridad por tipo (small
  exports prio).

6.7 Cumplimiento
================

- Sin canales prohibidos (CNST-001).
- Aging archivos automatico (24h).

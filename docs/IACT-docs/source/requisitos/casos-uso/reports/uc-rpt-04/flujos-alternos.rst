.. _uc-rpt-04-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Estimacion excede 1M filas
=====================================

PASO 4 detecta. 400 ROW_LIMIT_EXCEEDED;
sugerir filtros mas selectivos.

4.2 FA-02: User excede limite jobs
==================================

5 jobs activos + nueva request → 429
EXPORT_LIMIT_EXCEEDED. Esperar a que uno
termine.

4.3 FA-03: Permiso revocado durante worker
==========================================

PASO W3 detecta cambio: permiso revocado
o segmento cambio. Job ``failed``
PERMISSION_REVOKED. Audit.

4.4 FA-04: Archivo excede 200 MB
================================

PASO W7. Job failed TOO_LARGE. Notificar
en mailbox sugerencia "filtros mas
selectivos".

4.5 FA-05: Storage caido
========================

PASO W4 / W8. Worker reintenta con backoff;
agotados → job failed STORAGE_UNAVAILABLE.
Mailbox notify.

4.6 FA-06: Format PDF con muchos rows
=====================================

PDF NO escala — limite a 5K filas o vista
de resumen. Si excede, redirigir a CSV.

4.7 FA-07: Status check del job
===============================

::

   GET /api/reports/export/{job_id}/

Response: status, progress_pct, file_url
(si done), error_code (si failed).

4.8 FA-08: Cleanup automatico
=============================

Tras 24h:

- file purged from storage
- ExportJob.status='expired'
- file_url invalidado
- audit REPORT_EXPORT_EXPIRED

User debe re-exportar.

4.9 FA-09: Cancelar job
=======================

::

   DELETE /api/reports/export/{job_id}/

Si status=queued → cancel.
Si running → marcar cancellation_requested
y worker chequea tras cada batch.

4.10 Resumen
============

.. list-table::
 :widths: 12 38 30 20
 :header-rows: 1

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - > 1M filas
   - 400
   - filtros
 * - FA-02
   - > 5 jobs
   - 429
   - cola
 * - FA-03
   - Permiso revocado
   - failed PERMISSION_REVOKED
   - W3
 * - FA-04
   - > 200 MB
   - failed TOO_LARGE
   - W7
 * - FA-05
   - Storage caido
   - retry + failed
   - mailbox
 * - FA-06
   - PDF muchos rows
   - redirigir CSV
   - 5K limit
 * - FA-07
   - Status check
   - GET job_id
   - polling
 * - FA-08
   - Cleanup 24h
   - expired
   - re-export
 * - FA-09
   - Cancelar
   - DELETE
   - graceful

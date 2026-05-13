.. _uc-rpt-04-parte-03:

==========================
Parte 3 — Flujo principal
==========================

3.1 Pasos sync (encolar)
========================

**PASO 1** — POST con payload.

**PASO 2** — JWT.

**PASO 3** — RBAC ``export_reports``.

**PASO 4** — Validar:

- ``report_type`` ∈ enum
- ``format`` ∈ {csv, xlsx, json, pdf}
- ``filters`` valido para report_type.
- estimacion de filas ≤ 1M.

**PASO 5** — Validar User no excede limite
de jobs simultaneos (5 default).

**PASO 6** — Crear ExportJob:

::

   { id: uuid_v7(),
     actor_id: invoker.id,
     report_type, filters,
     period, group_by, format,
     status: 'queued',
     created_at: now() }

**PASO 7** — Encolar en ExportWorker.

**PASO 8** — Audit
``REPORT_EXPORT_QUEUED``.

**PASO 9** — Response 202 con job_id.

3.2 Pasos async (worker)
========================

**PASO W1** — Worker toma job.

**PASO W2** — Estado ``running``.

**PASO W3** — Validar permiso del User
(re-check; permisos pueden haber cambiado
desde encolado).

**PASO W4** — Stream query Analytics:

- query con cursor / streaming
- batch de 10K filas
- escribir batch al archivo en storage
  temporal

**PASO W5** — Sanitizar (sin PII).

**PASO W6** — Compresion opcional (gzip).

**PASO W7** — Validar tamano:

- > 200 MB → fail TOO_LARGE.

**PASO W8** — Mover archivo a storage
final + generar URL firmado (TTL 24h).

**PASO W9** — Estado ``done`` con
file_url, row_count, byte_count,
completed_at.

**PASO W10** — Audit
``REPORT_EXPORT_COMPLETED``.

**PASO W11** — Mailbox notify (CNST-002).

**PASO W12** — Cleanup tras 24h
(automatico, otra UC).

3.3 Resumen
===========

.. list-table::
 :widths: 8 50 22 20
 :header-rows: 1

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1-3
   - POST + JWT + RBAC
   - Endpoint
   - 009
 * - 4
   - Validar
   - Validator
   - —
 * - 5
   - Limite jobs
   - JobLimiter
   - —
 * - 6
   - Crear ExportJob
   - JobRepo
   - —
 * - 7
   - Encolar
   - Worker
   - —
 * - 8
   - Audit QUEUED
   - UC_PERM_09
   - 025
 * - 9
   - 202 con job_id
   - View
   - —
 * - W1-W3
   - Worker pickup + recheck
   - Worker
   - —
 * - W4-W7
   - Stream + escribir
   - Worker + Storage
   - 007
 * - W8-W11
   - URL + audit + mailbox
   - Worker + Mailbox
   - 001/002

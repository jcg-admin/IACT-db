.. _uc-rpt-04-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 ExportJob
=============

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Notas
 * - id
   - uuid
   - PK
 * - actor_id
   - int
   -
 * - report_type
   - enum
   -
 * - filters
   - JSON
   -
 * - period
   - JSON
   -
 * - group_by
   - list[Dimension]
   -
 * - format
   - enum
   -
 * - status
   - queued | running |
     done | failed | expired
     | cancelled
   -
 * - progress_pct
   - 0..100
   -
 * - file_path
   - string | null
   -
 * - file_url
   - string | null
   - firmado
 * - file_url_expires_at
   - timestamp | null
   - +24h
 * - row_count
   - int | null
   -
 * - byte_count
   - int | null
   -
 * - error_code
   - string | null
   -
 * - created_at
   - timestamp
   -
 * - completed_at
   - timestamp | null
   -

7.2 Storage
===========

Object storage (S3 / GCS / MinIO):

- Path: ``exports/{actor_id}/{job_id}/{filename}``.
- Encriptacion at-rest.
- Lifecycle policy: delete > 24h.

7.3 Mailbox message
===================

(Ver Parte 2.6.)

7.4 Datos NO involucrados
=========================

- Email externo (CNST-001).
- BD operativa (CNST-007).
- PII de individuales.

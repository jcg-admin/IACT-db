.. _uc-rpt-04-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User con funcion** ``export_reports``
- **ExportWorker** (background)
- **Storage** (object storage)
- **MailboxService** (notify)
- **AuditService** (UC_PERM_09)

2.2 Precondiciones
==================

- User autenticado.
- ``export_reports`` activa.
- Segmento del User definido.
- ExportWorker disponible.
- Storage operativo.

2.3 Postcondiciones
===================

**Caso queued:**

- ExportJob creado en estado queued.
- Audit REPORT_EXPORT_QUEUED.
- Response 202 con job_id.

**Caso done (async):**

- Archivo en storage.
- URL firmado generado.
- Notificacion en mailbox del User.
- Audit REPORT_EXPORT_COMPLETED.

2.4 Datos de entrada
====================

::

   POST /api/reports/export/
   body: {
     report_type: "historical" | "agents" | ...,
     filters: {...},
     period: ...,
     group_by: ...,
     format: "csv" | "xlsx" | "json" | "pdf",
     filename_hint: string
   }

2.5 Datos de salida (sync)
==========================

::

   {
     job_id: uuid,
     status: "queued",
     check_url: "/api/reports/export/{id}/",
     created_at: timestamp
   }

2.6 Datos de salida (async via mailbox)
=======================================

Mensaje en mailbox:

::

   {
     subject: "Export ready",
     job_id, format,
     file_url (firmado, TTL 24h),
     row_count, byte_count,
     completed_at
   }

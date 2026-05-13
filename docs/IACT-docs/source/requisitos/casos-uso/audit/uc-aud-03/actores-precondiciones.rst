.. _uc-aud-03-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- **User con funcion** ``export_audit``
- **ExportWorker**
- **Storage**
- **MailboxService**

::

   POST /api/audit/export/
   body: {
     filters, period,
     format: csv|json,
     include_archive: bool
   }

Response: 202 + job_id.

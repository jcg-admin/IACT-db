.. _uc-aud-04-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- **User con funcion**
  ``generate_compliance_report``
- **ComplianceWorker**
- **AuditRepo**
- **HMACSigner** (para firmar)

::

   POST /api/audit/compliance/
   body: {
     template: PRIVILEGED_ACCESS|...,
     period: {date_from, date_to},
     format: pdf|csv|json
   }

Response: 202 + job_id.

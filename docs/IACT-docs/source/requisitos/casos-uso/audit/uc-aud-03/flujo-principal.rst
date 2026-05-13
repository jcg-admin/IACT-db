.. _uc-aud-03-parte-03:

==========================
Parte 3 — Flujo principal
==========================

Identico a UC_RPT_04 / UC_PERM_10 export:

PASO 1 — POST.
PASO 2 — JWT + RBAC export_audit.
PASO 3 — Validar (estimacion ≤ 5M filas).
PASO 4 — Limite jobs simultaneos.
PASO 5 — Crear ExportJob.
PASO 6 — Encolar.
PASO 7 — Audit AUDIT_EXPORT_QUEUED.
PASO 8 — 202 + job_id.

Worker (background): re-check permiso
(P-64), stream query, sanitize, escribir
archivo, upload storage, mailbox notify,
audit completed.

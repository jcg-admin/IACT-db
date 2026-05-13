.. _uc-aud-04-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — POST.
PASO 2 — JWT + RBAC.
PASO 3 — Validar template + period.
PASO 4 — Encolar ComplianceWorker.
PASO 5 — Audit COMPLIANCE_REPORT_QUEUED.
PASO 6 — 202.

Worker (background):

PASO W1 — Re-check permiso.
PASO W2 — Ejecutar template-specific
queries.
PASO W3 — Sanitize + format.
PASO W4 — Firmar digitalmente
(HMAC-SHA256 + timestamp).
PASO W5 — Subir a storage + URL firmado.
PASO W6 — Audit COMPLIANCE_REPORT_GENERATED
con file_hash + signature.
PASO W7 — Mailbox notify.

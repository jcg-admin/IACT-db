.. _uc-aud-01-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — GET con filtros + period.
PASO 2 — JWT.
PASO 3 — RBAC view_general_audit.
PASO 4 — Validar.
PASO 5 — Query AuditRepo + cursor.
PASO 6 — Sanitize (truncar payload).
PASO 7 — Build cursor + estimated_total.
PASO 8 — Meta-audit
``GENERAL_AUDIT_QUERIED`` via UC_PERM_09.
PASO 9 — Si meta-audit fail → 503
(P-09 read variant).
PASO 10 — 200.

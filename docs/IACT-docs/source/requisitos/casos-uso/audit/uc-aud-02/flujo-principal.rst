.. _uc-aud-02-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — POST query.
PASO 2 — JWT.
PASO 3 — RBAC search_audit.
PASO 4 — Validar (query no vacio,
date range obligatorio ≤ 90 dias).
PASO 5 — Throttle (search es caro).
PASO 6 — Search en FTS engine + filtros.
PASO 7 — Sanitize results.
PASO 8 — Meta-audit
``AUDIT_SEARCH_QUERIED`` con query (sin
PII en query) + filters.
PASO 9 — 200.

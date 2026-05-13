.. _uc-pip-01-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — GET.
PASO 2 — JWT.
PASO 3 — RBAC.
PASO 4 — Cache lookup (TTL 30s — operacional
inmediato).
PASO 5 — Query ETLMetadataRepo: status de
jobs, lag, throughput.
PASO 6 — Build summary.
PASO 7 — Cache write.
PASO 8 — 200.

Auto-refresh sugerido al frontend: 30s.

.. _uc-pip-03-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — GET.
PASO 2 — JWT + RBAC.
PASO 3 — Cache lookup (TTL 60s).
PASO 4 — Query DatasetMetadata
last_refresh_at por dataset.
PASO 5 — Calcular lag y status
(thresholds configurables).
PASO 6 — Cache write.
PASO 7 — 200.

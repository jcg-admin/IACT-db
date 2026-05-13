.. _uc-opr-09-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — GET.
PASO 2 — JWT.
PASO 3 — Validar period ≤ 7d.
PASO 4 — Query CallSession WHERE
agent_id = invoker.id.
PASO 5 — Sanitize (sin caller raw).
PASO 6 — Paginar.
PASO 7 — 200.

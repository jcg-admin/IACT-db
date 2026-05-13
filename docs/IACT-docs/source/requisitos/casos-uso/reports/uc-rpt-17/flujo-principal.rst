.. _uc-rpt-17-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — GET con period.
PASO 2 — JWT.
PASO 3 — RBAC view_unique_clients_reports.
PASO 4 — Resolver segmento.
PASO 5 — Validar.
PASO 6 — Cache lookup.
PASO 7 — Query distinct count via
``COUNT(DISTINCT client_hash)`` o HLL
(HyperLogLog) si volumen alto.
PASO 8 — Query recurrence distribution
(group by calls_per_client).
PASO 9 — Calcular new vs returning
(comparar contra periodo prior).
PASO 10 — Top N anonimizado (prefix de
hash, no full).
PASO 11 — Cache write.
PASO 12 — 200.

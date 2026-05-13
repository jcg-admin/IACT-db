.. _uc-alr-02-parte-03:

==========================
Parte 3 — Flujo principal
==========================

PASO 1 — GET con filtros.
PASO 2 — JWT.
PASO 3 — RBAC view_active_alerts.
PASO 4 — Resolver segmento.
PASO 5 — Validar filtros.
PASO 6 — Query AlertRepo: state ∈ {firing,
acknowledged}, scope ⊆ segmentos del User.
PASO 7 — Ordenar por severidad DESC,
fired_at DESC.
PASO 8 — Response 200.

Resumen
=======

.. list-table::
 :widths: 8 50 22 20

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1-3
   - GET + JWT + RBAC
   - Endpoint
   - 009
 * - 4-5
   - Segmento + validacion
   - Resolver
   - 008
 * - 6
   - Query
   - AlertRepo
   - —
 * - 7
   - Ordenar
   - Service
   - —
 * - 8
   - 200
   - View
   - —

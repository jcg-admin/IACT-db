.. _uc-acc-03-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Latencia P50**
   - ≤ 100 ms (User tipico con < 5 AGRs y
     < 20 funciones efectivas)
 * - **Latencia P99**
   - ≤ 300 ms
 * - **Throughput**
   - ≥ 100 GET/seg sostenido
 * - **Costo consolidacion**
   - O(direct + agrs × functions_per_agr +
     exceptional). Tipico ~30 ops; con
     indices < 50 ms.

6.2 Seguridad
=============

- HTTPS, JWT (CNST-009).
- RBAC granular: ``view_assignments`` para
  vista de terceros; self-view permite vista
  propia sin esa funcion.
- CNST-026: payload sin email/full_name del
  target.
- Throttling 100/min/invoker.

6.3 Confiabilidad
=================

- Lectura idempotente.
- Cache aprovechable (consolidacion puede
  ser cache-able TTL corto). Decision queda
  en arquitectura — no parte del UC.

6.4 Auditabilidad
=================

- Audit selectivo P-16: vista focalizada por
  user_id se audita.
- Sin PII (CNST-026).
- ``self_view`` flag en payload distingue
  consultas propias.

6.5 Usabilidad
==============

- Tabla con columnas:
  ``function_code``, ``display_name``,
  ``sources`` (badges visuales),
  ``expires_at``, ``sod_warning``.
- Filtros: por origen (direct / via_agr /
  exceptional), por funcion.
- Indicador visual de expirados pendientes
  purge.
- Indicador visual de violaciones SoD
  detectadas (informativas).

6.6 Mantenibilidad
==================

- Logging estructurado.
- Counter
  ``access.view_permissions.{requests,
  unauthorized, not_found, with_sod_warnings}``;
  histogram de latencia + count efectivo.

6.7 Escalabilidad
=================

- Indices:

  - ``assignment(user_id, state)``
  - ``assignment(state, expires_at)``
    (para detectar expirados)
  - ``access_group_function(access_group_id)``
  - ``exceptional_permission(user_id,
    state, expires_at)``

- Batch operations: si en el futuro se
  agrega ``GET /api/users/effective-permissions/``
  amplio, considerar paginacion + cache.

6.8 Cumplimiento
================

- BR-006, BR-008, BR-009.
- CNST-009/013/025 (audit selectivo) /026.

.. _uc-acc-04-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **P50**
   - ≤ 250 ms (incluye expansion AGR + SoD
     evaluation)
 * - **P99**
   - ≤ 600 ms
 * - **Throughput**
   - ≥ 5 POST/seg

6.2 Seguridad
=============

- HTTPS, JWT (CNST-009).
- ``assign_function_groups`` (P-15 distinta
  de ``assign_functions``).
- P-11 anti-self-assign configurable.
- SoD enforcement write-time (CNST-005,
  P-27).
- Throttling 30/min/invoker (CNST-011).

6.3 Confiabilidad
=================

- Atomicidad PASOS 13-16.
- Idempotencia FA-01.
- Cache post-COMMIT (P-29).

6.4 Auditabilidad
=================

- CNST-025 append-only.
- CNST-026 sin PII en payload.
- ``functions_count_added`` distingue
  funciones nuevas vs duplicadas.

6.5 Usabilidad
==============

- Selector de AGR con descripcion +
  funciones contenidas (preview).
- SoD preview opcional (cliente puede llamar
  ``GET /api/users/{id}/access-groups/{agr_id}/sod-preview``
  antes — no parte del UC pero recomendado).
- Confirmacion robusta (operacion masiva).

6.6 Mantenibilidad
==================

- Counter
  ``access.assign_agr.{success, sod_violation,
  agr_not_found, forbidden}``;
  histogram de funciones agregadas por AGR.

6.7 Cumplimiento
================

BR-006, BR-007, BR-008, BR-010, CNST-005,
CNST-009/013/025/026.

.. _uc-acc-05-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

- GET listado P50 ≤ 100 ms (catalogo
  pequeño tipicamente < 100 reglas).
- POST/PATCH/DELETE P50 ≤ 200 ms (incluye
  cache invalidation).
- Throughput: ≥ 50 req/seg.

6.2 Seguridad
=============

- HTTPS, JWT (CNST-009).
- RBAC granular (P-15):
  ``view_separation_rules`` vs
  ``manage_separation_rules``.
- Throttling: 60/min/invoker.

6.3 Confiabilidad
=================

- Atomicidad por operacion (CRUD).
- Cache invalidate post-COMMIT (P-29).
- Idempotencia opcional en PATCH (mismo
  payload → mismo estado).

6.4 Auditabilidad
=================

- CNST-025 append-only.
- CNST-026 sin PII.
- Granularidad por evento:
  SOD_RULES_VIEWED (selectivo P-16),
  SOD_RULE_CREATED, SOD_RULE_MODIFIED,
  SOD_RULE_RETIRED, FAILED.

6.5 Usabilidad
==============

- Editor de reglas con multi-select de
  funciones + descripcion + severity.
- Vista detalle muestra:
  funciones, fecha de creacion, creador,
  severity, conteo de violaciones detectadas
  hoy (cross-link a UC_ACC_03).
- Confirmacion robusta para retirar
  (operacion con impact en enforcement
  global).

6.6 Mantenibilidad
==================

- Counter
  ``access.sod.{view, create, modify,
  retire, duplicate, forbidden}``;
  histograma de reglas activas.

6.7 Cumplimiento
================

- BR-007 SoD: este UC es el lugar canonico
  donde se define BR-007 operativamente.
- CNST-005, CNST-009/013/025/026.

6.8 Cache (operacional)
=======================

- Las reglas SoD se cachean en memoria
  (TTL corto 60s) para que UC_ACC_01/04 no
  golpeen BD en cada validacion.
- Cache invalidation en cualquier
  CREATE/MODIFY/RETIRE — eviction
  cluster-wide via mensaje pub/sub o
  refresh proxy.

.. _uc-acc-09-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

- P50 ≤ 200 ms para listado paginado con
  indices.
- P99 ≤ 500 ms.
- Throughput ≥ 50 GET/seg.
- Costo agregaciones: O(rows scaneados) —
  mitigado con indices y rangos temporales
  obligatorios.

6.2 Seguridad
=============

- HTTPS, JWT (CNST-009).
- ``view_access_audit`` (P-15 granular).
- Whitelist anti-SQLi (P-20).
- Throttling 200/min/invoker.

6.3 Confiabilidad
=================

- Lectura idempotente.
- AuditEvent P-16 emit es atomic con audit
  store mismo.

6.4 Auditabilidad
=================

- Meta-audit P-16: el UC se audita a si mismo
  cuando hay foco target_user_id.
- ACCESS_EVENT_TYPES catalogo:
  FUNCTIONS_ASSIGNED, FUNCTIONS_REVOKED,
  AGR_ASSIGNED, SOD_RULE_*,
  EXCEPTIONAL_PERMISSION_*,
  UNAUTHORIZED_ACCESS_ATTEMPT (subset),
  USER_ELIMINATED (subset que afecta
  Assignments).

6.5 Usabilidad
==============

- Tabla con columnas:
  occurred_at, event_type, actor_username,
  target_username, function_ids (chips),
  outcome (success / failed / alerta).
- Filtros: event_type (multi-select),
  actor / target user, fecha range
  (default ultimos 30 dias), function_id.
- Agregaciones:
  ``/aggregations/?group_by=event_type``,
  ``/?group_by=actor_user_id``.
- Vista detalle expandible (no abre nueva
  pagina) con payload completo.

6.6 Mantenibilidad
==================

- Counter
  ``access.audit.{requests, by_filter}``;
  histogram de latencia.
- Indices recomendados:

  - ``audit_event(event_type, occurred_at)``
  - ``audit_event(actor_user_id, occurred_at)``
  - ``audit_event((payload->target_user_id))``
    funcional (MySQL 8 JSON virtual column)

6.7 Cumplimiento
================

- BR-010 Auditoria.
- CNST-009/013/025/026.

6.8 Retencion
=============

CNST-006 retencion 2 anios. UC_ACC_09 puede
consultar hasta 2 anios atras. Eventos mas
viejos archivados en sistema separado
(scope de UC_LOG_*).

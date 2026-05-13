.. _uc-perm-06-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

- P50 ≤ 300 ms (incluye SoD cascade
  validation O(users_with_agr × rules)).
- P99 ≤ 800 ms con 100+ Users con AGR.
- Throughput ≥ 2 POST/seg sostenido.

Costo SoD cascade: O(N × M × R) donde
N=users_with_agr, M=delta functions,
R=sod_rules. Mitigado con cache de SoDRules
y limites en payload size (max 20 functions
delta).

6.2 Seguridad
=============

- HTTPS, JWT (CNST-009).
- ``manage_access_group_composition``
  (P-15 separable de manage_access_groups).
- Cascade SoD enforcement obligatorio (P-27
  + P-28 escalado).
- Throttling 30/hora (operacion poco
  frecuente).

6.3 Confiabilidad
=================

- Atomicidad PASOS 12-15.
- Cache invalidate post-COMMIT.
- All-or-nothing si cascade SoD violation.

6.4 Auditabilidad
=================

- AuditEvent
  ``ACCESS_GROUP_COMPOSITION_CHANGED``
  high-priority (afecta cascade).
- payload: ``functions_added``,
  ``functions_removed``, ``change_reason``,
  ``cascade_affected_user_count``,
  ``cascade_violations_count`` (si
  permissive).

6.5 Usabilidad
==============

- Editor con multi-select de functions
  disponibles.
- Preview SoD cascade obligatorio antes de
  submit.
- Modal robusto con count de Users
  afectados.
- Indicador visual de funciones a agregar /
  quitar.

6.6 Mantenibilidad
==================

Counter
``perm.composition.{success,
sod_violation, predefined_blocked,
forbidden, validation_error}``.

Histograma de
cascade_affected_user_count.

6.7 Cumplimiento
================

BR-006, BR-007, BR-010, CNST-005,
CNST-009/013/025/026.

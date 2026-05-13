.. _uc-acc-08-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

- P50 ≤ 250 ms (similar a UC_ACC_01).
- P99 ≤ 600 ms.
- Throughput ≥ 2 POST/seg (operacion poco
  frecuente).

6.2 Seguridad
=============

- HTTPS, JWT (CNST-009).
- ``grant_exceptional_permission`` (P-15
  granular distinta de ``assign_functions``
  — privilegio mas restringido).
- P-11 anti-self-grant obligatorio.
- SoD write-time (CNST-005, P-27).
- justification + expires_at obligatorios.
- Throttling ESTRICTO 10/hora/invoker
  (vs 30/min en UC_ACC_01) — operaciones
  excepcionales NO son rutinarias.

6.3 Confiabilidad
=================

- Atomicidad PASOS 13-16.
- Mailbox-or-abort HARD (P-10) — sin
  notificacion al User no se completa el
  grant.
- Cache post-COMMIT (P-29).

6.4 Auditabilidad
=================

- CNST-025.
- CNST-026 sin PII.
- Granularidad reforzada: payload incluye
  ``justification``, ``expires_at``,
  ``ticket_reference`` (si politica).
- AuditEvents ``EXCEPTIONAL_PERMISSION_*``
  son automaticamente tagged como
  high-priority en compliance reports.

6.5 Usabilidad
==============

- Form con campos OBLIGATORIOS:
  function_ids (multi-select), expires_at
  (datetime picker con bounds), justification
  (textarea minima 20 chars).
- Confirmacion ROBUSTA (operacion
  excepcional).
- Preview de SoD impact antes de submit
  (recomendado).
- Recordatorio visual al admin: "esta
  operacion sera auditada con high
  priority".

6.6 Mantenibilidad
==================

- Logging detallado (sin PII).
- Counter
  ``access.exceptional.{success, sod_violation,
  forbidden, mailbox_failed, validation_error,
  rate_limited}``;
  histogram de duraciones (expires_at -
  granted_at).
- Alertas:

  - EX-02 (UNAUTHORIZED) → alerta alta.
  - EX-05 (auto-grant) → alerta critica.
  - > 5 grants/dia mismo invoker → alerta
    investigacion (uso excesivo del canal
    excepcional).
  - duracion > 14 dias → alerta media (review
    necesaria).

6.7 Cumplimiento
================

- BR-008 Permisos con vencimiento (obligatorio
  expires_at).
- BR-007 SoD.
- BR-010 Auditoria.
- CNST-005, CNST-009/013/025/026.

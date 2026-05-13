.. _uc-perm-04-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

- P50 ≤ 150 ms.
- P99 ≤ 400 ms.
- Throughput ≥ 5 DELETE/seg.

6.2 Seguridad
=============

- HTTPS, JWT (CNST-009).
- ``revoke_exceptional_permission`` (P-15).
- P-11 anti-self-revoke (configurable).
- Throttling 30/hora estricto.
- ``revoke_reason`` ≥ 20 chars obligatorio.

6.3 Confiabilidad
=================

- Atomicidad PASOS 11-14.
- Mailbox-or-abort HARD (P-10).
- Cache post-COMMIT.

6.4 Auditabilidad
=================

- AuditEvent
  EXCEPTIONAL_PERMISSION_REVOKED
  high-priority.
- Diferencia clara con EXPIRED (cron):
  ``revoked_by_admin_id`` poblado.

6.5 Usabilidad
==============

- Lista de permission excepcionales del User
  con destacado de los proximos a expirar.
- Modal robusto con composicion del permiso
  + reason obligatoria.
- Indicador visual post-revoke
  (state=REVOKED en gris).

6.6 Mantenibilidad
==================

Counter
``perm.exceptional_revoke.{success,
forbidden, not_found, invalid_state,
mailbox_failed}``.

6.7 Cumplimiento
================

BR-009 Bajas Logicas, BR-010 Auditoria,
CNST-025/026.

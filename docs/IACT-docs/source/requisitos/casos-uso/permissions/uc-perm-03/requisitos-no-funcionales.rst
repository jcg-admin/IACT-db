.. _uc-perm-03-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

NFRs heredados de UC_ACC_08. Ver Parte 6 de
UC_ACC_08.

6.1 Deltas vista PERM
=====================

- GET preview-exceptional: P50 ≤ 100 ms.
- Refresh catalogo funciones (con counts de
  Users con permiso excepcional vigente):
  cached.
- Counter ``perm.exceptional.{success,
  forbidden, sod, mailbox_failed,
  rate_limited}``.

6.2 Performance / Seguridad / Auditabilidad / Cumplimiento
==========================================================

Identicos a UC_ACC_08 (throttling estricto
10/hora, mailbox HARD, audit reforzado high-
priority, BR-008, CNST-005).

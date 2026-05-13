.. _uc-perm-02-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

NFRs heredados de UC_ACC_02. Esta parte
documenta deltas vista PERM.

6.1 Performance
===============

Backend: P50 ≤ 150 ms (heredado).

Vista PERM agrega:

- GET preview-revoke: P50 ≤ 100 ms.
- Refresh catalogo + counts: O(1) con
  cache.

6.2 Seguridad
=============

Heredada. Boton "Revocar" en vista PERM
visible solo con
``revoke_function_groups``.

6.3 Confiabilidad
=================

Heredada. Cache catalogo invalidado
post-COMMIT.

6.4 Auditabilidad
=================

AuditEvent ``AGR_REVOKED`` identico a backend
UC_ACC_02. No distingue origen UI.

6.5 Usabilidad
==============

- Modal con composicion expandida del AGR
  (functions afectadas).
- Doble confirmacion si warnings criticos.
- Refresh catalogo automatico
  post-revocacion.

6.6 Mantenibilidad
==================

Counter
``perm.revoke_agr.{success, forbidden,
last_holder_blocked, validation_error}``;
histogramas heredados de UC_ACC_02.

6.7 Cumplimiento
================

Identico a UC_ACC_02 (BR-009, BR-010,
CNST-009/013/025/026).

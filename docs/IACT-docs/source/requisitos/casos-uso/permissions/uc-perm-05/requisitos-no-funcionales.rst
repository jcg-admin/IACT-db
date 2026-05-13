.. _uc-perm-05-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

- Listar / detalle: P50 ≤ 100 ms.
- Crear / modificar / retirar: P50 ≤ 150 ms.

6.2 Seguridad
=============

- HTTPS, JWT (CNST-009).
- ``manage_access_groups`` (P-15
  granular).
- Validacion code formato anti-injection.
- Throttling 30/hora (operaciones CRUD
  catalogo son infrecuentes).

6.3 Confiabilidad
=================

- Atomicidad por operacion (persistencia +
  audit).
- Cache catalogo invalidate post-COMMIT.

6.4 Auditabilidad
=================

- CNST-025 append-only.
- CNST-026 sin PII.
- AuditEvents: ``ACCESS_GROUP_CREATED``,
  ``ACCESS_GROUP_MODIFIED``,
  ``ACCESS_GROUP_RETIRED``,
  variantes ``_FAILED``.
- Granularidad: payload incluye ``code``,
  ``display_name``, ``severity``,
  ``users_with_agr_count`` (en RETIRED).

6.5 Usabilidad
==============

- Editor con preview de funciones contenidas
  (delegando a UC_PERM_06).
- Modal robusto para retirar (operacion
  critica).
- Indicador visual de AGR predefinido vs
  custom.

6.6 Mantenibilidad
==================

Counter
``perm.access_group.{create_success,
modify_success, retire_success,
duplicate, predefined_blocked, validation,
forbidden}``.

6.7 Cumplimiento
================

BR-006, BR-009, BR-010, CNST-009/013/025/026.

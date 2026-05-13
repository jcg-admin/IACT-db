.. _uc-perm-05-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion** ``manage_access_groups``
(P-15).

Audiencia tipica: admin de seguridad,
arquitecto RBAC, governance officer.

2.2 Actores Secundarios
=======================

- Sistema (validar code unique, persistir,
  audit).
- Auditor.

2.3 Precondiciones
==================

- Backend respondiendo en
  ``/api/access-groups/`` (POST/PATCH/DELETE).
- Invocante con ``manage_access_groups``.

Para crear:

- ``code`` provisto, valido (regex
  ``^[a-z][a-z0-9_]+_group$``), no colisiona
  con predefinidos AGR-001..010 ni otro AGR
  custom ACTIVE.
- ``display_name`` y ``description``
  provistos.

Para modificar/retirar:

- AGR existe.
- AGR custom (NO predefinido).
- AGR en state ACTIVE.

2.4 Postcondiciones
===================

2.4.1 Crear (exito)
-------------------

- 1 nuevo ``AccessGroup`` con
  ``state=ACTIVE``, ``is_predefined=false``,
  ``created_at``, ``created_by_admin_id``.
- AuditEvent ``ACCESS_GROUP_CREATED``.

2.4.2 Modificar (exito)
-----------------------

- AccessGroup actualizado con
  ``last_modified_at``,
  ``last_modified_by_admin_id``.
- AuditEvent ``ACCESS_GROUP_MODIFIED``.

2.4.3 Retirar (exito)
---------------------

- AGR ``state=RETIRED``,
  ``retired_at``, ``retired_by_admin_id``,
  ``retire_reason``.
- AuditEvent ``ACCESS_GROUP_RETIRED``.
- **Importante**: NO se revocan
  Assignments existentes con este AGR. La
  decision politica es preservar para
  trazabilidad — los Users con el AGR
  retirado siguen teniendolo hasta
  revocacion explicita (UC_PERM_02 /
  UC_ACC_02).

2.4.4 Postcondiciones de fallo
------------------------------

EX-01..XX: rollback total.

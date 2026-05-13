.. _uc-acc-05-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion** ``view_separation_rules``
(lectura) o ``manage_separation_rules``
(CRUD). P-15 RBAC granular: la lectura puede
otorgarse sin la gestion (perfil auditor).

2.2 Actores Secundarios
=======================

- **Sistema (Backend)**: validar reglas no
  ambiguas, no contradictorias entre si,
  aplicables a funciones existentes.
- **Stakeholders (consumidores)**:
  UC_ACC_01/04, UC_PERM_03 cargan reglas
  ACTIVE en cache y validan write-time.
- **Auditor**: consume AuditEvent
  ``SOD_RULE_*`` para compliance.

2.3 Precondiciones
==================

- Backend respondiendo en
  ``/api/access/sod-rules/`` (GET/POST/
  PATCH/DELETE).
- BD MySQL accesible.
- Invocante con la funcion correspondiente.

Para crear/modificar:

- Las funciones referenciadas existen y
  ACTIVE en catalogo.
- La nueva regla NO duplica una existente
  ACTIVE (mismo conjunto de funciones).

2.4 Postcondiciones
===================

2.4.1 Listado (lectura)
-----------------------

- 200 OK con lista paginada filtrada.
- AuditEvent ``SOD_RULES_VIEWED`` solo si se
  filtra por ``rule_id`` especifico (P-16
  audit selectivo).

2.4.2 Crear (CRUD)
------------------

- 1 nueva ``SoDRule`` con
  ``state='ACTIVE'``,
  ``created_at``,
  ``created_by_admin_id``.
- Cache de reglas ACTIVE invalidado
  (post-COMMIT) — UC_ACC_01/04/PERM_03
  recargan.
- AuditEvent ``SOD_RULE_CREATED``.

2.4.3 Modificar (CRUD)
----------------------

- ``SoDRule`` actualizada con
  ``last_modified_at``,
  ``last_modified_by_admin_id``.
- Cache invalidado.
- AuditEvent ``SOD_RULE_MODIFIED`` con
  ``fields_changed``.

2.4.4 Retirar (CRUD)
--------------------

- ``SoDRule.state RETIRED``,
  ``retired_at``,
  ``retired_by_admin_id``,
  ``retire_reason``.
- Cache invalidado (las reglas RETIRED ya no
  se aplican en write-time).
- AuditEvent ``SOD_RULE_RETIRED``.

2.4.5 Postcondiciones de fallo
------------------------------

- EX-01..EX-XX: rollback completo. Sin
  cambios en BD. Cache no invalidada.

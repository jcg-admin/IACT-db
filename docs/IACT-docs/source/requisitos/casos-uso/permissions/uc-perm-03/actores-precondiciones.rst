.. _uc-perm-03-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion**
``grant_exceptional_permission``. P-15
granular distinta de
``assign_functions`` y
``assign_function_groups``.

Audiencia tipica: admin de seguridad,
compliance officer respondiendo a tickets de
acceso ad-hoc.

2.2 Actores Secundarios
=======================

Heredados de UC_ACC_08:

- User destino (recibe capacidades temporales).
- Sistema (validar, persistir, mailbox HARD).
- Cron de expiracion.
- Auditor (high-priority audit).

2.3 Precondiciones
==================

Identicas a UC_ACC_08:

- Backend respondiendo,
  ``grant_exceptional_permission``.
- User destino existe + state ∈ {ACTIVE,
  INACTIVE}.
- Funciones existen + ACTIVE.
- ``expires_at`` valido (NOW()+1h ≤ x ≤
  NOW()+30d).
- ``justification`` ≥ 20 chars.
- SoD compliance del set efectivo resultante.

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

Identicas a UC_ACC_08:

- N ``ExceptionalPermission`` ACTIVE
  creados.
- Cache invalidada post-COMMIT.
- 1 ``InternalMessage`` OBLIGATORIO al User.
- 1 ``AuditEvent
  EXCEPTIONAL_PERMISSION_GRANTED`` con
  payload reforzado.

2.4.2 Postcondiciones de fallo
------------------------------

Heredadas: rollback total ante cualquier
error.

2.4.3 Postcondiciones asincronas
--------------------------------

Cron expira eventualmente:
``ExceptionalPermission.state EXPIRED`` +
AuditEvent EXCEPTIONAL_PERMISSION_EXPIRED.

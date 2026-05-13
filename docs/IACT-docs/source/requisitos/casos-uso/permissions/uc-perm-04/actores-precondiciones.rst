.. _uc-perm-04-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion**
``revoke_exceptional_permission``. P-15 RBAC
granular: distinta de
``grant_exceptional_permission``. Tipica
audiencia: admin de seguridad / compliance.

2.2 Actores Secundarios
=======================

- User destino (recibe notificacion).
- Sistema (validar, persistir, mailbox HARD).
- Auditor (high-priority).

2.3 Precondiciones
==================

- Backend respondiendo en
  ``/api/users/{id}/exceptional-permissions/{id}/``
  (DELETE).
- Invocante con
  ``revoke_exceptional_permission``.
- User destino existe.
- Existe ExceptionalPermission con
  ``state=ACTIVE``.
- ``revoke_reason`` provisto y ≥ 20 chars
  (auditabilidad).
- ``user_id != invoker.id`` si politica
  P-11.

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- ExceptionalPermission con
  ``state=REVOKED``,
  ``revoked_at=NOW()``,
  ``revoked_by_admin_id``,
  ``revoke_reason``.
- Cache invalidada (post-COMMIT).
- 1 InternalMessage al User obligatorio.
- 1 AuditEvent
  ``EXCEPTIONAL_PERMISSION_REVOKED``
  high-priority.

2.4.2 Postcondiciones de fallo
------------------------------

EX-01..EX-XX: rollback total. Sin cambios en
ExceptionalPermission.

2.4.3 Diferencia con expiracion automatica
------------------------------------------

- ``state=EXPIRED`` (cron):
  ``revoked_by_admin_id == NULL``,
  AuditEvent EXPIRED.
- ``state=REVOKED`` (este UC):
  ``revoked_by_admin_id`` con admin,
  AuditEvent REVOKED + reason.

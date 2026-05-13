.. _uc-usr-03-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**Admin con AGR-006** y funcion ``modify_users``.

2.2 Actores Secundarios
=======================

- **User modificado**: receptor pasivo. Si el
  cambio incluye state → BLOCKED, recibe
  notificacion via InternalMailbox (politica).
- **Sistema**: validar transiciones de state
  permitidas, cerrar Sessions tras BLOCKED,
  emitir AuditEvent.
- **Auditor**: consume AuditEvent
  USER_MODIFIED.

2.3 Precondiciones
==================

- Backend respondiendo en
  ``/api/users/{id}/`` (PATCH).
- Admin autenticado con ``modify_users``.
- ``User`` destino existe y ``state !=
  'ELIMINATED'``.
- ``user_id != admin.id`` para cambios de
  state (anti-self-state-change — P-11
  Anti-self-action).

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- ``User`` actualizado con campos provistos.
- Si ``state → BLOCKED``: todas las Sessions
  ACTIVE del User cerradas (con
  ``close_reason='ADMIN_BLOCKED'``).
- ``Audit Event USER_MODIFIED`` con payload
  conteniendo: ``target_user_id``,
  ``fields_changed`` (lista de keys), ``old_state``
  / ``new_state`` si aplica, ``ip``, ``user_agent``.
- (Opcional) InternalMessage al User si state
  cambio.

2.4.2 Postcondiciones de fallo
------------------------------

- EX-01..EX-08: rollback completo. Sin cambios
  en User. Sin sessiones cerradas. Posible
  USER_MODIFY_FAILED.

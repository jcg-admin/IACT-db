.. _uc-acc-03-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion** ``view_assignments``.

La dependencia canonica del UC es la funcion.
``view_assignments`` es lectura — distinta de
``assign_functions`` y ``revoke_functions``
(P-15 RBAC granular: lectura puede otorgarse
sin escritura para investigadores / auditores).

En el catalogo predefinido, esta funcion esta
contenida en AGR-006 user_admin_group y
AGR-008 auditor_group. AGRs custom pueden
contenerla.

2.2 Actores Secundarios
=======================

- **User consultado**: pasivo, no notificado.
- **Sistema**: consolidacion de fuentes,
  deduplicacion, calculo de origen por funcion.
- **BD analitica**: indices apropiados sobre
  ``Assignment``, ``AccessGroup``,
  ``ExceptionalPermission`` para query
  consolidacion.
- **Auditor (P-16)**: consume AuditEvent
  ``EFFECTIVE_PERMISSIONS_VIEWED`` cuando se
  consulta a un User especifico (focalizada).

2.3 Precondiciones
==================

- Backend respondiendo en
  ``/api/users/{user_id}/effective-permissions/``
  (GET).
- BD MySQL accesible.
- Invocante con ``view_assignments`` activo.

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- Respuesta consolidada con:

  - ``user_id``, ``username``
  - ``effective_functions``: lista deduplicada
    con metadata de origen
  - ``via_direct``: subset de las anteriores
  - ``via_agrs``: subset con AGR origen
  - ``via_exceptional``: subset con
    permission origen
  - ``expired_pending_purge``: subset que
    son ACTIVE pero ``expires_at < NOW()``
    (deuda — el cron no ha corrido aun)
  - ``sod_violations_detected``: lista
    informativa de pares conflictivos
    (auditoria — no bloqueo)

- 1 AuditEvent ``EFFECTIVE_PERMISSIONS_VIEWED``
  con ``target_user_id``, ``self_view``,
  conteos.

2.4.2 Postcondiciones de fallo
------------------------------

- EX-01..EX-04: rollback no aplica
  (read-only). Posible AuditEvent
  ``UNAUTHORIZED_ACCESS_ATTEMPT``.

2.4.3 Postcondiciones de self-view
----------------------------------

Si ``user_id == invoker.id``, el UC se permite
sin ``view_assignments`` requerido (el User
puede ver SUS PROPIOS permisos via
``/api/auth/me/permissions/`` — endpoint
analogo permitido por funcion implicita
``view_own_permissions``). Este UC sigue siendo
para vista de TERCEROS.

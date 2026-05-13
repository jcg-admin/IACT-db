.. _uc-acc-08-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion**
``grant_exceptional_permission``. P-15 RBAC
granular: distinta de ``assign_functions``
(UC_ACC_01) — el otorgamiento excepcional es
privilegio mas restringido. Tipicamente
solo en AGR-006 user_admin_group y AGR de
compliance.

2.2 Actores Secundarios
=======================

- **User destino**: receptor pasivo. Recibe
  capacidades temporales.
- **Sistema**: validar User + funciones,
  validar SoD, persistir
  ExceptionalPermission, notificar
  InternalMessage obligatorio.
- **Cron de expiracion**: proceso externo
  que monitorea ``expires_at`` y transiciona
  ExceptionalPermission a EXPIRED.
- **Auditor**: consume AuditEvent
  ``EXCEPTIONAL_PERMISSION_GRANTED`` con
  alta visibilidad (los excepcionales son
  flagged automaticamente en compliance
  reports).

2.3 Precondiciones
==================

- Backend respondiendo en
  ``/api/users/{user_id}/exceptional-permissions/``
  (POST).
- Invocante con
  ``grant_exceptional_permission``.
- User destino existe, state ∈ {ACTIVE,
  INACTIVE}, NO ELIMINATED/BLOCKED.
- Funciones existen + ACTIVE.
- ``expires_at`` valido (> NOW()+1h, <=
  NOW()+30 dias por default).
- ``justification`` provisto y no vacio
  (longitud minima recomendada 20 chars).
- Conjunto efectivo resultante cumple SoD.

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- N nuevos
  ``ExceptionalPermission`` con
  ``state='ACTIVE'``,
  ``expires_at``, ``justification``,
  ``granted_at``,
  ``granted_by_admin_id``.
- Cache de permisos invalidada.
- 1 ``InternalMessage`` OBLIGATORIO al User
  destino con detalle (funciones, vigencia,
  justificacion).
- 1 ``AuditEvent
  EXCEPTIONAL_PERMISSION_GRANTED`` con
  payload reforzado: ``target_user_id``,
  ``function_ids``, ``expires_at``,
  ``justification``, ``ip``,
  ``user_agent``,
  ``ticket_reference`` (si politica lo exige).

2.4.2 Postcondiciones de fallo
------------------------------

- EX-01..EX-XX: rollback completo. Sin
  ExceptionalPermission, sin
  InternalMessage, sin AuditEvent
  GRANTED. Posible
  EXCEPTIONAL_PERMISSION_GRANT_FAILED.

2.4.3 Postcondiciones de expiracion (asincrona)
-----------------------------------------------

Cuando el cron detecta
``ExceptionalPermission.expires_at < NOW()``:

- ``state`` transita a ``EXPIRED``.
- Cache invalidada.
- AuditEvent
  ``EXCEPTIONAL_PERMISSION_EXPIRED``.

(Esa logica vive en otro UC operativo
``uc-cron-expire-permissions`` no
documentado en este WP.)

.. _uc-perm-02-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion** ``revoke_function_groups``
(P-15 RBAC granular distinta de
``assign_function_groups``).

Audiencia tipica vista PERM: admin de
seguridad / compliance officer.

2.2 Actores Secundarios
=======================

Heredados de UC_ACC_02:

- User destino (pasivo).
- Sistema (validar, persistir, notificar).
- Auditor (consume AuditEvent).

Adicional vista PERM:

- Admin de catalogo: usa la vista para
  gestionar cobertura del catalogo de AGRs.

2.3 Precondiciones
==================

Identicas a UC_ACC_02 sobre Assignment AGR:

- Backend respondiendo, BD accesible.
- Invocante con ``revoke_function_groups``.
- User destino existe, no ELIMINATED.
- Existe Assignment ACTIVE
  (target_type='AccessGroup',
  target_id=agr_id) para el User.
- ``revoke_reason`` provisto y no vacio.

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- Assignment AGR con ``state=REVOKED``,
  ``revoked_at``, ``revoked_by_admin_id``,
  ``revoke_reason``.
- Cache de permisos invalidada (post-COMMIT).
- 1 ``AuditEvent AGR_REVOKED`` con payload
  ``{target_user_id, access_group_id,
  access_group_code,
  functions_count_revoked,
  revoke_reason, post_revoke_active_count,
  warnings}``.
- (Opcional) InternalMessage al User.

2.4.2 Postcondiciones de fallo
------------------------------

EX-01..EX-XX heredadas de UC_ACC_02:
rollback completo. Sin cambios en Assignment.
Sin AuditEvent AGR_REVOKED.

2.4.3 Warnings post-revoke
--------------------------

Heredados de UC_ACC_02 (no_functions,
critical_revoked, last_holder). Aplicados
al conjunto efectivo de funciones
(expandiendo el AGR revocado).

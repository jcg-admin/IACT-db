.. _uc-acc-04-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion**
``assign_function_groups`` (P-15 RBAC granular).

Distinta de ``assign_functions`` (UC_ACC_01) —
tipicamente otorgada al mismo perfil de admin
operacional, pero como funcion atomica
separada permite escenarios donde solo se
permite asignacion via AGRs predefinidos
(politica conservadora).

2.2 Actores Secundarios
=======================

- **User destino**: receptor pasivo. Recibe
  capacidades del AGR.
- **Sistema**: validar AGR existe ACTIVE,
  expandir funciones, validar SoD del set
  resultante (write-time), persistir
  Assignment con target_type=AGR, invalidar
  cache.
- **Auditor**: consume AuditEvent
  AGR_ASSIGNED.

2.3 Precondiciones
==================

- Backend respondiendo en
  ``/api/users/{user_id}/access-groups/``
  (POST).
- Invocante con
  ``assign_function_groups`` activo.
- User destino existe, state ∈ {ACTIVE,
  INACTIVE}, NO ELIMINATED/BLOCKED.
- AGR a asignar existe y state=ACTIVE.
- Conjunto efectivo resultante (current +
  funciones del AGR) cumple SoD.

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- 1 nuevo ``Assignment`` con
  ``target_type='AccessGroup'``,
  ``target_id=agr_id``,
  ``state='ACTIVE'``,
  ``granted_at=NOW()``,
  ``granted_by_admin_id=invoker.id``,
  ``expires_at`` opcional.
- Cache de permisos invalidada (post-COMMIT).
- 1 ``AuditEvent AGR_ASSIGNED`` con
  payload conteniendo
  ``target_user_id``, ``access_group_id``,
  ``access_group_code``,
  ``functions_count_added`` (cantidad de
  funciones que aporta efectivamente — puede
  ser menor al total del AGR si algunas ya
  estaban directas), ``expires_at``,
  ``sod_rules_evaluated``.
- (Opcional) InternalMessage al User.

2.4.2 Postcondiciones de fallo
------------------------------

- EX-01..EX-09: rollback completo. Sin
  Assignment creado. Sin AuditEvent
  AGR_ASSIGNED. Posible AGR_ASSIGN_FAILED.

2.4.3 Postcondiciones idempotentes
----------------------------------

Si User ya tiene el AGR asignado y ACTIVE:

- NO se crea nuevo Assignment.
- AuditEvent AGR_ASSIGN_NOOP con
  ``access_group_id``,
  ``original_granted_at``.
- Status 200 informativo.

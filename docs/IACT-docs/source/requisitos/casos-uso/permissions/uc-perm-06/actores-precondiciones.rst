.. _uc-perm-06-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion**
``manage_access_group_composition``. P-15
distinta de ``manage_access_groups``
(UC_PERM_05): un admin puede crear AGRs sin
poder modificar composicion (separacion de
duties dentro de governance).

2.2 Actores Secundarios
=======================

- AGR custom: target del cambio.
- Users con el AGR: receptores cascade.
- Sistema (validar, persistir, audit).
- Auditor.

2.3 Precondiciones
==================

- Backend respondiendo en
  ``/api/access-groups/{id}/functions/``
  (POST, DELETE).
- Invocante con
  ``manage_access_group_composition``.
- AGR existe + ACTIVE + custom (NO
  predefinido — predefinidos son inmutables).
- Funciones a agregar / quitar existen +
  ACTIVE.
- Conjunto resultante respeta SoD para
  TODOS los Users con el AGR (defensa
  cascade).
- ``change_reason`` ≥ 20 chars (auditabilidad).

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- N nuevos ``AccessGroupFunction`` (add)
  insertados.
- M ``AccessGroupFunction`` (remove)
  eliminados.
- Cache de AGR + permisos invalidado
  (post-COMMIT).
- 1 ``AuditEvent
  ACCESS_GROUP_COMPOSITION_CHANGED`` con
  ``functions_added``,
  ``functions_removed``, ``change_reason``,
  ``cascade_affected_user_count``.

2.4.2 Postcondiciones de fallo
------------------------------

EX-01..XX: rollback total.

2.4.3 Cascade postconditions
----------------------------

Para cada User con AGR ACTIVE:

- Si add: capacidades nuevas disponibles
  proxima request.
- Si remove + User no tiene la funcion por
  otro source: capacidad perdida proxima
  request.
- Si remove + User tiene otro source: sin
  cambio (UC_ACC_03 mostrara source
  alternativo).

NO se notifica individualmente a cada User
afectado (politica para evitar spam — el
cambio se documenta en AuditEvent y los
Users descubren el cambio cuando intenten
operacion).

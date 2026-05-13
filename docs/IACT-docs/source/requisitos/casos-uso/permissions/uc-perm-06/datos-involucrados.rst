.. _uc-perm-06-parte-07:

============================
Parte 7 — Datos involucrados
============================

7.1 Endpoint
============

POST
``/api/access-groups/{agr_id}/functions/``
con funcion
``manage_access_group_composition``.

(Tambien GET para inspeccion — heredado de
otros UCs de lectura).

7.2 Request
===========

.. code-block:: json

   {
     "add_function_ids": [10, 15],
     "remove_function_ids": [20],
     "change_reason": "TKT-12340 -
                       Reorganizacion de
                       perfil soporte_n2",
     "policy": "strict"
   }

7.3 Response 200
================

.. code-block:: json

   {
     "agr_id": 11,
     "agr_code": "soporte_n2_group",
     "added": [
       {"function_id": 10,
        "function_code": "view_logs"}
     ],
     "removed": [
       {"function_id": 20,
        "function_code": "modify_users"}
     ],
     "skipped_add": [
       {"function_id": 15,
        "reason": "already_in_agr"}
     ],
     "skipped_remove": [],
     "cascade_affected_user_count": 5,
     "cascade_violations": [],
     "change_reason": "TKT-12340 ...",
     "changed_at": "2026-05-01T20:00:00Z"
   }

7.4 Modelo de datos tocado
==========================

7.4.1 AccessGroupFunction (INSERT N + DELETE M)
-----------------------------------------------

Tabla pivote pura:

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Notas
 * - access_group_id
   - BIGINT (FK)
   - referencia AGR
 * - function_id
   - BIGINT (FK)
   - referencia Function

UNIQUE constraint
``(access_group_id, function_id)``.

NO se modifica AccessGroup (entidad).

7.4.2 PermissionCache invalidate
--------------------------------

Para todos los Users con el AGR ACTIVE
(cascade post-COMMIT).

7.4.3 AuditEvent
----------------

::

   event_type:
     ACCESS_GROUP_COMPOSITION_CHANGED
     (o COMPOSITION_FAILED)
   payload: {
     access_group_id, agr_code,
     functions_added: [...ids...],
     functions_removed: [...ids...],
     skipped_add: [...],
     skipped_remove: [...],
     change_reason,
     cascade_affected_user_count,
     cascade_violations_count,
     ip, user_agent}

7.5 FR derivados
================

15 FR aprox: validar auth + RBAC +
payload + AGR existe + custom + ACTIVE +
functions validas + idempotencia + cascade
SoD + atomic INSERT/DELETE + cache + audit
+ response.

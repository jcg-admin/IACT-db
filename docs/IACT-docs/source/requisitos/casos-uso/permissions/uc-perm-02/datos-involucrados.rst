.. _uc-perm-02-parte-07:

============================
Parte 7 — Datos involucrados
============================

7.1 Endpoints
=============

.. list-table::
 :widths: 35 25 40
 :header-rows: 1

 * - Endpoint
   - Metodo
   - RBAC
 * - ``/api/users/{id}/access-groups/{agr_id}/``
   - DELETE
   - ``revoke_function_groups``
 * - ``/api/users/{id}/access-groups/{agr_id}/preview-revoke/``
   - GET
   - ``revoke_function_groups``

7.2 Request DELETE
==================

.. code-block:: http

   DELETE /api/users/42/access-groups/6/ HTTP/1.1
   Host: iact.example.com
   Authorization: Bearer eyJhbGc...
   Content-Type: application/json

.. code-block:: json

   {
     "revoke_reason": "Cambio de rol",
     "notify_user": true
   }

7.3 Response 200 — exito
========================

.. code-block:: json

   {
     "target_user_id": 42,
     "username": "ana.gomez.0001",
     "access_group_id": 6,
     "access_group_code": "user_admin_group",
     "revoke_reason": "Cambio de rol",
     "functions_count_revoked": 8,
     "post_revoke_active_count": 2,
     "warnings": {
       "no_functions": false,
       "critical_revoked": [],
       "last_holder": []
     },
     "user_notified": true,
     "revoked_at": "2026-05-01T19:30:00Z"
   }

7.4 GET preview-revoke
======================

.. code-block:: json

   {
     "target_user_id": 42,
     "access_group_id": 6,
     "agr_total_functions": 8,
     "functions_count_to_revoke": 6,
     "functions_remaining_active": 2,
     "warnings": {
       "no_functions": false,
       "critical_revoked": [],
       "last_holder": [
         {"function_id": 7,
          "function_code": "configure_sod",
          "remaining_holders_after": 0}
       ]
     },
     "estimated_sod_violations_resolved": 0
   }

NO persiste.

7.5 Modelo de datos tocado
==========================

Identico a UC_ACC_02 sobre target_type=
'AccessGroup'. UPDATE Assignment ACTIVE →
REVOKED + metadata.

7.6 AuditEvent
==============

::

   event_type: AGR_REVOKED
   payload: {
     target_user_id, access_group_id,
     access_group_code,
     functions_count_revoked,
     revoke_reason,
     post_revoke_active_count,
     warnings,
     ip, user_agent}

7.7 FR derivados
================

Heredados de UC_ACC_02 + UI especificos:

- FR-PERM-02-A: GET preview-revoke
- FR-PERM-02-B: Modal composicion expandida
- FR-PERM-02-C: Doble confirmacion si
  warnings criticos
- FR-PERM-02-D: Refresh catalogo
  post-revocacion

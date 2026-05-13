.. _uc-perm-03-parte-07:

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
 * - ``/api/users/{id}/exceptional-permissions/``
   - POST
   - ``grant_exceptional_permission``
 * - ``/api/users/{id}/exceptional-permissions/preview/``
   - GET
   - ``grant_exceptional_permission``

7.2 Request POST
================

.. code-block:: json

   {
     "function_ids": [1, 5],
     "expires_at": "2026-05-15T23:59:59Z",
     "justification": "TKT-12345 Cobertura...",
     "ticket_reference": "TKT-12345"
   }

7.3 Response 201
================

Ver UC_ACC_08 Parte 7.3 — payload identico.

7.4 GET preview
===============

.. code-block:: json

   {
     "target_user_id": 42,
     "function_ids": [1, 5],
     "expires_at": "2026-05-15T23:59:59Z",
     "duration_days": 14,
     "estimated_sod_violations": 0,
     "warnings": []
   }

NO persiste.

7.5 Modelo de datos tocado
==========================

Identico a UC_ACC_08:

- ExceptionalPermission (INSERT N).
- InternalMessage (obligatorio).
- AuditEvent (high-priority).
- PermissionCache (invalidate post-COMMIT).

7.6 FR derivados
================

Heredados de UC_ACC_08 + UI:

- FR-PERM-03-A: GET preview sin persistir.
- FR-PERM-03-B: Modal con preview SoD +
  warning de high-priority audit.
- FR-PERM-03-C: Refresh catalogo funciones
  post-grant.

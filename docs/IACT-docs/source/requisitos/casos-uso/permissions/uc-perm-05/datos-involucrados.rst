.. _uc-perm-05-parte-07:

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
 * - ``/api/access-groups/``
   - POST
   - ``manage_access_groups``
 * - ``/api/access-groups/{id}/``
   - PATCH
   - ``manage_access_groups``
 * - ``/api/access-groups/{id}/``
   - DELETE
   - ``manage_access_groups``

(Lectura: ``GET`` cubierto por UC_PERM_01
catalogo y otros UCs de vista; no es scope
de UC_PERM_05.)

7.2 Crear — Request
===================

.. code-block:: json

   {
     "code": "soporte_n2_group",
     "display_name": "Soporte N2",
     "description": "Equipo de soporte
                     escalado nivel 2",
     "severity": "MEDIUM",
     "initial_function_ids": [10, 15, 20]
   }

``initial_function_ids`` opcional (FA-01).

7.3 Crear — Response 201
========================

.. code-block:: json

   {
     "id": 11,
     "code": "soporte_n2_group",
     "display_name": "Soporte N2",
     "description": "...",
     "severity": "MEDIUM",
     "is_predefined": false,
     "state": "ACTIVE",
     "function_count": 3,
     "users_count": 0,
     "created_at": "2026-05-01T19:55:00Z",
     "created_by_admin_id": 1
   }

7.4 PATCH — Request
===================

.. code-block:: json

   {
     "display_name": "Soporte Nivel 2",
     "description": "Texto actualizado",
     "severity": "HIGH"
   }

7.5 DELETE — Request
====================

.. code-block:: json

   {
     "retire_reason": "Reemplazado por
                       soporte_n2_group_v2"
   }

7.6 Modelo de datos tocado
==========================

7.6.1 AccessGroup
-----------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Notas
 * - id
   - BIGINT (PK)
   - autoincrement
 * - code
   - VARCHAR (UNIQUE)
   - inmutable post-create
 * - display_name
   - VARCHAR
   - mutable
 * - description
   - TEXT
   - mutable
 * - severity
   - ENUM
   - mutable
 * - is_predefined
   - BOOLEAN
   - false en customs
 * - state
   - ENUM
   - ACTIVE / RETIRED
 * - created_at
   - DATETIME
   - NOW() en create
 * - created_by_admin_id
   - BIGINT
   - invoker
 * - last_modified_at
   - DATETIME
   - PATCH update
 * - last_modified_by_admin_id
   - BIGINT
   - PATCH
 * - retired_at
   - DATETIME (null)
   - DELETE
 * - retired_by_admin_id
   - BIGINT (null)
   - DELETE
 * - retire_reason
   - VARCHAR (null)
   - DELETE

7.6.2 AuditEvent
----------------

::

   event_types: ACCESS_GROUP_CREATED,
                ACCESS_GROUP_MODIFIED,
                ACCESS_GROUP_RETIRED,
                ACCESS_GROUP_*_FAILED
   payload: {
     access_group_id, code, display_name,
     severity, fields_changed (en MODIFIED),
     retire_reason (en RETIRED),
     users_with_agr_count (en RETIRED),
     ip, user_agent}

7.7 FR derivados
================

12 FR aprox: validar auth + RBAC + payload
(code regex + duplicate + immutable
PATCH) + persistencia (INSERT/UPDATE) +
cache + audit + response.

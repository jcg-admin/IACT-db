.. _uc-acc-08-parte-07:

============================
Parte 7 — Datos involucrados
============================

7.1 Endpoint
============

POST
``/api/users/{user_id}/exceptional-permissions/``
con funcion ``grant_exceptional_permission``.

7.2 Request
===========

.. code-block:: json

   {
     "function_ids": [1, 5],
     "expires_at": "2026-05-15T23:59:59Z",
     "justification": "TKT-12345 - Cobertura
                       de licencia del admin
                       Juan hasta 2026-05-15",
     "ticket_reference": "TKT-12345"
   }

7.3 Response 201
================

.. code-block:: json

   {
     "target_user_id": 42,
     "username": "ana.gomez.0001",
     "granted": [
       {
         "permission_id": 510,
         "function_id": 1,
         "function_code": "view_users",
         "expires_at": "2026-05-15T23:59:59Z"
       }
     ],
     "skipped": [],
     "justification": "TKT-12345 ...",
     "ticket_reference": "TKT-12345",
     "user_notified": true,
     "sod_rules_evaluated": 5,
     "granted_at": "2026-05-01T18:40:00Z"
   }

7.4 Modelo de datos tocado
==========================

7.4.1 ExceptionalPermission (INSERT N)
--------------------------------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - id
   - BIGINT (PK)
   - autoincrement
 * - user_id
   - BIGINT (FK)
   - target.id
 * - function_id
   - BIGINT (FK)
   - cada elemento del payload
 * - state
   - ENUM
   - ACTIVE
 * - granted_at
   - DATETIME
   - NOW()
 * - granted_by_admin_id
   - BIGINT
   - invoker.id
 * - expires_at
   - DATETIME
   - payload.expires_at (REQUIRED)
 * - justification
   - TEXT
   - payload.justification (REQUIRED ≥ 20
     chars)
 * - ticket_reference
   - VARCHAR (nullable si politica
     opcional)
   - payload.ticket_reference

7.4.2 InternalMessage (INSERT obligatorio)
------------------------------------------

::

   subject: "Permiso temporal otorgado"
   body: detalle de funciones (display_names),
         expires_at, justification

7.4.3 AuditEvent
----------------

::

   event_type: EXCEPTIONAL_PERMISSION_GRANTED
   payload: {
     target_user_id, function_ids,
     expires_at, justification,
     ticket_reference, sod_rules_evaluated,
     ip, user_agent}

7.5 PermissionCache
===================

invalidate post-COMMIT.

7.6 Volumetria
==============

- Grants/mes: ~5-15 (excepcional).
- Pico durante incidentes: ~5/dia.
- Max simultaneos por User: politica =
  3 (no auditado por este UC, pero
  recomendable).

7.7 FR derivados — preliminar
=============================

15 FR derivados (auth + RBAC + payload
validation + funciones + idempotencia + SoD +
INSERT N + cache + mailbox + audit + response).

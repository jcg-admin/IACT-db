.. _uc-acc-09-parte-07:

============================
Parte 7 — Datos involucrados
============================

7.1 Endpoints
=============

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Endpoint
   - Metodo
   - RBAC
 * - ``/api/access/audit/``
   - GET
   - ``view_access_audit``
 * - ``/api/access/audit/{event_id}/``
   - GET
   - ``view_access_audit``
 * - ``/api/access/audit/aggregations/``
   - GET
   - ``view_access_audit``

7.2 Listado — Query params
==========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Param
   - Significado
 * - ``event_type``
   - filtro multi-select del catalogo
 * - ``actor_user_id``
   - quien emitio el evento
 * - ``target_user_id``
   - sobre quien (audit P-16 si especifico)
 * - ``includes_function_id``
   - filtro JSON contains
 * - ``occurred_after``
   - ISO datetime
 * - ``occurred_before``
   - ISO datetime
 * - ``ordering``
   - whitelist
 * - ``page``, ``page_size``
   - paginacion

7.3 Response listado
====================

.. code-block:: json

   {
     "count": 1450,
     "next": "...",
     "previous": null,
     "results": [
       {
         "id": "evt-...",
         "event_type": "FUNCTIONS_ASSIGNED",
         "occurred_at": "2026-05-01T...",
         "actor_user_id": 1,
         "actor_username": "admin",
         "target_user_id": 42,
         "target_username": "ana.gomez.0001",
         "summary": "Assigned 3 functions
                    via direct",
         "payload_preview": "{...}"
       }
     ]
   }

7.4 Response detalle
====================

Body con todos los campos del AuditEvent
(payload completo, ip, user_agent).

7.5 Response agregaciones
=========================

.. code-block:: json

   {
     "group_by": "event_type",
     "results": [
       {"event_type": "FUNCTIONS_ASSIGNED",
        "count": 850},
       {"event_type": "FUNCTIONS_REVOKED",
        "count": 210}
     ]
   }

7.6 Modelo de datos consultado
==============================

Solo lectura sobre ``AuditEvent``.

7.7 AuditEvent emitido (P-16)
=============================

::

   event_type: ACCESS_AUDIT_VIEWED (solo si
                target_user_id especifico)
   payload: {
     target_user_id, filters_summary,
     results_count, ip, user_agent}

7.8 ACCESS_EVENT_TYPES catalogo
===============================

::

   const ACCESS_EVENT_TYPES = [
     'FUNCTIONS_ASSIGNED',
     'FUNCTIONS_ASSIGN_NOOP',
     'FUNCTIONS_ASSIGN_FAILED',
     'FUNCTIONS_REVOKED',
     'FUNCTIONS_REVOKE_NOOP',
     'FUNCTIONS_REVOKE_FAILED',
     'AGR_ASSIGNED',
     'AGR_ASSIGN_NOOP',
     'AGR_ASSIGN_FAILED',
     'EFFECTIVE_PERMISSIONS_VIEWED',
     'SOD_RULE_CREATED',
     'SOD_RULE_MODIFIED',
     'SOD_RULE_RETIRED',
     'SOD_RULES_VIEWED',
     'EXCEPTIONAL_PERMISSION_GRANTED',
     'EXCEPTIONAL_PERMISSION_EXPIRED',
     'EXCEPTIONAL_PERMISSION_REVOKED',
     'UNAUTHORIZED_ACCESS_ATTEMPT'
       (filtrado por attempted_action que
        sea de MOD_Access)]

7.9 FR derivados — preliminar
=============================

10 FR aprox: validar auth, RBAC, filtros
whitelist, query con paginacion, JSON
contains, agregaciones, mascarado PII,
audit selectivo, response listado, response
detalle.

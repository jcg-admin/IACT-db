.. _uc-acc-03-parte-07:

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
 * - ``/api/users/{user_id}/effective-permissions/``
   - GET
   - ``view_assignments``
 * - ``/api/auth/me/permissions/``
   - GET
   - self (no requiere
     ``view_assignments``)

7.2 Request
===========

.. code-block:: http

   GET /api/users/42/effective-permissions/ HTTP/1.1
   Host: iact.example.com
   Authorization: Bearer eyJhbGc...

Sin body.

Query params opcionales:

- ``include_expired_pending=true`` (default)
- ``include_sod_check=true`` (default)

7.3 Response 200 — exito
========================

.. code-block:: json

   {
     "user_id": 42,
     "username": "ana.gomez.0001",
     "self_view": false,
     "effective_functions": [
       {
         "function_id": 1,
         "function_code": "view_users",
         "display_name": "Ver usuarios",
         "sources": [
           {
             "type": "direct",
             "assignment_id": 1023,
             "expires_at": null
           },
           {
             "type": "via_agr",
             "agr_id": 6,
             "agr_code": "user_admin_group"
           }
         ]
       }
     ],
     "via_direct_count": 5,
     "via_agr_count": 12,
     "via_exceptional_count": 1,
     "effective_total_count": 14,
     "expired_pending_purge": [
       {
         "function_id": 99,
         "assignment_id": 850,
         "expired_at": "2026-04-15T00:00:00Z"
       }
     ],
     "sod_violations_detected": [
       {
         "rule_id": "sod-001",
         "rule_name": "Admin no auditor",
         "conflict_pair": [
           {"function_id":1,"code":"modify_users"},
           {"function_id":42,"code":"audit_users"}
         ]
       }
     ]
   }

7.4 Modelo de datos consultado
==============================

7.4.1 Assignment (lectura)
--------------------------

Filtro: ``user_id=target``,
``state='ACTIVE'``.

7.4.2 AccessGroup + AccessGroupFunction (lectura)
-------------------------------------------------

Para cada AGR del User (Assignment cuyo target
es un AGR), obtener lista de funciones del
AGR via tabla pivote
``access_group_function``.

7.4.3 ExceptionalPermission (lectura)
-------------------------------------

Filtro: ``user_id=target``,
``state='ACTIVE'``,
``expires_at > NOW() OR expires_at IS NULL``.

7.4.4 SoDRule (lectura — para violations check)
-----------------------------------------------

Filtro: ``state='ACTIVE'``.

7.5 AuditEvent (escritura — INSERT P-16)
========================================

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Campo
   - Valor
 * - event_type
   - ``EFFECTIVE_PERMISSIONS_VIEWED``
 * - actor_user_id
   - invoker.id
 * - occurred_at
   - NOW()
 * - payload
   - ``{target_user_id,
     self_view,
     effective_count,
     via_direct_count,
     via_agr_count,
     via_exceptional_count,
     expired_pending_count,
     sod_violations_count,
     ip, user_agent}``

7.6 Volumetria estimada
=======================

.. list-table::
 :widths: 35 65
 :header-rows: 0

 * - **Consultas/dia**
   - ~50-200 (alta — operacion frecuente)
 * - **Pico**
   - ~30/min en investigacion / triage
 * - **Tamano response (User tipico)**
   - ~5-10 KB

7.7 FR derivados (Nivel 4) — preliminar
=======================================

.. list-table::
 :widths: 20 20 60
 :header-rows: 1

 * - FR ID
   - Paso UC
   - Capacidad
 * - FR-ACC-03-01
   - 3
   - Validar JWT
 * - FR-ACC-03-02
   - 4
   - Verificar view_assignments o self-view
 * - FR-ACC-03-03
   - 5
   - Localizar User destino
 * - FR-ACC-03-04
   - 6
   - Cargar Assignments directos ACTIVE
 * - FR-ACC-03-05
   - 7-8
   - Expandir AGRs en sus funciones
 * - FR-ACC-03-06
   - 9
   - Cargar ExceptionalPermissions ACTIVE
 * - FR-ACC-03-07
   - 10
   - Consolidar (deduplicar + metadata)
 * - FR-ACC-03-08
   - 11
   - Detectar expirados pendientes purga
 * - FR-ACC-03-09
   - 12
   - Detectar SoD violations informativas
 * - FR-ACC-03-10
   - 13
   - Audit selectivo (P-16)
 * - FR-ACC-03-11
   - 14
   - Construir response consolidada

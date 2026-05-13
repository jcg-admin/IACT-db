.. _uc-acc-04-parte-07:

============================
Parte 7 — Datos involucrados
============================

7.1 Endpoint
============

POST ``/api/users/{user_id}/access-groups/``
con funcion ``assign_function_groups``.

7.2 Request
===========

.. code-block:: json

   {
     "access_group_id": 6,
     "expires_at": "2026-12-31T23:59:59Z"
   }

7.3 Response 201 — exito
========================

.. code-block:: json

   {
     "target_user_id": 42,
     "username": "ana.gomez.0001",
     "access_group_id": 6,
     "access_group_code": "user_admin_group",
     "access_group_type": "predefined",
     "assignment_id": 1024,
     "expires_at": "2026-12-31T23:59:59Z",
     "agr_total_functions": 8,
     "functions_count_added": 6,
     "functions_already_present_count": 2,
     "sod_rules_evaluated": 5,
     "user_notified": true,
     "assigned_at": "2026-05-01T18:25:00Z"
   }

``functions_count_added`` cuenta SOLO las que
no estaban directas. ``functions_already_present_count``
las que el User ya tenia directas (no
duplicadas en el efectivo, pero si presentes
como source adicional).

7.4 Response idempotente (FA-01)
================================

.. code-block:: json

   {
     "target_user_id": 42,
     "access_group_id": 6,
     "already_assigned": true,
     "original_granted_at": "2026-04-15T10:00:00Z",
     "message": "AGR ya estaba asignado"
   }

7.5 Modelo de datos tocado
==========================

7.5.1 Assignment (escritura — INSERT)
-------------------------------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - user_id
   - BIGINT
   - target.id
 * - target_type
   - ENUM
   - ``'AccessGroup'``
 * - target_id
   - BIGINT
   - access_group_id
 * - state
   - ENUM
   - ``ACTIVE``
 * - granted_at
   - DATETIME
   - NOW()
 * - granted_by_admin_id
   - BIGINT
   - invoker.id
 * - expires_at
   - DATETIME (nullable)
   - payload.expires_at o NULL

UNIQUE constraint:
``(user_id, target_type, target_id, state)
WHERE state='ACTIVE'`` impide duplicados.

7.5.2 PermissionCache (invalidate)
----------------------------------

post-COMMIT.

7.5.3 AuditEvent (INSERT)
-------------------------

::

   event_type: AGR_ASSIGNED
   actor: invoker.id
   payload: {
     target_user_id,
     access_group_id, access_group_code,
     access_group_type,
     agr_total_functions,
     functions_count_added,
     functions_already_present_count,
     expires_at, sod_rules_evaluated,
     ip, user_agent}

7.5.4 InternalMessage (opcional)
--------------------------------

Body con AGR display_name y lista de
functions (display_names — NO IDs).

7.6 Datos solo de lectura
=========================

- ``User`` (target).
- ``AccessGroup``: existencia + state.
- ``AccessGroupFunction`` (pivote): funciones
  contenidas.
- ``Assignment`` actual del User
  (incluyendo otros AGRs y funciones
  directas — para SoD evaluation).
- ``SoDRule`` ACTIVE.

7.7 FR derivados (Nivel 4) — preliminar
=======================================

.. list-table::
 :widths: 20 20 60
 :header-rows: 1

 * - FR ID
   - Paso UC
   - Capacidad
 * - FR-ACC-04-01
   - 5
   - Validar JWT
 * - FR-ACC-04-02
   - 6
   - Verificar assign_function_groups
 * - FR-ACC-04-03
   - 7
   - Localizar User destino
 * - FR-ACC-04-04
   - 8
   - P-11 anti-self
 * - FR-ACC-04-05
   - 9
   - Validar AGR existe + ACTIVE
 * - FR-ACC-04-06
   - 10
   - Idempotencia check
 * - FR-ACC-04-07
   - 11
   - Expandir AGR funciones
 * - FR-ACC-04-08
   - 12
   - SoD validate write-time
 * - FR-ACC-04-09
   - 13
   - INSERT Assignment AGR
 * - FR-ACC-04-10
   - 14
   - Cache invalidate post-COMMIT
 * - FR-ACC-04-11
   - 15
   - INSERT AuditEvent AGR_ASSIGNED
 * - FR-ACC-04-12
   - 16
   - InternalMessage opcional
 * - FR-ACC-04-13
   - 17
   - Construir response con resumen

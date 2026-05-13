.. _uc-acc-01-parte-07:

============================
Parte 7 — Datos involucrados
============================

7.1 Endpoint
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Metodo**
   - POST
 * - **Path**
   - ``/api/users/{user_id}/functions/``
 * - **Auth**
   - JWT del invocante
 * - **RBAC**
   - funcion ``assign_functions``
 * - **Idempotente**
   - parcialmente (FA-01, FA-03)

7.2 Request
===========

.. code-block:: http

   POST /api/users/42/functions/ HTTP/1.1
   Host: iact.example.com
   Authorization: Bearer eyJhbGc...
   Content-Type: application/json

.. code-block:: json

   {
     "function_ids": [1, 2, 3],
     "expires_at": "2026-12-31T23:59:59Z"
   }

``expires_at`` opcional. Si se omite, el
Assignment es permanente (hasta revocacion
explicita via UC_ACC_02 o eliminacion del User
via UC_USR_04).

7.3 Response 201 — exito
========================

.. code-block:: json

   {
     "target_user_id": 42,
     "username": "ana.gomez.0001",
     "assigned": [
       {
         "function_id": 1,
         "function_code": "view_users",
         "expires_at": "2026-12-31T23:59:59Z"
       },
       {
         "function_id": 3,
         "function_code": "list_users",
         "expires_at": "2026-12-31T23:59:59Z"
       }
     ],
     "skipped": [
       {
         "function_id": 2,
         "function_code": "modify_users",
         "reason": "already_active"
       }
     ],
     "sod_rules_evaluated": 5,
     "user_notified": true,
     "assigned_at": "2026-05-01T17:30:00Z"
   }

7.4 Response — errores
======================

.. list-table::
 :widths: 20 30 50
 :header-rows: 1

 * - Status
   - Excepcion
   - Body code
 * - 400
   - VALIDATION_ERROR / INVALID_USER_STATE /
     SELF_ASSIGN_FORBIDDEN /
     FUNCTION_NOT_FOUND / FUNCTION_INACTIVE
   - segun excepcion (Parte 5)
 * - 401
   - INVALID_TOKEN
   - middleware estandar
 * - 403
   - FORBIDDEN
   - sin ``assign_functions``
 * - 404
   - USER_NOT_FOUND
   - target inexistente
 * - 409
   - SOD_VIOLATION
   - con detalle rule_id + conflict_pair
 * - 429
   - RATE_LIMIT
   - throttle
 * - 500
   - AUDIT_FAILED
   - audit fail (rollback)
 * - 503
   - DB_TIMEOUT
   - retry safe

7.5 Modelo de datos tocado
==========================

7.5.1 Assignment (escritura — INSERT N filas)
---------------------------------------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - id
   - BIGINT (PK auto)
   - autoincrement
 * - user_id
   - BIGINT (FK)
   - target.id
 * - function_id
   - BIGINT (FK)
   - cada elemento de payload.function_ids
 * - state
   - ENUM
   - ``ACTIVE``
 * - granted_at
   - DATETIME
   - ``NOW()``
 * - granted_by_admin_id
   - BIGINT (FK)
   - invoker.id
 * - expires_at
   - DATETIME (nullable)
   - payload.expires_at o NULL
 * - revoked_at
   - DATETIME (nullable)
   - NULL
 * - revoked_by_admin_id
   - BIGINT (nullable)
   - NULL
 * - revoke_reason
   - VARCHAR (nullable)
   - NULL

UNIQUE constraint:
``(user_id, function_id, state) WHERE
state='ACTIVE'`` — impide duplicados activos.
Permite multiples REVOKED historicos.

7.5.2 PermissionCache (escritura — DELETE/INVALIDATE)
-----------------------------------------------------

Implementacion-dependiente (Redis, Memcached,
in-memory). El UC delega a
``PermissionCache.invalidate(user_id)``.

7.5.3 AuditEvent (escritura — INSERT)
-------------------------------------

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Campo
   - Valor
 * - event_type
   - ``FUNCTIONS_ASSIGNED`` (o
     ``FUNCTIONS_ASSIGN_NOOP`` en FA-01,
     ``FUNCTIONS_ASSIGN_FAILED`` en
     excepciones)
 * - actor_user_id
   - invoker.id
 * - occurred_at
   - NOW()
 * - payload
   - ``{target_user_id,
     function_ids_assigned,
     function_ids_skipped,
     expires_at, ip, user_agent,
     sod_rules_evaluated_count}``

7.5.4 InternalMessage (escritura — INSERT opcional)
---------------------------------------------------

Si politica ``NOTIFY_USER_ON_ASSIGN=true``:

.. code-block:: json

   {
     "recipient_user_id": 42,
     "subject": "Nuevas capacidades en tu cuenta",
     "body": "Se te asignaron N capacidades:
              {function_display_names}.
              Vigentes hasta: {expires_at}."
   }

7.5.5 Datos solo de lectura
---------------------------

- ``User`` (target): para validar estado.
- ``Function``: para validar existencia y
  estado activo.
- ``SoDRule`` (state=ACTIVE): para validacion
  PASO 10.
- ``Assignment`` actuales del User: para
  filtrado idempotente (PASO 9) y evaluacion
  del conjunto efectivo SoD (PASO 10).

7.6 Volumetria estimada
=======================

.. list-table::
 :widths: 35 65
 :header-rows: 0

 * - **Asignaciones/dia**
   - ~10-30 (operacion administrativa
     habitual)
 * - **Pico (onboarding masivo)**
   - ~100/min
 * - **Funciones/asignacion (mediana)**
   - 1-3
 * - **AuditEvent size**
   - ~400-800 bytes (depende de
     function_ids count)

7.7 Indices recomendados
========================

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - Tabla
   - Indice
 * - assignment
   - ``(user_id, state)``
 * - assignment
   - ``(function_id, state)``
 * - assignment
   - ``(state, expires_at)`` — para cron de
     expiracion
 * - assignment
   - UNIQUE
     ``(user_id, function_id, state)``
     WHERE state='ACTIVE'
 * - sod_rule
   - ``(state, rule_type)``

7.8 FR derivados (Nivel 4) — preliminar
=======================================

.. list-table::
 :widths: 20 20 60
 :header-rows: 1

 * - FR ID
   - Paso UC
   - Capacidad
 * - FR-ACC-01-01
   - 5
   - Validar JWT
 * - FR-ACC-01-02
   - 6
   - Verificar funcion assign_functions
 * - FR-ACC-01-03
   - 7
   - Localizar User destino con
     select_for_update
 * - FR-ACC-01-04
   - 7
   - Validar state target ∈ {ACTIVE, INACTIVE}
 * - FR-ACC-01-05
   - 7
   - Validar P-11 anti-self-assignment
 * - FR-ACC-01-06
   - 8
   - Validar cada function_id existe y ACTIVE
 * - FR-ACC-01-07
   - 9
   - Filtrar idempotente (excluir activas)
 * - FR-ACC-01-08
   - 10
   - Construir effective_function_set
 * - FR-ACC-01-09
   - 10
   - Evaluar SoDRules contra effective_set
 * - FR-ACC-01-10
   - 10
   - Bloquear con detalle si SoD viola
 * - FR-ACC-01-11
   - 11
   - INSERT N Assignments con metadata
 * - FR-ACC-01-12
   - 12
   - Invalidar cache de permisos
 * - FR-ACC-01-13
   - 13
   - INSERT AuditEvent FUNCTIONS_ASSIGNED
 * - FR-ACC-01-14
   - 14
   - INSERT InternalMessage opcional
 * - FR-ACC-01-15
   - 15
   - Construir response con assigned/skipped

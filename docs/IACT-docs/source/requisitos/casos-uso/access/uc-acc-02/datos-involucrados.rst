.. _uc-acc-02-parte-07:

============================
Parte 7 — Datos involucrados
============================

7.1 Endpoint
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Metodo**
   - DELETE
 * - **Path**
   - ``/api/users/{user_id}/functions/``
 * - **Auth**
   - JWT del invocante
 * - **RBAC**
   - funcion ``revoke_functions``
 * - **Idempotente**
   - SI

7.2 Request
===========

.. code-block:: http

   DELETE /api/users/42/functions/ HTTP/1.1
   Host: iact.example.com
   Authorization: Bearer eyJhbGc...
   Content-Type: application/json

.. code-block:: json

   {
     "function_ids": [1, 2, 3],
     "revoke_reason": "Cambio de rol",
     "notify_user": true
   }

``revoke_reason`` obligatorio. ``notify_user``
opcional (default segun politica).

7.3 Response 200 — exito
========================

.. code-block:: json

   {
     "target_user_id": 42,
     "username": "ana.gomez.0001",
     "revoked": [
       {
         "function_id": 1,
         "function_code": "view_users",
         "previous_assignment_id": 1023
       }
     ],
     "skipped": [
       {
         "function_id": 2,
         "function_code": "modify_users",
         "reason": "not_active"
       }
     ],
     "revoke_reason": "Cambio de rol",
     "post_revoke_active_count": 5,
     "warnings": {
       "no_functions": false,
       "critical_revoked": [],
       "last_holder": []
     },
     "user_notified": true,
     "revoked_at": "2026-05-01T18:10:00Z"
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
   - VALIDATION_ERROR /
     SELF_REVOKE_FORBIDDEN /
     INVALID_USER_STATE
   - segun excepcion
 * - 401
   - INVALID_TOKEN
   - middleware
 * - 403
   - FORBIDDEN
   - sin ``revoke_functions``
 * - 404
   - USER_NOT_FOUND
   - target inexistente
 * - 409
   - LAST_HOLDER_PROTECTION
   - solo si politica strict
 * - 429
   - RATE_LIMIT
   - throttle
 * - 500
   - AUDIT_FAILED
   - rollback
 * - 503
   - DB_TIMEOUT
   - retry safe

7.5 Modelo de datos tocado
==========================

7.5.1 Assignment (escritura — UPDATE masivo)
--------------------------------------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Cambio
 * - state
   - ENUM
   - ``ACTIVE → REVOKED``
 * - revoked_at
   - DATETIME
   - ``NOW()``
 * - revoked_by_admin_id
   - BIGINT (FK)
   - invoker.id
 * - revoke_reason
   - VARCHAR
   - payload.revoke_reason

NO se modifica: ``granted_at``,
``granted_by_admin_id``, ``expires_at``
(historial preservado).

7.5.2 PermissionCache (invalidate)
----------------------------------

``invalidate(user_id)`` post-COMMIT.

7.5.3 AuditEvent (escritura — INSERT)
-------------------------------------

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Campo
   - Valor
 * - event_type
   - ``FUNCTIONS_REVOKED`` (o NOOP en FA-01,
     FAILED en excepciones)
 * - actor_user_id
   - invoker.id
 * - occurred_at
   - NOW()
 * - payload
   - ``{target_user_id,
     function_ids_revoked,
     function_ids_skipped,
     revoke_reason,
     post_revoke_active_count,
     warnings,
     ip, user_agent}``

7.5.4 InternalMessage (escritura — INSERT opcional)
---------------------------------------------------

Si politica notify activa o
``payload.notify_user=true``:

.. code-block:: json

   {
     "recipient_user_id": 42,
     "subject": "Capacidades revocadas",
     "body": "Se te revocaron N capacidades:
              {function_display_names}.
              Motivo: {revoke_reason}."
   }

7.5.5 Datos solo de lectura
---------------------------

- ``User`` (target): para validar estado.
- ``Assignment`` ACTIVE: para localizar
  matches.
- ``Function``: para display_names en
  notificacion y critical-check.
- ``CRITICAL_FUNCTIONS`` (config): lista de
  funciones marcadas como criticas para
  warnings.

7.6 Volumetria estimada
=======================

.. list-table::
 :widths: 35 65
 :header-rows: 0

 * - **Revocaciones/dia**
   - ~5-15 (operacion administrativa
     selectiva)
 * - **Pico (compliance review)**
   - ~50/min
 * - **Funciones/revocacion (mediana)**
   - 1-2

7.7 FR derivados (Nivel 4) — preliminar
=======================================

.. list-table::
 :widths: 20 20 60
 :header-rows: 1

 * - FR ID
   - Paso UC
   - Capacidad
 * - FR-ACC-02-01
   - 5
   - Validar JWT
 * - FR-ACC-02-02
   - 6
   - Verificar funcion revoke_functions
 * - FR-ACC-02-03
   - 7
   - Localizar User destino
 * - FR-ACC-02-04
   - 7
   - Validar state (no ELIMINATED)
 * - FR-ACC-02-05
   - 8
   - Validar P-11 anti-self-revoke
 * - FR-ACC-02-06
   - 9
   - Listar Assignments ACTIVE matching
 * - FR-ACC-02-07
   - 10
   - Filtrar idempotente (ya REVOKED)
 * - FR-ACC-02-08
   - 11
   - Calcular post-revoke + warnings
 * - FR-ACC-02-09
   - 12
   - UPDATE Assignments to REVOKED + metadata
 * - FR-ACC-02-10
   - 13
   - Cache invalidate post-COMMIT
 * - FR-ACC-02-11
   - 14
   - INSERT AuditEvent FUNCTIONS_REVOKED
 * - FR-ACC-02-12
   - 15
   - INSERT InternalMessage opcional
 * - FR-ACC-02-13
   - 16
   - Construir response con warnings

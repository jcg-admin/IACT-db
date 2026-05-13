.. _uc-usr-03-parte-07:

============================
Parte 7 — Datos involucrados
============================

7.1 Endpoint
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Metodo**
   - PATCH (parcial — RFC 5789)
 * - **Path**
   - ``/api/users/{user_id}/``
 * - **Auth**
   - JWT del admin
 * - **RBAC**
   - ``modify_users`` (AGR-006)
 * - **Idempotente**
   - SI (mismo payload → mismo estado)

7.2 Request
===========

.. code-block:: http

   PATCH /api/users/42/ HTTP/1.1
   Host: iact.example.com
   Authorization: Bearer eyJhbGc...
   Content-Type: application/json

.. code-block:: json

   {
     "first_name": "Ana Maria",
     "state": "BLOCKED",
     "segment_id": 3
   }

Solo se incluyen campos a modificar (PATCH
parcial). Campos NO permitidos:
``username``, ``password_hash``,
``access_groups``, ``id``, ``created_at``.

7.3 Response 200 — exito
========================

.. code-block:: json

   {
     "user_id": 42,
     "username": "ana.gomez.0001",
     "fields_changed": ["first_name", "state",
                        "segment_id"],
     "state_transition": {
       "from": "ACTIVE", "to": "BLOCKED"
     },
     "sessions_closed": 2,
     "user_notified": true,
     "modified_at": "2026-05-01T16:55:00Z"
   }

Si state NO cambio, ``state_transition`` es
``null`` y ``sessions_closed`` es ``0``.

7.4 Response — errores
======================

.. list-table::
 :widths: 20 30 50
 :header-rows: 1

 * - Status
   - Excepcion
   - Body code
 * - 400
   - VALIDATION_ERROR / SELF_STATE_CHANGE_FORBIDDEN
     / INVALID_STATE_TRANSITION
   - segun excepcion (Parte 5)
 * - 401
   - INVALID_TOKEN
   - middleware estandar
 * - 403
   - FORBIDDEN (sin ``modify_users``)
   - AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT
     emitido
 * - 404
   - USER_NOT_FOUND
   - target inexistente
 * - 409
   - EMAIL_EXISTS
   - email duplicado
 * - 429
   - RATE_LIMIT
   - throttle
 * - 503
   - DB_TIMEOUT
   - operacion idempotente, retry safe

7.5 Modelo de datos tocado
==========================

7.5.1 User (escritura — UPDATE)
-------------------------------

Campos modificables segun PATCH:

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Notas
 * - first_name
   - VARCHAR(50)
   - libre
 * - last_name
   - VARCHAR(50)
   - libre
 * - email
   - VARCHAR (UNIQUE)
   - validar unicidad si cambia
 * - state
   - ENUM
   - solo transiciones permitidas
 * - segment_id
   - BIGINT (FK)
   - CNST-008

Campos modificados de auditoria internos:

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - last_modified_at
   - DATETIME
   - ``NOW()``
 * - last_modified_by_admin_id
   - BIGINT (FK)
   - admin.id
 * - state_changed_at
   - DATETIME
   - ``NOW()`` solo si state cambia

7.5.2 Session (escritura masiva — opcional)
-------------------------------------------

Solo si state → BLOCKED. UPDATE de Sessions
ACTIVE del User a CLOSED:

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Cambio
 * - state
   - VARCHAR
   - ``ACTIVE → CLOSED``
 * - close_reason
   - VARCHAR
   - ``ADMIN_BLOCKED``
 * - closed_at
   - DATETIME
   - ``NOW()``
 * - closed_by_admin_id
   - BIGINT
   - admin.id

7.5.3 BlacklistedToken (escritura — INSERT N)
---------------------------------------------

Por cada Session cerrada, sus tokens activos
van al blacklist con ``expires_at`` original.

7.5.4 InternalMessage (escritura — INSERT opcional)
---------------------------------------------------

Solo si state cambio Y politica
``NOTIFY_USER_ON_MODIFY`` activa:

.. code-block:: json

   {
     "recipient": "User modificado",
     "subject": "Tu cuenta fue actualizada",
     "body": "Un administrador modifico tu
              cuenta. Estado actual: {state}.
              Si no reconoces este cambio,
              contacta a soporte."
   }

7.5.5 AuditEvent (escritura — INSERT append-only)
-------------------------------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - event_type
   - VARCHAR
   - ``USER_MODIFIED``
     (o USER_MODIFY_FAILED,
     UNAUTHORIZED_ACCESS_ATTEMPT)
 * - actor_user_id
   - BIGINT
   - admin.id
 * - occurred_at
   - DATETIME
   - ``NOW()``
 * - payload
   - JSON
   - ``{target_user_id, fields_changed,
     state_transition?, segment_transition?,
     ip, user_agent,
     sessions_closed_count}``

7.6 Datos NO tocados
====================

- ``username`` — CNST-029 inmutable.
- ``password_hash`` — UC_AUTH_03 / UC_AUTH_04.
- ``Assignment`` (AGRs) — UC_ACC_*.
- ``PasswordHistory``.

7.7 Volumetria estimada
=======================

.. list-table::
 :widths: 35 65
 :header-rows: 0

 * - **Modificaciones/dia**
   - ~10-30 (cambios organizacionales,
     ausencias, suspensiones)
 * - **Pico (revision masiva)**
   - ~50/min
 * - **AuditEvent size**
   - ~250-400 bytes (depende de
     fields_changed)
 * - **InternalMessage size**
   - ~300 bytes

7.8 FR derivados (Nivel 4) — preliminar
=======================================

.. list-table::
 :widths: 20 20 60
 :header-rows: 1

 * - FR ID
   - Paso UC
   - Capacidad
 * - FR-USR-03-01
   - 4
   - Validar JWT del admin
 * - FR-USR-03-02
   - 4
   - Verificar funcion modify_users
 * - FR-USR-03-03
   - 5
   - Localizar User destino
 * - FR-USR-03-04
   - 6
   - Validar transicion de state permitida
 * - FR-USR-03-05
   - 6
   - Validar P-11 anti-self-state-change
 * - FR-USR-03-06
   - 7
   - Validar email unico si cambia
 * - FR-USR-03-07
   - 7
   - Validar formato campos modificados
 * - FR-USR-03-08
   - 8
   - UPDATE User parcial
 * - FR-USR-03-09
   - 9
   - Cerrar Sessions ACTIVE si state→BLOCKED
 * - FR-USR-03-10
   - 9
   - Blacklistear tokens de Sessions cerradas
 * - FR-USR-03-11
   - 10
   - INSERT AuditEvent USER_MODIFIED
 * - FR-USR-03-12
   - 11
   - INSERT InternalMessage si politica
     activa
 * - FR-USR-03-13
   - 12
   - Construir response con fields_changed
 * - FR-USR-03-14
   - 13
   - Frontend muestra resumen sin password

Generacion detallada queda como WP futuro
(per DEC-10 del WP de mapeo).

.. _uc-usr-01-parte-07:

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
   - ``/api/users/``
 * - **Auth**
   - JWT del admin
 * - **RBAC**
   - ``create_users`` (AGR-006)
 * - **Idempotente**
   - NO

7.2 Request
===========

.. code-block:: http

   POST /api/users/ HTTP/1.1
   Host: iact.example.com
   Authorization: Bearer eyJhbGc...
   Content-Type: application/json

.. code-block:: json

   {
     "first_name": "Ana",
     "last_name": "Gomez",
     "email": "ana.gomez@empresa.com",
     "access_group_id": 6
   }

``access_group_id`` opcional (FA-01 si se omite).

7.3 Response
============

7.3.1 201 Created (sin contrasena)
----------------------------------

.. code-block:: json

   {
     "user_id": 142,
     "username": "ana.gomez.0001",
     "email": "ana.gomez@empresa.com",
     "state": "ACTIVE",
     "first_login": true,
     "created_at": "2026-05-01T16:45:00Z",
     "access_group_id": 6,
     "notification_sent": true
   }

**Critico**: la contrasena temporal NO aparece.

7.3.2 400 / 401 / 403 / 409 / 500 / 503
---------------------------------------

Forma estandar CNST-013 (ver Parte 5
Excepciones).

7.4 Modelo de datos tocado
==========================

7.4.1 User (escritura — INSERT)
-------------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - id
   - BIGINT (PK auto)
   - autoincrement
 * - username
   - VARCHAR (UNIQUE)
   - generado per CNST-029
 * - email
   - VARCHAR (UNIQUE)
   - input
 * - first_name
   - VARCHAR
   - input
 * - last_name
   - VARCHAR
   - input
 * - password_hash
   - VARCHAR(60)
   - bcrypt(temp)
 * - state
   - VARCHAR
   - ``ACTIVE``
 * - first_login
   - BOOLEAN
   - ``True``
 * - password_changed_at
   - DATETIME
   - ``NOW()``
 * - created_by_admin_id
   - BIGINT (FK)
   - ``admin.id``
 * - created_at
   - DATETIME
   - ``NOW()``

7.4.2 Assignment (escritura — INSERT, opcional)
-----------------------------------------------

Si ``access_group_id`` provisto y FA-01 NO
aplica:

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - user_id
   - BIGINT (FK)
   - new_user.id
 * - access_group_id
   - BIGINT (FK)
   - input
 * - state
   - VARCHAR
   - ``ACTIVE``
 * - granted_at
   - DATETIME
   - ``NOW()``
 * - granted_by_admin_id
   - BIGINT (FK)
   - ``admin.id``

7.4.3 InternalMessage (escritura — INSERT)
------------------------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - recipient_user_id
   - BIGINT (FK)
   - new_user.id
 * - sender_user_id
   - BIGINT (FK NULL)
   - NULL (mensaje sistema)
 * - subject
   - VARCHAR
   - "Bienvenido a IACT — Credenciales"
 * - body
   - TEXT
   - "Tu cuenta IACT... Usuario: {username}.
     Contrasena temporal: {temp}..."
 * - created_at
   - DATETIME
   - ``NOW()``
 * - read_at
   - DATETIME (NULL)
   - NULL

7.4.4 AuditEvent (escritura — INSERT append-only)
-------------------------------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - event_type
   - VARCHAR
   - ``USER_CREATED``
 * - actor_user_id
   - BIGINT
   - admin.id
 * - occurred_at
   - DATETIME
   - ``NOW()``
 * - payload
   - JSON
   - ``{target_user_id, access_group_id,
     ip, user_agent, has_initial_agr,
     username_retries}``

7.5 Datos NO tocados
====================

- ``Session`` (UC_AUTH_01 lo creara al primer
  login).
- ``BlacklistedToken`` (no aplica).
- ``PasswordHistory`` (UC_AUTH_04 lo creara al
  primer cambio).

7.6 Volumetria estimada
=======================

.. list-table::
 :widths: 35 65
 :header-rows: 0

 * - **Creaciones/dia**
   - ~2-5 (caso esporadico)
 * - **Pico/min (onboarding masivo)**
   - ~30
 * - **Tamano AuditEvent**
   - ~250 bytes
 * - **Tamano InternalMessage**
   - ~400 bytes (subject + body con creds)

7.7 FR derivados (Nivel 4)
==========================

Por cada paso "Sistema [verbo]" del flujo
principal (PASOS 5-13), se deriva 1+ FR per
``proc-req-009-generacion-fr`` y FND_06
(derivacion no transformacion). Lista
preliminar:

.. list-table::
 :widths: 20 20 60
 :header-rows: 1

 * - FR ID
   - Paso UC
   - Capacidad
 * - FR-USR-01-01
   - 5
   - Validar JWT del admin
 * - FR-USR-01-02
   - 5
   - Verificar funcion create_users
 * - FR-USR-01-03
   - 6
   - Validar formato email
 * - FR-USR-01-04
   - 6
   - Verificar email unico
 * - FR-USR-01-05
   - 7
   - Generar username CNST-029
 * - FR-USR-01-06
   - 8
   - Generar password temporal seguro
 * - FR-USR-01-07
   - 9
   - Hashear bcrypt cost 12
 * - FR-USR-01-08
   - 10
   - INSERT User
 * - FR-USR-01-09
   - 11
   - INSERT Assignment opcional
 * - FR-USR-01-10
   - 12
   - INSERT InternalMessage con creds
 * - FR-USR-01-11
   - 13
   - INSERT AuditEvent USER_CREATED
 * - FR-USR-01-12
   - 14
   - Construir response sin password

Generacion detallada de cada FR queda como WP
futuro per DEC-10 del WP de mapeo metodologico.

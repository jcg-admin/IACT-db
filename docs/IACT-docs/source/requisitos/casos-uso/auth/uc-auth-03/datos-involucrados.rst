.. _uc-auth-03-parte-07:

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
   - ``/api/users/{user_id}/reset-password/``
 * - **Auth**
   - JWT del admin
 * - **RBAC**
   - Funcion ``reset_password`` (AGR-006)
 * - **Idempotente**
   - NO

7.2 Request
===========

.. code-block:: http

   POST /api/users/42/reset-password/ HTTP/1.1
   Host: iact.example.com
   Authorization: Bearer eyJhbGc...
   Content-Type: application/json

Body vacio (la accion no requiere parametros).

7.3 Response
============

7.3.1 200 OK
------------

.. code-block:: json

   {
     "message": "Contrasena reseteada. Notificacion enviada al buzon del usuario.",
     "target_user_id": 42,
     "reset_at": "2026-05-01T07:55:14Z",
     "sessions_closed": 2
   }

**Critico**: la contrasena temporal NO aparece
en ningun campo de la response.

7.3.2 401 (EX-01)
-----------------

``{"error": "INVALID_TOKEN", ...}``

7.3.3 403 (EX-02)
-----------------

``{"error": "FORBIDDEN", "message": "Sin permisos
para resetear contrasenas"}``

7.3.4 404 (EX-03)
-----------------

``{"error": "USER_NOT_FOUND", ...}``

7.3.5 400 (EX-04, EX-05)
------------------------

``{"error": "SELF_RESET_FORBIDDEN", ...}`` o
``{"error": "USER_ELIMINATED", ...}``

7.3.6 429 (EX-08)
-----------------

``{"error": "RATE_LIMIT", "retry_after": 300}``

7.3.7 500/503 (EX-06, EX-07, EX-09)
-----------------------------------

``{"error": "DB_TIMEOUT", ...}`` /
``{"error": "MAILBOX_FAILED", ...}``

7.4 Modelo de datos tocado
==========================

7.4.1 User (escritura)
----------------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Cambio
 * - password_hash
   - VARCHAR(60)
   - reemplazado con bcrypt(temp_password)
 * - first_login
   - BOOLEAN
   - ``false → true`` (o permanece true en FA-02)
 * - password_changed_at
   - DATETIME
   - ``NOW()``

NO se modifica: ``state`` (excepto si admin
explicitamente lo cambia en otro UC),
``email``, ``username``, ``access_groups``.

7.4.2 Session (escritura masiva)
--------------------------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Cambio
 * - state
   - VARCHAR
   - ``ACTIVE → CLOSED`` (todas las del User)
 * - close_reason
   - VARCHAR
   - ``NULL → PASSWORD_RESET``
 * - closed_at
   - DATETIME
   - ``NULL → NOW()``

7.4.3 BlacklistedToken (escritura — N inserts)
----------------------------------------------

Por cada Session cerrada en 7.4.2, sus tokens
JWT activos (access + refresh si conocido) van
al blacklist con ``expires_at`` original.

7.4.4 InternalMessage (escritura — INSERT)
------------------------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - recipient_user_id
   - BIGINT
   - id del User afectado
 * - sender_user_id
   - BIGINT (NULL)
   - NULL (mensaje de sistema), o admin.id
     segun politica
 * - subject
   - VARCHAR
   - "Contrasena temporal"
 * - body
   - TEXT
   - "Tu contrasena fue reseteada... Contrasena
     temporal: {temp}. ..."
 * - created_at
   - DATETIME
   - ``NOW()``
 * - read_at
   - DATETIME
   - ``NULL`` (se marca al leer)

7.4.5 AuditEvent (escritura — INSERT append-only)
-------------------------------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - event_type
   - VARCHAR
   - ``PASSWORD_RESET`` (o
     PASSWORD_RESET_FAILED,
     UNAUTHORIZED_ACCESS_ATTEMPT)
 * - actor_user_id
   - BIGINT
   - admin.id
 * - occurred_at
   - DATETIME
   - ``NOW()``
 * - payload
   - JSON
   - ``{target_user_id, ip, user_agent,
     sessions_closed_count, prior_first_login}``

7.5 Datos NO tocados
====================

- ``Assignment``, ``FunctionGroup``,
  ``AccessGroup`` — el reset de contrasena no
  cambia los permisos.
- ``UserActionLog`` (legacy) — se usa
  AuditEvent canonico.

7.6 Volumetria estimada
=======================

.. list-table::
 :widths: 35 65
 :header-rows: 0

 * - **Resets/dia (200 ops)**
   - ~2 (caso esporadico)
 * - **Pico**
   - ~10 si hay incidente de seguridad
     (politica de rotacion forzada)
 * - **Tamano AuditEvent**
   - ~250 bytes
 * - **Tamano InternalMessage**
   - ~500 bytes (subject + body con temp_pwd)

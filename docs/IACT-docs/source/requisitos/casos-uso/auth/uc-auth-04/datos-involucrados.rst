.. _uc-auth-04-parte-07:

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
   - ``/api/auth/change-password/``
 * - **Auth**
   - JWT del User
 * - **Idempotente**
   - NO

7.2 Request
===========

.. code-block:: http

   POST /api/auth/change-password/ HTTP/1.1
   Host: iact.example.com
   Authorization: Bearer eyJhbGc...
   Content-Type: application/json

.. code-block:: json

   {
     "current_password": "Pass123!",
     "new_password": "MiNueva2026!@",
     "new_password_confirmation": "MiNueva2026!@"
   }

7.3 Response
============

7.3.1 200 OK
------------

.. code-block:: json

   {
     "message": "Contrasena actualizada",
     "changed_at": "2026-05-01T08:00:14Z",
     "next_step": "landing",
     "scope_upgraded": false,
     "other_sessions_closed": 1
   }

Si viene de FA-01 (first_login), ``scope_upgraded
=true``.

7.3.2 400 (EX-02..EX-06)
------------------------

.. code-block:: json

   {
     "error": "WRONG_CURRENT_PASSWORD",
     "message": "Contrasena actual incorrecta"
   }

.. code-block:: json

   {
     "error": "WEAK_PASSWORD",
     "message": "La nueva contrasena no cumple la politica.",
     "violations": ["min_length", "missing_uppercase"]
   }

7.3.3 401 (EX-01) / 429 (EX-08) / 500 (EX-09) / 503 (EX-07)
-----------------------------------------------------------

Forma estandar CNST-013.

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
   - bcrypt(new_password)
 * - first_login
   - BOOLEAN
   - ``true → false`` (si era true)
 * - password_changed_at
   - DATETIME
   - ``NOW()``

7.4.2 PasswordHistory (escritura — INSERT + cleanup)
----------------------------------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - id
   - BIGINT (PK)
   - autoincrement
 * - user_id
   - BIGINT (FK)
   - usuario
 * - password_hash
   - VARCHAR(60)
   - hash anterior (o el nuevo, segun politica
     — ver nota)
 * - changed_at
   - DATETIME
   - ``NOW()``

**Nota de politica**: PasswordHistory guarda los
HASHES de contrasenas pasadas (inclusive la
nueva al momento del cambio) para que la
verificacion de reuso (PASO 9) consulte ese
historial. Tras N=5 entries, las mas viejas se
eliminan.

7.4.3 Session (escritura masiva — opcional segun setting)
---------------------------------------------------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Cambio
 * - state
   - VARCHAR
   - ``ACTIVE → CLOSED`` (otras sesiones del
     User, no la actual)
 * - close_reason
   - VARCHAR
   - ``PASSWORD_CHANGED``
 * - closed_at
   - DATETIME
   - ``NOW()``

7.4.4 BlacklistedToken (escritura — INSERT N)
---------------------------------------------

Por cada Session cerrada, sus JWTs vivos van al
blacklist con ``expires_at`` original.

7.4.5 AuditEvent (escritura — INSERT)
-------------------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - event_type
   - VARCHAR
   - ``PASSWORD_CHANGED`` (o
     PASSWORD_CHANGE_FAILED,
     SUSPICIOUS_PASSWORD_CHANGE_ATTEMPTS)
 * - actor_user_id
   - BIGINT
   - user.id
 * - occurred_at
   - DATETIME
   - ``NOW()``
 * - payload
   - JSON
   - ``{ip, user_agent,
     prior_first_login,
     other_sessions_closed_count,
     scope_upgrade}``

7.5 Datos NO tocados
====================

- ``Assignment``, ``FunctionGroup``,
  ``AccessGroup`` — el cambio de password no
  altera permisos.
- ``User.email``, ``User.username``,
  ``User.state`` — preservados.
- ``InternalMailbox`` — UC_AUTH_04 no genera
  mensajes (a diferencia de UC_AUTH_03).

7.6 Volumetria estimada
=======================

.. list-table::
 :widths: 35 65
 :header-rows: 0

 * - **Cambios/dia (200 ops)**
   - ~5-10 (post first_login + voluntarios
     ocasionales)
 * - **Pico**
   - ~30/min en politica de rotacion forzada
 * - **Tamano AuditEvent**
   - ~250 bytes
 * - **Crecimiento PasswordHistory**
   - 1 entry/cambio, max N=5/user

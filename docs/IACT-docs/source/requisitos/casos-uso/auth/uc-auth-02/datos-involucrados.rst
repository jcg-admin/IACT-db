.. _uc-auth-02-parte-07:

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
   - ``/api/auth/logout/``
 * - **Auth**
   - Requerida (Bearer JWT)
 * - **Idempotente**
   - Si (FA-02)

7.2 Request
===========

7.2.1 Headers
-------------

.. code-block:: http

   POST /api/auth/logout/ HTTP/1.1
   Host: iact.example.com
   Authorization: Bearer eyJhbGc...
   Content-Type: application/json

7.2.2 Body (opcional)
---------------------

.. code-block:: json

   {
     "refresh_token": "eyJhbGc..."
   }

Si el body se omite, se aplica FA-01.

7.3 Response
============

7.3.1 200 OK (flujo principal y FA)
-----------------------------------

.. code-block:: json

   {
     "message": "Sesion cerrada",
     "logout_at": "2026-05-01T07:25:14Z"
   }

7.3.2 401 Unauthorized (EX-01/02/03)
------------------------------------

.. code-block:: json

   {
     "error": "INVALID_TOKEN",
     "message": "Token invalido o expirado"
   }

7.3.3 429 Too Many Requests (EX-07)
-----------------------------------

.. code-block:: json

   {
     "error": "RATE_LIMIT",
     "message": "Demasiados intentos. Espera.",
     "retry_after": 60
   }

7.3.4 500/503 (EX-04/05/06)
---------------------------

.. code-block:: json

   {
     "error": "DB_TIMEOUT",
     "message": "Servicio temporalmente no disponible"
   }

7.4 Modelo de datos tocado
==========================

7.4.1 Session (escritura)
-------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Cambio
 * - state
   - VARCHAR
   - ``ACTIVE`` → ``CLOSED``
 * - closed_at
   - DATETIME
   - ``NULL`` → ``NOW()``
 * - close_reason
   - VARCHAR
   - ``NULL`` → ``USER_LOGOUT``

7.4.2 BlacklistedToken (escritura — INSERT)
-------------------------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - jti
   - VARCHAR (UNIQUE)
   - JWT ID del token
 * - token_type
   - ENUM
   - ``ACCESS`` o ``REFRESH``
 * - expires_at
   - DATETIME
   - Misma fecha que el token original
 * - blacklisted_at
   - DATETIME
   - ``NOW()``

7.4.3 AuditEvent (escritura — INSERT append-only)
-------------------------------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Valor
 * - event_type
   - VARCHAR
   - ``LOGOUT`` (o LOGOUT_REPLAY,
     LOGOUT_FAILED, LOGOUT_ON_SUPERSEDED)
 * - actor_user_id
   - BIGINT
   - ``user_id`` del token
 * - occurred_at
   - DATETIME
   - ``NOW()``
 * - payload
   - JSON
   - ``{ip, user_agent, session_id,
     close_reason}``

7.5 Datos NO tocados
====================

- ``User`` — solo lectura indirecta via
  ``Session.user_id`` (no UPDATE)
- ``InternalMailbox`` — UC_AUTH_02 no genera
  mensajes
- ``Assignment``, ``FunctionGroup``,
  ``AccessGroup`` — no relevantes en logout

7.6 Volumetria estimada
=======================

.. list-table::
 :widths: 35 65
 :header-rows: 0

 * - **Logouts/dia (call center 200 ops)**
   - ~600 (3 cierres/operador/dia entre turnos)
 * - **Pico/min (cambio turno)**
   - ~50 logouts/min
 * - **Tamano AuditEvent**
   - ~300 bytes/registro
 * - **Crecimiento BlacklistedToken**
   - ~2 entries/logout (access+refresh) × TTL
     hasta que el cron de purga elimine
     entries con ``expires_at < NOW()``

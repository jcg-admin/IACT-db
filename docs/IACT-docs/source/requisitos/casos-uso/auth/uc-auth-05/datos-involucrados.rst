.. _uc-auth-05-parte-07:

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
   - Funcion RBAC
 * - ``/api/auth/sessions/``
   - GET
   - ``view_all_active_sessions``
 * - ``/api/auth/sessions/{id}/``
   - GET
   - ``view_all_active_sessions``
 * - ``/api/auth/sessions/{id}/close/``
   - POST
   - ``close_user_session``
 * - ``/api/users/{user_id}/close-all-sessions/``
   - POST
   - ``close_user_session``
 * - ``/api/auth/sessions/own/``
   - GET
   - ``view_own_sessions`` (default User)

7.2 GET /api/auth/sessions/ (listado)
=====================================

7.2.1 Query params
------------------

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Param
   - Significado
 * - ``state``
   - filtro por state (default ACTIVE)
 * - ``user_id``
   - filtra Sessions de un User
 * - ``ip_like``
   - subquery LIKE en IP
 * - ``user_agent_like``
   - subquery LIKE en user_agent
 * - ``created_after``
   - ISO datetime
 * - ``created_before``
   - ISO datetime
 * - ``page``
   - paginacion (default 1)
 * - ``page_size``
   - default 50, max 200

7.2.2 Response 200
------------------

.. code-block:: json

   {
     "count": 134,
     "next": "/api/auth/sessions/?page=2",
     "previous": null,
     "results": [
       {
         "session_id": "uuid",
         "user_id": 42,
         "username": "ana.gomez",
         "state": "ACTIVE",
         "created_at": "2026-05-01T07:10:00Z",
         "expires_at": "2026-05-01T07:25:00Z",
         "client_info": {
           "ip": "10.0.0.1",
           "user_agent_short": "Chrome 110/Win"
         }
       }
     ]
   }

7.3 POST /api/auth/sessions/{id}/close/
=======================================

7.3.1 Request
-------------

Body opcional ``{"notify_user": true}``.

7.3.2 Response 200
------------------

.. code-block:: json

   {
     "session_id": "uuid",
     "closed_at": "2026-05-01T08:05:00Z",
     "close_reason": "ADMIN_REVOKED",
     "user_notified": true
   }

7.4 POST /api/users/{id}/close-all-sessions/
============================================

7.4.1 Response 200
------------------

.. code-block:: json

   {
     "target_user_id": 42,
     "sessions_closed": 3,
     "session_ids": ["uuid1", "uuid2", "uuid3"]
   }

7.5 Modelo de datos tocado
==========================

7.5.1 Session (escritura en cierre)
-----------------------------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Cambio
 * - state
   - VARCHAR
   - ``ACTIVE → CLOSED``
 * - close_reason
   - VARCHAR
   - ``NULL → 'ADMIN_REVOKED'``
 * - closed_at
   - DATETIME
   - ``NOW()``
 * - closed_by_admin_id
   - BIGINT (FK)
   - admin.id

7.5.2 BlacklistedToken (INSERT)
-------------------------------

Por cada Session cerrada, sus JWTs vivos.

7.5.3 InternalMessage (INSERT — opcional)
-----------------------------------------

Si setting NOTIFY_USER_ON_ADMIN_SESSION_CLOSE.

.. code-block:: json

   {
     "recipient": "User cuyo session se cerro",
     "subject": "Sesion cerrada por administrador",
     "body": "Tu sesion en {client_info} fue cerrada por un administrador a las {timestamp}."
   }

7.5.4 AuditEvent (INSERT — N+1 en bulk)
---------------------------------------

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Campo
   - Valor
 * - event_type
   - ``SESSION_CLOSED`` (1 por session) o
     ``BULK_SESSION_CLOSE`` (1 adicional para
     bulk) o ``SESSIONS_VIEWED_FOR_USER`` o
     ``UNAUTHORIZED_ACCESS_ATTEMPT``
 * - actor_user_id
   - admin.id
 * - payload
   - ``{target_user_id, target_session_id, ip,
     user_agent, reason, ...}``

7.6 Indices recomendados
========================

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - Tabla
   - Indice
 * - session
   - ``(state, user_id)``
 * - session
   - ``(state, created_at)``
 * - session
   - ``(closed_by_admin_id)`` (para auditoria
     reversa)
 * - audit_event
   - ``(event_type, occurred_at)``

7.7 Volumetria estimada
=======================

.. list-table::
 :widths: 35 65
 :header-rows: 0

 * - **Sessions ACTIVE concurrentes (pico)**
   - ~250 (CNST-004 garantiza ≤ 1/User
     activos)
 * - **Operaciones admin/dia**
   - ~10 (caso esporadico — incidentes,
     supervision)
 * - **Pico**
   - ~50/min en respuesta a incidente

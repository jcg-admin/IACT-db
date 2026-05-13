.. _uc-usr-04-parte-07:

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
   - ``/api/users/{user_id}/``
 * - **Auth**
   - JWT del invocante
 * - **RBAC**
   - funcion ``deactivate_users``
 * - **Idempotente**
   - SI (default) — second DELETE responde
     200 OK informativo. Strict opcional
     responde 409.
 * - **Semantica DELETE**
   - baja logica (BR-009): internamente es
     UPDATE de state + side-effects.

7.2 Request
===========

.. code-block:: http

   DELETE /api/users/42/ HTTP/1.1
   Host: iact.example.com
   Authorization: Bearer eyJhbGc...

Sin body.

7.3 Response 200 — exito
========================

.. code-block:: json

   {
     "target_user_id": 42,
     "username": "ana.gomez.0001",
     "state": "ELIMINATED",
     "eliminated_at": "2026-05-01T17:05:00Z",
     "eliminated_by_admin_id": 1,
     "prior_state": "ACTIVE",
     "sessions_closed": 2,
     "assignments_revoked": 3,
     "user_notified": true,
     "mailbox_failed": false
   }

7.4 Response 200 — idempotente (FA-02)
======================================

.. code-block:: json

   {
     "target_user_id": 42,
     "state": "ELIMINATED",
     "already_eliminated": true,
     "original_eliminated_at": "2026-05-01T17:00:00Z",
     "message": "Usuario ya estaba eliminado"
   }

7.5 Response — errores
======================

.. list-table::
 :widths: 20 30 50
 :header-rows: 1

 * - Status
   - Excepcion
   - Body
 * - 400
   - SELF_ELIMINATION_FORBIDDEN
   - P-11 anti-self-elimination
 * - 401
   - INVALID_TOKEN
   - middleware estandar
 * - 403
   - FORBIDDEN
   - sin funcion ``deactivate_users``
 * - 404
   - USER_NOT_FOUND
   - target_user_id inexistente
 * - 409
   - USER_ALREADY_ELIMINATED
   - solo si politica strict
 * - 429
   - RATE_LIMIT
   - throttling 30/min
 * - 500
   - AUDIT_FAILED
   - audit fail (rollback)
 * - 503
   - DB_TIMEOUT
   - lock contention

7.6 Modelo de datos tocado
==========================

7.6.1 User (escritura — UPDATE)
-------------------------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Cambio
 * - state
   - ENUM
   - ``→ ELIMINATED``
 * - eliminated_at
   - DATETIME
   - ``NOW()`` (era NULL)
 * - eliminated_by_admin_id
   - BIGINT (FK)
   - admin.id (era NULL)

NO se modifican: ``username``, ``email``,
``first_name``, ``last_name``, ``password_hash``,
``created_at``, ``created_by_admin_id``. Estos
permanecen para trazabilidad historica.

7.6.2 Assignment (escritura masiva — UPDATE)
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
   - BIGINT
   - admin.id
 * - revoke_reason
   - VARCHAR
   - ``'USER_ELIMINATED'``

7.6.3 Session (escritura masiva — UPDATE)
-----------------------------------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Cambio
 * - state
   - ENUM
   - ``ACTIVE → CLOSED``
 * - close_reason
   - VARCHAR
   - ``'USER_ELIMINATED'``
 * - closed_at
   - DATETIME
   - ``NOW()``
 * - closed_by_admin_id
   - BIGINT
   - admin.id

7.6.4 BlacklistedToken (escritura — INSERT N)
---------------------------------------------

Por cada Session cerrada con ``access_jti``
no NULL, INSERT con expires_at original.

7.6.5 InternalMessage (escritura — INSERT opcional)
---------------------------------------------------

Solo si setting NOTIFY_USER_ON_ELIMINATION=true:

.. code-block:: json

   {
     "recipient_user_id": 42,
     "sender_user_id": null,
     "subject": "Tu cuenta fue eliminada",
     "body": "Tu cuenta IACT fue eliminada por
              un administrador. Si requieres
              acceso, contacta a tu jefatura."
   }

7.6.6 AuditEvent (escritura — INSERT append-only)
-------------------------------------------------

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Campo
   - Valor
 * - event_type
   - ``USER_ELIMINATED`` (o
     USER_ELIMINATE_NOOP en FA-02,
     USER_ELIMINATE_FAILED en EX-04, etc.)
 * - actor_user_id
   - admin.id
 * - occurred_at
   - NOW()
 * - payload
   - ``{target_user_id, ip, user_agent,
     prior_state, sessions_closed_count,
     assignments_revoked_count,
     user_notified, mailbox_failed}``

7.7 Datos NO tocados (preservados)
==================================

- ``InternalMessage`` enviados/recibidos por
  el User antes de la eliminacion: preservados.
- ``AuditEvent`` historicos donde el User era
  ``actor_user_id`` o ``target_user_id``:
  preservados (CNST-025 append-only).
- ``PasswordHistory``: preservada (no se purga).
- ``email`` y ``username``: NO quedan libres
  (defensa anti-impersonacion).

7.8 Volumetria estimada
=======================

.. list-table::
 :widths: 35 65
 :header-rows: 0

 * - **Eliminaciones/dia**
   - ~1-3 (caso esporadico — empleado deja
     organizacion)
 * - **Pico (limpieza masiva)**
   - ~10/min (excepcional, p.ej. cierre de
     proyecto / area)
 * - **AuditEvent size**
   - ~300 bytes
 * - **Crecimiento BD**
   - prácticamente nulo — UPDATE in-place

7.9 FR derivados (Nivel 4) — preliminar
=======================================

.. list-table::
 :widths: 20 20 60
 :header-rows: 1

 * - FR ID
   - Paso UC
   - Capacidad
 * - FR-USR-04-01
   - 6
   - Verificar funcion deactivate_users
 * - FR-USR-04-02
   - 7
   - Localizar User con select_for_update
 * - FR-USR-04-03
   - 8
   - Validar P-11 anti-self-elimination
 * - FR-USR-04-04
   - 9
   - UPDATE User → ELIMINATED + metadata
 * - FR-USR-04-05
   - 10
   - UPDATE Assignments activos → REVOKED
 * - FR-USR-04-06
   - 11
   - UPDATE Sessions activas → CLOSED
 * - FR-USR-04-07
   - 12
   - INSERT BlacklistedToken por cada Session
 * - FR-USR-04-08
   - 13
   - INSERT InternalMessage opcional
 * - FR-USR-04-09
   - 14
   - INSERT AuditEvent USER_ELIMINATED
 * - FR-USR-04-10
   - 15
   - Construir response con resumen
 * - FR-USR-04-11
   - 16
   - Frontend muestra resumen + refresca lista

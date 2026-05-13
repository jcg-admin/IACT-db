.. _uc-auth-02-parte-05:

==========================
Parte 5 — Excepciones
==========================

Caminos de falla del flujo principal. Cada EX
tiene activador, condicion, response code,
mensaje, y AuditEvent asociado.

5.1 EX-01: Token invalido o expirado
====================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 4 (validacion JWT)
 * - **Condicion**
   - Firma JWT invalida, token expirado, o token
     en blacklist
 * - **Accion sistema**
   - Rechaza request, no toca BD
 * - **Response**
   - 401 Unauthorized
 * - **Body**
   - ``{"error": "INVALID_TOKEN", "message":
     "Token invalido o expirado"}``
 * - **AuditEvent**
   - LOGOUT_FAILED con payload
     {reason: 'invalid_token'}
 * - **CNST**
   - CNST-009, CNST-013

5.2 EX-02: Sesion no encontrada
===============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 5 (localizar Session)
 * - **Condicion**
   - El ``session_id`` extraido del token no
     corresponde a ninguna Session en BD
 * - **Accion sistema**
   - Rechaza, posible token forjado o de Session
     ya purgada
 * - **Response**
   - 401 Unauthorized
 * - **Body**
   - ``{"error": "SESSION_NOT_FOUND", "message":
     "Sesion no localizada"}``
 * - **AuditEvent**
   - LOGOUT_FAILED con payload
     {reason: 'session_not_found',
     attempted_session_id}
 * - **CNST**
   - CNST-013, CNST-025

Diferencia con FA-02: en FA-02 la Session existe
pero CLOSED. En EX-02 la Session no existe en
absoluto — caso anomalo que merece flag de
seguridad.

5.3 EX-03: User mismatch
========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 5
 * - **Condicion**
   - La Session existe pero
     ``Session.user_id`` no matchea con el
     ``user_id`` del token
 * - **Accion sistema**
   - Rechaza inmediato; flag de alta severidad
 * - **Response**
   - 401 Unauthorized
 * - **Body**
   - ``{"error": "USER_MISMATCH", "message":
     "Sesion no autorizada"}``
 * - **AuditEvent**
   - LOGOUT_FAILED con
     {reason: 'user_mismatch',
     token_user_id, session_user_id} —
     posible intento de hijack
 * - **CNST**
   - CNST-009, CNST-025

5.4 EX-04: Timeout de BD durante UPDATE
=======================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 6 (UPDATE Session)
 * - **Condicion**
   - BD MySQL no responde dentro de 5s, o lock
     contention con UC_AUTH_05
 * - **Accion sistema**
   - ROLLBACK; Session permanece ACTIVE; tokens
     NO blacklisteados
 * - **Response**
   - 503 Service Unavailable
 * - **Body**
   - ``{"error": "DB_TIMEOUT", "message":
     "Servicio temporalmente no disponible.
     Reintenta."}``
 * - **AuditEvent**
   - LOGOUT_FAILED con
     {reason: 'db_timeout', retry_after}
 * - **CNST**
   - CNST-013

El cliente puede reintentar. Si el timeout
persiste, la Session se cerrara automaticamente
por CNST-005 (timeout 15 min).

5.5 EX-05: Falla parcial en blacklist
=====================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 7
 * - **Condicion**
   - INSERT en ``BlacklistedToken`` falla (cache
     Redis caido, BD overloaded)
 * - **Accion sistema**
   - ROLLBACK de toda la transaccion; Session
     vuelve a ACTIVE
 * - **Response**
   - 500 Internal Server Error
 * - **Body**
   - ``{"error": "BLACKLIST_FAILED", "message":
     "No se pudo invalidar el token. Reintenta."}``
 * - **AuditEvent**
   - LOGOUT_FAILED con
     {reason: 'blacklist_write_failed'}
 * - **CNST**
   - CNST-013

Critico: si el blacklist falla, NO se debe marcar
la Session como CLOSED — quedariamos con tokens
validos circulando contra una Session cerrada
(estado inconsistente).

5.6 EX-06: AuditEvent no se puede emitir
========================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 8
 * - **Condicion**
   - INSERT en ``AuditEvent`` falla
 * - **Accion sistema**
   - ROLLBACK completo (CNST-025 exige
     auditoria; sin auditoria no se cierra)
 * - **Response**
   - 500 Internal Server Error
 * - **Body**
   - ``{"error": "AUDIT_FAILED", "message":
     "Error interno. Reintenta."}``
 * - **AuditEvent**
   - (no se emite — esa es la falla)
 * - **CNST**
   - CNST-025

5.7 EX-07: Throttling
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - Antes de PASO 4
 * - **Condicion**
   - Mas de N requests/min al endpoint logout
     desde la misma IP (defensa contra abuso de
     blacklist)
 * - **Accion sistema**
   - Rate limit middleware rechaza
 * - **Response**
   - 429 Too Many Requests
 * - **Body**
   - ``{"error": "RATE_LIMIT", "message":
     "Demasiados intentos. Espera."}``
 * - **AuditEvent**
   - (rate limit middleware logging — no
     AuditEvent dominio)
 * - **CNST**
   - CNST-011

5.8 Resumen de excepciones
==========================

.. list-table::
 :widths: 12 35 18 35
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - AuditEvent
 * - EX-01
   - Token invalido / expirado
   - 401
   - LOGOUT_FAILED (invalid_token)
 * - EX-02
   - Session no existe
   - 401
   - LOGOUT_FAILED (session_not_found)
 * - EX-03
   - User mismatch (hijack?)
   - 401
   - LOGOUT_FAILED (user_mismatch) — ALERTA
 * - EX-04
   - BD timeout
   - 503
   - LOGOUT_FAILED (db_timeout)
 * - EX-05
   - Blacklist write fail
   - 500
   - LOGOUT_FAILED (blacklist_write_failed)
 * - EX-06
   - AuditEvent INSERT fail
   - 500
   - (no se emite)
 * - EX-07
   - Rate limit
   - 429
   - (middleware log)

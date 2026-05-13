.. _uc-auth-03-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido o expirado
====================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 7
 * - **Condicion**
   - JWT del admin invalido, expirado, o en
     blacklist
 * - **Response**
   - 401 Unauthorized
 * - **Body**
   - ``{"error": "INVALID_TOKEN", "message":
     "Token invalido"}``
 * - **AuditEvent**
   - PASSWORD_RESET_FAILED con
     {reason: 'invalid_token'}
 * - **CNST**
   - CNST-009, CNST-013

5.2 EX-02: Sin funcion reset_password (sin AGR-006)
===================================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 7
 * - **Condicion**
   - Admin autenticado pero sin la funcion
     RBAC ``reset_password``
 * - **Accion sistema**
   - Rechaza inmediato; emite AuditEvent
     UNAUTHORIZED_ACCESS_ATTEMPT (escalada de
     privilegio sospechosa)
 * - **Response**
   - 403 Forbidden
 * - **Body**
   - ``{"error": "FORBIDDEN", "message":
     "Sin permisos para resetear contrasenas"}``
 * - **AuditEvent**
   - UNAUTHORIZED_ACCESS_ATTEMPT con
     {target_user_id, attempted_action:
     'reset_password'}
 * - **CNST**
   - CNST-013, CNST-025

5.3 EX-03: Usuario no encontrado
================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 8
 * - **Condicion**
   - El ``user_id`` del path no corresponde a
     ningun User
 * - **Response**
   - 404 Not Found
 * - **Body**
   - ``{"error": "USER_NOT_FOUND", "message":
     "Usuario no encontrado"}``
 * - **AuditEvent**
   - PASSWORD_RESET_FAILED
     {reason: 'user_not_found',
     attempted_user_id}

5.4 EX-04: Auto-reset prohibido
===============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 8
 * - **Condicion**
   - ``user_id == admin.id``
 * - **Justificacion**
   - Un admin que olvida su propia contrasena
     debe pedirle a otro admin con AGR-006 que
     se la resetee. Defensa contra escalada.
 * - **Response**
   - 400 Bad Request
 * - **Body**
   - ``{"error": "SELF_RESET_FORBIDDEN",
     "message": "No puedes resetear tu propia
     contrasena. Pide a otro administrador o
     usa Cambiar Contrasena."}``
 * - **AuditEvent**
   - PASSWORD_RESET_FAILED
     {reason: 'self_reset_attempt'} —
     ALERTA media

5.5 EX-05: Usuario eliminado
============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 8
 * - **Condicion**
   - ``User.state == 'ELIMINATED'``
 * - **Response**
   - 400 Bad Request
 * - **Body**
   - ``{"error": "USER_ELIMINATED", "message":
     "No se puede resetear un usuario
     eliminado"}``
 * - **AuditEvent**
   - PASSWORD_RESET_FAILED
     {reason: 'user_eliminated'}

5.6 EX-06: BD timeout en UPDATE
===============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 10
 * - **Condicion**
   - ``OperationalError`` por lock contention
     (UC_USR_03 modificando el User
     simultaneamente) o BD lenta
 * - **Accion sistema**
   - ROLLBACK; sin cambios
 * - **Response**
   - 503 Service Unavailable
 * - **Body**
   - ``{"error": "DB_TIMEOUT", "message":
     "Servicio temporalmente no disponible.
     Reintenta."}``
 * - **AuditEvent**
   - PASSWORD_RESET_FAILED
     {reason: 'db_timeout'}

5.7 EX-07: InternalMessage no se puede crear
============================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 12
 * - **Condicion**
   - INSERT en ``internal_message`` falla
 * - **Accion sistema**
   - ROLLBACK COMPLETO. CNST-002 exige
     buzon como canal — sin mensaje, no se
     completa el reset. El admin debe
     reintentar.
 * - **Response**
   - 500 Internal Server Error
 * - **Body**
   - ``{"error": "MAILBOX_FAILED", "message":
     "No se pudo notificar al usuario.
     Reintenta."}``
 * - **AuditEvent**
   - PASSWORD_RESET_FAILED
     {reason: 'mailbox_write_failed'}
 * - **CNST**
   - CNST-002 (sin buzon, no operacion)

5.8 EX-08: Throttling
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - Antes de PASO 7
 * - **Condicion**
   - Admin excede ``10 resets/5min``
 * - **Accion sistema**
   - Rate limit middleware rechaza
 * - **Response**
   - 429 Too Many Requests
 * - **Body**
   - ``{"error": "RATE_LIMIT", "message":
     "Demasiados resets. Espera.",
     "retry_after": 300}``
 * - **CNST**
   - CNST-011

5.9 EX-09: AuditEvent no se puede emitir
========================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 13
 * - **Condicion**
   - INSERT en AuditEvent falla
 * - **Accion sistema**
   - ROLLBACK; CNST-025 exige auditoria
 * - **Response**
   - 500 Internal Server Error
 * - **CNST**
   - CNST-025

5.10 Resumen de excepciones
===========================

.. list-table::
 :widths: 12 35 18 35
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - AuditEvent
 * - EX-01
   - Token invalido
   - 401
   - PASSWORD_RESET_FAILED
 * - EX-02
   - Sin reset_password
   - 403
   - UNAUTHORIZED_ACCESS_ATTEMPT
 * - EX-03
   - User no existe
   - 404
   - PASSWORD_RESET_FAILED
 * - EX-04
   - Auto-reset
   - 400
   - PASSWORD_RESET_FAILED — ALERTA
 * - EX-05
   - User eliminado
   - 400
   - PASSWORD_RESET_FAILED
 * - EX-06
   - BD timeout
   - 503
   - PASSWORD_RESET_FAILED
 * - EX-07
   - Mailbox INSERT fail
   - 500
   - PASSWORD_RESET_FAILED
 * - EX-08
   - Rate limit
   - 429
   - (middleware log)
 * - EX-09
   - Audit INSERT fail
   - 500
   - (no se emite)

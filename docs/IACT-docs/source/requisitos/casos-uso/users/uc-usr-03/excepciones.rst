.. _uc-usr-03-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido
=========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 4
 * - **Condicion**
   - JWT firma invalida, expirado o blacklisted
 * - **Accion sistema**
   - rechazo en middleware authentication
 * - **Response**
   - 401 INVALID_TOKEN
 * - **Body**
   - ``{"error":"INVALID_TOKEN","message":
     "Token invalido"}``
 * - **AuditEvent**
   - (no aplica — middleware log)

5.2 EX-02: Sin permiso modify_users
===================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 4
 * - **Condicion**
   - Admin autenticado pero sin la funcion RBAC
     ``modify_users``
 * - **Accion sistema**
   - rechazo, emite alerta de seguridad
 * - **Response**
   - 403 FORBIDDEN
 * - **Body**
   - ``{"error":"FORBIDDEN","message":
     "Sin permisos para modificar usuarios"}``
 * - **AuditEvent**
   - UNAUTHORIZED_ACCESS_ATTEMPT
     {attempted_action:'modify_user',
     target_user_id}

5.3 EX-03: Usuario destino no encontrado
========================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 5
 * - **Condicion**
   - ``user_id`` del path no corresponde a
     ningun User
 * - **Response**
   - 404 USER_NOT_FOUND
 * - **AuditEvent**
   - USER_MODIFY_FAILED
     {reason:'user_not_found'}

5.4 EX-04: Auto-cambio de state prohibido (P-11)
================================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 6
 * - **Condicion**
   - ``user_id == admin.id`` y el PATCH incluye
     ``state``
 * - **Justificacion**
   - Defensa contra escalada / lockout: un
     admin no debe poder cambiar su propio
     estado (puede dejarse bloqueado por error,
     o promoverse a ACTIVE saltando un
     bloqueo). El cambio de propio state debe
     hacerlo OTRO admin.
 * - **Response**
   - 400 BAD_REQUEST
 * - **Body**
   - ``{"error":"SELF_STATE_CHANGE_FORBIDDEN",
     "message":"No puedes cambiar tu propio
     estado"}``
 * - **AuditEvent**
   - USER_MODIFY_FAILED
     {reason:'self_state_change'} — ALERTA
     media

5.5 EX-05: Email duplicado
==========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 7
 * - **Condicion**
   - PATCH cambia ``email`` y el nuevo valor
     ya existe en otro User
 * - **Response**
   - 409 EMAIL_EXISTS

5.6 EX-06: Transicion de state invalida
=======================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 6
 * - **Condicion**
   - Transicion no permitida (ej. desde
     ELIMINATED, o intentando ELIMINATED via
     este UC)
 * - **Response**
   - 400 INVALID_STATE_TRANSITION
 * - **Body**
   - ``{"error":"INVALID_STATE_TRANSITION",
     "from":"ELIMINATED","to":"ACTIVE",
     "message":"Transicion no permitida"}``

5.7 EX-07: Datos invalidos
==========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 7 (serializer)
 * - **Condicion**
   - email malformado, first_name vacio, etc.
 * - **Response**
   - 400 VALIDATION_ERROR
 * - **Body**
   - ``{"error":"VALIDATION_ERROR",
     "details":{...}}``

5.8 EX-08: BD timeout
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 8-10 (lock contention con
     UC_AUTH_03 / UC_AUTH_05)
 * - **Accion**
   - ROLLBACK; sin cambios
 * - **Response**
   - 503 DB_TIMEOUT

5.9 EX-09: Audit INSERT falla
=============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 10
 * - **Accion**
   - ROLLBACK completo (CNST-025)
 * - **Response**
   - 500 AUDIT_FAILED

5.10 EX-10: Throttling
======================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - antes de PASO 4
 * - **Condicion**
   - > 60 PATCH/min/admin (CNST-011)
 * - **Response**
   - 429 RATE_LIMIT

5.11 Resumen de excepciones
===========================

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - AuditEvent
 * - EX-01
   - Token invalido
   - 401
   - (middleware)
 * - EX-02
   - Sin modify_users
   - 403
   - UNAUTHORIZED_ACCESS_ATTEMPT
 * - EX-03
   - User no existe
   - 404
   - USER_MODIFY_FAILED
 * - EX-04
   - Auto-cambio state
   - 400
   - USER_MODIFY_FAILED — ALERTA
 * - EX-05
   - Email duplicado
   - 409
   - USER_MODIFY_FAILED
 * - EX-06
   - Transicion state invalida
   - 400
   - USER_MODIFY_FAILED
 * - EX-07
   - Datos invalidos
   - 400
   - (validacion)
 * - EX-08
   - BD timeout
   - 503
   - USER_MODIFY_FAILED
 * - EX-09
   - Audit fail
   - 500
   - (no se emite)
 * - EX-10
   - Rate limit
   - 429
   - (middleware)

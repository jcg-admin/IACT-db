.. _uc-usr-04-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido
=========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 6
 * - **Response**
   - 401 INVALID_TOKEN

5.2 EX-02: Sin permiso deactivate_users
=======================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 6
 * - **Condicion**
   - admin sin funcion ``deactivate_users``
 * - **Response**
   - 403 FORBIDDEN
 * - **AuditEvent**
   - UNAUTHORIZED_ACCESS_ATTEMPT
     {attempted_action:'eliminate_user',
     target_user_id} — ALERTA (intento de
     accion destructiva sin privilegio)

5.3 EX-03: User no encontrado
=============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 7
 * - **Response**
   - 404 USER_NOT_FOUND

5.4 EX-04: Auto-eliminacion prohibida (P-11)
============================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 8
 * - **Condicion**
   - ``user_id == admin.id``
 * - **Response**
   - 400 BAD_REQUEST
 * - **Body**
   - ``{"error":"SELF_ELIMINATION_FORBIDDEN",
     "message":"No puedes eliminar tu propia
     cuenta. Solicita a otro administrador."}``
 * - **AuditEvent**
   - USER_ELIMINATE_FAILED
     {reason:'self_elimination'} — ALERTA alta

5.5 EX-05: User ya ELIMINATED (politica strict)
===============================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 7 (cuando setting
     ``STRICT_ELIMINATION=true``)
 * - **Condicion**
   - User existe con ``state='ELIMINATED'``
 * - **Response**
   - 409 CONFLICT (politica strict) o 200 OK
     idempotente (default — FA-02)
 * - **Body strict**
   - ``{"error":"USER_ALREADY_ELIMINATED",
     "original_eliminated_at":"..."}``

5.6 EX-06: BD timeout
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASOS 9-12 (lock contention con
     UC_AUTH_03 / UC_USR_03 sobre el mismo
     User)
 * - **Accion**
   - ROLLBACK; sin cambios
 * - **Response**
   - 503 DB_TIMEOUT

5.7 EX-07: Audit INSERT falla
=============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 14
 * - **Accion**
   - ROLLBACK COMPLETO. CNST-025: sin audit no
     operacion.
 * - **Response**
   - 500 AUDIT_FAILED

5.8 EX-08: Throttling
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - antes del PASO 6
 * - **Condicion**
   - > 30 DELETE/min/admin (CNST-011 — limite
     mas estricto que UC_USR_03 dado que la
     accion es destructiva)
 * - **Response**
   - 429 RATE_LIMIT

5.9 EX-09: Mailbox INSERT falla (politica notify)
=================================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 13 (solo si politica
     ``NOTIFY_USER_ON_ELIMINATION=true``)
 * - **Politica**
   - **Mailbox-or-abort softer**: dado que la
     eliminacion es operacion administrativa
     destructiva irreversible, la falla del
     mailbox NO debe abortar la eliminacion
     completa (a diferencia de UC_USR_01 /
     UC_AUTH_03 donde el mailbox es el unico
     canal). En este UC, la transaccion
     procede sin el mensaje.
 * - **Accion**
   - registrar warning en AuditEvent payload
     ``mailbox_failed=true``; transaccion
     continua sin InternalMessage; status
     final 200 OK con
     ``user_notified=false``.

5.10 Resumen de excepciones
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
   - Sin deactivate_users
   - 403
   - UNAUTHORIZED — ALERTA
 * - EX-03
   - User no existe
   - 404
   - (sin audit)
 * - EX-04
   - Auto-eliminacion
   - 400
   - USER_ELIMINATE_FAILED — ALERTA alta
 * - EX-05
   - User ya ELIMINATED
   - 409 / 200
   - segun politica
 * - EX-06
   - BD timeout
   - 503
   - USER_ELIMINATE_FAILED
 * - EX-07
   - Audit fail
   - 500
   - (no se emite)
 * - EX-08
   - Rate limit
   - 429
   - (middleware)
 * - EX-09
   - Mailbox fail (notify)
   - 200
   - USER_ELIMINATED con
     mailbox_failed=true

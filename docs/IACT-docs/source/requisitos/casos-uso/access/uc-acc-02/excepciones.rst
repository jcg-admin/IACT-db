.. _uc-acc-02-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido
=========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 5
 * - **Response**
   - 401 INVALID_TOKEN

5.2 EX-02: Sin funcion revoke_functions
=======================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 6
 * - **Response**
   - 403 FORBIDDEN
 * - **AuditEvent**
   - UNAUTHORIZED_ACCESS_ATTEMPT
     {attempted_action:'revoke_functions',
     target_user_id} — ALERTA media

5.3 EX-03: User no encontrado
=============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 7
 * - **Response**
   - 404 USER_NOT_FOUND

5.4 EX-04: Auto-revocacion prohibida (P-11)
===========================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 8
 * - **Condicion**
   - ``user_id == invoker.id`` con politica
     ``ANTI_SELF_REVOKE_FUNCTIONS=true``
 * - **Justificacion**
   - defensa anti-lockout: invocante no
     debe revocarse a si mismo, especialmente
     ``revoke_functions`` (perderia la
     capacidad de revertir).
 * - **Response**
   - 400 SELF_REVOKE_FORBIDDEN
 * - **AuditEvent**
   - FUNCTIONS_REVOKE_FAILED
     {reason:'self_revoke'} — ALERTA alta

5.5 EX-05: User en estado invalido
==================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 7
 * - **Condicion**
   - User con state ELIMINATED (sus
     Assignments ya REVOKED por UC_USR_04)
 * - **Response**
   - 400 INVALID_USER_STATE

5.6 EX-06: Payload invalido
===========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 4 (serializer)
 * - **Condicion**
   - ``function_ids`` no es lista, lista
     vacia, > 50 elementos;
     ``revoke_reason`` ausente o vacio
     (obligatorio para auditabilidad)
 * - **Response**
   - 400 VALIDATION_ERROR

5.7 EX-07: BD timeout
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASOS 12-14
 * - **Accion**
   - ROLLBACK
 * - **Response**
   - 503 DB_TIMEOUT

5.8 EX-08: Audit INSERT falla
=============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 14
 * - **Accion**
   - ROLLBACK; CNST-025
 * - **Response**
   - 500 AUDIT_FAILED

5.9 EX-09: Last holder bloqueado (politica strict)
==================================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 11 (con politica
     ``BLOCK_LAST_HOLDER_REVOKE=true``)
 * - **Condicion**
   - alguna funcion del payload dejaria al
     sistema con cero holders post-revoke
 * - **Response**
   - 409 LAST_HOLDER_PROTECTION
 * - **Body**
   - JSON con ``conflict_function_ids``,
     ``message`` "El User es ultimo holder
     de la funcion X. Asigna primero a
     otro User"
 * - **AuditEvent**
   - FUNCTIONS_REVOKE_FAILED
     {reason:'last_holder_protection'}

5.10 EX-10: Throttling
======================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - antes de PASO 5
 * - **Condicion**
   - > 30 DELETE/min/invoker (CNST-011)
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
   - Sin revoke_functions
   - 403
   - UNAUTHORIZED — ALERTA
 * - EX-03
   - User no existe
   - 404
   - FUNCTIONS_REVOKE_FAILED
 * - EX-04
   - Auto-revocacion (P-11)
   - 400
   - FUNCTIONS_REVOKE_FAILED — ALERTA alta
 * - EX-05
   - User ELIMINATED
   - 400
   - FUNCTIONS_REVOKE_FAILED
 * - EX-06
   - Payload invalido
   - 400
   - (validacion)
 * - EX-07
   - BD timeout
   - 503
   - FUNCTIONS_REVOKE_FAILED
 * - EX-08
   - Audit fail
   - 500
   - (no se emite)
 * - EX-09
   - Last holder bloqueo strict
   - 409
   - FUNCTIONS_REVOKE_FAILED
 * - EX-10
   - Rate limit
   - 429
   - (middleware)

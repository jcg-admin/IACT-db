.. _uc-acc-01-parte-05:

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

5.2 EX-02: Sin funcion assign_functions
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
     {attempted_action:'assign_functions',
     target_user_id} — ALERTA (intento de
     escalada de privilegios)

5.3 EX-03: User destino no encontrado
=====================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 7
 * - **Response**
   - 404 USER_NOT_FOUND

5.4 EX-04: User destino en estado invalido
==========================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 7
 * - **Condicion**
   - User con state ELIMINATED o BLOCKED, o
     INACTIVE si politica strict
 * - **Response**
   - 400 INVALID_USER_STATE
 * - **Body**
   - ``{"error":"INVALID_USER_STATE",
     "user_state":"ELIMINATED",
     "message":"No se asignan funciones a
     usuarios eliminados"}``

5.5 EX-05: Auto-asignacion prohibida (P-11)
===========================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 7
 * - **Condicion**
   - ``user_id == invoker.id`` y politica
     ``ANTI_SELF_ASSIGN_FUNCTIONS=true``
 * - **Justificacion**
   - defensa contra escalada de privilegios:
     un User con ``assign_functions`` no debe
     poder agregarse funciones a si mismo.
 * - **Response**
   - 400 SELF_ASSIGN_FORBIDDEN
 * - **AuditEvent**
   - FUNCTIONS_ASSIGN_FAILED
     {reason:'self_assign'} — ALERTA alta

5.6 EX-06: Funcion no existe
============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 8
 * - **Condicion**
   - alguna ``function_id`` no existe en
     catalogo
 * - **Response**
   - 400 FUNCTION_NOT_FOUND
 * - **Body**
   - ``{"error":"FUNCTION_NOT_FOUND",
     "missing_ids":[42,99]}``

5.7 EX-07: Funcion inactiva
===========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 8
 * - **Condicion**
   - alguna funcion existe pero ``state !=
     ACTIVE``
 * - **Response**
   - 400 FUNCTION_INACTIVE
 * - **Body**
   - ``{"error":"FUNCTION_INACTIVE",
     "inactive_ids":[15]}``

5.8 EX-08: Violacion SoD (CNST-005, BR-007)
===========================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 10
 * - **Condicion**
   - el conjunto efectivo (actuales + nuevas)
     viola al menos una SoDRule activa
 * - **Accion sistema**
   - rechazo total (no asignacion parcial —
     all-or-nothing)
 * - **Response**
   - 409 CONFLICT
 * - **Body**
   - JSON con campos ``error="SOD_VIOLATION"``,
     ``rule_id``, ``rule_name``,
     ``conflict_pair`` (lista de objetos
     ``{function_id, code}``), y ``message``
     descriptiva. Ver § 7.4 EX-08 en Parte 7
     para ejemplo completo del payload.
 * - **AuditEvent**
   - FUNCTIONS_ASSIGN_FAILED
     {reason:'sod_violation', rule_id,
     conflict_pair}
 * - **CNST**
   - CNST-005

5.9 EX-09: BD timeout
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASOS 11-13
 * - **Accion**
   - ROLLBACK
 * - **Response**
   - 503 DB_TIMEOUT

5.10 EX-10: Audit INSERT falla
==============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 13
 * - **Accion**
   - ROLLBACK; CNST-025
 * - **Response**
   - 500 AUDIT_FAILED

5.11 EX-11: Throttling
======================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - antes del PASO 5
 * - **Condicion**
   - > 30 POST/min/invoker (CNST-011)
 * - **Response**
   - 429 RATE_LIMIT

5.12 EX-12: Payload invalido
============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 4 (serializer)
 * - **Condicion**
   - ``function_ids`` no es lista, lista
     vacia, o > 50 elementos;
     ``expires_at`` malformado o fuera de
     rango (< NOW() + 1h, > NOW() + 1 anio)
 * - **Response**
   - 400 VALIDATION_ERROR

5.13 Resumen de excepciones
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
   - Sin assign_functions
   - 403
   - UNAUTHORIZED — ALERTA
 * - EX-03
   - User no existe
   - 404
   - FUNCTIONS_ASSIGN_FAILED
 * - EX-04
   - User estado invalido
   - 400
   - FUNCTIONS_ASSIGN_FAILED
 * - EX-05
   - Auto-asignacion (P-11)
   - 400
   - FUNCTIONS_ASSIGN_FAILED — ALERTA alta
 * - EX-06
   - Funcion no existe
   - 400
   - (validacion)
 * - EX-07
   - Funcion inactiva
   - 400
   - (validacion)
 * - EX-08
   - SoD violacion
   - 409
   - FUNCTIONS_ASSIGN_FAILED — ALERTA
 * - EX-09
   - BD timeout
   - 503
   - FUNCTIONS_ASSIGN_FAILED
 * - EX-10
   - Audit fail
   - 500
   - (no se emite)
 * - EX-11
   - Rate limit
   - 429
   - (middleware)
 * - EX-12
   - Payload invalido
   - 400
   - (validacion)

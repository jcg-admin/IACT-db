.. _uc-usr-01-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Sin permiso create_users
===================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 5
 * - **Condicion**
   - Admin sin funcion ``create_users``
 * - **Response**
   - 403 FORBIDDEN
 * - **AuditEvent**
   - UNAUTHORIZED_ACCESS_ATTEMPT
     {attempted_action:'create_user'}

5.2 EX-02: Email ya existe
==========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 6
 * - **Response**
   - 409 CONFLICT
 * - **Body**
   - ``{"error":"EMAIL_EXISTS",
     "message":"El email ya esta registrado"}``
 * - **AuditEvent**
   - USER_CREATE_FAILED {reason:'email_exists'}

5.3 EX-03: Datos invalidos
==========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 6 (serializer)
 * - **Condicion**
   - email malformado, nombre vacio, etc.
 * - **Response**
   - 400 BAD_REQUEST
 * - **Body**
   - ``{"error":"VALIDATION_ERROR",
     "details":{...}}``

5.4 EX-04: Token invalido
=========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 5
 * - **Response**
   - 401 INVALID_TOKEN

5.5 EX-05: BD timeout
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 10-13
 * - **Accion**
   - ROLLBACK
 * - **Response**
   - 503 DB_TIMEOUT

5.6 EX-06: Mailbox INSERT falla
===============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 12
 * - **Accion**
   - ROLLBACK COMPLETO. CNST-002 obligatorio —
     sin mensaje, no se completa la creacion.
 * - **Response**
   - 500 MAILBOX_FAILED

5.7 EX-07: Audit INSERT falla
=============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 13
 * - **Accion**
   - ROLLBACK; CNST-025
 * - **Response**
   - 500 AUDIT_FAILED

5.8 EX-08: Username retry exhausted (FA-02)
===========================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 7-10 ciclo
 * - **Condicion**
   - 5 retries de username sin exito
 * - **Response**
   - 500 USERNAME_GENERATION_FAILED
 * - **Justificacion**
   - hot-spot inusual; investigar concurrencia

5.9 EX-09: Email externo prohibido
==================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 6
 * - **Condicion**
   - Setting ``REQUIRE_CORPORATE_EMAIL=True``
     y email no es del dominio corporativo
 * - **Response**
   - 400 EXTERNAL_EMAIL_FORBIDDEN

5.10 EX-10: AGR no existe / inactivo
====================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 11
 * - **Condicion**
   - ``access_group_id`` provisto pero el AGR
     no existe o ``state != 'ACTIVE'``
 * - **Response**
   - 400 INVALID_ACCESS_GROUP

5.11 Resumen
============

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - AuditEvent
 * - EX-01
   - Sin create_users
   - 403
   - UNAUTHORIZED_ACCESS_ATTEMPT
 * - EX-02
   - Email existe
   - 409
   - USER_CREATE_FAILED
 * - EX-03
   - Datos invalidos
   - 400
   - (validacion)
 * - EX-04
   - Token invalido
   - 401
   - USER_CREATE_FAILED
 * - EX-05
   - BD timeout
   - 503
   - USER_CREATE_FAILED
 * - EX-06
   - Mailbox fail
   - 500
   - USER_CREATE_FAILED
 * - EX-07
   - Audit fail
   - 500
   - (no se emite)
 * - EX-08
   - Username retry exhausted
   - 500
   - USER_CREATE_FAILED
 * - EX-09
   - Email externo
   - 400
   - USER_CREATE_FAILED
 * - EX-10
   - AGR invalido
   - 400
   - USER_CREATE_FAILED

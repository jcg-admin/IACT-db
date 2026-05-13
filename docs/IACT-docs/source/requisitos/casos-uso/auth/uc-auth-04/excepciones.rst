.. _uc-auth-04-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido / expirado
====================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 5
 * - **Condicion**
   - JWT invalido / expirado / blacklisted
 * - **Response**
   - 401
 * - **Body**
   - ``{"error": "INVALID_TOKEN"}``
 * - **AuditEvent**
   - PASSWORD_CHANGE_FAILED
     {reason: 'invalid_token'}

5.2 EX-02: Password actual incorrecto
=====================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 7
 * - **Condicion**
   - bcrypt.checkpw retorna False
 * - **Accion sistema**
   - delay defensivo (sleep 100-200ms aleatorio
     para mitigar timing attacks); incrementa
     contador de intentos (ver EX-08)
 * - **Response**
   - 400
 * - **Body**
   - ``{"error": "WRONG_CURRENT_PASSWORD",
     "message": "Contrasena actual
     incorrecta"}``
 * - **AuditEvent**
   - PASSWORD_CHANGE_FAILED
     {reason: 'wrong_current'}

5.3 EX-03: Nueva no cumple complejidad
======================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 8
 * - **Condicion**
   - Falla validador (longitud, charset,
     diccionario, similitud con username/email)
 * - **Response**
   - 400
 * - **Body**
   - ``{"error": "WEAK_PASSWORD", "message":
     "La nueva contrasena no cumple la
     politica.", "violations": ["min_length",
     "missing_uppercase", ...]}``
 * - **AuditEvent**
   - PASSWORD_CHANGE_FAILED
     {reason: 'policy_violation', violations}

La lista de violaciones se devuelve para que el
frontend pueda dar feedback util — pero nunca
indica el password ingresado en logs ni
respuesta.

5.4 EX-04: Reuso (esta en historial)
====================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 9
 * - **Condicion**
   - Nueva coincide con alguna de las ultimas
     N=5
 * - **Response**
   - 400
 * - **Body**
   - ``{"error": "PASSWORD_REUSED", "message":
     "No puedes reutilizar una de tus ultimas 5
     contrasenas."}``
 * - **BR**
   - BR-AUTH-32

5.5 EX-05: Nueva igual a la actual
==================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 9
 * - **Condicion**
   - bcrypt.checkpw(new, current_hash) == True
 * - **Response**
   - 400
 * - **Body**
   - ``{"error": "SAME_AS_CURRENT", "message":
     "La nueva contrasena debe ser distinta de
     la actual."}``

Es un caso particular de EX-04 (la actual
tambien esta en history) pero merece mensaje
propio para mejor UX.

5.6 EX-06: Nueva != confirmacion
================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 4 (validacion serializer)
 * - **Condicion**
   - ``new_password !=
     new_password_confirmation``
 * - **Response**
   - 400
 * - **Body**
   - ``{"error": "MISMATCH", "message":
     "La confirmacion no coincide con la nueva
     contrasena."}``

5.7 EX-07: BD timeout
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 10-13
 * - **Condicion**
   - OperationalError
 * - **Accion**
   - ROLLBACK
 * - **Response**
   - 503

5.8 EX-08: Demasiados intentos fallidos
=======================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 7 (acumulado)
 * - **Condicion**
   - 5 EX-02 consecutivos en 5 minutos para el
     mismo user
 * - **Accion**
   - bloqueo temporal del endpoint para ese
     user 5 min; emite AuditEvent
     SUSPICIOUS_PASSWORD_CHANGE_ATTEMPTS
 * - **Response**
   - 429
 * - **Body**
   - ``{"error": "TOO_MANY_ATTEMPTS",
     "retry_after": 300}``

5.9 EX-09: Audit INSERT fail
============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Paso de origen**
   - PASO 13
 * - **Accion**
   - ROLLBACK; CNST-025
 * - **Response**
   - 500

5.10 Resumen
============

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
   - PASSWORD_CHANGE_FAILED
 * - EX-02
   - Password actual incorrecto
   - 400
   - PASSWORD_CHANGE_FAILED (wrong_current)
 * - EX-03
   - Politica
   - 400
   - PASSWORD_CHANGE_FAILED (policy_violation)
 * - EX-04
   - Reuso
   - 400
   - PASSWORD_CHANGE_FAILED (reused)
 * - EX-05
   - Igual a actual
   - 400
   - PASSWORD_CHANGE_FAILED (same_as_current)
 * - EX-06
   - Mismatch confirmation
   - 400
   - (no audit)
 * - EX-07
   - BD timeout
   - 503
   - PASSWORD_CHANGE_FAILED (db_timeout)
 * - EX-08
   - Brute force intento
   - 429
   - SUSPICIOUS_PASSWORD_CHANGE_ATTEMPTS
 * - EX-09
   - Audit INSERT fail
   - 500
   - (no se emite)

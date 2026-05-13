.. _uc-usr-02-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido
=========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - Cualquier sub-flujo, validacion JWT
 * - **Response**
   - 401 INVALID_TOKEN

5.2 EX-02: Sin permiso de listado
=================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - Sub-flujo 3.A
 * - **Condicion**
   - Sin funcion ``list_users``
 * - **Response**
   - 403 FORBIDDEN
 * - **AuditEvent**
   - UNAUTHORIZED_ACCESS_ATTEMPT
     {attempted_action:'list_users'}

5.3 EX-03: Sin permiso de detalle
=================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - Sub-flujo 3.B
 * - **Condicion**
   - Sin funcion ``view_users``
 * - **Response**
   - 403 FORBIDDEN
 * - **AuditEvent**
   - UNAUTHORIZED_ACCESS_ATTEMPT
     {attempted_action:'view_user',
     target_user_id}

5.4 EX-04: User no encontrado
=============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - Sub-flujo 3.B PASO 4
 * - **Condicion**
   - ``user_id`` no existe
 * - **Response**
   - 404 USER_NOT_FOUND

5.5 EX-05: Filtro malformado
============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - Sub-flujo 3.A PASO 5
 * - **Condicion**
   - Filtro fuera del whitelist
     (``ordering=arbitrary_field``,
     ``state=INVALID``,
     ``created_after=not-a-date``)
 * - **Response**
   - 400 BAD_FILTER

5.6 EX-06: Throttling
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - Antes del sub-flujo
 * - **Condicion**
   - >150 GET/min/invocante (CNST-011)
 * - **Response**
   - 429 RATE_LIMIT

5.7 Resumen
===========

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
   - (auth middleware log)
 * - EX-02
   - Sin list_users
   - 403
   - UNAUTHORIZED_ACCESS_ATTEMPT
 * - EX-03
   - Sin view_users
   - 403
   - UNAUTHORIZED_ACCESS_ATTEMPT
 * - EX-04
   - User no existe
   - 404
   - (no audit)
 * - EX-05
   - Filtro malformado
   - 400
   - (no audit)
 * - EX-06
   - Rate limit
   - 429
   - (middleware)

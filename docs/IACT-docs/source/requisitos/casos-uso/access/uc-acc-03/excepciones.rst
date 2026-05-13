.. _uc-acc-03-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido
=========================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 3
 * - **Response**
   - 401 INVALID_TOKEN

5.2 EX-02: Sin funcion view_assignments
=======================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 4
 * - **Condicion**
   - sin funcion ``view_assignments`` y NO
     es self-view (``user_id !=
     invoker.id``)
 * - **Response**
   - 403 FORBIDDEN
 * - **AuditEvent**
   - UNAUTHORIZED_ACCESS_ATTEMPT
     {attempted_action:
     'view_effective_permissions',
     target_user_id} — alerta media

5.3 EX-03: User no encontrado
=============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - PASO 5
 * - **Response**
   - 404 USER_NOT_FOUND

5.4 EX-04: Throttling
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - antes de PASO 3
 * - **Condicion**
   - > 100 GET/min/invoker (CNST-011 — limite
     mas alto que escrituras dado que es
     read)
 * - **Response**
   - 429 RATE_LIMIT

5.5 Resumen
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
   - (middleware)
 * - EX-02
   - Sin view_assignments y no self
   - 403
   - UNAUTHORIZED_ACCESS_ATTEMPT
 * - EX-03
   - User no existe
   - 404
   - (sin audit)
 * - EX-04
   - Rate limit
   - 429
   - (middleware)

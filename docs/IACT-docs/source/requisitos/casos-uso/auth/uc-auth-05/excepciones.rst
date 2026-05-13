.. _uc-auth-05-parte-05:

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

5.2 EX-02: Sin permiso de lectura
=================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - Sub-flujo 3.A
 * - **Condicion**
   - Sin funcion ``view_all_active_sessions``
 * - **Response**
   - 403 FORBIDDEN
 * - **AuditEvent**
   - UNAUTHORIZED_ACCESS_ATTEMPT
     {attempted_action: 'view_sessions'}

5.3 EX-03: Sin permiso de cierre
================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - Sub-flujo 3.B / 3.C
 * - **Condicion**
   - Sin funcion ``close_user_session``
 * - **Response**
   - 403 FORBIDDEN
 * - **AuditEvent**
   - UNAUTHORIZED_ACCESS_ATTEMPT
     {attempted_action: 'close_session',
     target_session_id}

5.4 EX-04: Auto-cierre masivo prohibido
=======================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - Sub-flujo 3.C
 * - **Condicion**
   - ``target_user_id == admin.id`` y setting
     ``ALLOW_ADMIN_SELF_BULK_CLOSE=False``
     (default)
 * - **Response**
   - 400 SELF_BULK_CLOSE_FORBIDDEN
 * - **Body**
   - ``{"error": "SELF_BULK_CLOSE_FORBIDDEN",
     "message": "No puedes cerrar todas tus
     propias sesiones por esta via. Usa Cerrar
     sesion (UC_AUTH_02)."}``

5.5 EX-05: Session no encontrada
================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - Sub-flujo 3.B PASO 7
 * - **Condicion**
   - ``session_id`` no existe en BD
 * - **Response**
   - 404 SESSION_NOT_FOUND

5.6 EX-06: User no encontrado
=============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - Sub-flujo 3.C
 * - **Condicion**
   - ``user_id`` no existe
 * - **Response**
   - 404 USER_NOT_FOUND

5.7 EX-07: BD timeout
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - 3.B PASO 8 / 3.C PASO 8
 * - **Condicion**
   - OperationalError
 * - **Response**
   - 503

5.8 EX-08: AuditEvent INSERT fail
=================================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - 3.B PASO 10 / 3.C PASO 10
 * - **Condicion**
   - INSERT en AuditEvent falla
 * - **Accion**
   - ROLLBACK; CNST-025
 * - **Response**
   - 500

5.9 EX-09: Throttling
=====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - Antes de cualquier sub-flujo
 * - **Condicion**
   - > 100 req/min/admin (CNST-011)
 * - **Response**
   - 429 RATE_LIMIT

5.10 EX-10: Filtro malformado
=============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen**
   - 3.A PASO 5
 * - **Condicion**
   - ``created_after`` parseable pero no
     fecha valida; ``state`` con valor
     desconocido
 * - **Response**
   - 400 BAD_FILTER
 * - **Body**
   - ``{"error": "BAD_FILTER", "details":
     {"created_after": "Fecha invalida"}}``

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
   - Token invalido
   - 401
   - SESSION_OP_FAILED
 * - EX-02
   - Sin view_all
   - 403
   - UNAUTHORIZED_ACCESS_ATTEMPT
 * - EX-03
   - Sin close
   - 403
   - UNAUTHORIZED_ACCESS_ATTEMPT
 * - EX-04
   - Auto-bulk-close
   - 400
   - SESSION_OP_FAILED — ALERTA
 * - EX-05
   - Session no existe
   - 404
   - (ninguno)
 * - EX-06
   - User no existe
   - 404
   - (ninguno)
 * - EX-07
   - BD timeout
   - 503
   - SESSION_OP_FAILED
 * - EX-08
   - Audit fail
   - 500
   - (no se emite)
 * - EX-09
   - Rate limit
   - 429
   - (middleware)
 * - EX-10
   - Filtro malformado
   - 400
   - (ninguno)

.. _uc-usr-02-parte-07:

============================
Parte 7 — Datos involucrados
============================

7.1 Endpoints
=============

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Endpoint
   - Metodo
   - Funcion RBAC
 * - ``/api/users/``
   - GET
   - ``list_users``
 * - ``/api/users/{user_id}/``
   - GET
   - ``view_users``

7.2 GET /api/users/ — query params
==================================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Param
   - Significado
 * - ``state``
   - filtro por state (default: todos excepto
     ELIMINATED)
 * - ``access_group_id``
   - User con ese AGR activo (FA-03)
 * - ``user_id``
   - filter especifico (FA-02 — audit)
 * - ``search``
   - busqueda fuzzy en username, email,
     full_name
 * - ``created_after``
   - ISO datetime
 * - ``created_before``
   - ISO datetime
 * - ``ordering``
   - col whitelist (``created_at``,
     ``-created_at``, ``last_login_at``,
     ``username``)
 * - ``page``
   - default 1
 * - ``page_size``
   - default 50, max 200

7.3 Response 200 — listado
==========================

.. code-block:: json

   {
     "count": 187,
     "next": "/api/users/?page=2",
     "previous": null,
     "results": [
       {
         "id": 42,
         "username": "ana.gomez.0001",
         "email_masked": "a***@empresa.com",
         "full_name_initials": "AG",
         "state": "ACTIVE",
         "created_at": "2026-04-15T10:00:00Z",
         "last_login_at": "2026-05-01T08:30:00Z",
         "active_agr_ids": [6]
       }
     ]
   }

Email mascarado en listado (CNST-026 — politica
configurable).

7.4 Response 200 — detalle
==========================

.. code-block:: json

   {
     "id": 42,
     "username": "ana.gomez.0001",
     "email": "ana.gomez@empresa.com",
     "first_name": "Ana",
     "last_name": "Gomez",
     "state": "ACTIVE",
     "first_login": false,
     "created_at": "2026-04-15T10:00:00Z",
     "created_by_admin_id": 1,
     "password_changed_at": "2026-04-15T10:30:00Z",
     "last_login_at": "2026-05-01T08:30:00Z",
     "is_inactive": false,
     "self_view": false,
     "active_assignments": [
       {
         "access_group_id": 6,
         "access_group_name": "user_admin_group",
         "granted_at": "2026-04-15T10:00:00Z",
         "granted_by_admin_id": 1
       }
     ],
     "active_sessions_count": 1
   }

En detalle el email se muestra completo (el
invocante tiene ``view_users``, privilegio
suficiente para PII).

7.5 Datos NO tocados
====================

- Lectura pura. Sin INSERT/UPDATE/DELETE
  excepto AuditEvent (P-16 selectivo).

7.6 AuditEvent (escritura — INSERT en P-16)
===========================================

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Cuando emitir
   - event_type
   - payload
 * - Listado con filter user_id
   - USERS_VIEWED_FOR_USER
   - {target_user_id}
 * - Vista detalle de User
   - USER_DETAIL_VIEWED
   - {target_user_id, target_state, self_view}
 * - Listado amplio (sin filter user_id)
   - (no audit)
   - —
 * - 403 sin permiso
   - UNAUTHORIZED_ACCESS_ATTEMPT
   - {attempted_action, target_user_id?}

7.7 FR derivados (Nivel 4) — preliminar
=======================================

.. list-table::
 :widths: 20 20 60
 :header-rows: 1

 * - FR ID
   - Sub-flujo / Paso
   - Capacidad
 * - FR-USR-02-01
   - 3.A § 4
   - Verificar list_users
 * - FR-USR-02-02
   - 3.A § 5
   - Construir query con filtros y ordering
     whitelist
 * - FR-USR-02-03
   - 3.A § 6
   - Paginar resultados
 * - FR-USR-02-04
   - 3.A § 7
   - Restringir campos sensibles (CNST-026)
 * - FR-USR-02-05
   - 3.A § 8
   - Audit selectivo P-16
 * - FR-USR-02-06
   - 3.B § 3
   - Verificar view_users
 * - FR-USR-02-07
   - 3.B § 4
   - Localizar User
 * - FR-USR-02-08
   - 3.B § 5
   - Cargar Assignments + AGRs activos
 * - FR-USR-02-09
   - 3.B § 7
   - Audit USER_DETAIL_VIEWED

Generacion detallada queda como WP futuro
(per DEC-10 del WP de mapeo).

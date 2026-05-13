.. _uc-usr-02-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 Implementacion **abstracta** — contratos +
 pseudocodigo + responsabilidades. Stack
 concreto en ``arquitectura-tecnica/``.

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPListEndpoint**
   - GET ``/api/users/`` con query params
 * - **HTTPDetailEndpoint**
   - GET ``/api/users/{id}/``
 * - **AuthenticationGuard**
   - Validar token (CNST-009)
 * - **AuthorizationGuard**
   - Verificar ``list_users`` o ``view_users``
     segun endpoint (P-15)
 * - **ThrottlePolicy**
   - 150 GET/min/invocante (CNST-011)
 * - **FilterValidator**
   - Whitelist de fields y ordering (P-20)
 * - **QueryBuilder**
   - Compone Specifications en query
 * - **UserRepository**
   - list_paginated, get_by_id
 * - **AssignmentRepository**
   - list_active_for_user
 * - **MaskingStrategy**
   - Aplica restriccion de campos PII en
     listado (P-19)
 * - **AuditLog**
   - Audit selectivo P-16

11.2 Contratos
==============

::

   contract UserService:
     list_users(filters: Filters,
                pagination: Pagination,
                ordering: opt[Order],
                invoker: AuthenticatedUser)
       returns: PaginatedResult<UserListItem>
       throws: SinPermiso (sin list_users),
               BadFilter

     get_user_detail(user_id: int,
                     invoker: AuthenticatedUser)
       returns: UserDetail
       throws: SinPermiso (sin view_users),
               UserNotFound

   data Filters:
     state: opt[enum]
     access_group_id: opt[int]
     user_id: opt[int]
     search: opt[string]
     created_after: opt[timestamp]
     created_before: opt[timestamp]

   data Pagination:
     page: int >= 1
     page_size: int (1..200)

   data Order:
     field: enum {created_at, last_login_at,
                  username}
     direction: enum {asc, desc}

   data UserListItem:
     id: int
     username: string
     email_masked: string
     full_name_initials: string
     state: enum
     created_at: timestamp
     last_login_at: opt[timestamp]
     active_agr_ids: list[int]
     # NO contiene: email completo, full_name,
     # password_hash

   data UserDetail:
     # Todos los campos no-secretos
     id, username, email, first_name, last_name,
     state, first_login, created_at,
     created_by_admin_id, password_changed_at,
     last_login_at, is_inactive, self_view,
     active_assignments: list[AssignmentDetail],
     active_sessions_count: int

   contract AuditLog:
     emit_users_viewed_for_user(invoker_id,
                                 target_user_id)
     emit_user_detail_viewed(invoker_id,
                              target_user_id,
                              target_state,
                              self_view)

11.3 Pseudocodigo del flujo principal
=====================================

11.3.1 Listar (sub-flujo 3.A)
-----------------------------

::

   procedure list_users(filters, pagination,
                        ordering, invoker):

       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker, 'list_users')
       require ThrottlePolicy.is_allowed(invoker)

       FilterValidator.validate(filters, ordering)

       query = QueryBuilder
                 .where(default_state_filter)
                 .apply(filters)
                 .order_by(ordering or default_order)

       (rows, total) = UserRepository
                         .list_paginated(query,
                                          pagination)

       items = [MaskingStrategy.apply_listing(row)
                for row in rows]

       if filters.user_id is not None:
           AuditLog.emit_users_viewed_for_user(
               invoker_id = invoker.id,
               target_user_id = filters.user_id)

       return PaginatedResult(
           count = total,
           page = pagination.page,
           page_size = pagination.page_size,
           results = items)

11.3.2 Ver detalle (sub-flujo 3.B)
----------------------------------

::

   procedure get_user_detail(user_id, invoker):

       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker, 'view_users')

       user = UserRepository.get_by_id(user_id)
       if user is None:
           raise UserNotFound

       assignments = AssignmentRepository
                       .list_active_for_user(user)

       sessions_count = SessionRepository
                          .count_active(user)

       AuditLog.emit_user_detail_viewed(
           invoker_id = invoker.id,
           target_user_id = user.id,
           target_state = user.state,
           self_view = (invoker.id == user.id))

       return UserDetail(
           # ... campos del User ...
           is_inactive = (user.state != ACTIVE),
           self_view = (invoker.id == user.id),
           active_assignments = assignments,
           active_sessions_count = sessions_count)

11.4 Mapeo excepcion → respuesta
================================

.. list-table::
 :widths: 35 30 35
 :header-rows: 1

 * - Excepcion
   - Status HTTP
   - Body code
 * - sin token
   - 401
   - INVALID_TOKEN
 * - SinPermiso (list_users)
   - 403
   - FORBIDDEN
 * - SinPermiso (view_users)
   - 403
   - FORBIDDEN
 * - UserNotFound
   - 404
   - USER_NOT_FOUND
 * - BadFilter
   - 400
   - BAD_FILTER
 * - throttle exceeded
   - 429
   - RATE_LIMIT

11.5 Restricciones cross-cutting
================================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Restriccion
   - Implementacion
 * - **PII restriction listing** (CNST-026)
   - MaskingStrategy aplica antes de la
     respuesta. Validable por test que
     inspecciona keys del item.
 * - **Anti-SQLi** (P-20)
   - FilterValidator rechaza ordering /
     state / search fields fuera de whitelist
     ANTES del QueryBuilder.
 * - **Audit selectivo** (P-16)
   - Decision binaria en el servicio:
     ``filters.user_id is not None`` triggera
     audit en listado. Detalle siempre auditado.
 * - **Idempotencia / Read-only**
   - El servicio NO modifica estado del
     dominio. Solo AuditLog (append-only).

11.6 Indices recomendados (orientativos)
========================================

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - Tabla
   - Indice
 * - users
   - (state, created_at)
 * - users
   - email
 * - users
   - username
 * - users
   - last_login_at
 * - assignment
   - (user_id, state)

11.7 Stack-agnostico
====================

Cualquier stack que respete los contratos
satisface el UC. La implementacion concreta es
informativa y vive en
``arquitectura-tecnica/``.

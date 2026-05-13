.. _uc-usr-02-parte-12:

==========================
Parte 12 — Testing
==========================

.. note::

 Tests en pseudocodigo Given/When/Then alineado
 con CA. Stack-agnostico.

12.1 Pyramid
============

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Capa
   - Cantidad
   - Cobertura objetivo
 * - Unit
   - 8
   - ≥ 90% lineas
 * - Integration
   - 9
   - sub-flujos + EXs + CNSTs
 * - E2E
   - 3
   - listado + detalle + sin-permiso

12.2 Tests unitarios
====================

12.2.1 list_users default state filter
--------------------------------------

::

   GIVEN repo con Users en {ACTIVE, INACTIVE,
                            BLOCKED, ELIMINATED}
   WHEN  list_users sin filtro state
   THEN  ELIMINATED ausente del resultado

12.2.2 list_users paginacion (CA-01)
------------------------------------

::

   GIVEN repo con 187 Users
   WHEN  list_users(page=1, page_size=50)
   THEN  count == 187, results.length == 50

12.2.3 MaskingStrategy listing (CA-02)
--------------------------------------

::

   GIVEN un row de User con email completo
   WHEN  MaskingStrategy.apply_listing(row)
   THEN  result.email_masked NOT contains email
     AND result no tiene password_hash
     AND result no tiene first_name completo

12.2.4 FilterValidator whitelist (CA-12)
----------------------------------------

::

   GIVEN ordering = "arbitrary; DROP TABLE"
   WHEN  FilterValidator.validate
   THEN  raise BadFilter

12.2.5 Audit selectivo P-16 (CA-07, CA-08)
------------------------------------------

::

   GIVEN list_users sin filter user_id
   WHEN  procesa
   THEN  AuditLog.emit_users_viewed_for_user
         NOT invocado

   GIVEN list_users con filter user_id=42
   WHEN  procesa
   THEN  AuditLog.emit_users_viewed_for_user
         invocado con target_user_id=42

12.2.6 get_user_detail audit siempre (CA-09)
--------------------------------------------

::

   GIVEN view_users + user existe
   WHEN  get_user_detail(user_id)
   THEN  AuditLog.emit_user_detail_viewed
         invocado

12.2.7 self_view marcado (CA-10)
--------------------------------

::

   GIVEN invoker.id == user_id consultado
   WHEN  get_user_detail
   THEN  result.self_view == true
     AND audit payload self_view=true

12.2.8 UserNotFound (EX-04)
---------------------------

::

   GIVEN user_id no existe
   WHEN  get_user_detail
   THEN  raise UserNotFound

12.3 Tests de integracion
=========================

12.3.1 Endpoint list 200 (CA-01)
--------------------------------

::

   GIVEN invoker con list_users + 5 Users
   WHEN  GET /api/users/
   THEN  status == 200
     AND count >= 5

12.3.2 Sin list_users 403 (CA-04)
---------------------------------

::

   GIVEN invoker sin list_users
   WHEN  GET /api/users/
   THEN  status == 403
     AND AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT

12.3.3 Sin view_users 403 (CA-05)
---------------------------------

::

   GIVEN invoker con list_users pero sin
         view_users
   WHEN  GET /api/users/{id}/
   THEN  status == 403

12.3.4 User no existe 404 (CA-06)
---------------------------------

::

   GIVEN user_id 99999 no existe
   WHEN  GET /api/users/99999/
   THEN  status == 404

12.3.5 Filter user_id audita (CA-07)
------------------------------------

::

   GIVEN invoker con list_users
   WHEN  GET /api/users/?user_id=42
   THEN  AuditEvent USERS_VIEWED_FOR_USER con
         payload.target_user_id == 42

12.3.6 Listado amplio NO audita (CA-08)
---------------------------------------

::

   GIVEN invoker con list_users
   WHEN  GET /api/users/
   THEN  ZERO AuditEvent USERS_VIEWED_FOR_USER

12.3.7 Detalle audita (CA-09)
-----------------------------

::

   GIVEN invoker con view_users + user existe
   WHEN  GET /api/users/{id}/
   THEN  AuditEvent USER_DETAIL_VIEWED

12.3.8 Anti-SQLi ordering (CA-12)
---------------------------------

::

   GIVEN ordering = "x; DROP TABLE users; --"
   WHEN  GET /api/users/?ordering=...
   THEN  status == 400 BAD_FILTER
     AND tabla users intacta

12.3.9 Email mascarado en listing (CA-02)
-----------------------------------------

::

   GIVEN GET /api/users/
   WHEN  inspecciono cualquier item
   THEN  item.email completo no presente
     AND email mascarado / dominio o ausente

12.4 Tests E2E
==============

12.4.1 Admin lista y filtra
---------------------------

::

   GIVEN admin autenticado en UI
   WHEN  navega a "Usuarios", aplica filtro
         state=ACTIVE
   THEN  tabla muestra solo ACTIVE
     AND paginacion funcional

12.4.2 Admin abre detalle
-------------------------

::

   GIVEN admin con view_users
   WHEN  click en row de User
   THEN  vista detalle muestra Assignments,
         AGRs, last_login

12.4.3 Sin permiso, no acceso a vista
-------------------------------------

::

   GIVEN user sin list_users en UI
   WHEN  intenta navegar a /admin/users
   THEN  vista oculta o 403

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente logico
   - Lineas
   - Branches
 * - UserService.list_users
   - ≥ 90%
   - ≥ 85%
 * - UserService.get_user_detail
   - ≥ 95%
   - ≥ 90%
 * - FilterValidator
   - 100%
   - 100%
 * - MaskingStrategy
   - 100%
   - 100%
 * - AuthorizationGuard
   - 100%
   - 100%

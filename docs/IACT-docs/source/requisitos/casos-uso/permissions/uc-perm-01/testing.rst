.. _uc-perm-01-parte-12:

==========================
Parte 12 — Testing
==========================

.. note::

 Tests Given/When/Then. Stack-agnostico.
 Tests backend heredados de UC_ACC_04 Parte
 12. Esta parte documenta tests especificos
 de la vista PERM.

12.1 Pyramid
============

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Capa
   - Cantidad (incluye heredados)
   - Cobertura objetivo
 * - Unit (delta vs UC_ACC_04)
   - 6
   - ≥ 90%
 * - Integration (delta)
   - 7
   - sub-flujos UI especificos
 * - E2E
   - 3
   - flujos UI vista PERM

12.2 Tests unitarios especificos PERM
=====================================

12.2.1 AGRCatalogService.list
-----------------------------

::

   GIVEN BD con N AGRs
   WHEN  list()
   THEN  PaginatedResult con counts
         (function_count, users_count)

12.2.2 AGRCatalogService.get_detail
-----------------------------------

::

   GIVEN agr_id valido
   WHEN  get_detail
   THEN  AGRDetail con composicion completa

12.2.3 AssignPreviewService.preview
-----------------------------------

::

   GIVEN AGR con 8 functions
     AND target con 2 ya directas
   WHEN  preview
   THEN  functions_to_add_count == 6
   AND   functions_already_present_count == 2

12.2.4 Preview NO persiste (CA-PERM-03)
---------------------------------------

::

   GIVEN preview ejecutado
   WHEN  inspecciono BD
   THEN  ZERO Assignment creado
   AND   ZERO AuditEvent

12.2.5 Preview detecta SoD violations
-------------------------------------

::

   GIVEN AGR con funcion en conflicto SoD
   WHEN  preview
   THEN  estimated_sod_violations > 0
   AND   warnings lista regla SoD

12.2.6 Cache catalogo invalidate post-asignacion
------------------------------------------------

::

   GIVEN catalogo cached
   WHEN  asignacion exitosa
   THEN  AGRViewCache.invalidate llamado
   AND   next request recompute counts

12.3 Tests de integracion especificos PERM
==========================================

12.3.1 GET catalogo (CA-PERM-01)
--------------------------------

::

   GIVEN invoker con view permiso
   WHEN  GET /api/access-groups/
   THEN  status == 200 con counts

12.3.2 GET detalle AGR
----------------------

::

   GIVEN agr_id valido
   WHEN  GET /api/access-groups/{id}/
   THEN  status == 200
   AND   body con composicion completa

12.3.3 GET users-por-AGR
------------------------

::

   GIVEN AGR con 5 Users asignados
   WHEN  GET /api/access-groups/{id}/users/
   THEN  body.results.length == 5
         (paginated)

12.3.4 GET preview-assign (CA-PERM-03)
--------------------------------------

::

   GIVEN target + agr validos
   WHEN  GET preview-assign
   THEN  status == 200
   AND   body con counts e impact
   AND   ZERO Assignment / AuditEvent
         creados

12.3.5 POST asignacion via vista PERM
-------------------------------------

::

   GIVEN invoker con assign_function_groups
   WHEN  POST a /api/users/{id}/access-groups/
   THEN  comportamiento identico a UC_ACC_04
   AND   AuditEvent.event_type == 'AGR_ASSIGNED'

12.3.6 Audit no distingue origen UI (CA-PERM-05)
------------------------------------------------

::

   GIVEN dos asignaciones (1 via ACC, 1 via PERM)
   WHEN  inspecciono AuditEvents
   THEN  ambos con event_type
         AGR_ASSIGNED
   AND   payload no distingue origen

12.3.7 Catalogo refresh post-asignacion (CA-PERM-04)
----------------------------------------------------

::

   GIVEN catalogo con users_count = 3
   WHEN  asignacion exitosa
   AND   GET catalogo
   THEN  users_count == 4 (refrescado)

12.4 E2E
========

12.4.1 Admin de seguridad asigna desde catalogo
-----------------------------------------------

::

   GIVEN admin con assign_function_groups en
         vista PERM
   WHEN  abre catalogo, selecciona AGR-006,
         selecciona User, ve modal con 8
         funciones, confirma
   THEN  toast confirma
   AND   catalogo refleja count +1

12.4.2 Preview muestra impact antes de
confirmar
--------------------------------------

::

   GIVEN admin selecciona AGR + User
   WHEN  abre modal
   THEN  modal muestra:
         - functions_to_add_count
         - functions_already_present_count
         - warnings de SoD si aplican

12.4.3 Boton oculto sin permiso (CA-PERM-06)
--------------------------------------------

::

   GIVEN invoker sin assign_function_groups
   WHEN  abre catalogo
   THEN  boton "Asignar" no visible

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente
   - Lineas
   - Branches
 * - AGRCatalogService
   - ≥ 95%
   - ≥ 90%
 * - AssignPreviewService
   - 100%
   - 100%
 * - AGRViewCache
   - ≥ 90%
   - ≥ 85%
 * - HTTP*Endpoint (UI)
   - ≥ 90%
   - ≥ 85%

Backend: cobertura heredada de UC_ACC_04.

12.6 Resumen
============

.. list-table::
 :widths: 15 35 50
 :header-rows: 1

 * - Capa
   - Test
   - CA cubierto
 * - Unit
   - AGRCatalogService.list / get_detail
   - CA-PERM-01, CA-PERM-02
 * - Unit
   - AssignPreviewService.preview
   - CA-PERM-03
 * - Unit
   - Cache invalidate post-asignacion
   - CA-PERM-04
 * - Integration
   - GET catalogo / detalle / users
   - CA-PERM-01..02
 * - Integration
   - GET preview no persiste
   - CA-PERM-03
 * - Integration
   - audit unificado
   - CA-PERM-05
 * - E2E
   - Asignacion via catalogo
   - flujo completo
 * - E2E
   - Preview en modal
   - CA-PERM-02..03
 * - E2E
   - Boton oculto
   - CA-PERM-06

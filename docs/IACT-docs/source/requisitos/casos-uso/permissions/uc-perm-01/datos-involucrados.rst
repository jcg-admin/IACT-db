.. _uc-perm-01-parte-07:

============================
Parte 7 — Datos involucrados
============================

.. note::

 Datos backend identicos a UC_ACC_04 Parte 7.
 Esta parte agrega los datos read-only que
 alimentan la vista UI PERM.

7.1 Endpoints (compartidos + UI especificos)
============================================

.. list-table::
 :widths: 35 25 40
 :header-rows: 1

 * - Endpoint
   - Metodo
   - Comentario
 * - ``/api/users/{id}/access-groups/``
   - POST
   - Backend compartido con UC_ACC_04
 * - ``/api/access-groups/``
   - GET
   - Catalogo AGRs (vista PERM principal)
 * - ``/api/access-groups/{id}/``
   - GET
   - Detalle AGR + users count
 * - ``/api/access-groups/{id}/users/``
   - GET
   - Users que tienen este AGR
 * - ``/api/access-groups/{id}/preview-assign/``
   - GET
   - Preview de impact (FA-08)

7.2 Request/Response asignacion
===============================

Identicos a UC_ACC_04 Parte 7.

7.3 GET catalogo de AGRs
========================

.. code-block:: json

   {
     "count": 12,
     "results": [
       {
         "id": 6,
         "code": "user_admin_group",
         "display_name": "Administrador de Usuarios",
         "function_count": 8,
         "users_count": 3,
         "is_predefined": true,
         "state": "ACTIVE"
       }
     ]
   }

7.4 GET detalle AGR
===================

Body con composicion completa (functions
contenidas) + users que lo tienen
(paginated).

7.5 GET preview-assign
======================

.. code-block:: json

   {
     "agr_id": 6,
     "target_user_id": 42,
     "agr_total_functions": 8,
     "functions_already_present_count": 2,
     "functions_to_add_count": 6,
     "estimated_sod_violations": 0,
     "warnings": []
   }

NO persiste. NO genera AuditEvent.

7.6 Modelo de datos consultado / escrito
========================================

Escritura: identica a UC_ACC_04 (Assignment
con target_type='AccessGroup').

Lectura adicional para vista PERM:

- ``AccessGroup`` (catalogo).
- ``AccessGroupFunction`` (composicion).
- COUNT users-por-AGR (puede cachearse).

7.7 FR derivados — preliminar
=============================

Backend: heredados de UC_ACC_04.

UI PERM agrega:

- FR-PERM-01-A: GET listado AGRs paginado.
- FR-PERM-01-B: GET detalle AGR con
  composicion + users.
- FR-PERM-01-C: GET preview-assign sin
  persistir.
- FR-PERM-01-D: Cache invalidation de
  catalogo post-asignacion.

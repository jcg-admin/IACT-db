.. _uc-perm-05-parte-12:

==========================
Parte 12 — Testing
==========================

12.1 Pyramid
============

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Capa
   - Cantidad
   - Cobertura
 * - Unit
   - 14
   - ≥ 90%
 * - Integration
   - 13
   - sub-flujos + EXs
 * - E2E
   - 4
   - flujos UI

12.2 Tests unitarios
====================

12.2.1 Crear happy
------------------

::

   GIVEN payload valido
   WHEN  create
   THEN  AccessGroup ACTIVE creado
   AND   AuditEvent ACCESS_GROUP_CREATED

12.2.2 Code duplicado (CA-02)
-----------------------------

::

   GIVEN code existente
   WHEN  create
   THEN  raise CodeDuplicate

12.2.3 Code formato (CA-03)
---------------------------

::

   GIVEN code = "Bad-Code"
   WHEN  create
   THEN  raise ValidationError

12.2.4 Crear con composicion (CA-04, FA-01)
-------------------------------------------

::

   GIVEN initial_function_ids = [1, 2, 3]
   WHEN  create
   THEN  3 AccessGroupFunction insertados

12.2.5 PATCH parcial (CA-05)
----------------------------

::

   GIVEN PATCH solo display_name
   WHEN  modify
   THEN  display_name actualizado, otros
         preservados

12.2.6 Code immutable (CA-06)
-----------------------------

::

   GIVEN PATCH con code
   WHEN  modify
   THEN  raise CodeImmutable

12.2.7 Predefinido no mutable (CA-07)
-------------------------------------

::

   GIVEN AGR is_predefined=true
   WHEN  modify / retire
   THEN  raise PredefinedNotMutable

12.2.8 Retirar happy (CA-08)
----------------------------

::

   GIVEN AGR custom ACTIVE + reason
   WHEN  retire
   THEN  state=RETIRED + metadata
   AND   AuditEvent ACCESS_GROUP_RETIRED

12.2.9 Reason corto (CA-09)
---------------------------

::

   GIVEN reason 5 chars
   WHEN  retire
   THEN  raise ValidationError

12.2.10 Ya RETIRED (CA-10)
--------------------------

::

   GIVEN AGR state=RETIRED
   WHEN  modify / retire
   THEN  raise AlreadyRetired

12.2.11 Retirar con Users default warn (CA-11)
----------------------------------------------

::

   GIVEN politica default warn-only +
         5 Users con AGR
   WHEN  retire
   THEN  no lanza
   AND   output incluye
         users_with_agr_count = 5

12.2.12 Retirar strict block (CA-12)
------------------------------------

::

   GIVEN politica strict + Users > 0
   WHEN  retire
   THEN  raise RetireHasUsers

12.2.13 Assignments preservados (CA-14)
---------------------------------------

::

   GIVEN AGR retirado con Users
   WHEN  inspecciono Assignments
   THEN  todos permanecen ACTIVE

12.2.14 Audit con counts (CA-08)
--------------------------------

::

   GIVEN retire exitoso con 3 Users
   WHEN  inspecciono AuditEvent
   THEN  payload.users_with_agr_count = 3

12.3 Integracion
================

12.3.1 POST 201
---------------

::

   GIVEN payload valido
   WHEN  POST /api/access-groups/
   THEN  status == 201

12.3.2 POST duplicado 409
-------------------------

::

   GIVEN code existente
   WHEN  POST
   THEN  status == 409

12.3.3 POST formato 400
-----------------------

::

   GIVEN code "MAYUS"
   WHEN  POST
   THEN  status == 400

12.3.4 PATCH 200
----------------

::

   GIVEN PATCH valido
   WHEN  PATCH
   THEN  status == 200

12.3.5 PATCH code 400
---------------------

::

   GIVEN PATCH con code
   WHEN  PATCH
   THEN  status == 400 CODE_IMMUTABLE

12.3.6 PATCH predefinido 400
----------------------------

::

   GIVEN AGR-006 predefinido
   WHEN  PATCH
   THEN  status == 400 PREDEFINED_NOT_MUTABLE

12.3.7 DELETE 200
-----------------

::

   GIVEN DELETE con reason
   WHEN  DELETE
   THEN  status == 200

12.3.8 DELETE sin reason 400
----------------------------

::

   GIVEN sin reason
   WHEN  DELETE
   THEN  status == 400

12.3.9 DELETE ya RETIRED 400
----------------------------

::

   GIVEN AGR RETIRED
   WHEN  DELETE
   THEN  status == 400

12.3.10 DELETE warn con users
-----------------------------

::

   GIVEN politica warn + Users con AGR
   WHEN  DELETE
   THEN  status == 200 con count

12.3.11 DELETE strict 409
-------------------------

::

   GIVEN politica strict + Users
   WHEN  DELETE
   THEN  status == 409 RETIRE_HAS_USERS

12.3.12 Sin permiso 403
-----------------------

::

   GIVEN invoker sin manage_access_groups
   WHEN  cualquier endpoint
   THEN  status == 403

12.3.13 Audit emit (CA-15)
--------------------------

::

   GIVEN cualquier operacion CRUD exitosa
   WHEN  inspecciono BD
   THEN  AuditEvent ACCESS_GROUP_*

12.4 E2E
========

12.4.1 Admin crea AGR custom
----------------------------

::

   GIVEN admin con manage_access_groups
   WHEN  define code, display_name,
         description, severity, click Crear
   THEN  AGR aparece en catalogo

12.4.2 Admin modifica AGR
-------------------------

::

   GIVEN AGR custom
   WHEN  edita display_name + severity
   THEN  cambios reflejados en catalogo

12.4.3 Admin retira con confirmacion
------------------------------------

::

   GIVEN AGR con Users + politica warn
   WHEN  click Retirar, modal muestra count,
         ingresa reason, confirma
   THEN  AGR aparece como RETIRED

12.4.4 Predefinido botones ocultos
----------------------------------

::

   GIVEN AGR-006 (predefinido)
   WHEN  abre detalle
   THEN  botones Modificar/Retirar ocultos

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente
   - Lineas
   - Branches
 * - AccessGroupAdminService
   - ≥ 95%
   - ≥ 90%
 * - CodeValidator
   - 100%
   - 100%
 * - PredefinedGuard
   - 100%
   - 100%
 * - UsersWithAGRCounter
   - ≥ 90%
   - ≥ 85%

.. _uc-acc-05-parte-12:

==========================
Parte 12 — Testing
==========================

.. note::

 Tests Given/When/Then. Stack-agnostico.

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

12.2.1 list happy
-----------------

::

   GIVEN invoker con view_separation_rules
   WHEN  list()
   THEN  PaginatedResult con reglas ACTIVE

12.2.2 create happy (CA-03)
---------------------------

::

   GIVEN invoker con manage_separation_rules
     AND payload valido
   WHEN  create
   THEN  SoDRule ACTIVE creada
   AND   AuditEvent SOD_RULE_CREATED
   AND   Cache.invalidate llamado

12.2.3 create duplicada (CA-04)
-------------------------------

::

   GIVEN existe SoDRule ACTIVE con mismas
         functions
   WHEN  create con esas mismas functions
   THEN  raise SoDRuleDuplicate

12.2.4 create con violations existentes (CA-05)
-----------------------------------------------

::

   GIVEN Users con par conflictivo
   WHEN  create
   THEN  output.existing_violations_count > 0
   AND   output.violating_user_ids_sample no
         vacio

12.2.5 create funcion inexistente (CA-06)
-----------------------------------------

::

   GIVEN payload con function_id no existe
   WHEN  create
   THEN  raise FunctionNotFound

12.2.6 modify PATCH parcial (CA-07)
-----------------------------------

::

   GIVEN PATCH con solo display_name
   WHEN  modify
   THEN  display_name actualizado, otros
         campos preservados

12.2.7 modify function_ids prohibido (CA-08)
--------------------------------------------

::

   GIVEN PATCH con function_ids
   WHEN  modify
   THEN  raise FunctionIdsImmutable

12.2.8 retire happy (CA-09)
---------------------------

::

   GIVEN regla ACTIVE
     AND retire_reason provisto
   WHEN  retire
   THEN  state == RETIRED
   AND   retired_by_admin_id, retire_reason
         registrados
   AND   AuditEvent SOD_RULE_RETIRED
   AND   Cache.invalidate

12.2.9 retire sin reason (CA-10)
--------------------------------

::

   GIVEN retire_reason vacio
   WHEN  retire
   THEN  raise ValidationError

12.2.10 retire ya RETIRED (CA-11)
---------------------------------

::

   GIVEN regla con state=RETIRED
   WHEN  retire
   THEN  raise SoDRuleAlreadyRetired

12.2.11 sin permiso lectura
---------------------------

::

   GIVEN invoker sin view_separation_rules
   WHEN  list / get
   THEN  raise SinPermiso

12.2.12 sin permiso CRUD
------------------------

::

   GIVEN invoker sin manage_separation_rules
   WHEN  create / modify / retire
   THEN  raise SinPermiso

12.2.13 cache invalidate post-COMMIT (CA-13)
--------------------------------------------

::

   GIVEN flujo CRUD exitoso
   WHEN  TransactionManager.atomic retorna
   THEN  SoDRuleCache.invalidate llamado
         DESPUES

12.2.14 audit sin PII (CA-18)
-----------------------------

::

   GIVEN AuditEvent SOD_RULE_*
   THEN  payload sin email/full_name del
         invoker

12.3 Integracion
================

12.3.1 GET listado 200
----------------------

::

   GIVEN invoker con view_separation_rules
   WHEN  GET /api/access/sod-rules/
   THEN  status == 200

12.3.2 GET filter rule_id audita
--------------------------------

::

   GIVEN GET con ?rule_id=X
   THEN  AuditEvent SOD_RULES_VIEWED con
         target_rule_id

12.3.3 GET listado amplio NO audita (CA-15)
-------------------------------------------

::

   GIVEN GET sin rule_id
   THEN  ZERO AuditEvent SOD_RULES_VIEWED

12.3.4 POST create 201
----------------------

::

   GIVEN invoker con manage + payload valido
   WHEN  POST
   THEN  status == 201

12.3.5 POST duplicada 409
-------------------------

::

   GIVEN regla ACTIVE con mismas functions
   WHEN  POST con mismas functions
   THEN  status == 409 SOD_RULE_DUPLICATE

12.3.6 POST funcion no existe 400
---------------------------------

::

   GIVEN function_id invalido
   WHEN  POST
   THEN  status == 400 FUNCTION_NOT_FOUND

12.3.7 PATCH 200
----------------

::

   GIVEN PATCH valido
   WHEN  PATCH
   THEN  status == 200

12.3.8 PATCH function_ids immutable 400
---------------------------------------

::

   GIVEN PATCH con function_ids
   WHEN  PATCH
   THEN  status == 400 FUNCTION_IDS_IMMUTABLE

12.3.9 DELETE 200
-----------------

::

   GIVEN DELETE con retire_reason
   WHEN  DELETE
   THEN  status == 200
   AND   regla.state == RETIRED

12.3.10 DELETE sin reason 400
-----------------------------

::

   GIVEN DELETE sin retire_reason
   WHEN  DELETE
   THEN  status == 400

12.3.11 DELETE ya RETIRED 400
-----------------------------

::

   GIVEN regla RETIRED
   WHEN  DELETE
   THEN  status == 400
         SOD_RULE_ALREADY_RETIRED

12.3.12 Sin permiso 403
-----------------------

::

   GIVEN invoker sin permiso correspondiente
   WHEN  cualquier endpoint
   THEN  status == 403
   AND   AuditEvent UNAUTHORIZED

12.3.13 Audit fail 500
----------------------

::

   GIVEN AuditLog falla
   WHEN  CRUD
   THEN  status == 500
   AND   sin cambios (rollback)

12.4 E2E
========

12.4.1 Admin crea regla via UI
------------------------------

::

   GIVEN admin con manage_separation_rules
   WHEN  define functions, descripcion,
         severity, click Crear
   THEN  toast confirma con violations_count

12.4.2 Admin retira regla con confirmacion
------------------------------------------

::

   GIVEN regla ACTIVE en UI
   WHEN  click Retirar, ingresa reason,
         confirma
   THEN  regla aparece como RETIRED en lista

12.4.3 Auditor ve listado pero no edita
---------------------------------------

::

   GIVEN auditor con solo
         view_separation_rules
   WHEN  abre vista
   THEN  ve listado
   AND   botones Crear/Modificar/Retirar
         ocultos

12.4.4 Cambio aplica en validacion subsecuente
----------------------------------------------

::

   GIVEN admin retira regla
   WHEN  UC_ACC_01 intenta asignacion antes
         conflictiva
   THEN  asignacion procede (SoD ya no
         bloquea — cache actualizado)

12.5 Cobertura
==============

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente
   - Lineas
   - Branches
 * - SoDRuleService.{create,modify,retire}
   - ≥ 95%
   - ≥ 90%
 * - DuplicateChecker
   - 100%
   - 100%
 * - ViolationsImpactCalculator
   - ≥ 90%
   - ≥ 85%
 * - HTTPEndpoints
   - ≥ 90%
   - ≥ 85%

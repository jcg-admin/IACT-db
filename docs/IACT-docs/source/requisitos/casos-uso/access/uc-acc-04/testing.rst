.. _uc-acc-04-parte-12:

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
   - 12
   - ≥ 90%
 * - Integration
   - 11
   - sub-flujos + EXs
 * - E2E
   - 3
   - flujos UI

12.2 Tests unitarios
====================

12.2.1 assign_access_group happy
--------------------------------

::

   GIVEN invoker con assign_function_groups
     AND target ACTIVE sin AGR
     AND AGR con 8 funciones
   WHEN  assign_access_group
   THEN  Assignment AGR creado
   AND   AuditEvent AGR_ASSIGNED con
         functions_count_added=8
   AND   PermissionCache invalidate llamado

12.2.2 Idempotencia (CA-02)
---------------------------

::

   GIVEN AGR ya asignado al target
   WHEN  assign_access_group
   THEN  no nuevo Assignment
   AND   AuditEvent AGR_ASSIGN_NOOP

12.2.3 SoD bloquea (CA-03)
--------------------------

::

   GIVEN AGR contiene funcion en conflicto
         con functions actuales del target
   WHEN  assign_access_group
   THEN  raise SoDViolation
   AND   ningun Assignment creado

12.2.4 Subset ya directo (CA-04)
--------------------------------

::

   GIVEN AGR=8 funciones, target ya con 2
         directas (mismas)
   WHEN  assign_access_group
   THEN  Assignment creado
   AND   AuditEvent.functions_count_added=6
   AND   AuditEvent.functions_already_present_count=2

12.2.5 Auto-asignacion (CA-05)
------------------------------

::

   GIVEN politica anti-self activa
     AND invoker.id == target.id
   WHEN  assign
   THEN  raise SelfAssignForbidden

12.2.6 AGR no existe (CA-06)
----------------------------

::

   GIVEN access_group_id 99999
   WHEN  assign
   THEN  raise AccessGroupNotFound

12.2.7 AGR inactivo (CA-07)
---------------------------

::

   GIVEN AGR con state=INACTIVE
   WHEN  assign
   THEN  raise AccessGroupInactive

12.2.8 Atomicidad audit fail (CA-11)
------------------------------------

::

   GIVEN AuditLog.emit lanza
   WHEN  assign
   THEN  excepcion propagada
   AND   ningun Assignment creado
   AND   PermissionCache no invalidada

12.2.9 Cache post-COMMIT (CA-10)
--------------------------------

::

   GIVEN flujo exitoso
   WHEN  TransactionManager.atomic retorna
   THEN  PermissionCache.invalidate DESPUES

12.2.10 Audit sin PII (CA-12)
-----------------------------

::

   GIVEN AuditEvent emitido
   WHEN  inspecciono payload
   THEN  no contiene email/full_name

12.2.11 Re-asignacion post revoke (CA-13)
-----------------------------------------

::

   GIVEN Assignment(user, AGR, REVOKED)
   WHEN  assign
   THEN  nuevo Assignment ACTIVE
   AND   REVOKED preservado

12.2.12 expires_at temporal (CA-09)
-----------------------------------

::

   GIVEN expires_at = NOW()+6 meses
   WHEN  assign
   THEN  Assignment.expires_at = ese valor

12.3 Integracion
================

12.3.1 Endpoint POST 201 (CA-01)
--------------------------------

::

   GIVEN invoker autenticado con la funcion
   WHEN  POST con payload valido
   THEN  status == 201
   AND   body contiene assignment_id

12.3.2 Idempotencia 200 (CA-02)
-------------------------------

::

   GIVEN AGR ya asignado
   WHEN  POST
   THEN  status == 200
   AND   body.already_assigned == true

12.3.3 SoD 409 (CA-03)
----------------------

::

   GIVEN AGR conflicto SoD
   WHEN  POST
   THEN  status == 409 SOD_VIOLATION

12.3.4 Sin permiso 403 (CA-08)
------------------------------

::

   GIVEN invoker sin assign_function_groups
   WHEN  POST
   THEN  status == 403

12.3.5 User no existe 404
-------------------------

::

   GIVEN target inexistente
   WHEN  POST
   THEN  status == 404

12.3.6 User ELIMINATED 400
--------------------------

::

   GIVEN target ELIMINATED
   WHEN  POST
   THEN  status == 400 INVALID_USER_STATE

12.3.7 AGR no existe 400 (CA-06)
--------------------------------

::

   GIVEN access_group_id inexistente
   WHEN  POST
   THEN  status == 400
         ACCESS_GROUP_NOT_FOUND

12.3.8 AGR inactivo 400 (CA-07)
-------------------------------

::

   GIVEN AGR inactivo
   WHEN  POST
   THEN  status == 400
         ACCESS_GROUP_INACTIVE

12.3.9 Cache invalidada (CA-10)
-------------------------------

::

   GIVEN target con permisos cached
   WHEN  POST exitoso
   AND   target hace request inmediato
   THEN  cache miss → recompute
   AND   funciones del AGR reflejadas

12.3.10 Audit fail 500 (CA-11)
------------------------------

::

   GIVEN AuditLog falla simulado
   WHEN  POST
   THEN  status == 500
   AND   sin Assignment

12.3.11 Throttling 429 (CA-15)
------------------------------

::

   GIVEN > 30 POST/min
   WHEN  POST
   THEN  status == 429

12.4 E2E
========

12.4.1 Admin asigna AGR via UI
------------------------------

::

   GIVEN admin con assign_function_groups
   WHEN  selecciona AGR del catalogo, click
         Asignar
   THEN  toast confirma con resumen

12.4.2 SoD bloquea con detalle
------------------------------

::

   GIVEN AGR con conflicto
   WHEN  click Asignar
   THEN  modal de error con regla SoD

12.4.3 Boton oculto sin la funcion
----------------------------------

::

   GIVEN admin sin la funcion
   WHEN  abre detalle del User
   THEN  boton Asignar AGR no visible

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente
   - Lineas
   - Branches
 * - AccessService.assign_access_group
   - ≥ 95%
   - ≥ 90%
 * - AccessGroupRepository
   - 100%
   - 100%
 * - SoDValidator
   - 100%
   - 100%
 * - AntiSelfActionPolicy
   - 100%
   - 100%
 * - HTTPPostEndpoint
   - ≥ 90%
   - ≥ 85%

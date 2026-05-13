.. _uc-acc-02-parte-12:

==========================
Parte 12 — Testing
==========================

.. note::

 Tests en pseudocodigo Given/When/Then.
 Stack-agnostico.

12.1 Pyramid
============

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Capa
   - Cantidad
   - Cobertura objetivo
 * - Unit
   - 14
   - ≥ 90% lineas
 * - Integration
   - 12
   - sub-flujos + EXs
 * - E2E
   - 4
   - flujos UI completos

12.2 Tests unitarios
====================

12.2.1 PayloadValidator: revoke_reason obligatorio
--------------------------------------------------

::

   GIVEN payload con revoke_reason vacio
   WHEN  PayloadValidator.validate
   THEN  raise ValidationError

12.2.2 AntiSelfActionPolicy bloquea (CA-06)
-------------------------------------------

::

   GIVEN invoker.id == target.id
     AND politica ANTI_SELF_REVOKE=true
   WHEN  AntiSelfActionPolicy.allows
   THEN  raise SelfRevokeForbidden

12.2.3 WarningsCalculator detecta no_functions
----------------------------------------------

::

   GIVEN target con 2 funciones activas
     AND to_revoke = ambas
   WHEN  WarningsCalculator.compute
   THEN  warnings.no_functions == true

12.2.4 WarningsCalculator detecta critical
------------------------------------------

::

   GIVEN to_revoke incluye funcion en
         CRITICAL_FUNCTIONS
   WHEN  compute
   THEN  warnings.critical_revoked contiene
         la funcion

12.2.5 WarningsCalculator detecta last_holder
---------------------------------------------

::

   GIVEN target es uno de 1 holder de funcion X
     AND threshold = 1
   WHEN  compute con to_revoke incluyendo X
   THEN  warnings.last_holder contiene X con
         remaining_holders_after = 0

12.2.6 LastHolderPolicy block strict
------------------------------------

::

   GIVEN politica strict
     AND warnings.last_holder con
         remaining_holders_after = 0
   WHEN  should_block
   THEN  true

12.2.7 LastHolderPolicy warn-only default
-----------------------------------------

::

   GIVEN politica warn-only
   WHEN  should_block (cualquier warning)
   THEN  false

12.2.8 revoke_functions happy (CA-01)
-------------------------------------

::

   GIVEN target con Assignments [1,2] ACTIVE
     AND invoker con revoke_functions
   WHEN  revoke([1,2], reason="X")
   THEN  ambos Assignment con state=REVOKED
   AND   AuditEvent FUNCTIONS_REVOKED
   AND   PermissionCache invalidate llamado

12.2.9 Soft-delete (CA-02)
--------------------------

::

   GIVEN revocacion exitosa
   WHEN  inspecciono BD
   THEN  Assignment.objects.filter(id=...)
         .exists() == true (preservado)
   AND   granted_at preservado

12.2.10 Idempotencia total (CA-04)
----------------------------------

::

   GIVEN target sin Assignments ACTIVE en
         function_ids del payload
   WHEN  revoke
   THEN  return output con revoked=[],
         skipped=full
   AND   AuditEvent FUNCTIONS_REVOKE_NOOP
   AND   ningun UPDATE ejecutado

12.2.11 Mix activas + ya revocadas (CA-05)
------------------------------------------

::

   GIVEN function 1 ACTIVE, function 2 ya
         REVOKED
   WHEN  revoke([1,2])
   THEN  revoked contiene 1
   AND   skipped contiene 2

12.2.12 Atomicidad audit fail (CA-14)
-------------------------------------

::

   GIVEN AuditLog.emit lanza
   WHEN  revoke
   THEN  excepcion propagada
   AND   Assignments preservados (rollback)
   AND   PermissionCache no invalidada

12.2.13 Cache post-COMMIT (CA-15, P-29)
---------------------------------------

::

   GIVEN flujo exitoso
   WHEN  TransactionManager.atomic retorna
   THEN  PermissionCache.invalidate llamado
         DESPUES (no antes)

12.2.14 Audit sin PII (CA-16)
-----------------------------

::

   GIVEN AuditEvent FUNCTIONS_REVOKED
   WHEN  inspecciono payload
   THEN  no contiene email, full_name
   AND   contiene IDs, codigos, revoke_reason

12.3 Tests de integracion
=========================

12.3.1 Endpoint DELETE 200 (CA-01)
----------------------------------

::

   GIVEN invoker con revoke_functions
     AND target con Assignment 1,2 activos
   WHEN  DELETE con [1,2] + reason
   THEN  status == 200
   AND   body.revoked.length == 2

12.3.2 Sin permiso 403 (CA-07)
------------------------------

::

   GIVEN invoker sin revoke_functions
   WHEN  DELETE
   THEN  status == 403
   AND   AuditEvent UNAUTHORIZED

12.3.3 User no existe 404 (CA-08)
---------------------------------

::

   GIVEN user_id 99999
   WHEN  DELETE
   THEN  status == 404

12.3.4 User ELIMINATED 400 (CA-09)
----------------------------------

::

   GIVEN target ELIMINATED
   WHEN  DELETE
   THEN  status == 400 INVALID_USER_STATE

12.3.5 Auto-revoke 400 (CA-06)
------------------------------

::

   GIVEN politica ANTI_SELF_REVOKE=true
   WHEN  DELETE sobre invoker.id
   THEN  status == 400 SELF_REVOKE_FORBIDDEN
   AND   AuditEvent ALERTA

12.3.6 revoke_reason vacio 400 (CA-03)
--------------------------------------

::

   GIVEN payload con revoke_reason vacio
   WHEN  DELETE
   THEN  status == 400 VALIDATION_ERROR

12.3.7 Idempotencia total NOOP (CA-04)
--------------------------------------

::

   GIVEN target sin las funciones del
         payload activas
   WHEN  DELETE
   THEN  status == 200
   AND   body.revoked == []
   AND   AuditEvent FUNCTIONS_REVOKE_NOOP

12.3.8 Warning no_functions (CA-10)
-----------------------------------

::

   GIVEN target con [1,2] activas
   WHEN  DELETE [1,2]
   THEN  status == 200
   AND   body.warnings.no_functions == true

12.3.9 Last holder block strict (CA-13)
---------------------------------------

::

   GIVEN politica BLOCK_LAST_HOLDER=true
     AND target ultimo holder de funcion X
   WHEN  DELETE [X]
   THEN  status == 409 LAST_HOLDER_PROTECTION

12.3.10 Cache invalidada (CA-15)
--------------------------------

::

   GIVEN target permisos cached
   WHEN  DELETE exitoso
   AND   target hace request inmediato
   THEN  cache miss → recompute
   AND   funciones revocadas no aparecen

12.3.11 Throttling 429 (CA-19)
------------------------------

::

   GIVEN invoker > 30 DELETE/min
   WHEN  DELETE 31
   THEN  status == 429

12.3.12 notify_user respetado (CA-20)
-------------------------------------

::

   GIVEN payload notify_user=false
   WHEN  DELETE
   THEN  ningun InternalMessage al target

12.4 Tests E2E
==============

12.4.1 Admin revoca via UI
--------------------------

::

   GIVEN admin con revoke_functions en UI
   WHEN  abre detalle, multi-select 2
         funciones, ingresa reason, confirma
   THEN  toast confirma
   AND   detalle del User refleja menos
         funciones

12.4.2 Warning visual no_functions
----------------------------------

::

   GIVEN admin revoca todas las funciones
   THEN  modal informativo
         "Usuario quedara sin capacidades"

12.4.3 Sin permiso boton oculto
-------------------------------

::

   GIVEN admin sin revoke_functions
   WHEN  abre detalle del User
   THEN  boton "Revocar" no visible

12.4.4 User pierde capacidad
----------------------------

::

   GIVEN admin revoca funcion view_users
         del User X
   WHEN  X recarga sesion (proximo request)
   THEN  X NO puede acceder a la lista de
         Users (403)

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente
   - Lineas
   - Branches
 * - AccessService.revoke_functions
   - ≥ 95%
   - ≥ 90%
 * - WarningsCalculator
   - 100%
   - 100%
 * - LastHolderPolicy
   - 100%
   - 100%
 * - AntiSelfActionPolicy
   - 100%
   - 100%
 * - HTTPDeleteEndpoint
   - ≥ 90%
   - ≥ 85%

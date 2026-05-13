.. _uc-acc-01-parte-12:

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
   - 16
   - ≥ 90% lineas
 * - Integration
   - 14
   - sub-flujos + EXs + CNSTs
 * - E2E
   - 4
   - flujos administrativos completos

12.2 Tests unitarios
====================

12.2.1 SoDValidator detecta violacion
-------------------------------------

::

   GIVEN SoDRule(name='Admin no auditor',
                 functions={1, 42})
     AND effective_set = {1, 42, 7}
   WHEN  SoDValidator.validate(set, [rule])
   THEN  raise SoDViolation(
           rule_id=rule.id,
           conflict_pair=(1, 42))

12.2.2 SoDValidator pasa cuando no hay conflict
-----------------------------------------------

::

   GIVEN SoDRule(functions={1, 42})
     AND effective_set = {1, 7, 8}  # sin 42
   WHEN  SoDValidator.validate
   THEN  no lanza (set permitido)

12.2.3 AntiSelfAction bloquea (CA-07)
-------------------------------------

::

   GIVEN politica ANTI_SELF_ASSIGN=true
     AND invoker.id == target.id
   WHEN  AntiSelfActionPolicy.allows
   THEN  raise SelfAssignForbidden

12.2.4 IdempotencyPolicy NOOP (CA-03)
-------------------------------------

::

   GIVEN politica default
     AND target ya tiene todas las funciones
         del payload activas
   WHEN  handle_all_already_assigned
   THEN  return output con assigned=[],
         skipped=full_list

12.2.5 ExpirationPolicy lower bound (CA-17)
-------------------------------------------

::

   GIVEN expires_at = NOW() + 30 minutos
   WHEN  PayloadValidator.validate
   THEN  raise ValidationError
         ("expires_at must be >= NOW()+1h")

12.2.6 ExpirationPolicy upper bound (CA-18)
-------------------------------------------

::

   GIVEN expires_at = NOW() + 18 meses
   WHEN  PayloadValidator.validate
   THEN  raise ValidationError
         ("expires_at must be <= NOW()+1y")

12.2.7 assign_functions happy (CA-01)
-------------------------------------

::

   GIVEN invoker con assign_functions
     AND target ACTIVE sin funciones previas
     AND payload {function_ids:[1,2,3]}
     AND SoDRules vigentes no afectan
   WHEN  assign_functions
   THEN  3 Assignment ACTIVE creados
   AND   AuditEvent FUNCTIONS_ASSIGNED
   AND   PermissionCache.invalidate llamado

12.2.8 Idempotencia parcial (CA-04, FA-03)
------------------------------------------

::

   GIVEN target con function_id=1 ACTIVE
     AND payload {function_ids:[1,2]}
   WHEN  assign_functions
   THEN  1 Assignment nuevo (function_id=2)
   AND   skipped contiene function_id=1

12.2.9 SoD bloquea total (CA-05, CA-06)
---------------------------------------

::

   GIVEN SoDRule(functions={1, 42})
     AND target tiene function_id=1 ACTIVE
     AND payload {function_ids:[42, 7, 8]}
   WHEN  assign_functions
   THEN  raise SoDViolation
   AND   ningun Assignment creado (rollback)
   AND   AuditEvent FUNCTIONS_ASSIGN_FAILED

12.2.10 Re-asignacion post-revoke (CA-21)
-----------------------------------------

::

   GIVEN Assignment(target, function=1,
                     state=REVOKED) historico
     AND payload {function_ids:[1]}
   WHEN  assign_functions
   THEN  NUEVO Assignment ACTIVE con
         granted_at=NOW()
   AND   Assignment REVOKED previo intacto

12.2.11 Atomicidad audit fail (CA-13)
-------------------------------------

::

   GIVEN AuditLog.emit lanza
   WHEN  assign_functions
   THEN  excepcion propagada
   AND   ROLLBACK total
   AND   PermissionCache.invalidate NO
         llamado (post-COMMIT solo en exito)

12.2.12 Cache invalidate post-COMMIT (CA-14, P-29)
--------------------------------------------------

::

   GIVEN flujo exitoso
   WHEN  TransactionManager.atomic retorna
   THEN  PermissionCache.invalidate llamado
         DESPUES (no antes ni durante)

12.2.13 Audit sin PII (CA-15)
-----------------------------

::

   GIVEN AuditEvent FUNCTIONS_ASSIGNED emitido
   WHEN  inspecciono payload
   THEN  no contiene email, full_name del
         target
   AND   contiene IDs y codigos

12.2.14 InternalMessage con display_names (P-30)
------------------------------------------------

::

   GIVEN politica notify=true
   WHEN  assign exitoso
   THEN  InternalMessage.body contiene
         display_names (legibles), no IDs

12.2.15 Funcion no existe (CA-11)
---------------------------------

::

   GIVEN payload con function_id=99999
         (no existe)
   WHEN  assign_functions
   THEN  raise FunctionNotFound([99999])

12.2.16 Funcion inactiva (CA-12)
--------------------------------

::

   GIVEN function_id=15 con state=INACTIVE
   WHEN  assign_functions con [15]
   THEN  raise FunctionInactive([15])

12.3 Tests de integracion
=========================

12.3.1 Endpoint POST 201 (CA-01)
--------------------------------

::

   GIVEN invoker autenticado con
         assign_functions
   WHEN  POST /api/users/{id}/functions/
         con {function_ids:[1,2,3]}
   THEN  status == 201
   AND   body.assigned.length == 3

12.3.2 Sin la funcion 403 (CA-08)
---------------------------------

::

   GIVEN invoker sin assign_functions
   WHEN  POST
   THEN  status == 403
   AND   AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT

12.3.3 User no existe 404 (CA-09)
---------------------------------

::

   GIVEN user_id 99999 no existe
   WHEN  POST /api/users/99999/functions/
   THEN  status == 404 USER_NOT_FOUND

12.3.4 User ELIMINATED 400 (CA-10)
----------------------------------

::

   GIVEN target con state ELIMINATED
   WHEN  POST
   THEN  status == 400 INVALID_USER_STATE

12.3.5 Auto-asignacion 400 (CA-07)
----------------------------------

::

   GIVEN invoker con assign_functions
     AND politica ANTI_SELF_ASSIGN=true
   WHEN  POST sobre invoker.id
   THEN  status == 400 SELF_ASSIGN_FORBIDDEN

12.3.6 Funcion no existe 400 (CA-11)
------------------------------------

::

   GIVEN payload {function_ids:[99999]}
   WHEN  POST
   THEN  status == 400 FUNCTION_NOT_FOUND
   AND   body.missing_ids contiene 99999

12.3.7 Funcion inactiva 400 (CA-12)
-----------------------------------

::

   GIVEN function_id=15 state=INACTIVE
   WHEN  POST con [15]
   THEN  status == 400 FUNCTION_INACTIVE

12.3.8 SoD violation 409 (CA-05)
--------------------------------

::

   GIVEN SoDRule en BD
     AND target con function 1
   WHEN  POST con [42] (en conflicto con 1)
   THEN  status == 409 SOD_VIOLATION
   AND   body contiene rule_id, conflict_pair
   AND   ningun Assignment creado

12.3.9 SoD all-or-nothing (CA-06)
---------------------------------

::

   GIVEN payload con 3 funciones, 1 viola SoD
   WHEN  POST
   THEN  status == 409
   AND   las otras 2 NO se asignan

12.3.10 Idempotencia parcial (CA-04)
------------------------------------

::

   GIVEN target con function_id=1 ACTIVE
   WHEN  POST con [1, 2]
   THEN  status == 201
   AND   body.assigned contiene 2
   AND   body.skipped contiene 1

12.3.11 Idempotencia total NOOP (CA-03)
---------------------------------------

::

   GIVEN target con functions [1,2] ACTIVE
   WHEN  POST con [1, 2]
   THEN  status == 200 (no 201)
   AND   body.assigned == []
   AND   AuditEvent FUNCTIONS_ASSIGN_NOOP

12.3.12 Cache invalidada post-COMMIT (CA-14)
--------------------------------------------

::

   GIVEN target con permisos cached
   WHEN  POST exitoso
   AND   target hace request inmediato
   THEN  cache miss → recompute desde BD
   AND   nuevas funciones reflejadas

12.3.13 Atomicidad ante audit fail (CA-13)
------------------------------------------

::

   GIVEN AuditLog.emit lanza simulado
   WHEN  POST
   THEN  status == 500 AUDIT_FAILED
   AND   ningun Assignment creado
   AND   PermissionCache no invalidada

12.3.14 Throttling 429 (CA-20)
------------------------------

::

   GIVEN invoker > 30 POST/min
   WHEN  POST 31
   THEN  status == 429

12.4 Tests E2E
==============

12.4.1 Admin asigna funciones via UI
------------------------------------

::

   GIVEN admin autenticado en UI
   WHEN  abre detalle del User, multi-select
         3 funciones, click "Asignar"
   THEN  toast confirma asignacion
   AND   detalle del User muestra las nuevas
         funciones

12.4.2 SoD bloquea con detalle visual
-------------------------------------

::

   GIVEN admin selecciona funcion que
         conflictua con una activa del User
   WHEN  click "Asignar"
   THEN  modal de error muestra:
         - nombre de la regla SoD
         - par conflictivo
         - sugerencia "revoca primero la otra"

12.4.3 Boton oculto sin la funcion (CA-22)
------------------------------------------

::

   GIVEN admin sin assign_functions en UI
   WHEN  abre detalle del User
   THEN  boton "Asignar funciones" no visible

12.4.4 User destino ve nuevas capacidades
-----------------------------------------

::

   GIVEN admin asigna funcion 'view_users' a
         User X
   WHEN  X recarga su sesion (proximo request)
   THEN  X puede acceder a la lista de
         Users
   AND   X recibe InternalMessage en su buzon
         con la nueva capacidad

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente logico
   - Lineas
   - Branches
 * - AccessService.assign_functions
   - ≥ 95%
   - ≥ 90%
 * - SoDValidator
   - 100%
   - 100%
 * - AntiSelfActionPolicy
   - 100%
   - 100%
 * - IdempotencyPolicy
   - 100%
   - 100%
 * - ExpirationPolicy
   - 100%
   - 100%
 * - HTTPPostEndpoint
   - ≥ 90%
   - ≥ 85%
 * - AuthorizationGuard assign_functions
   - 100%
   - 100%

12.6 Resumen
============

.. list-table::
 :widths: 12 35 53
 :header-rows: 1

 * - Capa
   - Test
   - CA cubierto
 * - Unit
   - SoDValidator viola / pasa
   - CA-05 / CNST-005
 * - Unit
   - AntiSelfAction bloquea
   - CA-07
 * - Unit
   - IdempotencyPolicy NOOP
   - CA-03
 * - Unit
   - ExpirationPolicy bounds
   - CA-17, CA-18
 * - Unit
   - assign_functions happy
   - CA-01
 * - Unit
   - idempotencia parcial
   - CA-04
 * - Unit
   - SoD bloquea total
   - CA-05, CA-06
 * - Unit
   - re-asignacion post-revoke
   - CA-21
 * - Unit
   - atomicidad audit fail
   - CA-13
 * - Unit
   - cache post-COMMIT
   - CA-14
 * - Unit
   - audit sin PII
   - CA-15
 * - Unit
   - InternalMessage display_names
   - P-30
 * - Unit
   - funcion no existe / inactiva
   - CA-11, CA-12
 * - Integration
   - endpoint 201
   - CA-01
 * - Integration
   - sin permiso 403
   - CA-08
 * - Integration
   - user no existe 404
   - CA-09
 * - Integration
   - user ELIMINATED 400
   - CA-10
 * - Integration
   - auto-asignacion 400
   - CA-07
 * - Integration
   - funcion no existe / inactiva
   - CA-11, CA-12
 * - Integration
   - SoD 409 + all-or-nothing
   - CA-05, CA-06
 * - Integration
   - idempotencia parcial / total
   - CA-04, CA-03
 * - Integration
   - cache invalidada
   - CA-14
 * - Integration
   - audit fail rollback
   - CA-13
 * - Integration
   - throttling 429
   - CA-20
 * - E2E
   - admin asigna via UI
   - flujo completo
 * - E2E
   - SoD bloquea con detalle UI
   - CA-05 visual
 * - E2E
   - boton oculto
   - CA-22
 * - E2E
   - user destino ve capacidades
   - CA-14 + UC_ACC_03

.. _uc-usr-03-parte-12:

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
 * - Unit (servicio + state machine + policies)
   - 14
   - ≥ 90% lineas / ≥ 85% branches
 * - Integration (endpoint + BD)
   - 11
   - sub-flujos + EXs + CNSTs
 * - E2E (UI)
   - 4
   - flujos administrativos completos

12.2 Tests unitarios
====================

12.2.1 StateMachine: ACTIVE → BLOCKED permitido
-----------------------------------------------

::

   GIVEN un User con state ACTIVE
   WHEN  StateMachine.validate(ACTIVE, BLOCKED)
   THEN  pasa sin lanzar excepcion
   AND   side_effects incluye CloseSessions

12.2.2 StateMachine: ELIMINATED → ACTIVE rechaza
------------------------------------------------

::

   GIVEN un User con state ELIMINATED
   WHEN  StateMachine.validate(ELIMINATED,
                                ACTIVE)
   THEN  raise InvalidStateTransition

12.2.3 StateMachine: ACTIVE → ELIMINATED rechaza
------------------------------------------------

::

   GIVEN un User con state ACTIVE
   WHEN  StateMachine.validate(ACTIVE, ELIMINATED)
   THEN  raise InvalidStateTransition
   AND   sugerencia: usar UC_USR_04

12.2.4 AntiSelfActionPolicy bloquea auto-state
----------------------------------------------

::

   GIVEN invoker.id == target.user_id
   WHEN  AntiSelfActionPolicy.allows(
           invoker, target, action='state_change')
   THEN  raise SelfStateChangeForbidden

12.2.5 AntiSelfActionPolicy permite cambios no-state
----------------------------------------------------

::

   GIVEN invoker.id == target.user_id
     AND patch contiene solo first_name
   WHEN  AntiSelfActionPolicy.allows(
           invoker, target, action='non_state')
   THEN  pasa sin lanzar (cambios de datos
                          personales propios OK)

12.2.6 NotifyOnModifyStrategy default
-------------------------------------

::

   GIVEN strategy default
   WHEN  patch sin state cambio
   THEN  should_notify == false

   GIVEN patch con state cambio
   WHEN  should_notify
   THEN  true

12.2.7 modify_user happy path datos personales (CA-01)
------------------------------------------------------

::

   GIVEN admin con modify_users + User existe
   WHEN  modify_user(target_id,
                     {first_name:'Ana Maria'},
                     invoker)
   THEN  User.first_name == 'Ana Maria'
   AND   User.last_name sin cambio
   AND   User.state sin cambio
   AND   AuditEvent USER_MODIFIED con
         fields_changed == ['first_name']
   AND   ZERO Sessions cerradas

12.2.8 Bloqueo cierra Sessions (CA-02)
--------------------------------------

::

   GIVEN User con state ACTIVE y 2 Sessions
         activas
   WHEN  modify_user(target, {state:'BLOCKED'},
                     admin)
   THEN  User.state == BLOCKED
   AND   Sessions activas == 0
   AND   2 BlacklistedToken creadas
   AND   AuditEvent state_transition.to ==
         'BLOCKED' y sessions_closed_count == 2

12.2.9 Desbloqueo NO restaura Sessions (CA-03)
----------------------------------------------

::

   GIVEN User BLOCKED con Sessions ya CLOSED
   WHEN  modify_user(target, {state:'ACTIVE'},
                     admin)
   THEN  User.state == ACTIVE
   AND   Sessions permanecen CLOSED
   AND   AuditEvent state_transition

12.2.10 Auto-state-change rechaza (CA-04)
-----------------------------------------

::

   GIVEN admin.id == target.id
   WHEN  modify_user(admin.id,
                     {state:'BLOCKED'},
                     admin)
   THEN  raise SelfStateChangeForbidden
   AND   AuditEvent USER_MODIFY_FAILED

12.2.11 PATCH parcial preserva campos (CA-09)
---------------------------------------------

::

   GIVEN User con first_name='Ana',
         last_name='Gomez'
   WHEN  modify_user con patch sin last_name
   THEN  last_name preservado

12.2.12 PATCH idempotente (CA-10)
---------------------------------

::

   GIVEN admin envia el mismo patch dos veces
   WHEN  estado intermedio == estado final
   THEN  no cambios extras
   AND   2 AuditEvents emitidos

12.2.13 Atomicidad cierre Sessions falla (CA-11)
------------------------------------------------

::

   GIVEN SessionService.close_all_active lanza
         excepcion
   WHEN  modify_user con state→BLOCKED
   THEN  User.state permanece ACTIVE (rollback)
   AND   Sessions intactas

12.2.14 Audit sin PII (CA-14)
-----------------------------

::

   GIVEN modify_user exitoso con email cambio
   WHEN  inspecciono AuditEvent.payload
   THEN  payload no contiene email completo
   AND   payload contiene fields_changed,
         target_user_id

12.3 Tests de integracion
=========================

12.3.1 Endpoint PATCH 200 (CA-01)
---------------------------------

::

   GIVEN admin con modify_users autenticado
   WHEN  PATCH /api/users/{id}/ con
         {first_name:'Ana Maria'}
   THEN  status == 200
   AND   body.fields_changed == ['first_name']

12.3.2 Bloqueo via endpoint (CA-02)
-----------------------------------

::

   GIVEN User con 2 Sessions activas
   WHEN  PATCH /api/users/{id}/
         {state:'BLOCKED'}
   THEN  status == 200
   AND   body.sessions_closed == 2
   AND   subsiguiente login con esos tokens
         responde 401

12.3.3 Sin permiso 403 (CA-05)
------------------------------

::

   GIVEN admin sin modify_users
   WHEN  PATCH /api/users/{id}/
   THEN  status == 403
   AND   AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT

12.3.4 User no existe 404 (CA-06)
---------------------------------

::

   GIVEN user_id 99999 no existe
   WHEN  PATCH /api/users/99999/
   THEN  status == 404

12.3.5 Email duplicado 409 (CA-07)
----------------------------------

::

   GIVEN existe otro User con email X
   WHEN  PATCH cambia email a X
   THEN  status == 409 EMAIL_EXISTS
   AND   sin cambios

12.3.6 Transicion invalida 400 (CA-08)
--------------------------------------

::

   GIVEN User con state ELIMINATED
   WHEN  PATCH state=ACTIVE
   THEN  status == 400 INVALID_STATE_TRANSITION

12.3.7 Auto-state-change 400 (CA-04)
------------------------------------

::

   GIVEN admin con modify_users
   WHEN  PATCH /api/users/{admin.id}/
         {state:'BLOCKED'}
   THEN  status == 400
         SELF_STATE_CHANGE_FORBIDDEN

12.3.8 Token rechazado post-bloqueo
-----------------------------------

::

   GIVEN admin bloquea User X
   WHEN  cliente con token valido de X intenta
         GET /api/users/me/
   THEN  status == 401 (token blacklisteado)

12.3.9 Audit registra fields_changed (CA-12)
--------------------------------------------

::

   GIVEN PATCH con multiples campos
   WHEN  buscar AuditEvent USER_MODIFIED
   THEN  payload.fields_changed contiene exactamente
         las keys del patch

12.3.10 Atomicidad ante falla audit (CA-11)
-------------------------------------------

::

   GIVEN AuditLog.emit lanza
   WHEN  PATCH con state cambio
   THEN  status == 500
   AND   User.state sin cambio (rollback)
   AND   Sessions intactas

12.3.11 Throttling 429 (CA-17)
------------------------------

::

   GIVEN admin con > 60 PATCH/min
   WHEN  envia PATCH 61
   THEN  status == 429

12.4 Tests E2E
==============

12.4.1 Admin modifica datos personales
--------------------------------------

::

   GIVEN admin autenticado en UI
   WHEN  abre detalle del User, edita
         first_name, click Guardar
   THEN  toast confirma cambio
   AND   tabla de Users actualizada

12.4.2 Bloqueo con confirmacion (CA-18)
---------------------------------------

::

   GIVEN admin abre detalle
   WHEN  cambia state a BLOCKED
   THEN  modal de confirmacion robusto
         (no se envia sin confirmar)
   AND   tras confirmar, status BLOCKED visible
   AND   contador de Sessions activas == 0

12.4.3 Notificacion al User (CA-19)
-----------------------------------

::

   GIVEN politica NOTIFY=true y state cambio
   WHEN  admin bloquea User
   THEN  el User al ingresar via UI ve
         InternalMessage en buzon

12.4.4 Self-state-change bloqueado en UI
----------------------------------------

::

   GIVEN admin abre su propio detalle
   WHEN  intenta cambiar su state
   THEN  campo state deshabilitado o submit
         devuelve 400 con mensaje claro

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente logico
   - Lineas
   - Branches
 * - UserService.modify_user
   - ≥ 95%
   - ≥ 90%
 * - StateMachine
   - 100%
   - 100%
 * - AntiSelfActionPolicy
   - 100%
   - 100%
 * - NotifyOnModifyStrategy
   - ≥ 95%
   - ≥ 90%
 * - HTTPPatchEndpoint
   - ≥ 90%
   - ≥ 85%
 * - AuthorizationGuard modify_users
   - 100%
   - 100%

12.6 Resumen
============

.. list-table::
 :widths: 15 35 50
 :header-rows: 1

 * - Capa
   - Test
   - CA cubierto
 * - Unit
   - StateMachine ACTIVE→BLOCKED / ELIMINATED →*
   - Estado validation
 * - Unit
   - AntiSelfActionPolicy bloquea / permite
   - CA-04
 * - Unit
   - happy path datos personales
   - CA-01
 * - Unit
   - bloqueo cierra Sessions
   - CA-02
 * - Unit
   - desbloqueo no restaura Sessions
   - CA-03
 * - Unit
   - PATCH parcial preserva
   - CA-09
 * - Unit
   - PATCH idempotente
   - CA-10
 * - Unit
   - atomicidad cierre Sessions falla
   - CA-11
 * - Unit
   - audit sin PII
   - CA-14
 * - Integration
   - endpoint PATCH 200
   - CA-01
 * - Integration
   - bloqueo via endpoint
   - CA-02
 * - Integration
   - sin permiso 403
   - CA-05
 * - Integration
   - user no existe 404
   - CA-06
 * - Integration
   - email duplicado 409
   - CA-07
 * - Integration
   - transicion invalida 400
   - CA-08
 * - Integration
   - auto-state-change 400
   - CA-04
 * - Integration
   - token post-bloqueo rechazado
   - CA-02 (efecto)
 * - Integration
   - audit fields_changed
   - CA-12
 * - Integration
   - throttling 429
   - CA-17
 * - E2E
   - modificar datos personales
   - CA-01 visual
 * - E2E
   - bloqueo con confirmacion
   - CA-18
 * - E2E
   - notificacion User
   - CA-19
 * - E2E
   - self-state UI bloqueado
   - CA-04 visual

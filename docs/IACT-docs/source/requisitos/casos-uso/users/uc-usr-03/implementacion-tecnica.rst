.. _uc-usr-03-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 **Especificacion abstracta** — contratos +
 pseudocodigo + responsabilidades. Sin atadura
 a un stack concreto. Aplica DEC-USR01-03.

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPPatchEndpoint**
   - Recibir PATCH ``/api/users/{id}/``,
     deserializar payload, delegar al servicio
 * - **AuthenticationGuard**
   - Validar token
 * - **AuthorizationGuard**
   - Verificar ``modify_users``
 * - **ThrottlePolicy**
   - 60 PATCH/min/admin
 * - **PatchValidator**
   - Validar tipos, formatos, prohibidos
     (username, password_hash, etc.)
 * - **StateMachine**
   - Validar transicion permitida; conocer
     side-effects de cada transicion
 * - **AntiSelfActionPolicy**
   - Validar ``admin.id != target.user_id``
     cuando hay cambio de state (P-11)
 * - **EmailUniquenessChecker**
   - Si email cambia, verificar unicidad
 * - **UserRepository**
   - get_by_id_for_update, update_partial
 * - **SessionService**
   - close_all_active_for_user (invocado en
     state → BLOCKED)
 * - **InternalMailbox**
   - Notificacion opcional (politica)
 * - **AuditLog**
   - Append-only
 * - **TransactionManager**
   - Atomicidad pasos 8-10
 * - **NotifyOnModifyStrategy**
   - Decision injectable: notificar User?
     (default: solo si state cambio)

11.2 Contratos
==============

::

   contract UserService:
     modify_user(target_user_id: int,
                 patch: ModifyUserPatch,
                 invoker: AuthenticatedUser,
                 context: RequestContext)
       returns: ModifyUserOutput
       throws: SinPermiso, UserNotFound,
               SelfStateChangeForbidden,
               InvalidStateTransition,
               EmailExists, ValidationError,
               BDTimeout, AuditFalla

   data ModifyUserPatch:
     # Todos opcionales — PATCH parcial
     first_name: opt[string]
     last_name: opt[string]
     email: opt[string]
     state: opt[enum {ACTIVE, INACTIVE, BLOCKED}]
     segment_id: opt[int]
     # Prohibidos: username, password_hash,
     # access_groups, id, created_at

   data ModifyUserOutput:
     user_id: int
     username: string
     fields_changed: list[string]
     state_transition: opt[StateTransition]
     sessions_closed: int
     user_notified: bool
     modified_at: timestamp

   data StateTransition:
     from_state: string
     to_state: string

   contract StateMachine:
     allowed_transitions() returns
       dict[(from, to) -> Transition]
     validate(current, target) returns bool
       throws: InvalidStateTransition
     side_effects(transition) returns
       list[SideEffect]

   contract SessionService:
     close_all_active_for_user(user, admin,
                                close_reason)
       returns: closed_count
       guarantee:
         - todas las Sessions ACTIVE → CLOSED
         - tokens activos blacklisted

   contract NotifyOnModifyStrategy:
     should_notify(patch, transition) returns bool

11.3 Pseudocodigo del flujo principal
=====================================

::

   procedure modify_user(target_id, patch,
                         invoker, ctx):

       # PASO 4
       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker, 'modify_users')
       require ThrottlePolicy.is_allowed(invoker)

       # PASO 5
       PatchValidator.validate(patch)

       # PASO 8-10 atomico
       result = TransactionManager.atomic(():

           target = UserRepository.get_by_id_for_update(
                      target_id)
           if target is None:
               raise UserNotFound

           # PASO 6
           if patch.state is not None:
               require AntiSelfActionPolicy.allows(
                         invoker, target,
                         action='state_change')
               StateMachine.validate(
                 current = target.state,
                 target = patch.state)

           # PASO 7
           if patch.email is not None
              and patch.email != target.email:
               require EmailUniquenessChecker
                         .is_available(patch.email,
                                        excluding=target.id)

           # PASO 8
           old_state = target.state
           UserRepository.update_partial(
               target,
               fields = patch_as_dict(patch),
               metadata = {
                 last_modified_at: now(),
                 last_modified_by_admin_id: invoker.id,
                 state_changed_at: now()
                   if patch.state else None})

           # PASO 9
           sessions_closed_count = 0
           transition = None
           if patch.state is not None
              and patch.state != old_state:
               transition = StateTransition(
                 from_state = old_state,
                 to_state = patch.state)
               for effect in StateMachine.side_effects(
                              transition):
                   sessions_closed_count =
                     effect.execute(target, invoker)

           # PASO 11
           user_notified = False
           if NotifyOnModifyStrategy.should_notify(
                patch, transition):
               InternalMailbox.send(
                 recipient_id = target.id,
                 subject = 'Tu cuenta fue actualizada',
                 body = build_notification_body(
                          transition))
               user_notified = True

           # PASO 10
           AuditLog.emit(
             event_type = 'USER_MODIFIED',
             actor_id = invoker.id,
             payload = {
               target_user_id: target.id,
               fields_changed: list(patch_as_dict(patch)
                                    .keys()),
               state_transition: transition,
               sessions_closed_count:
                 sessions_closed_count,
               ip: ctx.ip,
               user_agent: ctx.user_agent})

           return {target, fields_changed: ...,
                   transition, sessions_closed_count,
                   user_notified}
       )

       return ModifyUserOutput(
         user_id = result.target.id,
         username = result.target.username,
         fields_changed = result.fields_changed,
         state_transition = result.transition,
         sessions_closed = result.sessions_closed_count,
         user_notified = result.user_notified,
         modified_at = result.target.last_modified_at)

11.4 Mapeo excepcion → respuesta HTTP
=====================================

.. list-table::
 :widths: 35 30 35
 :header-rows: 1

 * - Excepcion
   - Status
   - Body code
 * - sin token / token invalido
   - 401
   - INVALID_TOKEN
 * - SinPermiso
   - 403
   - FORBIDDEN
 * - UserNotFound
   - 404
   - USER_NOT_FOUND
 * - SelfStateChangeForbidden
   - 400
   - SELF_STATE_CHANGE_FORBIDDEN
 * - InvalidStateTransition
   - 400
   - INVALID_STATE_TRANSITION
 * - EmailExists
   - 409
   - EMAIL_EXISTS
 * - ValidationError
   - 400
   - VALIDATION_ERROR
 * - BDTimeout
   - 503
   - DB_TIMEOUT
 * - AuditFalla
   - 500
   - AUDIT_FAILED
 * - throttle exceeded
   - 429
   - RATE_LIMIT

11.5 Tabla canonica de transiciones de state
============================================

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Desde → A
   - Permitida?
   - Side-effect
 * - ACTIVE → INACTIVE
   - SI
   - (ninguno especifico)
 * - ACTIVE → BLOCKED
   - SI
   - cerrar Sessions, blacklist tokens
 * - INACTIVE → ACTIVE
   - SI
   - (ninguno)
 * - INACTIVE → BLOCKED
   - SI
   - cerrar Sessions (si hay), blacklist
 * - BLOCKED → ACTIVE
   - SI
   - (ninguno — Sessions no se restauran)
 * - BLOCKED → INACTIVE
   - SI
   - (ninguno)
 * - * → ELIMINATED
   - NO
   - (UC_USR_04 lo realiza)
 * - ELIMINATED → *
   - NO
   - (estado terminal)

11.6 Restricciones cross-cutting
================================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Restriccion
   - Implementacion
 * - **Atomicidad**
   - TransactionManager.atomic envuelve
     PASOS 8-10. Si cualquier paso lanza,
     ROLLBACK total.
 * - **Audit obligatorio**
   - AuditLog.emit dentro del bloque atomico.
     CNST-025: sin audit, no operacion.
 * - **PII fuera del payload**
   - AuditEvent.payload contiene solo IDs y
     keys de campos modificados.
     ``email`` y ``full_name`` NO en payload.
 * - **State machine enforcement**
   - Tabla de transiciones permitidas
     declarativa. Solo configurable por
     admin de seguridad — no en runtime.

11.7 Stack-agnostico
====================

Cualquier stack que respete los contratos
satisface el UC. La implementacion concreta
(Django/DRF, Express, Spring, ASP.NET Core)
NO pertenece al UC; vive en
``arquitectura-tecnica/`` y en los modulos del
backend.

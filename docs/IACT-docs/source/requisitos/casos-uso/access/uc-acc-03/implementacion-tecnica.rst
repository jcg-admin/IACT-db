.. _uc-acc-03-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 **Especificacion abstracta** — contratos +
 pseudocodigo. Aplica DEC-USR01-03.

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPGetEndpoint**
   - GET ``/api/users/{id}/effective-permissions/``
 * - **AuthenticationGuard**
   - JWT (CNST-009)
 * - **AuthorizationGuard**
   - Verifica ``view_assignments`` o self-view
 * - **ThrottlePolicy**
   - 100 GET/min/invoker
 * - **AssignmentRepository**
   - list_active_for_user (direct + AGR)
 * - **AGRRepository**
   - expand_functions_for_agrs
 * - **ExceptionalPermissionRepository**
   - list_active_for_user
 * - **EffectivePermissionsAggregator**
   - consolida 3 fuentes en set deduplicado
     con metadata
 * - **ExpiredPendingDetector**
   - filtra Assignments con expired_at < NOW()
 * - **SoDValidator (info mode)**
   - detecta violaciones sin bloquear
 * - **AuditLog**
   - emit P-16

11.2 Contratos
==============

::

   contract AccessService:
     get_effective_permissions(
       target_user_id: int,
       invoker: AuthenticatedUser,
       options: opt[Options])
       returns: EffectivePermissionsView
       throws: SinPermiso, UserNotFound

   data EffectivePermissionsView:
     user_id: int
     username: string
     self_view: bool
     effective_functions: list[FunctionWithSources]
     via_direct_count: int
     via_agr_count: int
     via_exceptional_count: int
     effective_total_count: int
     expired_pending_purge: list[ExpiredItem]
     sod_violations_detected: list[SoDViolation]

   data FunctionWithSources:
     function_id: int
     function_code: string
     display_name: string
     sources: list[Source]

   data Source = (
     DirectSource(assignment_id, expires_at?)
   | ViaAGRSource(agr_id, agr_code)
   | ExceptionalSource(permission_id,
                       expires_at)
   )

   contract EffectivePermissionsAggregator:
     aggregate(
       direct: list[Assignment],
       agr_assignments: list[Assignment],
       agr_function_map: map[agr_id, list[Function]],
       exceptional: list[ExceptionalPermission])
       returns: list[FunctionWithSources]
     # Deduplica por function_id, preserva
     # todas las sources

11.3 Pseudocodigo del flujo principal
=====================================

::

   procedure get_effective_permissions(
             target_user_id, invoker, options):

       # PASO 3
       require AuthenticationGuard.is_valid(invoker)

       # PASO 4 (con self-view bypass)
       is_self = (target_user_id == invoker.id)
       if not is_self:
           require AuthorizationGuard
                     .has_function(invoker,
                                    'view_assignments')
       require ThrottlePolicy.is_allowed(invoker)

       # PASO 5
       target = UserRepository.get_by_id(target_user_id)
       if target is None:
           raise UserNotFound

       # PASOS 6-9
       direct_assignments =
         AssignmentRepository
           .list_active_direct(target)
       agr_assignments =
         AssignmentRepository
           .list_active_agr(target)
       agr_ids = {a.target_id for a in agr_assignments}
       agr_function_map =
         AGRRepository
           .expand_functions_for_agrs(agr_ids)
       exceptional =
         ExceptionalPermissionRepository
           .list_active_for_user(target, NOW())

       # PASO 10
       effective =
         EffectivePermissionsAggregator
           .aggregate(direct_assignments,
                      agr_assignments,
                      agr_function_map,
                      exceptional)

       # PASO 11
       expired_pending =
         ExpiredPendingDetector
           .find(direct_assignments + agr_assignments)

       # PASO 12
       effective_function_ids =
         {f.function_id for f in effective}
       sod_rules = SoDRuleRepository.list_active()
       sod_violations =
         SoDValidator
           .find_violations_info_mode(
             effective_function_ids, sod_rules)

       # PASO 13 — audit P-16
       AuditLog.emit(
         event_type='EFFECTIVE_PERMISSIONS_VIEWED',
         actor_id=invoker.id,
         payload={
           target_user_id: target.id,
           self_view: is_self,
           effective_count: len(effective),
           via_direct_count:
             count_by_source(effective, 'direct'),
           via_agr_count:
             count_by_source(effective, 'via_agr'),
           via_exceptional_count:
             count_by_source(effective, 'exceptional'),
           expired_pending_count:
             len(expired_pending),
           sod_violations_count:
             len(sod_violations),
           ip: ctx.ip,
           user_agent: ctx.user_agent})

       return EffectivePermissionsView(
         user_id=target.id,
         username=target.username,
         self_view=is_self,
         effective_functions=effective,
         via_direct_count=...,
         via_agr_count=...,
         via_exceptional_count=...,
         effective_total_count=len(effective),
         expired_pending_purge=expired_pending,
         sod_violations_detected=sod_violations)

11.4 Mapeo excepcion → respuesta HTTP
=====================================

.. list-table::
 :widths: 35 25 40
 :header-rows: 1

 * - Excepcion
   - Status
   - Body code
 * - sin token
   - 401
   - INVALID_TOKEN
 * - SinPermiso (no self)
   - 403
   - FORBIDDEN
 * - UserNotFound
   - 404
   - USER_NOT_FOUND
 * - throttle exceeded
   - 429
   - RATE_LIMIT

11.5 Restricciones cross-cutting
================================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Restriccion
   - Implementacion
 * - **Self-view bypass (P-33)**
   - AuthorizationGuard hace pre-check:
     si ``target_user_id == invoker.id``,
     skip ``has_function`` check.
 * - **Audit selectivo (P-16)**
   - emit en cada vista focalizada
     (con user_id especifico).
 * - **Sin PII (CNST-026)**
   - Response y AuditEvent.payload solo
     contienen IDs, codigos, counts.
 * - **Read-only**
   - el servicio NO modifica estado del
     dominio. Solo AuditLog (append-only).

11.6 Stack-agnostico
====================

Cualquier stack que respete los contratos
satisface el UC.

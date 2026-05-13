.. _uc-acc-05-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 Especificacion abstracta. Aplica
 DEC-USR01-03.

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPListEndpoint**
   - GET ``/api/access/sod-rules/``
 * - **HTTPDetailEndpoint**
   - GET por id
 * - **HTTPCreateEndpoint**
   - POST
 * - **HTTPPatchEndpoint**
   - PATCH por id
 * - **HTTPDeleteEndpoint**
   - DELETE por id (soft)
 * - **AuthorizationGuard**
   - Verificar
     ``view_separation_rules`` (read) o
     ``manage_separation_rules`` (CRUD)
 * - **SoDRuleRepository**
   - CRUD de SoDRule
 * - **FunctionRepository**
   - validate_functions
 * - **DuplicateChecker**
   - find_active_with_same_functions
 * - **ViolationsImpactCalculator**
   - count_existing_violations
 * - **SoDRuleCache**
   - invalidate post-COMMIT
 * - **AuditLog**
   - emit por operacion
 * - **TransactionManager**
   - Atomicidad

11.2 Contratos
==============

::

   contract SoDRuleService:
     list(filters, pagination, invoker)
       returns: PaginatedResult<SoDRule>
       throws: SinPermiso (sin
                view_separation_rules)

     get(rule_id, invoker)
       returns: SoDRule
       throws: SinPermiso, SoDRuleNotFound

     create(payload, invoker)
       returns: CreateSoDRuleOutput
       throws: SinPermiso, ValidationError,
               FunctionNotFound,
               FunctionInactive,
               SoDRuleDuplicate, AuditFalla

     modify(rule_id, patch, invoker)
       returns: SoDRule
       throws: SinPermiso, SoDRuleNotFound,
               SoDRuleAlreadyRetired,
               FunctionIdsImmutable

     retire(rule_id, retire_reason, invoker)
       returns: SoDRule
       throws: SinPermiso, SoDRuleNotFound,
               SoDRuleAlreadyRetired,
               ValidationError

   data CreateSoDRuleOutput:
     rule: SoDRule
     existing_violations_count: int
     violating_user_ids_sample: list[int]

11.3 Pseudocodigo de crear (sub-flujo 3.B)
==========================================

::

   procedure create_sod_rule(payload, invoker, ctx):

       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker, 'manage_separation_rules')
       require ThrottlePolicy.is_allowed(invoker)

       PayloadValidator.validate(payload)

       FunctionRepository
         .validate_functions_active(
           payload.function_ids)

       existing = SoDRuleRepository
                    .find_active_with_same_functions(
                      payload.function_ids)
       if existing is not None:
           raise SoDRuleDuplicate(existing.id)

       # Calcular impact retroactivo
       (violations_count,
        violating_user_ids_sample) =
         ViolationsImpactCalculator
           .count_existing_for_function_set(
             payload.function_ids,
             sample_size=10)

       # Atomico
       result = TransactionManager.atomic(():
         rule = SoDRuleRepository.insert(
           name=payload.name,
           description=payload.description,
           function_ids=payload.function_ids,
           severity=payload.severity,
           state=ACTIVE,
           created_at=now(),
           created_by_admin_id=invoker.id)

         AuditLog.emit(
           event_type='SOD_RULE_CREATED',
           actor_id=invoker.id,
           payload={
             rule_id: rule.id,
             rule_name: rule.name,
             function_ids: payload.function_ids,
             severity: payload.severity,
             existing_violations_count:
               violations_count,
             ip: ctx.ip,
             user_agent: ctx.user_agent})

         return rule
       )

       SoDRuleCache.invalidate()  # post-COMMIT

       return CreateSoDRuleOutput(
         rule=result,
         existing_violations_count=violations_count,
         violating_user_ids_sample=
           violating_user_ids_sample)

11.4 Pseudocodigo de retirar (sub-flujo 3.D)
============================================

::

   procedure retire_sod_rule(rule_id,
                             retire_reason,
                             invoker, ctx):

       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker, 'manage_separation_rules')

       if not retire_reason:
           raise ValidationError(
             'retire_reason required')

       rule = SoDRuleRepository
                .get_by_id_for_update(rule_id)
       if rule is None:
           raise SoDRuleNotFound
       if rule.state == RETIRED:
           raise SoDRuleAlreadyRetired

       (residual_violations_count, _) =
         ViolationsImpactCalculator
           .count_existing_for_function_set(
             rule.function_ids,
             sample_size=0)

       result = TransactionManager.atomic(():
         SoDRuleRepository.update(
           rule_id,
           state=RETIRED,
           retired_at=now(),
           retired_by_admin_id=invoker.id,
           retire_reason=retire_reason)

         AuditLog.emit(
           event_type='SOD_RULE_RETIRED',
           actor_id=invoker.id,
           payload={
             rule_id: rule.id,
             retire_reason: retire_reason,
             residual_violations_count:
               residual_violations_count,
             ip: ctx.ip,
             user_agent: ctx.user_agent})

         return rule
       )

       SoDRuleCache.invalidate()  # post-COMMIT

       return result

11.5 Mapeo excepcion → HTTP
===========================

.. list-table::
 :widths: 40 20 40
 :header-rows: 1

 * - Excepcion
   - Status
   - Body code
 * - sin token
   - 401
   - INVALID_TOKEN
 * - SinPermiso
   - 403
   - FORBIDDEN
 * - SoDRuleNotFound
   - 404
   - SOD_RULE_NOT_FOUND
 * - FunctionNotFound
   - 400
   - FUNCTION_NOT_FOUND
 * - FunctionInactive
   - 400
   - FUNCTION_INACTIVE
 * - SoDRuleDuplicate
   - 409
   - SOD_RULE_DUPLICATE
 * - SoDRuleAlreadyRetired
   - 400
   - SOD_RULE_ALREADY_RETIRED
 * - FunctionIdsImmutable
   - 400
   - FUNCTION_IDS_IMMUTABLE
 * - ValidationError
   - 400
   - VALIDATION_ERROR
 * - BDTimeout
   - 503
   - DB_TIMEOUT
 * - AuditFalla
   - 500
   - AUDIT_FAILED

11.6 Restricciones cross-cutting
================================

- Atomicidad por operacion.
- Audit obligatorio (CNST-025).
- PII fuera del payload (CNST-026).
- Cache post-COMMIT (P-29).
- function_ids inmutable (P-36).
- retire_reason obligatorio (P-32).

11.7 Stack-agnostico
====================

Cualquier stack que respete los contratos.

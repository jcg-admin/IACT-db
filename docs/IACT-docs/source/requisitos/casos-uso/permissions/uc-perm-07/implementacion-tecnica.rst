.. _uc-perm-07-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **PermissionService**
   - API publica check / check_bulk
 * - **PrecedenceEvaluator**
   - aplicar P-50 sobre los datos leidos
 * - **ExceptionalPermissionRepo**
   - revoke / grant activos
 * - **AssignmentRepo**
   - AGR ACTIVE con funcion
 * - **PermissionCache**
   - get / set / invalidate
 * - **CheckPermissionEndpoint**
   - solo modo admin (GET)
 * - **CheckPermissionBulkEndpoint**
   - POST bulk
 * - **AuthorizationGuard**
   - ``view_assignments`` (admin)
 * - **MetricsCollector**
   - hits, misses, denies — para alerting

11.2 Contratos
==============

::

   contract PermissionService:
     check(user_id: int,
           function_code: string,
           context: RequestContext,
           bypass_cache: bool = false)
       returns: CheckPermissionOutput
       throws: UserNotFound,
               FunctionNotFound,
               BDTimeout

     check_bulk(user_id: int,
                function_codes: list[string],
                context: RequestContext)
       returns: BulkCheckOutput
       throws: ValidationError,
               UserNotFound,
               BDTimeout

   data CheckPermissionOutput:
     user_id: int
     function_code: string
     allowed: bool
     origin: enum
     via_agr_codes: list[string]
     valid_until: timestamp | null
     cache: bool
     checked_at: timestamp

   contract PrecedenceEvaluator:
     evaluate(revoke_active: bool,
              grant_active: GrantInfo | null,
              agr_codes: list[string])
       returns: (allowed, origin,
                 via_agr_codes,
                 valid_until)

11.3 Pseudocodigo
=================

::

   procedure check(user_id, function_code,
                   ctx, bypass_cache=false):
       # Validacion estructural
       if not function_code: raise
                ValidationError
       if not FunctionRepo.exists(
                function_code):
           raise FunctionNotFound
       if not UserRepo.exists(user_id):
           raise UserNotFound

       key = "perm:" + user_id + ":"
                                + function_code

       # Cache lookup
       if not bypass_cache:
           hit = PermissionCache.get(key)
           if hit:
               metrics.cache_hits += 1
               return hit + { cache: true }

       metrics.cache_misses += 1

       # Una sola query agregada
       try:
           data = AggregateAuthQuery.run(
             user_id, function_code)
       except BDTimeout:
           metrics.bd_timeouts += 1
           raise   # caller fail-closed

       # Aplicar precedencia (P-50)
       result = PrecedenceEvaluator.evaluate(
         revoke_active=data.revoked,
         grant_active=data.grant,
         agr_codes=data.agr_codes)

       if not result.allowed:
           metrics.denies += 1

       # Cache write
       ttl = compute_ttl(
         default=60,
         valid_until=result.valid_until)
       PermissionCache.set(key, result, ttl)

       return result + { cache: false }

   procedure evaluate(revoke, grant, agrs):
       if revoke:
           return { allowed: false,
                    origin: REVOKED_EXCEPTIONAL,
                    via_agr_codes: [],
                    valid_until: null }
       if grant:
           return { allowed: true,
                    origin: GRANTED_EXCEPTIONAL,
                    via_agr_codes: [],
                    valid_until:
                      grant.valid_until }
       if agrs and len(agrs) > 0:
           return { allowed: true,
                    origin: GRANTED_BY_AGR,
                    via_agr_codes: agrs,
                    valid_until: null }
       return { allowed: false,
                origin: DENIED_NO_GRANT,
                via_agr_codes: [],
                valid_until: null }

11.4 Mapeo excepcion → HTTP (admin endpoint)
============================================

.. list-table::
 :widths: 40 20 40
 :header-rows: 1

 * - Excepcion
   - Status
   - Body code
 * - SinPermiso
   - 403
   - FORBIDDEN
 * - UserNotFound
   - 404
   - USER_NOT_FOUND
 * - FunctionNotFound
   - 400
   - FUNCTION_NOT_FOUND
 * - ValidationError
   - 400
   - VALIDATION_ERROR
 * - BDTimeout
   - 503
   - SERVICE_UNAVAILABLE
 * - Throttle
   - 429
   - RATE_LIMITED

11.5 Restricciones cross-cutting
================================

- Read-only — sin transaccion.
- Fail-closed (P-08).
- Sin audit por invocacion (P-51).
- Cache invalidate por evento (P-29).
- Una query agregada por miss.

11.6 Stack-agnostico
====================

- Cache: Redis / Memcached / in-process —
  el contrato no asume.
- BD: cualquier RDBMS con soporte de
  ARRAY / JSON aggregations o equivalente
  via subqueries.
- Decorator API: depende del framework — el
  servicio expone funcion publica reutilizable.

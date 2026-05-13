.. _uc-acc-09-parte-11:

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
   - GET ``/api/access/audit/``
 * - **HTTPDetailEndpoint**
   - GET por id
 * - **HTTPAggregateEndpoint**
   - GET ``/aggregations/``
 * - **AuthorizationGuard**
   - ``view_access_audit``
 * - **ThrottlePolicy**
   - 200 GET/min
 * - **FilterValidator**
   - whitelist + bounds
 * - **AuditEventRepository**
   - list_paginated, get_by_id, aggregate
 * - **ScopeFilter**
   - aplica
     ``event_type__in=ACCESS_EVENT_TYPES``
 * - **PIIMaskingStrategy**
   - defensa secundaria contra leaks
 * - **AuditLog**
   - emit P-16

11.2 Contratos
==============

::

   contract AccessAuditService:
     list(filters, pagination, ordering,
          invoker)
       returns: PaginatedResult<AuditEventView>
       throws: SinPermiso, BadFilter

     get(event_id, invoker)
       returns: AuditEventDetail
       throws: SinPermiso, EventNotFound

     aggregate(group_by, filters, invoker)
       returns: list[AggregatedEntry]
       throws: SinPermiso, BadFilter

   data AuditEventView:
     id, event_type, occurred_at,
     actor_user_id, actor_username,
     target_user_id?, target_username?,
     summary, payload_preview

   constant ACCESS_EVENT_TYPES = [...]
     (ver Parte 7 § 7.8)

11.3 Pseudocodigo (listado)
===========================

::

   procedure list_audit(filters, pagination,
                        ordering, invoker, ctx):

       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker, 'view_access_audit')
       require ThrottlePolicy.is_allowed(invoker)

       FilterValidator.validate(filters, ordering)

       # P-40: pre-filtro de scope
       query = AuditEventRepository
                 .where(event_type__in=
                        ACCESS_EVENT_TYPES)
                 .apply(filters)
                 .order_by(ordering or
                           '-occurred_at')

       (rows, total) = AuditEventRepository
                         .paginate(query,
                                    pagination)

       # P-19: mascarado defensivo
       items = [PIIMaskingStrategy
                  .mask_for_audit_view(row)
                for row in rows]

       # P-16: audit selectivo
       if filters.target_user_id is not None:
           AuditLog.emit(
             event_type='ACCESS_AUDIT_VIEWED',
             actor_id=invoker.id,
             payload={
               target_user_id:
                 filters.target_user_id,
               filters_summary:
                 summarize(filters),
               results_count: total,
               ip: ctx.ip,
               user_agent: ctx.user_agent})

       return PaginatedResult(
         count=total,
         results=items,
         page=pagination.page,
         page_size=pagination.page_size)

11.4 Mapeo excepcion → HTTP
===========================

.. list-table::
 :widths: 35 25 40
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
 * - BadFilter
   - 400
   - BAD_FILTER
 * - EventNotFound
   - 404
   - EVENT_NOT_FOUND
 * - throttle
   - 429
   - RATE_LIMIT

11.5 Restricciones cross-cutting
================================

- **Scope ACCESS_EVENT_TYPES** (P-40):
  pre-filtro en query.
- **Whitelist filtros** (P-20).
- **Audit selectivo** (P-16).
- **Mascarado PII defensivo** (P-19).
- **Read-only**: solo AuditLog en P-16
  modifica estado.

11.6 Stack-agnostico
====================

Cualquier stack que respete los contratos.

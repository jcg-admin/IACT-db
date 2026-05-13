.. _uc-perm-10-parte-11:

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
 * - **AuditQueryEndpoint**
   - GET / POST endpoints
 * - **AuthorizationGuard**
   - JWT + view_audit_log
 * - **FilterValidator**
   - validar filtros + range
 * - **AuditRepo (read replica)**
   - query / get / aggregate
 * - **CursorEncoder**
   - encode / decode opaco
 * - **PayloadSanitizer**
   - truncar + 0 PII
 * - **ExportWorker**
   - procesar jobs en background
 * - **MailboxService**
   - notificar auditor
 * - **AuditService (UC_PERM_09)**
   - meta-audit

11.2 Contratos
==============

::

   contract AuditQueryService:
     list(filters: AuditFilters,
          cursor: string | null,
          page_size: int,
          invoker: AuthenticatedUser,
          context: RequestContext)
       returns: ListAuditOutput
       throws: SinPermiso, ValidationError,
               CursorInvalid, BDTimeout,
               AuditUnavailable

     get(id: uuid,
         invoker, context)
       returns: AuditEvent
       throws: SinPermiso, NotFound,
               AuditUnavailable

     aggregate(filters, group_by,
               invoker, context)
       returns: AggregateOutput
       throws: SinPermiso, AggregateLimit,
               AuditUnavailable

     export(filters, format,
            include_archive,
            invoker, context)
       returns: ExportJobRef
       throws: SinPermiso, QueueFull,
               AuditUnavailable

   data ListAuditOutput:
     events: list[AuditEvent]
     next_cursor: string | null
     estimated_total: int
     query_id: uuid

11.3 Pseudocodigo (list)
========================

::

   procedure list(filters, cursor,
                  page_size, invoker, ctx):
       # Auth + RBAC
       require AuthorizationGuard
                 .has_function(invoker,
                   'view_audit_log')

       # Validate filters
       FilterValidator.validate(filters)
       if cursor:
           decoded =
             CursorEncoder.decode(cursor)
           assert decoded.filters_hash ==
                    hash(filters)

       # Apply scope (CNST-008 conditional)
       scoped = apply_scope(
         filters, invoker.scope)

       # Query
       try:
           rows =
             AuditRepo.query(
               scoped,
               cursor=decoded if cursor
                                 else null,
               limit=page_size + 1)
       except BDTimeout:
           raise

       has_more = len(rows) > page_size
       rows = rows[:page_size]

       # Sanitizar
       events = [
         PayloadSanitizer.truncate(r)
         for r in rows
       ]

       next_cursor = (
         CursorEncoder.encode(
           rows[-1], hash(filters))
         if has_more else null)

       estimated_total =
         AuditRepo.estimate(scoped)

       query_id = uuid_v7()

       # Meta-audit (P-44)
       try:
           AuditService.emit(
             event_type='AUDIT_LOG_QUERIED',
             actor_id=invoker.id,
             target_type='audit_query',
             target_id=query_id,
             payload={
               filters: sanitize(filters),
               page_size,
               row_count: len(events),
               query_id
             },
             context=ctx)
       except AuditFailure:
           raise AuditUnavailable

       return ListAuditOutput(
         events, next_cursor,
         estimated_total, query_id)

11.4 Mapeo excepcion → HTTP
===========================

.. list-table::
 :widths: 40 20 40
 :header-rows: 1

 * - Excepcion
   - Status
   - Body code
 * - SinPermiso
   - 403
   - FORBIDDEN
 * - ValidationError
   - 400
   - VALIDATION_ERROR
 * - CursorInvalid
   - 400
   - CURSOR_INVALID
 * - NotFound
   - 404
   - AUDIT_EVENT_NOT_FOUND
 * - AggregateLimit
   - 400
   - AGGREGATE_LIMIT_EXCEEDED
 * - QueueFull
   - 503
   - EXPORT_QUEUE_FULL
 * - BDTimeout
   - 503
   - SERVICE_UNAVAILABLE
 * - AuditUnavailable
   - 503
   - AUDIT_UNAVAILABLE

11.5 Restricciones cross-cutting
================================

- Read replicas (P-25).
- Meta-audit obligatorio.
- Cursor con filters_hash.
- Sin PII en responses.
- Export con mailbox notify.

11.6 Stack-agnostico
====================

- AuditRepo: cualquier RDBMS con
  particionamiento (online vs archive).
- ExportWorker: cualquier runner async
  (Celery, RQ, Sidekiq, custom).
- Storage: object storage con URLs firmadas
  (S3, GCS, Azure Blob, MinIO).
- MailboxService: el internal de IACT.

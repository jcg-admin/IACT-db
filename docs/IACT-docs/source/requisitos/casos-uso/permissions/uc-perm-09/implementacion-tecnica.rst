.. _uc-perm-09-parte-11:

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
 * - **AuditService**
   - API publica (emit, emit_batch)
 * - **AuditValidator**
   - validar event_type, payload size
 * - **PIIScanner**
   - detectar patrones PII
 * - **Sanitizer**
   - hashear, normalizar UTC
 * - **EventFactory**
   - construir AuditEvent con UUID v7
 * - **AuditRepo**
   - INSERT (no UPDATE / DELETE)
 * - **AlertHook**
   - on_commit ⇒ AlertEngine push
 * - **CriticalReplicator**
   - replica sincrona a log secundario

11.2 Contratos
==============

::

   contract AuditService:
     emit(event_type: enum,
          actor_id: int | null,
          target_type: string | null,
          target_id: any | null,
          payload: dict,
          context: RequestContext)
       returns: AuditEmitResult
       throws: AuditValidationError,
               AuditPIIDetected,
               AuditWriteFailed

     emit_batch(events: list[EventInput],
                context: RequestContext)
       returns: list[AuditEmitResult]
       throws: AuditValidationError,
               AuditPIIDetected,
               AuditWriteFailed

   data AuditEmitResult:
     id: uuid
     persisted_at: timestamp

   data AuditEvent:
     id, event_type, actor_id,
     target_type, target_id,
     payload, ip_address, user_agent,
     request_id, module, created_at

11.3 Pseudocodigo
=================

::

   procedure emit(event_type, actor_id,
                  target_type, target_id,
                  payload, ctx):
       # 1) Validacion estructural
       AuditValidator.validate(
         event_type, payload)

       # 2) PII scan (CNST-026 enforcement)
       findings = PIIScanner.scan(payload)
       if findings:
           raise AuditPIIDetected(findings)

       # 3) Sanitizar
       sanitized =
         Sanitizer.sanitize(payload)

       # 4) Construir
       event = EventFactory.build(
         event_type=event_type,
         actor_id=actor_id,
         target_type=target_type,
         target_id=target_id,
         payload=sanitized,
         ip=ctx.ip,
         user_agent=ctx.user_agent,
         request_id=ctx.request_id,
         module=ctx.module,
         created_at=now_utc())

       # 5) INSERT en tx del caller (P-09)
       try:
           AuditRepo.insert(event)
       except BDError as e:
           raise AuditWriteFailed(e)

       # 6) Replicacion CRITICAL (P-39)
       if event_type.priority == CRITICAL:
           CriticalReplicator.replicate_sync(
             event)

       # 7) Hook post-COMMIT (best-effort)
       on_commit_register(
         lambda: AlertHook.consume(event))

       return AuditEmitResult(
         id=event.id,
         persisted_at=now_utc())

11.4 Mapeo excepcion
====================

.. list-table::
 :widths: 40 30 30
 :header-rows: 1

 * - Excepcion (caller side)
   - Manejo
   - HTTP del caller
 * - AuditValidationError
   - rollback caller
   - 500
 * - AuditPIIDetected
   - rollback caller
   - 500
 * - AuditWriteFailed
   - rollback caller
   - 500 (operacion FAILED)
 * - AuditTableLockTimeout
   - rollback caller
   - 503
 * - AlertEnginePushFailed
   - log only
   - n/a (post-COMMIT)

11.5 Restricciones cross-cutting
================================

- Inmutabilidad enforced (P-55).
- PII enforcement (P-54).
- Atomicidad con caller (P-09).
- Replicacion CRITICAL (P-39).
- Sin canales prohibidos (CNST-001/002):
  alertas via internal mailbox / UI, no
  email externo.

11.6 Stack-agnostico
====================

Cualquier RDBMS con:

- Soporte de UUID o equivalente
  (CHAR(36)).
- Triggers o constraints para enforcement
  inmutabilidad.
- Particionamiento (recomendado).

El push a AlertEngine puede ser por mensaje
queue (Kafka, RabbitMQ) o llamada async.

.. _uc-rpt-04-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes logicos
========================

- **ExportEndpoint** (POST /export, GET
  /export/{id}, DELETE /export/{id})
- **AuthorizationGuard**
- **PayloadValidator**
- **JobLimiter** (5 simultaneos por User)
- **ExportJobRepo**
- **ExportWorker** (background)
- **AnalyticsRepo** (streaming)
- **PayloadSanitizer** (sin PII)
- **FormatWriter** (csv / xlsx / json /
  pdf strategies)
- **StorageGateway** (upload + signed URL)
- **MailboxService**
- **AuditService**

11.2 Contratos
==============

::

   contract ExportService:
     queue(payload, invoker, ctx)
       returns: ExportJobRef
       throws: SinPermiso, ValidationError,
               RowLimitExceeded,
               ExportLimitExceeded,
               QueueFull, AuditFailed

     status(job_id, invoker)
       returns: ExportJobStatus
       throws: SinPermiso, NotFound

     cancel(job_id, invoker)
       returns: void
       throws: SinPermiso, NotFound,
               InvalidState

   contract ExportWorker:
     process(job_id)

11.3 Pseudocodigo (queue)
=========================

::

   procedure queue(payload, invoker, ctx):
       require AuthorizationGuard.has(
                 invoker, 'export_reports')
       PayloadValidator.validate(payload)
       estimated_rows =
         AnalyticsRepo.estimate(
           payload.filters, payload.period)
       if estimated_rows > 1_000_000:
           raise RowLimitExceeded
       if JobLimiter.count_active(
              invoker.id) >= 5:
           raise ExportLimitExceeded

       job = ExportJob(
         id=uuid_v7(),
         actor_id=invoker.id,
         report_type=payload.report_type,
         filters=payload.filters,
         period=payload.period,
         group_by=payload.group_by,
         format=payload.format,
         status='queued',
         created_at=now())

       ExportJobRepo.save(job)
       AuditService.emit(
         'REPORT_EXPORT_QUEUED',
         actor_id=invoker.id,
         payload={job_id: job.id, ...},
         context=ctx)
       Worker.enqueue(job.id)
       return ExportJobRef(job_id=job.id)

11.4 Pseudocodigo (worker process)
==================================

::

   procedure process(job_id):
       job = ExportJobRepo.load(job_id)
       job.status = 'running'
       ExportJobRepo.save(job)

       # P-64: re-check
       user =
         UserRepo.load(job.actor_id)
       if not user.has_function(
                'export_reports'):
           fail(job, 'PERMISSION_REVOKED')
           return

       segments =
         SegmentResolver.for(user.id)
       if not segments:
           fail(job, 'PERMISSION_REVOKED')
           return

       writer = FormatWriter.for(job.format)
       try:
           cursor =
             AnalyticsRepo.stream(
               job.filters,
               segments,
               job.period,
               job.group_by)

           total_bytes = 0
           total_rows = 0
           for batch in cursor.batches(10_000):
               sanitized =
                 PayloadSanitizer.sanitize(
                   batch)
               total_bytes +=
                 writer.write(sanitized)
               total_rows += len(sanitized)
               if total_bytes > 200_000_000:
                   fail(job, 'TOO_LARGE')
                   return
               job.progress_pct =
                 cursor.pct()
               ExportJobRepo.save(job)
               if job.cancellation_requested:
                   fail(job, 'CANCELLED')
                   return

           file_path = writer.close()

           url = StorageGateway.upload(
             local_path=file_path,
             remote_path=storage_path(job),
             ttl=86400)

           job.status = 'done'
           job.file_url = url
           job.file_url_expires_at =
             now() + 24h
           job.row_count = total_rows
           job.byte_count = total_bytes
           job.completed_at = now()
           ExportJobRepo.save(job)

           AuditService.emit(
             'REPORT_EXPORT_COMPLETED',
             actor_id=job.actor_id,
             payload={
               job_id: job.id,
               row_count, byte_count})

           MailboxService.notify(
             user_id=job.actor_id,
             subject='Export ready',
             body={ job_id, file_url: url,
                    row_count, byte_count })

       except StorageError:
           fail(job, 'STORAGE_UNAVAILABLE')
       except BDTimeout:
           fail(job, 'BD_TIMEOUT')

11.5 Mapeo excepcion
====================

Ver Parte 5.

11.6 Restricciones cross-cutting
================================

- CNST-001: NO email externo.
- CNST-002: mailbox notify obligatorio.
- CNST-007: Analytics read-only.
- CNST-008: filtro segmento.
- P-39 audit reforzado.
- P-64 re-check at execution.
- P-65 streaming.

11.7 Stack-agnostico
====================

- Worker: Celery / Sidekiq / RQ / custom.
- Storage: S3 / GCS / MinIO / local FS.
- FormatWriter: cualquier libreria CSV /
  XLSX / PDF.

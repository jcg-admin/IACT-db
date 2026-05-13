.. _uc-pip-04-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: PipelineRetryEndpoint,
AuthorizationGuard, PipelineRunRepo,
PipelineExecutor, AuditService.

::

   contract PipelineRetryService:
     retry(pipeline_id, run_id?,
           reason, priority,
           invoker, ctx)
       returns: PipelineRunRef

Pseudocodigo:

::

   procedure retry(pipeline_id, run_id,
                    reason, priority,
                    invoker, ctx):
       require AuthorizationGuard.has(
                 invoker,
                 'request_pipeline_retry')
       if len(reason) < 20:
           raise ValidationError
       pipeline = PipelineRepo.get(pipeline_id)
       if pipeline is null:
           raise NotFound
       if pipeline.is_running:
           raise AlreadyRunning
       new_run = PipelineRunRepo.create(
         pipeline_id, triggered_by='manual',
         retry_of_run_id=run_id,
         actor_id=invoker.id,
         reason, priority)
       PipelineExecutor.enqueue(new_run.id,
                                  priority)
       AuditService.emit(
         'PIPELINE_RETRY_REQUESTED',
         actor_id=invoker.id,
         payload={pipeline_id, run_id,
                   reason, priority,
                   new_run_id: new_run.id})
       return new_run

Stack-agnostico.

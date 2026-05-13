.. _uc-rpt-07-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes logicos
========================

- **ScheduledReportEndpoint** (CRUD)
- **AuthorizationGuard**
- **ScheduleValidator** (cron parser)
- **ScheduledReportRepo**
- **Scheduler** (servicio, tick 1 min)
- **ExportEnqueuer** (delegado a UC_RPT_04)
- **AuditService**
- **MailboxService**

11.2 Contratos
==============

::

   contract ScheduleService:
     create(payload, invoker, ctx)
       returns: ScheduledReportRef
     update(id, payload, invoker, ctx)
     delete(id, invoker, ctx)
     pause(id), resume(id)
     run_now(id, invoker, ctx)
       returns: ExportJobRef

   contract Scheduler:
     tick()  # cada 1 min

11.3 Pseudocodigo (tick)
========================

::

   procedure tick():
       now = now_utc()
       due = ScheduledReportRepo
                .find_due(now,
                            status='active',
                            limit=100,
                            for_update_skip_locked=true)

       for sched in due:
           # P-67: lock + update atomico
           sched.next_run_at =
             compute_next(sched, now)
           ScheduledReportRepo.save(sched)

           # P-64: re-check
           user = UserRepo.load(sched.actor_id)
           if not user.has_function(
                    'export_reports'):
               AuditService.emit(
                 'SCHEDULED_REPORT_PERMISSION_LOST',
                 actor_id=user.id,
                 payload={schedule_id})
               continue

           try:
               job_id =
                 ExportEnqueuer.queue(
                   payload=expand(sched),
                   invoker=user,
                   ctx=...)
               sched.failure_count = 0
               AuditService.emit(
                 'SCHEDULED_REPORT_EXECUTED',
                 actor_id=user.id,
                 payload={schedule_id,
                          job_id})
           except SystemError:
               sched.failure_count += 1
               AuditService.emit(
                 'SCHEDULED_REPORT_FAILED', ...)
               if sched.failure_count >= 3:
                   sched.status = 'auto_paused'
                   AuditService.emit(
                     'SCHEDULED_REPORT_AUTO_PAUSED', ...)
                   MailboxService.notify(
                     user_id=user.id,
                     subject='Schedule auto-paused',
                     body={schedule_id, reason})

           ScheduledReportRepo.save(sched)

11.4 Stack-agnostico
====================

- Scheduler: cron-like nativo del lenguaje
  / Quartz / APScheduler / similar.
- Lock: DB row lock o servicio externo
  (Redlock, Zookeeper).

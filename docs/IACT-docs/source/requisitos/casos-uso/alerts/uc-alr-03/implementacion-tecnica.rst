.. _uc-alr-03-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes: AckEndpoint, AuthorizationGuard,
AlertRepo, AuditService, NotifySuppressor.

Contrato:

::

   contract AlertAckService:
     ack(alert_id, note, invoker, ctx)
       returns: Alert
       throws SinPermiso, NotFound,
              CrossSegment, InvalidState

Pseudocodigo:

::

   procedure ack(alert_id, note,
                  invoker, ctx):
       require AuthorizationGuard.has(
                 invoker,
                 'acknowledge_alerts')
       alert = AlertRepo.get(alert_id)
       if alert is null:
           raise NotFound
       segments = SegmentResolver.for(
                    invoker.id)
       if alert.scope not in segments:
           raise CrossSegment
       if alert.state != 'firing':
           raise InvalidState
       TransactionManager.atomic(():
           alert.state = 'acknowledged'
           alert.acknowledged_by = invoker.id
           alert.acknowledged_at = now()
           alert.acknowledged_note = note
           AlertRepo.save(alert)
           AuditService.emit(
             'ALERT_ACKNOWLEDGED',
             actor_id=invoker.id,
             target_type='alert',
             target_id=alert_id,
             payload={note_excerpt})
       )
       NotifySuppressor.suppress(alert_id)
       return alert

Stack-agnostico.

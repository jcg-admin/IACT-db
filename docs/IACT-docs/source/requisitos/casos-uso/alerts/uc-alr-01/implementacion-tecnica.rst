.. _uc-alr-01-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes
================

- AlertRuleEndpoint (CRUD + dry-run)
- AuthorizationGuard
- RuleValidator
- AlertRuleRepo
- EvaluatorReloader
- DryRunEngine
- AuditService

11.2 Contratos
==============

::

   contract AlertRuleService:
     create(payload, invoker, ctx)
     update(id, payload, invoker, ctx)
     delete(id, invoker, ctx)
     pause(id), resume(id)
     dry_run(payload, invoker)
       returns: DryRunReport

11.3 Pseudocodigo
=================

::

   procedure create(payload, invoker, ctx):
       require AuthorizationGuard.has(
                 invoker,
                 'manage_alert_thresholds')
       segments = SegmentResolver.for(
                    invoker.id)
       RuleValidator.validate(
         payload, segments)
       rule = AlertRule(...)
       AlertRuleRepo.save(rule)
       AuditService.emit(
         'ALERT_RULE_CREATED', ...)
       EvaluatorReloader.notify(rule.id)
       return rule

   procedure dry_run(payload, invoker):
       RuleValidator.validate(
         payload,
         SegmentResolver.for(invoker.id))
       hits = DryRunEngine.evaluate_against(
                payload, period=last_24h)
       return DryRunReport(
         would_have_fired=hits.count,
         sample=hits.first(10))

11.4 Stack-agnostico
====================

- Pub/sub para reload notifications.
- Engine de evaluacion separado.

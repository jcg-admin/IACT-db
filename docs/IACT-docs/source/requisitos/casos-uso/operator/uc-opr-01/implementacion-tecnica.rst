.. _uc-opr-01-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

Componentes
===========

- AgentStateEndpoint
- AuthorizationGuard (auth-only)
- StateTransitionValidator
- AgentStateRepo
- AgentStateHistoryRepo
- AuditService
- CallRouterEventBus

Contrato
========

::

   contract AgentStateService:
     change_state(new_state, reason,
                  invoker, ctx)
       returns: AgentStateOutput
       throws: InvalidTransition,
               ReasonMissing,
               PolicyViolation

Pseudocodigo
============

::

   procedure change_state(new_state,
                          reason,
                          invoker, ctx):
       current = AgentStateRepo.get(
                    invoker.id)
       if not StateTransitionValidator
                .is_valid(current.state,
                            new_state):
           raise InvalidTransition
       if new_state in {break, training}
              and (not reason or
                    len(reason) < 10):
           raise ReasonMissing
       if new_state == break:
           require BreakPolicy
                     .allows(invoker.id)

       TransactionManager.atomic(():
           duration = now() -
                       current.since_at
           AgentStateRepo.set(
             invoker.id, new_state,
             since=now())
           AgentStateHistoryRepo.append(
             invoker.id,
             from_state=current.state,
             to_state=new_state,
             reason=reason,
             duration=duration)
           AuditService.emit(
             'AGENT_STATE_CHANGED', ...)
       )
       on_commit:
           CallRouterEventBus.publish(
             agent_id=invoker.id,
             new_state=new_state)
       return AgentStateOutput(...)

Stack-agnostico.

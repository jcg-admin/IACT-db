.. _uc-opr-01-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Agente" as A
 actor "CallRouter" as CR
 rectangle "MOD_Operator" {
   usecase "UC_OPR_01\nCambiar Estado" as UC01
 }
 A --> UC01
 UC01 --> CR
 @enduml

8.2 Diagrama de estado
======================

.. uml::

 @startuml
 [*] --> offline
 offline --> available : login
 available --> busy : llamada (auto)
 busy --> after_call_work : hangup (auto)
 after_call_work --> available : wrap-up done
 available --> break : manual
 break --> available : manual
 available --> training : manual
 training --> available : end
 available --> offline : logout
 break --> offline : logout
 training --> offline : logout
 after_call_work --> offline : logout
 @enduml

8.3 Diagrama de actividad
=========================

.. uml::

 @startuml
 start
 :POST cambiar estado;
 :JWT;
 :Validar new_state + transicion;
 if (Reason requerida y missing?) then (si)
   :400; stop
 endif
 :BEGIN tx;
 :UPDATE AgentState;
 :INSERT AgentStateHistory;
 :Audit AGENT_STATE_CHANGED;
 :COMMIT;
 :Notify CallRouter;
 :200;
 stop
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Agente" as AG
 participant "Endpoint" as E
 database "AgentStateRepo" as R
 participant "AuditSvc" as A
 participant "CallRouter" as CR
 AG -> E: POST new_state
 E -> R: BEGIN
 E -> R: UPDATE state
 E -> A: emit AGENT_STATE_CHANGED
 E -> R: COMMIT
 E -> CR: state changed
 E --> AG: 200
 @enduml

.. _uc-opr-02-parte-08:

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
   usecase "UC_OPR_02\nAnswer" as UC
 }
 A --> UC
 CR --> UC
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :Offer ring;
 if (Agente acepta?) then (no)
   :Decline; stop
 endif
 :Bridge;
 :State busy;
 :Audit CALL_ANSWERED;
 :200;
 stop
 @enduml

8.3 Estado de la llamada
========================

.. uml::

 @startuml
 [*] --> queued
 queued --> offered
 offered --> bridged : answer
 offered --> queued : decline
 offered --> abandoned : caller hangup
 bridged --> ended : hangup
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Agente" as A
 participant "Frontend" as FE
 participant "Router" as R
 participant "Endpoint" as E
 participant "Telephony" as T
 R -> FE: offer
 FE -> A: ring
 A -> FE: click answer
 FE -> E: POST answer
 E -> T: bridge
 T --> E: ok
 E --> FE: 200
 @enduml

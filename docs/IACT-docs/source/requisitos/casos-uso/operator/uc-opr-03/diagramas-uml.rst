.. _uc-opr-03-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Agente" as A
 rectangle "MOD_Operator" {
   usecase "UC_OPR_03\nOutbound" as UC
 }
 A --> UC
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :POST outbound;
 :JWT + RBAC;
 :Validar destination;
 if (En lista permitida?) then (no)
   :400 BLOCKED; stop
 endif
 :Telephony dial;
 if (Pickup?) then (si)
   :Bridge + state busy;
   :Audit OUTBOUND_INITIATED;
   :200;
 else (no)
   :State available;
   :Audit NO_ANSWER;
 endif
 stop
 @enduml

8.3 Estado
==========

.. uml::

 @startuml
 [*] --> dialing
 dialing --> ringing
 ringing --> bridged : pickup
 ringing --> failed : no_answer|busy
 bridged --> ended : hangup
 failed --> [*]
 ended --> [*]
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Agente" as A
 participant "Endpoint" as E
 participant "Telephony" as T
 A -> E: POST outbound
 E -> E: JWT + RBAC + validar
 E -> T: dial
 T --> E: pickup
 E --> A: 200
 @enduml

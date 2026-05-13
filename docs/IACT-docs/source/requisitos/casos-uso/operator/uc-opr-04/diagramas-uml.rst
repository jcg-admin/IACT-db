.. _uc-opr-04-parte-08:

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
   usecase "UC_OPR_04\nHold/Unhold" as UC
 }
 A --> UC
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :POST hold;
 :Validar ownership;
 :Telephony.hold;
 :UPDATE session;
 :Audit CALL_HELD;
 :200;
 stop
 @enduml

8.3 Estado de la llamada
========================

.. uml::

 @startuml
 [*] --> bridged
 bridged --> on_hold : hold
 on_hold --> bridged : unhold
 bridged --> ended : hangup
 on_hold --> ended : caller hangup
 ended --> [*]
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Agente" as A
 participant "Endpoint" as E
 participant "Telephony" as T
 A -> E: POST hold
 E -> T: hold
 T --> E: ok
 E --> A: 200
 @enduml

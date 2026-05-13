.. _uc-sup-02-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Supervisor con funcion\nbarge_in_calls" as SUP
 rectangle "MOD_Supervision" {
   usecase "UC_SUP_02\nBarge-in" as UC
   usecase "Take over" as TO
 }
 SUP --> UC
 UC ..> TO : <<extend>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :POST barge-in;
 :JWT + RBAC + segmento + reason;
 :Telephony bridge 3-way;
 :Audit CALL_BARGED;
 :200;
 stop
 @enduml

8.3 Modes
=========

.. uml::

 @startuml
 [*] --> active
 active --> takeover : disconnect agent
 active --> ended : leave
 takeover --> ended
 ended --> [*]
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Supervisor" as S
 participant "Telephony" as T
 actor "Agente" as A
 actor "Caller" as C
 S -> T: bridge 3way
 T -> A: announce
 T -> C: announce
 @enduml

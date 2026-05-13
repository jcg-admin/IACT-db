.. _uc-opr-05-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Agente A" as A
 actor "Agente B" as B
 rectangle "MOD_Operator" {
   usecase "UC_OPR_05\nTransfer" as UC
   usecase "Warm" as W
   usecase "Cold" as C
 }
 A --> UC
 UC ..> W : <<extend>>
 UC ..> C : <<extend>>
 W --> B
 C --> B
 @enduml

8.2 Actividad warm
==================

.. uml::

 @startuml
 start
 :POST transfer warm;
 :Consult B;
 if (B accepts?) then (no)
   :Cancel; stop
 endif
 :Bridge caller-B;
 :Disconnect A;
 :Audit;
 :200;
 stop
 @enduml

8.3 Actividad cold
==================

.. uml::

 @startuml
 start
 :POST transfer cold;
 :Direct bridge B;
 :Disconnect A;
 :Audit;
 :200;
 stop
 @enduml

8.4 Secuencia warm
==================

.. uml::

 @startuml
 actor "A" as A
 participant "Caller" as C
 participant "Telephony" as T
 actor "B" as B
 A -> T: consult B
 T -> B: ring
 B -> T: answer
 T -> A: bridged with B
 A -> B: presenta caso
 A -> T: complete transfer
 T -> C: bridge with B
 T -> A: disconnect
 @enduml

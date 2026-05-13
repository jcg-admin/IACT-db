.. _uc-cli-03-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Caller" as C
 actor "CallRouter" as R
 rectangle "MOD_Caller" {
   usecase "UC_CLI_03\nEsperar cola" as UC
   usecase "UC_CLI_04\nCallback" as CB
 }
 C --> UC
 UC --> R
 UC ..> CB : <<extend>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :Insert QueueEntry;
 :Music on hold;
 repeat
   :Update position;
   if (Wait > X?) then (si)
     :Ofrecer callback;
   endif
 repeat while (no asignado)
 :Bridge agente;
 :Remove QueueEntry;
 stop
 @enduml

8.3 Estado
==========

.. uml::

 @startuml
 [*] --> waiting
 waiting --> served : agente asigna
 waiting --> abandoned : caller cuelga
 waiting --> callback_offered : > X min
 callback_offered --> waiting : declina
 callback_offered --> callback_scheduled : acepta
 served --> [*]
 abandoned --> [*]
 callback_scheduled --> [*]
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Caller" as C
 participant "Queue" as Q
 participant "Router" as R
 actor "Agente" as A
 C -> Q: enter
 Q -> R: notify
 R -> A: offer
 A -> R: answer
 R -> Q: dequeue
 Q -> C: bridge
 @enduml

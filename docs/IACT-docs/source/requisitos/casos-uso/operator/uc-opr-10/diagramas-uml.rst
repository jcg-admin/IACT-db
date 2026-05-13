.. _uc-opr-10-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Agente" as A
 actor "Supervisor" as S
 rectangle "MOD_Operator" {
   usecase "UC_OPR_10\nLeer Mailbox" as UC
   usecase "UC_SUP_03\nBroadcast" as B
 }
 S --> B
 B ..> UC : <<include>>
 A --> UC
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET /me/mailbox;
 :JWT;
 :Query mailbox;
 :Filter status;
 :200;
 stop
 @enduml

8.3 Estado mensaje
==================

.. uml::

 @startuml
 [*] --> sent
 sent --> delivered
 delivered --> read : POST read
 read --> archived
 archived --> [*]
 @enduml

8.4 Secuencia push
==================

.. uml::

 @startuml
 actor "Agente" as A
 participant "Frontend" as FE
 queue "MailboxBus" as B
 B -> FE: SSE urgent
 FE -> A: toast
 A -> FE: click read
 FE -> B: POST read
 @enduml

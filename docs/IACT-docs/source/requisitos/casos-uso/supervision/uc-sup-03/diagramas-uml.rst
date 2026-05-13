.. _uc-sup-03-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Supervisor con funcion\nbroadcast_team_messages" as SUP
 actor "Agentes" as AG
 rectangle "MOD_Supervision" {
   usecase "UC_SUP_03\nBroadcast" as UC
 }
 SUP --> UC
 UC --> AG
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :POST broadcast;
 :JWT + RBAC;
 :Validar target;
 :Resolver recipients;
 :Bulk INSERT mailbox;
 if (Urgente?) then (si)
   :SSE push;
 endif
 :Audit BROADCAST_SENT;
 :200;
 stop
 @enduml

8.3 Componentes
===============

.. uml::

 @startuml
 component "Endpoint" as E
 component "MailboxService" as M
 component "SSE Push" as P
 E --> M
 E --> P
 @enduml

8.4 Secuencia urgente
=====================

.. uml::

 @startuml
 actor "Supervisor" as S
 participant "Endpoint" as E
 queue "MailboxBus" as B
 actor "Agente" as A
 S -> E: POST broadcast urgente
 E -> B: bulk insert
 B -> A: SSE push
 A -> A: toast urgente
 @enduml

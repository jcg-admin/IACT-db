.. _uc-opr-09-parte-08:

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
   usecase "UC_OPR_09\nMy History" as UC
 }
 A --> UC
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET /me/calls/;
 :JWT;
 :Validar range;
 :Query own;
 :Sanitize;
 :Paginar;
 :200;
 stop
 @enduml

8.3 Componentes
===============

.. uml::

 @startuml
 component "Endpoint" as E
 component "CallSessionRepo" as R
 component "Sanitizer" as S
 E --> R
 E --> S
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Agente" as A
 participant "Endpoint" as E
 database "Calls" as R
 A -> E: GET /me/calls
 E -> R: query own
 R --> E: rows
 E --> A: 200
 @enduml

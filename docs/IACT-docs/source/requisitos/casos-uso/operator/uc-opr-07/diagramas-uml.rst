.. _uc-opr-07-parte-08:

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
   usecase "UC_OPR_07\nBreak" as UC
   usecase "UC_OPR_01\nState change" as S
 }
 A --> UC
 UC ..> S : <<include>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :POST break;
 :Validar quota;
 if (Excedida?) then (si)
   :409; stop
 endif
 :Delegar UC_OPR_01;
 :Iniciar timer;
 :200;
 stop
 @enduml

8.3 Estado
==========

.. uml::

 @startuml
 [*] --> available
 available --> on_break : POST
 on_break --> available : POST resume
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Agente" as A
 participant "Endpoint" as E
 participant "Policy" as P
 A -> E: POST break
 E -> P: check quota
 P --> E: ok
 E --> A: 200
 @enduml

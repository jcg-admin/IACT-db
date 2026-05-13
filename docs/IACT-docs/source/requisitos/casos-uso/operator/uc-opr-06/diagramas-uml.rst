.. _uc-opr-06-parte-08:

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
   usecase "UC_OPR_06\nDisposition" as UC
 }
 A --> UC
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :POST disposition;
 :JWT + ownership;
 :Validar code + notes;
 if (do_not_call?) then (si)
   :Add DNC list;
 endif
 if (follow_up?) then (si)
   :Crear CallbackEntry;
 endif
 :UPDATE CallSession;
 :Audit;
 :State ACW → available;
 :200;
 stop
 @enduml

8.3 Estado disposition
======================

.. uml::

 @startuml
 [*] --> pending : ACW start
 pending --> set : agente
 pending --> auto_no_disp : timeout
 set --> [*]
 auto_no_disp --> [*]
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Agente" as A
 participant "Endpoint" as E
 database "Repo" as R
 A -> E: POST disposition
 E -> R: UPDATE
 E -> E: emit DISPOSITION_SET
 E --> A: 200
 @enduml

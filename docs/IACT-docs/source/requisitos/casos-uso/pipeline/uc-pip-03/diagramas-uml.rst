.. _uc-pip-03-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nview_data_availability" as USR
 rectangle "MOD_Pipeline" {
   usecase "UC_PIP_03\nDisponibilidad" as UC03
 }
 USR --> UC03
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET /data/availability/;
 :JWT + RBAC;
 :Cache lookup;
 :Query DatasetMetadata;
 :Calcular lag + status;
 :Cache write;
 :200;
 stop
 @enduml

8.3 Estado por dataset
======================

.. uml::

 @startuml
 [*] --> fresh : recien refresh
 fresh --> stale : > threshold
 stale --> critical_stale : > critical
 critical_stale --> stale : refresh
 stale --> fresh : refresh
 @enduml

8.4 Componentes
===============

.. uml::

 @startuml
 component "DatasetMetadata" as DM
 component "Service" as S
 component "Status calc" as SC
 DM --> S
 SC --> S
 @enduml

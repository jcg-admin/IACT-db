.. _uc-pip-01-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nview_etl_supervision" as USR
 rectangle "MOD_Pipeline" {
   usecase "UC_PIP_01\nSupervisar ETL" as UC01
   usecase "Drill errores" as DR
 }
 USR --> UC01
 UC01 ..> DR : <<extend>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET /etl/supervision/;
 :JWT + RBAC;
 :Cache lookup;
 :Query PipelineRun;
 :Build summary;
 :Cache write;
 :200;
 stop
 @enduml

8.3 Estados pipeline
====================

.. uml::

 @startuml
 [*] --> idle
 idle --> running : trigger
 running --> success : ok
 running --> failed : error
 success --> idle
 failed --> idle : reset
 @enduml

8.4 Clases
==========

.. uml::

 @startuml
 class ETLSupervisionService
 class PipelineRunRepo
 ETLSupervisionService --> PipelineRunRepo
 @enduml

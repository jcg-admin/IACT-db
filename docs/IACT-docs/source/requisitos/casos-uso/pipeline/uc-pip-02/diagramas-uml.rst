.. _uc-pip-02-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nview_etl_errors" as USR
 rectangle "MOD_Pipeline" {
   usecase "UC_PIP_02\nErrores ETL" as UC02
   usecase "Drill error" as DR
   usecase "Group by type" as G
 }
 USR --> UC02
 UC02 ..> DR : <<extend>>
 UC02 ..> G : <<extend>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET con filtros + period;
 :JWT + RBAC;
 :Query ETLError;
 :Sanitize stack/payload;
 :200;
 stop
 @enduml

8.3 Clases
==========

.. uml::

 @startuml
 class ETLErrorService
 class ETLErrorRepo
 class PIIScanner
 ETLErrorService --> ETLErrorRepo
 ETLErrorService --> PIIScanner
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "User" as U
 participant "Endpoint" as E
 database "ETLErrorRepo" as R
 U -> E: GET /etl/errors/
 E -> E: JWT + RBAC
 E -> R: query
 R --> E: rows
 E -> E: sanitize
 E --> U: 200
 @enduml

.. _uc-aud-02-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nsearch_audit" as USR
 rectangle "MOD_Audit" {
   usecase "UC_AUD_02\nBuscar" as UC02
   usecase "UC_PERM_09\nMeta-audit" as M
 }
 USR --> UC02
 UC02 ..> M : <<include>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :POST search;
 :JWT + RBAC;
 :Validar query + range ≤ 90;
 :Throttle check;
 :FTS search;
 :Sanitize results;
 :Meta-audit;
 :200;
 stop
 @enduml

8.3 Componente FTS
==================

.. uml::

 @startuml
 component "AuditEvent BD" as DB
 component "Sync trigger" as SY
 component "FTS Index" as IDX
 component "Search service" as SS
 DB --> SY
 SY --> IDX
 SS --> IDX
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "User" as U
 participant "Endpoint" as E
 participant "FTS" as F
 participant "AuditSvc" as A
 U -> E: POST search
 E -> E: JWT + RBAC + validar
 E -> F: search query
 F --> E: hits
 E -> A: emit AUDIT_SEARCH_QUERIED
 E --> U: 200
 @enduml

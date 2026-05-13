.. _uc-aud-01-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nview_general_audit" as USR
 rectangle "MOD_Audit" {
   usecase "UC_AUD_01\nConsultar Auditoria" as UC01
   usecase "UC_PERM_09\nMeta-audit" as M
 }
 USR --> UC01
 UC01 ..> M : <<include>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET /audit/;
 :JWT + RBAC;
 :Validar;
 :Query AuditRepo + cursor;
 :Sanitize;
 :Build cursor;
 :Meta-audit GENERAL_AUDIT_QUERIED;
 if (Meta-audit ok?) then (no)
   :503; stop
 endif
 :200;
 stop
 @enduml

8.3 Clases
==========

.. uml::

 @startuml
 class GeneralAuditService
 class AuditRepo
 class CursorEncoder
 class AuditService
 GeneralAuditService --> AuditRepo
 GeneralAuditService --> CursorEncoder
 GeneralAuditService --> AuditService
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Auditor" as A
 participant "Endpoint" as E
 database "AuditRepo" as R
 participant "AuditSvc" as AU
 A -> E: GET /audit/
 E -> E: JWT + RBAC
 E -> R: query
 R --> E: rows
 E -> AU: emit GENERAL_AUDIT_QUERIED
 E --> A: 200
 @enduml

.. _uc-pip-04-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nrequest_pipeline_retry" as USR
 actor "PipelineExecutor" as PE
 rectangle "MOD_Pipeline" {
   usecase "UC_PIP_04\nReintento" as UC04
 }
 USR --> UC04
 UC04 --> PE
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :POST retry con reason;
 :JWT + RBAC;
 :Validar;
 if (Already running?) then (si)
   :409; stop
 endif
 if (Reason missing?) then (si)
   :400; stop
 endif
 :Encolar nuevo run;
 :Audit PIPELINE_RETRY_REQUESTED;
 :202 + run_id;
 stop
 @enduml

8.3 Estado del retry
====================

.. uml::

 @startuml
 [*] --> queued
 queued --> running
 running --> success
 running --> failed
 success --> [*]
 failed --> queued : nuevo retry
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Operador" as O
 participant "Endpoint" as E
 participant "Executor" as EX
 participant "AuditSvc" as A
 O -> E: POST retry + reason
 E -> E: JWT + RBAC + validar
 E -> EX: enqueue
 EX --> E: new_run_id
 E -> A: emit PIPELINE_RETRY_REQUESTED
 E --> O: 202
 @enduml

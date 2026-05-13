.. _uc-rpt-04-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_RPT_04 — export

 @startuml
 left to right direction
 actor "User con funcion\nexport_reports" as USR
 actor "ExportWorker" as W
 actor "MailboxService" as MB

 rectangle "MOD_Reports" {
   usecase "UC_RPT_04\nExport" as UC04
   usecase "Encolar Job" as Q
   usecase "Audit eventos" as A
   usecase "Notify mailbox" as N
 }

 USR --> UC04
 UC04 ..> Q : <<include>>
 UC04 ..> A : <<include>>
 W ..> A : <<include>>
 W ..> N : <<include>>
 N --> MB

 note bottom
   Async via worker. URL firmado
   TTL 24h. CNST-002 mailbox.
 end note

 @enduml

8.2 Diagrama de actividad
=========================

.. uml::
 :caption: UC_RPT_04 — flujo

 @startuml
 start
 :POST /api/reports/export/;
 if (JWT?) then (no)
   :401; stop
 endif
 if (export_reports?) then (no)
   :403 + audit; stop
 endif
 :Validar payload + estimacion;
 if (Excede limites?) then (si)
   :400; stop
 endif
 if (User > 5 jobs?) then (si)
   :429; stop
 endif
 :Crear ExportJob;
 :Encolar en worker;
 :Audit REPORT_EXPORT_QUEUED;
 :202 con job_id;
 :Worker toma job;
 :Recheck permiso del User;
 if (Permiso revocado?) then (si)
   :failed PERMISSION_REVOKED;
   stop
 endif
 :Stream query Analytics;
 :Sanitizar + escribir archivo;
 if (> 200 MB?) then (si)
   :failed TOO_LARGE; stop
 endif
 :Subir a storage + URL firmado;
 :Audit REPORT_EXPORT_COMPLETED;
 :Notify mailbox del User;

 stop
 @enduml

8.3 Diagrama de estado
======================

.. uml::
 :caption: ExportJob

 @startuml
 [*] --> queued
 queued --> running : worker pickup
 queued --> cancelled : DELETE
 running --> done : ok
 running --> failed : error
 running --> cancelled : cancellation_requested
 done --> expired : 24h
 failed --> [*]
 cancelled --> [*]
 expired --> [*]
 @enduml

8.4 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_RPT_04 — sync + async

 @startuml
 actor "User" as U
 participant "Endpoint" as E
 participant "JobRepo" as JR
 queue "Worker" as W
 database "Analytics" as A
 participant "Storage" as ST
 participant "Mailbox" as MB
 participant "AuditSvc" as AU

 U -> E: POST /export
 E -> E: JWT + RBAC + validar
 E -> JR: create(job)
 JR --> E: job_id
 E -> AU: emit QUEUED
 E -> W: enqueue(job_id)
 E --> U: 202 + job_id

 ... background ...

 W -> JR: load(job_id)
 W -> W: re-check permiso
 W -> A: stream query
 A --> W: rows
 W -> ST: upload file
 ST --> W: url
 W -> JR: update(done, url, ...)
 W -> AU: emit COMPLETED
 W -> MB: notify(user, url)
 @enduml

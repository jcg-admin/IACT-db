.. _uc-perm-10-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_PERM_10 — consultar audit

 @startuml
 left to right direction

 actor "User con funcion\nview_audit_log" as AUD
 actor "ExportWorker" as EW

 rectangle "MOD_Permissions / Audit" {
   usecase "UC_PERM_10\nList" as L
   usecase "Detalle" as D
   usecase "Aggregate" as A
   usecase "Export" as E
   usecase "UC_PERM_09\nmeta-audit" as M
 }

 AUD --> L
 AUD --> D
 AUD --> A
 AUD --> E
 L ..> M : <<include>>
 D ..> M : <<include>>
 A ..> M : <<include>>
 E ..> M : <<include>>
 E --> EW
 EW ..> M : <<include>>

 note bottom
   P-44: cada consulta del log
   se audita (audit del audit).
 end note

 @enduml

8.2 Diagrama de actividad (list)
================================

.. uml::
 :caption: UC_PERM_10 — list

 @startuml

 start
 :GET con filtros + cursor;
 if (JWT?) then (no)
   :401; stop
 endif
 if (view_audit_log?) then (no)
   :403 + UNAUTHORIZED audit;
   stop
 endif
 if (Filtros validos?) then (no)
   :400; stop
 endif
 :Query AuditRepo (read replica);
 :Sanitizar (truncar payload);
 :Construir cursor;
 :Estimar total;
 :Emit AUDIT_LOG_QUERIED (UC_PERM_09);
 if (Meta-audit ok?) then (no)
   :503; stop
 endif
 :200 OK;
 stop

 @enduml

8.3 Diagrama de clases
======================

.. uml::
 :caption: Estructura

 @startuml

 class AuditQueryService {
   list(filters, cursor, page_size)
   get(id)
   aggregate(filters, group_by)
   export(filters, format)
 }

 class AuditRepo {
   query(filters, cursor, limit)
   get_by_id(id)
   aggregate(filters, group_by)
 }

 class CursorEncoder {
   encode(last)
   decode(cursor)
 }

 class Sanitizer {
   truncate(payload)
 }

 class ExportWorker {
   enqueue(job)
   process(job)
 }

 AuditQueryService --> AuditRepo
 AuditQueryService --> CursorEncoder
 AuditQueryService --> Sanitizer
 AuditQueryService --> ExportWorker

 @enduml

8.4 Diagrama de secuencia (export)
==================================

.. uml::
 :caption: UC_PERM_10 — export async

 @startuml

 actor "Auditor" as A
 participant "ExportEndpoint" as EE
 participant "QueryService" as QS
 participant "ExportWorker" as EW
 participant "MailboxService" as MB
 database "AuditRepo" as DB
 participant "Storage" as ST

 A -> EE: POST /export con filtros
 EE -> EE: JWT + RBAC + validar
 EE -> QS: enqueue(filters, format)
 QS -> EW: schedule(job)
 EW --> QS: job_id
 QS -> QS: emit AUDIT_LOG_EXPORT_QUEUED
 QS --> EE: 202 + job_id
 EE --> A: 202

 ... background ...
 EW -> DB: query stream
 DB --> EW: rows
 EW -> ST: write file
 EW -> EW: emit AUDIT_LOG_EXPORT_COMPLETED
 EW -> MB: notify(actor, file_url)

 ... auditor checks ...
 A -> EE: GET job_id
 EE -> A: status=done + file_url

 @enduml

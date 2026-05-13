.. _uc-rpt-07-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_RPT_07 — programar

 @startuml
 left to right direction
 actor "User con funcion\nschedule_reports" as USR
 actor "Scheduler" as SC

 rectangle "MOD_Reports" {
   usecase "UC_RPT_07\nProgramar" as UC07
   usecase "Crear/Update" as CRUD
   usecase "Auto execute" as AE
   usecase "UC_RPT_04\nExport" as EXP
 }

 USR --> UC07
 UC07 ..> CRUD : <<include>>
 SC ..> AE : <<include>>
 AE ..> EXP : <<include>>
 @enduml

8.2 Diagrama de actividad (creacion)
====================================

.. uml::
 :caption: UC_RPT_07 — crear

 @startuml
 start
 :POST con schedule;
 if (JWT?) then (no)
   :401; stop
 endif
 if (RBAC?) then (no)
   :403; stop
 endif
 :Validar cron / frecuencia / period;
 if (User > 10?) then (si)
   :429; stop
 endif
 :Calcular next_run_at;
 :INSERT ScheduledReport;
 :Audit CREATED;
 :201;
 stop
 @enduml

8.3 Diagrama de actividad (ejecucion)
=====================================

.. uml::
 :caption: UC_RPT_07 — auto run

 @startuml
 start
 :Scheduler tick;
 :Query schedules con next_run_at <= now;
 while (schedules pendientes?)
   :Re-check permiso del User;
   if (Permiso ok?) then (no)
     :Audit PERMISSION_LOST;
     :Skip + reschedule next;
   else (si)
     :Enqueue ExportJob;
     :Update last_run_at + next_run_at;
     :Audit EXECUTED;
   endif
 endwhile
 stop
 @enduml

8.4 Diagrama de estado
======================

.. uml::
 :caption: ScheduledReport

 @startuml
 [*] --> active : crear
 active --> paused : DELETE pause
 paused --> active : resume
 active --> auto_paused : 3 fallos
 auto_paused --> active : User fix
 active --> [*] : DELETE
 paused --> [*] : DELETE
 auto_paused --> [*] : DELETE
 @enduml

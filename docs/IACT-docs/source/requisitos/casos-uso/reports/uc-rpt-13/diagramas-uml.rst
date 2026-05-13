.. _uc-rpt-13-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nview_queue_reports" as USR
 rectangle "MOD_Reports" {
   usecase "UC_RPT_13\nReporte Colas" as UC13
   usecase "Detalle cola" as DET
 }
 USR --> UC13
 UC13 ..> DET : <<extend>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET con period + filtros;
 :JWT + RBAC + segmento;
 :Cache lookup;
 :Query QueueDailyStat;
 :Calcular ASA, SL, abandono;
 :Cache write;
 :200;
 stop
 @enduml

8.3 Clases
==========

.. uml::

 @startuml
 class QueueReportService {
   list, detail
 }
 class QueueDailyStatRepo {
   aggregate, stream
 }
 class KPICalculator
 QueueReportService --> QueueDailyStatRepo
 QueueReportService --> KPICalculator
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "User" as U
 participant "Endpoint" as E
 database "Analytics" as A
 U -> E: GET /queues/
 E -> E: JWT + RBAC
 E -> A: aggregate
 A --> E: rows
 E --> U: 200 + items
 @enduml

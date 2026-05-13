.. _uc-rpt-14-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nview_campaign_reports" as USR
 rectangle "MOD_Reports" {
   usecase "UC_RPT_14\nReporte Campanas" as UC14
   usecase "Detalle" as DET
 }
 USR --> UC14
 UC14 ..> DET : <<extend>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET con period + filtros;
 :JWT + RBAC + segmento;
 :Cache lookup;
 :Query CampaignDailyStat;
 :Calcular conversion rate, calls/hour;
 :Cache write;
 :200;
 stop
 @enduml

8.3 Clases
==========

.. uml::

 @startuml
 class CampaignReportService
 class CampaignDailyStatRepo
 class KPICalculator
 CampaignReportService --> CampaignDailyStatRepo
 CampaignReportService --> KPICalculator
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "User" as U
 participant "Endpoint" as E
 database "Analytics" as A
 U -> E: GET /campaigns/
 E -> E: JWT + RBAC
 E -> A: aggregate
 A --> E: rows
 E --> U: 200 + items
 @enduml

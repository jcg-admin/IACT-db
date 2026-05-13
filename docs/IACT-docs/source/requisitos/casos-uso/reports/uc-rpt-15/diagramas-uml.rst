.. _uc-rpt-15-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nview_transfer_reports" as USR
 rectangle "MOD_Reports" {
   usecase "UC_RPT_15\nReporte Transfers" as UC15
   usecase "Heatmap" as HM
   usecase "Drill agente/reason" as DR
 }
 USR --> UC15
 UC15 ..> HM : <<include>>
 UC15 ..> DR : <<extend>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET con period;
 :JWT + RBAC + segmento;
 :Cache lookup;
 :Query TransferEvent;
 :Computar totals + breakdowns;
 :Build heatmap;
 :Cache write;
 :200;
 stop
 @enduml

8.3 Clases
==========

.. uml::

 @startuml
 class TransferReportService
 class TransferEventRepo {
   aggregate, build_heatmap
 }
 TransferReportService --> TransferEventRepo
 @enduml

8.4 Heatmap (componente)
========================

.. uml::

 @startuml
 component "From Queues" as F
 component "Heatmap matrix" as H
 component "To Queues" as T
 F --> H
 T --> H
 note right of H
   Cada celda: count(from→to)
   Colores: bajo / medio / alto
 end note
 @enduml

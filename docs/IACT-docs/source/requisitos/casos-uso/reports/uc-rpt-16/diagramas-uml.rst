.. _uc-rpt-16-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nview_ivr_reports" as USR
 rectangle "MOD_Reports" {
   usecase "UC_RPT_16\nReporte IVR" as UC16
   usecase "Path mining" as PM
   usecase "Heatmap nodos" as HM
 }
 USR --> UC16
 UC16 ..> PM : <<include>>
 UC16 ..> HM : <<include>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET con period;
 :JWT + RBAC + segmento;
 :Cache lookup;
 :Query IVRSessionEvent;
 :Computar totals + distribucion;
 :Path mining (top N);
 :Heatmap drop-off;
 :Cache write;
 :200;
 stop
 @enduml

8.3 Path tree
=============

.. uml::

 @startuml
 (Entry) -> (Opcion 1) : 60%
 (Entry) -> (Opcion 2) : 25%
 (Entry) -> (Hangup) : 15%
 (Opcion 1) -> (Opcion 1.1) : 80%
 (Opcion 1) -> (Hangup) : 20%
 @enduml

8.4 Componente path mining
==========================

.. uml::

 @startuml
 component "Session events" as SE
 component "Path extractor" as PE
 component "Top-N counter" as TC
 component "Top paths report" as TP
 SE --> PE
 PE --> TC
 TC --> TP
 @enduml

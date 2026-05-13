.. _uc-alr-04-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nview_alert_history" as USR
 rectangle "MOD_Alerts" {
   usecase "UC_ALR_04\nHistorial" as UC04
 }
 USR --> UC04
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET con filtros + period;
 :JWT + RBAC + segmento;
 :Validar range ≤ 1 ano;
 :Cache lookup;
 :Query Alert resolved/closed;
 :Calcular time-to-ack/resolve;
 :Build summary;
 :Cache write;
 :200;
 stop
 @enduml

8.3 Clases
==========

.. uml::

 @startuml
 class AlertHistoryService
 class AlertRepo {
   query_history(filters, period)
 }
 class TimingCalculator {
   compute_ttak, compute_ttar
 }
 AlertHistoryService --> AlertRepo
 AlertHistoryService --> TimingCalculator
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "User" as U
 participant "Endpoint" as E
 database "AlertRepo" as A
 U -> E: GET /history
 E -> E: JWT + RBAC
 E -> A: query
 A --> E: rows
 E --> U: 200 + summary
 @enduml

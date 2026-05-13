.. _uc-rpt-17-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nview_unique_clients_reports" as USR
 rectangle "MOD_Reports" {
   usecase "UC_RPT_17\nClientes Unicos" as UC17
   usecase "Distinct count" as DC
   usecase "Recurrence" as R
   usecase "New vs returning" as NR
 }
 USR --> UC17
 UC17 ..> DC : <<include>>
 UC17 ..> R : <<include>>
 UC17 ..> NR : <<include>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET con period;
 :JWT + RBAC + segmento;
 :Cache lookup;
 if (Volumen > umbral?) then (si)
   :HLL estimate;
 else (no)
   :COUNT(DISTINCT) exacto;
 endif
 :Recurrence distribution;
 :New vs returning (prior period);
 :Top N anonimizado;
 :Cache write;
 :200;
 stop
 @enduml

8.3 Hash flow
=============

.. uml::

 @startuml
 component "ETL" as E
 component "client_id raw" as CR
 component "tenant_salt" as TS
 component "client_hash" as CH
 component "Analytics" as A
 CR --> E
 TS --> E
 E --> CH : sha256
 CH --> A
 note right of E
   client_id raw NUNCA llega a
   Analytics. Solo el hash.
 end note
 @enduml

8.4 Distribucion
================

.. uml::

 @startuml
 [*] --> singletons : 1 call
 [*] --> doublets : 2 calls
 [*] --> recurrent : 3+ calls
 singletons --> [*]
 doublets --> [*]
 recurrent --> [*]
 @enduml

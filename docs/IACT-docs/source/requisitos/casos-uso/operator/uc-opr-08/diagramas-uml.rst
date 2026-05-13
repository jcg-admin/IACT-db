.. _uc-opr-08-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Agente" as A
 rectangle "MOD_Operator" {
   usecase "UC_OPR_08\nMy Dashboard" as UC
 }
 A --> UC
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET /me/dashboard;
 :JWT;
 :Cache lookup;
 :Query own stats;
 :Calcular KPIs;
 :Ranking opt-in;
 :200;
 stop
 @enduml

8.3 Componentes
===============

.. uml::

 @startuml
 component "Endpoint" as E
 component "Cache" as C
 component "AgentDailyStatRepo" as R
 component "RankingService" as RS
 E --> C
 E --> R
 E --> RS
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Agente" as A
 participant "Endpoint" as E
 database "Stats" as S
 A -> E: GET dashboard
 E -> S: query own
 S --> E: rows
 E --> A: 200 + KPIs
 @enduml

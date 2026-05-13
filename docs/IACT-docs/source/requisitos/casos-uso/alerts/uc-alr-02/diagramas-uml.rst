.. _uc-alr-02-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nview_active_alerts" as USR
 rectangle "MOD_Alerts" {
   usecase "UC_ALR_02\nAlertas Activas" as UC02
   usecase "UC_ALR_03\nAck inline" as UC03
   usecase "Auto-refresh" as AR
 }
 USR --> UC02
 UC02 ..> AR : <<extend>>
 UC02 ..> UC03 : <<extend>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :GET /api/alerts/active/;
 :JWT + RBAC + segmento;
 :Query AlertRepo state ∈ {firing, ack};
 :Ordenar severity + fired_at;
 :200 OK;
 :Frontend renderiza + auto-refresh 10s;
 stop
 @enduml

8.3 Estado de la alerta
=======================

.. uml::

 @startuml
 [*] --> firing : evaluator dispara
 firing --> acknowledged : UC_ALR_03
 firing --> resolved : metric vuelve normal
 acknowledged --> resolved : metric normal
 acknowledged --> closed : forced close
 resolved --> closed : auto cleanup
 closed --> [*]
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Supervisor" as S
 participant "Frontend" as FE
 participant "Endpoint" as E
 database "AlertRepo" as A

 S -> FE: abrir vista
 loop cada 10s
   FE -> E: GET /alerts/active
   E -> E: JWT + RBAC
   E -> A: query active
   A --> E: rows
   E --> FE: 200
   FE -> S: actualizar UI
 end
 @enduml

.. _uc-alr-03-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nacknowledge_alerts" as USR
 rectangle "MOD_Alerts" {
   usecase "UC_ALR_03\nReconocer" as UC03
   usecase "Bulk ack" as BA
 }
 USR --> UC03
 USR --> BA
 BA ..> UC03 : <<include>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :POST /alerts/{id}/ack/;
 :JWT + RBAC;
 :Cargar Alert;
 if (Cross-segmento?) then (si)
   :403; stop
 endif
 if (state != firing?) then (si)
   :409; stop
 endif
 :BEGIN tx;
 :UPDATE Alert state, ack_*;
 :Audit ALERT_ACKNOWLEDGED;
 :COMMIT;
 :Suprimir notify;
 :200;
 stop
 @enduml

8.3 Estado (transicion)
=======================

.. uml::

 @startuml
 [*] --> firing
 firing --> acknowledged : ack
 acknowledged --> resolved : metric normal
 firing --> resolved : metric normal
 resolved --> closed
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Supervisor" as S
 participant "Endpoint" as E
 database "AlertRepo" as A
 participant "AuditSvc" as AU

 S -> E: POST ack
 E -> E: JWT + RBAC + scope
 E -> A: BEGIN
 E -> A: UPDATE Alert
 E -> AU: emit ALERT_ACKNOWLEDGED
 E -> A: COMMIT
 E --> S: 200
 @enduml

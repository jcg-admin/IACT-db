.. _uc-sup-01-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Supervisor con funcion\nmonitor_live_calls" as SUP
 actor "Agente" as A
 actor "Caller" as C
 rectangle "MOD_Supervision" {
   usecase "UC_SUP_01\nMonitor" as UC
 }
 SUP --> UC
 UC --> A
 UC --> C
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :POST monitor;
 :JWT + RBAC;
 :Validar segmento;
 if (Reason ok?) then (no)
   :400; stop
 endif
 :Telephony bridge listen;
 :Tono audible al agente;
 :Audit CALL_MONITORED;
 :200;
 stop
 @enduml

8.3 Modes
=========

.. uml::

 @startuml
 [*] --> silent
 silent --> whisper : switch
 whisper --> silent : switch
 silent --> stopped : stop
 whisper --> stopped : stop
 stopped --> [*]
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Supervisor" as S
 participant "Endpoint" as E
 participant "Telephony" as T
 actor "Agente" as A
 S -> E: POST monitor
 E -> T: bridge listen
 T -> A: tono "monitor on"
 E --> S: 200
 @enduml

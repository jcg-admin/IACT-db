.. _uc-cli-04-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Caller" as C
 actor "Agente" as A
 rectangle "MOD_Caller" {
   usecase "UC_CLI_04\nCallback" as UC
   usecase "UC_OPR_03\nDial" as D
 }
 C --> UC
 UC --> A
 A --> D
 D ..> UC : consume CallbackEntry
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :Ofrecer callback;
 if (Cliente acepta?) then (no)
   :Sigue cola;
   stop
 endif
 :Capturar numero;
 if (DNC?) then (si)
   :Mensaje rechazo;
   stop
 endif
 :Hash + INSERT CallbackEntry;
 :Audit;
 :Confirmar + hangup;
 stop
 @enduml

8.3 Estado
==========

.. uml::

 @startuml
 [*] --> pending
 pending --> in_progress : agente toma
 in_progress --> done : llamada exitosa
 in_progress --> expired : ventana cerro
 pending --> expired : sin tomar
 done --> [*]
 expired --> [*]
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Caller" as C
 participant "IVR" as I
 database "CallbackRepo" as R
 actor "Agente" as A
 I -> C: oferta callback
 C -> I: acepta + numero
 I -> R: INSERT pending
 I -> C: confirma + hangup

 ... despues ...
 A -> R: take callback
 A -> C: dial (UC_OPR_03)
 @enduml

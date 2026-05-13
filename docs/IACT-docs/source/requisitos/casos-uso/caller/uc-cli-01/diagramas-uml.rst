.. _uc-cli-01-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Cliente Caller" as C
 actor "Telephony" as T
 rectangle "MOD_Caller" {
   usecase "UC_CLI_01\nIniciar llamada" as UC
   usecase "UC_CLI_02\nNavegar IVR" as IVR
 }
 C --> UC
 UC --> T
 UC ..> IVR : <<include>>
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :Llamada al DID;
 :Telephony acepta;
 :Capturar caller_id;
 :Hash caller_id;
 :INSERT CallSession;
 :Reproducir greeting;
 :Audit CALL_STARTED;
 :Pasar a IVR;
 stop
 @enduml

8.3 Pipeline PII
================

.. uml::

 @startuml
 component "Caller phone" as P
 component "Telephony" as T
 component "PIIHasher" as H
 component "CallSession" as S
 P --> T
 T --> H
 H --> S
 note right of H
   Hash con tenant_salt.
   Phone NUNCA llega a S raw.
 end note
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Caller" as C
 participant "Telephony" as T
 participant "PIIHasher" as H
 participant "CallRepo" as R
 participant "AuditSvc" as A
 C -> T: dial DID
 T -> H: caller_id
 H --> T: hash
 T -> R: INSERT session
 T -> A: emit CALL_STARTED
 T -> C: greeting audio
 @enduml

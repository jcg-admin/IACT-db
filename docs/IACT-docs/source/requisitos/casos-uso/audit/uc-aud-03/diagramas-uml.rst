.. _uc-aud-03-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User con funcion\nexport_audit" as USR
 actor "ExportWorker" as EW
 actor "Mailbox" as MB
 rectangle "MOD_Audit" {
   usecase "UC_AUD_03\nExport" as UC03
 }
 USR --> UC03
 UC03 --> EW
 EW --> MB
 @enduml

8.2 Actividad — identica a UC_RPT_04.

8.3 Estado del job — identico a UC_RPT_04.

8.4 Secuencia — identica a UC_RPT_04.

Para los diagramas detallados ver
:doc:`/requisitos/casos-uso/reports/uc-rpt-04/diagramas-uml`.

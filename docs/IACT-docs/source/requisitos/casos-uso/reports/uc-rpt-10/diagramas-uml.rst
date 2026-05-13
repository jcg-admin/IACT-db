.. _uc-rpt-10-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "User autenticado" as USR
 rectangle "MOD_Reports" {
   usecase "UC_RPT_10\nGuardar Vista" as UC10
   usecase "Aplicar vista" as APP
   usecase "Clone" as CL
 }
 USR --> UC10
 USR --> APP
 USR --> CL
 @enduml

8.2 Actividad (crear)
=====================

.. uml::

 @startuml
 start
 :POST /api/me/views/;
 if (JWT?) then (no)
   :401; stop
 endif
 :Validar nombre + columns + segmento;
 if (Cross-segmento?) then (si)
   :400; stop
 endif
 if (User > 30?) then (si)
   :429; stop
 endif
 :INSERT;
 :Audit VIEW_CREATED;
 :201;
 stop
 @enduml

8.3 Clases
==========

.. uml::

 @startuml
 class SavedView {
   id, name, report_type,
   filters, columns, chart_config
 }
 class ColumnCatalog {
   list_for(report_type)
   exists(col_id, report_type)
 }
 SavedView -- ColumnCatalog
 @enduml

8.4 Estado
==========

.. uml::

 @startuml
 [*] --> active : crear
 active --> degraded : columna deprecada
 degraded --> active : columna restaurada
 active --> [*] : delete
 @enduml

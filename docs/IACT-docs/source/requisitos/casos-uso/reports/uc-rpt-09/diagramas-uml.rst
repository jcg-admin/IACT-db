.. _uc-rpt-09-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_RPT_09 — filtros

 @startuml
 left to right direction
 actor "User autenticado" as USR
 rectangle "MOD_Reports" {
   usecase "UC_RPT_09\nGestionar filtros" as UC09
   usecase "Aplicar filtro" as APP
 }
 USR --> UC09
 USR --> APP
 @enduml

8.2 Diagrama de actividad
=========================

.. uml::
 :caption: UC_RPT_09 — crear

 @startuml
 start
 :POST /api/me/filters/;
 if (JWT?) then (no)
   :401; stop
 endif
 :Validar nombre + filtros + segmentos;
 if (Cross-segmento?) then (si)
   :400 SEGMENT_VIOLATION; stop
 endif
 if (User > 50?) then (si)
   :429; stop
 endif
 :INSERT;
 :201;
 stop
 @enduml

8.3 Diagrama de clases
======================

.. uml::
 :caption: Estructura

 @startuml
 class SavedFilter {
   id, name, filters,
   period_relative, applies_to,
   is_default, is_invalid
 }
 class FilterValidator {
   validate(filter, user_segments)
 }
 SavedFilter -- FilterValidator
 @enduml

8.4 Diagrama de estado
======================

.. uml::
 :caption: SavedFilter

 @startuml
 [*] --> active : crear
 active --> invalid : segmentos cambian
 invalid --> active : segmentos restored
 active --> [*] : delete
 invalid --> [*] : delete
 @enduml

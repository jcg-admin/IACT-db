.. _uc-perm-01-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

.. note::

 Diagramas backend identicos a UC_ACC_04
 Parte 8. Esta parte muestra el flujo desde
 la vista UI PERM y la coexistencia ACC↔PERM.

8.1 Diagrama de coexistencia ACC↔PERM
=====================================

.. uml::
 :caption: UC_PERM_01 vs UC_ACC_04 — vistas
           del mismo flujo

 @startuml
 left to right direction

 actor "Admin operacional" as OPS
 actor "Admin de seguridad\n/ Compliance" as SEC

 rectangle "UI MOD_Access" {
   usecase "UC_ACC_04\nAsignar AGR\n(desde User)" as ACC04
 }

 rectangle "UI MOD_Permissions" {
   usecase "UC_PERM_01\nAsignar Grupo\n(desde catalogo AGR)" as PERM01
 }

 cloud "Backend compartido" {
   usecase "POST /api/users/\n{id}/access-groups/" as BE
   note bottom: Funcion: assign_function_groups
 }

 OPS --> ACC04
 SEC --> PERM01
 ACC04 --> BE : delega
 PERM01 --> BE : delega

 note right of BE
   Implementacion comun (UC_ACC_04 backing).
   AuditEvent AGR_ASSIGNED no distingue
   origen UI.
 end note

 @enduml

8.2 Diagrama de secuencia (vista PERM)
======================================

.. uml::
 :caption: UC_PERM_01 — secuencia desde
           catalogo

 @startuml

 actor Invoker as I
 participant "UI Catalogo PERM" as UI
 participant "API ACG" as API
 participant "Backend\n(UC_ACC_04)" as BE
 database "Repo" as DB

 I -> UI: Abre catalogo de AGRs
 UI -> API: GET /api/access-groups/
 API --> UI: lista AGRs + counts

 I -> UI: Selecciona AGR + User
 UI -> API: GET preview-assign?
 API -> DB: dry-run validations
 API --> UI: preview con composicion + impact

 UI -> UI: Modal con composicion
 I -> UI: Confirma

 UI -> API: POST /api/users/{id}/access-groups/
 API -> BE: delega flujo UC_ACC_04
 BE -> DB: INSERT Assignment + audit + cache
 BE --> API: 201 Created
 API --> UI: result
 UI -> UI: refresh catalogo (counts +1)
 UI --> I: Toast confirmacion

 @enduml

8.3 Diagrama de actividad
=========================

.. uml::
 :caption: UC_PERM_01 — actividad

 @startuml

 start

 :Invoker abre catalogo de AGRs;
 :Selecciona AGR;
 :Selecciona User destino;

 :GET preview-assign;
 :Modal con composicion + impact;

 if (Confirma?) then (no)
   :Cancela; stop
 else (si)
 endif

 :POST /api/users/{id}/access-groups/;

 note right
   Flujo backend identico
   a UC_ACC_04
 end note

 if (Backend OK?) then (no)
   :Mostrar error segun status; stop
 else (si)
 endif

 :Refrescar catalogo
  (counts AGR +1);
 :Toast confirmacion;

 stop

 @enduml

8.4 Diagrama de clases — vistas compartidas
===========================================

.. uml::
 :caption: ACC y PERM vistas — backing comun

 @startuml

 class "View_ACC" as VA
 class "View_PERM" as VP
 class "AccessService" as AS {
   +assign_access_group(...)
 }
 class Assignment
 class AccessGroup
 class AuditEvent

 VA --> AS : invoca
 VP --> AS : invoca
 AS --> Assignment : crea
 AS --> AuditEvent : emite
 Assignment --> AccessGroup : referencia

 note right of AS
   UC_ACC_04 backing
   compartido por ambas vistas
 end note

 @enduml

.. _uc-usr-02-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_USR_02 — actores y casos asociados

 @startuml

 left to right direction

 actor "User\n(AGR-006 / AGR-008)" as INVOKER
 actor "User consultado" as TARGET <<pasivo>>
 actor "Auditor" as AUD <<beneficiario>>

 rectangle "MOD_Users" {
   usecase "UC_USR_02\nConsultar Usuarios" as UC02
   usecase "Listar (paginado)" as LST
   usecase "Ver detalle" as DET
   usecase "Audit selectivo\n(P-16)" as AUDS
 }

 INVOKER --> UC02
 UC02 ..> LST : <<extend>>
 UC02 ..> DET : <<extend>>
 LST ..> AUDS : <<extend (filter user_id)>>
 DET ..> AUDS : <<include>>
 AUDS --> AUD

 note bottom of LST
   list_users (RBAC)
 end note
 note bottom of DET
   view_users (RBAC distinto)
 end note

 @enduml

8.2 Diagrama de secuencia (listado)
===================================

.. uml::
 :caption: UC_USR_02 sub-flujo 3.A

 @startuml

 actor Invoker as I
 participant "Frontend" as FE
 participant "ListUsersView" as LV
 participant "UserRepository" as REP
 participant "AuditLog" as AL
 database "Repo Users" as DB

 I -> FE: Navega a "Usuarios" + filtros
 FE -> LV: GET /api/users/?...

 LV -> LV: Validar JWT (CNST-009)
 LV -> LV: Verificar list_users (AGR)
 alt Sin permiso
   LV --> FE: 403 FORBIDDEN
   LV -> AL: emit UNAUTHORIZED_ACCESS_ATTEMPT
 else Con permiso
   LV -> LV: Construir query (whitelist filters)
   LV -> REP: list(filters, page, page_size)
   REP -> DB: SELECT ... LIMIT ... OFFSET ...
   DB --> REP: rows
   REP --> LV: results + count
   LV -> LV: Restringir campos PII (CNST-026)
   opt filter user_id presente
     LV -> AL: emit USERS_VIEWED_FOR_USER\n  {target_user_id}
   end
   LV --> FE: 200 OK con lista paginada
   FE --> I: Tabla renderizada
 end

 @enduml

8.3 Diagrama de secuencia (detalle)
===================================

.. uml::
 :caption: UC_USR_02 sub-flujo 3.B

 @startuml

 actor Invoker as I
 participant "Frontend" as FE
 participant "UserDetailView" as DV
 participant "UserRepository" as UREP
 participant "AssignmentRepository" as AREP
 participant "AuditLog" as AL
 database "Repo" as DB

 I -> FE: Click en User X
 FE -> DV: GET /api/users/{X}/

 DV -> DV: Validar JWT
 DV -> DV: Verificar view_users
 alt Sin permiso
   DV --> FE: 403 FORBIDDEN
   DV -> AL: UNAUTHORIZED_ACCESS_ATTEMPT
 else Con permiso
   DV -> UREP: get(X)
   alt User no existe
     DV --> FE: 404
   else
     UREP --> DV: user
     DV -> AREP: list_active(user)
     AREP --> DV: assignments
     DV -> AL: emit USER_DETAIL_VIEWED\n  {target_user_id: X,\n   target_state: user.state,\n   self_view: invoker == user}
     DV --> FE: 200 OK con detalle completo
     FE --> I: Vista detalle
   end
 end

 @enduml

8.4 Diagrama de actividad
=========================

.. uml::
 :caption: UC_USR_02 — actividad combinada

 @startuml

 start

 if (Sub-flujo?) then (listar)
   :GET /api/users/?filtros;
   if (JWT valido?) then (no)
     :401; stop
   else (si)
   endif
   if (list_users?) then (no)
     :403; :Audit UNAUTHORIZED;
     stop
   else (si)
   endif
   if (Filtros validos?) then (no)
     :400 BAD_FILTER; stop
   else (si)
   endif
   :Query con paginacion;
   :Restringir campos PII;
   if (filter user_id?) then (si)
     :Audit USERS_VIEWED_FOR_USER;
   else (no)
   endif
   :200 OK lista;
   stop
 else (detalle)
   :GET /api/users/{id}/;
   if (JWT valido?) then (no)
     :401; stop
   else (si)
   endif
   if (view_users?) then (no)
     :403; :Audit UNAUTHORIZED;
     stop
   else (si)
   endif
   if (User existe?) then (no)
     :404; stop
   else (si)
   endif
   :Cargar Assignments + AGRs;
   :Audit USER_DETAIL_VIEWED;
   :200 OK detalle;
   stop
 endif

 @enduml

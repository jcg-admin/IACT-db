.. _uc-acc-03-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_ACC_03 — actores y casos asociados

 @startuml

 left to right direction

 actor "User con funcion\nview_assignments" as INVOKER
 actor "Auditor" as AUD <<beneficiario>>
 actor "Sistema" as SYS <<sistema>>

 rectangle "MOD_Access" {
   usecase "UC_ACC_03\nConsultar Permisos" as UC03
   usecase "Cargar Assignments\ndirectos" as DIR
   usecase "Expandir AGRs\nen funciones" as AGR
   usecase "Cargar permisos\nexcepcionales" as EXC
   usecase "Consolidar\n+ metadata origen" as CONS
   usecase "Detectar SoD\ninformativo" as SOD
   usecase "Audit selectivo\nP-16" as AUDS
 }

 INVOKER --> UC03
 UC03 ..> DIR : <<include>>
 UC03 ..> AGR : <<include>>
 UC03 ..> EXC : <<include>>
 UC03 ..> CONS : <<include>>
 UC03 ..> SOD : <<include>>
 UC03 ..> AUDS : <<include>>
 SYS --> AUDS
 AUDS --> AUD

 note bottom of CONS
   3 fuentes: direct + AGR + excepcional
   deduplicacion + metadata por funcion
 end note
 note bottom of SOD
   INFORMATIVO no bloqueo
   (UC_ACC_01 valida write-time)
 end note

 @enduml

8.2 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_ACC_03 — flujo principal

 @startuml

 actor Invoker as I
 participant "Frontend" as FE
 participant "ViewPermsView" as VV
 participant "AccessService" as AS
 participant "AssignmentRepo" as AR
 participant "AGRRepo" as GR
 participant "ExcPermRepo" as XR
 participant "SoDValidator" as SV
 participant "AuditLog" as AL
 database "Repo" as DB

 I -> FE: Click "Ver permisos del User"
 FE -> VV: GET /api/users/{id}/\n  effective-permissions/

 VV -> VV: Validar JWT (CNST-009)
 VV -> VV: Verificar view_assignments\n  o self-view

 alt Sin permiso y no self
   VV --> FE: 403 FORBIDDEN
   VV -> AL: emit UNAUTHORIZED_ACCESS_ATTEMPT
 else Permitido
   VV -> AS: get_effective_permissions(\n  target, invoker)

   AS -> DB: SELECT User
   alt User no existe
     AS --> VV: UserNotFound
     VV --> FE: 404
   else User existe
     AS -> AR: list_active_assignments(target)
     AR --> AS: direct_assignments
     AS -> AR: list_agr_assignments(target)
     AR --> AS: agr_assignments
     AS -> GR: expand_functions_for_agrs(\n  agr_ids)
     GR --> AS: agr_functions
     AS -> XR: list_active_for_user(\n  target, NOW())
     XR --> AS: exceptional_perms
     AS -> AS: consolidar effective set\n  con metadata de origen
     AS -> AS: detectar expired_pending_purge
     AS -> SV: detect_violations(set, rules)
     SV --> AS: sod_violations (info)

     AS -> AL: emit EFFECTIVE_PERMISSIONS_VIEWED\n  {target_user_id, self_view, counts}

     AS --> VV: result
     VV --> FE: 200 OK con vista consolidada
     FE --> I: Tabla con badges de origen
   end
 end

 @enduml

8.3 Diagrama de actividad
=========================

.. uml::
 :caption: UC_ACC_03 — actividad

 @startuml

 start

 :GET /api/users/{id}/effective-permissions/;

 if (JWT valido?) then (no)
   :401; stop
 else (si)
 endif

 if (tiene view_assignments\no es self-view?) then (no)
   :403;
   :Audit UNAUTHORIZED_ACCESS_ATTEMPT;
   stop
 else (si)
 endif

 if (User existe?) then (no)
   :404; stop
 else (si)
 endif

 :Cargar Assignments directos ACTIVE;
 :Cargar AGR Assignments ACTIVE;
 :Expandir funciones de cada AGR;
 :Cargar ExceptionalPermissions ACTIVE;

 :Consolidar set efectivo
  + metadata origen por funcion;
 :Detectar Assignments con expires_at < NOW()
  (expired_pending_purge);
 :Evaluar SoDRules informativamente
  (sod_violations_detected);

 :Audit EFFECTIVE_PERMISSIONS_VIEWED (P-16);

 :200 OK con vista consolidada;
 :Frontend renderiza tabla con badges;

 stop

 @enduml

8.4 Diagrama de clases — fuentes de permisos
============================================

.. uml::
 :caption: 3 fuentes que UC_ACC_03 consolida

 @startuml

 class User {
   id: int
   username: string
   state: enum
 }

 class Assignment {
   id: int
   user_id: int
   target_type: enum {Function, AccessGroup}
   target_id: int
   state: enum {ACTIVE, REVOKED, EXPIRED}
   granted_at: timestamp
   expires_at: opt[timestamp]
 }

 class AccessGroup {
   id: int
   code: string
   display_name: string
   state: enum
 }

 class Function {
   id: int
   code: string
   display_name: string
   state: enum
 }

 class AccessGroupFunction {
   access_group_id: int
   function_id: int
 }

 class ExceptionalPermission {
   id: int
   user_id: int
   function_id: int
   state: enum
   expires_at: timestamp
   granted_reason: string
 }

 User "1" -- "*" Assignment
 Assignment "*" -- "1" AccessGroup : (target_type=AGR)
 Assignment "*" -- "1" Function : (target_type=Function)
 AccessGroup "1" -- "*" AccessGroupFunction
 AccessGroupFunction "*" -- "1" Function
 User "1" -- "*" ExceptionalPermission
 ExceptionalPermission "*" -- "1" Function

 note right of Assignment
   3 fuentes de Function efectiva:
   1) Assignment (target=Function): direct
   2) Assignment (target=AGR) -> AGR.functions: via_agr
   3) ExceptionalPermission: exceptional
 end note

 @enduml

.. _uc-acc-04-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_ACC_04 — actores y casos asociados

 @startuml
 left to right direction

 actor "User con funcion\nassign_function_groups" as INVOKER
 actor "User destino" as TARGET <<beneficiario>>
 actor "Auditor" as AUD <<beneficiario>>

 rectangle "MOD_Access" {
   usecase "UC_ACC_04\nAsignar AGR" as UC04
   usecase "Validar AGR\nexiste + ACTIVE" as VAGR
   usecase "Expandir funciones\ndel AGR" as EXP
   usecase "Validar SoD\n(set efectivo)" as SOD
   usecase "INSERT Assignment\n(target=AGR)" as INS
   usecase "Invalidar cache" as CACHE
   usecase "AuditEvent\nAGR_ASSIGNED" as EMI
 }

 INVOKER --> UC04
 UC04 ..> VAGR : <<include>>
 UC04 ..> EXP : <<include>>
 UC04 ..> SOD : <<include>>
 UC04 ..> INS : <<include>>
 UC04 ..> CACHE : <<include>>
 UC04 ..> EMI : <<include>>
 EMI --> AUD

 note bottom of SOD
   SoD se evalua sobre FUNCIONES,
   no sobre AGRs como entidad
 end note

 @enduml

8.2 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_ACC_04 — flujo principal

 @startuml

 actor Invoker as I
 participant "Frontend" as FE
 participant "AssignAGRView" as AV
 participant "AccessService" as AS
 participant "AGRRepository" as AGR
 participant "SoDValidator" as SV
 participant "PermissionCache" as PC
 participant "AuditLog" as AL
 database "Repo" as DB

 I -> FE: Selecciona AGR + User
 FE -> AV: POST /api/users/{id}/access-groups/

 AV -> AV: Validar JWT (CNST-009)
 AV -> AV: Verificar assign_function_groups
 alt Sin la funcion
   AV --> FE: 403
   AV -> AL: emit UNAUTHORIZED_ACCESS_ATTEMPT
 else
   AV -> AS: assign_agr(target_id, agr_id,\n  expires_at, invoker)

   AS -> DB: SELECT User FOR UPDATE
   alt User no existe / state invalido
     AS --> AV: error
     AV --> FE: 404 / 400
   else User OK
     AS -> AS: validar P-11
     AS -> AGR: get(agr_id)
     alt AGR no existe / inactivo
       AS --> AV: error
       AV --> FE: 400
     else AGR OK
       AS -> DB: SELECT Assignment\n  WHERE user=target\n  AND target_type='AccessGroup'\n  AND target_id=agr.id\n  AND state='ACTIVE'
       alt Ya asignado (FA-01)
         AS -> AL: emit AGR_ASSIGN_NOOP
         AV --> FE: 200 OK informativo
       else No asignado
         AS -> AGR: list_functions(agr_id)
         AGR --> AS: agr_functions
         AS -> AS: build effective_post_assign\n  = current_effective ∪ agr_functions
         AS -> SV: validate(effective_post_assign,\n  rules)
         alt SoD viola
           SV --> AS: SoDViolation
           AS -> AL: emit AGR_ASSIGN_FAILED
           AV --> FE: 409
         else SoD OK
           group Transaccion atomica
             AS -> DB: INSERT Assignment\n  (target_type='AccessGroup',\n   target_id=agr.id, ...)
             AS -> AL: emit AGR_ASSIGNED
             opt notify
               AS -> DB: INSERT InternalMessage
             end
           end
           AS -> PC: invalidate(target.id)
           AS --> AV: result
           AV --> FE: 201 Created
           FE --> I: Toast con resumen
         end
       end
     end
   end
 end

 @enduml

8.3 Diagrama de actividad
=========================

.. uml::
 :caption: UC_ACC_04 — actividad

 @startuml

 start

 :POST /api/users/{id}/access-groups/;

 if (JWT valido?) then (no)
   :401; stop
 else (si)
 endif

 if (Tiene assign_function_groups?) then (no)
   :403; :Audit UNAUTHORIZED;
   stop
 else (si)
 endif

 if (User existe?) then (no)
   :404; stop
 else (si)
 endif

 if (User state OK?) then (no)
   :400 INVALID_USER_STATE; stop
 else (si)
 endif

 if (P-11 viola?) then (si)
   :400 SELF_ASSIGN_FORBIDDEN;
   :Audit ALERTA;
   stop
 else (no)
 endif

 if (AGR existe + ACTIVE?) then (no)
   :400 ACCESS_GROUP_NOT_FOUND/INACTIVE; stop
 else (si)
 endif

 if (Ya asignado?) then (si)
   :Audit AGR_ASSIGN_NOOP;
   :200 OK informativo;
   stop
 else (no)
 endif

 :Expandir funciones del AGR;
 :Construir effective_post_assign
  = current ∪ agr_functions;
 :Evaluar SoDRules;

 if (SoD viola?) then (si)
   :409 SOD_VIOLATION;
   :Audit AGR_ASSIGN_FAILED;
   stop
 else (no)
 endif

 partition "Transaccion atomica" {
   :INSERT Assignment (target=AGR);
   :INSERT AuditEvent AGR_ASSIGNED;
   if (notify activo?) then (si)
     :INSERT InternalMessage;
   else (no)
   endif
 }

 if (Transaccion OK?) then (no)
   :ROLLBACK; :500/503;
   stop
 else (si)
 endif

 :PermissionCache.invalidate (post-COMMIT);
 :201 Created con resumen;

 stop

 @enduml

8.4 Diagrama AGR como agregacion
================================

.. uml::
 :caption: AGR contiene funciones — UC_ACC_04 asigna el AGR

 @startuml

 class User {
   id, username
 }

 class Assignment {
   id, user_id
   target_type: AccessGroup
   target_id: int (= agr.id)
   state, granted_at,
   expires_at?
 }

 class AccessGroup {
   id, code, display_name
   state
 }

 class AccessGroupFunction {
   access_group_id
   function_id
 }

 class Function {
   id, code, display_name
 }

 User "1" --> "*" Assignment
 Assignment "*" --> "1" AccessGroup : (target=AGR)
 AccessGroup "1" -- "*" AccessGroupFunction
 AccessGroupFunction "*" -- "1" Function

 note right of Assignment
   UC_ACC_04 crea ESTE Assignment
   con target_type='AccessGroup'
 end note

 note right of AccessGroupFunction
   UC_PERM_06 manipula esta tabla
   (composicion del AGR)
 end note

 @enduml

.. _uc-usr-03-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_USR_03 — actores y casos asociados

 @startuml

 left to right direction

 actor "Admin\n(AGR-006)" as ADMIN
 actor "User modificado" as USER <<beneficiario>>
 actor "Auditor" as AUD <<beneficiario>>
 actor "Sistema" as SYS <<sistema>>

 rectangle "MOD_Users" {
   usecase "UC_USR_03\nModificar Usuario" as UC03
   usecase "Validar transicion\nde state" as TS
   usecase "Validar email\nunico" as EU
   usecase "UPDATE User\nparcial" as UPD
   usecase "Cerrar Sessions\nactivas" as CSE
   usecase "Notificar via\nInternalMailbox" as NOT
   usecase "AuditEvent\nUSER_MODIFIED" as EMI
 }

 ADMIN --> UC03
 UC03 ..> TS : <<include>>
 UC03 ..> EU : <<extend (si email cambia)>>
 UC03 ..> UPD : <<include>>
 UC03 ..> CSE : <<extend (si state→BLOCKED)>>
 UC03 ..> NOT : <<extend (politica)>>
 UC03 ..> EMI : <<include>>
 NOT --> USER
 SYS --> EMI
 EMI --> AUD

 note bottom of TS
   P-11 anti-self-state-change
 end note
 note bottom of CSE
   side-effect: invalida tokens activos
 end note

 @enduml

8.2 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_USR_03 — flujo principal

 @startuml

 actor Admin as A
 participant "Frontend" as FE
 participant "ModifyUserView" as MV
 participant "UserService" as US
 participant "SessionService" as SS
 participant "AuditLog" as AL
 database "Repo" as DB

 A -> FE: Edita campos del User
 FE -> MV: PATCH /api/users/{id}/

 MV -> MV: Validar JWT (CNST-009)
 MV -> MV: Verificar modify_users (AGR-006)
 alt Sin permiso
   MV --> FE: 403 FORBIDDEN
   MV -> AL: emit UNAUTHORIZED_ACCESS_ATTEMPT
 else Con permiso
   MV -> US: modify_user(id, patch, admin)

   US -> DB: SELECT User FOR UPDATE WHERE id=?
   alt User no existe
     US --> MV: UserNotFound
     MV --> FE: 404
   else User existe
     US -> US: validar transicion de state
     alt user_id == admin.id y patch.state
       US --> MV: SelfStateChange
       MV --> FE: 400 SELF_STATE_CHANGE_FORBIDDEN
     else OK
       opt patch.email cambia
         US -> DB: SELECT email
         alt email duplicado
           US --> MV: EmailExists
           MV --> FE: 409 EMAIL_EXISTS
         end
       end

       group Transaccion atomica
         US -> DB: UPDATE User SET (campos),\n  last_modified_at=NOW(),\n  last_modified_by_admin_id=admin.id
         opt state -> BLOCKED
           US -> SS: close_all_active_for_user(user)
           SS -> DB: UPDATE Session\n  state='CLOSED',\n  close_reason='ADMIN_BLOCKED'
           SS -> DB: INSERT BlacklistedToken (N)
           SS --> US: closed_count
         end
         opt state cambio Y notify activo
           US -> DB: INSERT InternalMessage
         end
         US -> AL: emit USER_MODIFIED\n  {fields_changed,\n   state_transition?,\n   sessions_closed_count}
       end

       US --> MV: result
       MV --> FE: 200 OK con fields_changed
       FE --> A: Toast con resumen
     end
   end
 end

 @enduml

8.3 Diagrama de actividad
=========================

.. uml::
 :caption: UC_USR_03 — actividad

 @startuml

 start

 :Admin edita campos del User;
 :PATCH /api/users/{id}/;

 if (JWT valido?) then (no)
   :401 INVALID_TOKEN; stop
 else (si)
 endif

 if (Tiene modify_users?) then (no)
   :403 FORBIDDEN;
   :Audit UNAUTHORIZED_ACCESS_ATTEMPT;
   stop
 else (si)
 endif

 if (User existe?) then (no)
   :404 USER_NOT_FOUND; stop
 else (si)
 endif

 if (Datos validos?) then (no)
   :400 VALIDATION_ERROR; stop
 else (si)
 endif

 if (patch incluye state?) then (si)
   if (user_id == admin.id?) then (si)
     :400 SELF_STATE_CHANGE_FORBIDDEN;
     :Audit USER_MODIFY_FAILED ALERTA;
     stop
   else (no)
   endif
   if (transicion permitida?) then (no)
     :400 INVALID_STATE_TRANSITION; stop
   else (si)
   endif
 else (no)
 endif

 if (patch incluye email cambiado?) then (si)
   if (email duplicado?) then (si)
     :409 EMAIL_EXISTS; stop
   else (no)
   endif
 else (no)
 endif

 partition "Transaccion atomica" {
   :UPDATE User parcial
    + last_modified_*;
   if (state -> BLOCKED?) then (si)
     :UPDATE Sessions ACTIVE -> CLOSED;
     :INSERT BlacklistedToken (N);
   else (no)
   endif
   if (state cambio Y notify activo?) then (si)
     :INSERT InternalMessage;
   else (no)
   endif
   :INSERT AuditEvent USER_MODIFIED (CNST-025);
 }

 if (Transaccion OK?) then (no)
   :ROLLBACK;
   :500 / 503;
   stop
 else (si)
 endif

 :200 OK con fields_changed;
 :Frontend toast resumen;

 stop

 @enduml

8.4 Diagrama de estados — User.state
====================================

.. uml::
 :caption: Maquina de estados del User en UC_USR_03

 @startuml

 [*] --> ACTIVE : UC_USR_01

 ACTIVE --> INACTIVE : UC_USR_03\n(suspension temporal)
 ACTIVE --> BLOCKED : UC_USR_03\n(bloqueo administrativo)\n+cierra Sessions
 INACTIVE --> ACTIVE : UC_USR_03\n(reactivacion)
 INACTIVE --> BLOCKED : UC_USR_03
 BLOCKED --> ACTIVE : UC_USR_03\n(desbloqueo)
 BLOCKED --> INACTIVE : UC_USR_03

 ACTIVE --> ELIMINATED : UC_USR_04
 INACTIVE --> ELIMINATED : UC_USR_04
 BLOCKED --> ELIMINATED : UC_USR_04

 ELIMINATED --> [*]

 note right of BLOCKED
   Side-effect:
   Sessions ACTIVE -> CLOSED
   tokens blacklisted
 end note

 note right of ELIMINATED
   UC_USR_03 NO permite
   transicion hacia
   ELIMINATED — solo
   UC_USR_04
 end note

 @enduml

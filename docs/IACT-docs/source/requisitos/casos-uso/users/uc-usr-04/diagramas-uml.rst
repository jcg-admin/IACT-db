.. _uc-usr-04-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_USR_04 — actores y casos asociados

 @startuml

 left to right direction

 actor "User con funcion\ndeactivate_users" as INVOKER
 actor "User eliminado" as USER <<receptor>>
 actor "Auditor" as AUD <<beneficiario>>
 actor "Sistema" as SYS <<sistema>>

 rectangle "MOD_Users" {
   usecase "UC_USR_04\nEliminar Usuario\n(baja logica)" as UC04
   usecase "Validar P-11\nanti-self-elimination" as P11
   usecase "Transitar User\na ELIMINATED" as ELI
   usecase "Revocar\nAssignments" as REV
   usecase "Cerrar Sessions\n+ blacklist tokens" as CSE
   usecase "Notificar via\nInternalMailbox" as NOT
   usecase "AuditEvent\nUSER_ELIMINATED" as EMI
 }

 INVOKER --> UC04
 UC04 ..> P11 : <<include>>
 UC04 ..> ELI : <<include>>
 UC04 ..> REV : <<include>>
 UC04 ..> CSE : <<include>>
 UC04 ..> NOT : <<extend (politica notify)>>
 UC04 ..> EMI : <<include>>
 NOT --> USER
 SYS --> EMI
 EMI --> AUD

 note bottom of ELI
   BR-009: baja LOGICA, no DELETE fisico
 end note
 note bottom of P11
   admin no puede auto-eliminarse
 end note

 @enduml

8.2 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_USR_04 — flujo principal

 @startuml

 actor Invoker as I
 participant "Frontend" as FE
 participant "DeleteUserView" as DV
 participant "UserService" as US
 participant "SessionService" as SS
 participant "AuditLog" as AL
 database "Repo" as DB

 I -> FE: Click "Eliminar" en User X
 FE -> FE: Modal robusto + doble confirmacion
 I -> FE: Escribe "ELIMINAR" + Confirmar
 FE -> DV: DELETE /api/users/{X}/

 DV -> DV: Validar JWT (CNST-009)
 DV -> DV: Verificar funcion deactivate_users
 alt Sin la funcion
   DV --> FE: 403 FORBIDDEN
   DV -> AL: emit UNAUTHORIZED_ACCESS_ATTEMPT
 else Con la funcion
   DV -> US: eliminate_user(X, invoker)

   US -> DB: SELECT User FOR UPDATE WHERE id=X
   alt User no existe
     US --> DV: UserNotFound
     DV --> FE: 404
   else User existe
     alt User.state == ELIMINATED
       opt politica strict
         US --> DV: AlreadyEliminated
         DV --> FE: 409
       end
       opt politica idempotente (default)
         US -> AL: emit USER_ELIMINATE_NOOP
         US --> DV: noop_result
         DV --> FE: 200 OK informativo
       end
     else state != ELIMINATED
       alt invoker.id == X
         US --> DV: SelfElimination
         DV --> FE: 400
         DV -> AL: emit USER_ELIMINATE_FAILED ALERTA
       else
         group Transaccion atomica
           US -> DB: UPDATE User\n  state='ELIMINATED',\n  eliminated_at=NOW(),\n  eliminated_by=invoker.id
           US -> DB: UPDATE Assignment\n  state='REVOKED'\n  WHERE user=X AND state='ACTIVE'
           US -> SS: close_all_active(X, invoker,\n  reason='USER_ELIMINATED')
           SS -> DB: UPDATE Session... CLOSED
           SS -> DB: INSERT BlacklistedToken (N)
           SS --> US: closed_count
           opt notify activo
             US -> DB: INSERT InternalMessage
             alt mailbox falla
               US -> US: mailbox_failed=true (no abort)
             end
           end
           US -> AL: emit USER_ELIMINATED\n  {target, prior_state,\n   sessions_closed_count,\n   assignments_revoked_count,\n   user_notified, mailbox_failed}
         end

         US --> DV: result
         DV --> FE: 200 OK con resumen
         FE --> I: Toast con resumen + refresh lista
       end
     end
   end
 end

 @enduml

8.3 Diagrama de actividad
=========================

.. uml::
 :caption: UC_USR_04 — actividad

 @startuml

 start

 :Invoker abre detalle del User;
 :Click "Eliminar";
 :Modal robusto + escribir "ELIMINAR";

 if (Confirma?) then (no)
   :Cancelar; stop
 else (si)
 endif

 :DELETE /api/users/{id}/;

 if (JWT valido?) then (no)
   :401; stop
 else (si)
 endif

 if (Tiene deactivate_users?) then (no)
   :403;
   :Audit UNAUTHORIZED_ACCESS_ATTEMPT;
   stop
 else (si)
 endif

 if (User existe?) then (no)
   :404 USER_NOT_FOUND; stop
 else (si)
 endif

 if (User ya ELIMINATED?) then (si)
   if (politica strict?) then (si)
     :409 USER_ALREADY_ELIMINATED; stop
   else (no — default idempotente)
     :Audit USER_ELIMINATE_NOOP;
     :200 OK informativo;
     stop
   endif
 else (no)
 endif

 if (invoker.id == target.id?) then (si)
   :400 SELF_ELIMINATION_FORBIDDEN;
   :Audit USER_ELIMINATE_FAILED ALERTA;
   stop
 else (no)
 endif

 partition "Transaccion atomica" {
   :UPDATE User → ELIMINATED + metadata;
   :UPDATE Assignments activas → REVOKED;
   :UPDATE Sessions activas → CLOSED;
   :INSERT BlacklistedToken por cada Session;
   if (politica notify?) then (si)
     :INSERT InternalMessage;
     if (mailbox OK?) then (no)
       :mailbox_failed=true (sin abort);
     else (si)
     endif
   else (no)
   endif
   :INSERT AuditEvent USER_ELIMINATED;
 }

 if (Transaccion OK?) then (no)
   :ROLLBACK;
   :500 / 503;
   stop
 else (si)
 endif

 :200 OK con resumen
  (sessions_closed,
   assignments_revoked);
 :Frontend toast + refresh;

 stop

 @enduml

8.4 Diagrama de estados — User.state
====================================

.. uml::
 :caption: User.state con foco en transicion a ELIMINATED

 @startuml

 [*] --> ACTIVE : UC_USR_01

 ACTIVE --> INACTIVE : UC_USR_03
 ACTIVE --> BLOCKED : UC_USR_03
 INACTIVE --> ACTIVE : UC_USR_03
 BLOCKED --> ACTIVE : UC_USR_03

 ACTIVE --> ELIMINATED : UC_USR_04\n+ revoke Assignments\n+ close Sessions
 INACTIVE --> ELIMINATED : UC_USR_04
 BLOCKED --> ELIMINATED : UC_USR_04

 ELIMINATED --> [*] : (terminal — registro\npreservado por BR-009)

 note right of ELIMINATED
   - eliminated_at, eliminated_by_admin_id
   - email/username NO liberados
   - data historica preservada
   - retencion CNST-006 (2 anios)
 end note

 @enduml

8.5 Diagrama de actividad — side-effects post-eliminacion
=========================================================

.. uml::
 :caption: Que pasa cuando el User intenta usar tokens o iniciar
           sesion despues de UC_USR_04

 @startuml

 start

 :User eliminado intenta operacion;

 if (Tiene token activo (cached)?) then (si)
   :GET /api/{cualquier}/;
   :Middleware verifica blacklist;
   :Token blacklisteado;
   :401 INVALID_TOKEN; stop
 else (no — intenta nuevo login)
 endif

 :POST /api/auth/login/;
 :Backend SELECT User WHERE username = ?;

 if (User.state == ELIMINATED?) then (si)
   :401 ACCOUNT_ELIMINATED;
   :Audit LOGIN_FAILED
    {reason:'account_eliminated',
     user_state:'ELIMINATED'};
   stop
 endif

 stop

 @enduml

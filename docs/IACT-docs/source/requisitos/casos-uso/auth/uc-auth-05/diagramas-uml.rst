.. _uc-auth-05-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_AUTH_05 — actores y casos asociados

 @startuml

 left to right direction

 actor "Admin\n(AGR-006)" as ADMIN
 actor "User afectado" as USER <<beneficiario>>
 actor "Auditor" as AUD <<beneficiario>>
 actor "Sistema" as SYS <<sistema>>

 rectangle "MOD_Auth" {
   usecase "UC_AUTH_05\nGestionar Sesiones" as UC05
   usecase "Listar Sessions" as LST
   usecase "Cerrar Session\nindividual" as C1
   usecase "Cerrar todas\nlas del User" as CALL
   usecase "Notificar\n(opcional)" as NOT
   usecase "AuditEvent\nSESSION_CLOSED" as EMI
 }

 ADMIN --> UC05
 UC05 ..> LST : <<extend>>
 UC05 ..> C1 : <<extend>>
 UC05 ..> CALL : <<extend>>
 C1 ..> EMI : <<include>>
 CALL ..> EMI : <<include>>
 C1 ..> NOT : <<extend>>
 CALL ..> NOT : <<extend>>
 NOT --> USER
 SYS --> EMI
 EMI --> AUD

 @enduml

8.2 Diagrama de secuencia (cierre individual)
=============================================

.. uml::
 :caption: UC_AUTH_05 sub-flujo 3.B

 @startuml

 actor Admin as A
 participant "Frontend" as FE
 participant "CloseSessionView" as CV
 participant "SessionService" as SS
 database "MySQL" as DB

 A -> FE: Click "Cerrar" en Session X
 FE -> FE: Modal confirm
 A -> FE: Confirmar
 FE -> CV: POST /api/auth/sessions/{id}/close/
 CV -> CV: Validar JWT (CNST-009)
 CV -> CV: Verificar close_user_session
 alt Sin permiso
   CV --> FE: 403 FORBIDDEN
 else
   CV -> SS: close(session_id, admin)

   group Transaccion atomica
     SS -> DB: SELECT Session FOR UPDATE
     DB --> SS: session
     alt Ya CLOSED (FA-02)
       SS -> DB: INSERT AuditEvent SESSION_CLOSE_NOOP
       SS --> CV: noop
     else ACTIVE
       SS -> DB: UPDATE Session SET\n  state='CLOSED',\n  close_reason='ADMIN_REVOKED',\n  closed_by_admin_id=admin.id
       SS -> DB: INSERT BlacklistedToken
       SS -> DB: INSERT AuditEvent SESSION_CLOSED
       opt NOTIFY_USER_ON_ADMIN_SESSION_CLOSE
         SS -> DB: INSERT InternalMessage
       end
     end
   end

   SS --> CV: result
   CV --> FE: 200 OK
   FE --> A: Toast confirmacion
 end

 @enduml

8.3 Diagrama de actividad (cierre masivo 3.C)
=============================================

.. uml::
 :caption: UC_AUTH_05 sub-flujo 3.C — actividad

 @startuml

 start

 :Admin abre detalle del User;
 :Click "Cerrar todas las sesiones";
 :Modal robusto con count;

 if (Admin confirma?) then (no)
   :Cancelar; stop
 else (si)
 endif

 :POST /api/users/{id}/close-all-sessions/;

 if (JWT valido?) then (no)
   :401; stop
 else (si)
 endif

 if (Tiene close_user_session?) then (no)
   :403; :Audit UNAUTHORIZED_ACCESS_ATTEMPT;
   stop
 else (si)
 endif

 if (User existe?) then (no)
   :404; stop
 else (si)
 endif

 if (target_user == admin?) then (si)
   if (Setting permite?) then (no)
     :400 SELF_BULK_CLOSE_FORBIDDEN; stop
   else (si)
   endif
 else (no)
 endif

 :SELECT Sessions ACTIVE WHERE user=target;

 if (count == 0?) then (si)
   :Audit BULK_SESSION_CLOSE_NOOP;
   :200 OK count=0;
   stop
 else (no)
 endif

 partition "Transaccion atomica" {
   :UPDATE Sessions → CLOSED;
   :INSERT BlacklistedToken (N);
   :INSERT N AuditEvent SESSION_CLOSED;
   :INSERT 1 AuditEvent BULK_SESSION_CLOSE;
   if (Setting notify) then (si)
     :INSERT InternalMessage al User;
   else (no)
   endif
 }

 if (Transaccion OK?) then (no)
   :ROLLBACK;
   :500/503;
   stop
 else (si)
 endif

 :200 OK con count;
 :Frontend toast con count;

 stop

 @enduml

8.4 Diagrama de estados — Session (foco UC_AUTH_05)
===================================================

.. uml::
 :caption: Estados Session relevantes a UC_AUTH_05

 @startuml

 [*] --> ACTIVE : UC_AUTH_01

 ACTIVE --> CLOSED : UC_AUTH_05 (ADMIN_REVOKED)
 ACTIVE --> CLOSED : UC_AUTH_02 (USER_LOGOUT)
 ACTIVE --> CLOSED : CNST-004 (SUPERSEDED)
 ACTIVE --> CLOSED : CNST-005 (TIMEOUT)
 ACTIVE --> CLOSED : UC_AUTH_03 (PASSWORD_RESET)

 note right of CLOSED
   close_reason indica origen
   UC_AUTH_05 solo origina ADMIN_REVOKED
 end note

 CLOSED --> [*]

 @enduml

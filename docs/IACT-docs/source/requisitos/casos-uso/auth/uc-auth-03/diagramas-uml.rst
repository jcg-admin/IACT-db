.. _uc-auth-03-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_AUTH_03 — actores y casos asociados

 @startuml

 left to right direction

 actor "Admin\n(AGR-006\nuser_admin_group)" as ADMIN
 actor "User afectado" as USER <<beneficiario>>
 actor "Auditor" as AUD <<beneficiario>>
 actor "Sistema" as SYS <<sistema>>

 rectangle "MOD_Auth" {
   usecase "UC_AUTH_03\nRecuperar Contrasena" as UC03
   usecase "Generar password\ntemporal" as GEN
   usecase "Cerrar Sessions\ndel User" as CSE
   usecase "Notificar via\nInternalMailbox" as NOT
   usecase "Emitir AuditEvent\nPASSWORD_RESET" as EMI
 }

 ADMIN --> UC03
 UC03 ..> GEN : <<include>>
 UC03 ..> CSE : <<include>>
 UC03 ..> NOT : <<include>>
 UC03 ..> EMI : <<include>>
 NOT --> USER : InternalMessage
 SYS --> EMI
 EMI --> AUD : (consume\nUC_AUD_*)

 note bottom of NOT
   CNST-001 prohibe email/SMTP
   CNST-002 InternalMailbox obligatorio
 end note

 @enduml

8.2 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_AUTH_03 — flujo principal

 @startuml

 actor Admin as A
 participant "Frontend" as FE
 participant "ResetPasswordView" as RV
 participant "AuthService" as AS
 participant "PasswordGenerator" as PG
 database "MySQL" as DB

 A -> FE: Click "Resetear contrasena"
 FE -> FE: Modal de confirmacion
 A -> FE: Confirmar
 FE -> RV: POST /api/users/{id}/reset-password/

 RV -> RV: Validar JWT (CNST-009)
 RV -> RV: Verificar funcion\nreset_password (AGR-006)
 alt Sin permiso
   RV --> FE: 403 FORBIDDEN
 else Con permiso
   RV -> AS: reset_password(target_id, admin)

   AS -> DB: SELECT User WHERE id=target_id
   DB --> AS: user
   AS -> AS: Validar (no auto-reset, no eliminado)

   AS -> PG: generate(length=12)
   PG --> AS: temp_password
   AS -> AS: bcrypt.hashpw(temp_password, cost=12)

   group Transaccion atomica
     AS -> DB: UPDATE user SET\n  password_hash=?,\n  first_login=true,\n  password_changed_at=NOW()
     AS -> DB: UPDATE session SET\n  state='CLOSED',\n  close_reason='PASSWORD_RESET'\n  WHERE user_id=? AND state='ACTIVE'
     AS -> DB: INSERT BlacklistedToken (N tokens)
     AS -> DB: INSERT InternalMessage\n  (recipient=user, body=temp_pwd)
     AS -> DB: INSERT AuditEvent\n  (PASSWORD_RESET)
   end

   AS --> RV: success (sin temp_password)
   RV --> FE: 200 OK
   FE --> A: "Contrasena reseteada. Notificacion en buzon."
 end

 @enduml

8.3 Diagrama de actividad
=========================

.. uml::
 :caption: UC_AUTH_03 — actividad

 @startuml

 start

 :Admin selecciona User;
 :Admin click "Resetear contrasena";
 :Modal de confirmacion;

 if (Admin confirma?) then (no)
   :Cancelar; stop
 else (si)
 endif

 :POST /api/users/{id}/reset-password/;

 if (JWT valido?) then (no)
   :401 INVALID_TOKEN; stop
 else (si)
 endif

 if (Tiene reset_password?) then (no)
   :403 FORBIDDEN;
   :Audit UNAUTHORIZED_ACCESS_ATTEMPT;
   stop
 else (si)
 endif

 if (User existe?) then (no)
   :404 USER_NOT_FOUND; stop
 else (si)
 endif

 if (Es auto-reset?) then (si)
   :400 SELF_RESET_FORBIDDEN; stop
 else (no)
 endif

 if (User ELIMINATED?) then (si)
   :400 USER_ELIMINATED; stop
 else (no)
 endif

 :Generar password temporal (12+ chars);
 :bcrypt.hashpw cost 12;

 partition "Transaccion atomica" {
   :UPDATE User (password_hash, first_login=true);
   :UPDATE Session (CLOSED, PASSWORD_RESET);
   :INSERT BlacklistedToken;
   :INSERT InternalMessage (CNST-001+002);
   :INSERT AuditEvent PASSWORD_RESET (CNST-025);
 }

 if (Transaccion OK?) then (no)
   :ROLLBACK;
   :500/503;
   stop
 else (si)
 endif

 :200 OK (sin temp_password en response);
 :Frontend muestra confirmacion (sin password);

 stop

 @enduml

8.4 Diagrama de estados — User.first_login
==========================================

.. uml::
 :caption: Estado first_login del User

 @startuml

 [*] --> first_login_true : UC_USR_01\n(creacion)

 first_login_true --> first_login_true : UC_AUTH_03\n(reset por admin)
 first_login_true --> first_login_false : UC_AUTH_04\n(cambio voluntario\npost first login)

 first_login_false --> first_login_true : UC_AUTH_03\n(reset)

 note right of first_login_true
   UC_AUTH_01 detecta first_login=true
   y dispara FA-01 → forzar UC_AUTH_04
 end note

 @enduml

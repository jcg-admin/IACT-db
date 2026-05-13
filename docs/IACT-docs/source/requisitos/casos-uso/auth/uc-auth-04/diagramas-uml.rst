.. _uc-auth-04-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_AUTH_04 — actores y casos asociados

 @startuml

 left to right direction

 actor "User\nautenticado" as USER
 actor "Auditor" as AUD <<beneficiario>>
 actor "Sistema" as SYS <<sistema>>

 rectangle "MOD_Auth" {
   usecase "UC_AUTH_04\nCambiar Contrasena" as UC04
   usecase "Validar password\nactual" as VAL
   usecase "Validar complejidad" as COMP
   usecase "Verificar historial\n(no reuso)" as HIST
   usecase "Cerrar otras\nSessions" as CSE
   usecase "Emitir AuditEvent\nPASSWORD_CHANGED" as EMI
 }

 USER --> UC04
 UC04 ..> VAL : <<include>>
 UC04 ..> COMP : <<include>>
 UC04 ..> HIST : <<include>>
 UC04 ..> CSE : <<include>>
 UC04 ..> EMI : <<include>>
 SYS --> EMI
 EMI --> AUD

 note bottom of HIST
   N=5 ultimas hashes (BR-AUTH-32)
 end note

 @enduml

8.2 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_AUTH_04 — flujo principal

 @startuml

 actor User as U
 participant "Frontend" as FE
 participant "ChangePasswordView" as CV
 participant "AuthService" as AS
 participant "PolicyValidator" as PV
 database "MySQL" as DB

 U -> FE: Form (current, new, confirm)
 FE -> FE: Client-side basic validation
 FE -> CV: POST /api/auth/change-password/
 CV -> CV: Validar JWT (CNST-009)
 CV -> AS: change_password(user, current, new)

 AS -> DB: SELECT User FOR UPDATE
 DB --> AS: user
 AS -> AS: bcrypt.checkpw(current, user.hash)
 alt Password actual incorrecto
   AS --> CV: WrongCurrentPassword
   CV --> FE: 400 WRONG_CURRENT_PASSWORD
 else OK
   AS -> PV: validate(new)
   alt Falla politica
     PV --> AS: violations
     AS --> CV: WeakPassword
     CV --> FE: 400 WEAK_PASSWORD
   else OK
     AS -> DB: SELECT history WHERE user=?\n  ORDER BY changed_at DESC LIMIT 5
     DB --> AS: hashes[5]
     AS -> AS: for h in hashes:\n  if bcrypt.checkpw(new, h): reused
     alt Reuso
       AS --> CV: PasswordReused
       CV --> FE: 400 PASSWORD_REUSED
     else OK
       AS -> AS: bcrypt.hashpw(new, cost=12)

       group Transaccion atomica
         AS -> DB: UPDATE user (hash, first_login=false,\n  password_changed_at=NOW())
         AS -> DB: INSERT password_history
         AS -> DB: UPDATE other sessions (CLOSED)
         AS -> DB: INSERT BlacklistedToken
         AS -> DB: INSERT AuditEvent PASSWORD_CHANGED
       end

       AS --> CV: success
       CV --> FE: 200 OK
       FE --> U: "Contrasena actualizada"
     end
   end
 end

 @enduml

8.3 Diagrama de actividad
=========================

.. uml::
 :caption: UC_AUTH_04 — actividad

 @startuml

 start

 :User envia (current, new, confirm);

 if (JWT valido?) then (no)
   :401; stop
 else (si)
 endif

 if (new == confirmation?) then (no)
   :400 MISMATCH; stop
 else (si)
 endif

 if (bcrypt.checkpw(current, user.hash)?) then (no)
   :delay defensivo;
   :incrementar contador;
   if (5+ fallos en 5min?) then (si)
     :429 TOO_MANY_ATTEMPTS;
     :Audit SUSPICIOUS;
     stop
   else (no)
     :400 WRONG_CURRENT;
     stop
   endif
 else (si)
 endif

 if (Politica OK?) then (no)
   :400 WEAK_PASSWORD; stop
 else (si)
 endif

 if (Igual a actual?) then (si)
   :400 SAME_AS_CURRENT; stop
 else (no)
 endif

 if (En history N=5?) then (si)
   :400 PASSWORD_REUSED; stop
 else (no)
 endif

 :bcrypt.hashpw(new, cost=12);

 partition "Transaccion atomica" {
   :UPDATE User (hash, first_login=false);
   :INSERT PasswordHistory;
   if (Setting cierra otras?) then (si)
     :UPDATE Sessions != current → CLOSED;
     :INSERT BlacklistedToken;
   else (no)
   endif
   :INSERT AuditEvent PASSWORD_CHANGED;
 }

 if (Transaccion OK?) then (no)
   :ROLLBACK; :500/503;
   stop
 else (si)
 endif

 :200 OK;
 :Frontend toast + nav;

 stop

 @enduml

8.4 Diagrama de estados — User.first_login + scope
==================================================

.. uml::
 :caption: Transiciones de scope post UC_AUTH_04

 @startuml

 state "Sesion scope reducido" as REDUCED
 state "Sesion scope pleno" as FULL

 [*] --> REDUCED : UC_AUTH_01 + FA-01\n(first_login=true)

 REDUCED --> FULL : UC_AUTH_04 OK\n(first_login=false)

 FULL --> FULL : UC_AUTH_04 voluntario

 FULL --> REDUCED : UC_AUTH_03\n(admin reset)\nuser proximo login

 @enduml

.. _uc-usr-01-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_USR_01 — actores y casos asociados

 @startuml

 left to right direction

 actor "Admin\n(AGR-006)" as ADMIN
 actor "Nuevo User" as USER <<beneficiario>>
 actor "Auditor" as AUD <<beneficiario>>
 actor "Sistema" as SYS <<sistema>>

 rectangle "MOD_Users" {
   usecase "UC_USR_01\nCrear Usuario" as UC01
   usecase "Generar username\n(CNST-029)" as GEN
   usecase "Generar password\ntemporal" as PWD
   usecase "Asignar AGR\nopcional" as AGR
   usecase "Notificar via\nInternalMailbox" as NOT
   usecase "AuditEvent\nUSER_CREATED" as EMI
 }

 ADMIN --> UC01
 UC01 ..> GEN : <<include>>
 UC01 ..> PWD : <<include>>
 UC01 ..> AGR : <<extend>>
 UC01 ..> NOT : <<include>>
 UC01 ..> EMI : <<include>>
 NOT --> USER : InternalMessage
 SYS --> EMI
 EMI --> AUD

 note bottom of NOT
   CNST-001 prohibe email/SMTP
   CNST-002 InternalMailbox obligatorio
 end note

 @enduml

8.2 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_USR_01 — flujo principal

 @startuml

 actor Admin as A
 participant "Frontend" as FE
 participant "CreateUserView" as CV
 participant "UserService" as US
 participant "UsernameGenerator" as UG
 participant "PasswordGenerator" as PG
 database "MySQL" as DB

 A -> FE: Form (first, last, email, agr_id?)
 FE -> CV: POST /api/users/

 CV -> CV: Validar JWT (CNST-009)
 CV -> CV: Verificar create_users (AGR-006)
 alt Sin permiso
   CV --> FE: 403 FORBIDDEN
 else
   CV -> US: create_user(data, admin)

   US -> DB: SELECT email
   alt Email existe
     US --> CV: EmailExists
     CV --> FE: 409 EMAIL_EXISTS
   else No existe
     US -> UG: generate(first, last)
     UG -> DB: SELECT COUNT username LIKE base%
     UG --> US: ana.gomez.0001
     US -> PG: generate(length=12)
     PG --> US: temp_password
     US -> US: bcrypt.hashpw(temp, cost=12)

     group Transaccion atomica
       US -> DB: INSERT User\n  (username, email, password_hash,\n   first_login=true, ...)
       opt access_group_id provided
         US -> DB: INSERT Assignment\n  (user, agr, granted_by=admin)
       end
       US -> DB: INSERT InternalMessage\n  (recipient=user, body=temp_password)
       US -> DB: INSERT AuditEvent\n  USER_CREATED
     end

     US --> CV: {user_id, username}
     CV --> FE: 201 Created (sin password)
     FE --> A: Toast "Creado: ana.gomez.0001"
   end
 end

 @enduml

8.3 Diagrama de actividad
=========================

.. uml::
 :caption: UC_USR_01 — actividad

 @startuml

 start

 :Admin abre form;
 :Ingresa datos + AGR opcional;
 :POST /api/users/;

 if (JWT valido?) then (no)
   :401; stop
 else (si)
 endif

 if (Tiene create_users?) then (no)
   :403;
   :Audit UNAUTHORIZED_ACCESS_ATTEMPT;
   stop
 else (si)
 endif

 if (Datos validos?) then (no)
   :400 VALIDATION_ERROR; stop
 else (si)
 endif

 if (Email unico?) then (no)
   :409 EMAIL_EXISTS; stop
 else (si)
 endif

 if (Setting strict y email externo?) then (si)
   :400 EXTERNAL_EMAIL_FORBIDDEN; stop
 else (no)
 endif

 :Generar username CNST-029;
 :Generar password temporal;
 :bcrypt.hashpw cost 12;

 partition "Transaccion atomica" {
   :INSERT User (first_login=true);
   if (AGR provisto?) then (si)
     :INSERT Assignment;
   else (no)
   endif
   :INSERT InternalMessage (CNST-001+002);
   :INSERT AuditEvent USER_CREATED (CNST-025);
 }

 if (Transaccion OK?) then (no)
   :ROLLBACK; :500/503;
   stop
 else (si)
 endif

 :201 Created (sin password en response);
 :Frontend toast con username;

 stop

 @enduml

8.4 Diagrama de estados — User.first_login
==========================================

.. uml::
 :caption: Estados first_login del nuevo User

 @startuml

 [*] --> first_login_true : UC_USR_01 (creacion)

 first_login_true --> first_login_true : UC_AUTH_03\n(admin reset)
 first_login_true --> first_login_false : UC_AUTH_04\n(cambio post first login)

 first_login_false --> first_login_true : UC_AUTH_03

 note right of first_login_true
   UC_AUTH_01 detecta first_login=true
   y dispara FA-01 → forzar UC_AUTH_04
 end note

 @enduml

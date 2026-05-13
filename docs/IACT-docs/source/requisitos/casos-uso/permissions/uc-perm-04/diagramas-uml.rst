.. _uc-perm-04-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_PERM_04 — actores

 @startuml
 left to right direction

 actor "User con funcion\nrevoke_exceptional_permission" as INVOKER
 actor "User destino" as TARGET
 actor "Auditor high-priority" as AUD

 rectangle "MOD_Permissions" {
   usecase "UC_PERM_04\nRevocar\nExceptional" as UC04
   usecase "UPDATE state\nREVOKED" as UPD
   usecase "Notificar\nObligatorio" as NOT
   usecase "AuditEvent\nREVOKED" as EMI
 }

 INVOKER --> UC04
 UC04 ..> UPD : <<include>>
 UC04 ..> NOT : <<include>>
 UC04 ..> EMI : <<include>>
 NOT --> TARGET
 EMI --> AUD

 note bottom of NOT
   Mailbox-or-abort HARD
 end note

 @enduml

8.2 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_PERM_04 — flujo

 @startuml

 actor Invoker as I
 participant "Frontend" as FE
 participant "RevokeExcView" as RV
 participant "AccessService" as AS
 participant "PermCache" as PC
 participant "InternalMailbox" as IM
 participant "AuditLog" as AL
 database "Repo" as DB

 I -> FE: Selecciona permission + reason
 FE -> RV: DELETE .../{permission_id}/

 RV -> RV: Validar JWT
 RV -> RV: Verificar revoke_exc
 alt Sin permiso
   RV --> FE: 403
   RV -> AL: emit UNAUTHORIZED
 else
   RV -> AS: revoke_exc(perm_id, reason,
                          invoker)

   AS -> DB: SELECT ExceptionalPermission
   alt No existe / EXPIRED / REVOKED
     AS --> RV: error
     RV --> FE: 404 / 400 / 200 NOOP
   else ACTIVE
     AS -> AS: validar P-11
     AS -> AS: validar reason
     group Transaccion atomica
       AS -> DB: UPDATE state=REVOKED
       AS -> IM: send (HARD)
       alt Mailbox falla
         IM --> AS: MailboxFailure
         AS --> RV: error 500
       else Mailbox OK
         AS -> AL: emit
           EXCEPTIONAL_PERMISSION_REVOKED
       end
     end
     AS -> PC: invalidate post-COMMIT
     AS --> RV: result
     RV --> FE: 200 OK
   end
 end

 @enduml

8.3 Diagrama de actividad
=========================

.. uml::
 :caption: UC_PERM_04 — actividad

 @startuml

 start

 :DELETE .../{permission_id}/;

 if (JWT valido?) then (no)
   :401; stop
 else (si)
 endif

 if (Tiene revoke_exceptional?) then (no)
   :403; :Audit UNAUTHORIZED;
   stop
 else (si)
 endif

 if (Permission existe?) then (no)
   :404; stop
 else (si)
 endif

 if (state == REVOKED?) then (si)
   :Audit REVOKE_NOOP;
   :200 informativo; stop
 else (no)
 endif

 if (state == EXPIRED?) then (si)
   :400 INVALID_STATE; stop
 else (no — ACTIVE)
 endif

 if (P-11 viola?) then (si)
   :400 SELF_REVOKE_FORBIDDEN;
   :Audit ALERTA;
   stop
 else (no)
 endif

 if (reason valido?) then (no)
   :400; stop
 else (si)
 endif

 :Iniciar transaccion atomica;
 :UPDATE state=REVOKED + metadata;
 :INSERT InternalMessage (HARD);
 if (Mailbox OK?) then (no)
   :ROLLBACK; :500 MAILBOX_FAILED;
   stop
 else (si)
 endif
 :INSERT AuditEvent
  EXCEPTIONAL_PERMISSION_REVOKED;
 :Commit;

 :PermCache.invalidate post-COMMIT;
 :200 OK;

 stop

 @enduml

8.4 Estados ExceptionalPermission
=================================

.. uml::
 :caption: Maquina de estados

 @startuml

 [*] --> ACTIVE : UC_PERM_03 / UC_ACC_08
 ACTIVE --> REVOKED : UC_PERM_04
 ACTIVE --> EXPIRED : cron job
 REVOKED --> [*]
 EXPIRED --> [*]

 note right of REVOKED
   revoked_by_admin_id !=
   NULL distingue de EXPIRED
 end note

 @enduml

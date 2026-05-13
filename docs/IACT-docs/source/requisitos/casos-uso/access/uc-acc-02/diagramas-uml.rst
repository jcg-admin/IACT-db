.. _uc-acc-02-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_ACC_02 — actores y casos asociados

 @startuml

 left to right direction

 actor "User con funcion\nrevoke_functions" as INVOKER
 actor "User destino" as TARGET <<receptor>>
 actor "Auditor" as AUD <<beneficiario>>
 actor "Sistema" as SYS <<sistema>>

 rectangle "MOD_Access" {
   usecase "UC_ACC_02\nRevocar Funciones" as UC02
   usecase "Validar P-11\nanti-self-revoke" as P11
   usecase "Localizar Assignments\nACTIVE matching" as LOC
   usecase "Calcular post-revoke\n+ warnings" as CALC
   usecase "UPDATE → REVOKED" as UPD
   usecase "Invalidar cache" as CACHE
   usecase "Notificar via\nInternalMailbox" as NOT
   usecase "AuditEvent\nFUNCTIONS_REVOKED" as EMI
 }

 INVOKER --> UC02
 UC02 ..> P11 : <<include>>
 UC02 ..> LOC : <<include>>
 UC02 ..> CALC : <<include>>
 UC02 ..> UPD : <<include>>
 UC02 ..> CACHE : <<include>>
 UC02 ..> NOT : <<extend>>
 UC02 ..> EMI : <<include>>
 NOT --> TARGET
 SYS --> EMI
 EMI --> AUD

 note bottom of UPD
   BR-009: soft-delete via state,
   no DELETE fisico
 end note
 note bottom of CALC
   warnings: no_functions,
   critical_revoked, last_holder
 end note

 @enduml

8.2 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_ACC_02 — flujo principal

 @startuml

 actor Invoker as I
 participant "Frontend" as FE
 participant "RevokeFunctionsView" as RV
 participant "AccessService" as AS
 participant "PermissionCache" as PC
 participant "AuditLog" as AL
 database "Repo" as DB

 I -> FE: Selecciona funciones a revocar
 FE -> FE: Modal robusto + revoke_reason
 I -> FE: Confirmar
 FE -> RV: DELETE /api/users/{id}/functions/

 RV -> RV: Validar JWT (CNST-009)
 RV -> RV: Verificar revoke_functions
 alt Sin la funcion
   RV --> FE: 403 FORBIDDEN
   RV -> AL: emit UNAUTHORIZED_ACCESS_ATTEMPT
 else Con la funcion
   RV -> AS: revoke(target_id, function_ids,\n  reason, invoker)

   AS -> DB: SELECT User FOR UPDATE
   alt No existe / ELIMINATED
     AS --> RV: error
     RV --> FE: 404 / 400
   else
     AS -> AS: validar P-11 anti-self-revoke
     AS -> DB: SELECT Assignments ACTIVE\n  WHERE user=target\n  AND function IN (...)
     DB --> AS: matched_assignments
     AS -> AS: separar to_revoke vs skipped
     alt to_revoke vacio (FA-01)
       AS -> AL: emit FUNCTIONS_REVOKE_NOOP
       AS --> RV: noop_result
       RV --> FE: 200 OK informativo
     else hay revocaciones
       AS -> DB: COUNT current_active\n  - to_revoke (post-revoke set)
       AS -> AS: calcular warnings\n  (no_functions, critical, last_holder)
       alt strict + last_holder violado
         AS -> AL: emit FUNCTIONS_REVOKE_FAILED
         AS --> RV: LastHolderProtection
         RV --> FE: 409
       else procede
         group Transaccion atomica
           AS -> DB: UPDATE Assignment\n  state='REVOKED', revoked_at,\n  revoked_by_admin_id, revoke_reason\n  WHERE id IN (...)
           AS -> AL: emit FUNCTIONS_REVOKED
           opt notify
             AS -> DB: INSERT InternalMessage
           end
         end
         AS -> PC: invalidate(target.id)\n  (post-COMMIT)
         AS --> RV: result + warnings
         RV --> FE: 200 OK
         FE --> I: Toast + warnings visuales
       end
     end
   end
 end

 @enduml

8.3 Diagrama de actividad
=========================

.. uml::
 :caption: UC_ACC_02 — actividad

 @startuml

 start

 :DELETE /api/users/{id}/functions/;

 if (JWT valido?) then (no)
   :401; stop
 else (si)
 endif

 if (revoke_functions?) then (no)
   :403;
   :Audit UNAUTHORIZED_ACCESS_ATTEMPT;
   stop
 else (si)
 endif

 if (Payload valido?) then (no)
   :400 VALIDATION_ERROR
    (incluye revoke_reason missing); stop
 else (si)
 endif

 if (User existe?) then (no)
   :404; stop
 else (si)
 endif

 if (User ELIMINATED?) then (si)
   :400 INVALID_USER_STATE; stop
 else (no)
 endif

 if (P-11 viola?) then (si)
   :400 SELF_REVOKE_FORBIDDEN;
   :Audit ALERTA;
   stop
 else (no)
 endif

 :SELECT Assignments ACTIVE matching;
 :Filtrar idempotente
  (skip ya REVOKED);

 if (Quedan funciones a revocar?) then (no)
   :Audit FUNCTIONS_REVOKE_NOOP;
   :200 OK informativo;
   stop
 else (si)
 endif

 :Calcular post_revoke_active_count;
 :Detectar warnings (no_functions,
  critical_revoked, last_holder);

 if (BLOCK_LAST_HOLDER y last_holder violado?) then (si)
   :409 LAST_HOLDER_PROTECTION;
   :Audit FUNCTIONS_REVOKE_FAILED;
   stop
 else (no)
 endif

 partition "Transaccion atomica" {
   :UPDATE Assignments → REVOKED + metadata;
   :INSERT AuditEvent FUNCTIONS_REVOKED;
   if (notify activo?) then (si)
     :INSERT InternalMessage;
   else (no)
   endif
 }

 if (Transaccion OK?) then (no)
   :ROLLBACK;
   :500 / 503;
   stop
 else (si)
 endif

 :PermissionCache.invalidate(target.id)
  (post-COMMIT);
 :200 OK con warnings;
 :Frontend toast + warnings UI;

 stop

 @enduml

8.4 Diagrama de transicion Assignment.state
===========================================

.. uml::
 :caption: Maquina de estados Assignment con foco UC_ACC_02

 @startuml

 [*] --> ACTIVE : UC_ACC_01\n(asignacion)

 ACTIVE --> REVOKED : UC_ACC_02\n(revocacion explicita)
 ACTIVE --> REVOKED : UC_USR_04\n(eliminacion del User)
 ACTIVE --> EXPIRED : cron job\n(NOW > expires_at)

 REVOKED --> [*]
 EXPIRED --> [*]

 note right of REVOKED
   revoked_by_admin_id
   revoked_at
   revoke_reason (obligatorio)
   Historial preservado (BR-009)
 end note

 @enduml

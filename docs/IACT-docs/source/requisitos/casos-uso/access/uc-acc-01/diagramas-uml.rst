.. _uc-acc-01-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_ACC_01 — actores y casos asociados

 @startuml

 left to right direction

 actor "User con funcion\nassign_functions" as INVOKER
 actor "User destino" as TARGET <<beneficiario>>
 actor "Auditor" as AUD <<beneficiario>>
 actor "Sistema" as SYS <<sistema>>

 rectangle "MOD_Access" {
   usecase "UC_ACC_01\nAsignar Funciones" as UC01
   usecase "Validar User destino" as VUSER
   usecase "Validar funciones\n(existen + activas)" as VFUN
   usecase "Filtrar idempotente" as IDEM
   usecase "Validar SoD\n(CNST-005)" as VSOD
   usecase "INSERT N Assignments" as INS
   usecase "Invalidar cache\npermisos" as CACHE
   usecase "Notificar via\nInternalMailbox" as NOT
   usecase "AuditEvent\nFUNCTIONS_ASSIGNED" as EMI
 }

 INVOKER --> UC01
 UC01 ..> VUSER : <<include>>
 UC01 ..> VFUN : <<include>>
 UC01 ..> IDEM : <<include>>
 UC01 ..> VSOD : <<include>>
 UC01 ..> INS : <<include>>
 UC01 ..> CACHE : <<include>>
 UC01 ..> NOT : <<extend>>
 UC01 ..> EMI : <<include>>
 NOT --> TARGET
 SYS --> EMI
 EMI --> AUD

 note bottom of VSOD
   BR-007 + CNST-005:
   all-or-nothing — SoD violation
   bloquea TODA la asignacion
 end note
 note bottom of VFUN
   P-15 RBAC granular:
   funcion canonica, no AGR
 end note

 @enduml

8.2 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_ACC_01 — flujo principal

 @startuml

 actor Invoker as I
 participant "Frontend" as FE
 participant "AssignFunctionsView" as AV
 participant "AccessService" as AS
 participant "SoDValidator" as SV
 participant "PermissionCache" as PC
 participant "AuditLog" as AL
 database "Repo" as DB

 I -> FE: Selecciona funciones + expires_at
 FE -> AV: POST /api/users/{id}/functions/

 AV -> AV: Validar JWT (CNST-009)
 AV -> AV: Verificar assign_functions
 alt Sin la funcion
   AV --> FE: 403 FORBIDDEN
   AV -> AL: emit UNAUTHORIZED_ACCESS_ATTEMPT
 else Con la funcion
   AV -> AS: assign(target_id, function_ids,\n  expires_at, invoker)

   AS -> DB: SELECT User FOR UPDATE
   alt User no existe / estado invalido
     AS --> AV: error
     AV --> FE: 404 / 400
   else User valido
     AS -> AS: validar P-11 (no self-assign)

     AS -> DB: SELECT Function WHERE id IN (...)
     alt Alguna no existe / inactiva
       AS --> AV: error
       AV --> FE: 400
     else Funciones validas
       AS -> DB: SELECT Assignment activos del User
       AS -> AS: separar new_ids vs already_ids
       alt new_ids vacio (FA-01)
         AS -> AL: emit FUNCTIONS_ASSIGN_NOOP
         AV --> FE: 200 OK informativo
       else hay funciones nuevas
         AS -> SV: validate(target,\n  current_functions ∪ new_function_ids)
         SV -> DB: SELECT SoDRule WHERE state='ACTIVE'
         alt SoD viola
           SV --> AS: SoDViolation(rule_id, pair)
           AS -> AL: emit FUNCTIONS_ASSIGN_FAILED\n  {reason:'sod_violation'}
           AV --> FE: 409 SOD_VIOLATION
         else SoD OK
           group Transaccion atomica
             AS -> DB: INSERT Assignment (N filas)
             AS -> AL: emit FUNCTIONS_ASSIGNED
             opt notify activo
               AS -> DB: INSERT InternalMessage
             end
           end
           AS -> PC: invalidate(target.id)\n  (post-COMMIT)
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
 :caption: UC_ACC_01 — actividad

 @startuml

 start

 :POST /api/users/{id}/functions/;

 if (JWT valido?) then (no)
   :401 INVALID_TOKEN; stop
 else (si)
 endif

 if (Tiene assign_functions?) then (no)
   :403 FORBIDDEN;
   :Audit UNAUTHORIZED_ACCESS_ATTEMPT;
   stop
 else (si)
 endif

 if (Payload valido?) then (no)
   :400 VALIDATION_ERROR; stop
 else (si)
 endif

 if (User existe?) then (no)
   :404 USER_NOT_FOUND; stop
 else (si)
 endif

 if (User state válido?) then (no)
   :400 INVALID_USER_STATE; stop
 else (si)
 endif

 if (P-11 viola — auto-asignacion?) then (si)
   :400 SELF_ASSIGN_FORBIDDEN;
   :Audit ALERTA;
   stop
 else (no)
 endif

 if (Todas las funciones existen y ACTIVE?) then (no)
   :400 FUNCTION_NOT_FOUND/INACTIVE; stop
 else (si)
 endif

 :Filtrar funciones ya asignadas;

 if (Quedan funciones nuevas?) then (no — FA-01)
   :Audit FUNCTIONS_ASSIGN_NOOP;
   :200 OK informativo;
   stop
 else (si)
 endif

 :Construir effective_function_set
  (actuales + nuevas);
 :Evaluar SoDRules ACTIVE contra set;

 if (SoD violada?) then (si — EX-08)
   :409 SOD_VIOLATION
    + rule_id + conflict_pair;
   :Audit FUNCTIONS_ASSIGN_FAILED ALERTA;
   stop
 else (no)
 endif

 partition "Transaccion atomica" {
   :INSERT Assignment (N filas);
   :INSERT AuditEvent FUNCTIONS_ASSIGNED;
   if (politica notify?) then (si)
     :INSERT InternalMessage;
   else (no)
   endif
 }

 if (Transaccion OK?) then (no)
   :ROLLBACK; :500/503;
   stop
 else (si)
 endif

 :PermissionCache.invalidate(target.id)
  (post-COMMIT);
 :201 Created con assigned + skipped;
 :Frontend toast resumen;

 stop

 @enduml

8.4 Diagrama de estados — Assignment
====================================

.. uml::
 :caption: Maquina de estados de un Assignment

 @startuml

 [*] --> ACTIVE : UC_ACC_01\n(asignacion)

 ACTIVE --> REVOKED : UC_ACC_02\n(revocacion explicita)
 ACTIVE --> REVOKED : UC_USR_04\n(eliminacion del User)
 ACTIVE --> EXPIRED : cron job\n(NOW() > expires_at)
 ACTIVE --> ACTIVE : UC_ACC_01 idempotente\n(no cambia)

 REVOKED --> [*]
 EXPIRED --> [*]

 note right of ACTIVE
   UNIQUE (user, function, ACTIVE)
   impide duplicados
 end note

 note right of REVOKED
   Preservado como historial.
   Re-asignacion crea NUEVO Assignment
   (no reactiva — FA-06)
 end note

 @enduml

8.5 Diagrama de SoD validation
==============================

.. uml::
 :caption: Logica de validacion SoD (PASO 10)

 @startuml

 start

 :Recibir new_function_ids
  + current_function_ids del User;

 :effective_set =
  current_function_ids ∪ new_function_ids;

 :SELECT SoDRule WHERE state='ACTIVE';

 repeat
   :tomar siguiente rule;
   :rule define {function_a, function_b}
    o relacion compleja;
   if (rule violada por effective_set?) then (si)
     :raise SoDViolation
      (rule_id, conflict_pair);
     stop
   else (no)
   endif
 repeat while (mas rules?) is (si) not (no)

 :return OK (set permitido);
 stop

 @enduml

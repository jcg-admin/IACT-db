.. _uc-perm-05-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_PERM_05 — gestion catalogo AGR

 @startuml
 left to right direction

 actor "User con funcion\nmanage_access_groups" as MGR
 actor "Auditor" as AUD

 rectangle "MOD_Permissions" {
   usecase "UC_PERM_05\nCreate AGR" as UCCRE
   usecase "UC_PERM_05\nModify AGR" as UCMOD
   usecase "UC_PERM_05\nRetire AGR" as UCRET
   usecase "AuditEvent" as EMI
 }

 MGR --> UCCRE
 MGR --> UCMOD
 MGR --> UCRET
 UCCRE ..> EMI : <<include>>
 UCMOD ..> EMI : <<include>>
 UCRET ..> EMI : <<include>>
 EMI --> AUD

 @enduml

8.2 Diagrama de actividad
=========================

.. uml::
 :caption: UC_PERM_05 — actividad CRUD

 @startuml

 start

 :Operacion CRUD recibida;

 if (JWT valido?) then (no)
   :401; stop
 else (si)
 endif

 if (manage_access_groups?) then (no)
   :403; :Audit UNAUTHORIZED;
   stop
 else (si)
 endif

 if (Operacion?) then (CREATE)
   if (code formato + unique?) then (no)
     :400 / 409; stop
   else (si)
   endif
   :INSERT AccessGroup;
   :Audit ACCESS_GROUP_CREATED;
 else (PATCH / DELETE)
   if (AGR existe + ACTIVE + custom?) then (no)
     :404 / 400; stop
   else (si)
   endif
   if (PATCH?) then (si)
     if (incluye code?) then (si)
       :400 CODE_IMMUTABLE; stop
     else (no)
     endif
     :UPDATE atributos descriptivos;
     :Audit ACCESS_GROUP_MODIFIED;
   else (DELETE)
     if (retire_reason ≥ 20?) then (no)
       :400 VALIDATION; stop
     else (si)
     endif
     :Calcular users_with_agr_count;
     if (count > 0 y politica strict?) then (si)
       :409 RETIRE_HAS_USERS; stop
     else (no)
     endif
     :UPDATE state=RETIRED;
     :Audit ACCESS_GROUP_RETIRED;
   endif
 endif

 :Cache invalidate post-COMMIT;
 :200 / 201;

 stop

 @enduml

8.3 Estados AccessGroup
=======================

.. uml::
 :caption: Maquina de estados

 @startuml

 [*] --> ACTIVE : UC_PERM_05 CREATE\n(o predefinido seed)
 ACTIVE --> ACTIVE : UC_PERM_05 PATCH
 ACTIVE --> RETIRED : UC_PERM_05 DELETE
 RETIRED --> [*]

 note right of RETIRED
   No vuelve a ACTIVE
   Migracion: nuevo CREATE
 end note

 @enduml

8.4 Diagrama de clases
======================

.. uml::
 :caption: AccessGroup + relaciones

 @startuml

 class AccessGroup {
   id, code, display_name, description,
   severity, is_predefined, state,
   created_at, retired_at...
 }

 class AccessGroupFunction {
   access_group_id, function_id
 }

 class Function {
   id, code, display_name, state
 }

 class Assignment {
   user_id, target_type, target_id
 }

 AccessGroup "1" -- "*" AccessGroupFunction
 AccessGroupFunction "*" -- "1" Function
 AccessGroup "1" -- "*" Assignment

 note right of AccessGroupFunction
   UC_PERM_06 maneja esta tabla
   (composicion del AGR)
 end note

 @enduml

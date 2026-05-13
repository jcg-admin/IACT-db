.. _uc-perm-07-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_PERM_07 — verificar permiso

 @startuml
 left to right direction

 actor "Decorator/Middleware" as DEC
 actor "User con funcion\nview_assignments" as ADMIN
 actor "UC_PERM_08" as MENU

 rectangle "MOD_Permissions (servicio)" {
   usecase "UC_PERM_07\nVerificar Permiso" as UC07
   usecase "Bulk check" as BULK
   usecase "Cache lookup" as CACHE
   usecase "Algoritmo precedencia" as ALG
 }

 DEC --> UC07
 ADMIN --> UC07
 MENU --> BULK
 UC07 ..> CACHE : <<include>>
 UC07 ..> ALG : <<include>>
 BULK ..> CACHE : <<include>>
 BULK ..> ALG : <<include>>

 note bottom of UC07
   Read-only. Sin audit por invocacion.
   Fail-closed ante errores.
 end note

 @enduml

8.2 Diagrama de actividad
=========================

.. uml::
 :caption: UC_PERM_07 — algoritmo

 @startuml

 start

 :Recibir (user_id, function_code);

 if (Cache hit?) then (si)
   :return cached;
   stop
 else (no)
 endif

 if (Revocacion excepcional ACTIVA?) then (si)
   :origin=REVOKED_EXCEPTIONAL
    allowed=false;
 else (no)
   if (Concesion excepcional ACTIVA?) then (si)
     :origin=GRANTED_EXCEPTIONAL
      allowed=true;
   else (no)
     if (AGR ACTIVE con funcion?) then (si)
       :origin=GRANTED_BY_AGR
        allowed=true;
     else (no)
       :origin=DENIED_NO_GRANT
        allowed=false;
     endif
   endif
 endif

 :Cache write con TTL ajustado;
 :return result;

 stop

 @enduml

8.3 Diagrama de clases (algoritmo)
==================================

.. uml::
 :caption: Estructura del servicio

 @startuml

 class PermissionService {
   check(user_id, function_code, ctx)
   check_bulk(user_id, codes, ctx)
 }

 class PermissionCache {
   get(key)
   set(key, value, ttl)
   invalidate(user_id)
 }

 class ExceptionalPermissionRepo {
   find_active_revoke(user, fn)
   find_active_grant(user, fn)
 }

 class AssignmentRepo {
   find_active_agrs_with_function(
     user, fn)
 }

 PermissionService --> PermissionCache
 PermissionService --> ExceptionalPermissionRepo
 PermissionService --> AssignmentRepo

 note right of PermissionService
   Funcion pura: dado el set de datos
   leidos, el resultado es deterministico.
 end note

 @enduml

8.4 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_PERM_07 — flujo cache miss

 @startuml

 participant "Caller" as C
 participant "PermService" as PS
 participant "PermCache" as PC
 database "Repos" as DB

 C -> PS: check(user_id, function_code)
 PS -> PC: get(key)
 PC --> PS: miss

 PS -> DB: query agregada
 DB --> PS: revoked? grant? agr_codes
 PS -> PS: aplicar precedencia
 PS -> PC: set(key, result, ttl)
 PS --> C: result

 note right of PS
   Sin audit por invocacion.
   Fail-closed ante BD timeout.
 end note

 @enduml

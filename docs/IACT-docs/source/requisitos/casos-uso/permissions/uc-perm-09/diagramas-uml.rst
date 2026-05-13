.. _uc-perm-09-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_PERM_09 — auditar acceso

 @startuml
 left to right direction

 actor "UC invocante\n(UC_AUTH/USR/ACC/PERM)" as CALLER
 actor "AlertEngine" as AE
 actor "AuditTable\n(append-only)" as DB

 rectangle "MOD_Permissions / Audit" {
   usecase "UC_PERM_09\nAuditar Acceso" as UC09
   usecase "PII Scan" as PII
   usecase "Sanitizar" as SAN
   usecase "INSERT en tx caller" as INS
   usecase "Push alert post-COMMIT" as ALT
 }

 CALLER --> UC09
 UC09 ..> PII : <<include>>
 UC09 ..> SAN : <<include>>
 UC09 ..> INS : <<include>>
 UC09 ..> ALT : <<extend>>
 INS --> DB
 ALT --> AE

 note bottom of UC09
   P-09 audit-or-abort:
   si emit falla, caller hace rollback.
 end note

 @enduml

8.2 Diagrama de actividad
=========================

.. uml::
 :caption: UC_PERM_09 — emit

 @startuml

 start

 :Caller invoca con event_type, payload, ctx;

 if (Validacion estructural?) then (no)
   :AuditValidationError; stop
 else (si)
 endif

 if (PII detectado?) then (si)
   :AuditPIIDetected; stop
 else (no)
 endif

 :Sanitizar (hash de PII si requerido);
 :Construir AuditEvent con UUID v7;
 :INSERT en transaccion del caller;

 if (INSERT ok?) then (no)
   :AuditWriteFailed;
   :Caller hace ROLLBACK;
   stop
 else (si)
 endif

 if (event_type CRITICAL?) then (si)
   :Replicar a log secundario sincrono;
 else (no)
 endif

 :Caller COMMIT;
 :AlertEngine push (best-effort);
 :Retornar id al caller;

 stop

 @enduml

8.3 Diagrama de clases
======================

.. uml::
 :caption: Estructura del servicio

 @startuml

 class AuditService {
   emit(event)
   emit_batch(events)
 }

 class AuditValidator {
   validate(event)
 }

 class PIIScanner {
   scan(payload)
 }

 class Sanitizer {
   sanitize(payload)
 }

 class AuditRepo {
   insert(event)
   insert_batch(events)
 }

 class AlertHook {
   on_commit(event)
 }

 AuditService --> AuditValidator
 AuditService --> PIIScanner
 AuditService --> Sanitizer
 AuditService --> AuditRepo
 AuditService --> AlertHook

 note right of AuditRepo
   Tabla append-only.
   CONSTRAINT prohibe UPDATE/DELETE.
 end note

 @enduml

8.4 Diagrama de secuencia (P-09)
================================

.. uml::
 :caption: UC_PERM_09 — audit-or-abort

 @startuml

 participant "Caller UC" as C
 participant "TxManager" as TM
 participant "AuditService" as AS
 participant "AuditRepo" as AR
 participant "AlertHook" as AH

 C -> TM: BEGIN
 TM --> C: tx
 C -> AS: emit(event, ctx)
 AS -> AS: validate + PII scan + sanitize
 AS -> AR: INSERT (in tx)
 AR --> AS: id
 AS --> C: id
 C -> TM: COMMIT
 TM --> C: ok
 TM -> AH: on_commit(event)
 AH -> AH: push to AlertEngine

 note over C, AR
   Si AS o AR fallan, C hace ROLLBACK.
   La operacion principal no avanza.
 end note

 @enduml

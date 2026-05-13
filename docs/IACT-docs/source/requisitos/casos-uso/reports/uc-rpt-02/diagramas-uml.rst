.. _uc-rpt-02-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Diagrama de caso de uso
===========================

.. uml::
 :caption: UC_RPT_02 — realtime

 @startuml
 left to right direction

 actor "User con funcion\nview_realtime_metrics" as USR
 actor "AnalyticsStream" as AS

 rectangle "MOD_Reports" {
   usecase "UC_RPT_02\nRealtime Metrics" as UC02
   usecase "Suscribir stream" as SUB
   usecase "Throttle" as TH
   usecase "Heartbeat" as HB
 }

 USR --> UC02
 UC02 ..> SUB : <<include>>
 UC02 ..> TH : <<include>>
 UC02 ..> HB : <<include>>
 SUB --> AS

 note bottom
   Stream push via SSE / WS / poll.
   Reconnect via Last-Event-ID.
 end note

 @enduml

8.2 Diagrama de actividad
=========================

.. uml::
 :caption: UC_RPT_02 — flujo

 @startuml

 start
 :Frontend abre conexion stream;
 if (JWT?) then (no)
   :401; stop
 endif
 if (view_realtime_metrics?) then (no)
   :403 + audit; stop
 endif
 if (Sin segmento?) then (si)
   :400; stop
 endif
 :Suscribir a AnalyticsStream
  con filtro segmento;
 :Audit REALTIME_STREAM_OPENED;

 while (Conexion abierta?)
   if (Evento del stream?) then (si)
     :Construir snapshot;
     :Throttle 1/5s;
     :Emit event: metrics;
   else (no)
     if (>= 30s sin data?) then (si)
       :Emit event: heartbeat;
     endif
   endif
 endwhile

 :Audit REALTIME_STREAM_CLOSED;
 :Limpieza;
 stop

 @enduml

8.3 Diagrama de secuencia
=========================

.. uml::
 :caption: UC_RPT_02 — SSE

 @startuml

 actor "User" as U
 participant "Frontend" as FE
 participant "StreamGateway" as SG
 participant "Subscriber" as SUB
 queue "AnalyticsStream" as ST
 participant "AuditService" as AU

 U -> FE: abrir vista realtime
 FE -> SG: GET /realtime (SSE)
 SG -> SG: JWT + RBAC + segmento
 SG -> AU: emit STREAM_OPENED
 SG -> SUB: subscribe(segments)
 SUB -> ST: subscribe(topics)

 loop hasta cierre
   ST -> SUB: event
   SUB -> SG: snapshot (throttled)
   SG -> FE: data: {...}
 end

 U -> FE: cerrar
 FE -> SG: close
 SG -> SUB: unsubscribe
 SG -> AU: emit STREAM_CLOSED

 @enduml

8.4 Diagrama de estado
======================

.. uml::
 :caption: Estado de conexion

 @startuml
 [*] --> Handshake
 Handshake --> Authorized : ok
 Handshake --> Closed : 401/403
 Authorized --> Streaming : suscrito
 Streaming --> Streaming : event / heartbeat
 Streaming --> Reconnecting : red caida
 Reconnecting --> Streaming : recuperado
 Reconnecting --> Closed : timeout
 Streaming --> Closed : user close
 Closed --> [*]
 @enduml

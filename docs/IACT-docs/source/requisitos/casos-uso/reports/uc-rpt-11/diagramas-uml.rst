.. _uc-rpt-11-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Owner User con funcion\nshare_reports" as O
 actor "Receptor User" as R
 actor "MailboxService" as MB

 rectangle "MOD_Reports" {
   usecase "UC_RPT_11\nCompartir" as UC11
   usecase "Aplicar share" as APP
   usecase "Mailbox notify" as N
 }

 O --> UC11
 UC11 ..> N : <<include>>
 N --> MB
 R --> APP
 APP ..> UC11 : <<extend>>
 @enduml

8.2 Actividad (compartir)
=========================

.. uml::

 @startuml
 start
 :POST share;
 if (JWT?) then (no)
   :401; stop
 endif
 if (share_reports?) then (no)
   :403; stop
 endif
 :Validar view + owner + target;
 if (Owner != invoker?) then (si)
   :403; stop
 endif
 if (expires_at en pasado?) then (si)
   :400; stop
 endif
 :INSERT ShareEntry;
 :Audit REPORT_SHARED;
 :Mailbox notify (si receptor permite);
 :201;
 stop
 @enduml

8.3 Actividad (aplicar)
=======================

.. uml::

 @startuml
 start
 :GET con view_id;
 :Cargar SavedView;
 if (Owner == invoker?) then (si)
   :Aplicar (segmento del invoker);
 else (no)
   :Buscar ShareEntry activo;
   if (Encontrado?) then (no)
     :403; stop
   endif
   if (Expirado?) then (si)
     :403 SHARE_EXPIRED; stop
   endif
   :Aplicar (segmento del invoker);
 endif
 stop
 @enduml

8.4 Estado del share
====================

.. uml::

 @startuml
 [*] --> active : crear
 active --> revoked : DELETE
 active --> expired : expires_at
 active --> orphan : view borrada (cascade)
 revoked --> [*]
 expired --> [*]
 orphan --> [*]
 @enduml

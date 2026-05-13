.. _uc-cli-05-parte-08:

==========================
Parte 8 — Diagramas UML
==========================

8.1 Caso de uso
===============

.. uml::

 @startuml
 left to right direction
 actor "Caller" as C
 rectangle "MOD_Caller" {
   usecase "UC_CLI_05\nCSAT" as UC
 }
 C --> UC
 @enduml

8.2 Actividad
=============

.. uml::

 @startuml
 start
 :Agente cuelga;
 if (Survey ofrecido?) then (no)
   :Hangup; stop
 endif
 :Reproducir prompt;
 repeat
   :Pregunta;
   :Esperar DTMF;
   if (Respuesta o skip?) then (skip)
     :Marcar skip;
   endif
 repeat while (mas preguntas)
 :INSERT SurveyResponse;
 :Mensaje agradecimiento;
 :Hangup;
 stop
 @enduml

8.3 Componentes
===============

.. uml::

 @startuml
 component "SurveyRunner" as SR
 component "DTMFCollector" as D
 component "ResponseRepo" as R
 SR --> D
 SR --> R
 @enduml

8.4 Secuencia
=============

.. uml::

 @startuml
 actor "Caller" as C
 participant "Survey" as S
 database "Repo" as R
 S -> C: prompt
 C -> S: DTMF
 S -> C: pregunta 2
 C -> S: DTMF
 S -> R: INSERT
 S -> C: gracias + hangup
 @enduml

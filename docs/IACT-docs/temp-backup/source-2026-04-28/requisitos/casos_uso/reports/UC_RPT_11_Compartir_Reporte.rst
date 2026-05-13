.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_11
   :normativa: CNST-001, CNST-004, CNST-009

============================
UC_RPT_11: Compartir Reporte
============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_11
   * - **Nombre**
     - Compartir Reporte
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-011: comparte_reportes
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-RPT-011

2. Descripcion
--------------

Permite compartir un reporte generado con otros usuarios del mismo
segmento. La notificacion se envia via InternalMessage (CNST-001).

**Restriccion CNST-001:** Notificaciones SOLO via InternalMessage.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_11

   @startuml
   left to right direction
   actor "AGR-003\nagr_supervisor" as USER
   rectangle "MOD_Reports" {
     usecase "UC_RPT_11\nCompartir Reporte" as UC11
     usecase "Notificar via\nInternalMessage" as NOT
   }
   USER --> UC11
   UC11 --> NOT : include
   @enduml

4. Contexto de Ejecucion
------------------------

4.1 Precondiciones
^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Precondicion
   * - PRE-01
     - Usuario tiene funcion RPT-011
   * - PRE-02
     - Existe un reporte para compartir
   * - PRE-03
     - Destinatarios del mismo segmento

4.2 Trigger
^^^^^^^^^^^

Usuario hace clic en Compartir desde un reporte.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Reporte compartido con destinatarios
   * - POST-02
     - Notificacion enviada via InternalMessage

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Usuario
     - Hace clic en Compartir
   * - 2
     - Sistema
     - Valida RPT-011
   * - 3
     - Sistema
     - Muestra usuarios del segmento
   * - 4
     - Usuario
     - Selecciona destinatarios
   * - 5
     - Usuario
     - Opcionalmente agrega mensaje
   * - 6
     - Sistema
     - Valida destinatarios del segmento
   * - 7
     - Sistema
     - Envia notificacion via InternalMessage
   * - 8
     - Sistema
     - Registra en auditoria

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_11

   @startuml
   actor "Usuario" as U
   participant "Frontend" as FE
   participant "ShareController" as SC
   participant "ShareService" as SS
   participant "InternalMessage" as IM
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   U -> FE: Compartir reporte
   FE -> SC: POST /api/reports/share
   SC -> SC: verify_function(RPT-011)
   SC -> SS: share_report(report, destinatarios)
   SS -> SS: validate_same_segment()
   note right: CNST-004
   SS -> IM: notify(destinatarios, report_link)
   note right: CNST-001
   SS -> UAL: record(REPORT_SHARE)
   note right: CNST-009
   UAL -> DB: INSERT audit
   SS --> SC: shared
   SC --> FE: 200 OK
   FE --> U: Reporte compartido
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Compartir con Mensaje
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Usuario
     - Ingresa mensaje personalizado
   * - 7a
     - Sistema
     - Incluye mensaje en notificacion

8. Excepciones
--------------

8.1 EX-01: Destinatario Otro Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Condicion**
     - Destinatario de segmento diferente
   * - **Mensaje**
     - Solo puede compartir con usuarios del mismo segmento
   * - **Codigo Error**
     - RPT-100

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_11

   @startuml
   start
   if (Tiene RPT-011?) then (no)
     stop
   else (si)
   endif
   :Seleccionar destinatarios;
   if (Mismo segmento?) then (no)
     :Error segmento;
     stop
   else (si)
   endif
   :Enviar via InternalMessage;
   note right: CNST-001
   :Registrar auditoria;
   stop
   @enduml

10. Reglas de Negocio
---------------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - ID
     - Regla
     - Descripcion
   * - BR-RPT-100
     - Mismo Segmento
     - Solo usuarios del mismo segmento
   * - BR-RPT-101
     - Notificacion
     - Via InternalMessage unicamente

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion
   * - CNST-001
     - Comunicacion Interna
     - Solo InternalMessage
   * - CNST-004
     - Segmentos
     - Mismo segmento
   * - CNST-009
     - Auditoria
     - Registro REPORT_SHARE

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-100
     - Compartir reportes
     - Notificacion enviada
   * - FR-RPT-101
     - Validar segmento
     - Solo mismo segmento

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-011
   * - **Restricciones**
     - CNST-001, CNST-004, CNST-009
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Funcion RBAC**
     - RPT-011: comparte_reportes

14. Historial de Cambios
------------------------

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 4.0.0
     - 2026-01-06
     - Version inicial v4.0
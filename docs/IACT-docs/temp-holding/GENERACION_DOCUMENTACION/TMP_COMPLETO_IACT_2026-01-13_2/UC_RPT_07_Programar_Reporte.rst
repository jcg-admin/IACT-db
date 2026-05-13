.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_07
   :normativa: CNST-001, CNST-004, CNST-009

==================================================
UC_RPT_07: Programar Reporte
==================================================

.. contents:: Contenido
   :depth: 3
   :local:

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_07
   * - **Nombre**
     - Programar Reporte
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-007: programa_reportes
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Alta
   * - **BReq Origen**
     - BRQ-RPT-007

2. Descripcion
--------------

Permite programar la generacion automatica de reportes en horarios
definidos. Notificacion via InternalMessage (CNST-001).

**Restriccion CNST-001:** Notificaciones SOLO via InternalMessage.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_07

   @startuml
   left to right direction
   actor "AGR-003\nagr_supervisor" as USER
   actor "Scheduler" as SYS
   rectangle "MOD_Reports" {
     usecase "UC_RPT_07\nProgramar Reporte" as UC07
     usecase "Ejecutar\nProgramado" as EXEC
   }
   USER --> UC07
   SYS --> EXEC
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
     - Usuario tiene funcion RPT-007
   * - PRE-02
     - Destinatarios del mismo segmento

4.2 Trigger
^^^^^^^^^^^

Usuario accede a programacion de reportes.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Programacion activa registrada
   * - POST-02
     - Auditoria SCHEDULE_CREATE

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
     - Accede a programacion
   * - 2
     - Sistema
     - Valida RPT-007
   * - 3
     - Usuario
     - Selecciona reporte
   * - 4
     - Usuario
     - Define frecuencia y hora
   * - 5
     - Usuario
     - Selecciona destinatarios
   * - 6
     - Sistema
     - Valida destinatarios del segmento
   * - 7
     - Sistema
     - Crea programacion
   * - 8
     - Sistema
     - Registra en auditoria

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_07

   @startuml
   actor "Usuario" as U
   participant "Frontend" as FE
   participant "ScheduleController" as SC
   participant "ScheduleService" as SS
   participant "InternalMessage" as IM
   database "Analytics" as DB
   
   U -> FE: Programar reporte
   FE -> SC: POST /api/reports/schedules
   SC -> SC: verify_function(RPT-007)
   SC -> SS: create_schedule(config)
   SS -> DB: INSERT schedule
   SS -> DB: INSERT audit
   SC --> FE: 201 Created
   
   ... Ejecucion Programada ...
   
   SS -> SS: generate_report()
   SS -> IM: notify(destinatarios)
   note right: CNST-001
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Modificar Programacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 3a
     - Usuario
     - Selecciona programacion existente
   * - 7a
     - Sistema
     - Actualiza programacion

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
     - Destinatarios deben ser del mismo segmento
   * - **Codigo Error**
     - RPT-060

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_07

   @startuml
   start
   if (Tiene RPT-007?) then (no)
     stop
   else (si)
   endif
   :Seleccionar reporte;
   :Definir frecuencia;
   :Seleccionar destinatarios;
   if (Mismo segmento?) then (no)
     :Error segmento;
     stop
   else (si)
   endif
   :Crear programacion;
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
   * - BR-RPT-60
     - Frecuencias
     - Diario, semanal, mensual
   * - BR-RPT-61
     - Notificacion
     - Solo via InternalMessage (CNST-001)
   * - BR-RPT-62
     - Segmento
     - Destinatarios del mismo segmento

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
     - Notificacion SOLO via InternalMessage
   * - CNST-004
     - Segmentos
     - Destinatarios del segmento
   * - CNST-009
     - Auditoria
     - Registro de programaciones

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-060
     - Programar reportes
     - Frecuencias configurables
   * - FR-RPT-061
     - Notificar destinatarios
     - Via InternalMessage

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-007
   * - **Restricciones**
     - CNST-001, CNST-004, CNST-009
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Funcion RBAC**
     - RPT-007: programa_reportes

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

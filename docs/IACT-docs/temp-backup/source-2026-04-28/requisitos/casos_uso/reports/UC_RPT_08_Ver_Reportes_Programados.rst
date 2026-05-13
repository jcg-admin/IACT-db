.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_08
   :normativa: CNST-004

===================================
UC_RPT_08: Ver Reportes Programados
===================================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_08
   * - **Nombre**
     - Ver Reportes Programados
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-008: ve_programados
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Baja
   * - **BReq Origen**
     - BRQ-RPT-008

2. Descripcion
--------------

Permite consultar las programaciones de reportes activas, su estado,
proxima ejecucion y historial de ejecuciones anteriores.

**Caracteristicas principales:**

- Listar programaciones activas
- Ver estado de cada programacion
- Ver proxima ejecucion programada
- Ver historial de ejecuciones
- Filtrado por segmento (CNST-004)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_08

   @startuml
   left to right direction
   actor "AGR-003\nagr_supervisor" as USER
   rectangle "MOD_Reports" {
     usecase "UC_RPT_08\nVer Programados" as UC08
     usecase "Ver Historial" as HIST
   }
   USER --> UC08
   UC08 --> HIST : extend
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
     - Usuario tiene funcion RPT-008

4.2 Trigger
^^^^^^^^^^^

Usuario accede a reportes programados.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra lista de programaciones

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
     - Accede a reportes programados
   * - 2
     - Sistema
     - Valida RPT-008
   * - 3
     - Sistema
     - Consulta programaciones del segmento
   * - 4
     - Sistema
     - Muestra lista con estado y proxima ejecucion
   * - 5
     - Usuario
     - Selecciona programacion para ver detalle

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_08

   @startuml
   actor "Usuario" as U
   participant "Frontend" as FE
   participant "ScheduleController" as SC
   participant "ScheduleService" as SS
   database "Analytics" as DB

   U -> FE: Accede a Programados
   FE -> SC: GET /api/reports/schedules
   SC -> SC: verify_function(RPT-008)
   SC -> SS: get_schedules(segmento)
   SS -> DB: SELECT * FROM report_schedules\nWHERE segmento_id = ?
   DB --> SS: schedules
   SS --> SC: schedules
   SC --> FE: 200 OK
   FE --> U: Lista de programaciones

   U -> FE: Ver historial
   FE -> SC: GET /api/reports/schedules/{id}/history
   SC -> SS: get_execution_history(id)
   SS -> DB: SELECT * FROM schedule_executions
   DB --> SS: history
   SS --> SC: history
   SC --> FE: 200 OK
   FE --> U: Historial de ejecuciones
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Ver Historial de Ejecucion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Usuario
     - Hace clic en Ver Historial
   * - 5b
     - Sistema
     - Muestra ejecuciones anteriores con estado

8. Excepciones
--------------

8.1 EX-01: Sin Programaciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Condicion**
     - No hay programaciones para el segmento
   * - **Mensaje**
     - No hay reportes programados

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_08

   @startuml
   start
   if (Tiene RPT-008?) then (no)
     stop
   else (si)
   endif
   :Consultar programaciones del segmento;
   if (Hay programaciones?) then (no)
     :Mostrar Sin programaciones;
   else (si)
     :Mostrar lista;
   endif
   if (Ver historial?) then (si)
     :Mostrar ejecuciones anteriores;
   endif
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
   * - BR-RPT-70
     - Por Segmento
     - Solo programaciones del segmento del usuario
   * - BR-RPT-71
     - Historial
     - Se conservan ultimas 30 ejecuciones

**Estados de Programacion:**

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - Estado
     - Descripcion
   * - ACTIVE
     - Programacion activa, se ejecutara
   * - PAUSED
     - Pausada temporalmente
   * - DISABLED
     - Deshabilitada

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion
   * - CNST-004
     - Segmentos
     - Solo programaciones del segmento

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-070
     - Listar programaciones
     - Lista con estado y proxima ejecucion
   * - FR-RPT-071
     - Ver historial
     - Ultimas 30 ejecuciones

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-008
   * - **Restricciones**
     - CNST-004
   * - **UC Relacionados**
     - UC_RPT_07
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Funcion RBAC**
     - RPT-008: ve_programados

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

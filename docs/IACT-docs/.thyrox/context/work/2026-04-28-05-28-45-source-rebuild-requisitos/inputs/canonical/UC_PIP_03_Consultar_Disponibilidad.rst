.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Pipeline
   :uc_id: UC_PIP_03
   :normativa: CNST-003

===================================
UC_PIP_03: Consultar Disponibilidad
===================================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_PIP_03
   * - **Nombre**
     - Consultar Disponibilidad
   * - **Actor Principal**
     - AGR-009: agr_admin_pipeline
   * - **Modulo**
     - MOD_Pipeline
   * - **Funcion RBAC**
     - PIP-003: ve_disponibilidad_datos
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Baja
   * - **BReq Origen**
     - BRQ-PIP-003

2. Descripcion
--------------

Este caso de uso permite consultar la disponibilidad de datos por periodo,
mostrando que fechas tienen datos sincronizados y cuales tienen gaps o
datos faltantes.

**Caracteristicas principales:**

- Ver calendario de disponibilidad de datos
- Identificar gaps (fechas sin datos)
- Ver volumen de datos por fecha
- Comparar datos IVR vs Analytics
- Detectar inconsistencias

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_PIP_03

   @startuml
   left to right direction
   actor "AGR-009\nagr_admin_pipeline" as ADMIN

   rectangle "MOD_Pipeline" {
     usecase "UC_PIP_03\nConsultar Disponibilidad" as UC03
     usecase "Ver Calendario" as CAL
     usecase "Detectar Gaps" as GAPS
     usecase "Ver Volumenes" as VOL
   }

   ADMIN --> UC03
   UC03 --> CAL : include
   UC03 --> GAPS : include
   UC03 --> VOL : extend
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
     - El administrador tiene sesion activa con funcion PIP-003
   * - PRE-02
     - Existen datos en la tabla de disponibilidad

4.2 Trigger
^^^^^^^^^^^

El administrador accede al modulo de disponibilidad de datos.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra el calendario de disponibilidad
   * - POST-02
     - Se identifican gaps si existen

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Admin
     - Accede a disponibilidad de datos
   * - 2
     - Sistema
     - Valida funcion PIP-003
   * - 3
     - Sistema
     - Consulta tabla de disponibilidad
   * - 4
     - Sistema
     - Genera calendario visual del mes actual
   * - 5
     - Sistema
     - Marca fechas con datos completos (verde)
   * - 6
     - Sistema
     - Marca fechas con gaps (rojo)
   * - 7
     - Sistema
     - Marca fechas parciales (amarillo)
   * - 8
     - Admin
     - Navega entre meses
   * - 9
     - Admin
     - Selecciona fecha para ver detalle

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_PIP_03

   @startuml
   actor "AGR-009 Admin" as A
   participant "Frontend" as FE
   participant "PipelineController" as PC
   participant "DataAvailabilityService" as DAS
   database "Analytics" as ADB
   database "IVR\n(readonly)" as IVR

   A -> FE: Accede a Disponibilidad
   FE -> PC: GET /api/pipeline/availability?month=2026-01
   PC -> PC: verify_function(PIP-003)

   PC -> DAS: get_availability(month)

   DAS -> ADB: SELECT fecha, count_records\nFROM data_availability\nWHERE fecha BETWEEN ? AND ?
   ADB --> DAS: analytics_data

   note right of IVR
     CNST-003: Solo lectura
     Comparacion programada,
     no en tiempo real
   end note

   DAS -> DAS: detect_gaps(analytics_data)
   DAS -> DAS: calculate_coverage()

   DAS --> PC: availability_calendar
   PC --> FE: 200 OK
   FE --> A: Calendario visual

   A -> FE: Click en fecha
   FE -> PC: GET /api/pipeline/availability/{date}
   PC -> DAS: get_date_detail(date)
   DAS -> ADB: SELECT * FROM data_availability\nWHERE fecha = ?
   DAS --> PC: date_detail
   PC --> FE: 200 OK
   FE --> A: Detalle de fecha
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Gaps Detectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Sistema
     - Detecta fechas sin datos
   * - 6b
     - Sistema
     - Muestra alerta con lista de gaps
   * - 6c
     - Sistema
     - Ofrece enlace a UC_PIP_04 para solicitar reintento

7.2 FA-02: Ver Detalle de Fecha
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 9a
     - Admin
     - Hace clic en una fecha
   * - 9b
     - Sistema
     - Muestra: registros procesados, hora de carga, fuente

8. Excepciones
--------------

8.1 EX-01: Sin Permiso PIP-003
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Usuario no tiene funcion PIP-003
   * - **Accion Sistema**
     - Rechaza acceso
   * - **Mensaje Usuario**
     - No tiene permisos para ver disponibilidad
   * - **Codigo Error**
     - PIP-020

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_PIP_03

   @startuml
   start
   :Admin accede a Disponibilidad;
   if (Tiene PIP-003?) then (no)
     :Error permisos;
     stop
   else (si)
   endif
   :Consultar datos de disponibilidad;
   :Generar calendario visual;
   :Marcar fechas segun estado;
   note right
     Verde: completo
     Amarillo: parcial
     Rojo: gap
   end note
   if (Hay gaps?) then (si)
     :Mostrar alerta de gaps;
   endif
   if (Ver detalle fecha?) then (si)
     :Mostrar detalle de fecha;
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
   * - BR-PIP-20
     - Completitud
     - Una fecha se considera completa si tiene 100% de registros esperados
   * - BR-PIP-21
     - Gap
     - Un gap es una fecha sin ningun registro sincronizado
   * - BR-PIP-22
     - Parcial
     - Una fecha parcial tiene entre 1% y 99% de registros esperados

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-003
     - BD Dual
     - La disponibilidad se calcula comparando conteos de IVR vs Analytics. La comparacion se hace en proceso batch, no en tiempo real.

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-PIP-020
     - El sistema debe mostrar calendario de disponibilidad
     - Vista mensual con indicadores de color
   * - FR-PIP-021
     - El sistema debe detectar gaps automaticamente
     - Lista de fechas sin datos identificadas
   * - FR-PIP-022
     - El sistema debe mostrar detalle por fecha
     - Registros procesados, timestamp, fuente

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-PIP-003: Permitir consulta de disponibilidad de datos
   * - **Reglas de Negocio**
     - BR-PIP-20 a BR-PIP-22
   * - **Restricciones**
     - CNST-003 (BD Dual)
   * - **UC Relacionados**
     - UC_PIP_01, UC_PIP_04
   * - **Actor Principal**
     - AGR-009: agr_admin_pipeline
   * - **Funcion RBAC**
     - PIP-003: ve_disponibilidad_datos

14. Historial de Cambios
------------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 4.0.0
     - 2026-01-06
     - Equipo IACT
     - Version inicial v4.0
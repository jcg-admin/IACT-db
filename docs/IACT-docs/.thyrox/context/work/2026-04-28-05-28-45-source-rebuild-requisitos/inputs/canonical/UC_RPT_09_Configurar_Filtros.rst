.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_09
   :normativa: CNST-004, CNST-009

=============================
UC_RPT_09: Configurar Filtros
=============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_09
   * - **Nombre**
     - Configurar Filtros
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-009: configura_filtros
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-RPT-009

2. Descripcion
--------------

Permite configurar filtros predeterminados para reportes que seran
aplicados automaticamente segun el perfil del usuario o el tipo
de reporte.

**Caracteristicas principales:**

- Definir filtros por defecto para reportes
- Filtros aplicados dentro del segmento (CNST-004)
- Guardar configuraciones de filtros
- Registro de cambios en auditoria (CNST-009)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_09

   @startuml
   left to right direction
   actor "AGR-003\nagr_supervisor" as USER
   rectangle "MOD_Reports" {
     usecase "UC_RPT_09\nConfigurar Filtros" as UC09
     usecase "Definir\nFiltros" as DEF
     usecase "Guardar\nConfiguracion" as SAVE
   }
   USER --> UC09
   UC09 --> DEF : include
   UC09 --> SAVE : include
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
     - Usuario tiene funcion RPT-009
   * - PRE-02
     - Existen reportes configurables

4.2 Trigger
^^^^^^^^^^^

Usuario accede a configuracion de filtros.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Filtros configurados y activos
   * - POST-02
     - Registro en auditoria

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
     - Accede a configuracion de filtros
   * - 2
     - Sistema
     - Valida RPT-009
   * - 3
     - Usuario
     - Selecciona reporte a configurar
   * - 4
     - Sistema
     - Muestra filtros disponibles
   * - 5
     - Usuario
     - Define valores por defecto
   * - 6
     - Usuario
     - Guarda configuracion
   * - 7
     - Sistema
     - Valida filtros dentro del segmento
   * - 8
     - Sistema
     - Guarda configuracion
   * - 9
     - Sistema
     - Registra en auditoria

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_09

   @startuml
   actor "Usuario" as U
   participant "Frontend" as FE
   participant "FilterController" as FC
   participant "FilterService" as FS
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   U -> FE: Configurar filtros
   FE -> FC: GET /api/reports/filters/config
   FC -> FC: verify_function(RPT-009)
   FC --> FE: filter_options
   FE --> U: Formulario de filtros

   U -> FE: Define filtros
   FE -> FC: POST /api/reports/filters
   FC -> FS: save_filter_config(config)
   FS -> FS: validate_within_segment()
   note right: CNST-004
   FS -> DB: INSERT/UPDATE filter_config
   FS -> UAL: record(FILTER_CONFIG)
   note right: CNST-009
   UAL -> DB: INSERT audit
   FS --> FC: saved
   FC --> FE: 200 OK
   FE --> U: Confirmacion
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Modificar Filtro Existente
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 3a
     - Usuario
     - Selecciona filtro existente
   * - 4a
     - Sistema
     - Carga valores actuales

8. Excepciones
--------------

8.1 EX-01: Filtro Fuera de Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Condicion**
     - Filtro incluye datos fuera del segmento
   * - **Mensaje**
     - Filtros deben estar dentro del segmento
   * - **Codigo Error**
     - RPT-080

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_09

   @startuml
   start
   if (Tiene RPT-009?) then (no)
     stop
   else (si)
   endif
   :Seleccionar reporte;
   :Definir filtros;
   if (Dentro del segmento?) then (no)
     :Error fuera de segmento;
     stop
   else (si)
   endif
   :Guardar configuracion;
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
   * - BR-RPT-80
     - Segmento
     - Filtros limitados al segmento del usuario
   * - BR-RPT-81
     - Persistencia
     - Filtros se aplican automaticamente al reporte

**Tipos de Filtros:**

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Tipo
     - Descripcion
   * - Fecha
     - Rango de fechas por defecto
   * - Agente
     - Agentes especificos o grupos
   * - Cola
     - Colas de llamadas
   * - Metrica
     - Metricas a incluir

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
     - Filtros dentro del segmento
   * - CNST-009
     - Auditoria
     - Registro de cambios

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-080
     - Configurar filtros
     - Filtros guardados y aplicados
   * - FR-RPT-081
     - Validar segmento
     - Rechazo si fuera de segmento

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-009
   * - **Restricciones**
     - CNST-004, CNST-009
   * - **Actor Principal**
     - AGR-003: agr_supervisor
   * - **Funcion RBAC**
     - RPT-009: configura_filtros

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
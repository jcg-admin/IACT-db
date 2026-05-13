.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_05
   :normativa: CNST-004, CNST-007, CNST-009

=========================
UC_RPT_05: Exportar Excel
=========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_05
   * - **Nombre**
     - Exportar Excel
   * - **Actor Principal**
     - AGR-004: agr_exportador
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-005: exporta_excel
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-RPT-005

2. Descripcion
--------------

Este caso de uso permite exportar datos de reportes a formato Excel (.xlsx)
con formato enriquecido, incluyendo estilos, graficos embebidos y multiples
hojas de calculo.

**Caracteristicas principales:**

- Exportar a formato XLSX nativo
- Formato enriquecido con estilos
- Graficos embebidos opcionales
- Multiples hojas por tipo de dato
- Limite 100,000 registros (CNST-007)
- Auditoria obligatoria (CNST-009)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_05

   @startuml
   left to right direction
   actor "AGR-004\nagr_exportador" as USER

   rectangle "MOD_Reports" {
     usecase "UC_RPT_05\nExportar Excel" as UC05
     usecase "Validar Limite" as LIM
     usecase "Generar XLSX" as GEN
     usecase "Aplicar Formato" as FMT
     usecase "Registrar Auditoria" as AUD
   }

   USER --> UC05
   UC05 --> LIM : include
   UC05 --> GEN : include
   UC05 --> FMT : include
   UC05 --> AUD : include
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
     - El usuario tiene sesion activa con funcion RPT-005
   * - PRE-02
     - Existen datos para exportar
   * - PRE-03
     - El usuario tiene segmento asignado

4.2 Trigger
^^^^^^^^^^^

El usuario hace clic en Exportar Excel desde un reporte.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se genera archivo XLSX con datos formateados
   * - POST-02
     - Se registra EXPORT_EXCEL en auditoria (CNST-009)

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
     - Hace clic en Exportar Excel
   * - 2
     - Sistema
     - Valida funcion RPT-005
   * - 3
     - Sistema
     - Cuenta registros a exportar
   * - 4
     - Sistema
     - Valida limite 100,000 registros
   * - 5
     - Sistema
     - Aplica filtro de segmento
   * - 6
     - Sistema
     - Crea workbook con hoja principal
   * - 7
     - Sistema
     - Aplica estilos y formato
   * - 8
     - Sistema
     - Registra en auditoria
   * - 9
     - Sistema
     - Descarga archivo XLSX

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_05

   @startuml
   actor "AGR-004 Usuario" as U
   participant "Frontend" as FE
   participant "ExportController" as EC
   participant "ExcelService" as ES
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   U -> FE: Click Exportar Excel
   FE -> EC: POST /api/exports/excel
   EC -> EC: verify_function(RPT-005)

   EC -> ES: export_excel(filters, segmento)

   ES -> DB: SELECT COUNT(*)
   DB --> ES: count

   alt count > 100000
     ES --> EC: ExportLimitExceeded
     EC --> FE: 400 Bad Request
     FE --> U: Error limite excedido
   end

   ES -> DB: SELECT * FROM datos\nWHERE segmento_id = ?
   note right: CNST-004
   DB --> ES: data

   ES -> ES: create_workbook()
   ES -> ES: add_header_styles()
   ES -> ES: add_data_rows()
   ES -> ES: auto_fit_columns()
   ES -> ES: add_filters()

   ES -> UAL: record(EXPORT_EXCEL)
   note right: CNST-009
   UAL -> DB: INSERT audit

   ES --> EC: xlsx_file
   EC --> FE: 200 OK + file
   FE --> U: Descarga XLSX
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Incluir Graficos
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Usuario
     - Selecciona opcion Incluir Graficos
   * - 7a
     - Sistema
     - Genera grafico de datos en hoja separada
   * - 7b
     - Sistema
     - Embebe grafico en el workbook

7.2 FA-02: Multiples Hojas
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Sistema
     - Detecta multiples tipos de datos
   * - 6b
     - Sistema
     - Crea una hoja por cada tipo
   * - 6c
     - Sistema
     - Agrega hoja de resumen

8. Excepciones
--------------

8.1 EX-01: Limite Excedido
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 4
   * - **Condicion**
     - Mas de 100,000 registros
   * - **Accion Sistema**
     - Rechaza exportacion
   * - **Mensaje Usuario**
     - Limite de exportacion Excel es 100,000 registros
   * - **Codigo Error**
     - RPT-040

8.2 EX-02: Error Generacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 6
   * - **Condicion**
     - Error al generar workbook
   * - **Accion Sistema**
     - Informa error
   * - **Mensaje Usuario**
     - Error al generar archivo Excel
   * - **Codigo Error**
     - RPT-041

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_05

   @startuml
   start
   :Usuario solicita exportar Excel;

   if (Tiene RPT-005?) then (no)
     :Error permisos;
     stop
   else (si)
   endif

   :Contar registros;

   if (Count > 100,000?) then (si)
     :Error limite;
     note right: CNST-007
     stop
   else (no)
   endif

   :Aplicar filtro segmento;
   note right: CNST-004

   :Crear workbook;

   if (Incluir graficos?) then (si)
     :Generar graficos;
   endif

   :Aplicar estilos;
   :Auto-ajustar columnas;
   :Agregar filtros Excel;

   :Registrar auditoria;
   note right: CNST-009

   :Descargar archivo;

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
   * - BR-RPT-40
     - Limite
     - Maximo 100,000 registros por exportacion
   * - BR-RPT-41
     - Formato
     - XLSX nativo compatible con Excel 2010+
   * - BR-RPT-42
     - Estilos
     - Cabeceras en negrita, bordes en tabla

**Caracteristicas del XLSX:**

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Caracteristica
     - Descripcion
   * - Formato
     - Office Open XML (.xlsx)
   * - Cabeceras
     - Negrita, fondo gris, filtros automaticos
   * - Columnas
     - Auto-ajuste de ancho
   * - Fechas
     - Formato regional configurable
   * - Numeros
     - Separador de miles, decimales

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-004
     - Segmentos
     - Filtro automatico por segmento
   * - CNST-007
     - Exportaciones
     - Limite 100,000 registros
   * - CNST-009
     - Auditoria Inmutable
     - Registro EXPORT_EXCEL con detalles

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-040
     - El sistema debe exportar a XLSX
     - Archivo Excel descargable
   * - FR-RPT-041
     - El sistema debe incluir formato
     - Estilos y graficos aplicados
   * - FR-RPT-042
     - El sistema debe auditar
     - Registro en user_action_log

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-005: Exportar a Excel
   * - **Reglas de Negocio**
     - BR-RPT-40 a BR-RPT-42
   * - **Restricciones**
     - CNST-004, CNST-007, CNST-009
   * - **UC Relacionados**
     - UC_RPT_04 (CSV), UC_RPT_06 (PDF)
   * - **Actor Principal**
     - AGR-004: agr_exportador
   * - **Funcion RBAC**
     - RPT-005: exporta_excel

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

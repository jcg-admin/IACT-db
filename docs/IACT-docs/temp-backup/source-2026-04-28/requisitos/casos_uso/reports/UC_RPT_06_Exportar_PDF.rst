.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_06
   :normativa: CNST-004, CNST-007, CNST-009

=======================
UC_RPT_06: Exportar PDF
=======================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_06
   * - **Nombre**
     - Exportar PDF
   * - **Actor Principal**
     - AGR-004: agr_exportador
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-006: exporta_pdf
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-RPT-006

2. Descripcion
--------------

Este caso de uso permite exportar reportes a formato PDF para impresion
o distribucion formal. Incluye formato corporativo con encabezados,
graficos y tablas estilizadas.

**Caracteristicas principales:**

- Exportar a formato PDF
- Formato corporativo con logo y encabezados
- Graficos incluidos como imagenes
- Tablas con paginacion automatica
- Limite 50 paginas por documento
- Auditoria obligatoria (CNST-009)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_06

   @startuml
   left to right direction
   actor "AGR-004\nagr_exportador" as USER

   rectangle "MOD_Reports" {
     usecase "UC_RPT_06\nExportar PDF" as UC06
     usecase "Generar PDF" as GEN
     usecase "Aplicar Formato\nCorporativo" as FMT
     usecase "Registrar Auditoria" as AUD
   }

   USER --> UC06
   UC06 --> GEN : include
   UC06 --> FMT : include
   UC06 --> AUD : include
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
     - El usuario tiene sesion activa con funcion RPT-006
   * - PRE-02
     - Existen datos para el reporte
   * - PRE-03
     - El usuario tiene segmento asignado

4.2 Trigger
^^^^^^^^^^^

El usuario hace clic en Exportar PDF desde un reporte.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se genera archivo PDF con formato corporativo
   * - POST-02
     - Se registra EXPORT_PDF en auditoria (CNST-009)

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
     - Hace clic en Exportar PDF
   * - 2
     - Sistema
     - Valida funcion RPT-006
   * - 3
     - Sistema
     - Obtiene datos del reporte con filtro de segmento
   * - 4
     - Sistema
     - Estima numero de paginas
   * - 5
     - Sistema
     - Valida limite 50 paginas
   * - 6
     - Sistema
     - Genera documento PDF con formato corporativo
   * - 7
     - Sistema
     - Incluye graficos como imagenes
   * - 8
     - Sistema
     - Registra en auditoria
   * - 9
     - Sistema
     - Descarga archivo PDF

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_06

   @startuml
   actor "AGR-004 Usuario" as U
   participant "Frontend" as FE
   participant "ExportController" as EC
   participant "PDFService" as PS
   participant "ChartRenderer" as CR
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   U -> FE: Click Exportar PDF
   FE -> EC: POST /api/exports/pdf
   EC -> EC: verify_function(RPT-006)

   EC -> PS: export_pdf(report, segmento)

   PS -> DB: SELECT * FROM datos\nWHERE segmento_id = ?
   DB --> PS: data

   PS -> PS: estimate_pages(data)

   alt pages > 50
     PS --> EC: PageLimitExceeded
     EC --> FE: 400 Bad Request
     FE --> U: Error limite 50 paginas
   end

   PS -> PS: create_pdf_document()
   PS -> PS: add_corporate_header()
   PS -> PS: add_title_page()

   PS -> CR: render_charts(data)
   CR --> PS: chart_images

   PS -> PS: add_charts_to_pdf()
   PS -> PS: add_data_tables()
   PS -> PS: add_page_numbers()
   PS -> PS: add_footer()

   PS -> UAL: record(EXPORT_PDF)
   note right: CNST-009
   UAL -> DB: INSERT audit

   PS --> EC: pdf_file
   EC --> FE: 200 OK + file
   FE --> U: Descarga PDF
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Solo Resumen
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Usuario
     - Selecciona opcion Solo Resumen
   * - 6a
     - Sistema
     - Genera PDF con graficos y totales unicamente
   * - 6b
     - Sistema
     - Omite tablas de detalle

7.2 FA-02: Orientacion Horizontal
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Usuario
     - Selecciona orientacion horizontal
   * - 6a
     - Sistema
     - Genera PDF en formato landscape

8. Excepciones
--------------

8.1 EX-01: Limite Paginas Excedido
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 5
   * - **Condicion**
     - Reporte excede 50 paginas
   * - **Accion Sistema**
     - Rechaza exportacion
   * - **Mensaje Usuario**
     - Limite de exportacion PDF es 50 paginas. Aplique filtros adicionales.
   * - **Codigo Error**
     - RPT-050

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_06

   @startuml
   start
   :Usuario solicita exportar PDF;

   if (Tiene RPT-006?) then (no)
     :Error permisos;
     stop
   else (si)
   endif

   :Obtener datos con filtro segmento;
   note right: CNST-004

   :Estimar paginas;

   if (Paginas > 50?) then (si)
     :Error limite paginas;
     stop
   else (no)
   endif

   :Crear documento PDF;
   :Agregar encabezado corporativo;
   :Agregar portada;
   :Renderizar graficos;
   :Agregar tablas de datos;
   :Agregar numeracion de paginas;
   :Agregar pie de pagina;

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
   * - BR-RPT-50
     - Limite Paginas
     - Maximo 50 paginas por documento PDF
   * - BR-RPT-51
     - Formato Corporativo
     - Logo, encabezado y pie de pagina estandar
   * - BR-RPT-52
     - Graficos
     - Se incluyen como imagenes PNG de alta resolucion

**Estructura del PDF:**

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Seccion
     - Contenido
   * - Portada
     - Titulo, fecha, usuario, segmento
   * - Encabezado
     - Logo corporativo, nombre del reporte
   * - Cuerpo
     - Graficos y tablas de datos
   * - Pie de pagina
     - Numero de pagina, fecha de generacion

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
     - Limite 50 paginas por PDF
   * - CNST-009
     - Auditoria Inmutable
     - Registro EXPORT_PDF con detalles

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-050
     - El sistema debe exportar a PDF
     - Archivo PDF descargable
   * - FR-RPT-051
     - El sistema debe incluir formato corporativo
     - Logo y encabezados presentes
   * - FR-RPT-052
     - El sistema debe incluir graficos
     - Graficos renderizados como imagenes

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-006: Exportar a PDF
   * - **Reglas de Negocio**
     - BR-RPT-50 a BR-RPT-52
   * - **Restricciones**
     - CNST-004, CNST-007, CNST-009
   * - **UC Relacionados**
     - UC_RPT_04 (CSV), UC_RPT_05 (Excel)
   * - **Actor Principal**
     - AGR-004: agr_exportador
   * - **Funcion RBAC**
     - RPT-006: exporta_pdf

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

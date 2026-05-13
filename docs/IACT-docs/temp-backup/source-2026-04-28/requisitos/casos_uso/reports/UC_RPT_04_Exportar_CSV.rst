.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Reports
   :uc_id: UC_RPT_04
   :normativa: CNST-004, CNST-007, CNST-009

=======================
UC_RPT_04: Exportar CSV
=======================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_RPT_04
   * - **Nombre**
     - Exportar CSV
   * - **Actor Principal**
     - AGR-004: agr_exportador
   * - **Modulo**
     - MOD_Reports
   * - **Funcion RBAC**
     - RPT-004: exporta_csv
   * - **Prioridad**
     - Media
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-RPT-004

2. Descripcion
--------------

Este caso de uso permite exportar datos de reportes a formato CSV.
Todas las exportaciones se registran en auditoria (CNST-009) y estan
limitadas a 100,000 registros por exportacion (CNST-007).

**Caracteristicas principales:**

- Exportar datos filtrados a CSV
- Limite de 100,000 registros por exportacion (CNST-007)
- Registro obligatorio en auditoria (CNST-009)
- Filtrado por segmento automatico (CNST-004)
- Generacion asincrona para volumenes grandes
- Codificacion UTF-8 con BOM

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_RPT_04

   @startuml
   left to right direction
   actor "AGR-004\nagr_exportador" as USER
   actor "Sistema" as SYS

   rectangle "MOD_Reports" {
     usecase "UC_RPT_04\nExportar CSV" as UC04
     usecase "Validar\nLimite" as LIM
     usecase "Generar\nCSV" as GEN
     usecase "Registrar\nAuditoria" as AUD
   }

   USER --> UC04
   UC04 --> LIM : include
   UC04 --> GEN : include
   UC04 --> AUD : include
   SYS --> AUD
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
     - El usuario tiene sesion activa con funcion RPT-004
   * - PRE-02
     - Existen datos para exportar segun los filtros aplicados
   * - PRE-03
     - El usuario tiene un segmento asignado

4.2 Trigger
^^^^^^^^^^^

El usuario hace clic en Exportar CSV desde cualquier reporte.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se genera archivo CSV con datos filtrados
   * - POST-02
     - Se registra EXPORT_CSV en auditoria (CNST-009)
   * - POST-03
     - El archivo se descarga al navegador del usuario

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
     - Hace clic en Exportar CSV desde un reporte
   * - 2
     - Sistema
     - Valida funcion RPT-004
   * - 3
     - Sistema
     - Obtiene filtros actuales del reporte
   * - 4
     - Sistema
     - Cuenta registros a exportar
   * - 5
     - Sistema
     - Valida limite 100,000 registros (CNST-007)
   * - 6
     - Sistema
     - Aplica filtro de segmento (CNST-004)
   * - 7
     - Sistema
     - Genera archivo CSV con cabeceras
   * - 8
     - Sistema
     - Registra EXPORT_CSV en auditoria
   * - 9
     - Sistema
     - Inicia descarga del archivo
   * - 10
     - Usuario
     - Recibe archivo CSV

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_RPT_04

   @startuml
   actor "AGR-004 Usuario" as U
   participant "Frontend" as FE
   participant "ExportController" as EC
   participant "ExportService" as ES
   participant "UserActionLog" as UAL
   database "Analytics" as DB

   U -> FE: Click Exportar CSV
   FE -> EC: POST /api/exports/csv
   EC -> EC: verify_function(RPT-004)

   EC -> ES: export_csv(filters, segmento)

   ES -> DB: SELECT COUNT(*) FROM datos\nWHERE segmento_id = ?\nAND (filtros)
   DB --> ES: count

   alt count > 100000
     note right of ES: CNST-007 Limite
     ES --> EC: ExportLimitExceeded
     EC --> FE: 400 Bad Request
     FE --> U: Error: Limite excedido (100,000)
   end

   ES -> DB: SELECT * FROM datos\nWHERE segmento_id = ?\nAND (filtros)\nLIMIT 100000
   note right of DB: CNST-004 Segmento
   DB --> ES: data

   ES -> ES: generate_csv(data)
   note right of ES
     - Cabeceras de columnas
     - Encoding UTF-8 BOM
     - Delimitador coma
   end note

   ES -> UAL: record(EXPORT_CSV, user, details)
   note right of UAL
     CNST-009: Auditoria
     Registra: usuario, filtros,
     cantidad, timestamp
   end note
   UAL -> DB: INSERT audit

   ES --> EC: csv_file
   EC --> FE: 200 OK + file
   FE --> U: Descarga CSV
   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Exportacion Asincrona
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Sistema
     - Detecta volumen grande (> 50,000 registros)
   * - 4b
     - Sistema
     - Muestra mensaje: Exportacion se procesara en segundo plano
   * - 4c
     - Sistema
     - Encola tarea de exportacion
   * - 4d
     - Sistema
     - Notifica via InternalMessage cuando este listo (CNST-001)

7.2 FA-02: Seleccionar Columnas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1a
     - Usuario
     - Hace clic en Exportar CSV con opciones
   * - 1b
     - Sistema
     - Muestra selector de columnas
   * - 1c
     - Usuario
     - Selecciona columnas a incluir
   * - 7a
     - Sistema
     - Genera CSV solo con columnas seleccionadas

8. Excepciones
--------------

8.1 EX-01: Limite Excedido
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 5
   * - **Condicion**
     - Mas de 100,000 registros a exportar
   * - **Accion Sistema**
     - Rechaza exportacion
   * - **Mensaje Usuario**
     - Limite de exportacion es 100,000 registros. Aplique filtros adicionales para reducir el volumen.
   * - **Codigo Error**
     - RPT-030

8.2 EX-02: Sin Datos
^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 4
   * - **Condicion**
     - No hay datos para los filtros aplicados
   * - **Accion Sistema**
     - Informa al usuario
   * - **Mensaje Usuario**
     - No hay datos para exportar con los filtros actuales
   * - **Codigo Error**
     - RPT-031

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_RPT_04

   @startuml
   start
   :Usuario solicita exportar CSV;

   if (Tiene RPT-004?) then (no)
     :Error permisos;
     stop
   else (si)
   endif

   :Obtener filtros del reporte;
   :Contar registros a exportar;

   if (Count = 0?) then (si)
     :Error sin datos;
     stop
   else (no)
   endif

   if (Count > 100,000?) then (si)
     :Error limite excedido;
     note right: CNST-007
     stop
   else (no)
   endif

   if (Count > 50,000?) then (si)
     :Encolar exportacion asincrona;
     :Notificar cuando listo;
   else (no)
     :Generar CSV sincronamente;
   endif

   :Aplicar filtro segmento;
   note right: CNST-004

   :Generar archivo CSV;

   :Registrar en auditoria;
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
   * - BR-RPT-30
     - Limite Registros
     - Maximo 100,000 registros por exportacion (CNST-007)
   * - BR-RPT-31
     - Auditoria Obligatoria
     - Toda exportacion se registra en auditoria (CNST-009)
   * - BR-RPT-32
     - Segmento
     - Solo datos del segmento del usuario (CNST-004)
   * - BR-RPT-33
     - Formato CSV
     - UTF-8 con BOM, delimitador coma, comillas en texto

**Formato del Archivo CSV:**

.. code-block:: text

   - Encoding: UTF-8 con BOM
   - Delimitador: coma (,)
   - Texto: entre comillas dobles
   - Salto de linea: CRLF
   - Primera fila: cabeceras de columnas

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
     - Filtro automatico por segmento del usuario
   * - CNST-007
     - Exportaciones
     - Limite 100,000 registros por exportacion
   * - CNST-009
     - Auditoria Inmutable
     - Registro EXPORT_CSV con usuario, filtros, cantidad, timestamp

**Registro de Auditoria (CNST-009):**

.. code-block:: python

   UserActionLog.record(
       user=current_user,
       action='EXPORT_CSV',
       resource='reports',
       result='SUCCESS',
       ip=request.META.get('REMOTE_ADDR'),
       details={
           'report_type': report_type,
           'filters': applied_filters,
           'record_count': count,
           'columns': selected_columns,
           'file_size_bytes': file_size
       }
   )

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-RPT-030
     - El sistema debe exportar a CSV
     - Archivo CSV descargable
   * - FR-RPT-031
     - El sistema debe validar limite 100k
     - Rechazo si excede limite
   * - FR-RPT-032
     - El sistema debe auditar exportacion
     - Registro en user_action_log
   * - FR-RPT-033
     - El sistema debe filtrar por segmento
     - Solo datos del segmento en export

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-RPT-004: Exportar reportes a CSV
   * - **Reglas de Negocio**
     - BR-RPT-30 a BR-RPT-33
   * - **Restricciones**
     - CNST-004, CNST-007, CNST-009
   * - **UC Relacionados**
     - UC_RPT_05 (Excel), UC_RPT_06 (PDF), UC_RPT_03 (Historicos)
   * - **Actor Principal**
     - AGR-004: agr_exportador
   * - **Funcion RBAC**
     - RPT-004: exporta_csv

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
     - Version inicial v4.0 con CNST-007
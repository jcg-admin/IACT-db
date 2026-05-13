.. meta::
   :artefacto: BReq_002
   :tipo: Requisito de Negocio
   :dominio: requisitos
   :subdominio: requisitos_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _breq-002:

==============================================================================
BReq_002: Exportar Datos a Formatos Externos
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Identificacion
--------------

.. list-table::
   :widths: 25 75
   :stub-columns: 1

   * - ID
     - BReq_002
   * - Nombre
     - Exportar Datos a Formatos Externos
   * - Categoria
     - Funcional
   * - Prioridad
     - **Alta**
   * - Stakeholder
     - Analistas, Supervisores, Gerencia
   * - Deriva de
     - BR_001 (Inmutabilidad Fuente), BR_002 (ETL Programado)

----

1. Declaracion del Requisito
----------------------------

1.1 Enunciado
^^^^^^^^^^^^^

.. admonition:: BReq_002 - Requisito de Negocio
   :class: important

   **"El negocio NECESITA que los usuarios autorizados puedan exportar 
   datos y reportes del dashboard a formatos externos (Excel, CSV, PDF)
   para analisis offline, presentaciones ejecutivas y archivo historico."**

1.2 Contexto de Negocio
^^^^^^^^^^^^^^^^^^^^^^^

Los usuarios del sistema requieren llevar datos fuera de la plataforma para:

- Crear reportes ejecutivos en PowerPoint
- Realizar analisis avanzados en Excel
- Compartir datos con stakeholders sin acceso al sistema
- Mantener archivos historicos para auditoria

1.3 Problema que Resuelve
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   SITUACION ACTUAL (sin exportacion):
   
   - Usuarios copian datos manualmente del dashboard
   - Errores de transcripcion frecuentes
   - No hay formato estandarizado para reportes
   - Tiempo perdido en formateo manual
   
   SITUACION DESEADA (con exportacion):
   
   - Un clic para exportar datos formateados
   - Formatos listos para presentaciones
   - Datos consistentes y verificables
   - Ahorro de tiempo significativo

----

2. Restricciones Aplicables
---------------------------

2.1 De BR_001 (Inmutabilidad)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RESTRICCION: Los datos exportados son snapshot de solo lectura
   
   - El archivo exportado es una copia estatica
   - No hay sincronizacion con cambios posteriores
   - El archivo debe incluir timestamp de extraccion
   
   IMPLICACION PARA EXPORTACION:
   - Incluir metadata: "Datos extraidos: DD/MM/YYYY HH:MM"
   - El archivo es valido hasta el proximo ETL

2.2 De BR_002 (ETL Programado)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RESTRICCION: Datos exportados reflejan ultimo ETL
   
   - Exportacion no dispara actualizacion de datos
   - Los datos tienen la misma latencia que el dashboard
   
   IMPLICACION PARA EXPORTACION:
   - Nombre del archivo incluye fecha/hora de datos
   - Ejemplo: "reporte_metricas_2025-12-22_0800.xlsx"

2.3 De BR_003 (RBAC)
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RESTRICCION: Solo usuarios con rol de exportacion
   
   - Rol requerido: R005 (REPORTS_EXPORTER) o R007 (REPORTS_CREATOR)
   - Usuarios con solo R004 pueden ver pero no exportar
   
   IMPLICACION PARA UI:
   - Boton de exportar solo visible para roles autorizados
   - Intentos no autorizados registrados en audit_logs

----

3. Formatos de Exportacion
--------------------------

3.1 Formatos Soportados
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 25 30 30

   * - Formato
     - Extension
     - Uso Principal
     - Limite de Registros
   * - Excel
     - .xlsx
     - Analisis avanzado, pivots
     - 50,000 filas
   * - CSV
     - .csv
     - Importacion a otros sistemas
     - 100,000 filas
   * - PDF
     - .pdf
     - Presentaciones, archivo
     - 1,000 filas (formateado)

3.2 Contenido del Archivo Exportado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Excel (.xlsx):**

.. code-block:: text

   Hoja 1: "Resumen"
   ├── Titulo del reporte
   ├── Rango de fechas
   ├── Timestamp de generacion
   ├── Usuario que genero
   └── KPIs principales
   
   Hoja 2: "Datos"
   ├── Tabla completa de metricas
   ├── Formato de tabla Excel
   └── Filtros activos aplicados
   
   Hoja 3: "Metadata"
   ├── Fuente de datos
   ├── Ultima actualizacion ETL
   └── Notas y disclaimers

**CSV (.csv):**

.. code-block:: text

   # Encabezado con metadata
   # Reporte: Metricas Dashboard IACT
   # Generado: 2025-12-22 10:30:00
   # Usuario: ana.garcia
   # Datos hasta: 2025-12-22 08:00:00
   
   fecha,centro,cola,total_llamadas,completadas,abandonadas,tasa_abandono
   2025-12-21,Centro Norte,Ventas,150,142,8,5.33
   2025-12-21,Centro Sur,Soporte,230,215,15,6.52
   ...

**PDF (.pdf):**

.. code-block:: text

   Pagina 1: Portada
   ├── Logo IACT
   ├── Titulo del reporte
   ├── Rango de fechas
   └── Fecha de generacion
   
   Pagina 2: Resumen Ejecutivo
   ├── KPIs principales
   └── Graficos de tendencia
   
   Paginas 3+: Detalle
   ├── Tablas formateadas
   └── Pie de pagina con disclaimer

----

4. Criterios de Exito
---------------------

4.1 Criterios Medibles
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Criterio
     - Meta
     - Medicion
   * - Tiempo de generacion Excel
     - < 10 segundos (10K filas)
     - Performance testing
   * - Tiempo de generacion CSV
     - < 5 segundos (50K filas)
     - Performance testing
   * - Tiempo de generacion PDF
     - < 15 segundos
     - Performance testing
   * - Exportaciones exitosas
     - > 99%
     - Logs de errores

4.2 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: gherkin

   Escenario: Exportar datos a Excel
     Dado que el usuario tiene rol R005 (REPORTS_EXPORTER)
     Y el usuario esta viendo el dashboard con filtros aplicados
     Cuando el usuario hace clic en "Exportar a Excel"
     Entonces el sistema DEBE generar archivo .xlsx
     Y el archivo DEBE descargarse automaticamente
     Y el archivo DEBE incluir timestamp en el nombre
     Y el archivo DEBE contener los datos filtrados

   Escenario: Exportar datos a CSV
     Dado que el usuario tiene rol R005
     Cuando el usuario hace clic en "Exportar a CSV"
     Entonces el sistema DEBE generar archivo .csv
     Y el archivo DEBE incluir encabezado con metadata
     Y los datos DEBEN estar separados por comas

   Escenario: Exportar reporte a PDF
     Dado que el usuario tiene rol R007 (REPORTS_CREATOR)
     Cuando el usuario hace clic en "Exportar a PDF"
     Entonces el sistema DEBE generar archivo .pdf
     Y el PDF DEBE incluir portada con logo
     Y el PDF DEBE incluir graficos del dashboard

   Escenario: Usuario sin permiso no puede exportar
     Dado que el usuario tiene solo rol R004 (REPORTS_VIEWER)
     Cuando el usuario busca opcion de exportar
     Entonces el boton de exportar NO DEBE estar visible
     O el boton DEBE estar deshabilitado

   Escenario: Limite de registros
     Dado que el usuario solicita exportar 60,000 registros a Excel
     Cuando el sistema procesa la solicitud
     Entonces el sistema DEBE advertir que se excede el limite
     Y el sistema DEBE ofrecer exportar a CSV como alternativa

----

5. Limites y Restricciones Operativas
-------------------------------------

5.1 Limites por Rol
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 25 25 30

   * - Rol
     - Exportaciones/Dia
     - Max Registros
     - Formatos
   * - R005 (Exporter)
     - 20
     - 50,000
     - Excel, CSV
   * - R007 (Creator)
     - 50
     - 100,000
     - Excel, CSV, PDF
   * - R016 (Admin)
     - Ilimitado
     - 500,000
     - Todos

5.2 Registro de Exportaciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cada exportacion se registra en audit_logs:

.. code-block:: python

   {
       "action": "EXPORT_DATA",
       "user_id": 123,
       "timestamp": "2025-12-22T10:30:00Z",
       "format": "xlsx",
       "records_count": 5000,
       "filters_applied": {
           "date_range": ["2025-12-01", "2025-12-22"],
           "centro": "Norte"
       },
       "file_name": "reporte_metricas_2025-12-22_0800.xlsx",
       "file_size_kb": 256
   }

----

6. Trazabilidad
---------------

6.1 Hacia Arriba (Origen)
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BReq_002
     │
     ├──▶ BR_001: Inmutabilidad (datos de solo lectura)
     ├──▶ BR_002: ETL Programado (timestamp de datos)
     └──▶ BR_003: RBAC (roles R005, R007)

6.2 Hacia Abajo (Deriva)
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BReq_002
     │
     └──▶ UC_002: Exportar Reporte
           │
           └──▶ FR_003: Generar Excel

6.3 Matriz de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 25 25

   * - BR
     - BReq
     - UC
     - FR
     - TST
   * - BR_001, BR_002
     - **BReq_002**
     - UC_002
     - FR_003
     - TST_UC_002

----

7. Historial de Cambios
-----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2025-12-22
     - Equipo IACT
     - Creacion inicial

----

Referencias
-----------

- :ref:`br-001` - Inmutabilidad de Fuente Operacional
- :ref:`br-002` - Actualizacion mediante ETL Programado
- :ref:`br-003` - Control de Acceso RBAC Flat
- :ref:`uc-002` - Exportar Reporte (pendiente)

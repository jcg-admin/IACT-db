.. meta::
   :project: IACT - Sistema de Dashboard Analytics
   :version: 1.0.0
   :date: 2026-04-25
   :status: Validado
   :feature: plantuml-java-integration-impl
   :uc_ref: UC_PIP_01, UC_PIP_02, UC_PIP_03, UC_PIP_04

=========================================
Ejemplo: Diagrama de Proceso ETL Pipeline
=========================================

Propósito
=========

Este ejemplo illustra el proceso completo de ETL (Extract, Transform, Load) que sincroniza datos desde la base de datos operacional IVR hacia la base de datos analítica, con manejo de errores y validación.

Proceso ETL
===========

.. uml::
   :caption: IACT - Proceso ETL Pipeline Detallado

   @startuml IACT-ETL-Pipeline
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: plantuml-guide
   ' type: activity
   ' description: ETL Pipeline process with validation and error handling

   skinparam BackgroundColor white

   ' Extract Phase
   package "EXTRACT PHASE" {
     component [MySQL IVR\nConnection] as mysql_conn
     component [Query Builder] as query_builder
     component [Data Cursor] as cursor
   }

   ' Validation
   component [Pre-Check\nValidation] as precheck

   ' Transform Phase
   package "TRANSFORM PHASE" {
     component [Row Parser] as parser
     component [Business Rules\nEngine] as rules_engine
     component [Data Mapper] as mapper
     component [Schema\nValidator] as schema_val
   }

   ' Error Handling
   package "ERROR HANDLING" {
     component [Error\nLogger] as error_log
     component [Dead Letter\nQueue] as dlq
   }

   ' Load Phase
   package "LOAD PHASE" {
     component [PostgreSQL\nConnection] as pg_conn
     component [Batch Insert] as batch_insert
     component [Commit\nManager] as commit_mgr
   }

   ' Monitoring
   component [Audit Log\n(Immutable)] as audit_log
   component [Metrics\nCollector] as metrics

   ' Connections - Extract
   mysql_conn --> query_builder : SQL
   query_builder --> cursor : Iterator
   cursor --> precheck : Raw Records

   ' Validation
   precheck --> parser : Valid Data
   precheck --> error_log : Invalid Data

   ' Transform
   parser --> rules_engine : Parsed Rows
   rules_engine --> mapper : Transformed Data
   mapper --> schema_val : Mapped Records

   ' Schema Validation
   schema_val --> batch_insert : Validated Data
   schema_val --> error_log : Schema Errors

   ' Error Handling
   error_log --> dlq : Failed Records
   error_log --> audit_log : Error Events

   ' Load
   batch_insert --> commit_mgr : Insert Batch
   commit_mgr --> pg_conn : Commit Transaction

   ' Success Path
   commit_mgr --> audit_log : Success Event

   ' Monitoring
   mysql_conn -.-> metrics : Extract Time
   rules_engine -.-> metrics : Transform Time
   pg_conn -.-> metrics : Load Time
   dlq -.-> metrics : Error Count
   metrics -.-> audit_log : Pipeline Metrics

   @enduml

Fases del Pipeline
==================

1. **EXTRACT PHASE**

   - Conectar a MySQL IVR (read-only per CNST-003)
   - Ejecutar queries para traer datos operacionales
   - Crear cursor para procesar por lotes
   - Pre-validación: verificar formato y completitud

   **Records procesados:** 1000-50000 por ejecución

2. **TRANSFORM PHASE**

   - **Row Parser:** Parsear registros crudos
   - **Rules Engine:** Aplicar reglas de negocio
     - Cálculos de agregación
     - Conversiones de formato
     - Enriquecimiento de datos
   - **Data Mapper:** Mapear a schema analítico
   - **Schema Validator:** Verificar tipos y restricciones

3. **ERROR HANDLING**

   - Registrar errores en **Audit Log** (CNST-009 - inmutable)
   - Guardar registros fallidos en **Dead Letter Queue**
   - Permitir reintentos con :doc:`test-component-diagram`

4. **LOAD PHASE**

   - Agrupar registros validados en batches
   - Insertar en PostgreSQL Analytics
   - Commit transaccional (all-or-nothing)
   - Log de suceso en Audit Log

5. **MONITORING**

   - Recolectar métricas de cada fase
   - Tiempo de ejecución
   - Cantidad de errores
   - Recordar: :doc:`../index` para más ejemplos

Flujo de Ejecución
==================

**Escenario Normal (Happy Path):**

.. code-block:: text

   MySQL → Extract → Pre-Check ✓ → Parse → Rules → Map → Schema ✓
   → Batch → PostgreSQL → Commit ✓ → Audit Log

**Escenario con Errores:**

.. code-block:: text

   MySQL → Extract → Pre-Check ✗ → Error Logger → Dead Letter Queue
                                                  ↓
                                            Audit Log (CNST-009)

**Casos de Uso Relacionados:**

- **UC_PIP_01:** Supervisar ETL (ver estado del pipeline)
- **UC_PIP_02:** Consultar Errores ETL (revisar DLQ)
- **UC_PIP_03:** Consultar Disponibilidad (health check)
- **UC_PIP_04:** Solicitar Reintento (reintentar fallidos)

Restricciones de Arquitectura
=============================

1. **CNST-003:** Base de datos dual inmutable
   - MySQL IVR: Solo lectura (read-only cursor)
   - PostgreSQL: Escritura transaccional + audit trail

2. **CNST-009:** Logging y auditoría inmutable
   - Todos los eventos registrados en Audit Log
   - Timestamps precisos para cada fase
   - No se pueden eliminar registros de error

3. **Performance (CNST-007)**
   - Procesamiento en batches (1000-50000 registros)
   - Tiempo máximo por ejecución: 15 minutos
   - Alertas si <90% de éxito

Validación del Diagrama
=======================

Este ejemplo demuestra:

- ✓ Flujo completo de ETL con todas las fases
- ✓ Manejo explícito de errores
- ✓ Auditoría e inmutabilidad (CNST-009)
- ✓ Monitoreo de métricas
- ✓ Colores semánticos (verde=almacenamiento, rojo=errores, azul=procesamiento)
- ✓ Integración con casos de uso del proyecto

Referencias
===========

- :doc:`../GUIDELINES` — Cómo usar estilos centralizados
- :doc:`../color-palette` — Convenciones de color
- :ref:`requisitos` — Casos de uso UC_PIP_01 a UC_PIP_04
- :ref:`arquitectura-tecnica` — Detalles técnicos del pipeline
- :ref:`normativa` — Restricciones CNST-003, CNST-007, CNST-009

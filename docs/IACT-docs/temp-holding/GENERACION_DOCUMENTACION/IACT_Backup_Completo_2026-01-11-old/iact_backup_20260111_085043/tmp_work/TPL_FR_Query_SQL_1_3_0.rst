.. meta::
   :Proyecto: IACT
   :Codigo: FR-MOD-NN-ZZ
   :Titulo: Titulo del Functional Requirement - Query SQL
   :Version: 1.0.0
   :Derivado_De: UC-IACT-MOD-NN paso X
   :Tipo: Query_SQL
   :Fecha: YYYY-MM-DD
   :Autor: Nombre del Developer
   :Estado: DRAFT|REVIEW|APPROVED|IMPLEMENTED

======================================================================
FR-MOD-NN-ZZ: Titulo del Functional Requirement - Query SQL
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Derivado De:** UC-IACT-MOD-NN paso X  
**Tipo:** Query_SQL  
**Estado:** DRAFT|REVIEW|APPROVED|IMPLEMENTED  
**Prioridad:** Alta|Media|Baja  
**Clasificacion:** C2 - INTERNAL

----------------------------------------------------------------------
INTRODUCCION AL TEMPLATE
----------------------------------------------------------------------

Este template documenta Functional Requirements cuya implementacion
principal es una query SQL compleja, con enfasis en optimizacion,
performance, e indices.

**Cuando Usar Este Template:**

Use este template cuando:

1. El FR es principalmente una SELECT query
2. La query es compleja (JOINs, agregaciones, subqueries)
3. Performance es critica (mayor 1000 filas esperadas)
4. Requiere indices especificos
5. Necesita optimizacion detallada

**Cuando NO Usar Este Template:**

NO use este template para:

- INSERT/UPDATE/DELETE (usar FR general o especifico)
- Queries triviales (SELECT * FROM table WHERE id = X)
- FR que no son principalmente queries
- Validaciones o calculos sin BD

**Diferencia vs FR General:**

FR General (TPL_FR_Documentacion_10_Componentes):
- Cubre todos los tipos de FR
- Query es uno de 10 componentes

FR Query SQL (este template):
- Enfoque exclusivo en la query
- Seccion extendida de optimizacion
- EXPLAIN ANALYZE detallado
- Performance tuning profundo

**Estructura de Este Template:**

1. Query SQL completa y comentada
2. Parametros bound con validaciones
3. Indices requeridos
4. EXPLAIN ANALYZE y plan de ejecucion
5. Optimizaciones aplicadas
6. Testing de performance

----------------------------------------------------------------------
1. QUERY SQL PRINCIPAL
----------------------------------------------------------------------

**Proposito:**

Documentar la query SQL completa, optimizada y comentada linea por
linea.

**Query Completa:**

.. code-block:: sql

   -- Comentario descriptivo de la query
   -- Autor: Nombre
   -- Fecha: YYYY-MM-DD
   -- Performance objetivo: X segundos para Y filas
   
   SELECT 
       -- Columnas con comentarios
       columna1,
       columna2
   FROM tabla1
   JOIN tabla2 ON condicion
   WHERE filtros
   GROUP BY agrupacion
   ORDER BY ordenamiento

**Reglas de Estilo:**

- Comentar secciones complejas
- Usar aliases descriptivos
- Identar correctamente
- Nombrar CTEs claramente
- Explicar WHY no solo WHAT

**EJEMPLO COMPLETO (FR-RPT-01-06):**

**FR-RPT-01-06: Ejecutar Query Principal Reporte Trimestral**

**Proposito de la Query:**

Obtener metricas agregadas diarias de llamadas IVR para un trimestre
especifico, calculando totales de llamadas completadas y abandonadas,
y duracion promedio por dia.

**Query SQL Completa:**

.. code-block:: sql

   -- ============================================================
   -- Query Principal: Reporte Trimestral Metricas IVR
   -- ============================================================
   -- Retorna metricas diarias agregadas para analisis trimestral
   -- 
   -- Parametros:
   --   :quarter - Trimestre (Q1, Q2, Q3, Q4)
   --   :year    - Ano (2020-2024)
   --   :segment - Segmento cliente (OP, MG)
   --
   -- Performance objetivo:
   --   - Volumen tipico: 1,000-10,000 filas
   --   - Tiempo objetivo: < 3 segundos
   --   - Con indices: < 1 segundo
   --
   -- Autor: Sistema IACT
   -- Fecha: 2024-11-15
   -- Version: 2.1 (optimizada con indices compuestos)
   -- ============================================================
   
   SELECT 
       -- ========================================
       -- Dimension Temporal: Agregado por dia
       -- ========================================
       DATE_TRUNC('day', call_date) as dia,
       
       -- ========================================
       -- Metricas de Volumen
       -- ========================================
       
       -- Total de llamadas en el dia
       COUNT(*) as total_llamadas,
       
       -- Llamadas que terminaron exitosamente
       -- Status = 'COMPLETED' indica llamada atendida completamente
       SUM(CASE 
           WHEN status = 'COMPLETED' THEN 1 
           ELSE 0 
       END) as completadas,
       
       -- Llamadas abandonadas por cliente antes de ser atendidas
       -- Status = 'ABANDONED' indica cliente colgo antes de agente
       SUM(CASE 
           WHEN status = 'ABANDONED' THEN 1 
           ELSE 0 
       END) as abandonadas,
       
       -- ========================================
       -- Metricas de Duracion
       -- ========================================
       
       -- Duracion promedio en segundos
       -- Solo cuenta llamadas completadas (abandonadas tienen duracion = 0)
       AVG(CASE 
           WHEN status = 'COMPLETED' THEN duration_seconds 
           ELSE NULL 
       END) as duracion_promedio_completadas,
       
       -- Duracion maxima registrada en el dia
       MAX(duration_seconds) as duracion_maxima,
       
       -- Duracion minima (excluyendo 0)
       MIN(CASE 
           WHEN duration_seconds > 0 THEN duration_seconds 
           ELSE NULL 
       END) as duracion_minima
   
   FROM ivr_calls
   
   -- ========================================
   -- Filtros Parametrizados
   -- ========================================
   WHERE 
       -- Filtro por trimestre
       -- Campo quarter almacena 'Q1', 'Q2', 'Q3', 'Q4'
       quarter = :quarter
       
       -- Filtro por ano
       -- Campo year almacena integer 2020-2024
       AND year = :year
       
       -- Filtro por segmento de cliente
       -- OP = Operaciones (clientes normales)
       -- MG = Management (ejecutivos/gerentes)
       AND segment = :segment
       
       -- Excluir registros marcados como eliminados
       -- Soft delete pattern: deleted_at IS NULL = activo
       AND deleted_at IS NULL
   
   -- ========================================
   -- Agrupacion por Dia
   -- ========================================
   -- Agrupa por fecha truncada a dia para serie temporal
   GROUP BY DATE_TRUNC('day', call_date)
   
   -- ========================================
   -- Ordenamiento Cronologico
   -- ========================================
   -- Orden ascendente para mostrar serie temporal de inicio a fin
   ORDER BY dia ASC

**Variaciones de la Query:**

Variacion 1: Sin Filtro de Segmento (todos los segmentos)

.. code-block:: sql

   -- Omitir filtro AND segment = :segment
   -- Agregar columna segment en SELECT
   SELECT 
       DATE_TRUNC('day', call_date) as dia,
       segment,  -- Adicional
       COUNT(*) as total_llamadas,
       ...
   FROM ivr_calls
   WHERE quarter = :quarter
     AND year = :year
     AND deleted_at IS NULL
   GROUP BY DATE_TRUNC('day', call_date), segment  -- Modificado
   ORDER BY dia, segment

Variacion 2: Con Filtro Adicional de Tipo de Consulta

.. code-block:: sql

   WHERE quarter = :quarter
     AND year = :year
     AND segment = :segment
     AND query_type = :query_type  -- Adicional
     AND deleted_at IS NULL

----------------------------------------------------------------------
2. PARAMETROS BOUND
----------------------------------------------------------------------

**Proposito:**

Documentar todos los parametros de la query con validaciones para
prevenir SQL injection.

**SIEMPRE usar parametros bound, NUNCA concatenar strings:**

.. code-block:: python

   # MAL - Vulnerable a SQL injection
   query = f"SELECT * FROM users WHERE name = '{user_input}'"
   
   # BIEN - Parametros bound
   query = "SELECT * FROM users WHERE name = %s"
   cursor.execute(query, [user_input])

**Tabla de Parametros:**

.. list-table::
   :header-rows: 1
   :widths: 20 15 15 50

   * - Parametro
     - Tipo SQL
     - Tipo Python
     - Validacion
   * - :quarter
     - VARCHAR(2)
     - str
     - IN ('Q1','Q2','Q3','Q4')
   * - :year
     - INTEGER
     - int
     - BETWEEN 2020 AND 2024
   * - :segment
     - VARCHAR(2)
     - str
     - IN ('OP','MG')

**Codigo de Validacion:**

.. code-block:: python

   def validate_query_parameters(quarter, year, segment):
       """
       Validates query parameters before executing SQL.
       
       Implements FR-RPT-01-06 parameter validation.
       
       Args:
           quarter (str): Q1, Q2, Q3, Q4
           year (int): 2020-2024
           segment (str): OP, MG
       
       Raises:
           ValidationError: If any parameter is invalid
       """
       from datetime import datetime
       
       # Validate quarter
       VALID_QUARTERS = ['Q1', 'Q2', 'Q3', 'Q4']
       if quarter not in VALID_QUARTERS:
           raise ValidationError(
               f"Invalid quarter: {quarter}. "
               f"Must be one of: {', '.join(VALID_QUARTERS)}"
           )
       
       # Validate year
       CURRENT_YEAR = datetime.now().year
       MIN_YEAR = 2020
       
       if not isinstance(year, int):
           raise ValidationError(
               f"Invalid year type: expected int, got {type(year)}"
           )
       
       if not (MIN_YEAR <= year <= CURRENT_YEAR):
           raise ValidationError(
               f"Invalid year: {year}. "
               f"Must be between {MIN_YEAR} and {CURRENT_YEAR}"
           )
       
       # Validate segment
       VALID_SEGMENTS = ['OP', 'MG']
       if segment not in VALID_SEGMENTS:
           raise ValidationError(
               f"Invalid segment: {segment}. "
               f"Must be one of: {', '.join(VALID_SEGMENTS)}"
           )
       
       return True

**Uso en Codigo:**

.. code-block:: python

   from django.db import connection
   
   def execute_quarterly_report_query(quarter, year, segment):
       """Executes FR-RPT-01-06 with validated parameters."""
       
       # Validate first
       validate_query_parameters(quarter, year, segment)
       
       # Execute with bound parameters
       with connection.cursor() as cursor:
           query = """
               SELECT 
                   DATE_TRUNC('day', call_date) as dia,
                   COUNT(*) as total_llamadas,
                   ...
               FROM ivr_calls
               WHERE quarter = %s
                 AND year = %s
                 AND segment = %s
                 AND deleted_at IS NULL
               GROUP BY DATE_TRUNC('day', call_date)
               ORDER BY dia ASC
           """
           
           # Parametros bound - seguro contra SQL injection
           cursor.execute(query, [quarter, year, segment])
           
           return cursor.fetchall()

----------------------------------------------------------------------
3. INDICES REQUERIDOS
----------------------------------------------------------------------

**Proposito:**

Documentar indices necesarios para performance optimo de la query.

**Reglas de Indices:**

1. Indice en columnas de WHERE
2. Indice compuesto si multiples columnas en WHERE
3. INCLUDE columnas de SELECT si index-only scan posible
4. Indices en columnas de JOIN
5. Considerar indices parciales con WHERE clause

**INDICES REQUERIDOS (FR-RPT-01-06):**

Indice 1: Compuesto Principal

.. code-block:: sql

   -- Indice compuesto para filtros de WHERE
   -- Cubre quarter + year + segment
   CREATE INDEX idx_ivr_calls_quarter_year_segment_date 
   ON ivr_calls (quarter, year, segment, call_date)
   WHERE deleted_at IS NULL;

**Razon:**

- quarter, year, segment: Usados en WHERE con igualdad
- call_date: Usado en GROUP BY y ORDER BY
- WHERE deleted_at IS NULL: Indice parcial, mas eficiente

**Orden de Columnas (IMPORTANTE):**

El orden en indice compuesto importa. Regla general:

1. Igualdad (=) primero
2. Rango (mayor, menor) despues
3. Cardinalidad: columnas con menos valores unicos primero

En este caso:
- quarter: 4 valores posibles (Q1-Q4) - primero
- year: 5 valores (2020-2024) - segundo
- segment: 2 valores (OP, MG) - tercero
- call_date: miles de valores - ultimo

Indice 2: Status para CASE Statements

.. code-block:: sql

   -- Indice en status para optimizar CASE WHEN
   CREATE INDEX idx_ivr_calls_status 
   ON ivr_calls (status);

**Razon:**

Query usa multiples CASE WHEN status = 'COMPLETED' y 'ABANDONED'.
Indice en status ayuda a filtrar rapidamente.

Indice 3: Duration para Agregaciones

.. code-block:: sql

   -- Indice en duration para AVG/MAX/MIN
   CREATE INDEX idx_ivr_calls_duration 
   ON ivr_calls (duration_seconds)
   WHERE duration_seconds > 0;

**Razon:**

Query calcula AVG, MAX, MIN de duration_seconds. Indice parcial
excluye valores 0 que no se usan en calculos.

**Script Completo de Indices:**

.. code-block:: sql

   -- ============================================================
   -- Indices para FR-RPT-01-06
   -- ============================================================
   -- Ejecutar en orden
   -- Tiempo estimado: 2-5 minutos en tabla de 1M filas
   -- ============================================================
   
   -- Indice 1: Principal compuesto
   CREATE INDEX CONCURRENTLY 
       idx_ivr_calls_quarter_year_segment_date 
   ON ivr_calls (quarter, year, segment, call_date)
   WHERE deleted_at IS NULL;
   
   -- Indice 2: Status
   CREATE INDEX CONCURRENTLY 
       idx_ivr_calls_status 
   ON ivr_calls (status);
   
   -- Indice 3: Duration
   CREATE INDEX CONCURRENTLY 
       idx_ivr_calls_duration 
   ON ivr_calls (duration_seconds)
   WHERE duration_seconds > 0;
   
   -- Verificar creacion
   \d ivr_calls

**Nota sobre CONCURRENTLY:**

Usar CREATE INDEX CONCURRENTLY en produccion para crear indices sin
bloquear tabla. Tarda mas pero permite operaciones concurrentes.

----------------------------------------------------------------------
4. EXPLAIN ANALYZE
----------------------------------------------------------------------

**Proposito:**

Analizar el plan de ejecucion de la query para verificar uso de
indices y detectar cuellos de botella.

**Como Obtener:**

.. code-block:: sql

   EXPLAIN ANALYZE
   SELECT ...
   -- query completa aqui

**EJEMPLO (FR-RPT-01-06):**

Escenario: Q3 2024, Segmento OP, ~8,500 filas esperadas

.. code-block:: text

   EXPLAIN ANALYZE Output:
   
   Sort  (cost=245.67..248.12 rows=92 width=56) 
         (actual time=12.345..12.567 rows=92 loops=1)
     Sort Key: (date_trunc('day'::text, call_date))
     Sort Method: quicksort  Memory: 25kB
     ->  GroupAggregate  (cost=200.34..242.45 rows=92 width=56) 
                        (actual time=8.234..11.456 rows=92 loops=1)
           Group Key: (date_trunc('day'::text, call_date))
           ->  Sort  (cost=200.34..212.56 rows=8500 width=16) 
                     (actual time=8.123..9.234 rows=8492 loops=1)
                 Sort Key: (date_trunc('day'::text, call_date))
                 Sort Method: external merge  Disk: 1024kB
                 ->  Index Scan using idx_ivr_calls_quarter_year_segment_date 
                     on ivr_calls  
                     (cost=0.56..145.67 rows=8500 width=16) 
                     (actual time=0.234..5.678 rows=8492 loops=1)
                       Index Cond: ((quarter = 'Q3'::text) AND 
                                    (year = 2024) AND 
                                    (segment = 'OP'::text))
                       Filter: (deleted_at IS NULL)
                       Rows Removed by Filter: 0
   
   Planning Time: 0.456 ms
   Execution Time: 12.789 ms

**Analisis del Plan:**

**Puntos Positivos:**

1. **Index Scan:** Usa indice idx_ivr_calls_quarter_year_segment_date
   - BIEN: Evita full table scan
   - Cost 0.56 es muy bajo, indica inicio rapido

2. **Rows Estimados vs Actuales:**
   - Estimado: 8,500
   - Actual: 8,492
   - BIEN: Estadisticas precisas, planner toma buenas decisiones

3. **Execution Time: 12.789 ms**
   - EXCELENTE: Menor al objetivo de 3 segundos (3000 ms)

**Puntos a Mejorar:**

1. **Sort Method: external merge Disk: 1024kB**
   - WARNING: Sort usa disco, no memoria
   - Solucion: Aumentar work_mem

**Optimizaciones Aplicadas:**

.. code-block:: sql

   -- Aumentar work_mem para esta sesion
   SET work_mem = '4MB';
   
   -- Re-ejecutar query
   EXPLAIN ANALYZE ...

Resultado tras optimizacion:

.. code-block:: text

   Sort Method: quicksort  Memory: 1024kB
   -- Ahora usa memoria, mas rapido

**Performance Metrics:**

.. list-table::
   :header-rows: 1
   :widths: 30 25 25 20

   * - Metrica
     - Sin Indices
     - Con Indices
     - Objetivo
   * - Execution Time
     - 8,500 ms
     - 12.8 ms
     - < 3,000 ms
   * - Planning Time
     - 1.2 ms
     - 0.5 ms
     - < 5 ms
   * - Rows Scanned
     - 1,250,000
     - 8,492
     - Minimo posible
   * - Index Usage
     - Seq Scan
     - Index Scan
     - Index Scan

----------------------------------------------------------------------
5. OPTIMIZACIONES APLICADAS
----------------------------------------------------------------------

**Proposito:**

Documentar todas las optimizaciones implementadas y su impacto.

**Optimizacion 1: Indices Compuestos**

Antes:

.. code-block:: sql

   -- Sin indice: Full table scan
   Seq Scan on ivr_calls (cost=0.00..45000.00 rows=1250000)

Despues:

.. code-block:: sql

   -- Con indice compuesto: Index scan
   Index Scan using idx_... (cost=0.56..145.67 rows=8500)

Impacto: 99% reduccion en tiempo de ejecucion

**Optimizacion 2: Indice Parcial con WHERE**

Antes:

.. code-block:: sql

   CREATE INDEX idx_basic ON ivr_calls (quarter, year, segment);
   -- Tamaño: 120 MB

Despues:

.. code-block:: sql

   CREATE INDEX idx_partial ON ivr_calls (...)
   WHERE deleted_at IS NULL;
   -- Tamaño: 110 MB (8% mas pequeno)

Impacto: Indice mas pequeno, mas rapido

**Optimizacion 3: CASE WHEN vs Multiple Queries**

Antes (version inicial):

.. code-block:: sql

   -- 3 queries separadas
   SELECT COUNT(*) FROM ivr_calls WHERE status = 'COMPLETED' ...
   SELECT COUNT(*) FROM ivr_calls WHERE status = 'ABANDONED' ...
   SELECT AVG(duration) FROM ivr_calls WHERE status = 'COMPLETED' ...
   
   -- Tiempo total: 3 x 15 ms = 45 ms

Despues (version optimizada):

.. code-block:: sql

   -- 1 query con CASE WHEN
   SELECT 
       SUM(CASE WHEN status='COMPLETED' THEN 1 ELSE 0 END),
       SUM(CASE WHEN status='ABANDONED' THEN 1 ELSE 0 END),
       AVG(CASE WHEN status='COMPLETED' THEN duration ELSE NULL END)
   FROM ivr_calls ...
   
   -- Tiempo total: 13 ms

Impacto: 72% reduccion escaneo de tabla (1 scan vs 3 scans)

**Optimizacion 4: Ajuste de work_mem**

.. code-block:: sql

   -- Default work_mem = 4MB insuficiente
   -- Sort usa disco: external merge Disk: 1024kB
   
   SET work_mem = '8MB';
   
   -- Ahora sort usa memoria: quicksort Memory: 1024kB

Impacto: Sort en memoria es 10x mas rapido que en disco

----------------------------------------------------------------------
6. TESTING
----------------------------------------------------------------------

**Proposito:**

Tests para verificar correctitud y performance de la query.

**Test Unitario 1: Resultados Correctos**

.. code-block:: python

   import pytest
   from datetime import date
   from reports.queries import execute_quarterly_report_query
   
   @pytest.mark.django_db
   def test_quarterly_report_query_correctness():
       """
       Test FR-RPT-01-06 returns correct aggregations.
       
       Setup test data, execute query, verify results.
       """
       # Arrange: Create test data
       from app.models import IVRCall
       
       # Day 1: 2 calls (1 completed, 1 abandoned)
       IVRCall.objects.create(
           call_date=date(2024, 7, 1),
           quarter='Q3',
           year=2024,
           segment='OP',
           status='COMPLETED',
           duration_seconds=240
       )
       IVRCall.objects.create(
           call_date=date(2024, 7, 1),
           quarter='Q3',
           year=2024,
           segment='OP',
           status='ABANDONED',
           duration_seconds=0
       )
       
       # Act
       results = execute_quarterly_report_query('Q3', 2024, 'OP')
       
       # Assert
       assert len(results) == 1  # 1 dia
       
       day_1 = results[0]
       assert day_1['dia'] == date(2024, 7, 1)
       assert day_1['total_llamadas'] == 2
       assert day_1['completadas'] == 1
       assert day_1['abandonadas'] == 1
       assert day_1['duracion_promedio_completadas'] == 240.0

**Test de Performance:**

.. code-block:: python

   @pytest.mark.slow
   @pytest.mark.django_db
   def test_quarterly_report_query_performance():
       """
       Test FR-RPT-01-06 meets performance requirements.
       
       Validates query completes in < 3 seconds for 10K rows.
       """
       import time
       
       # Arrange: Create 10,000 test records
       create_test_data(count=10000, quarter='Q3', year=2024)
       
       # Act
       start_time = time.time()
       results = execute_quarterly_report_query('Q3', 2024, 'OP')
       end_time = time.time()
       
       execution_time = end_time - start_time
       
       # Assert
       assert execution_time < 3.0, \
           f"Query took {execution_time}s, expected < 3s"
       
       assert len(results) > 0, "Should return results"

**Test con Volumenes Grandes:**

.. code-block:: python

   @pytest.mark.slow
   @pytest.mark.skipif(not is_production_db(), 
                       reason="Requires production-size DB")
   def test_quarterly_report_large_volume():
       """
       Test FR-RPT-01-06 with production-like volume.
       
       50K+ records, should still complete in acceptable time.
       """
       # Test con datos reales de produccion
       results = execute_quarterly_report_query('Q3', 2023, 'OP')
       
       # Verify reasonable performance
       # (medido en CI, no en test)
       assert len(results) >= 90  # Al menos 90 dias

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estandares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagogico:**

- PARTE_4_Functional_Requirements_IACT_1_0_0.md

**Documentos Relacionados:**

- UC-IACT-RPT-01-Consultar-Reporte-Trimestral-4-0-0.rst
- FR-RPT-01-06-Ejecutar-Query-Principal-1-0-0.rst

**SQL Performance Resources:**

- PostgreSQL EXPLAIN documentation
- Use The Index Luke (https://use-the-index-luke.com/)

----------------------------------------------------------------------

.. note::
   CHECKLIST FR QUERY SQL:
   
   - Query SQL completa y comentada linea por linea
   - Parametros bound documentados (prevenir SQL injection)
   - Validaciones de parametros implementadas
   - Indices requeridos especificados con CREATE INDEX
   - EXPLAIN ANALYZE output analizado
   - Optimizaciones documentadas con impacto medido
   - Tests unitarios de correctitud
   - Tests de performance con volumenes grandes
   - Metricas de performance: < 3s objetivo

----------------------------------------------------------------------

**Archivo:** TPL_FR_Query_SQL_1_3_0.rst  
**Version Template:** 1.3.0  
**Fecha Creacion Template:** 2026-01-11  
**Autor Template:** Sistema de Regeneracion IACT  
**Lineas Totales:** aproximadamente 700

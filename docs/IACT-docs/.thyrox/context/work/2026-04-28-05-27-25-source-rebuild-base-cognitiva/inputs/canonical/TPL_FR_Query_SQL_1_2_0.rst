.. meta::
   :Proyecto: IACT
   :Codigo: FR-XXX-YY-ZZ
   :Titulo: [Nombre - Query SQL]
   :Version: 1.0.0
   :Tipo: Query
   :Complejidad: [Baja|Media|Alta]

======================================================================
FR-XXX-YY-ZZ: [Nombre] (SQL Query)
======================================================================

**Tipo:** Query SQL  
**Complejidad:** [Baja|Media|Alta] (según JOINs, agregaciones)

----------------------------------------------------------------------
1. QUERY PRINCIPAL
----------------------------------------------------------------------

.. code-block:: sql

   -- FR-XXX-YY-ZZ: [Nombre del FR]
   -- Descripción: [Qué retorna este query]
   -- Complejidad: [N] JOINs, [M] WHERE, [P] GROUP BY
   -- Performance esperado: < [X] segundos
   -- Autor: [Nombre] Fecha: YYYY-MM-DD
   
   SELECT 
       -- Campos de tabla principal
       t1.id,
       t1.nombre,
       t1.fecha_creacion,
       
       -- Campos de tabla relacionada
       t2.descripcion as tipo_descripcion,
       
       -- Agregaciones
       COUNT(t3.id) as total_registros,
       SUM(t3.monto) as monto_total,
       AVG(t3.calificacion) as promedio_calificacion,
       
       -- Cálculos derivados
       CASE 
           WHEN COUNT(t3.id) > 100 THEN 'Alto'
           WHEN COUNT(t3.id) > 50 THEN 'Medio'
           ELSE 'Bajo'
       END as volumen_categoria,
       
       -- Subconsulta (si es necesaria)
       (
           SELECT MAX(fecha)
           FROM otra_tabla ot
           WHERE ot.tabla1_id = t1.id
       ) as ultima_actualizacion
   
   FROM tabla_principal t1
   
   -- INNER JOIN: Solo registros que existen en ambas tablas
   INNER JOIN tabla_tipos t2
       ON t1.tipo_id = t2.id
   
   -- LEFT JOIN: Incluir t1 aunque no tenga t3
   LEFT JOIN tabla_detalles t3
       ON t1.id = t3.tabla1_id
       AND t3.deleted_at IS NULL  -- Filtrar soft-deleted
   
   WHERE 
       -- Filtros de fecha
       t1.fecha_creacion BETWEEN :fecha_inicio AND :fecha_fin
       
       -- Filtros de estado
       AND t1.status = :status
       
       -- Excluir eliminados (soft delete pattern)
       AND t1.deleted_at IS NULL
       
       -- Filtro condicional (si parámetro presente)
       AND (:segmento IS NULL OR t1.segmento = :segmento)
   
   GROUP BY 
       t1.id,
       t1.nombre,
       t1.fecha_creacion,
       t2.descripcion
   
   HAVING 
       -- Filtrar después de agregación
       COUNT(t3.id) > :threshold_minimo
   
   ORDER BY 
       monto_total DESC,
       t1.fecha_creacion DESC
   
   LIMIT :page_size 
   OFFSET :offset;

**Ejemplo Concreto (Reportes IACT):**

.. code-block:: sql

   -- FR-RPT-01-05: Query Consolidado Trimestral
   -- Retorna métricas agregadas de llamadas IVR
   
   SELECT 
       c.quarter,
       c.year,
       c.segment,
       s.segment_name,
       
       -- Métricas básicas
       COUNT(c.id) as total_calls,
       COUNT(c.id) FILTER (WHERE c.status = 'COMPLETED') as completed_calls,
       COUNT(c.id) FILTER (WHERE c.status = 'ABANDONED') as abandoned_calls,
       
       -- Tasa de abandono (BR-IACT-053)
       ROUND(
           COUNT(c.id) FILTER (WHERE c.status = 'ABANDONED')::NUMERIC / 
           NULLIF(COUNT(c.id), 0) * 100,
           2
       ) as abandon_rate,
       
       -- Duración promedio
       AVG(c.duration_seconds) as avg_duration,
       
       -- Comparación trimestre anterior
       LAG(COUNT(c.id)) OVER (
           PARTITION BY c.segment 
           ORDER BY c.year, c.quarter
       ) as prev_quarter_calls
   
   FROM ivr_calls c
   
   INNER JOIN segments s
       ON c.segment = s.code
   
   WHERE 
       c.quarter = :quarter
       AND c.year = :year
       AND (:segment IS NULL OR c.segment = :segment)
       AND c.deleted_at IS NULL
   
   GROUP BY 
       c.quarter,
       c.year,
       c.segment,
       s.segment_name
   
   ORDER BY 
       total_calls DESC;

----------------------------------------------------------------------
2. PARAMETROS BOUND
----------------------------------------------------------------------

**Tabla de Parámetros:**

.. list-table::
   :header-rows: 1
   :widths: 20 15 10 15 40

   * - Parámetro
     - Tipo
     - Req.
     - Default
     - Descripción
   * - :fecha_inicio
     - DATE
     - Sí
     - -
     - Fecha inicio del rango
   * - :fecha_fin
     - DATE
     - Sí
     - -
     - Fecha fin del rango
   * - :status
     - VARCHAR(20)
     - Sí
     - 'ACTIVE'
     - Estado del registro
   * - :segmento
     - VARCHAR(20)
     - No
     - NULL
     - Filtro opcional por segmento
   * - :page_size
     - INTEGER
     - No
     - 25
     - Registros por página
   * - :offset
     - INTEGER
     - No
     - 0
     - Offset para paginación

**Binding en Python:**

.. code-block:: python

   params = {
       'fecha_inicio': '2024-01-01',
       'fecha_fin': '2024-03-31',
       'status': 'ACTIVE',
       'segmento': 'OP',  # o None
       'page_size': 25,
       'offset': 0
   }
   
   result = session.execute(query, params)

----------------------------------------------------------------------
3. INDICES REQUERIDOS
----------------------------------------------------------------------

**Para Optimizar WHERE:**

.. code-block:: sql

   -- Índice compuesto para rango de fechas + filtros
   CREATE INDEX idx_tabla_fecha_status
   ON tabla_principal(fecha_creacion, status)
   WHERE deleted_at IS NULL;
   
   -- Índice para segmento (si usado frecuentemente)
   CREATE INDEX idx_tabla_segmento
   ON tabla_principal(segmento)
   WHERE deleted_at IS NULL AND status = 'ACTIVE';

**Para Optimizar JOINs:**

.. code-block:: sql

   -- Índice en FK
   CREATE INDEX idx_tabla_detalles_fk
   ON tabla_detalles(tabla1_id)
   WHERE deleted_at IS NULL;

**Para Optimizar ORDER BY:**

.. code-block:: sql

   -- Si se ordena frecuentemente por monto
   CREATE INDEX idx_detalles_monto
   ON tabla_detalles(monto DESC);

**Ejemplo IACT:**

.. code-block:: sql

   -- Índice principal para queries trimestrales
   CREATE INDEX idx_calls_quarter_year_segment
   ON ivr_calls(quarter, year, segment)
   WHERE deleted_at IS NULL;
   
   -- Índice para filtros de status
   CREATE INDEX idx_calls_status
   ON ivr_calls(status)
   INCLUDE (duration_seconds);

----------------------------------------------------------------------
4. EXPLAIN PLAN
----------------------------------------------------------------------

**Ejecutar Análisis:**

.. code-block:: sql

   EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
   SELECT ... [query completo];

**Resultado Esperado (simplificado):**

.. code-block:: text

   QUERY PLAN
   ──────────────────────────────────────────────────────────
   Limit  (cost=145.32..145.57 rows=25 width=120) 
          (actual time=2.451..2.458 rows=25 loops=1)
     ->  Sort  (cost=145.32..147.82 rows=1000 width=120)
               (actual time=2.450..2.454 rows=25 loops=1)
           Sort Key: monto_total DESC
           ->  Hash Join  (cost=65.00..95.50 rows=1000)
                         (actual time=1.234..2.123 rows=1000)
                 Hash Cond: (t1.tipo_id = t2.id)
                 ->  Index Scan using idx_tabla_fecha_status
                                       (actual time=0.050..0.850)
                       Index Cond: (fecha BETWEEN '...' AND '...')
   
   Planning Time: 0.521 ms
   Execution Time: 2.512 ms

**Interpretación:**

- **Execution Time:** 2.5 ms ✅ (< 5 seg target)
- **Usa índices:** idx_tabla_fecha_status ✅
- **No hay Seq Scan:** ✅ (bueno)
- **Rows estimado vs actual:** ~igual ✅

----------------------------------------------------------------------
5. PERFORMANCE ANALYSIS
----------------------------------------------------------------------

**Complejidad Estimada:**

- **Big O:** O(n log n) por el ORDER BY
- **Peor caso:** O(n * m) si JOINs sin índices
- **Mejor caso:** O(log n) con índices óptimos

**Benchmarks:**

.. list-table::
   :header-rows: 1
   :widths: 30 20 20 30

   * - Volumen Datos
     - Tiempo Esperado
     - Tiempo Máximo
     - Acción si Excede
   * - < 1,000 registros
     - < 100 ms
     - 500 ms
     - Nada
   * - 1,000-10,000
     - < 1 seg
     - 3 seg
     - WARNING en log
   * - 10,000-100,000
     - < 3 seg
     - 10 seg
     - Require approval
   * - > 100,000
     - N/A
     - N/A
     - Rechazar query

**Optimizaciones Aplicadas:**

1. **Índices Compuestos:** Cubren WHERE + JOIN
2. **INCLUDE Columns:** Evitar table lookup
3. **Filtered Index:** WHERE deleted_at IS NULL
4. **Partition by Date:** Si tabla muy grande
5. **Materialized View:** Para queries muy frecuentes

----------------------------------------------------------------------
CODIGO PYTHON COMPLETO
----------------------------------------------------------------------

.. code-block:: python

   from sqlalchemy import text
   import logging
   
   logger = logging.getLogger(__name__)
   
   def execute_quarterly_report_query(quarter, year, segment=None):
       """
       Implements FR-RPT-01-05: Query Consolidado Trimestral
       
       Args:
           quarter (str): Q1, Q2, Q3, Q4
           year (int): 2020-2025
           segment (str, optional): OP, MG, AD
       
       Returns:
           list: Resultados del query
       
       Raises:
           QueryTimeoutError: Si excede 5 segundos
       """
       query_sql = text("""
           SELECT 
               c.quarter,
               c.year,
               c.segment,
               COUNT(c.id) as total_calls,
               COUNT(*) FILTER (WHERE c.status = 'ABANDONED') 
                   as abandoned_calls,
               ROUND(
                   COUNT(*) FILTER (WHERE c.status = 'ABANDONED')::NUMERIC / 
                   NULLIF(COUNT(c.id), 0) * 100,
                   2
               ) as abandon_rate
           FROM ivr_calls c
           WHERE c.quarter = :quarter
             AND c.year = :year
             AND (:segment IS NULL OR c.segment = :segment)
             AND c.deleted_at IS NULL
           GROUP BY c.quarter, c.year, c.segment
           ORDER BY total_calls DESC
       """)
       
       params = {
           'quarter': quarter,
           'year': year,
           'segment': segment
       }
       
       try:
           # Set timeout
           session.execute(text("SET statement_timeout = '5s'"))
           
           # Execute query
           start_time = time.time()
           result = session.execute(query_sql, params)
           duration = time.time() - start_time
           
           rows = result.fetchall()
           
           logger.info(
               f"Query executed successfully. "
               f"Params: {params}, Rows: {len(rows)}, "
               f"Duration: {duration:.3f}s"
           )
           
           return [dict(row) for row in rows]
       
       except Exception as e:
           logger.error(
               f"Query failed. Params: {params}, Error: {str(e)}"
           )
           raise

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

- STD_001_Estandares_Documentacion_1_1_0.rst
- PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md

**PostgreSQL Documentation:**
- Indexes: https://postgresql.org/docs/current/indexes.html
- EXPLAIN: https://postgresql.org/docs/current/sql-explain.html

**Archivo:** TPL_FR_Query_SQL_1_2_0.rst  
**Líneas:** ~340


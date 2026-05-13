.. meta::
   :Proyecto: IACT
   :Codigo: FR-XXX-YY-ZZ
   :Tipo: Query
   :Version: 1.0.0

======================================================================
FR-XXX-YY-ZZ: [Consulta SQL]
======================================================================

QUERY PRINCIPAL
~~~~~~~~~~~~~~~

.. code-block:: sql

   SELECT 
       t1.id,
       t1.nombre,
       t2.valor,
       COUNT(t3.id) as total
   FROM tabla1 t1
   INNER JOIN tabla2 t2 ON t1.id = t2.tabla1_id
   LEFT JOIN tabla3 t3 ON t1.id = t3.tabla1_id
   WHERE t1.fecha BETWEEN :fecha_inicio AND :fecha_fin
     AND t1.status = :status
   GROUP BY t1.id, t1.nombre, t2.valor
   HAVING COUNT(t3.id) > :min_count
   ORDER BY total DESC
   LIMIT :limit OFFSET :offset

PARAMETROS BOUND
~~~~~~~~~~~~~~~~

:fecha_inicio - DATE
:fecha_fin - DATE
:status - VARCHAR(20)
:min_count - INTEGER
:limit - INTEGER
:offset - INTEGER

INDICES REQUERIDOS
~~~~~~~~~~~~~~~~~~

.. code-block:: sql

   CREATE INDEX idx_tabla1_fecha 
   ON tabla1(fecha, status);
   
   CREATE INDEX idx_tabla2_fk 
   ON tabla2(tabla1_id);

ANALISIS PERFORMANCE
~~~~~~~~~~~~~~~~~~~~

Complejidad: O(n log n)
Estimado: < 2 seg para 100K registros
Explain Plan: [Adjuntar]

**Archivo:** TPL_FR_Query_SQL_1_1_0.rst
**Version:** 1.1.0

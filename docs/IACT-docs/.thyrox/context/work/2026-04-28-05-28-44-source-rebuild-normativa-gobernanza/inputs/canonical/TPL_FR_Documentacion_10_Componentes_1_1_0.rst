.. meta::
   :Proyecto: IACT
   :Codigo: FR-XXX-YY-ZZ
   :Titulo: [Nombre del FR]
   :Version: 1.0.0

======================================================================
FR-XXX-YY-ZZ: [Nombre Descriptivo del FR]
======================================================================

**10 COMPONENTES ESTANDAR (PARTE_4)**

1. DERIVADO DE
~~~~~~~~~~~~~~
**UC:** UC-IACT-XXX-YY paso N
**BR:** BR-IACT-XXX (si aplica)

2. DESCRIPCION
~~~~~~~~~~~~~~
[Qué hace este FR en 2-3 oraciones]

3. CONSULTA SQL
~~~~~~~~~~~~~~~

.. code-block:: sql

   SELECT 
       campo1,
       campo2,
       COUNT(*) as total
   FROM tabla
   WHERE condicion = :param
   GROUP BY campo1, campo2
   HAVING COUNT(*) > :threshold
   ORDER BY total DESC
   LIMIT :limit

4. PARAMETROS
~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   
   * - Parámetro
     - Tipo
     - Obligatorio
     - Descripción
   * - param1
     - INTEGER
     - Sí
     - [Descripción]
   * - param2
     - VARCHAR(100)
     - No
     - [Descripción]

5. OUTPUT
~~~~~~~~~

**Tipo Retorno:** List[Dict]

**Estructura:**

.. code-block:: json

   [
     {
       "campo1": "valor",
       "campo2": 123,
       "total": 456
     }
   ]

6. VALIDACIONES
~~~~~~~~~~~~~~~

V-1: param1 > 0
V-2: param2 longitud <= 100
V-3: Resultado < 1000 filas

7. TIMEOUT
~~~~~~~~~~

Máximo: 5 segundos
Acción si excede: Cancelar query

8. MANEJO DE ERRORES
~~~~~~~~~~~~~~~~~~~~

Error DB Connection:
- Reintentar 3 veces
- Log ERROR
- Retornar exception

9. LOGS
~~~~~~~

Nivel INFO:
- Parámetros recibidos
- Filas retornadas
- Tiempo ejecución

Nivel ERROR:
- Timeout
- Exception SQL

10. TESTS
~~~~~~~~~

.. code-block:: python

   def test_fr_xxx_caso_normal():
       result = execute_fr(param1=10, param2='test')
       assert len(result) > 0
       assert result[0]['total'] == 100

**Archivo:** TPL_FR_Documentacion_10_Componentes_1_1_0.rst
**Version:** 1.1.0

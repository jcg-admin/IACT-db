.. meta::
   :Proyecto: IACT
   :Codigo: FR-XXX-YY-ZZ
   :Titulo: [Nombre del Functional Requirement]
   :Version: 1.0.0
   :Tipo: [Query|Validacion|Calculo|UI|Integracion]
   :Modulo: [MOD]
   :Fecha: YYYY-MM-DD
   :Autor: [Nombre Dev]

======================================================================
FR-XXX-YY-ZZ: [Nombre Descriptivo del FR]
======================================================================

**Proyecto:** IACT  
**Tipo:** [Query|Validacion|Calculo|UI|Integracion]  
**Complejidad:** [Baja|Media|Alta]

----------------------------------------------------------------------
INTRODUCCION: LOS 10 COMPONENTES ESTANDAR
----------------------------------------------------------------------

Este template implementa el estándar de **10 Componentes** para
documentación de Functional Requirements (PARTE_4).

**Los 10 Componentes Obligatorios:**

1. **DERIVADO DE** - Trazabilidad backward (UC/BR padre)
2. **DESCRIPCION** - Qué hace este FR
3. **CONSULTA SQL** - Query principal (si aplica)
4. **PARAMETROS** - Inputs del FR
5. **OUTPUT** - Tipo y estructura del retorno
6. **VALIDACIONES** - Reglas V-1, V-2, V-3...
7. **TIMEOUT** - Tiempo máximo de ejecución
8. **MANEJO DE ERRORES** - Try-catch, logging, retry
9. **LOGS** - Qué se loguea y en qué nivel
10. **TESTS** - Tests unitarios e integración

**Importancia:**

Cada componente responde una pregunta crítica para implementación
y mantenimiento del FR.

----------------------------------------------------------------------
1. DERIVADO DE (Backward Traceability)
----------------------------------------------------------------------

**UC Padre:** UC-IACT-XXX-YY: [Nombre del UC]

**Paso Específico:** Paso N del flujo normal (o FA-N, FE-N)

**BR Implementada:** BR-IACT-ZZZ: [Nombre de BR] (si aplica)

**Justificación:**

Este FR deriva del [paso N] del UC porque se requiere [explicación
breve de por qué este FR es necesario].

**Ejemplo:**

UC Padre: UC-IACT-RPT-01: Consultar Reporte Trimestral

Paso: Paso 6 del flujo normal

BR: BR-IACT-053: Cálculo de Tasa de Abandono

Justificación:
Este FR deriva del paso 6 porque se necesita calcular COUNT de
registros ANTES de ejecutar el SELECT principal, para verificar
que no se excedan 10,000 registros (BR-IACT-028).

----------------------------------------------------------------------
2. DESCRIPCION
----------------------------------------------------------------------

**¿Qué hace este FR?**

[Descripción en 2-3 oraciones de QUÉ hace este FR, sin detalles
técnicos de CÓMO lo hace]

**Input Esperado:**

[Breve descripción de qué datos recibe]

**Output Esperado:**

[Breve descripción de qué retorna]

**Responsabilidad Principal:**

[Una sola oración describiendo la responsabilidad core]

**Ejemplo:**

Qué hace:
Calcula el número total de registros que retornaría una consulta
de reportes trimestrales, sin ejecutar el SELECT principal.
Permite verificar umbral ANTES de ejecutar query costosa.

Input:
Parámetros de búsqueda: quarter, year, segment

Output:
Entero (count de registros que cumplen criterios)

Responsabilidad:
Ejecutar COUNT(*) con parámetros dados y retornar total.

----------------------------------------------------------------------
3. CONSULTA SQL (si aplica)
----------------------------------------------------------------------

**Nota:** Si este FR NO involucra SQL, marcar como "N/A" y pasar
al componente 4.

**Query Principal:**

.. code-block:: sql

   -- FR-XXX-YY-ZZ: [Nombre del FR]
   -- Descripción: [Qué hace este query]
   -- Autor: [Nombre] Fecha: YYYY-MM-DD
   
   SELECT 
       columna1,
       columna2,
       COUNT(*) as total,
       SUM(campo_numerico) as suma_total,
       AVG(campo_numerico) as promedio
   FROM tabla_principal tp
   INNER JOIN tabla_relacionada tr
       ON tp.id = tr.tabla_principal_id
   LEFT JOIN tabla_opcional to
       ON tp.id = to.tabla_principal_id
   WHERE tp.fecha BETWEEN :fecha_inicio AND :fecha_fin
     AND tp.status = :status
     AND tp.deleted_at IS NULL
   GROUP BY columna1, columna2
   HAVING COUNT(*) > :threshold
   ORDER BY total DESC, promedio ASC
   LIMIT :limit OFFSET :offset

**Índices Sugeridos:**

.. code-block:: sql

   -- Para mejorar performance de WHERE
   CREATE INDEX idx_tabla_fecha_status 
   ON tabla_principal(fecha, status) 
   WHERE deleted_at IS NULL;
   
   -- Para JOIN eficiente
   CREATE INDEX idx_tabla_rel_fk 
   ON tabla_relacionada(tabla_principal_id);

**Ejemplo Específico (FR-RPT-01-07):**

.. code-block:: sql

   -- FR-RPT-01-07: Calcular Count de Registros
   -- Retorna número de llamadas que cumplen criterios
   -- sin ejecutar SELECT completo
   
   SELECT COUNT(*) as record_count
   FROM ivr_calls
   WHERE quarter = :quarter
     AND year = :year
     AND segment = :segment
     AND deleted_at IS NULL

**Índices:**

.. code-block:: sql

   CREATE INDEX idx_calls_quarter_year_segment
   ON ivr_calls(quarter, year, segment)
   WHERE deleted_at IS NULL;

----------------------------------------------------------------------
4. PARAMETROS (Inputs)
----------------------------------------------------------------------

**Tabla de Parámetros:**

.. list-table::
   :header-rows: 1
   :widths: 20 15 10 15 40

   * - Parámetro
     - Tipo
     - Oblig.
     - Valor Default
     - Descripción
   * - :param1
     - VARCHAR(50)
     - Sí
     - -
     - [Descripción detallada]
   * - :param2
     - INTEGER
     - Sí
     - -
     - [Descripción]
   * - :param3
     - DATE
     - No
     - NOW()
     - [Descripción]
   * - :param4
     - BOOLEAN
     - No
     - FALSE
     - [Descripción]

**Restricciones de Parámetros:**

- param1: Debe estar en conjunto {valor1, valor2, valor3}
- param2: Rango [min, max]
- param3: No puede ser fecha futura
- param4: Si TRUE, entonces param5 es obligatorio

**Ejemplo (FR-RPT-01-07):**

.. list-table::
   :header-rows: 1
   :widths: 20 15 10 15 40

   * - Parámetro
     - Tipo
     - Oblig.
     - Default
     - Descripción
   * - :quarter
     - VARCHAR(2)
     - Sí
     - -
     - Trimestre: Q1, Q2, Q3, Q4
   * - :year
     - INTEGER
     - Sí
     - -
     - Año entre 2020 y 2025
   * - :segment
     - VARCHAR(20)
     - Sí
     - -
     - Segmento: OP, MG, AD

Restricciones:
- quarter ∈ {'Q1', 'Q2', 'Q3', 'Q4'}
- year ∈ [2020..2025]
- segment ∈ {'OP', 'MG', 'AD'}

----------------------------------------------------------------------
5. OUTPUT (Resultado)
----------------------------------------------------------------------

**Tipo de Retorno:** [List|Dict|Integer|String|Boolean|Object]

**Estructura del Output:**

Para queries que retornan múltiples filas:

.. code-block:: json

   [
     {
       "campo1": "valor1",
       "campo2": 123,
       "campo3": "2024-01-15",
       "total": 456
     },
     {
       "campo1": "valor2",
       "campo2": 789,
       "campo3": "2024-01-16",
       "total": 234
     }
   ]

Para queries que retornan valor único:

.. code-block:: json

   {
     "record_count": 10500
   }

**Propiedades del Output:**

- **Tipo:** [INTEGER|DECIMAL|VARCHAR|JSON|etc]
- **Rango esperado:** [min, max] o descripción
- **Null permitido:** [Sí|No]
- **Formato especial:** [ISO 8601 para fechas, etc]

**Ejemplo (FR-RPT-01-07):**

Tipo: Integer

Estructura:

.. code-block:: json

   {
     "record_count": 10500
   }

Propiedades:
- Tipo: INTEGER
- Rango: 0 a infinito (no puede ser negativo)
- Null: NO (siempre retorna entero, mínimo 0)

----------------------------------------------------------------------
6. VALIDACIONES
----------------------------------------------------------------------

**Reglas de Validación:**

V-1: [Nombre de la validación]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** [Qué se valida]

**Condición:**

.. code-block:: python

   if not condicion:
       raise ValidationError("Mensaje")

**Mensaje de Error:** "[Texto exacto del error]"

**Ejemplo:**

.. code-block:: python

   # V-1: Quarter debe estar en conjunto válido
   if quarter not in ['Q1', 'Q2', 'Q3', 'Q4']:
       raise ValidationError(
           f"Quarter '{quarter}' inválido. "
           f"Debe ser: Q1, Q2, Q3, Q4"
       )

V-2: [Otra validación]
~~~~~~~~~~~~~~~~~~~~~~

**Descripción:** [...]

**Código:**

.. code-block:: python

   if valor < min_value or valor > max_value:
       raise ValidationError(
           f"Valor {valor} fuera de rango [{min_value}, {max_value}]"
       )

**Ejemplo Completo (FR-RPT-01-07):**

V-1: Quarter válido
~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   VALID_QUARTERS = ['Q1', 'Q2', 'Q3', 'Q4']
   if quarter not in VALID_QUARTERS:
       raise ValidationError(
           f"Quarter '{quarter}' inválido. Valores permitidos: {VALID_QUARTERS}"
       )

V-2: Year en rango
~~~~~~~~~~~~~~~~~~

.. code-block:: python

   MIN_YEAR = 2020
   MAX_YEAR = 2025
   
   if not isinstance(year, int):
       raise ValidationError("Year debe ser entero")
   
   if year < MIN_YEAR or year > MAX_YEAR:
       raise ValidationError(
           f"Year {year} fuera de rango [{MIN_YEAR}, {MAX_YEAR}]"
       )

V-3: Segment válido
~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   VALID_SEGMENTS = ['OP', 'MG', 'AD']
   if segment not in VALID_SEGMENTS:
       raise ValidationError(
           f"Segment '{segment}' inválido. Valores permitidos: {VALID_SEGMENTS}"
       )

----------------------------------------------------------------------
7. TIMEOUT
----------------------------------------------------------------------

**Tiempo Máximo de Ejecución:** [N] segundos

**Razón del Timeout:**

[Explicación de por qué este tiempo es adecuado]

**Acción si se Excede Timeout:**

1. [Primera acción]
2. [Segunda acción]
3. [Tercera acción]

**Configuración:**

.. code-block:: python

   QUERY_TIMEOUT = 5  # segundos
   
   @timeout(seconds=QUERY_TIMEOUT)
   def execute_query(...):
       # código del FR

O en SQL:

.. code-block:: sql

   SET statement_timeout = '5s';
   
   SELECT COUNT(*) FROM ...;

**Ejemplo (FR-RPT-01-07):**

Tiempo Máximo: 2 segundos

Razón:
COUNT(*) debe ser rápido. Si tarda >2 seg, indica:
- Índices faltantes
- Volumen de datos excesivo
- Query mal optimizado

Acción si excede:

1. Cancelar query (no esperar más)
2. Registrar WARNING en log con parámetros
3. Retornar excepción TimeoutError al cliente
4. Alertar a equipo técnico (si es recurrente)

Código:

.. code-block:: python

   import signal
   
   def timeout_handler(signum, frame):
       raise TimeoutError("Query exceeded 2 seconds")
   
   signal.signal(signal.SIGALRM, timeout_handler)
   signal.alarm(2)  # 2 segundos
   
   try:
       result = execute_count_query(quarter, year, segment)
       signal.alarm(0)  # Cancelar alarma
       return result
   except TimeoutError:
       logger.warning(
           f"COUNT query timeout. Params: {quarter}, {year}, {segment}"
       )
       raise

----------------------------------------------------------------------
8. MANEJO DE ERRORES
----------------------------------------------------------------------

**Estrategia de Error Handling:**

1. **Try-Catch Específico**
   - Capturar excepciones específicas
   - NO usar except genérico

2. **Logging Detallado**
   - Registrar contexto completo
   - Incluir stack trace si es crítico

3. **Retry Logic**
   - Reintentar operaciones transitorias
   - Backoff exponencial

4. **Error Propagation**
   - Lanzar excepciones custom
   - Cliente decide qué hacer

**Código Patrón:**

.. code-block:: python

   import logging
   from tenacity import retry, stop_after_attempt, wait_exponential
   
   logger = logging.getLogger(__name__)
   
   @retry(
       stop=stop_after_attempt(3),
       wait=wait_exponential(multiplier=1, min=1, max=10)
   )
   def execute_fr_xxx(params):
       """
       Implements FR-XXX-YY-ZZ with error handling
       """
       try:
           # Validar parámetros
           validate_params(params)
           
           # Ejecutar lógica principal
           result = perform_operation(params)
           
           return result
       
       except ValidationError as e:
           # Error de validación (no reintentar)
           logger.warning(f"Validation failed: {e}")
           raise
       
       except DatabaseConnectionError as e:
           # Error de conexión (reintentar)
           logger.error(f"DB connection failed: {e}. Retrying...")
           raise  # Tenacity reintentará
       
       except TimeoutError as e:
           # Timeout (no reintentar, escalar)
           logger.error(f"Operation timeout: {e}")
           send_alert_to_team(f"Timeout in FR-XXX: {params}")
           raise
       
       except Exception as e:
           # Error inesperado (loguear y escalar)
           logger.exception(f"Unexpected error in FR-XXX: {e}")
           raise RuntimeError(f"FR-XXX failed: {str(e)}") from e

**Ejemplo (FR-RPT-01-07):**

.. code-block:: python

   from psycopg2 import OperationalError, DatabaseError
   
   def calculate_record_count(quarter, year, segment):
       """FR-RPT-01-07: Calculate record count"""
       try:
           # Validaciones
           validate_quarter(quarter)
           validate_year(year)
           validate_segment(segment)
           
           # Ejecutar query con timeout
           with timeout(seconds=2):
               result = db.execute("""
                   SELECT COUNT(*) FROM ivr_calls
                   WHERE quarter = %s AND year = %s AND segment = %s
               """, (quarter, year, segment))
           
           count = result[0]['count']
           
           logger.info(
               f"Count calculated successfully. "
               f"Params: Q={quarter}, Y={year}, S={segment}, Count={count}"
           )
           
           return count
       
       except ValidationError as e:
           logger.warning(f"Invalid parameters: {e}")
           raise
       
       except TimeoutError:
           logger.error(
               f"COUNT query timeout. Q={quarter}, Y={year}, S={segment}"
           )
           raise
       
       except (OperationalError, DatabaseError) as e:
           logger.error(f"Database error: {e}")
           raise DatabaseAccessError("Could not access database") from e
       
       except Exception as e:
           logger.exception(f"Unexpected error in FR-RPT-01-07: {e}")
           raise

----------------------------------------------------------------------
9. LOGS
----------------------------------------------------------------------

**Niveles de Log:**

- **DEBUG:** Detalles técnicos para debugging
- **INFO:** Ejecución normal exitosa
- **WARNING:** Situación anómala pero manejada
- **ERROR:** Error que impide operación
- **CRITICAL:** Error grave que afecta sistema

**Qué se Loguea:**

**Nivel INFO (ejecución normal):**

.. code-block:: python

   logger.info(
       f"FR-XXX-YY-ZZ executed successfully. "
       f"Params: {params}, Result: {result}, Duration: {duration}ms"
   )

**Nivel WARNING (situaciones anómalas):**

.. code-block:: python

   logger.warning(
       f"FR-XXX-YY-ZZ: Unusual condition. "
       f"Count={count} exceeds expected range [0, 1000]"
   )

**Nivel ERROR (fallos):**

.. code-block:: python

   logger.error(
       f"FR-XXX-YY-ZZ failed. "
       f"Params: {params}, Error: {str(e)}, "
       f"User: {user_id}, Timestamp: {datetime.now()}"
   )

**Formato de Log Estructurado:**

.. code-block:: python

   import logging
   import json
   from datetime import datetime
   
   class StructuredLogger:
       def log_fr_execution(self, fr_id, params, result, duration):
           log_entry = {
               'timestamp': datetime.now().isoformat(),
               'fr_id': fr_id,
               'params': params,
               'result_summary': {
                   'count': len(result) if isinstance(result, list) else 1,
                   'success': True
               },
               'duration_ms': duration,
               'level': 'INFO'
           }
           logger.info(json.dumps(log_entry))

**Ejemplo (FR-RPT-01-07):**

INFO - Ejecución exitosa:

.. code-block:: python

   logger.info(
       f"FR-RPT-01-07: Count calculated. "
       f"Quarter={quarter}, Year={year}, Segment={segment}, "
       f"Count={count}, Duration={duration}ms"
   )

WARNING - Count alto:

.. code-block:: python

   if count > 10000:
       logger.warning(
           f"FR-RPT-01-07: High count detected. "
           f"Count={count} exceeds threshold 10000. "
           f"Params: {quarter}, {year}, {segment}"
       )

ERROR - Query falló:

.. code-block:: python

   logger.error(
       f"FR-RPT-01-07: Query failed. "
       f"Error: {str(e)}, Params: {quarter}/{year}/{segment}, "
       f"User: {user_id}, StackTrace: {traceback.format_exc()}"
   )

----------------------------------------------------------------------
10. TESTS
----------------------------------------------------------------------

**Test Unitario - Caso Normal:**

.. code-block:: python

   import pytest
   from unittest.mock import Mock, patch
   
   def test_fr_xxx_caso_normal():
       """
       Test FR-XXX-YY-ZZ: Caso normal de ejecución
       
       Given: Parámetros válidos
       When: Se ejecuta el FR
       Then: Retorna resultado esperado
       """
       # Arrange
       params = {
           'param1': 'valor_valido',
           'param2': 123,
           'param3': '2024-01-15'
       }
       expected_result = {'count': 100}
       
       # Act
       result = execute_fr_xxx(params)
       
       # Assert
       assert result == expected_result
       assert result['count'] > 0

**Test Unitario - Validación Falla:**

.. code-block:: python

   def test_fr_xxx_validacion_falla():
       """Test validación de parámetros inválidos"""
       params = {
           'param1': 'valor_invalido',  # No está en conjunto válido
           'param2': -1  # Negativo no permitido
       }
       
       with pytest.raises(ValidationError) as exc_info:
           execute_fr_xxx(params)
       
       assert "inválido" in str(exc_info.value).lower()

**Test de Integración:**

.. code-block:: python

   def test_fr_xxx_integracion_con_db():
       """
       Test de integración con base de datos real
       """
       # Arrange: Preparar datos de prueba
       setup_test_data()
       
       params = {'quarter': 'Q1', 'year': 2024, 'segment': 'OP'}
       
       # Act: Ejecutar contra DB real (test)
       result = execute_fr_xxx(params)
       
       # Assert
       assert isinstance(result, int)
       assert result >= 0
       
       # Cleanup
       teardown_test_data()

**Ejemplo Completo (FR-RPT-01-07):**

.. code-block:: python

   # tests/test_fr_rpt_01_07.py
   
   import pytest
   from app.reports.fr_rpt_01_07 import calculate_record_count
   from app.exceptions import ValidationError
   
   class TestFR_RPT_01_07:
       
       def test_caso_normal(self, db_session):
           """Test caso normal con parámetros válidos"""
           # Given
           quarter = 'Q1'
           year = 2024
           segment = 'OP'
           
           # When
           count = calculate_record_count(quarter, year, segment)
           
           # Then
           assert isinstance(count, int)
           assert count >= 0
       
       def test_quarter_invalido(self):
           """Test validación de quarter inválido"""
           with pytest.raises(ValidationError) as exc:
               calculate_record_count('Q5', 2024, 'OP')
           
           assert "Quarter 'Q5' inválido" in str(exc.value)
       
       def test_year_fuera_rango(self):
           """Test validación de año fuera de rango"""
           with pytest.raises(ValidationError):
               calculate_record_count('Q1', 2030, 'OP')
       
       def test_segment_invalido(self):
           """Test validación de segmento inválido"""
           with pytest.raises(ValidationError):
               calculate_record_count('Q1', 2024, 'INVALID')
       
       @pytest.mark.slow
       def test_performance(self, db_session):
           """Test que query termina en <2 segundos"""
           import time
           
           start = time.time()
           count = calculate_record_count('Q1', 2024, 'OP')
           duration = time.time() - start
           
           assert duration < 2.0, f"Query took {duration}s (max 2s)"
       
       def test_count_cero(self, db_session):
           """Test con parámetros que retornan 0 registros"""
           # Usar year futuro que no tiene datos
           count = calculate_record_count('Q4', 2025, 'OP')
           assert count == 0

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estándares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagógico:**

- PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md (Los 10 Componentes)

**Herramientas:**

- pytest: https://pytest.org
- tenacity: https://tenacity.readthedocs.io (retry logic)
- logging: https://docs.python.org/3/library/logging.html

----------------------------------------------------------------------

**Archivo:** TPL_FR_Documentacion_10_Componentes_1_2_0.rst  
**Version Template:** 1.2.0  
**Fecha:** 2026-01-09  
**Líneas:** ~600


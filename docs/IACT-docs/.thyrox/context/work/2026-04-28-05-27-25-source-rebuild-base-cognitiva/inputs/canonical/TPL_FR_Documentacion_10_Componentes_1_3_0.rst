.. meta::
   :Proyecto: IACT
   :Codigo: FR-MOD-NN-ZZ
   :Titulo: Titulo Descriptivo del Functional Requirement
   :Version: 1.0.0
   :Derivado_De: UC-IACT-MOD-NN paso X
   :Tipo: Query|INSERT|UPDATE|DELETE|Validacion|Calculo|UI
   :Fecha: YYYY-MM-DD
   :Autor: Nombre del Developer/Analyst
   :Estado: DRAFT|REVIEW|APPROVED|IMPLEMENTED

======================================================================
FR-MOD-NN-ZZ: Titulo Descriptivo del Functional Requirement
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Derivado De:** UC-IACT-MOD-NN paso X  
**Tipo:** Query|INSERT|UPDATE|DELETE|Validacion|Calculo|UI  
**Estado:** DRAFT|REVIEW|APPROVED|IMPLEMENTED  
**Prioridad:** Alta|Media|Baja  
**Clasificacion:** C2 - INTERNAL

----------------------------------------------------------------------
INTRODUCCION AL TEMPLATE
----------------------------------------------------------------------

Este template documenta Functional Requirements utilizando el estandar
de 10 componentes obligatorios definido en PARTE_4 del material
pedagogico IACT.

**Que es un Functional Requirement:**

Un FR describe una funcionalidad especifica e implementable que el
sistema debe realizar. Se deriva directamente de pasos en Use Cases.

**Los 10 Componentes Obligatorios:**

1. DERIVADO DE: Trazabilidad backward (UC padre, paso, BR)
2. DESCRIPCION: Que hace el FR, inputs/outputs
3. CONSULTA SQL: Query completa con comentarios
4. PARAMETROS: Inputs del FR con tipos y validaciones
5. OUTPUT: Estructura de retorno
6. VALIDACIONES: Reglas de validacion V-1 a V-N
7. TIMEOUT: Tiempo maximo de ejecucion
8. MANEJO DE ERRORES: Try-catch, logging, retry
9. LOGS: Que loguear, niveles, formato
10. TESTS: Tests unitarios e integracion

**Por que 10 Componentes:**

Cada componente cubre un aspecto critico de la implementacion:

- Componentes 1-2: Contexto y objetivo
- Componentes 3-5: Especificacion tecnica
- Componentes 6-8: Robustez y confiabilidad
- Componentes 9-10: Observabilidad y verificacion

**Como Usar Este Template:**

1. Completar metadata al inicio
2. Llenar los 10 componentes en orden
3. Incluir codigo real, no pseudocodigo
4. Usar ejemplo concreto del dominio IACT
5. Validar nomenclatura antes de aprobar

----------------------------------------------------------------------
COMPONENTE 1: DERIVADO DE (Backward Traceability)
----------------------------------------------------------------------

**Proposito:**

Documentar de donde proviene este FR para mantener trazabilidad completa
desde Business Requirements hasta codigo.

**Use Case Padre:**

- UC ID: UC-IACT-MOD-NN-Nombre-4-0-0.rst
- Nombre: Nombre del Use Case
- Paso: Numero de paso del flujo normal que deriva este FR
- Descripcion del paso: Texto literal del paso

**Business Rule Implementada:**

Si este FR implementa una BR:

- BR ID: BR-IACT-XXX
- Nombre: Nombre de la BR
- Tipo: Restriccion|Calculo|Desencadenador|Inferencia|Definicion
- Como se implementa: Descripcion breve

Si NO implementa BR:

- Ningun BR directo, deriva solo de flujo de UC

**Contexto del Negocio:**

Por que es necesario este FR, que problema resuelve

**EJEMPLO COMPLETO (FR-RPT-01-07):**

**Use Case Padre:**

- UC ID: UC-IACT-RPT-01-Consultar-Reporte-Trimestral-4-0-0.rst
- Nombre: Consultar Reporte Trimestral
- Paso: 7
- Descripcion del paso:
  
  "Sistema ejecuta query principal de reporte para obtener metricas
  diarias de llamadas IVR agrupadas por fecha, con totales de llamadas
  completadas y abandonadas, y duracion promedio."

**Business Rule Implementada:**

Ningun BR directo.

Este FR es la implementacion del paso de consulta principal. La BR
relevante (BR-IACT-028 Aprobacion Consultas Grandes) se implementa
en pasos anteriores (5-6).

**Contexto:**

Este FR ejecuta la query principal que retorna los datos base del
reporte trimestral. Es el core del UC, el paso que realmente obtiene
los datos de metricas IVR desde la base de datos para su posterior
procesamiento y visualizacion.

Los datos retornados seran usados por FR posteriores para:
- Calcular metricas derivadas (tasa abandono)
- Generar graficos visuales
- Mostrar tabla de resultados

----------------------------------------------------------------------
COMPONENTE 2: DESCRIPCION
----------------------------------------------------------------------

**Que Hace Este FR:**

Descripcion concisa y clara de la funcionalidad en lenguaje natural

**Input Esperado:**

Lista de inputs que el FR recibe:

- Input 1: Tipo, descripcion
- Input 2: Tipo, descripcion
- Input N: Tipo, descripcion

**Output Esperado:**

Que retorna el FR:

- Tipo de retorno: Dataset|JSON|Boolean|Integer|String|None
- Estructura: Descripcion de la estructura
- Casos especiales: Que retorna si error, vacio, etc

**Precondiciones Tecnicas:**

Condiciones que deben cumplirse antes de ejecutar:

- Precondicion 1
- Precondicion 2

**EJEMPLO COMPLETO (FR-RPT-01-07):**

**Que Hace:**

Este FR ejecuta una query SQL compleja que obtiene metricas agregadas
de llamadas IVR para un periodo trimestral especifico, agrupadas por
dia, con calculos de totales de llamadas completadas y abandonadas,
y promedios de duracion.

**Input Esperado:**

- quarter: STRING, valores permitidos: Q1, Q2, Q3, Q4
- year: INTEGER, rango: 2020 a ano actual
- segment: STRING, valores permitidos: OP, MG

**Output Esperado:**

- Tipo: Dataset (lista de diccionarios)
- Estructura:

.. code-block:: python

   [
       {
           'dia': datetime.date,
           'total_llamadas': int,
           'completadas': int,
           'abandonadas': int,
           'duracion_promedio': float
       },
       ...
   ]

- Casos especiales:
  
  - Si no hay datos: Lista vacia []
  - Si error: Lanza QueryExecutionError
  - Si timeout: Lanza QueryTimeoutError

**Precondiciones Tecnicas:**

- Conexion a BD activa y estable
- Usuario de BD tiene permiso SELECT en tabla ivr_calls
- Parametros ya validados por FR-RPT-01-02
- Count ya evaluado por FR-RPT-01-04, menor o igual 10,000

----------------------------------------------------------------------
COMPONENTE 3: CONSULTA SQL
----------------------------------------------------------------------

**Proposito:**

Documentar la query SQL completa, optimizada y comentada que implementa
este FR.

**Consulta SQL Completa:**

.. code-block:: sql

   -- Comentarios explicativos
   -- de la query
   
   SELECT ...
   FROM ...
   WHERE ...
   GROUP BY ...
   ORDER BY ...

**Consideraciones de Performance:**

- Indices requeridos
- Estimated row count
- Complejidad: Simple|Media|Compleja
- Tiempo estimado de ejecucion

**Parametros Bound:**

Usar parametros bound (prepared statements) para evitar SQL injection:

- :param1
- :param2

**EJEMPLO COMPLETO (FR-RPT-01-07):**

**Consulta SQL:**

.. code-block:: sql

   -- Query Principal: Reporte Trimestral de Metricas IVR
   -- Obtiene metricas diarias agregadas para un trimestre especifico
   -- Agrupa por dia, calcula totales y promedios
   
   SELECT 
       -- Fecha agregada por dia
       DATE_TRUNC('day', call_date) as dia,
       
       -- Total de llamadas en el dia
       COUNT(*) as total_llamadas,
       
       -- Llamadas completadas (status = COMPLETED)
       SUM(CASE 
           WHEN status = 'COMPLETED' THEN 1 
           ELSE 0 
       END) as completadas,
       
       -- Llamadas abandonadas (status = ABANDONED)
       SUM(CASE 
           WHEN status = 'ABANDONED' THEN 1 
           ELSE 0 
       END) as abandonadas,
       
       -- Duracion promedio en segundos
       AVG(duration_seconds) as duracion_promedio
   
   FROM ivr_calls
   
   -- Filtros por parametros
   WHERE quarter = :quarter        -- Q1, Q2, Q3, Q4
     AND year = :year              -- 2020-2024
     AND segment = :segment        -- OP, MG
     AND deleted_at IS NULL        -- Excluir registros borrados
   
   -- Agrupar por dia para serie temporal
   GROUP BY DATE_TRUNC('day', call_date)
   
   -- Ordenar cronologicamente
   ORDER BY dia ASC

**Consideraciones de Performance:**

Indices requeridos:

.. code-block:: sql

   -- Indice compuesto para optimizar query
   CREATE INDEX idx_ivr_calls_quarter_year_segment 
   ON ivr_calls (quarter, year, segment, call_date)
   WHERE deleted_at IS NULL;
   
   -- Indice para status (usado en CASE)
   CREATE INDEX idx_ivr_calls_status 
   ON ivr_calls (status);

Metricas:
- Estimated rows: 1,000 - 10,000 por trimestre
- Complejidad: Media (GROUP BY, agregaciones)
- Tiempo estimado: 1-3 segundos con indices

Parametros bound:
- :quarter (STRING)
- :year (INTEGER)
- :segment (STRING)

----------------------------------------------------------------------
COMPONENTE 4: PARAMETROS
----------------------------------------------------------------------

**Proposito:**

Documentar todos los parametros de entrada del FR con tipos de datos,
validaciones y valores por defecto.

**Formato de Tabla:**

.. list-table::
   :header-rows: 1
   :widths: 20 15 10 20 35

   * - Parametro
     - Tipo
     - Obligatorio
     - Valores/Rango
     - Descripcion
   * - nombre_param
     - STRING
     - SI
     - valores permitidos
     - Descripcion del parametro

**EJEMPLO COMPLETO (FR-RPT-01-07):**

.. list-table::
   :header-rows: 1
   :widths: 20 15 10 20 35

   * - Parametro
     - Tipo
     - Obligatorio
     - Valores/Rango
     - Descripcion
   * - quarter
     - STRING
     - SI
     - Q1, Q2, Q3, Q4
     - Trimestre a consultar
   * - year
     - INTEGER
     - SI
     - 2020-2024
     - Ano del reporte
   * - segment
     - STRING
     - SI
     - OP, MG
     - Segmento de clientes
   * - include_deleted
     - BOOLEAN
     - NO
     - TRUE, FALSE
     - Incluir registros eliminados (default: FALSE)

**Valores por Defecto:**

.. code-block:: python

   DEFAULT_VALUES = {
       'include_deleted': False
   }

**Validaciones por Parametro:**

Ver COMPONENTE 6 para validaciones detalladas.

----------------------------------------------------------------------
COMPONENTE 5: OUTPUT
----------------------------------------------------------------------

**Proposito:**

Documentar la estructura exacta del output que retorna el FR.

**Tipo de Retorno:**

Dataset|JSON|Boolean|Integer|String|Object|None

**Estructura del Output:**

Descripcion detallada de la estructura

**Formato JSON si aplica:**

.. code-block:: json

   {
       "campo1": "tipo y ejemplo",
       "campo2": 123,
       "campo3": []
   }

**Casos Especiales:**

- Que retorna si no hay datos
- Que retorna si hay error
- Limites de tamano

**EJEMPLO COMPLETO (FR-RPT-01-07):**

**Tipo de Retorno:**

Dataset: Lista de diccionarios Python

**Estructura:**

Cada elemento de la lista representa un dia del trimestre con sus
metricas agregadas:

.. code-block:: python

   [
       {
           'dia': datetime.date(2024, 7, 1),
           'total_llamadas': 1250,
           'completadas': 1100,
           'abandonadas': 150,
           'duracion_promedio': 245.67
       },
       {
           'dia': datetime.date(2024, 7, 2),
           'total_llamadas': 1180,
           'completadas': 1050,
           'abandonadas': 130,
           'duracion_promedio': 238.42
       },
       ...
   ]

**Tipos de Datos:**

- dia: datetime.date, formato YYYY-MM-DD
- total_llamadas: int, mayor o igual 0
- completadas: int, mayor o igual 0
- abandonadas: int, mayor o igual 0
- duracion_promedio: float, segundos con 2 decimales

**Invariantes:**

- total_llamadas = completadas + abandonadas
- duracion_promedio mayor 0 si total_llamadas mayor 0
- Lista ordenada cronologicamente por dia

**Casos Especiales:**

- Sin datos: Retorna lista vacia []
- Error de BD: Lanza QueryExecutionError con mensaje
- Timeout: Lanza QueryTimeoutError
- Datos corruptos: Lanza DataIntegrityError

**Limites:**

- Maximo 92 dias por trimestre (Q1-Q4)
- Cada dia puede tener 0 a 50,000 llamadas

----------------------------------------------------------------------
COMPONENTE 6: VALIDACIONES
----------------------------------------------------------------------

**Proposito:**

Documentar todas las reglas de validacion que se aplican a los inputs
antes de ejecutar el FR.

**Formato de Validacion:**

V-N: Titulo de la validacion

Condicion: Que debe cumplirse

Mensaje Error: Mensaje si falla

Codigo:

.. code-block:: python

   if not condicion:
       raise ValidationError("mensaje")

**EJEMPLO COMPLETO (FR-RPT-01-07):**

V-1: Quarter Valido

Condicion:
El parametro quarter debe ser exactamente uno de: Q1, Q2, Q3, Q4
(case-sensitive)

Mensaje Error:
"Invalid quarter: debe ser Q1, Q2, Q3 o Q4"

Codigo:

.. code-block:: python

   VALID_QUARTERS = ['Q1', 'Q2', 'Q3', 'Q4']
   
   if quarter not in VALID_QUARTERS:
       raise ValidationError(
           f"Invalid quarter: {quarter}. "
           f"Debe ser uno de: {', '.join(VALID_QUARTERS)}"
       )

V-2: Year en Rango Valido

Condicion:
El ano debe estar entre 2020 y el ano actual (2024)

Mensaje Error:
"Invalid year: debe estar entre 2020 y 2024"

Codigo:

.. code-block:: python

   import datetime
   
   CURRENT_YEAR = datetime.datetime.now().year
   MIN_YEAR = 2020
   
   if not (MIN_YEAR <= year <= CURRENT_YEAR):
       raise ValidationError(
           f"Invalid year: {year}. "
           f"Debe estar entre {MIN_YEAR} y {CURRENT_YEAR}"
       )

V-3: Segment Valido

Condicion:
El segmento debe ser OP (Operaciones) o MG (Management)

Mensaje Error:
"Invalid segment: debe ser OP o MG"

Codigo:

.. code-block:: python

   VALID_SEGMENTS = ['OP', 'MG']
   
   if segment not in VALID_SEGMENTS:
       raise ValidationError(
           f"Invalid segment: {segment}. "
           f"Debe ser uno de: {', '.join(VALID_SEGMENTS)}"
       )

V-4: Tipos de Datos Correctos

Condicion:
- quarter: string
- year: integer
- segment: string

Mensaje Error:
"Invalid parameter type: esperado tipo, recibido tipo"

Codigo:

.. code-block:: python

   if not isinstance(quarter, str):
       raise ValidationError(
           f"Invalid type for quarter: expected str, "
           f"got {type(quarter).__name__}"
       )
   
   if not isinstance(year, int):
       raise ValidationError(
           f"Invalid type for year: expected int, "
           f"got {type(year).__name__}"
       )
   
   if not isinstance(segment, str):
       raise ValidationError(
           f"Invalid type for segment: expected str, "
           f"got {type(segment).__name__}"
       )

V-5: Trimestre No en el Futuro

Condicion:
El trimestre consultado no debe estar en el futuro

Mensaje Error:
"Cannot query future quarter"

Codigo:

.. code-block:: python

   from datetime import datetime
   
   # Mapeo quarter a mes de inicio
   QUARTER_START_MONTH = {
       'Q1': 1, 'Q2': 4, 'Q3': 7, 'Q4': 10
   }
   
   query_date = datetime(year, QUARTER_START_MONTH[quarter], 1)
   current_date = datetime.now()
   
   if query_date > current_date:
       raise ValidationError(
           f"Cannot query future quarter: {quarter} {year}"
       )

----------------------------------------------------------------------
COMPONENTE 7: TIMEOUT
----------------------------------------------------------------------

**Proposito:**

Definir el tiempo maximo de ejecucion y que hacer si se excede.

**Timeout Definido:**

- Tiempo maximo: N segundos
- Nivel: Statement|Connection|Application

**Accion si Excede:**

- Cancelar query
- Loguear error
- Retornar excepcion especifica

**Configuracion Tecnica:**

Como se configura el timeout en codigo

**EJEMPLO COMPLETO (FR-RPT-01-07):**

**Timeout Definido:**

- Tiempo maximo: 30 segundos
- Nivel: Statement (query individual)

**Razon:**

Queries de reportes con mas de 10,000 registros fueron pre-aprobadas
en pasos anteriores. Queries normales (menor o igual 10,000 registros)
deben completarse en menos de 5 segundos tipicamente. 30 segundos es
un limite muy generoso para evitar queries infinitas por errores de
sintaxis o joins mal optimizados.

**Accion si Excede:**

1. PostgreSQL cancela automaticamente la query
2. Sistema captura error QueryTimeoutError
3. Log de nivel ERROR registra el timeout
4. Se notifica a equipo de soporte
5. Usuario ve mensaje amigable

**Configuracion PostgreSQL:**

.. code-block:: sql

   -- Configuracion a nivel de session
   SET statement_timeout = '30s';

**Configuracion Python:**

.. code-block:: python

   from sqlalchemy import create_engine
   
   # Configurar timeout en connection string
   engine = create_engine(
       'postgresql://user:pass@host/db',
       connect_args={
           'options': '-c statement_timeout=30000'  # milliseconds
       }
   )

O a nivel de query:

.. code-block:: python

   from django.db import connection
   
   with connection.cursor() as cursor:
       cursor.execute("SET statement_timeout = '30s'")
       cursor.execute(query, params)

----------------------------------------------------------------------
COMPONENTE 8: MANEJO DE ERRORES
----------------------------------------------------------------------

**Proposito:**

Documentar como se manejan todos los tipos de errores posibles.

**Tipos de Errores a Manejar:**

1. Errores de validacion
2. Errores de BD (conexion, sintaxis, timeout)
3. Errores de datos (corruptos, inconsistentes)
4. Errores de recursos (memoria, disco)

**Patron Try-Catch:**

.. code-block:: python

   try:
       # Codigo del FR
       pass
   except TipoError1 as e:
       # Manejo especifico
       pass
   except TipoError2 as e:
       # Manejo especifico
       pass
   finally:
       # Limpieza
       pass

**Logging de Errores:**

Todos los errores deben loguearse con:
- Nivel: ERROR o CRITICAL
- Contexto: user_id, parametros, timestamp
- Stack trace si es error inesperado

**Retry Logic:**

Definir si se reintenta y cuantas veces

**EJEMPLO COMPLETO (FR-RPT-01-07):**

**Codigo Completo con Manejo de Errores:**

.. code-block:: python

   import logging
   from django.db import connection, OperationalError, DatabaseError
   from app.exceptions import (
       ValidationError,
       QueryTimeoutError,
       QueryExecutionError,
       DataIntegrityError
   )
   
   logger = logging.getLogger(__name__)
   
   def execute_quarterly_report_query(quarter, year, segment):
       """
       Implements FR-RPT-01-07: Execute Main Query
       
       Args:
           quarter (str): Q1, Q2, Q3, Q4
           year (int): 2020-2024
           segment (str): OP, MG
       
       Returns:
           list: Dataset with daily metrics
       
       Raises:
           ValidationError: Invalid parameters
           QueryTimeoutError: Query exceeded 30s
           QueryExecutionError: Database error
           DataIntegrityError: Corrupt data detected
       """
       
       # Validaciones (ver COMPONENTE 6)
       validate_parameters(quarter, year, segment)
       
       try:
           # Configurar timeout
           with connection.cursor() as cursor:
               cursor.execute("SET statement_timeout = '30s'")
               
               # Ejecutar query
               query = """
                   SELECT 
                       DATE_TRUNC('day', call_date) as dia,
                       COUNT(*) as total_llamadas,
                       SUM(CASE WHEN status='COMPLETED' THEN 1 ELSE 0 END) as completadas,
                       SUM(CASE WHEN status='ABANDONED' THEN 1 ELSE 0 END) as abandonadas,
                       AVG(duration_seconds) as duracion_promedio
                   FROM ivr_calls
                   WHERE quarter = %s
                     AND year = %s
                     AND segment = %s
                     AND deleted_at IS NULL
                   GROUP BY DATE_TRUNC('day', call_date)
                   ORDER BY dia ASC
               """
               
               cursor.execute(query, [quarter, year, segment])
               
               # Fetch resultados
               columns = [col[0] for col in cursor.description]
               results = [
                   dict(zip(columns, row))
                   for row in cursor.fetchall()
               ]
               
               # Validar integridad de datos
               validate_data_integrity(results)
               
               # Log exitoso
               logger.info(
                   f"Query executed successfully: "
                   f"quarter={quarter}, year={year}, segment={segment}, "
                   f"rows={len(results)}"
               )
               
               return results
       
       except OperationalError as e:
           # Timeout o conexion perdida
           if 'timeout' in str(e).lower():
               logger.error(
                   f"Query timeout: quarter={quarter}, year={year}, "
                   f"segment={segment}, error={str(e)}"
               )
               raise QueryTimeoutError(
                   "Query exceeded 30 second timeout. "
                   "Try reducing date range or contact support."
               ) from e
           else:
               logger.error(
                   f"Database connection error: {str(e)}"
               )
               raise QueryExecutionError(
                   "Database connection failed. Please retry."
               ) from e
       
       except DatabaseError as e:
           # Error de sintaxis SQL o constraint
           logger.error(
               f"Database error: quarter={quarter}, year={year}, "
               f"segment={segment}, error={str(e)}"
           )
           raise QueryExecutionError(
               "Database error occurred. Contact support."
           ) from e
       
       except Exception as e:
           # Error inesperado
           logger.critical(
               f"Unexpected error in FR-RPT-01-07: "
               f"quarter={quarter}, year={year}, segment={segment}",
               exc_info=True
           )
           raise QueryExecutionError(
               "An unexpected error occurred. Contact support."
           ) from e
   
   def validate_data_integrity(results):
       """Validates data integrity invariants."""
       for row in results:
           total = row['total_llamadas']
           comp = row['completadas']
           aban = row['abandonadas']
           
           # Invariant: total = completadas + abandonadas
           if total != comp + aban:
               raise DataIntegrityError(
                   f"Data integrity violation on {row['dia']}: "
                   f"total ({total}) != completadas ({comp}) + "
                   f"abandonadas ({aban})"
               )

**Retry Logic:**

NO se reintenta automaticamente para queries de reportes porque:
- Si falla por timeout, reintentar causaria mas carga
- Si falla por datos corruptos, reintento no ayuda
- Usuario debe corregir parametros o esperar mejor momento

**Notificaciones:**

Si error es CRITICAL o mas de 5 errores en 1 minuto:
- Enviar alerta a Slack canal alerts-database
- Crear ticket en Jira proyecto IACT

----------------------------------------------------------------------
COMPONENTE 9: LOGS
----------------------------------------------------------------------

**Proposito:**

Documentar que debe loguearse, en que niveles y con que formato.

**Niveles de Log:**

- DEBUG: Detalles tecnicos, variables
- INFO: Ejecucion normal, operaciones exitosas
- WARNING: Situaciones anomalas pero recuperables
- ERROR: Errores que impiden completar operacion
- CRITICAL: Errores graves que afectan sistema

**Que Loguear:**

Entrada del FR:
- Parametros recibidos
- Usuario que ejecuta
- Timestamp

Durante ejecucion:
- Inicio de query
- Tiempo de ejecucion
- Rows retornadas

Salida del FR:
- Resultado exitoso con metricas
- Errores con contexto completo

**Formato de Log:**

Estandar JSON estructurado para facil parsing

**EJEMPLO COMPLETO (FR-RPT-01-07):**

**Configuracion de Logger:**

.. code-block:: python

   import logging
   import json
   from datetime import datetime
   
   logger = logging.getLogger('iact.reports.fr_rpt_01_07')
   logger.setLevel(logging.INFO)

**Log al Inicio (INFO):**

.. code-block:: python

   logger.info(
       json.dumps({
           'event': 'fr_rpt_01_07_start',
           'timestamp': datetime.now().isoformat(),
           'user_id': request.user.id,
           'parameters': {
               'quarter': quarter,
               'year': year,
               'segment': segment
           },
           'request_id': request.id
       })
   )

Salida:

.. code-block:: json

   {
       "event": "fr_rpt_01_07_start",
       "timestamp": "2024-11-15T14:23:45.123456",
       "user_id": "USR-001",
       "parameters": {
           "quarter": "Q3",
           "year": 2024,
           "segment": "OP"
       },
       "request_id": "req-abc123"
   }

**Log de Query Execution (DEBUG):**

.. code-block:: python

   logger.debug(
       json.dumps({
           'event': 'query_execution',
           'timestamp': datetime.now().isoformat(),
           'query_hash': hashlib.md5(query.encode()).hexdigest(),
           'parameters': [quarter, year, segment]
       })
   )

**Log Exitoso (INFO):**

.. code-block:: python

   logger.info(
       json.dumps({
           'event': 'fr_rpt_01_07_success',
           'timestamp': datetime.now().isoformat(),
           'user_id': request.user.id,
           'parameters': {
               'quarter': quarter,
               'year': year,
               'segment': segment
           },
           'result': {
               'rows_returned': len(results),
               'execution_time_ms': execution_time
           },
           'request_id': request.id
       })
   )

**Log de Error (ERROR):**

.. code-block:: python

   logger.error(
       json.dumps({
           'event': 'fr_rpt_01_07_error',
           'timestamp': datetime.now().isoformat(),
           'user_id': request.user.id,
           'parameters': {
               'quarter': quarter,
               'year': year,
               'segment': segment
           },
           'error': {
               'type': type(e).__name__,
               'message': str(e),
               'stack_trace': traceback.format_exc()
           },
           'request_id': request.id
       })
   )

**Metricas para Observabilidad:**

Adicionalmente, enviar metricas a Prometheus:

.. code-block:: python

   from prometheus_client import Counter, Histogram
   
   # Counter de ejecuciones
   query_executions = Counter(
       'fr_rpt_01_07_executions_total',
       'Total query executions',
       ['status', 'segment']
   )
   
   # Histogram de tiempos
   query_duration = Histogram(
       'fr_rpt_01_07_duration_seconds',
       'Query execution duration',
       ['segment']
   )
   
   # Uso
   with query_duration.labels(segment=segment).time():
       results = execute_query()
   
   query_executions.labels(status='success', segment=segment).inc()

----------------------------------------------------------------------
COMPONENTE 10: TESTS
----------------------------------------------------------------------

**Proposito:**

Documentar tests unitarios e integracion que verifican el FR.

**Tests Unitarios:**

Tests aislados que verifican logica del FR sin dependencias externas

**Tests de Integracion:**

Tests que verifican FR con BD real, servicios reales

**Cobertura Minima:**

- Caso normal exitoso
- Casos borde (limites de parametros)
- Casos de error (validaciones, timeouts, BD)

**Framework:**

pytest para Python, con fixtures y mocks

**EJEMPLO COMPLETO (FR-RPT-01-07):**

**Test Unitario 1: Caso Normal**

.. code-block:: python

   # tests/unit/test_fr_rpt_01_07.py
   
   import pytest
   from datetime import date
   from reports.fr_rpt_01_07 import execute_quarterly_report_query
   
   def test_execute_query_success_q3_2024(mocker):
       """
       Test successful query execution for Q3 2024.
       
       Validates FR-RPT-01-07 with normal parameters.
       """
       # Arrange
       quarter = 'Q3'
       year = 2024
       segment = 'OP'
       
       # Mock database response
       mock_results = [
           {
               'dia': date(2024, 7, 1),
               'total_llamadas': 1250,
               'completadas': 1100,
               'abandonadas': 150,
               'duracion_promedio': 245.67
           },
           {
               'dia': date(2024, 7, 2),
               'total_llamadas': 1180,
               'completadas': 1050,
               'abandonadas': 130,
               'duracion_promedio': 238.42
           }
       ]
       
       mocker.patch(
           'reports.fr_rpt_01_07.execute_raw_query',
           return_value=mock_results
       )
       
       # Act
       results = execute_quarterly_report_query(quarter, year, segment)
       
       # Assert
       assert len(results) == 2
       assert results[0]['dia'] == date(2024, 7, 1)
       assert results[0]['total_llamadas'] == 1250
       assert results[0]['completadas'] + results[0]['abandonadas'] == 1250

**Test Unitario 2: Validacion Falla**

.. code-block:: python

   def test_execute_query_invalid_quarter():
       """Test validation error for invalid quarter."""
       # Arrange
       quarter = 'Q5'  # Invalid
       year = 2024
       segment = 'OP'
       
       # Act & Assert
       with pytest.raises(ValidationError, match="Invalid quarter"):
           execute_quarterly_report_query(quarter, year, segment)

**Test Unitario 3: Year Fuera de Rango**

.. code-block:: python

   def test_execute_query_year_out_of_range():
       """Test validation error for year out of range."""
       # Arrange
       quarter = 'Q3'
       year = 2030  # Future year
       segment = 'OP'
       
       # Act & Assert
       with pytest.raises(ValidationError, match="Invalid year"):
           execute_quarterly_report_query(quarter, year, segment)

**Test de Integracion 1: Query Real en BD**

.. code-block:: python

   # tests/integration/test_fr_rpt_01_07_integration.py
   
   import pytest
   from django.test import TestCase, TransactionTestCase
   from reports.fr_rpt_01_07 import execute_quarterly_report_query
   from app.models import IVRCall
   from datetime import date
   
   @pytest.mark.django_db
   class TestFRRPT0107Integration(TransactionTestCase):
       """Integration tests for FR-RPT-01-07 with real database."""
       
       def setUp(self):
           """Setup test data in database."""
           # Create test data for Q3 2024
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
               duration_seconds=60
           )
           # ... more test data
       
       def test_query_returns_correct_aggregations(self):
           """Test that query returns correct aggregated data."""
           # Act
           results = execute_quarterly_report_query('Q3', 2024, 'OP')
           
           # Assert
           assert len(results) > 0
           
           # Verify first day
           day_1 = results[0]
           assert day_1['dia'] == date(2024, 7, 1)
           assert day_1['total_llamadas'] == 2
           assert day_1['completadas'] == 1
           assert day_1['abandonadas'] == 1
           assert day_1['duracion_promedio'] == 150.0  # (240+60)/2

**Test de Integracion 2: Timeout**

.. code-block:: python

   @pytest.mark.slow
   def test_query_timeout_after_30_seconds(mocker):
       """Test that query times out after 30 seconds."""
       # Arrange
       # Mock a slow query that takes > 30 seconds
       def slow_query(*args, **kwargs):
           import time
           time.sleep(31)  # Simulate timeout
       
       mocker.patch(
           'django.db.connection.cursor.execute',
           side_effect=slow_query
       )
       
       # Act & Assert
       with pytest.raises(QueryTimeoutError):
           execute_quarterly_report_query('Q3', 2024, 'OP')

**Cobertura de Tests:**

.. code-block:: bash

   # Run tests with coverage
   pytest tests/unit/test_fr_rpt_01_07.py \
          tests/integration/test_fr_rpt_01_07_integration.py \
          --cov=reports.fr_rpt_01_07 \
          --cov-report=html

Objetivo: Mayor o igual 80% de cobertura de lineas

----------------------------------------------------------------------
SECCION 11: HISTORIAL DE VERSIONES
----------------------------------------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 10 15 50 25

   * - Version
     - Fecha
     - Cambios
     - Autor
   * - 1.0.0
     - YYYY-MM-DD
     - Version inicial - Implementacion de FR
     - Nombre del Developer
   * - 1.1.0
     - YYYY-MM-DD
     - Agrega validacion V-5 (trimestre futuro)
     - Nombre del Developer
   * - 1.0.1
     - YYYY-MM-DD
     - Corrige typo en mensaje de error
     - Nombre del Developer

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estandares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagogico:**

- PARTE_4_Functional_Requirements_IACT_1_0_0.md
  - Seccion 2: Los 10 Componentes Obligatorios
  - Seccion 3: Derivacion UC → FR
  - Seccion 4: Testing de FR

**Documentos Relacionados:**

- UC-IACT-RPT-01-Consultar-Reporte-Trimestral-4-0-0.rst
- BR-IACT-028-Aprobacion-Consultas-1-0-0.rst

----------------------------------------------------------------------

.. note::
   CHECKLIST DE CALIDAD - 10 COMPONENTES:
   
   Verificar que TODOS los componentes esten completos:
   
   - Componente 1: DERIVADO DE completo
   - Componente 2: DESCRIPCION clara
   - Componente 3: CONSULTA SQL funcional y comentada
   - Componente 4: PARAMETROS con tipos y validaciones
   - Componente 5: OUTPUT con estructura detallada
   - Componente 6: VALIDACIONES V-1 a V-N con codigo
   - Componente 7: TIMEOUT definido y configurado
   - Componente 8: MANEJO ERRORES con try-catch completo
   - Componente 9: LOGS en todos los niveles
   - Componente 10: TESTS unitarios e integracion
   
   Codigo:
   - Todo el codigo es funcional, no pseudocodigo
   - Queries SQL usan parametros bound
   - Excepciones son especificas, no genericas
   - Logging es estructurado (JSON)
   - Tests cubren casos normal, borde y error

----------------------------------------------------------------------

**Archivo:** TPL_FR_Documentacion_10_Componentes_1_3_0.rst  
**Version Template:** 1.3.0  
**Fecha Creacion Template:** 2026-01-11  
**Autor Template:** Sistema de Regeneracion IACT  
**Lineas Totales:** aproximadamente 1,100

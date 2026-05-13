.. meta::
   :Proyecto: IACT
   :Codigo: BR-IACT-XXX
   :Titulo: [Nombre Descriptivo de la Business Rule]
   :Version: 1.0.0
   :Tipo: [Restriccion|Calculo|Desencadenador|Inferencia|Definicion]
   :Genera_UC: [UC-IACT-XXX-YY o "-" si no genera]
   :Fecha: YYYY-MM-DD
   :Autor: [Nombre del Business Analyst]
   :Estado: [DRAFT|REVIEW|APPROVED|IMPLEMENTED]

======================================================================
BR-IACT-XXX: [Nombre Descriptivo de la Business Rule]
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Tipo:** [Restriccion|Calculo|Desencadenador|Inferencia|Definicion]  
**Estado:** [DRAFT|REVIEW|APPROVED|IMPLEMENTED]  
**Prioridad:** [Alta|Media|Baja]  
**Clasificacion:** [C2 - INTERNAL]

----------------------------------------------------------------------
INTRODUCCION AL TEMPLATE
----------------------------------------------------------------------

Este template documenta Business Rules siguiendo la taxonomía estándar
de 5 tipos de BR, con énfasis en el TEST DE OBSERVABILIDAD para
distinguir correctamente entre Desencadenadores e Inferencias.

**Propósito de las Business Rules:**

Las BR son declaraciones de política o condición del negocio que:

1. **Restringen** comportamientos del sistema
2. **Calculan** valores derivados
3. **Desencadenan** acciones observables por usuarios
4. **Infieren** cambios silenciosos en el estado
5. **Definen** conceptos del dominio

**Importancia de la Clasificación Correcta:**

La clasificación determina cómo se implementa la BR:

- **Restricción** → Precondición + Flujo Alterno en UC existente
- **Cálculo** → Paso en flujo normal (NO genera UC propio)
- **Desencadenador** → UC completo NUEVO (actor ve algo)
- **Inferencia** → NO genera UC (solo FR directo, cambio silencioso)
- **Definición** → Glosario/Diccionario de datos (NO genera UC ni FR)

**Test de Observabilidad (CRÍTICO):**

.. code-block:: text

   Pregunta: ¿El usuario VE algo como resultado de esta BR?
   
   SI → Es DESENCADENADOR
        - Usuario ve notificación, mensaje, modal, email, etc.
        - Genera UC completo
        - Actor: Usuario que recibe la acción
   
   NO → Es INFERENCIA
        - Solo cambia BD, estado interno, timestamp
        - NO genera UC completo
        - Deriva FR directo
        - Puede implementarse en UC temporal (actor: Sistema)

----------------------------------------------------------------------
SECCION 1: ENUNCIADO
----------------------------------------------------------------------

**Definición:**

El enunciado es una frase declarativa clara y concisa que describe
la regla de negocio en lenguaje natural, comprensible por stakeholders
no técnicos.

**Características de un buen enunciado:**

1. **Una sola frase** (puede tener cláusulas, pero un punto final)
2. **Verbo en presente** (indicativo, no condicional)
3. **Sujeto claro** (sistema, usuario, entidad)
4. **Sin ambigüedad** (términos precisos, sin jerga)
5. **Testable** (se puede verificar si se cumple)

**Formato general:**

   "[Sujeto] [verbo] [complemento] [condición si aplica]."

**ENUNCIADO:**

[Escribe aquí el enunciado de tu BR en una sola frase clara]

**Ejemplos Completos por Tipo:**

1.1 Ejemplo: Restricción
~~~~~~~~~~~~~~~~~~~~~~~~~

**BR-IACT-028: Aprobación de Consultas Grandes**

**Enunciado:**

"Las consultas de reportes que retornen más de 10,000 registros deben
ser aprobadas por el supervisor del área antes de ejecutarse."

**Análisis del enunciado:**

- Sujeto: "Las consultas de reportes"
- Verbo: "deben ser aprobadas"
- Complemento: "por el supervisor del área"
- Condición: "que retornen más de 10,000 registros"
- Timing: "antes de ejecutarse"

**Criterio de cumplimiento:**

Sistema puede verificar si count > 10,000 y si existe aprobación.

1.2 Ejemplo: Cálculo
~~~~~~~~~~~~~~~~~~~~

**BR-IACT-053: Cálculo de Tasa de Abandono**

**Enunciado:**

"La tasa de abandono se calcula dividiendo el número de llamadas
abandonadas entre el total de llamadas, multiplicado por 100."

**Análisis del enunciado:**

- Sujeto: "La tasa de abandono"
- Verbo: "se calcula"
- Complemento: "dividiendo... entre... multiplicado por 100"
- Fórmula implícita: (abandonadas / total) * 100

**Criterio de cumplimiento:**

Sistema aplica la fórmula correctamente y retorna porcentaje.

1.3 Ejemplo: Desencadenador
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**BR-IACT-031: Notificación de Sesión Próxima a Expirar**

**Enunciado:**

"El sistema debe notificar al usuario cuando su sesión esté próxima a
expirar (falten 3 minutos)."

**Análisis del enunciado:**

- Sujeto: "El sistema"
- Verbo: "debe notificar"
- Complemento: "al usuario"
- Condición: "cuando su sesión esté próxima a expirar (falten 3 minutos)"

**Test de observabilidad:**

¿Usuario VE algo? → SÍ (ve modal/notificación)
Por lo tanto: Es DESENCADENADOR

**Criterio de cumplimiento:**

Usuario recibe notificación visible 3 minutos antes de expiración.

1.4 Ejemplo: Inferencia
~~~~~~~~~~~~~~~~~~~~~~~

**BR-IACT-046: Marcar Sesiones Expiradas**

**Enunciado:**

"El sistema debe marcar automáticamente las sesiones como expiradas
cuando superen 15 minutos de inactividad."

**Análisis del enunciado:**

- Sujeto: "El sistema"
- Verbo: "debe marcar"
- Complemento: "las sesiones como expiradas"
- Condición: "cuando superen 15 minutos de inactividad"

**Test de observabilidad:**

¿Usuario VE algo? → NO (solo cambia campo en BD)
Por lo tanto: Es INFERENCIA

**Criterio de cumplimiento:**

Campo sessions.status = 'EXPIRED' cuando inactividad > 15 min.

1.5 Ejemplo: Definición
~~~~~~~~~~~~~~~~~~~~~~~

**BR-IACT-001: Cliente Activo**

**Enunciado:**

"Un cliente se considera activo si ha realizado al menos una llamada
en los últimos 90 días."

**Análisis del enunciado:**

- Término definido: "Cliente Activo"
- Criterio: "ha realizado al menos una llamada en los últimos 90 días"

**Criterio de cumplimiento:**

Existe registro en ivr_calls con call_date >= NOW() - INTERVAL '90 days'

----------------------------------------------------------------------
SECCION 2: DERIVADO DE (Backward Traceability)
----------------------------------------------------------------------

**Propósito:**

Documentar el origen de esta BR para mantener trazabilidad hacia atrás
(backward traceability). Esto permite responder:

- ¿Quién solicitó esta BR?
- ¿De qué Business Requirement deriva?
- ¿Cuál es el contexto de negocio?
- ¿Por qué existe esta regla?

2.1 Business Requirement (BReq) Padre
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**BReq Padre:**

- **ID:** BRQ-XXX
- **Nombre:** [Nombre del Business Requirement]
- **Archivo:** BRQ_XXX_[Nombre]_1_0_0.rst (si existe)
- **Sección:** [Número de sección del BReq donde se menciona]

**Justificación:**

[Explica cómo esta BR contribuye a satisfacer el BReq padre. Responde:
¿Por qué esta BR es necesaria para cumplir el BReq?]

**Ejemplo:**

BReq Padre:
- ID: BRQ-015
- Nombre: Optimizar Performance de Reportes
- Archivo: BRQ_015_Optimizar_Performance_1_0_0.rst
- Sección: 3.2 (Controlar volumen de consultas)

Justificación:

Esta BR (Aprobación de Consultas Grandes) contribuye al BRQ-015
porque previene que consultas masivas degraden el performance del
sistema. Al requerir aprobación para queries >10K registros,
aseguramos que:

1. Consultas grandes se ejecuten fuera de horario pico
2. Se evalúe si realmente son necesarias
3. Se optimicen parámetros antes de ejecución
4. Se mantenga experiencia de usuario para consultas normales

2.2 Stakeholder
~~~~~~~~~~~~~~~

**Identificación del Stakeholder:**

- **Nombre completo:** [Nombre y Apellido]
- **Rol/Cargo:** [Título del puesto]
- **Área/Departamento:** [Departamento de la organización]
- **Email:** [email@ejemplo.com]
- **Teléfono:** [+XX XXX XXX XXXX] (opcional)

**Fecha de Elicitación:** YYYY-MM-DD

**Método de Elicitación:**

- [ ] Entrevista presencial
- [ ] Reunión virtual
- [ ] Email
- [ ] Workshop
- [ ] Análisis de documentos
- [ ] Observación directa

**Referencia Documental:**

- **Acta de reunión:** [Archivo o link a acta]
- **Email de confirmación:** [Asunto del email / link]
- **Grabación:** [Link a grabación si aplica]
- **Documento de requerimientos:** [Si stakeholder envió doc]

**Quote textual del stakeholder (si aplica):**

   "[Texto exacto que dijo el stakeholder sobre esta necesidad]"

**Ejemplo:**

Stakeholder:
- Nombre: María Rodríguez
- Rol: Gerente de Operaciones
- Área: Call Center Operations
- Email: maria.rodriguez@iact.com

Fecha: 2024-11-15

Método: Entrevista presencial

Referencia:
- Acta: ACTA_REUNION_OPS_2024_11_15.docx
- Email confirmación: "RE: Requerimientos Performance Reportes"

Quote textual:

"Necesitamos controlar las consultas grandes porque a veces los
analistas piden reportes de todo el año y eso deja el sistema lento
para todos. Queremos que si alguien va a hacer una consulta muy
grande, tenga que pedirme permiso primero para que yo vea si
realmente lo necesita y cuándo es mejor hacerlo."

2.3 Contexto del Negocio
~~~~~~~~~~~~~~~~~~~~~~~~~

**Problema que Resuelve:**

[Descripción del problema o dolor (pain point) del negocio que motiva
esta BR. ¿Qué estaba saliendo mal? ¿Qué riesgo se busca mitigar?]

**Situación Actual (As-Is):**

[Cómo funcionan las cosas HOY sin esta BR]

**Situación Deseada (To-Be):**

[Cómo deberían funcionar CON esta BR implementada]

**Impacto Esperado:**

[Beneficios medibles que esta BR traerá al negocio]

**Categorías de Impacto:**

- [ ] Eficiencia operativa
- [ ] Cumplimiento normativo
- [ ] Experiencia de usuario
- [ ] Reducción de costos
- [ ] Mitigación de riesgos
- [ ] Calidad de datos
- [ ] Seguridad
- [ ] Otro: [especificar]

**Métricas de Éxito:**

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Métrica
     - Valor Actual
     - Valor Objetivo
   * - [Nombre de métrica 1]
     - [Valor hoy]
     - [Valor esperado]
   * - [Nombre de métrica 2]
     - [Valor hoy]
     - [Valor esperado]

**Ejemplo Completo:**

Problema:

Analistas ejecutan consultas de reportes sin restricciones, causando:
- Timeouts en BD (queries >30 seg)
- Degradación de performance para otros usuarios
- Costos de infraestructura elevados (CPU picos de 95%)
- Frustración de usuarios (sistema "se cuelga")

As-Is:

Cualquier usuario con permiso RPT-001 puede ejecutar cualquier
consulta sin límites de volumen. Sistema intenta ejecutar y si
tarda mucho (>30 seg), devuelve timeout.

To-Be:

Sistema evalúa volumen de consulta ANTES de ejecutar. Si supera
10,000 registros, solicita aprobación de supervisor. Supervisor
puede aprobar, rechazar, o pedir optimizar parámetros.

Impacto Esperado:

- ✅ Eficiencia operativa: Consultas grandes en horario controlado
- ✅ Experiencia usuario: Sistema responsivo para consultas normales
- ✅ Reducción costos: Menos picos de CPU, infraestructura optimizada

Métricas:

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Métrica
     - Valor Actual
     - Valor Objetivo
   * - Tiempo respuesta p95 (consultas normales)
     - 8.5 segundos
     - < 3 segundos
   * - Consultas con timeout
     - 15% mensual
     - < 2% mensual
   * - CPU promedio en horario pico
     - 85%
     - < 60%
   * - Quejas de usuarios por lentitud
     - 23/mes
     - < 5/mes

----------------------------------------------------------------------
SECCION 3: CRITERIOS DE ACEPTACION
----------------------------------------------------------------------

**Definición:**

Los Criterios de Aceptación (CA) son condiciones específicas, medibles
y verificables que deben cumplirse para considerar que la BR está
correctamente implementada.

**Formato: Given-When-Then (Gherkin)**

.. code-block:: gherkin

   CA-N: [Título descriptivo del criterio]
   
   Dado: [Condición inicial / estado del sistema]
   Cuando: [Acción o evento que se ejecuta]
   Entonces: [Resultado esperado OBSERVABLE]

**Características de buenos CA:**

1. **Específicos:** Sin ambigüedad, no genéricos
2. **Medibles:** Se puede verificar objetivamente
3. **Verificables:** Se puede probar con test manual o automatizado
4. **Completos:** Cubren caso normal + casos borde
5. **Independientes:** Cada CA es auto-contenido

**Número Recomendado:**

- Mínimo: 3 CA (caso normal + 2 casos borde/error)
- Típico: 5-7 CA
- Máximo recomendado: 10 CA (si son más, considerar dividir la BR)

**CRITERIOS DE ACEPTACION:**

CA-1: [Título del criterio 1 - Caso Normal]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:** [Precondición / estado inicial]

**Cuando:** [Acción del usuario o evento del sistema]

**Entonces:** [Resultado observable esperado]

**Verificación:**

[Cómo se puede verificar este criterio: query SQL, inspección UI,
log, etc.]

CA-2: [Título del criterio 2 - Caso Borde]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:** [...]

**Cuando:** [...]

**Entonces:** [...]

**Verificación:** [...]

CA-3: [Título del criterio 3 - Caso Error]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:** [...]

**Cuando:** [...]

**Entonces:** [...]

**Verificación:** [...]

**Ejemplo Completo (BR-IACT-028):**

CA-1: Sistema calcula count antes de ejecutar query principal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:**
- Usuario autenticado con permiso RPT-001
- Usuario solicita reporte trimestral con parámetros:
  
  - Trimestre: Q3
  - Año: 2024
  - Segmento: OP

**Cuando:**
- Usuario hace click en botón "Generar Reporte"

**Entonces:**
- Sistema ejecuta COUNT(*) con mismos parámetros ANTES de SELECT principal
- Sistema registra count en variable temporal
- Query COUNT debe completarse en < 2 segundos

**Verificación:**

.. code-block:: sql

   -- Log debe mostrar:
   SELECT COUNT(*) FROM ivr_calls
   WHERE quarter = 'Q3' AND year = 2024 AND segment = 'OP'
   -- Resultado: 10,500

CA-2: Sistema solicita aprobación si count > 10,000
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:**
- Count calculado es 10,500 registros (> umbral de 10,000)

**Cuando:**
- Sistema evalúa resultado del count

**Entonces:**
- Sistema NO ejecuta query principal
- Sistema crea registro en tabla approvals:
  
  .. code-block:: sql
  
     INSERT INTO approvals (
         user_id, query_hash, record_count,
         status, created_at
     ) VALUES (
         :user_id, MD5(:query_params), 10500,
         'PENDING', NOW()
     )

- Sistema identifica supervisor del usuario
- Sistema crea notificación para supervisor

**Verificación:**

.. code-block:: sql

   SELECT * FROM approvals
   WHERE user_id = :user_id
     AND created_at > NOW() - INTERVAL '1 minute'
     AND status = 'PENDING'
   -- Debe retornar 1 fila

CA-3: Supervisor recibe notificación en buzón interno
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:**
- Consulta requiere aprobación
- Supervisor identificado: supervisor_id = 'SUP-001'

**Cuando:**
- Sistema crea registro de aprobación

**Entonces:**
- Supervisor ve notificación en su bandeja de entrada
- Notificación contiene:
  
  - Título: "Aprobación requerida: Consulta de [nombre_usuario]"
  - Descripción: "Consulta retornaría 10,500 registros"
  - Link directo a pantalla de aprobación
  - Timestamp

- Badge de notificaciones incrementa (+1)

**Verificación:**

.. code-block:: sql

   SELECT * FROM notifications
   WHERE recipient_id = 'SUP-001'
     AND type = 'APPROVAL_REQUEST'
     AND read_at IS NULL
   ORDER BY created_at DESC
   LIMIT 1
   -- Debe retornar la notificación creada

CA-4: Usuario ve mensaje de espera
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:**
- Consulta enviada a aprobación

**Cuando:**
- Sistema termina proceso de solicitud de aprobación

**Entonces:**
- Usuario ve modal con mensaje:
  
  "Su consulta requiere aprobación del supervisor debido al
  volumen de datos (10,500 registros).
  
  Le notificaremos cuando sea aprobada o rechazada.
  
  Tiempo estimado de respuesta: 2-4 horas."

- Modal tiene botón "OK"
- Al hacer click en "OK", redirige a dashboard de reportes

**Verificación:**

- Inspección visual de UI
- Test automatizado con Selenium/Cypress

CA-5: Sistema no ejecuta query principal si no hay aprobación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:**
- Consulta con count = 10,500
- Estado aprobación = 'PENDING' (no aprobada aún)

**Cuando:**
- Cualquier intento de ejecutar query principal

**Entonces:**
- Sistema rechaza ejecución
- Sistema retorna error con código ERR-APPROVAL-REQUIRED
- Log registra intento de ejecución sin aprobación
- Usuario NO ve resultados

**Verificación:**

.. code-block:: python

   # Test unitario
   def test_no_execution_without_approval():
       params = {'quarter': 'Q3', 'year': 2024, 'segment': 'OP'}
       count = get_count(params)  # 10,500
       
       approval = get_approval_status(user_id, params)
       assert approval.status == 'PENDING'
       
       with pytest.raises(ApprovalRequiredError):
           execute_query(params)


----------------------------------------------------------------------
SECCION 4: ANALISIS POR TIPO DE BR
----------------------------------------------------------------------

**Instrucción:**

Completa SOLO la subsección que corresponde al tipo de tu BR.
Las demás subsecciones pueden eliminarse o dejarse marcadas como N/A.

4.1 Si es RESTRICCION
~~~~~~~~~~~~~~~~~~~~~

**¿Qué restringe esta BR?**

[Describe específicamente qué acciones, datos, estados o comportamientos
están limitados por esta regla. Sé preciso.]

**¿Cuándo aplica la restricción?**

[Condiciones temporales, contextuales o de estado bajo las cuales
la restricción está activa. Incluye:
- Momento (¿cuándo?)
- Contexto (¿en qué situación?)
- Actor (¿para quién?)]

**¿Cómo se valida el cumplimiento?**

[Método técnico de validación. Puede ser:
- Query SQL que verifica la condición
- Cálculo o comparación
- Verificación de estado
- Comparación con umbral
- Otro método]

**Código de validación:**

.. code-block:: sql

   -- Ejemplo de query de validación
   SELECT ...

O:

.. code-block:: python

   def validate_restriction():
       # Lógica de validación
       ...

**¿Qué sucede si se viola la restricción?**

[Comportamiento del sistema cuando se intenta violar la restricción:
- Mensaje de error específico
- Bloqueo de acción
- Registro en log
- Notificación
- Flujo alterno activado]

**Mensaje de error (si aplica):**

   "[Texto exacto del mensaje que ve el usuario]"

**Ejemplo Completo (BR-IACT-028):**

Restringe:
- Ejecución directa de consultas SQL que retornarían >10,000 registros
- Afecta a: Reportes trimestrales, anuales, por segmento

Aplica cuando:
- Momento: Usuario solicita generar reporte
- Contexto: count(registros) > 10,000
- Actor: Cualquier usuario con permiso RPT-001

Validación:

.. code-block:: sql

   SELECT COUNT(*) as record_count
   FROM ivr_calls
   WHERE quarter = :quarter
     AND year = :year
     AND segment = :segment;
   
   -- Si record_count > 10000 → Restricción se activa

Violación:

Si usuario intenta ejecutar query sin aprobación:

1. Sistema bloquea ejecución de SELECT principal
2. Sistema muestra mensaje:
   
   "Esta consulta requiere aprobación del supervisor
   (retornaría 10,500 registros, límite: 10,000).
   
   Se ha enviado solicitud de aprobación.
   Recibirá notificación cuando sea aprobada."

3. Sistema registra en audit_log:
   
   .. code-block:: sql
   
      INSERT INTO audit_log (
          action, user_id, details, severity
      ) VALUES (
          'QUERY_BLOCKED_APPROVAL_REQUIRED',
          :user_id,
          'Count: 10500, Threshold: 10000',
          'INFO'
      )

4. Sistema NO retorna datos al usuario

4.2 Si es CALCULO
~~~~~~~~~~~~~~~~~

**Fórmula Matemática:**

Representa la fórmula en notación matemática y en código:

**Notación Matemática:**

.. math::

   variable_{resultado} = \frac{numerador}{denominador} \times factor

**Notación de Código:**

.. code-block:: text

   variable_resultado = (numerador / denominador) * factor

**Componentes del Cálculo:**

**Entradas (Inputs):**

.. list-table::
   :header-rows: 1
   :widths: 25 20 20 35

   * - Variable
     - Tipo Dato
     - Rango Válido
     - Fuente
   * - [nombre_var_1]
     - [INTEGER|FLOAT]
     - [min, max]
     - [tabla.campo]
   * - [nombre_var_2]
     - [DECIMAL(p,s)]
     - [min, max]
     - [tabla.campo]

**Salida (Output):**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Propiedad
     - Valor
   * - Tipo
     - [INTEGER|FLOAT|DECIMAL(p,s)|PERCENTAGE]
   * - Rango esperado
     - [min, max]
   * - Precisión decimal
     - [número de decimales]
   * - Unidad
     - [%, USD, registros, segundos, etc.]

**Casos Especiales:**

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Situación
     - Manejo
   * - División por cero
     - [Retornar NULL | Retornar 0 | Throw exception]
   * - Valores NULL
     - [Tratar como 0 | Saltar | Retornar NULL]
   * - Valores fuera de rango
     - [Validar y rechazar | Clamp a rango | Warning]
   * - Overflow numérico
     - [Usar DECIMAL | Limitar a MAX_VALUE]

**Código de Implementación:**

.. code-block:: python

   def calculate_[nombre](input1, input2):
       """
       Implements BR-IACT-XXX: [Nombre de la BR]
       
       Args:
           input1 (tipo): Descripción
           input2 (tipo): Descripción
       
       Returns:
           tipo: Resultado del cálculo
       
       Raises:
           ValueError: Si inputs son inválidos
       """
       # Validar inputs
       if input2 == 0:
           return None  # Manejo de división por cero
       
       # Cálculo
       resultado = (input1 / input2) * 100
       
       # Redondear
       resultado = round(resultado, 2)
       
       return resultado

**Ejemplo Completo (BR-IACT-053):**

Fórmula Matemática:

.. math::

   tasa\_abandono = \frac{llamadas\_abandonadas}{total\_llamadas} \times 100

Código:

.. code-block:: python

   tasa_abandono = (llamadas_abandonadas / total_llamadas) * 100

Entradas:

.. list-table::
   :header-rows: 1
   :widths: 25 20 20 35

   * - Variable
     - Tipo
     - Rango
     - Fuente
   * - llamadas_abandonadas
     - INTEGER
     - >= 0
     - COUNT(*) WHERE status='ABANDONED'
   * - total_llamadas
     - INTEGER
     - > 0
     - COUNT(*) FROM ivr_calls

Salida:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Propiedad
     - Valor
   * - Tipo
     - DECIMAL(5,2)
   * - Rango esperado
     - 0.00 a 100.00
   * - Precisión decimal
     - 2 decimales
   * - Unidad
     - % (porcentaje)

Casos Especiales:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Situación
     - Manejo
   * - total_llamadas = 0
     - Retornar NULL y registrar WARNING en log
   * - llamadas_abandonadas NULL
     - Tratar como 0
   * - Resultado > 100
     - ERROR (datos corruptos, investigar)
   * - Resultado < 0
     - ERROR (datos corruptos, investigar)

Código Python:

.. code-block:: python

   def calculate_abandon_rate(abandoned_calls, total_calls):
       """
       Implements BR-IACT-053: Cálculo de Tasa de Abandono
       
       Formula: (abandoned / total) * 100
       
       Args:
           abandoned_calls (int): Llamadas abandonadas
           total_calls (int): Total de llamadas
       
       Returns:
           Decimal: Tasa de abandono (0.00 - 100.00)
           None: Si total_calls es 0
       
       Raises:
           ValueError: Si inputs son negativos o resultado inválido
       """
       # Validaciones
       if abandoned_calls < 0 or total_calls < 0:
           raise ValueError("Inputs no pueden ser negativos")
       
       # Caso especial: división por cero
       if total_calls == 0:
           logger.warning(
               "Cannot calculate abandon rate: total_calls is 0"
           )
           return None
       
       # Cálculo
       rate = (abandoned_calls / total_calls) * 100
       
       # Validar rango
       if rate < 0 or rate > 100:
           logger.error(
               f"Invalid abandon rate: {rate}. "
               f"Abandoned: {abandoned_calls}, Total: {total_calls}"
           )
           raise ValueError(f"Abandon rate out of range: {rate}")
       
       # Redondear a 2 decimales
       return round(rate, 2)

4.3 Si es DESENCADENADOR
~~~~~~~~~~~~~~~~~~~~~~~~~

**TEST DE OBSERVABILIDAD (CRÍTICO):**

.. code-block:: text

   Pregunta: ¿El usuario VE algo como resultado directo de esta BR?
   
   [ ] SÍ → Es DESENCADENADOR (continúa llenando esta sección)
   [ ] NO → Es INFERENCIA (ve sección 4.4 en su lugar)

**¿Qué desencadena esta BR?**

[Descripción detallada de la acción OBSERVABLE por el usuario:
- Notificación (modal, toast, banner)
- Mensaje en UI
- Email
- SMS
- Push notification
- Alerta sonora
- Cambio visual en pantalla
- Cualquier cosa que el usuario PERCIBA]

**Actor que Recibe la Acción:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Propiedad
     - Valor
   * - Tipo de Actor
     - [Usuario interno | Usuario externo | Sistema externo]
   * - Rol Específico
     - [Analista | Supervisor | Admin | Cliente | etc.]
   * - Canal
     - [Pantalla/UI | Email | SMS | Push | Slack | etc.]
   * - Dispositivo
     - [Web | Mobile | Desktop | Todos]

**Contenido de la Acción:**

[Qué información se comunica al actor]

**Formato del mensaje/notificación:**

   "[Texto exacto o template del mensaje]"

**Elementos visuales (si aplica):**

- Icono: [descripción]
- Color: [verde/rojo/amarillo/azul]
- Botones: [Aceptar], [Cancelar], [Ver Más], etc.
- Campos: [Si es form con datos]

**Timing:**

[Cuándo exactamente se ejecuta la acción]

- [ ] Inmediatamente tras evento
- [ ] Con delay de [X] segundos/minutos
- [ ] En horario específico: [hora]
- [ ] Tras [N] minutos/horas de [condición]
- [ ] Otro: [especificar]

**Genera UC Completo:**

**SÍ** (obligatorio para Desencadenadores)

- **UC ID:** UC_IACT_[MOD]_NN_[Nombre]_4_0_0.rst
- **Nombre:** [Nombre del UC generado]
- **Actor Principal:** [Actor que recibe la acción]
- **Tipo UC:** [Normal|Temporal]

**Ejemplo Completo (BR-IACT-031):**

Test de Observabilidad:

- Pregunta: ¿Usuario VE algo?
- Respuesta: SÍ (ve modal emergente)
- Conclusión: Es DESENCADENADOR ✓

Desencadena:

Modal emergente en UI con:

- Título: "Sesión próxima a expirar"
- Mensaje: "Su sesión expirará en 3 minutos. ¿Desea extenderla?"
- Botones: [Extender Sesión] [Cerrar Sesión Ahora]
- Icono: ⚠️ (warning amarillo)

Actor:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Propiedad
     - Valor
   * - Tipo
     - Usuario interno autenticado
   * - Rol
     - Cualquier rol (Analista, Supervisor, Admin)
   * - Canal
     - Pantalla/UI (modal JavaScript)
   * - Dispositivo
     - Web y Desktop app

Contenido:

Formato del mensaje:

   "Su sesión expirará en 3 minutos. ¿Desea extenderla?"

Elementos visuales:

- Modal centered: 400px width
- Fondo semi-transparente (backdrop)
- Icono: ⚠️ warning amarillo (32px)
- Título: "Sesión próxima a expirar" (bold, 18px)
- Mensaje: Texto descrito arriba (14px)
- Botón primario: "Extender Sesión" (azul)
- Botón secundario: "Cerrar Sesión Ahora" (gris)
- No se puede cerrar haciendo click fuera (requiere acción)

Timing:

- Cuando: last_activity_at + 12 minutos = NOW()
- Es decir: 3 minutos ANTES de expiración (timeout = 15 min)
- Cron check: Cada 30 segundos
- Si usuario hace actividad → cancela notificación

Genera UC:

SÍ

- UC ID: UC_IACT_AUTH_07_Notificar_Sesion_Proxima_Expiracion_4_0_0.rst
- Nombre: Notificar Sesión Próxima a Expiración
- Actor Principal: Usuario Autenticado (cualquier rol)
- Tipo: Normal (UI-driven)

4.4 Si es INFERENCIA
~~~~~~~~~~~~~~~~~~~~

**TEST DE OBSERVABILIDAD (CRÍTICO):**

.. code-block:: text

   Pregunta: ¿El usuario VE algo como resultado directo de esta BR?
   
   [ ] SÍ → Es DESENCADENADOR (ve sección 4.3 en su lugar)
   [ ] NO → Es INFERENCIA (continúa llenando esta sección)

**¿Qué cambia internamente?**

[Descripción del cambio SILENCIOSO en el sistema:
- Campo en base de datos
- Estado interno
- Flag booleano
- Timestamp
- Contador
- Cálculo no visible
- Variable de sistema]

**Tabla/Campo Afectado:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Propiedad
     - Valor
   * - Tabla
     - [nombre_tabla]
   * - Campo(s)
     - [campo_1, campo_2, ...]
   * - Valor Anterior
     - [estado/valor previo]
   * - Valor Nuevo
     - [estado/valor resultante]
   * - Tipo Cambio
     - [UPDATE | INSERT | DELETE]

**Actor que Recibe:**

**Ninguno** (cambio silencioso en sistema)

El usuario NO percibe este cambio directamente. Puede verlo DESPUÉS
si consulta explícitamente (ej: ver historial, ver estado), pero NO
recibe notificación ni acción visible automática.

**Trigger del Cambio:**

[Qué evento interno o temporal dispara el cambio]

- [ ] Cron job / Scheduler
- [ ] Tiempo transcurrido (timeout)
- [ ] Condición en base de datos
- [ ] Evento interno de sistema
- [ ] Callback de servicio externo
- [ ] Otro: [especificar]

**Detalle del trigger:**

[Especificación exacta: cron expression, condición SQL, timeout, etc.]

**Genera UC Completo:**

**NO** (las Inferencias NO generan UC completo)

**Patrón de implementación:**

1. Derivar FR directamente (sin UC intermedio)
2. Si requiere proceso programado → implementar como UC Temporal con actor=Sistema
3. UC Temporal es interno, no visible por usuarios

**FR Derivado:**

- **FR ID:** FR_[MOD]_NN_ZZ_[Nombre]_1_0_0.rst
- **Nombre:** [Nombre del FR]
- **Tipo:** [UPDATE|Query_Temporal|Cron_Job]

**UC Temporal (si aplica):**

- **UC ID:** UC_IACT_[MOD]_NN_[Nombre]_4_0_0.rst
- **Nombre:** [Nombre del proceso]
- **Actor:** Sistema (Scheduler)

**Ejemplo Completo (BR-IACT-046):**

Test de Observabilidad:

- Pregunta: ¿Usuario VE algo?
- Respuesta: NO (solo cambia campo en BD)
- Conclusión: Es INFERENCIA ✓

Cambia:

Campo sessions.status pasa de 'ACTIVE' a 'EXPIRED'
Campo sessions.expired_at se establece en NOW()

Tabla/Campo:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Propiedad
     - Valor
   * - Tabla
     - ivr_sessions
   * - Campos
     - status, expired_at
   * - Valor Anterior
     - status='ACTIVE', expired_at=NULL
   * - Valor Nuevo
     - status='EXPIRED', expired_at=NOW()
   * - Tipo Cambio
     - UPDATE

Actor:

Ninguno (cambio silencioso)

Usuario NO ve notificación. Descubrirá que sesión expiró cuando
intente hacer su próxima acción y sistema le pida re-autenticarse.

Trigger:

Cron job programado

Detalle:

.. code-block:: text

   Cron expression: */1 * * * * (cada 1 minuto)
   
   Comando: python manage.py mark_expired_sessions
   
   Condición SQL:
   UPDATE ivr_sessions
   SET status = 'EXPIRED',
       expired_at = NOW()
   WHERE status = 'ACTIVE'
     AND last_activity_at < NOW() - INTERVAL '15 minutes'

Genera UC:

NO (no genera UC completo)

FR Derivado:

- FR ID: FR_AUTH_08_02_Marcar_Sesiones_Expiradas_1_0_0.rst
- Nombre: UPDATE Sesiones Expiradas por Inactividad
- Tipo: UPDATE (query ejecutada por cron)

UC Temporal (para documentar el cron):

- UC ID: UC_IACT_AUTH_08_Marcar_Sesiones_Expiradas_4_0_0.rst
- Nombre: Marcar Sesiones Expiradas (Proceso Programado)
- Actor: Sistema (Scheduler Cron)
- Tipo: Temporal

Nota: Este UC_AUTH_08 es INTERNO, documenta el proceso cron,
pero NO es UC "generado por BR" en el sentido tradicional.
Es una conveniencia para documentar procesos programados.

4.5 Si es DEFINICION
~~~~~~~~~~~~~~~~~~~~

**Término Definido:**

[Palabra, concepto o entidad del dominio que se está definiendo]

**Definición Formal:**

[Definición precisa, sin ambigüedad, que puede usarse para determinar
inequívocamente si algo pertenece o no a esta categoría]

**Atributos o Criterios:**

.. list-table::
   :header-rows: 1
   :widths: 10 50 40

   * - #
     - Criterio
     - Verificación
   * - 1
     - [Condición que debe cumplirse]
     - [Cómo se verifica]
   * - 2
     - [Otra condición]
     - [Cómo se verifica]
   * - 3
     - [Otra condición]
     - [Cómo se verifica]

**Lógica de Criterios:**

- [ ] TODOS deben cumplirse (AND)
- [ ] AL MENOS UNO debe cumplirse (OR)
- [ ] Lógica compleja: [especificar]

**Ejemplos (Instancias que SÍ cumplen):**

1. **[Ejemplo concreto 1]**
   
   Cumple porque: [explicación de por qué cumple cada criterio]

2. **[Ejemplo concreto 2]**
   
   Cumple porque: [...]

3. **[Ejemplo concreto 3]**
   
   Cumple porque: [...]

**Contraejemplos (Instancias que NO cumplen):**

1. **[Contraejemplo 1]**
   
   NO cumple porque: [explicación de qué criterio falla y por qué]

2. **[Contraejemplo 2]**
   
   NO cumple porque: [...]

**Uso en el Sistema:**

[Cómo se utiliza esta definición en el sistema]

- En queries SQL: [WHERE cláusula]
- En lógica de negocio: [Condicional if]
- En reportes: [Filtro]
- En UI: [Dropdown, filtro, label]
- Otro: [especificar]

**Código de Implementación:**

.. code-block:: sql

   -- Query que identifica instancias que cumplen la definición
   SELECT ...

O:

.. code-block:: python

   def is_[termino](entity):
       """
       Determines if entity meets definition of [término]
       
       Implements BR-IACT-XXX
       """
       return (criterio_1 and criterio_2 and criterio_3)

**Ejemplo Completo (BR-IACT-001):**

Término:

Cliente Activo

Definición:

Un cliente se considera activo si cumple AL MENOS UNA de las siguientes
condiciones en los últimos 90 días:

- Ha realizado una llamada al IVR
- Ha iniciado sesión en el sistema web
- Ha sido contactado por el equipo de operaciones

Criterios:

.. list-table::
   :header-rows: 1
   :widths: 10 50 40

   * - #
     - Criterio
     - Verificación SQL
   * - 1
     - Llamada en últimos 90 días
     - EXISTS (SELECT 1 FROM ivr_calls WHERE customer_id=X AND call_date >= NOW()-INTERVAL '90 days')
   * - 2
     - Sesión en últimos 90 días
     - EXISTS (SELECT 1 FROM ivr_sessions WHERE customer_id=X AND created_at >= NOW()-INTERVAL '90 days')
   * - 3
     - Contacto en últimos 90 días
     - EXISTS (SELECT 1 FROM customer_contacts WHERE customer_id=X AND contact_date >= NOW()-INTERVAL '90 days')

Lógica:

AL MENOS UNO debe cumplirse (OR)

Ejemplos SÍ cumplen:

1. **Cliente que llamó hace 30 días**
   
   Cumple criterio 1: llamada dentro de ventana de 90 días
   Estado: ACTIVO

2. **Cliente que inició sesión ayer**
   
   Cumple criterio 2: sesión dentro de ventana de 90 días
   Estado: ACTIVO

3. **Cliente contactado hace 89 días**
   
   Cumple criterio 3: contacto dentro de ventana (89 < 90)
   Estado: ACTIVO

4. **Cliente que llamó hace 60 días Y fue contactado hace 10 días**
   
   Cumple criterios 1 y 3: múltiples actividades recientes
   Estado: ACTIVO (doblemente confirmado)

Contraejemplos NO cumplen:

1. **Cliente que llamó hace 91 días**
   
   NO cumple ningún criterio: actividad fuera de ventana de 90 días
   Estado: INACTIVO

2. **Cliente sin llamadas, sesiones ni contactos**
   
   NO cumple ningún criterio: sin actividad registrada
   Estado: INACTIVO

3. **Cliente dado de baja en el sistema (deleted_at != NULL)**
   
   Aunque cumpla criterios de actividad, está marcado como eliminado
   Estado: INACTIVO (override por baja)

Uso en Sistema:

Query SQL para reportes:

.. code-block:: sql

   SELECT customer_id, name
   FROM customers
   WHERE deleted_at IS NULL
     AND (
         EXISTS (
             SELECT 1 FROM ivr_calls
             WHERE customer_id = customers.id
               AND call_date >= NOW() - INTERVAL '90 days'
         )
         OR EXISTS (
             SELECT 1 FROM ivr_sessions
             WHERE customer_id = customers.id
               AND created_at >= NOW() - INTERVAL '90 days'
         )
         OR EXISTS (
             SELECT 1 FROM customer_contacts
             WHERE customer_id = customers.id
               AND contact_date >= NOW() - INTERVAL '90 days'
         )
     )

Dashboard UI:

- Filtro "Mostrar solo activos" (checkbox)
- Cuando checked → aplica query de arriba
- Badge: "ACTIVO" (verde) o "INACTIVO" (gris)

Segmentación:

- Campañas de marketing dirigidas solo a clientes activos
- Reportes ejecutivos: "Clientes activos vs total"

Código Python:

.. code-block:: python

   def is_active_customer(customer_id, as_of_date=None):
       """
       Determines if customer is ACTIVE per BR-IACT-001
       
       Args:
           customer_id (UUID): Customer ID
           as_of_date (datetime): Reference date (default: now)
       
       Returns:
           bool: True if customer is active
       """
       if as_of_date is None:
           as_of_date = datetime.now()
       
       cutoff_date = as_of_date - timedelta(days=90)
       
       # Check if deleted
       customer = Customer.objects.get(id=customer_id)
       if customer.deleted_at is not None:
           return False
       
       # Check criteria
       has_recent_call = IVRCall.objects.filter(
           customer_id=customer_id,
           call_date__gte=cutoff_date
       ).exists()
       
       has_recent_session = IVRSession.objects.filter(
           customer_id=customer_id,
           created_at__gte=cutoff_date
       ).exists()
       
       has_recent_contact = CustomerContact.objects.filter(
           customer_id=customer_id,
           contact_date__gte=cutoff_date
       ).exists()
       
       return (
           has_recent_call or
           has_recent_session or
           has_recent_contact
       )


----------------------------------------------------------------------
SECCION 5: GENERA UC (Forward Traceability)
----------------------------------------------------------------------

**Reglas de Transformación BR → UC:**

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Tipo BR
     - ¿Genera UC?
     - Patrón de Implementación
   * - Restricción
     - NO
     - Precondición + Flujo Alterno en UC existente
   * - Cálculo
     - NO
     - Paso en flujo normal (no UC propio)
   * - Desencadenador
     - SÍ
     - UC completo NUEVO
   * - Inferencia
     - NO
     - FR directo (+ UC temporal opcional para cron)
   * - Definición
     - NO
     - Glosario/Diccionario (no genera UC ni FR)

5.1 UC Generados o Afectados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Si esta BR genera UC nuevo:**

- **UC Generado:**
  
  - **ID:** UC_IACT_[MOD]_NN_[Nombre]_4_0_0.rst
  - **Nombre:** [Nombre descriptivo del UC]
  - **Actor Principal:** [Usuario o Sistema]
  - **Tipo:** [Normal|Temporal|CRUD]
  - **Archivo:** [Nombre del archivo UC]

**Si esta BR afecta UC existente:**

- **UC Afectado:**
  
  - **ID:** UC_IACT_[MOD]_NN_[Nombre]_4_0_0.rst
  - **Nombre:** [Nombre del UC existente]
  - **Donde se implementa:** [Paso N | FA-X | FE-X | Precondición PC-N]
  - **Tipo de impacto:** [Agrega validación | Modifica flujo | Nueva precondición | Nuevo FA]

**Si esta BR NO genera UC:**

- **Razón:** [Es Cálculo | Es Inferencia | Es Definición]
- **Implementación directa:** FR_[MOD]_NN_ZZ_[Nombre]_1_0_0.rst
- **O:** Se implementa en paso X del UC_[MOD]_NN

**Ejemplos por Tipo:**

Restricción (BR-IACT-028):

.. code-block:: text

   NO genera UC nuevo
   
   Afecta: UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
   
   Implementa en:
   - Precondición PC-4: count <= 10,000 para ejecución directa
   - FA-2: Consulta Requiere Aprobación (cuando count > 10,000)

Cálculo (BR-IACT-053):

.. code-block:: text

   NO genera UC propio
   
   Se usa en: UC_IACT_RPT_01_Consultar_Reporte paso 9
   
   Derivación: FR_RPT_01_09_Calcular_Metricas_1_0_0.rst

Desencadenador (BR-IACT-031):

.. code-block:: text

   SÍ genera UC nuevo
   
   UC Generado:
   - ID: UC_IACT_AUTH_07_Notificar_Sesion_4_0_0.rst
   - Nombre: Notificar Sesión Próxima a Expiración
   - Actor: Usuario Autenticado
   - Tipo: Normal (UI-driven)

Inferencia (BR-IACT-046):

.. code-block:: text

   NO genera UC (cambio silencioso)
   
   Derivación directa:
   - FR_AUTH_08_02_Marcar_Sesiones_Expiradas_1_0_0.rst
   
   UC Temporal (opcional):
   - UC_IACT_AUTH_08_Marcar_Sesiones_Expiradas_4_0_0.rst
   - Actor: Sistema (Cron Scheduler)

Definición (BR-IACT-001):

.. code-block:: text

   NO genera UC
   NO genera FR
   
   Se documenta en:
   - Glosario de Términos
   - Diccionario de Datos
   
   Se USA en:
   - WHERE clauses de múltiples UC
   - Filtros en reportes
   - Segmentación

----------------------------------------------------------------------
SECCION 6: TRAZABILIDAD FORWARD COMPLETA
----------------------------------------------------------------------

**Árbol de Trazabilidad:**

Desde esta BR hasta código y tests:

.. code-block:: text

   BRQ-XXX ([Nombre del BReq])
     |
     └─> BR-IACT-XXX ([Nombre de esta BR])
           |
           ├─> UC_IACT_XXX_YY_[Nombre]_4_0_0.rst
           |     |
           |     ├─> Paso 5 → FR_XXX_YY_01_[Nombre]_1_0_0.rst
           |     |              |
           |     |              └─> modulo_1_0_0/archivo.py::funcion_1 (linea 234)
           |     |                    |
           |     |                    └─> tests/test_modulo.py::test_funcion_1
           |     |
           |     ├─> Paso 8 → FR_XXX_YY_02_[Nombre]_1_0_0.rst
           |     |              |
           |     |              └─> modulo_1_0_0/archivo.py::funcion_2 (linea 456)
           |     |                    |
           |     |                    └─> tests/test_modulo.py::test_funcion_2
           |     |
           |     └─> FA-2 → FR_XXX_YY_03_[Nombre]_1_0_0.rst
           |                  |
           |                  └─> modulo_1_0_0/archivo.py::funcion_3 (linea 789)
           |                        |
           |                        └─> tests/test_modulo.py::test_funcion_3
           |
           └─> [Otros UC si aplica]

**Ejemplo Concreto (BR-IACT-028):**

.. code-block:: text

   BRQ-015 (Optimizar Performance Reportes)
     |
     └─> BR-IACT-028 (Aprobación Consultas Grandes)
           |
           └─> UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
                 |
                 ├─> Paso 6 → FR_RPT_01_07_Calcular_Count_1_0_0.rst
                 |              |
                 |              └─> reports_1_0_0/services.py::calculate_query_count
                 |                    (linea 234-248)
                 |                    |
                 |                    ├─> tests/test_reports.py::test_calculate_count_normal
                 |                    ├─> tests/test_reports.py::test_calculate_count_large
                 |                    └─> tests/test_reports.py::test_calculate_count_timeout
                 |
                 ├─> Paso 7 → FR_RPT_01_08_Evaluar_Umbral_1_0_0.rst
                 |              |
                 |              └─> reports_1_0_0/services.py::evaluate_threshold
                 |                    (linea 250-260)
                 |                    |
                 |                    └─> tests/test_reports.py::test_evaluate_threshold
                 |
                 └─> FA-2 → FR_RPT_01_10_Crear_Approval_1_0_0.rst
                              |
                              └─> reports_1_0_0/approvals.py::create_approval
                                    (linea 89-120)
                                    |
                                    ├─> tests/test_approvals.py::test_create_approval
                                    ├─> tests/test_approvals.py::test_notify_supervisor
                                    └─> tests/integration/test_approval_flow.py

**Matriz de Trazabilidad (formato tabla):**

.. list-table::
   :header-rows: 1
   :widths: 15 20 25 25 15

   * - BR
     - UC
     - FR
     - Código
     - Tests
   * - BR-IACT-028
     - UC-RPT-01 (Paso 6)
     - FR-RPT-01-07
     - services.py:234
     - test_calculate_count
   * - BR-IACT-028
     - UC-RPT-01 (Paso 7)
     - FR-RPT-01-08
     - services.py:250
     - test_evaluate_threshold
   * - BR-IACT-028
     - UC-RPT-01 (FA-2)
     - FR-RPT-01-10
     - approvals.py:89
     - test_create_approval

----------------------------------------------------------------------
SECCION 7: IMPACTO DE CAMBIOS
----------------------------------------------------------------------

**Propósito:**

Analizar qué sucedería si esta BR cambiara, para facilitar análisis
de impacto futuro.

7.1 Análisis de Impacto
~~~~~~~~~~~~~~~~~~~~~~~~

**Si esta BR cambiara, se verían afectados:**

**UC Afectados:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - UC ID
     - Tipo de Cambio Necesario
   * - UC_IACT_XXX_YY
     - [Modificar paso N | Reescribir FA | Actualizar precondición]
   * - UC_IACT_AAA_BB
     - [...]

**FR Afectados:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - FR ID
     - Modificación Necesaria
   * - FR_XXX_YY_01
     - [Cambiar validación | Actualizar query | Modificar cálculo]
   * - FR_XXX_YY_02
     - [...]

**Archivos de Código:**

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Archivo
     - Función(es) a Modificar
   * - modulo_1_0_0/archivo.py
     - funcion_1() (linea 234), funcion_2() (linea 456)
   * - modulo_1_0_0/otro.py
     - clase.metodo() (linea 89)

**Tests Afectados:**

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Archivo Test
     - Test(s) a Actualizar
   * - tests/test_modulo.py
     - test_funcion_1, test_funcion_2
   * - tests/test_integracion.py
     - test_flujo_completo

**Stakeholders a Notificar:**

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Nombre
     - Rol
     - Razón de Notificación
   * - [Nombre Stakeholder]
     - [Rol]
     - [Por qué debe saber del cambio]

7.2 Escenarios de Cambio
~~~~~~~~~~~~~~~~~~~~~~~~~

**Escenario 1: [Tipo de cambio - ej: Cambio de valor umbral]**

Ejemplo: Cambiar umbral de 10,000 a 5,000 registros

**Cambios requeridos:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Componente
     - Acción
   * - UC-RPT-01
     - Actualizar documentación en FA-2 (nuevo umbral: 5,000)
   * - FR-RPT-01-07
     - Modificar constante THRESHOLD = 5000
   * - reports_1_0_0/services.py
     - Cambiar linea 240: THRESHOLD = 5000
   * - tests/test_reports.py
     - Actualizar valores en test_calculate_count_large (usar 5,001)
   * - BR-IACT-028
     - Actualizar enunciado y sección 4

**Estimación:**

- Esfuerzo: 2 horas
- Riesgo: Bajo (cambio de configuración)
- Impacto: Más consultas requerirán aprobación

**Escenario 2: [Tipo de cambio - ej: Cambio de lógica completa]**

Ejemplo: Eliminar aprobación, implementar paginación automática

**Cambios requeridos:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Componente
     - Acción
   * - UC-RPT-01
     - Eliminar FA-2 completo, agregar paso paginación
   * - FR-RPT-01-10
     - Eliminar (ya no hay approvals)
   * - FR-RPT-01-11 (NUEVO)
     - Crear: Implementar paginación automática
   * - reports_1_0_0/approvals.py
     - Deprecar archivo completo
   * - reports_1_0_0/pagination.py
     - Crear nuevo módulo
   * - tests/test_approvals.py
     - Deprecar suite completa
   * - tests/test_pagination.py (NUEVO)
     - Crear suite nueva
   * - DB Migration
     - Opcional: Archivar tabla approvals

**Estimación:**

- Esfuerzo: 16 horas (2 días)
- Riesgo: Alto (cambio de arquitectura)
- Impacto: Experiencia usuario muy diferente
- Requiere: Aprobación stakeholder, testing extenso

----------------------------------------------------------------------
SECCION 8: VALIDACION Y TESTING
----------------------------------------------------------------------

8.1 Cómo se Valida esta BR
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Test Funcional Manual:**

**Precondiciones:**

1. [Condición 1 que debe existir antes del test]
2. [Condición 2]
3. [Condición 3]

**Pasos del Test:**

1. [Paso de preparación]
2. [Paso de ejecución]
3. [Paso de verificación]

**Resultado Esperado:**

[Descripción detallada del resultado que demuestra que BR se cumple]

**Resultado Actual:**

[A completar durante ejecución del test]

- [ ] PASS
- [ ] FAIL (describir falla)

**Evidencia:**

- Screenshot: [adjuntar]
- Log: [adjuntar extracto]
- Query resultado: [adjuntar]

8.2 Tests Automatizados
~~~~~~~~~~~~~~~~~~~~~~~~

**Tests Unitarios:**

.. code-block:: python

   # tests/test_[modulo].py
   
   import pytest
   from modulo import funcion_bajo_test
   
   def test_br_iact_xxx_caso_normal():
       """
       Valida BR-IACT-XXX en caso normal.
       
       Given: [Condición inicial]
       When: [Acción ejecutada]
       Then: [Resultado esperado]
       """
       # Arrange
       param1 = valor_valido_1
       param2 = valor_valido_2
       
       # Act
       resultado = funcion_bajo_test(param1, param2)
       
       # Assert
       assert resultado == valor_esperado
       assert resultado.tipo == 'esperado'
   
   def test_br_iact_xxx_caso_borde_superior():
       """Valida BR en límite superior."""
       # Arrange
       param = valor_limite_max
       
       # Act
       resultado = funcion_bajo_test(param)
       
       # Assert
       assert resultado is not None
       assert resultado <= max_permitido
   
   def test_br_iact_xxx_caso_borde_inferior():
       """Valida BR en límite inferior."""
       param = valor_limite_min
       resultado = funcion_bajo_test(param)
       assert resultado >= min_permitido
   
   def test_br_iact_xxx_caso_error_division_cero():
       """Valida manejo de división por cero."""
       with pytest.raises(ZeroDivisionError):
           funcion_bajo_test(numerador=10, denominador=0)
   
   def test_br_iact_xxx_caso_input_invalido():
       """Valida rechazo de inputs inválidos."""
       with pytest.raises(ValueError, match="Input fuera de rango"):
           funcion_bajo_test(param=-1)  # negativo no permitido

**Tests de Integración:**

.. code-block:: python

   # tests/integration/test_[modulo]_integration.py
   
   import pytest
   from django.test import TestCase
   
   class TestBRIACT_XXX_Integration(TestCase):
       """
       Integration tests for BR-IACT-XXX.
       
       Validates complete flow from UC through FR to DB.
       """
       
       def setUp(self):
           """Setup test data."""
           self.user = create_test_user()
           self.client.login(username=self.user.username)
       
       def test_br_iact_xxx_flujo_completo(self):
           """
           Valida BR-IACT-XXX en flujo end-to-end.
           
           Validates: BR-IACT-XXX
           Related UC: UC-IACT-YYY-ZZ
           """
           # Given
           data = {
               'param1': 'valor1',
               'param2': 'valor2'
           }
           
           # When
           response = self.client.post('/api/endpoint/', data)
           
           # Then
           self.assertEqual(response.status_code, 200)
           result = response.json()
           self.assertEqual(result['status'], 'success')
           
           # Verify DB state
           obj = Model.objects.get(id=result['id'])
           self.assertEqual(obj.field, expected_value)

8.3 Criterios de Aceptación de Tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Para considerar esta BR validada:**

.. list-table::
   :header-rows: 1
   :widths: 50 10 40

   * - Criterio
     - Status
     - Evidencia
   * - Tests unitarios pasan 100%
     - [ ]
     - [Link a reporte]
   * - Tests de integración pasan 100%
     - [ ]
     - [Link a reporte]
   * - Test manual ejecutado y documentado
     - [ ]
     - [Link a documento]
   * - Cobertura de código >= 80% en funciones relacionadas
     - [ ]
     - [Link a coverage report]
   * - Validado por QA Engineer
     - [ ]
     - [Firma: _______ Fecha: _____]
   * - Aprobado por Business Analyst
     - [ ]
     - [Firma: _______ Fecha: _____]
   * - Firmado por Stakeholder
     - [ ]
     - [Firma: _______ Fecha: _____]

----------------------------------------------------------------------
SECCION 9: NOTAS Y EXCEPCIONES
----------------------------------------------------------------------

9.1 Excepciones Conocidas
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Excepción 1: [Situación excepcional]**

- **Descripción:** [Cuándo no aplica la BR]
- **Razón:** [Por qué existe esta excepción]
- **Comportamiento alternativo:** [Qué hacer en su lugar]
- **Frecuencia:** [Común|Rara|Muy rara]
- **Stakeholder que aprobó:** [Nombre]

**Ejemplo:**

Excepción 1: Usuarios Administradores

- Descripción: Administradores del sistema pueden ejecutar cualquier
  consulta sin límite ni aprobación
- Razón: Necesidad operativa para debugging y análisis urgente
- Comportamiento: Sistema valida rol, si user.role='ADMIN' → skip approval
- Frecuencia: Rara (2-3 veces/mes)
- Stakeholder: CTO aprobó el 2024-11-20

9.2 Notas Técnicas
~~~~~~~~~~~~~~~~~~

**Consideraciones de Implementación:**

- [Nota técnica importante 1]
- [Nota técnica importante 2]
- [Limitaciones conocidas]

**Dependencias Externas:**

- [Servicio externo necesario]
- [Librería o API requerida]
- [Configuración especial]

**Performance:**

- [Consideraciones de performance]
- [Índices requeridos]
- [Optimizaciones aplicadas]

9.3 Decisiones de Diseño
~~~~~~~~~~~~~~~~~~~~~~~~~

**Decision 1: [Título de la decisión]**

- **Fecha:** YYYY-MM-DD
- **Contexto:** [Por qué se necesitaba decidir]
- **Alternativas consideradas:**
  
  - Opción A: [descripción]
  - Opción B: [descripción]
  - Opción C: [descripción]

- **Decisión tomada:** [Opción elegida]
- **Razón:** [Por qué se eligió esta opción]
- **Trade-offs:** [Qué se sacrificó]

----------------------------------------------------------------------
SECCION 10: HISTORIAL DE VERSIONES
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
     - Version inicial - Creacion de BR
     - [Nombre del BA]
   * - 1.1.0
     - YYYY-MM-DD
     - [Descripcion del cambio MINOR - nueva funcionalidad compatible]
     - [Nombre del BA]
   * - 2.0.0
     - YYYY-MM-DD
     - [Cambio MAJOR - breaking change, incompatible con v1.x]
     - [Nombre del BA]

**Notas sobre Versionado Semántico:**

- **MAJOR (X.0.0):** Cambios incompatibles que rompen implementación actual
  
  Ejemplo: Cambiar de "aprobación supervisor" a "paginación automática"

- **MINOR (0.X.0):** Nueva funcionalidad compatible con versión anterior
  
  Ejemplo: Agregar nueva excepción para usuarios VIP

- **PATCH (0.0.X):** Correcciones y clarificaciones sin cambio funcional
  
  Ejemplo: Corregir typo en enunciado

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estándares del Proyecto:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagógico:**

- PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
  
  - Sección 2: Taxonomía de Business Rules (5 tipos)
  - Sección 3: Desencadenadores vs Inferencias (TEST CRITICO)
  - Sección 4: Documentación de BR
  - Sección 5: Derivación BR → UC → FR

**Documentos Relacionados:**

- BRQ_XXX_[Nombre]_1_0_0.rst (Business Requirement padre)
- UC_IACT_XXX_YY_[Nombre]_4_0_0.rst (Use Cases generados/afectados)
- FR_XXX_YY_ZZ_[Nombre]_1_0_0.rst (Functional Requirements derivados)

**Fuentes Externas:**

- [URL a documento externo si aplica]
- [Referencia a estándar de industria]
- [Regulación o normativa]

----------------------------------------------------------------------
ANEXOS
----------------------------------------------------------------------

ANEXO A: Glosario de Términos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**[Término 1]:** [Definición breve específica a esta BR]

**[Término 2]:** [Definición]

ANEXO B: Diagramas
~~~~~~~~~~~~~~~~~~

[Insertar diagramas de flujo, entidad-relación, secuencia, etc.]

ANEXO C: Ejemplos Adicionales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[Ejemplos detallados adicionales si son necesarios para clarificar]

----------------------------------------------------------------------

.. note::
   **CHECKLIST DE CALIDAD (14 PUNTOS):**
   
   Antes de marcar esta BR como APPROVED, verificar:
   
   Sección 1: Enunciado
   - [ ] Enunciado claro y conciso (1 frase)
   - [ ] Tipo de BR correctamente identificado
   - [ ] Test de observabilidad aplicado (si Desencadenador vs Inferencia)
   
   Sección 2: Derivado De
   - [ ] Trazabilidad backward completa (BReq, Stakeholder)
   - [ ] Contexto de negocio documentado
   
   Sección 3: Criterios
   - [ ] Criterios de aceptación medibles (mínimo 3)
   
   Sección 4: Análisis por Tipo
   - [ ] Sección de tipo BR completamente llenada
   
   Sección 5-6: Trazabilidad
   - [ ] Trazabilidad forward documentada (UC, FR, código)
   
   Sección 7: Impacto
   - [ ] Análisis de impacto de cambios completo
   
   Sección 8: Testing
   - [ ] Tests definidos (manual y automatizados)
   
   Sección 9-10: Documentación
   - [ ] Metadata correcta al inicio
   - [ ] Versión semántica aplicada
   - [ ] Referencias actualizadas

**REGLA DE ORO DEL TEST DE OBSERVABILIDAD:**

Si no puedes decidir si es Desencadenador o Inferencia,
aplica el TEST:

   ¿El usuario VE algo? → SI = Desencadenador | NO = Inferencia

----------------------------------------------------------------------

**Archivo:** TPL_BR_Decision_Tipo_1_2_0.rst  
**Version Template:** 1.2.0  
**Fecha Creacion Template:** 2026-01-09  
**Autor Template:** Sistema de Regeneracion IACT  
**Lineas Totales:** ~900


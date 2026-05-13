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


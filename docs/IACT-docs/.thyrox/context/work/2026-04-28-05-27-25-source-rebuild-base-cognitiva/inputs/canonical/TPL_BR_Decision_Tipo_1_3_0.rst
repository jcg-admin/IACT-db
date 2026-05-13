.. meta::
   :Proyecto: IACT
   :Codigo: BR-IACT-XXX
   :Titulo: Titulo Descriptivo de la Business Rule
   :Version: 1.0.0
   :Tipo: Restriccion|Calculo|Desencadenador|Inferencia|Definicion
   :Genera_UC: UC-IACT-XXX-YY o "-" si no genera
   :Fecha: YYYY-MM-DD
   :Autor: Nombre del Business Analyst
   :Estado: DRAFT|REVIEW|APPROVED|IMPLEMENTED

======================================================================
BR-IACT-XXX: Titulo Descriptivo de la Business Rule
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Tipo:** Restriccion|Calculo|Desencadenador|Inferencia|Definicion  
**Estado:** DRAFT|REVIEW|APPROVED|IMPLEMENTED  
**Prioridad:** Alta|Media|Baja  
**Clasificacion:** C2 - INTERNAL

----------------------------------------------------------------------
INTRODUCCION AL TEMPLATE
----------------------------------------------------------------------

Este template documenta Business Rules siguiendo la taxonomia estandar
de 5 tipos de BR, con enfasis en el TEST DE OBSERVABILIDAD para
distinguir correctamente entre Desencadenadores e Inferencias.

**Proposito de las Business Rules:**

Las BR son declaraciones de politica o condicion del negocio que:

1. Restringen comportamientos del sistema
2. Calculan valores derivados
3. Desencadenan acciones observables por usuarios
4. Infieren cambios silenciosos en el estado
5. Definen conceptos del dominio

**Importancia de la Clasificacion Correcta:**

La clasificacion determina como se implementa la BR:

- Restriccion: Precondicion + Flujo Alterno en UC existente
- Calculo: Paso en flujo normal, no genera UC propio
- Desencadenador: UC completo NUEVO, actor ve algo
- Inferencia: NO genera UC, solo FR directo, cambio silencioso
- Definicion: Glosario/Diccionario de datos, no genera UC ni FR

**Test de Observabilidad (CRITICO):**

.. code-block:: text

   Pregunta: El usuario VE algo como resultado de esta BR?
   
   SI -> Es DESENCADENADOR
        - Usuario ve notificacion, mensaje, modal, email, etc.
        - Genera UC completo
        - Actor: Usuario que recibe la accion
   
   NO -> Es INFERENCIA
        - Solo cambia BD, estado interno, timestamp
        - NO genera UC completo
        - Deriva FR directo
        - Puede implementarse en UC temporal con actor Sistema

----------------------------------------------------------------------
SECCION 1: ENUNCIADO
----------------------------------------------------------------------

**Definicion:**

El enunciado es una frase declarativa clara y concisa que describe
la regla de negocio en lenguaje natural, comprensible por stakeholders
no tecnicos.

**Caracteristicas de un buen enunciado:**

1. Una sola frase, puede tener clausulas pero un punto final
2. Verbo en presente indicativo, no condicional
3. Sujeto claro: sistema, usuario, entidad
4. Sin ambiguedad, terminos precisos, sin jerga
5. Testable, se puede verificar si se cumple

**Formato general:**

   "Sujeto verbo complemento condicion si aplica."

**ENUNCIADO:**

Escribe aqui el enunciado de tu BR en una sola frase clara

**Ejemplos Completos por Tipo:**

1.1 Ejemplo: Restriccion
~~~~~~~~~~~~~~~~~~~~~~~~~

**BR-IACT-028: Aprobacion de Consultas Grandes**

**Enunciado:**

"Las consultas de reportes que retornen mas de 10,000 registros deben
ser aprobadas por el supervisor del area antes de ejecutarse."

**Analisis del enunciado:**

- Sujeto: "Las consultas de reportes"
- Verbo: "deben ser aprobadas"
- Complemento: "por el supervisor del area"
- Condicion: "que retornen mas de 10,000 registros"
- Timing: "antes de ejecutarse"

**Criterio de cumplimiento:**

Sistema puede verificar si count > 10,000 y si existe aprobacion.

1.2 Ejemplo: Calculo
~~~~~~~~~~~~~~~~~~~~

**BR-IACT-053: Calculo de Tasa de Abandono**

**Enunciado:**

"La tasa de abandono se calcula dividiendo el numero de llamadas
abandonadas entre el total de llamadas, multiplicado por 100."

**Analisis del enunciado:**

- Sujeto: "La tasa de abandono"
- Verbo: "se calcula"
- Complemento: "dividiendo... entre... multiplicado por 100"
- Formula implicita: abandonadas / total * 100

**Criterio de cumplimiento:**

Sistema aplica la formula correctamente y retorna porcentaje.

1.3 Ejemplo: Desencadenador
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**BR-IACT-031: Notificacion de Sesion Proxima a Expirar**

**Enunciado:**

"El sistema debe notificar al usuario cuando su sesion este proxima a
expirar, tres minutos antes del timeout."

**Analisis del enunciado:**

- Sujeto: "El sistema"
- Verbo: "debe notificar"
- Complemento: "al usuario"
- Condicion: "cuando su sesion este proxima a expirar"
- Timing: "tres minutos antes del timeout"

**Test de observabilidad:**

Usuario VE algo? SI, ve modal/notificacion
Por lo tanto: Es DESENCADENADOR

**Criterio de cumplimiento:**

Usuario recibe notificacion visible 3 minutos antes de expiracion.

1.4 Ejemplo: Inferencia
~~~~~~~~~~~~~~~~~~~~~~~

**BR-IACT-046: Marcar Sesiones Expiradas**

**Enunciado:**

"El sistema debe marcar automaticamente las sesiones como expiradas
cuando superen 15 minutos de inactividad."

**Analisis del enunciado:**

- Sujeto: "El sistema"
- Verbo: "debe marcar"
- Complemento: "las sesiones como expiradas"
- Condicion: "cuando superen 15 minutos de inactividad"

**Test de observabilidad:**

Usuario VE algo? NO, solo cambia campo en BD
Por lo tanto: Es INFERENCIA

**Criterio de cumplimiento:**

Campo sessions.status = 'EXPIRED' cuando inactividad > 15 min.

1.5 Ejemplo: Definicion
~~~~~~~~~~~~~~~~~~~~~~~

**BR-IACT-001: Cliente Activo**

**Enunciado:**

"Un cliente se considera activo si ha realizado al menos una llamada
en los ultimos 90 dias."

**Analisis del enunciado:**

- Termino definido: "Cliente Activo"
- Criterio: "ha realizado al menos una llamada en los ultimos 90 dias"

**Criterio de cumplimiento:**

Existe registro en ivr_calls con call_date >= NOW() - INTERVAL '90 days'

----------------------------------------------------------------------
SECCION 2: DERIVADO DE (Backward Traceability)
----------------------------------------------------------------------

**Proposito:**

Documentar el origen de esta BR para mantener trazabilidad hacia atras.
Esto permite responder:

- Quien solicito esta BR?
- De que Business Requirement deriva?
- Cual es el contexto de negocio?
- Por que existe esta regla?

2.1 Business Requirement Padre
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**BReq Padre:**

- ID: BRQ-XXX
- Nombre: Nombre del Business Requirement
- Archivo: BRQ_XXX_Nombre_1_0_0.rst si existe
- Seccion: Numero de seccion del BReq donde se menciona

**Justificacion:**

Explica como esta BR contribuye a satisfacer el BReq padre. Responde:
Por que esta BR es necesaria para cumplir el BReq?

**Ejemplo Completo (BR-IACT-028):**

BReq Padre:
- ID: BRQ-015
- Nombre: Optimizar Performance de Reportes
- Archivo: BRQ_015_Optimizar_Performance_1_0_0.rst
- Seccion: 3.2 Controlar volumen de consultas

Justificacion:

Esta BR contribuye al BRQ-015 porque previene que consultas masivas
degraden el performance del sistema. Al requerir aprobacion para
queries mayores a 10K registros, aseguramos que:

1. Consultas grandes se ejecuten fuera de horario pico
2. Se evalúe si realmente son necesarias
3. Se optimicen parametros antes de ejecucion
4. Se mantenga experiencia de usuario para consultas normales

2.2 Stakeholder
~~~~~~~~~~~~~~~

**Identificacion del Stakeholder:**

- Nombre completo: Nombre y Apellido
- Rol/Cargo: Titulo del puesto
- Area/Departamento: Departamento de la organizacion
- Email: email@ejemplo.com
- Telefono: +XX XXX XXX XXXX (opcional)

**Fecha de Elicitacion:** YYYY-MM-DD

**Metodo de Elicitacion:**

- Entrevista presencial
- Reunion virtual
- Email
- Workshop
- Analisis de documentos
- Observacion directa

**Referencia Documental:**

- Acta de reunion: Archivo o link a acta
- Email de confirmacion: Asunto del email / link
- Grabacion: Link a grabacion si aplica
- Documento de requerimientos: Si stakeholder envio doc

**Quote textual del stakeholder:**

   "Texto exacto que dijo el stakeholder sobre esta necesidad"

**Ejemplo Completo (BR-IACT-028):**

Stakeholder:
- Nombre: Maria Rodriguez
- Rol: Gerente de Operaciones
- Area: Call Center Operations
- Email: maria.rodriguez@iact.com

Fecha: 2024-11-15

Metodo: Entrevista presencial

Referencia:
- Acta: ACTA_REUNION_OPS_2024_11_15.docx
- Email confirmacion: "RE: Requerimientos Performance Reportes"

Quote textual:

"Necesitamos controlar las consultas grandes porque a veces los
analistas piden reportes de todo el ano y eso deja el sistema lento
para todos. Queremos que si alguien va a hacer una consulta muy
grande, tenga que pedirme permiso primero para que yo vea si
realmente lo necesita y cuando es mejor hacerlo."

2.3 Contexto del Negocio
~~~~~~~~~~~~~~~~~~~~~~~~~

**Problema que Resuelve:**

Descripcion del problema o dolor del negocio que motiva esta BR.
Que estaba saliendo mal? Que riesgo se busca mitigar?

**Situacion Actual (As-Is):**

Como funcionan las cosas HOY sin esta BR

**Situacion Deseada (To-Be):**

Como deberian funcionar CON esta BR implementada

**Impacto Esperado:**

Beneficios medibles que esta BR traera al negocio

**Categorias de Impacto:**

- Eficiencia operativa
- Cumplimiento normativo
- Experiencia de usuario
- Reduccion de costos
- Mitigacion de riesgos
- Calidad de datos
- Seguridad
- Otro: especificar

**Metricas de Exito:**

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Metrica
     - Valor Actual
     - Valor Objetivo
   * - Nombre de metrica 1
     - Valor hoy
     - Valor esperado
   * - Nombre de metrica 2
     - Valor hoy
     - Valor esperado

**Ejemplo Completo (BR-IACT-028):**

Problema:

Analistas ejecutan consultas de reportes sin restricciones, causando:
- Timeouts en BD, queries mayores a 30 seg
- Degradacion de performance para otros usuarios
- Costos de infraestructura elevados, CPU picos de 95%
- Frustracion de usuarios, sistema "se cuelga"

As-Is:

Cualquier usuario con permiso RPT-001 puede ejecutar cualquier
consulta sin limites de volumen. Sistema intenta ejecutar y si
tarda mucho (>30 seg), devuelve timeout.

To-Be:

Sistema evalua volumen de consulta ANTES de ejecutar. Si supera
10,000 registros, solicita aprobacion de supervisor. Supervisor
puede aprobar, rechazar, o pedir optimizar parametros.

Impacto Esperado:

- Eficiencia operativa: Consultas grandes en horario controlado
- Experiencia usuario: Sistema responsivo para consultas normales
- Reduccion costos: Menos picos de CPU, infraestructura optimizada

Metricas:

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Metrica
     - Valor Actual
     - Valor Objetivo
   * - Tiempo respuesta p95 consultas normales
     - 8.5 segundos
     - menor 3 segundos
   * - Consultas con timeout
     - 15% mensual
     - menor 2% mensual
   * - CPU promedio en horario pico
     - 85%
     - menor 60%
   * - Quejas de usuarios por lentitud
     - 23/mes
     - menor 5/mes

----------------------------------------------------------------------
SECCION 3: CRITERIOS DE ACEPTACION
----------------------------------------------------------------------

**Definicion:**

Los Criterios de Aceptacion son condiciones especificas, medibles
y verificables que deben cumplirse para considerar que la BR esta
correctamente implementada.

**Formato: Given-When-Then (Gherkin)**

.. code-block:: gherkin

   CA-N: Titulo descriptivo del criterio
   
   Dado: Condicion inicial / estado del sistema
   Cuando: Accion o evento que se ejecuta
   Entonces: Resultado esperado OBSERVABLE

**Caracteristicas de buenos CA:**

1. Especificos: Sin ambiguedad, no genericos
2. Medibles: Se puede verificar objetivamente
3. Verificables: Se puede probar con test manual o automatizado
4. Completos: Cubren caso normal + casos borde
5. Independientes: Cada CA es auto-contenido

**Numero Recomendado:**

- Minimo: 3 CA (caso normal + 2 casos borde/error)
- Tipico: 5-7 CA
- Maximo recomendado: 10 CA

**CRITERIOS DE ACEPTACION:**

CA-1: Titulo del criterio 1 - Caso Normal

**Dado:** Precondicion / estado inicial

**Cuando:** Accion del usuario o evento del sistema

**Entonces:** Resultado observable esperado

**Verificacion:**

Como se puede verificar este criterio: query SQL, inspeccion UI,
log, etc.

CA-2: Titulo del criterio 2 - Caso Borde

**Dado:** ...

**Cuando:** ...

**Entonces:** ...

**Verificacion:** ...

**Ejemplo Completo (BR-IACT-028):**

CA-1: Sistema calcula count antes de ejecutar query principal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:**
- Usuario autenticado con permiso RPT-001
- Usuario solicita reporte trimestral con parametros:
  - Trimestre: Q3
  - Ano: 2024
  - Segmento: OP

**Cuando:**
- Usuario hace click en boton "Generar Reporte"

**Entonces:**
- Sistema ejecuta COUNT(*) con mismos parametros ANTES de SELECT principal
- Sistema registra count en variable temporal
- Query COUNT debe completarse en menor 2 segundos

**Verificacion:**

.. code-block:: sql

   -- Log debe mostrar:
   SELECT COUNT(*) FROM ivr_calls
   WHERE quarter = 'Q3' AND year = 2024 AND segment = 'OP'
   -- Resultado: 10,500

CA-2: Sistema solicita aprobacion si count mayor 10,000
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:**
- Count calculado es 10,500 registros, mayor umbral de 10,000

**Cuando:**
- Sistema evalua resultado del count

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
- Sistema crea notificacion para supervisor

**Verificacion:**

.. code-block:: sql

   SELECT * FROM approvals
   WHERE user_id = :user_id
     AND created_at > NOW() - INTERVAL '1 minute'
     AND status = 'PENDING'
   -- Debe retornar 1 fila

CA-3: Supervisor recibe notificacion en buzon interno
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:**
- Consulta requiere aprobacion
- Supervisor identificado: supervisor_id = 'SUP-001'

**Cuando:**
- Sistema crea registro de aprobacion

**Entonces:**
- Supervisor ve notificacion en su bandeja de entrada
- Notificacion contiene:
  - Titulo: "Aprobacion requerida: Consulta de nombre_usuario"
  - Descripcion: "Consulta retornaria 10,500 registros"
  - Link directo a pantalla de aprobacion
  - Timestamp
- Badge de notificaciones incrementa +1

**Verificacion:**

.. code-block:: sql

   SELECT * FROM notifications
   WHERE recipient_id = 'SUP-001'
     AND type = 'APPROVAL_REQUEST'
     AND read_at IS NULL
   ORDER BY created_at DESC
   LIMIT 1
   -- Debe retornar la notificacion creada

CA-4: Usuario ve mensaje de espera
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:**
- Consulta enviada a aprobacion

**Cuando:**
- Sistema termina proceso de solicitud de aprobacion

**Entonces:**
- Usuario ve modal con mensaje:
  
  "Su consulta requiere aprobacion del supervisor debido al
  volumen de datos (10,500 registros).
  
  Le notificaremos cuando sea aprobada o rechazada.
  
  Tiempo estimado de respuesta: 2-4 horas."

- Modal tiene boton "OK"
- Al hacer click en "OK", redirige a dashboard de reportes

**Verificacion:**

- Inspeccion visual de UI
- Test automatizado con Selenium/Cypress

CA-5: Sistema no ejecuta query principal si no hay aprobacion
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Dado:**
- Consulta con count = 10,500
- Estado aprobacion = 'PENDING', no aprobada aun

**Cuando:**
- Cualquier intento de ejecutar query principal

**Entonces:**
- Sistema rechaza ejecucion
- Sistema retorna error con codigo ERR-APPROVAL-REQUIRED
- Log registra intento de ejecucion sin aprobacion
- Usuario NO ve resultados

**Verificacion:**

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

**Instruccion:**

Completa SOLO la subseccion que corresponde al tipo de tu BR.
Las demas subsecciones pueden eliminarse o dejarse marcadas como N/A.

4.1 Si es RESTRICCION
~~~~~~~~~~~~~~~~~~~~~

**Que restringe esta BR?**

Describe especificamente que acciones, datos, estados o comportamientos
estan limitados por esta regla. Se preciso.

**Cuando aplica la restriccion?**

Condiciones temporales, contextuales o de estado bajo las cuales
la restriccion esta activa. Incluye:
- Momento: cuando?
- Contexto: en que situacion?
- Actor: para quien?

**Como se valida el cumplimiento?**

Metodo tecnico de validacion. Puede ser:
- Query SQL que verifica la condicion
- Calculo o comparacion
- Verificacion de estado
- Comparacion con umbral
- Otro metodo

**Codigo de validacion:**

.. code-block:: sql

   -- Ejemplo de query de validacion
   SELECT ...

O:

.. code-block:: python

   def validate_restriction():
       # Logica de validacion
       ...

**Que sucede si se viola la restriccion?**

Comportamiento del sistema cuando se intenta violar la restriccion:
- Mensaje de error especifico
- Bloqueo de accion
- Registro en log
- Notificacion
- Flujo alterno activado

**Mensaje de error si aplica:**

   "Texto exacto del mensaje que ve el usuario"

**Ejemplo Completo (BR-IACT-028):**

Restringe:
- Ejecucion directa de consultas SQL que retornarian mayor 10,000 registros
- Afecta a: Reportes trimestrales, anuales, por segmento

Aplica cuando:
- Momento: Usuario solicita generar reporte
- Contexto: count(registros) mayor 10,000
- Actor: Cualquier usuario con permiso RPT-001

Validacion:

.. code-block:: sql

   SELECT COUNT(*) as record_count
   FROM ivr_calls
   WHERE quarter = :quarter
     AND year = :year
     AND segment = :segment;
   
   -- Si record_count > 10000 → Restriccion se activa

Violacion:

Si usuario intenta ejecutar query sin aprobacion:

1. Sistema bloquea ejecucion de SELECT principal
2. Sistema muestra mensaje:
   
   "Esta consulta requiere aprobacion del supervisor
   (retornaria 10,500 registros, limite: 10,000).
   
   Se ha enviado solicitud de aprobacion.
   Recibira notificacion cuando sea aprobada."

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

**Formula Matematica:**

Representa la formula en notacion matematica y en codigo:

**Notacion Matematica:**

.. math::

   variable_{resultado} = \frac{numerador}{denominador} \times factor

**Notacion de Codigo:**

.. code-block:: text

   variable_resultado = (numerador / denominador) * factor

**Componentes del Calculo:**

**Entradas (Inputs):**

.. list-table::
   :header-rows: 1
   :widths: 25 20 20 35

   * - Variable
     - Tipo Dato
     - Rango Valido
     - Fuente
   * - nombre_var_1
     - INTEGER|FLOAT
     - min, max
     - tabla.campo
   * - nombre_var_2
     - DECIMAL(p,s)
     - min, max
     - tabla.campo

**Salida (Output):**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Propiedad
     - Valor
   * - Tipo
     - INTEGER|FLOAT|DECIMAL(p,s)|PERCENTAGE
   * - Rango esperado
     - min, max
   * - Precision decimal
     - numero de decimales
   * - Unidad
     - %, USD, registros, segundos, etc.

**Casos Especiales:**

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Situacion
     - Manejo
   * - Division por cero
     - Retornar NULL | Retornar 0 | Throw exception
   * - Valores NULL
     - Tratar como 0 | Saltar | Retornar NULL
   * - Valores fuera de rango
     - Validar y rechazar | Clamp a rango | Warning
   * - Overflow numerico
     - Usar DECIMAL | Limitar a MAX_VALUE

**Codigo de Implementacion:**

.. code-block:: python

   def calculate_nombre(input1, input2):
       """
       Implements BR-IACT-XXX: Nombre de la BR
       
       Args:
           input1 (tipo): Descripcion
           input2 (tipo): Descripcion
       
       Returns:
           tipo: Resultado del calculo
       
       Raises:
           ValueError: Si inputs son invalidos
       """
       # Validar inputs
       if input2 == 0:
           return None  # Manejo de division por cero
       
       # Calculo
       resultado = (input1 / input2) * 100
       
       # Redondear
       resultado = round(resultado, 2)
       
       return resultado

**Ejemplo Completo (BR-IACT-053):**

Formula Matematica:

.. math::

   tasa\_abandono = \frac{llamadas\_abandonadas}{total\_llamadas} \times 100

Codigo:

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
   * - Precision decimal
     - 2 decimales
   * - Unidad
     - % (porcentaje)

Casos Especiales:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Situacion
     - Manejo
   * - total_llamadas = 0
     - Retornar NULL y registrar WARNING en log
   * - llamadas_abandonadas NULL
     - Tratar como 0
   * - Resultado mayor 100
     - ERROR, datos corruptos, investigar
   * - Resultado menor 0
     - ERROR, datos corruptos, investigar

Codigo Python:

.. code-block:: python

   def calculate_abandon_rate(abandoned_calls, total_calls):
       """
       Implements BR-IACT-053: Calculo de Tasa de Abandono
       
       Formula: (abandoned / total) * 100
       
       Args:
           abandoned_calls (int): Llamadas abandonadas
           total_calls (int): Total de llamadas
       
       Returns:
           Decimal: Tasa de abandono (0.00 - 100.00)
           None: Si total_calls es 0
       
       Raises:
           ValueError: Si inputs son negativos o resultado invalido
       """
       import logging
       
       logger = logging.getLogger(__name__)
       
       # Validaciones
       if abandoned_calls < 0 or total_calls < 0:
           raise ValueError("Inputs no pueden ser negativos")
       
       # Caso especial: division por cero
       if total_calls == 0:
           logger.warning(
               "Cannot calculate abandon rate: total_calls is 0"
           )
           return None
       
       # Calculo
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

**TEST DE OBSERVABILIDAD (CRITICO):**

.. code-block:: text

   Pregunta: El usuario VE algo como resultado directo de esta BR?
   
   [ ] SI → Es DESENCADENADOR (continua llenando esta seccion)
   [ ] NO → Es INFERENCIA (ve seccion 4.4 en su lugar)

**Que desencadena esta BR?**

Descripcion detallada de la accion OBSERVABLE por el usuario:
- Notificacion (modal, toast, banner)
- Mensaje en UI
- Email
- SMS
- Push notification
- Alerta sonora
- Cambio visual en pantalla
- Cualquier cosa que el usuario PERCIBA

**Actor que Recibe la Accion:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Propiedad
     - Valor
   * - Tipo de Actor
     - Usuario interno | Usuario externo | Sistema externo
   * - Rol Especifico
     - Analista | Supervisor | Admin | Cliente | etc.
   * - Canal
     - Pantalla/UI | Email | SMS | Push | Slack | etc.
   * - Dispositivo
     - Web | Mobile | Desktop | Todos

**Contenido de la Accion:**

Que informacion se comunica al actor

**Formato del mensaje/notificacion:**

   "Texto exacto o template del mensaje"

**Elementos visuales si aplica:**

- Icono: descripcion
- Color: verde/rojo/amarillo/azul
- Botones: Aceptar, Cancelar, Ver Mas, etc.
- Campos: Si es form con datos

**Timing:**

Cuando exactamente se ejecuta la accion

- Inmediatamente tras evento
- Con delay de X segundos/minutos
- En horario especifico: hora
- Tras N minutos/horas de condicion
- Otro: especificar

**Genera UC Completo:**

SÍ (obligatorio para Desencadenadores)

- UC ID: UC_IACT_MOD_NN_Nombre_4_0_0.rst
- Nombre: Nombre del UC generado
- Actor Principal: Actor que recibe la accion
- Tipo UC: Normal|Temporal

**Ejemplo Completo (BR-IACT-031):**

Test de Observabilidad:

- Pregunta: Usuario VE algo?
- Respuesta: SI, ve modal emergente
- Conclusion: Es DESENCADENADOR

Desencadena:

Modal emergente en UI con:

- Titulo: "Sesion proxima a expirar"
- Mensaje: "Su sesion expirara en 3 minutos. Desea extenderla?"
- Botones: Extender Sesion | Cerrar Sesion Ahora
- Icono: advertencia amarillo

Actor:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Propiedad
     - Valor
   * - Tipo
     - Usuario interno autenticado
   * - Rol
     - Cualquier rol, Analista, Supervisor, Admin
   * - Canal
     - Pantalla/UI, modal JavaScript
   * - Dispositivo
     - Web y Desktop app

Contenido:

Formato del mensaje:

   "Su sesion expirara en 3 minutos. Desea extenderla?"

Elementos visuales:

- Modal centered: 400px width
- Fondo semi-transparente, backdrop
- Icono: advertencia amarillo 32px
- Titulo: "Sesion proxima a expirar", bold, 18px
- Mensaje: Texto descrito arriba, 14px
- Boton primario: "Extender Sesion", azul
- Boton secundario: "Cerrar Sesion Ahora", gris
- No se puede cerrar haciendo click fuera, requiere accion

Timing:

- Cuando: last_activity_at + 12 minutos = NOW()
- Es decir: 3 minutos ANTES de expiracion, timeout = 15 min
- Cron check: Cada 30 segundos
- Si usuario hace actividad → cancela notificacion

Genera UC:

SI

- UC ID: UC_IACT_AUTH_07_Notificar_Sesion_Proxima_Expiracion_4_0_0.rst
- Nombre: Notificar Sesion Proxima a Expiracion
- Actor Principal: Usuario Autenticado, cualquier rol
- Tipo: Normal, UI-driven

4.4 Si es INFERENCIA
~~~~~~~~~~~~~~~~~~~~

**TEST DE OBSERVABILIDAD (CRITICO):**

.. code-block:: text

   Pregunta: El usuario VE algo como resultado directo de esta BR?
   
   [ ] SI → Es DESENCADENADOR (ve seccion 4.3 en su lugar)
   [ ] NO → Es INFERENCIA (continua llenando esta seccion)

**Que cambia internamente?**

Descripcion del cambio SILENCIOSO en el sistema:
- Campo en base de datos
- Estado interno
- Flag booleano
- Timestamp
- Contador
- Calculo no visible
- Variable de sistema

**Tabla/Campo Afectado:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Propiedad
     - Valor
   * - Tabla
     - nombre_tabla
   * - Campo(s)
     - campo_1, campo_2, ...
   * - Valor Anterior
     - estado/valor previo
   * - Valor Nuevo
     - estado/valor resultante
   * - Tipo Cambio
     - UPDATE | INSERT | DELETE

**Actor que Recibe:**

NINGUNO, cambio silencioso en sistema

El usuario NO percibe este cambio directamente. Puede verlo DESPUES
si consulta explicitamente, ejemplo ver historial, ver estado, pero NO
recibe notificacion ni accion visible automatica.

**Trigger del Cambio:**

Que evento interno o temporal dispara el cambio

- Cron job / Scheduler
- Tiempo transcurrido, timeout
- Condicion en base de datos
- Evento interno de sistema
- Callback de servicio externo
- Otro: especificar

**Detalle del trigger:**

Especificacion exacta: cron expression, condicion SQL, timeout, etc.

**Genera UC Completo:**

NO, las Inferencias NO generan UC completo

**Patron de implementacion:**

1. Derivar FR directamente, sin UC intermedio
2. Si requiere proceso programado → implementar como UC Temporal con actor=Sistema
3. UC Temporal es interno, no visible por usuarios

**FR Derivado:**

- FR ID: FR_MOD_NN_ZZ_Nombre_1_0_0.rst
- Nombre: Nombre del FR
- Tipo: UPDATE|Query_Temporal|Cron_Job

**UC Temporal si aplica:**

- UC ID: UC_IACT_MOD_NN_Nombre_4_0_0.rst
- Nombre: Nombre del proceso
- Actor: Sistema, Scheduler

**Ejemplo Completo (BR-IACT-046):**

Test de Observabilidad:

- Pregunta: Usuario VE algo?
- Respuesta: NO, solo cambia campo en BD
- Conclusion: Es INFERENCIA

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

Ninguno, cambio silencioso

Usuario NO ve notificacion. Descubrira que sesion expiro cuando
intente hacer su proxima accion y sistema le pida re-autenticarse.

Trigger:

Cron job programado

Detalle:

.. code-block:: text

   Cron expression: */1 * * * * (cada 1 minuto)
   
   Comando: python manage.py mark_expired_sessions
   
   Condicion SQL:
   UPDATE ivr_sessions
   SET status = 'EXPIRED',
       expired_at = NOW()
   WHERE status = 'ACTIVE'
     AND last_activity_at < NOW() - INTERVAL '15 minutes'

Genera UC:

NO, no genera UC completo

FR Derivado:

- FR ID: FR_AUTH_08_02_Marcar_Sesiones_Expiradas_1_0_0.rst
- Nombre: UPDATE Sesiones Expiradas por Inactividad
- Tipo: UPDATE, query ejecutada por cron

UC Temporal, para documentar el cron:

- UC ID: UC_IACT_AUTH_08_Marcar_Sesiones_Expiradas_4_0_0.rst
- Nombre: Marcar Sesiones Expiradas, Proceso Programado
- Actor: Sistema, Scheduler Cron
- Tipo: Temporal

Nota: Este UC_AUTH_08 es INTERNO, documenta el proceso cron,
pero NO es UC "generado por BR" en el sentido tradicional.
Es una conveniencia para documentar procesos programados.

4.5 Si es DEFINICION
~~~~~~~~~~~~~~~~~~~~

**Termino Definido:**

Palabra, concepto o entidad del dominio que se esta definiendo

**Definicion Formal:**

Definicion precisa, sin ambiguedad, que puede usarse para determinar
inequivocamente si algo pertenece o no a esta categoria

**Atributos o Criterios:**

.. list-table::
   :header-rows: 1
   :widths: 10 50 40

   * - #
     - Criterio
     - Verificacion
   * - 1
     - Condicion que debe cumplirse
     - Como se verifica
   * - 2
     - Otra condicion
     - Como se verifica
   * - 3
     - Otra condicion
     - Como se verifica

**Logica de Criterios:**

- TODOS deben cumplirse, AND
- AL MENOS UNO debe cumplirse, OR
- Logica compleja: especificar

**Ejemplos (Instancias que SI cumplen):**

1. Ejemplo concreto 1
   
   Cumple porque: explicacion de por que cumple cada criterio

2. Ejemplo concreto 2
   
   Cumple porque: ...

3. Ejemplo concreto 3
   
   Cumple porque: ...

**Contraejemplos (Instancias que NO cumplen):**

1. Contraejemplo 1
   
   NO cumple porque: explicacion de que criterio falla y por que

2. Contraejemplo 2
   
   NO cumple porque: ...

**Uso en el Sistema:**

Como se utiliza esta definicion en el sistema

- En queries SQL: WHERE clausula
- En logica de negocio: Condicional if
- En reportes: Filtro
- En UI: Dropdown, filtro, label
- Otro: especificar

**Codigo de Implementacion:**

.. code-block:: sql

   -- Query que identifica instancias que cumplen la definicion
   SELECT ...

O:

.. code-block:: python

   def is_termino(entity):
       """
       Determines if entity meets definition of termino
       
       Implements BR-IACT-XXX
       """
       return (criterio_1 and criterio_2 and criterio_3)

**Ejemplo Completo (BR-IACT-001):**

Termino:

Cliente Activo

Definicion:

Un cliente se considera activo si cumple AL MENOS UNA de las siguientes
condiciones en los ultimos 90 dias:

- Ha realizado una llamada al IVR
- Ha iniciado sesion en el sistema web
- Ha sido contactado por el equipo de operaciones

Criterios:

.. list-table::
   :header-rows: 1
   :widths: 10 50 40

   * - #
     - Criterio
     - Verificacion SQL
   * - 1
     - Llamada en ultimos 90 dias
     - EXISTS (SELECT 1 FROM ivr_calls WHERE customer_id=X AND call_date >= NOW()-INTERVAL '90 days')
   * - 2
     - Sesion en ultimos 90 dias
     - EXISTS (SELECT 1 FROM ivr_sessions WHERE customer_id=X AND created_at >= NOW()-INTERVAL '90 days')
   * - 3
     - Contacto en ultimos 90 dias
     - EXISTS (SELECT 1 FROM customer_contacts WHERE customer_id=X AND contact_date >= NOW()-INTERVAL '90 days')

Logica:

AL MENOS UNO debe cumplirse, OR

Ejemplos SI cumplen:

1. Cliente que llamo hace 30 dias
   
   Cumple criterio 1: llamada dentro de ventana de 90 dias
   Estado: ACTIVO

2. Cliente que inicio sesion ayer
   
   Cumple criterio 2: sesion dentro de ventana de 90 dias
   Estado: ACTIVO

3. Cliente contactado hace 89 dias
   
   Cumple criterio 3: contacto dentro de ventana, 89 menor 90
   Estado: ACTIVO

4. Cliente que llamo hace 60 dias Y fue contactado hace 10 dias
   
   Cumple criterios 1 y 3: multiples actividades recientes
   Estado: ACTIVO, doblemente confirmado

Contraejemplos NO cumplen:

1. Cliente que llamo hace 91 dias
   
   NO cumple ningun criterio: actividad fuera de ventana de 90 dias
   Estado: INACTIVO

2. Cliente sin llamadas, sesiones ni contactos
   
   NO cumple ningun criterio: sin actividad registrada
   Estado: INACTIVO

3. Cliente dado de baja en el sistema, deleted_at != NULL
   
   Aunque cumpla criterios de actividad, esta marcado como eliminado
   Estado: INACTIVO, override por baja

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

- Filtro "Mostrar solo activos", checkbox
- Cuando checked → aplica query de arriba
- Badge: "ACTIVO", verde o "INACTIVO", gris

Segmentacion:

- Campanas de marketing dirigidas solo a clientes activos
- Reportes ejecutivos: "Clientes activos vs total"

Codigo Python:

.. code-block:: python

   from datetime import datetime, timedelta
   
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

**Reglas de Transformacion BR → UC:**

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Tipo BR
     - Genera UC?
     - Patron de Implementacion
   * - Restriccion
     - NO
     - Precondicion + Flujo Alterno en UC existente
   * - Calculo
     - NO
     - Paso en flujo normal, no UC propio
   * - Desencadenador
     - SI
     - UC completo NUEVO
   * - Inferencia
     - NO
     - FR directo + UC temporal opcional para cron
   * - Definicion
     - NO
     - Glosario/Diccionario, no genera UC ni FR

5.1 UC Generados o Afectados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Si esta BR genera UC nuevo:**

- UC Generado:
  
  - ID: UC_IACT_MOD_NN_Nombre_4_0_0.rst
  - Nombre: Nombre descriptivo del UC
  - Actor Principal: Usuario o Sistema
  - Tipo: Normal|Temporal|CRUD
  - Archivo: Nombre del archivo UC

**Si esta BR afecta UC existente:**

- UC Afectado:
  
  - ID: UC_IACT_MOD_NN_Nombre_4_0_0.rst
  - Nombre: Nombre del UC existente
  - Donde se implementa: Paso N | FA-X | FE-X | Precondicion PC-N
  - Tipo de impacto: Agrega validacion | Modifica flujo | Nueva precondicion | Nuevo FA

**Si esta BR NO genera UC:**

- Razon: Es Calculo | Es Inferencia | Es Definicion
- Implementacion directa: FR_MOD_NN_ZZ_Nombre_1_0_0.rst
- O: Se implementa en paso X del UC_MOD_NN

**Ejemplos por Tipo:**

Restriccion (BR-IACT-028):

.. code-block:: text

   NO genera UC nuevo
   
   Afecta: UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
   
   Implementa en:
   - Precondicion PC-4: count <= 10,000 para ejecucion directa
   - FA-2: Consulta Requiere Aprobacion, cuando count > 10,000

Calculo (BR-IACT-053):

.. code-block:: text

   NO genera UC propio
   
   Se usa en: UC_IACT_RPT_01_Consultar_Reporte paso 9
   
   Derivacion: FR_RPT_01_09_Calcular_Metricas_1_0_0.rst

Desencadenador (BR-IACT-031):

.. code-block:: text

   SI genera UC nuevo
   
   UC Generado:
   - ID: UC_IACT_AUTH_07_Notificar_Sesion_4_0_0.rst
   - Nombre: Notificar Sesion Proxima a Expiracion
   - Actor: Usuario Autenticado
   - Tipo: Normal, UI-driven

Inferencia (BR-IACT-046):

.. code-block:: text

   NO genera UC, cambio silencioso
   
   Derivacion directa:
   - FR_AUTH_08_02_Marcar_Sesiones_Expiradas_1_0_0.rst
   
   UC Temporal opcional:
   - UC_IACT_AUTH_08_Marcar_Sesiones_Expiradas_4_0_0.rst
   - Actor: Sistema, Cron Scheduler

Definicion (BR-IACT-001):

.. code-block:: text

   NO genera UC
   NO genera FR
   
   Se documenta en:
   - Glosario de Terminos
   - Diccionario de Datos
   
   Se USA en:
   - WHERE clauses de multiples UC
   - Filtros en reportes
   - Segmentacion

----------------------------------------------------------------------
SECCION 6: TRAZABILIDAD FORWARD COMPLETA
----------------------------------------------------------------------

**Arbol de Trazabilidad:**

Desde esta BR hasta codigo y tests:

.. code-block:: text

   BRQ-XXX (Nombre del BReq)
     |
     └─> BR-IACT-XXX (Nombre de esta BR)
           |
           ├─> UC_IACT_XXX_YY_Nombre_4_0_0.rst
           |     |
           |     ├─> Paso 5 → FR_XXX_YY_01_Nombre_1_0_0.rst
           |     |              |
           |     |              └─> modulo_1_0_0/archivo.py::funcion_1 (linea 234)
           |     |                    |
           |     |                    └─> tests/test_modulo.py::test_funcion_1
           |     |
           |     ├─> Paso 8 → FR_XXX_YY_02_Nombre_1_0_0.rst
           |     |              |
           |     |              └─> modulo_1_0_0/archivo.py::funcion_2 (linea 456)
           |     |                    |
           |     |                    └─> tests/test_modulo.py::test_funcion_2
           |     |
           |     └─> FA-2 → FR_XXX_YY_03_Nombre_1_0_0.rst
           |                  |
           |                  └─> modulo_1_0_0/archivo.py::funcion_3 (linea 789)
           |                        |
           |                        └─> tests/test_modulo.py::test_funcion_3
           |
           └─> Otros UC si aplica

**Ejemplo Concreto (BR-IACT-028):**

.. code-block:: text

   BRQ-015 (Optimizar Performance Reportes)
     |
     └─> BR-IACT-028 (Aprobacion Consultas Grandes)
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
     - Codigo
     - Tests
   * - BR-IACT-028
     - UC-RPT-01 Paso 6
     - FR-RPT-01-07
     - services.py:234
     - test_calculate_count
   * - BR-IACT-028
     - UC-RPT-01 Paso 7
     - FR-RPT-01-08
     - services.py:250
     - test_evaluate_threshold
   * - BR-IACT-028
     - UC-RPT-01 FA-2
     - FR-RPT-01-10
     - approvals.py:89
     - test_create_approval

----------------------------------------------------------------------
SECCION 7: IMPACTO DE CAMBIOS
----------------------------------------------------------------------

**Proposito:**

Analizar que sucederia si esta BR cambiara, para facilitar analisis
de impacto futuro.

7.1 Analisis de Impacto
~~~~~~~~~~~~~~~~~~~~~~~~

**Si esta BR cambiara, se verian afectados:**

**UC Afectados:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - UC ID
     - Tipo de Cambio Necesario
   * - UC_IACT_XXX_YY
     - Modificar paso N | Reescribir FA | Actualizar precondicion
   * - UC_IACT_AAA_BB
     - ...

**FR Afectados:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - FR ID
     - Modificacion Necesaria
   * - FR_XXX_YY_01
     - Cambiar validacion | Actualizar query | Modificar calculo
   * - FR_XXX_YY_02
     - ...

**Archivos de Codigo:**

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Archivo
     - Funcion(es) a Modificar
   * - modulo_1_0_0/archivo.py
     - funcion_1() linea 234, funcion_2() linea 456
   * - modulo_1_0_0/otro.py
     - clase.metodo() linea 89

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
     - Razon de Notificacion
   * - Nombre Stakeholder
     - Rol
     - Por que debe saber del cambio

7.2 Escenarios de Cambio
~~~~~~~~~~~~~~~~~~~~~~~~~

**Escenario 1: Tipo de cambio - ejemplo Cambio de valor umbral**

Ejemplo: Cambiar umbral de 10,000 a 5,000 registros

**Cambios requeridos:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Componente
     - Accion
   * - UC-RPT-01
     - Actualizar documentacion en FA-2, nuevo umbral: 5,000
   * - FR-RPT-01-07
     - Modificar constante THRESHOLD = 5000
   * - reports_1_0_0/services.py
     - Cambiar linea 240: THRESHOLD = 5000
   * - tests/test_reports.py
     - Actualizar valores en test_calculate_count_large, usar 5,001
   * - BR-IACT-028
     - Actualizar enunciado y seccion 4

**Estimacion:**

- Esfuerzo: 2 horas
- Riesgo: Bajo, cambio de configuracion
- Impacto: Mas consultas requeriran aprobacion

**Escenario 2: Tipo de cambio - ejemplo Cambio de logica completa**

Ejemplo: Eliminar aprobacion, implementar paginacion automatica

**Cambios requeridos:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Componente
     - Accion
   * - UC-RPT-01
     - Eliminar FA-2 completo, agregar paso paginacion
   * - FR-RPT-01-10
     - Eliminar, ya no hay approvals
   * - FR-RPT-01-11 NUEVO
     - Crear: Implementar paginacion automatica
   * - reports_1_0_0/approvals.py
     - Deprecar archivo completo
   * - reports_1_0_0/pagination.py
     - Crear nuevo modulo
   * - tests/test_approvals.py
     - Deprecar suite completa
   * - tests/test_pagination.py NUEVO
     - Crear suite nueva
   * - DB Migration
     - Opcional: Archivar tabla approvals

**Estimacion:**

- Esfuerzo: 16 horas, 2 dias
- Riesgo: Alto, cambio de arquitectura
- Impacto: Experiencia usuario muy diferente
- Requiere: Aprobacion stakeholder, testing extenso

----------------------------------------------------------------------
SECCION 8: VALIDACION Y TESTING
----------------------------------------------------------------------

8.1 Como se Valida esta BR
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Test Funcional Manual:**

**Precondiciones:**

1. Condicion 1 que debe existir antes del test
2. Condicion 2
3. Condicion 3

**Pasos del Test:**

1. Paso de preparacion
2. Paso de ejecucion
3. Paso de verificacion

**Resultado Esperado:**

Descripcion detallada del resultado que demuestra que BR se cumple

**Resultado Actual:**

A completar durante ejecucion del test

- PASS
- FAIL, describir falla

**Evidencia:**

- Screenshot: adjuntar
- Log: adjuntar extracto
- Query resultado: adjuntar

8.2 Tests Automatizados
~~~~~~~~~~~~~~~~~~~~~~~~

**Tests Unitarios:**

.. code-block:: python

   # tests/test_modulo.py
   
   import pytest
   from modulo import funcion_bajo_test
   
   def test_br_iact_xxx_caso_normal():
       """
       Valida BR-IACT-XXX en caso normal.
       
       Given: Condicion inicial
       When: Accion ejecutada
       Then: Resultado esperado
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
       """Valida BR en limite superior."""
       # Arrange
       param = valor_limite_max
       
       # Act
       resultado = funcion_bajo_test(param)
       
       # Assert
       assert resultado is not None
       assert resultado <= max_permitido
   
   def test_br_iact_xxx_caso_borde_inferior():
       """Valida BR en limite inferior."""
       param = valor_limite_min
       resultado = funcion_bajo_test(param)
       assert resultado >= min_permitido
   
   def test_br_iact_xxx_caso_error_division_cero():
       """Valida manejo de division por cero."""
       with pytest.raises(ZeroDivisionError):
           funcion_bajo_test(numerador=10, denominador=0)
   
   def test_br_iact_xxx_caso_input_invalido():
       """Valida rechazo de inputs invalidos."""
       with pytest.raises(ValueError, match="Input fuera de rango"):
           funcion_bajo_test(param=-1)  # negativo no permitido

**Tests de Integracion:**

.. code-block:: python

   # tests/integration/test_modulo_integration.py
   
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

8.3 Criterios de Aceptacion de Tests
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
     - Link a reporte
   * - Tests de integracion pasan 100%
     - [ ]
     - Link a reporte
   * - Test manual ejecutado y documentado
     - [ ]
     - Link a documento
   * - Cobertura de codigo >= 80% en funciones relacionadas
     - [ ]
     - Link a coverage report
   * - Validado por QA Engineer
     - [ ]
     - Firma: _______ Fecha: _____
   * - Aprobado por Business Analyst
     - [ ]
     - Firma: _______ Fecha: _____
   * - Firmado por Stakeholder
     - [ ]
     - Firma: _______ Fecha: _____

----------------------------------------------------------------------
SECCION 9: NOTAS Y EXCEPCIONES
----------------------------------------------------------------------

9.1 Excepciones Conocidas
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Excepcion 1: Situacion excepcional**

- Descripcion: Cuando no aplica la BR
- Razon: Por que existe esta excepcion
- Comportamiento alternativo: Que hacer en su lugar
- Frecuencia: Comun|Rara|Muy rara
- Stakeholder que aprobo: Nombre

**Ejemplo:**

Excepcion 1: Usuarios Administradores

- Descripcion: Administradores del sistema pueden ejecutar cualquier
  consulta sin limite ni aprobacion
- Razon: Necesidad operativa para debugging y analisis urgente
- Comportamiento: Sistema valida rol, si user.role='ADMIN' → skip approval
- Frecuencia: Rara, 2-3 veces/mes
- Stakeholder: CTO aprobo el 2024-11-20

9.2 Notas Tecnicas
~~~~~~~~~~~~~~~~~~

**Consideraciones de Implementacion:**

- Nota tecnica importante 1
- Nota tecnica importante 2
- Limitaciones conocidas

**Dependencias Externas:**

- Servicio externo necesario
- Libreria o API requerida
- Configuracion especial

**Performance:**

- Consideraciones de performance
- Indices requeridos
- Optimizaciones aplicadas

9.3 Decisiones de Diseno
~~~~~~~~~~~~~~~~~~~~~~~~~

**Decision 1: Titulo de la decision**

- Fecha: YYYY-MM-DD
- Contexto: Por que se necesitaba decidir
- Alternativas consideradas:
  
  - Opcion A: descripcion
  - Opcion B: descripcion
  - Opcion C: descripcion

- Decision tomada: Opcion elegida
- Razon: Por que se eligio esta opcion
- Trade-offs: Que se sacrifico

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
     - Nombre del BA
   * - 1.1.0
     - YYYY-MM-DD
     - Descripcion del cambio MINOR - nueva funcionalidad compatible
     - Nombre del BA
   * - 2.0.0
     - YYYY-MM-DD
     - Cambio MAJOR - breaking change, incompatible con v1.x
     - Nombre del BA

**Notas sobre Versionado Semantico:**

- MAJOR X.0.0: Cambios incompatibles que rompen implementacion actual
  
  Ejemplo: Cambiar de "aprobacion supervisor" a "paginacion automatica"

- MINOR 0.X.0: Nueva funcionalidad compatible con version anterior
  
  Ejemplo: Agregar nueva excepcion para usuarios VIP

- PATCH 0.0.X: Correcciones y clarificaciones sin cambio funcional
  
  Ejemplo: Corregir typo en enunciado

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estandares del Proyecto:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagogico:**

- PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
  
  - Seccion 2: Taxonomia de Business Rules, 5 tipos
  - Seccion 3: Desencadenadores vs Inferencias, TEST CRITICO
  - Seccion 4: Documentacion de BR
  - Seccion 5: Derivacion BR → UC → FR

**Documentos Relacionados:**

- BRQ_XXX_Nombre_1_0_0.rst, Business Requirement padre
- UC_IACT_XXX_YY_Nombre_4_0_0.rst, Use Cases generados/afectados
- FR_XXX_YY_ZZ_Nombre_1_0_0.rst, Functional Requirements derivados

**Fuentes Externas:**

- URL a documento externo si aplica
- Referencia a estandar de industria
- Regulacion o normativa

----------------------------------------------------------------------
ANEXOS
----------------------------------------------------------------------

ANEXO A: Glosario de Terminos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Termino 1:** Definicion breve especifica a esta BR

**Termino 2:** Definicion

ANEXO B: Diagramas
~~~~~~~~~~~~~~~~~~

Insertar diagramas de flujo, entidad-relacion, secuencia, etc.

ANEXO C: Ejemplos Adicionales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ejemplos detallados adicionales si son necesarios para clarificar

----------------------------------------------------------------------

.. note::
   CHECKLIST DE CALIDAD 14 PUNTOS:
   
   Antes de marcar esta BR como APPROVED, verificar:
   
   Seccion 1: Enunciado
   - Enunciado claro y conciso, 1 frase
   - Tipo de BR correctamente identificado
   - Test de observabilidad aplicado si Desencadenador vs Inferencia
   
   Seccion 2: Derivado De
   - Trazabilidad backward completa, BReq, Stakeholder
   - Contexto de negocio documentado
   
   Seccion 3: Criterios
   - Criterios de aceptacion medibles, minimo 3
   
   Seccion 4: Analisis por Tipo
   - Seccion de tipo BR completamente llenada
   
   Seccion 5-6: Trazabilidad
   - Trazabilidad forward documentada, UC, FR, codigo
   
   Seccion 7: Impacto
   - Analisis de impacto de cambios completo
   
   Seccion 8: Testing
   - Tests definidos, manual y automatizados
   
   Seccion 9-10: Documentacion
   - Metadata correcta al inicio
   - Version semantica aplicada
   - Referencias actualizadas

**REGLA DE ORO DEL TEST DE OBSERVABILIDAD:**

Si no puedes decidir si es Desencadenador o Inferencia,
aplica el TEST:

   El usuario VE algo? → SI = Desencadenador | NO = Inferencia

----------------------------------------------------------------------

**Archivo:** TPL_BR_Decision_Tipo_1_2_0.rst  
**Version Template:** 1.2.0  
**Fecha Creacion Template:** 2026-01-11  
**Autor Template:** Sistema de Regeneracion IACT  
**Lineas Totales:** aproximadamente 2,300


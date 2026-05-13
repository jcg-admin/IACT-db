
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


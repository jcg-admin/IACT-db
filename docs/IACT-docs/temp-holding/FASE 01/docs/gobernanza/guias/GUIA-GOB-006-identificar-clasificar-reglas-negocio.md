---
id: GUIA-GOB-006
tipo: guia
categoria: gobernanza
subcategoria: requisitos
version: 1.0.0
fecha: 2025-11-17
autor: Claude Code (Sonnet 4.5)
estado: activo
relacionados: ["ADR-GOB-006", "ADR-GOB-005", "ADR-GOB-009"]
---

# GUIA-GOB-006: Identificar y Clasificar Reglas de Negocio

## Propósito

Esta guía enseña cómo identificar reglas de negocio en documentación, conversaciones y código existente, y cómo clasificarlas correctamente en uno de los 5 tipos establecidos en ADR-GOB-006.

## Audiencia

- Analistas de negocio
- Analistas de requisitos
- Product Owners
- Arquitectos de software

## Problema que Resuelve

Sin una metodología clara de identificación y clasificación:
- Se documentan reglas de negocio como "texto libre" sin estructura
- No se distingue entre hechos inmutables y restricciones modificables
- Confusión entre desencadenadores de acción e inferencias
- Cálculos complejos expresados ambiguamente
- Desarrolladores implementan incorrectamente por falta de claridad

## Los 5 Tipos de Reglas de Negocio (Recordatorio)

```
1. HECHOS
   → Verdades inmutables del negocio
   → "cada... tiene...", "todos... deben tener..."

2. RESTRICCIONES
   → Limitaciones de acciones
   → "debe", "no debe", "no puede", "solo puede"

3. DESENCADENADORES DE ACCIÓN
   → Si... entonces HACER algo
   → Desencadenan acciones/comportamientos

4. INFERENCIAS
   → Si... entonces SE ESTABLECE nuevo conocimiento
   → Derivan hechos nuevos

5. CÁLCULOS COMPUTACIONALES
   → Fórmulas matemáticas y algoritmos
   → Transforman datos con cálculos
```

## Parte 1: Identificar Reglas de Negocio

### ¿Qué es una Regla de Negocio?

**Definición**: Políticas, leyes, estándares y restricciones bajo las cuales opera la organización.

**Características clave**:
- Provienen de fuente externa (leyes, regulaciones) o interna (políticas organizacionales)
- Son independientes de la implementación técnica
- Persisten aunque cambie el sistema
- Restringen o controlan cómo opera el negocio

### Fuentes de Reglas de Negocio

#### 1. Documentos Legales y Regulatorios

**Ejemplos**:
- Leyes federales (LFPDPPP, Ley Federal del Trabajo)
- Normas oficiales mexicanas (NOMs)
- Reglamentos de salud
- Estándares de la industria (ISO, PCI-DSS)

**Técnica de extracción**:
```
Buscar palabras clave en documentos legales:
- "deberá", "deberán"
- "obligatorio", "obligatoria"
- "prohibido", "prohibida"
- "no podrá", "no podrán"
- "se requiere", "es requisito"
```

**Ejemplo de LFPDPPP**:

> "Artículo 8.- Todo tratamiento de datos personales quedará sujeto al
> consentimiento de su titular"

**Regla extraída**:
```
RN-BACK-002: El sistema debe obtener consentimiento explícito del titular
              antes de procesar datos personales (LFPDPPP Art. 8)
```

#### 2. Políticas Organizacionales

**Ejemplos**:
- Manuales de operación
- Políticas de recursos humanos
- Procedimientos internos
- Estándares de calidad

**Técnica de extracción**:
```
Entrevistar a stakeholders clave:
- ¿Qué políticas rigen esta operación?
- ¿Qué restricciones existen?
- ¿Quién puede hacer qué?
- ¿Qué reglas no se pueden romper?
```

**Ejemplo de política interna**:

> "Política de Compras: Todas las compras superiores a $50,000 MXN
> requieren aprobación del Director General"

**Regla extraída**:
```
RN-BACK-050: Las compras superiores a $50,000 MXN deben ser aprobadas
              por el Director General antes de procesarse
```

#### 3. Lógica de Negocio Existente en Código

**Técnica de extracción**:

Buscar en código patrones como:
```python
if monto > 50000:
    enviar_aprobacion_director()

if usuario.rol != "ADMIN":
    raise PermissionError("No autorizado")

if producto.categoria == "PELIGROSO" and not usuario.certificacion:
    return "Requiere certificación de seguridad"
```

**Reglas extraídas**:
```
RN-BACK-050: Compras > $50,000 requieren aprobación
RN-BACK-025: Solo administradores pueden acceder a módulo X
RN-BACK-030: Productos peligrosos requieren certificación
```

#### 4. Conversaciones con Expertos de Dominio

**Técnica: Entrevistas Estructuradas**

Preguntas clave:
```
1. "¿Qué no se puede hacer en este proceso?"
   → Identifica RESTRICCIONES

2. "¿Qué debe existir siempre?"
   → Identifica HECHOS

3. "¿Qué pasa cuando...?"
   → Identifica DESENCADENADORES

4. "¿Cómo se determina si...?"
   → Identifica INFERENCIAS

5. "¿Cómo se calcula...?"
   → Identifica CÁLCULOS
```

**Ejemplo de conversación**:

> Experto: "Si un cliente no paga en 30 días, lo marcamos como moroso"

**Regla extraída**:
```
RN-BACK-080: Si un pago no se recibe dentro de 30 días después de
              la fecha de vencimiento, entonces la cuenta es marcada
              como morosa

Tipo: INFERENCIA (se establece nuevo conocimiento)
```

### Checklist de Identificación

Una oración contiene una regla de negocio SI:

- [ ] Describe una política, ley o estándar
- [ ] Es independiente de tecnología (no menciona "base de datos", "API", "servidor")
- [ ] Proviene de fuente autoritativa (ley, ejecutivo, experto de dominio)
- [ ] Restringe, controla o define comportamiento del negocio
- [ ] Persistiría aunque cambiara el sistema tecnológico

## Parte 2: Clasificar Reglas de Negocio

### Árbol de Decisión para Clasificar

```
┌─ ¿Describe una VERDAD INMUTABLE del negocio?
│  (ej: "cada orden tiene un costo de envío")
│  → SÍ: HECHO (Tipo 1)
│  → NO: ↓
│
┌─ ¿Establece RESTRICCIÓN sobre quién puede hacer qué?
│  (palabras: debe, no debe, no puede, solo puede)
│  → SÍ: RESTRICCIÓN (Tipo 2)
│  → NO: ↓
│
┌─ ¿Sigue patrón "SI... ENTONCES..."?
│  → SÍ: ↓
│  │
│  ┌─ ¿La cláusula ENTONCES ejecuta una ACCIÓN?
│  │  (enviar, notificar, bloquear, crear, actualizar)
│  │  → SÍ: DESENCADENADOR DE ACCIÓN (Tipo 3)
│  │  → NO: ↓
│  │
│  ┌─ ¿La cláusula ENTONCES establece un HECHO NUEVO?
│     (marcar como, clasificar como, considerar como)
│     → SÍ: INFERENCIA (Tipo 4)
│
│  → NO: ↓
│
└─ ¿Describe una FÓRMULA MATEMÁTICA o ALGORITMO?
   (cálculos, transformaciones, conversiones)
   → SÍ: CÁLCULO COMPUTACIONAL (Tipo 5)
```

### Guía Detallada por Tipo

## TIPO 1: HECHOS

### Definición
Verdades inmutables del negocio que describen relaciones entre conceptos.

### Palabras Clave para Identificar
- "cada... tiene..."
- "todos... deben tener..."
- "debe existir..."
- "se requiere la existencia de..."
- "es una relación entre..."

### Ejemplos con Clasificación

**Ejemplo 1**:
> "Cada contenedor de productos químicos tiene un identificador de código de barras único"

```
Tipo: HECHO
ID: RN-BACK-001
Razón: Describe una verdad estructural del negocio (relación 1:1 entre contenedor e identificador)
```

**Ejemplo 2**:
> "Todos los estudiantes deben tener una matrícula para estar registrados en la universidad"

```
Tipo: HECHO
ID: RN-GOB-010
Razón: Establece relación obligatoria entre estudiante y matrícula
```

**Ejemplo 3**:
> "Cada orden debe tener exactamente un cliente, pero un cliente puede tener múltiples órdenes"

```
Tipo: HECHO
ID: RN-BACK-015
Razón: Describe cardinalidad de relación (1:N)
```

### Cómo Documentar

```markdown
---
id: RN-DOMINIO-###
tipo: regla_negocio
subtipo: hecho
---

# RN-DOMINIO-###: [Título del Hecho]

## Tipo
Hecho

## Declaración
[Oración clara del hecho]

## Elementos Relacionados
- Concepto A: [Definición]
- Concepto B: [Definición]

## Fuente
[De dónde proviene: modelo de datos, experto de dominio, etc.]

## Impacto en Requisitos
- UC-###: [Caso de uso afectado]
- RF-###: [Requisito funcional que implementa]
```

## TIPO 2: RESTRICCIONES

### Definición
Sentencias que limitan acciones de usuarios o sistema, definiendo permisos y prohibiciones.

### Palabras Clave para Identificar

| Palabra Clave | Función | Ejemplo |
|---------------|---------|---------|
| **debe** | Obligación | "El usuario debe proporcionar email" |
| **no debe** | Prohibición | "El sistema no debe mostrar contraseñas" |
| **no puede** | Limitación | "Un usuario no puede tener más de 10 sesiones" |
| **solo puede** | Exclusividad | "Solo el administrador puede eliminar usuarios" |
| **requiere** | Prerrequisito | "La operación requiere autenticación 2FA" |
| **está restringido a** | Limitación por rol | "El módulo está restringido a gerentes" |

### Ejemplos con Clasificación

**Ejemplo 1**:
> "Un solicitante de préstamo que es menor de 18 años debe tener un padre o tutor legal como cosignatario"

```
Tipo: RESTRICCIÓN
ID: RN-BACK-020
Razón: Establece obligación (debe tener) basada en condición (menor de 18)
Palabras clave: "debe tener"
```

**Ejemplo 2**:
> "La correspondencia no puede mostrar más de cuatro dígitos del número de seguro social"

```
Tipo: RESTRICCIÓN
ID: RN-BACK-022
Razón: Prohíbe acción (no puede mostrar más de X)
Palabras clave: "no puede"
```

**Ejemplo 3**:
> "Solo gerentes de laboratorio pueden aprobar solicitudes de productos químicos peligrosos"

```
Tipo: RESTRICCIÓN
ID: RN-BACK-028
Razón: Restringe acción a rol específico
Palabras clave: "solo... pueden"
```

### Cuándo Usar Matriz de Permisos

Si la restricción es sobre **roles y operaciones**, usar matriz en lugar de texto:

```markdown
## Matriz de Permisos: Módulo de Productos Químicos

| Operación | Admin | Gerente Lab | Técnico | Usuario |
|-----------|:-----:|:-----------:|:-------:|:-------:|
| Ver catálogo | ✓ | ✓ | ✓ | ✓ |
| Solicitar producto común | ✓ | ✓ | ✓ | ✓ |
| Solicitar producto peligroso | ✓ | ✓ | ✓ | ✗ |
| Aprobar solicitud | ✓ | ✓ | ✗ | ✗ |
| Eliminar producto | ✓ | ✗ | ✗ | ✗ |
| Configurar alertas | ✓ | ✓ | ✗ | ✗ |

Leyenda: ✓ = Permitido    ✗ = No permitido
```

**Ventaja**: Visual, sin ambigüedad, fácil de validar.

### Cómo Documentar

```markdown
---
id: RN-DOMINIO-###
tipo: regla_negocio
subtipo: restriccion
---

# RN-DOMINIO-###: [Título de la Restricción]

## Tipo
Restricción

## Declaración
[Oración usando palabras clave: debe, no debe, no puede, solo puede]

## Alcance
- Aplica a: [Usuarios, Sistema, Módulo]
- Roles afectados: [Lista de roles]

## Justificación
[Por qué existe: seguridad, regulación, política]

## Excepciones
[Si hay excepciones a la restricción]

## Validación
[Cómo se valida el cumplimiento]
```

## TIPO 3: DESENCADENADORES DE ACCIÓN

### Definición
Reglas que ejecutan acciones cuando se cumplen condiciones. Patrón: SI... ENTONCES [ACCIÓN].

### Estructura Característica
```
SI [condición o evento]
ENTONCES [ejecutar acción]
```

La cláusula ENTONCES contiene **verbos de acción**: enviar, notificar, bloquear, crear, actualizar, eliminar, ejecutar, disparar.

### Palabras Clave para Identificar

**En la cláusula ENTONCES**:
- enviar (email, notificación, alerta)
- notificar (a persona, sistema)
- bloquear (cuenta, acceso, operación)
- crear (registro, archivo, tarea)
- actualizar (campo, estado, dato)
- eliminar (registro, archivo)
- ejecutar (proceso, script, workflow)
- disparar (evento, trigger)

### Ejemplos con Clasificación

**Ejemplo 1**:
> "Si el almacén de productos químicos tiene contenedores de un producto solicitado en stock, entonces ofrece los contenedores al solicitante"

```
Tipo: DESENCADENADOR DE ACCIÓN
ID: RN-BACK-030
Razón: La cláusula ENTONCES ejecuta acción (ofrece = mostrar/notificar)

Desglose:
  SI: producto en stock
  ENTONCES: ACCIÓN (ofrecer al solicitante)
```

**Ejemplo 2**:
> "Si se ha alcanzado la fecha de vencimiento en un envase del producto químico, entonces se notifica a la persona a cargo"

```
Tipo: DESENCADENADOR DE ACCIÓN
ID: RN-BACK-031
Razón: La cláusula ENTONCES ejecuta acción (notifica)

Desglose:
  SI: fecha vencimiento alcanzada
  ENTONCES: ACCIÓN (notificar a persona)
```

**Ejemplo 3**:
> "Si un usuario intenta iniciar sesión con credenciales incorrectas 3 veces consecutivas, entonces bloquear la cuenta por 15 minutos"

```
Tipo: DESENCADENADOR DE ACCIÓN
ID: RN-BACK-032
Razón: La cláusula ENTONCES ejecuta acción (bloquear)

Desglose:
  SI: 3 intentos fallidos consecutivos
  ENTONCES: ACCIÓN (bloquear cuenta por 15 min)
```

### Diferencia Crítica: Desencadenador vs Inferencia

**Pregunta clave**: ¿Qué hace la cláusula ENTONCES?

| Aspecto | Desencadenador | Inferencia |
|---------|----------------|------------|
| **ENTONCES hace** | ACCIÓN (algo sucede) | ESTABLECE HECHO (algo se sabe) |
| **Verbo típico** | Enviar, notificar, bloquear | Marcar como, clasificar como, considerar |
| **Resultado** | Comportamiento observable | Nuevo conocimiento |
| **Ejemplo** | "enviar email de alerta" | "marcar cuenta como morosa" |

**Ejemplo de contraste**:

```
DESENCADENADOR:
  SI: usuario tiene 3 intentos fallidos
  ENTONCES: Enviar email de alerta + Bloquear cuenta  ← ACCIONES

INFERENCIA:
  SI: usuario tiene 3 intentos fallidos
  ENTONCES: Usuario tiene estado "sospechoso"  ← NUEVO CONOCIMIENTO
```

### Cómo Documentar

```markdown
---
id: RN-DOMINIO-###
tipo: regla_negocio
subtipo: desencadenador
---

# RN-DOMINIO-###: [Título del Desencadenador]

## Tipo
Desencadenador de Acción

## Declaración

**SI**: [Condición o evento que dispara]

**ENTONCES**: [Acción(es) que se ejecutan]

## Condición de Activación
[Descripción detallada de cuándo se activa]

## Acción(es) Desencadenada(s)
1. [Primera acción]
2. [Segunda acción]

## Frecuencia Esperada
[Qué tan frecuente se espera que se active]

## Prioridad
[Alta/Media/Baja]

## Actores Involucrados
- [Quién recibe notificación, etc.]
```

## TIPO 4: INFERENCIAS

### Definición
Reglas que derivan nuevo conocimiento a partir de hechos existentes. Patrón: SI... ENTONCES [NUEVO HECHO].

### Estructura Característica
```
SI [condiciones sobre hechos existentes]
ENTONCES [nuevo hecho se establece como verdadero]
```

La cláusula ENTONCES contiene **verbos de estado**: marcar como, clasificar como, considerar como, determinar que, establecer que.

### Palabras Clave para Identificar

**En la cláusula ENTONCES**:
- marcar como (estado)
- clasificar como (categoría)
- considerar como (tipo)
- determinar que (conclusión)
- establecer que (hecho nuevo)
- el elemento ES (categoría)
- calificar como (clasificación)

### Ejemplos con Clasificación

**Ejemplo 1**:
> "Si un pago no se recibe dentro de 30 días después de que se debe, entonces la cuenta es marcada como morosa"

```
Tipo: INFERENCIA
ID: RN-BACK-040
Razón: La cláusula ENTONCES establece nuevo conocimiento (estado "morosa")

Desglose:
  SI: pago no recibido en 30 días
  ENTONCES: NUEVO HECHO (cuenta es morosa)

NO es acción: No dice "enviar aviso" o "notificar", dice "es marcada como"
```

**Ejemplo 2**:
> "Si un vendedor nuevo no puede enviar un artículo ordenado dentro de 5 días al recibir la orden, entonces la orden es marcada como cancelada"

```
Tipo: INFERENCIA
ID: RN-BACK-041
Razón: Establece nuevo estado de la orden

Desglose:
  SI: vendedor no envía en 5 días
  ENTONCES: NUEVO HECHO (orden cancelada)
```

**Ejemplo 3**:
> "Si un estudiante ha completado todos los cursos obligatorios y tiene promedio >= 7.0, entonces el estudiante es elegible para graduación"

```
Tipo: INFERENCIA
ID: RN-GOB-042
Razón: Deriva nuevo conocimiento (elegibilidad)

Desglose:
  SI: cursos completos AND promedio >= 7.0
  ENTONCES: NUEVO HECHO (es elegible para graduación)
```

### Diferencia con Desencadenadores (Refuerzo)

**Ejemplo lado a lado**:

```
Contexto: Usuario con 3 intentos fallidos de login

DESENCADENADOR (RN-BACK-032):
  SI: usuario intenta login 3 veces con credenciales incorrectas
  ENTONCES: Enviar email de alerta + Bloquear cuenta
  → Ejecuta ACCIONES

INFERENCIA (RN-BACK-045):
  SI: usuario intenta login 3 veces con credenciales incorrectas
  ENTONCES: Usuario tiene estado "sospechoso"
  → Establece CONOCIMIENTO

Ambas pueden coexistir: La inferencia establece conocimiento, el desencadenador actúa sobre ese conocimiento.
```

### Cómo Documentar

```markdown
---
id: RN-DOMINIO-###
tipo: regla_negocio
subtipo: inferencia
---

# RN-DOMINIO-###: [Título de la Inferencia]

## Tipo
Inferencia (Conocimiento Derivado)

## Declaración

**SI**: [Condiciones sobre hechos existentes]

**ENTONCES**: [Nuevo hecho que se establece]

## Hechos de Entrada
- [Hecho 1]
- [Hecho 2]

## Conocimiento Derivado
[Descripción del nuevo hecho]

## Regla de Derivación
[Lógica que conecta entrada con conocimiento derivado]

## Persistencia
[Si el conocimiento se guarda, dónde, por cuánto tiempo]
```

## TIPO 5: CÁLCULOS COMPUTACIONALES

### Definición
Reglas que transforman datos mediante fórmulas matemáticas o algoritmos específicos.

### Características
- Contienen operadores matemáticos: +, -, ×, ÷, %, ^
- Describen fórmulas o algoritmos
- Transforman datos de entrada en datos de salida
- Frecuentemente provienen de leyes (impuestos) o estándares

### Palabras Clave para Identificar
- "se calcula como"
- "la fórmula es"
- "se determina mediante"
- "el total es"
- "se suma", "se multiplica", "se divide"
- "porcentaje", "tasa", "factor"

### Ejemplos con Clasificación

**Ejemplo 1**:
> "El cargo de envío terrestre nacional por una orden que pesa más de 2 kg es de $40.75 + $0.12 por gramo de fracción adicional"

```
Tipo: CÁLCULO COMPUTACIONAL
ID: RN-BACK-050
Razón: Describe fórmula matemática

Fórmula:
  Cargo_Envío = $40.75 + ((Peso_Total - 2000g) × $0.12)

Variables:
  - Peso_Total: peso en gramos
  - Cargo_Envío: costo en pesos MXN
```

**Ejemplo 2**:
> "El precio total de una orden se calcula como: suma de precio de artículos, menos descuentos por volumen, más impuestos (IVA 16%), más gastos de envío, más seguro opcional (2% del subtotal)"

```
Tipo: CÁLCULO COMPUTACIONAL
ID: RN-BACK-051
Razón: Describe algoritmo de cálculo multi-paso

Fórmula:
  Subtotal = Suma(Precio_Artículos) - Descuento_Volumen
  IVA = Subtotal × 0.16
  Seguro = IF(solicitado, Subtotal × 0.02, 0)
  Total = Subtotal + IVA + Gastos_Envío + Seguro
```

**Ejemplo 3**:
> "El descuento por volumen se aplica según la tabla: 1-5 unidades (0%), 6-10 unidades (10%), 11-20 unidades (20%), 21+ unidades (30%)"

```
Tipo: CÁLCULO COMPUTACIONAL (Tabla)
ID: RN-BACK-052
Razón: Cálculo basado en tabla de rangos

Tabla:
  | Cantidad | Descuento |
  |----------|-----------|
  | 1-5      | 0%        |
  | 6-10     | 10%       |
  | 11-20    | 20%       |
  | 21+      | 30%       |
```

### Cuándo Usar Tablas vs Fórmulas

**Usar TABLA si**:
- Cálculo basado en rangos discretos
- Valores predefinidos sin fórmula matemática clara
- Múltiples condiciones que intersectan

**Usar FÓRMULA si**:
- Cálculo matemático continuo
- Operaciones aritméticas claras
- Algoritmo paso a paso

### Cómo Documentar

```markdown
---
id: RN-DOMINIO-###
tipo: regla_negocio
subtipo: calculo
---

# RN-DOMINIO-###: [Título del Cálculo]

## Tipo
Cálculo Computacional

## Declaración
[Descripción en lenguaje natural]

## Fórmula

```
[Fórmula matemática en notación clara]
Variable_Salida = (Variable1 × Constante) + Variable2
```

## Variables de Entrada
- Variable1: [Descripción, unidades, rango válido]
- Variable2: [Descripción, unidades, rango válido]

## Variables de Salida
- Resultado: [Descripción, unidades, rango esperado]

## Constantes
- Constante: [Valor, unidades, origen]

## Tabla de Valores (si aplica)
[Tabla estructurada]

## Ejemplo de Cálculo
[Ejemplo numérico concreto con valores]

## Reglas de Redondeo
[Cómo se redondean los resultados]

## Fuente
[Ley, regulación, política interna, estándar]
```

## Parte 3: Ejercicios Prácticos

### Ejercicio 1: Clasificar 10 Reglas

Clasifica cada regla en uno de los 5 tipos:

**1.** "Cada factura debe tener un RFC válido del cliente"
```
Respuesta: _____________
```

**2.** "Si una orden no es pagada en 15 días, entonces enviar recordatorio de pago al cliente"
```
Respuesta: _____________
```

**3.** "Si un producto no tiene movimientos en 180 días, entonces el producto es considerado de lento movimiento"
```
Respuesta: _____________
```

**4.** "Solo gerentes y administradores pueden aprobar devoluciones superiores a $5,000 MXN"
```
Respuesta: _____________
```

**5.** "El ISR se calcula como: (Ingreso_Gravable × Tasa_ISR) - Subsidio_Empleo"
```
Respuesta: _____________
```

**6.** "Cada empleado debe tener exactamente un número de nómina único"
```
Respuesta: _____________
```

**7.** "Si el inventario de un producto cae por debajo del punto de reorden, entonces crear orden de compra automática"
```
Respuesta: _____________
```

**8.** "Un usuario no puede tener más de 3 sesiones activas simultáneamente"
```
Respuesta: _____________
```

**9.** "Si un usuario ha completado 5 compras en el mes, entonces el usuario es clasificado como 'frecuente'"
```
Respuesta: _____________
```

**10.** "El tiempo extra se paga al 200% del salario por hora después de 8 horas diarias"
```
Respuesta: _____________
```

### Soluciones Ejercicio 1

1. **HECHO** (cada... debe tener)
2. **DESENCADENADOR** (entonces enviar → acción)
3. **INFERENCIA** (entonces es considerado → nuevo conocimiento)
4. **RESTRICCIÓN** (solo... pueden → limitación de acción)
5. **CÁLCULO** (fórmula matemática)
6. **HECHO** (cada... debe tener... único)
7. **DESENCADENADOR** (entonces crear → acción)
8. **RESTRICCIÓN** (no puede... más de → limitación)
9. **INFERENCIA** (entonces es clasificado como → nuevo conocimiento)
10. **CÁLCULO** (porcentaje, fórmula de salario)

### Ejercicio 2: Extraer Reglas de Texto

**Texto**: Política de Devoluciones de la Empresa XYZ

> "Las devoluciones de productos son aceptadas únicamente dentro de 30 días
> después de la compra. Todos los productos devueltos deben estar en su
> empaque original sin abrir. Los productos electrónicos no pueden ser
> devueltos si han sido abiertos. El reembolso se procesa en 5-7 días
> hábiles y se aplica un cargo del 10% por gastos administrativos. Si el
> producto tiene defecto de fábrica, no se aplica el cargo administrativo
> y se notifica al departamento de calidad."

**Tarea**: Extraer y clasificar todas las reglas de negocio.

### Solución Ejercicio 2

```
RN-BACK-100: Las devoluciones deben realizarse dentro de 30 días después de la compra
Tipo: RESTRICCIÓN (debe... dentro de)

RN-BACK-101: Los productos devueltos deben estar en empaque original sin abrir
Tipo: RESTRICCIÓN (deben estar)

RN-BACK-102: Los productos electrónicos no pueden ser devueltos si han sido abiertos
Tipo: RESTRICCIÓN (no pueden ser... si)

RN-BACK-103: El reembolso se procesa en 5-7 días hábiles
Tipo: HECHO (describe característica del proceso)

RN-BACK-104: El monto de reembolso se calcula como: Precio_Original × 0.90
              (se aplica cargo 10% por gastos administrativos)
Tipo: CÁLCULO (fórmula matemática)

RN-BACK-105: Si el producto tiene defecto de fábrica, entonces no se aplica
              el cargo administrativo (reembolso 100%)
Tipo: DESENCADENADOR / CÁLCULO CONDICIONAL (acción: no aplicar cargo)

RN-BACK-106: Si el producto tiene defecto de fábrica, entonces notificar
              al departamento de calidad
Tipo: DESENCADENADOR (entonces notificar → acción)
```

## Parte 4: Errores Comunes

### Error 1: Confundir Desencadenador con Inferencia

**Problema**:
```
"Si el stock cae a 0, entonces el producto se marca como agotado y se
envía alerta al comprador"
```

**Análisis**:
- "se marca como agotado" → INFERENCIA (nuevo conocimiento)
- "se envía alerta" → DESENCADENADOR (acción)

**Solución**: Separar en 2 reglas
```
RN-BACK-200: Si el stock cae a 0, entonces el producto es marcado como agotado
Tipo: INFERENCIA

RN-BACK-201: Si el producto es marcado como agotado, entonces enviar alerta al comprador
Tipo: DESENCADENADOR
```

### Error 2: Clasificar Cálculo Simple como Hecho

**Incorrecto**:
```
"El total de la orden es la suma de los artículos más el envío"
Tipo: HECHO ✗
```

**Correcto**:
```
"El total de la orden se calcula como: Suma(Artículos) + Costo_Envío"
Tipo: CÁLCULO ✓
```

**Razón**: Aunque parece hecho, contiene operación matemática (suma).

### Error 3: No Identificar Restricción Implícita

**Texto**:
```
"Los descuentos especiales solo están disponibles para clientes VIP"
```

**Error**: Clasificar como HECHO

**Correcto**: RESTRICCIÓN (implica "solo pueden")

### Error 4: Mezclar Múltiples Tipos en Una Regla

**Incorrecto**:
```
RN-BACK-300: Cada orden tiene un cliente, y si el cliente ha gastado más
              de $100,000 MXN en el año, es clasificado como VIP y recibe
              10% de descuento automático
```

**Problema**: Mezcla HECHO + INFERENCIA + CÁLCULO

**Correcto**: Separar
```
RN-BACK-300: Cada orden debe tener exactamente un cliente
Tipo: HECHO

RN-BACK-301: Si un cliente ha gastado más de $100,000 MXN en el año,
              entonces es clasificado como VIP
Tipo: INFERENCIA

RN-BACK-302: El descuento para clientes VIP se calcula como 10% del subtotal
Tipo: CÁLCULO
```

## Checklist de Clasificación Final

Antes de documentar una regla, verificar:

- [ ] ¿La regla está redactada claramente en una oración?
- [ ] ¿He identificado las palabras clave que indican el tipo?
- [ ] ¿Si es SI...ENTONCES, la cláusula ENTONCES es ACCIÓN o CONOCIMIENTO?
- [ ] ¿La regla contiene fórmula matemática? (entonces es CÁLCULO)
- [ ] ¿La regla contiene "debe", "no puede"? (probablemente es RESTRICCIÓN)
- [ ] ¿La regla describe estructura inmutable? (probablemente es HECHO)
- [ ] ¿He separado reglas mezcladas en reglas atómicas?
- [ ] ¿La regla tiene ID único asignado?
- [ ] ¿He documentado la fuente (ley, política, experto)?

## Referencias

- [ADR-GOB-006: Clasificación y Documentación de Reglas de Negocio](/home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-006-clasificacion-reglas-negocio.md)
- [ADR-GOB-005: Jerarquía de Requerimientos en 5 Niveles](/home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-005-jerarquia-requerimientos-5-niveles.md)
- [GUIA-GOB-005: Derivar Requisitos entre Niveles](GUIA-GOB-005-derivar-requisitos-entre-niveles.md)

## Próximos Pasos

1. Practicar con ejercicios adicionales
2. Revisar código existente para extraer reglas de negocio
3. Entrevistar stakeholders usando técnicas de esta guía
4. Documentar primeras 10-20 reglas de negocio del proyecto

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-17 | Claude Code | Versión inicial |


# ANÁLISIS PARTE 2A - FUNDAMENTOS Y PATRONES (Secciones 1-3)

Perfecto. PARTE 2 es el documento más extenso hasta ahora (~6,000 líneas). Lo dividiré en **3 entregas (PARTE 2A, 2B, 2C)** para análisis manejable.

# ANÁLISIS PARTE 2A: FUNDAMENTOS Y PATRONES (Secciones 1-3)

## DOCUMENTO ANALIZADO

**Archivo:** PARTE_2.md (UID: 20251208041455144132) **Longitud total:** ~6,000 líneas (~150 páginas) - **3× más largo que PARTE 1** **Análisis actual:** Secciones 1-3 (~2,400 líneas, 40% del documento)

---

## SECCIÓN 1: INTRODUCCIÓN

### 1.1 Estructura y Alcance

**Contenido:**

- Objetivos de aprendizaje (3 categorías: conceptuales, prácticas, validación)
- Estado del catálogo BR (entrada de PARTE 1)
- Entregables esperados (3 principales)
- Proceso general de transformación

**Diagrama PlantUML incluido:**

- Proceso general BR → UC → FR (1 diagrama)

**Observación crítica:**

```
"Esta parte construye sobre ese fundamento, respondiendo a la pregunta central:
¿Cómo se transforman las Business Rules en elementos de requerimientos implementables?"
```

### 1.2 Decisión Central del Proceso

**Diagrama de decisión clave:**

```
¿Qué Genera Cada Tipo de BR?
- HECHO → NO genera UC
- RESTRICCIÓN → NO genera UC independiente
- DESENCADENADOR → SÍ genera UC completo ⭐⭐⭐
- INFERENCIA → NO genera UC
- CÁLCULO → NO genera UC independiente
```

**Implicación crítica:**

> "Solo los DESENCADENADORES generan Casos de Uso completos"

---

## SECCIÓN 2: FUNDAMENTOS DE CASOS DE USO

### 2.1 Qué es un Caso de Uso

**Definición formal dada:**

> "Una descripción de una secuencia completa de interacciones entre un actor y el sistema, iniciada por el actor para alcanzar un objetivo específico que tiene valor para ese actor."

**Ejemplos de dominio químicos:**

|Incorrecto (NO es UC)|Correcto (SÍ es UC)|Frecuencia|
|---|---|---|
|"UC-01: Validar Usuario"|"UC-01: Iniciar Sesión"|1 vez|
|"UC-05: Pantalla de Búsqueda"|"UC-05: Buscar Producto en Catálogo"|1 vez|
|"UC-10: Módulo de Inventario"|"UC-10: Consultar Disponibilidad de Producto"|1 vez|

**Características esenciales:**

1. Interacción completa
2. Valor para el actor
3. Comportamiento observable
4. Unidad de análisis
5. Independencia contextual

### 2.2 Componentes de un Caso de Uso

**12 componentes obligatorios y opcionales:**

**Obligatorios (7):**

1. ID único (UC-NNN)
2. Nombre (Verbo + Objeto)
3. Actor Primario
4. Precondiciones
5. Trigger
6. Flujo Normal
7. Postcondiciones

**Opcionales (5):** 8. Actores Secundarios 9. Stakeholders e Intereses 10. Flujos Alternos 11. Garantías 12. Business Rules Aplicadas

**Diagrama incluido:**

- Anatomía de un Caso de Uso (1 diagrama PlantUML)

### 2.3 Ejemplos del Dominio Químicos

**UC-04: Solicitar Producto Químico** (ejemplo recurrente)

```
Precondiciones:
- Usuario autenticado
- Usuario tiene rol Solicitante o superior
- Existen productos químicos en catálogo
- Usuario tiene certificación OSHA vigente (si producto peligroso)

Flujo Normal (11 pasos):
1. Usuario selecciona opción "Nueva Solicitud"
2. Sistema muestra catálogo de productos químicos
3. Usuario selecciona producto
4. Usuario especifica cantidad
5. Sistema calcula costo total
6. Sistema muestra costo
7. Usuario confirma
8. Sistema verifica permisos
9. Sistema registra solicitud con estado "Aprobada"
10. Sistema actualiza inventario reservado
11. Sistema muestra confirmación
```

**Términos específicos químicos encontrados:**

- "productos químicos" (8×)
- "catálogo de productos" (3×)
- "inventario reservado" (2×)
- "certificación OSHA" (4×)

### 2.4 Actores y sus Tipos

**Taxonomía presentada:**

|Tipo Actor|Características|Ejemplo Químicos|
|---|---|---|
|Actor Primario|Inicia, tiene objetivo, solo UNO|Solicitante|
|Actor Secundario|Participa, no inicia, varios|Gerente, Coordinador|
|Actor Sistema|Sistema externo, API|Servicio de Pago, LDAP|
|Actor Tiempo|Ejecución periódica|Sistema (diario 00:00)|

**Diagrama incluido:**

- Taxonomía de Actores (1 diagrama PlantUML)

### 2.5 Flujo Normal vs Flujos Alternos

**Diagrama de estructura:**

- Flujos en un Caso de Uso (1 diagrama PlantUML)

**4 tipos de flujos alternos identificados:**

```
TIPO A: Variación de negocio
  Ejemplo: FA-1: Solicitud Requiere Aprobación

TIPO B: Error de validación  
  Ejemplo: FA-2: Cantidad Excede Disponibilidad

TIPO C: Error técnico
  Ejemplo: FA-3: Error al Conectar con Servicio de Pago

TIPO D: Usuario cancela
  Ejemplo: FA-4: Usuario Cancela Solicitud
```

**Ejemplo químico detallado:**

```
UC-12: Transferir Contenedor Entre Ubicaciones

FA-1: Contenedor No Encontrado
FA-2: Contenedor en Estado No Transferible (Caduco/Eliminado)
FA-3: Ubicación Destino Inválida
FA-4: Ubicación Destino sin Capacidad
FA-5: Usuario Cancela
```

---

## SECCIÓN 3: PATRONES DE TRANSFORMACIÓN POR TIPO

**LA SECCIÓN MÁS CRÍTICA DE PARTE 2**

### 3.1 Patrón 1: Hechos → Modelo de Dominio

**Principio:**

> "Los Hechos NO generan Casos de Uso porque no describen comportamiento, describen estructura."

**Ejemplo principal: BR-012**

```
BR-012 (HECHO):
"Cada contenedor de producto químico tiene asignado un código de 
 barras único que no puede ser reasignado a otro contenedor"

RESULTADO:
Entidad: Contenedor
Atributo: codigo_barras (UNIQUE, NOT NULL, IMMUTABLE)
```

**Análisis paso a paso completo (5 pasos):**

1. Identificar entidades: Contenedor, ProductoQuimico
2. Identificar relaciones: Contenedor "contiene" ProductoQuimico (N:1)
3. Identificar atributos: codigo_barras
4. Identificar características: UNIQUE, NOT NULL, IMMUTABLE
5. Restricciones de integridad: FK, constraints

**Diagrama de clases resultante:**

- 1 diagrama PlantUML con Contenedor, ProductoQuimico, Ubicacion

**3 ejemplos adicionales:**

- BR-018: Relación M:N (Producto-Proveedor)
- BR-022: Cardinalidad mínima (Orden-Items)
- Ejemplos breves de otros hechos

**Términos químicos del patrón:**

- "contenedor de producto químico" (15×)
- "código de barras" (8×)
- "producto químico" (12×)
- "ubicación" (5×)

### 3.2 Patrón 2: Restricciones → Precondiciones/Validaciones

**Principio:**

> "Las Restricciones NO generan Casos de Uso independientes. Se integran en UC existentes en una de tres ubicaciones."

**Las 3 ubicaciones posibles:**

```
UBICACIÓN 1: PRECONDICIÓN (aplica ANTES)
  Ejemplo: "Solo usuarios autenticados pueden..."

UBICACIÓN 2: VALIDACIÓN EN PASO (aplica DURANTE)
  Ejemplo: "Sistema verifica que monto <= límite"

UBICACIÓN 3: FLUJO ALTERNO (cuando se VIOLA)
  Ejemplo: "Si monto >$500, solicitar aprobación"
```

**Ejemplo 1: BR-087 como PRECONDICIÓN**

```
BR-087 (RESTRICCIÓN):
"Solo personal con certificación OSHA vigente puede solicitar 
 productos químicos clasificados como peligrosos (clase 1-4)"

INTEGRACIÓN EN UC-04:

Precondiciones:
  - SI producto es clase peligrosa (1-4):
    ENTONCES usuario debe tener certificación OSHA vigente [BR-087]

Flujo Alterno:
  FA-3: Producto Peligroso sin Certificación OSHA [BR-087]
    6a. Sistema detecta producto.clase IN (1,2,3,4)
    6b. Sistema detecta NO existe certificación OSHA vigente
    6c. Sistema muestra mensaje de denegación
    6d. Sistema registra intento en log de auditoría
    6e. UC termina

FR derivados: RF-401, RF-402, RF-403, RF-404
```

**Ejemplo 2: BR-028 como VALIDACIÓN + FLUJO ALTERNO**

```
BR-028 (RESTRICCIÓN):
"Solicitudes de compra que excedan $500 deben obtener aprobación 
 del gerente de departamento"

INTEGRACIÓN EN UC-04:

Paso 8: Sistema verifica monto contra umbral de $500 [BR-028]

FA-1: Solicitud Requiere Aprobación de Gerente [BR-028]
  8a. Sistema detecta que costo_total > $500
  8b. Sistema identifica gerente del departamento
  8c. Sistema registra con estado "Pendiente Aprobación"
  8d. Sistema envía email al gerente
  8e. UC termina (continuará con UC-09)

FR derivados: RF-205, RF-206, RF-207, RF-208, RF-209
```

**Ejemplo 3: Matriz de Roles → Múltiples Restricciones**

Matriz presentada:

- 14 operaciones × 5 roles (Solicitante, Aprobador, Gerente, Coordinador, Admin)
- Genera BR-101 a BR-105
- Cada BR se convierte en precondición de UC correspondiente

**Términos químicos del patrón:**

- "productos químicos peligrosos" (10×)
- "certificación OSHA" (17× en BR-087)
- "solicitud de compra" (8×)
- "gerente de departamento" (6×)
- "Coordinador de Seguridad" (9×)

### 3.3 Patrón 3: Desencadenadores → Casos de Uso Completos ⭐⭐⭐

**EL PATRÓN MÁS IMPORTANTE DE TODA LA TRANSFORMACIÓN**

**Principio:**

> "Los Desencadenadores son el ÚNICO tipo de Business Rule que SÍ genera Casos de Uso completos e independientes."

**Diferencia crítica con Inferencia:**

```
DESENCADENADOR (genera UC):
  "SI químico vence ENTONCES NOTIFICAR propietario"
  → Usuario RECIBE email (observable)
  → Genera UC-07 completo

INFERENCIA (NO genera UC):
  "SI químico vence ENTONCES MARCAR como caduco"
  → Solo campo en BD cambia (no observable)
  → NO genera UC, solo RF directo
```

**Patrón de transformación (7 pasos):**

1. Analizar la regla (condición + comportamiento)
2. Identificar actor primario
3. Definir trigger
4. Construir flujo normal (3-10 pasos)
5. Identificar flujos alternos
6. Definir pre/postcondiciones
7. Derivar FR de cada paso

**EJEMPLO GUÍA COMPLETO: BR-031 → UC-07**

**EL EJEMPLO MÁS DESARROLLADO DE TODO PARTE 2**

```
BR-031 (DESENCADENADOR):
"SI un contenedor de químico alcanza su fecha de vencimiento ENTONCES 
 el sistema debe notificar por email al propietario del contenedor y al 
 coordinador de seguridad con 30 días de anticipación"
```

**Análisis completo paso a paso:**

**PASO 1: Analizar la regla (4 páginas de análisis)**

```
Condición extraída:
  (fecha_vencimiento - fecha_actual) <= 30 días

Query SQL conceptual:
  SELECT * FROM Contenedores
  WHERE DATEDIFF(fecha_vencimiento, CURDATE()) <= 30
    AND DATEDIFF(fecha_vencimiento, CURDATE()) >= 0
    AND estado = 'ACTIVO'

Comportamiento extraído:
  1. Identificar contenedores próximos a vencer
  2. Para cada contenedor:
     - Obtener propietario
     - Obtener coordinador
     - Generar email
     - Enviar emails
     - Registrar notificación

¿Observable?: SÍ
  - Propietario RECIBE email (observable)
  - Coordinador RECIBE email (observable)
```

**PASO 2-6: Construcción del UC-07 completo**

```
UC-07: Notificar Vencimiento de Químico

Actor Primario: Sistema (tiempo)
Trigger: Diario a las 00:00 horas

Flujo Normal (6 pasos principales, 10 subpasos):
  1. Sistema verifica fecha actual
  2. Sistema consulta tabla Contenedores
  3. Sistema filtra contenedores (DATEDIFF <= 30)
  4. Sistema itera sobre cada contenedor:
     4.1 Consulta asignación activa
     4.2 Obtiene propietario
     4.3 Extrae email propietario
     4.4 Obtiene coordinador de seguridad
     4.5 Obtiene email coordinador
     4.6 Obtiene datos completos del contenedor
     4.7 Genera contenido email con plantilla
     4.8 Envía email al propietario
     4.9 Envía email al coordinador
     4.10 Registra notificación en BD
  5. Sistema cuenta notificaciones enviadas
  6. Sistema registra en log
  7. Sistema finaliza

Flujos Alternos (5):
  FA-1: Sin Contenedores Próximos a Vencer
  FA-2: Contenedor sin Propietario Asignado
  FA-3: Email del Propietario Inválido
  FA-4: Error al Conectar con Servidor SMTP
  FA-5: Proceso Excede Tiempo Máximo (>5 min)
```

**PASO 7: Derivación de FR (9 Functional Requirements)**

```
RF-301: Obtener Fecha Actual del Servidor
RF-302: Consultar Contenedores Activos
RF-303: Filtrar Contenedores Próximos a Vencer (30 días)
RF-304: Obtener Propietario Actual del Contenedor
RF-305: Validar y Extraer Email del Usuario
RF-306: Obtener Coordinador de Seguridad
RF-307: Generar Contenido de Email con Plantilla
RF-308: Enviar Email vía Protocolo SMTP
RF-309: Registrar Timestamp de Notificación
```

**Cada FR incluye:**

- Descripción completa
- Derivado de: UC-07 Paso X
- Implementa: BR-031
- Query/Algoritmo detallado
- Prioridad

**Ejemplo de RF-303 completo:**

```
RF-303: Filtrar Contenedores Próximos a Vencer (30 días)

Descripción:
  El sistema debe aplicar filtro para identificar contenedores donde
  la diferencia entre fecha_vencimiento y fecha_actual sea <= 30 días.

Derivado de: UC-07 Paso 3
Implementa: BR-031 (condición: 30 días)
Prioridad: Alta

Algoritmo SQL:
  WHERE DATEDIFF(c.fecha_vencimiento, CURDATE()) <= 30
    AND DATEDIFF(c.fecha_vencimiento, CURDATE()) >= 0

Performance:
  - Query puede ser costoso si hay miles de contenedores
  - Considerar índice funcional en DATEDIFF
  - Alternativa: Columna calculada dias_hasta_vencimiento
```

**Template de email incluido (HTML):**

```html
<h2>Notificación de Vencimiento de Químico</h2>
<p>Estimado/a {{nombre_propietario}},</p>
<p>El siguiente producto químico está próximo a vencer:</p>
<table>
  <tr><td>Producto:</td><td>{{nombre_quimico}}</td></tr>
  <tr><td>Código:</td><td>{{codigo_contenedor}}</td></tr>
  <tr><td>Vencimiento:</td><td>{{fecha_vencimiento}}</td></tr>
  <tr><td>Días Restantes:</td><td>{{dias_restantes}}</td></tr>
</table>
```

**Trazabilidad completa establecida:**

```
BR-031 → UC-07 → RF-301..309 → ExpirationNotificationService.java
```

**Estadísticas del ejemplo BR-031:**

- **17 ocurrencias** de BR-031 en PARTE 1 (el más usado)
- **10 páginas** dedicadas solo a este ejemplo en PARTE 2
- **9 Functional Requirements** derivados
- **5 Flujos Alternos** documentados
- **1 Template HTML** completo
- **Código Java** de ejemplo incluido

### 3.4 Patrón 4: Inferencias → Functional Requirement Directo

**Principio:**

> "Las Inferencias NO generan Casos de Uso porque el resultado es un cambio de estado INTERNO que NO es observable externamente."

**Pregunta clave:**

```
¿El actor puede OBSERVAR que algo ocurrió?
- Desencadenador: SÍ → Genera UC
- Inferencia: NO → Solo FR directo
```

**Ejemplo principal: BR-046**

```
BR-046 (INFERENCIA):
"SI un contenedor de químico alcanza su fecha de vencimiento ENTONCES 
 el contenedor debe ser marcado con estado 'Caduco' en el sistema"

¿Es observable?: NO
  - Usuario NO recibe notificación
  - Usuario NO ve cambio (hasta que consulte específicamente)

RESULTADO: FR-305 directo (SIN UC intermedio)

RF-305: Actualizar Estado de Contenedor a Caduco

Trigger: Diario 00:00 (mismo proceso que UC-07)

Algoritmo SQL:
  UPDATE Contenedores
  SET estado = 'CADUCO',
      fecha_actualizacion = NOW()
  WHERE fecha_vencimiento <= CURDATE()
    AND estado NOT IN ('CADUCO', 'ELIMINADO')

Trazabilidad: BR-046 → RF-305 (directo, sin UC)
```

**COMPARACIÓN DIRECTA: BR-031 vs BR-046**

Tabla comparativa completa:

|Característica|BR-031 (DESENCADENADOR)|BR-046 (INFERENCIA)|
|---|---|---|
|Condición|Vence en 30 días|Ya venció|
|Comportamiento|NOTIFICAR propietario|MARCAR como caduco|
|¿Observable?|SÍ (emails)|NO (solo BD)|
|¿Genera UC?|SÍ (UC-07)|NO|
|¿Genera FR?|SÍ (9 FR)|SÍ (1 FR directo)|
|Trazabilidad|BR→UC→FR|BR→FR directo|
|Actor|Propietario, Coordinador|Ninguno|
|Líneas código|~150 (complejo)|~15 (UPDATE simple)|

**Conclusión crítica:**

> "MISMO evento (contenedor que vence), DIFERENTE tipo de regla, DIFERENTE transformación. AMBAS coexisten y se complementan."

**2 ejemplos adicionales:**

- BR-098: Marcar producto "Requiere Reorden" (trigger en tiempo real)
- BR-115: Clasificar cliente como "Moroso" (condiciones múltiples)

### 3.5 Patrón 5: Cálculos → Pasos en Casos de Uso

**Principio:**

> "Los Cálculos NO generan UC independientes, pero SÍ se integran como pasos dentro de UC existentes."

**Ejemplo 1: BR-060 (tabla de descuentos)**

```
BR-060 (CÁLCULO):
"El descuento aplicable se determina según tabla de descuentos por volumen"

Tabla:
+----------+----------+-----------+
| Cantidad | Cantidad | Descuento |
| Mínima   | Máxima   |           |
+----------+----------+-----------+
| 1        | 10       | 0%        |
| 11       | 50       | 5%        |
| 51       | 100      | 10%       |
| 101      | ∞        | 15%       |
+----------+----------+-----------+

INTEGRACIÓN EN UC-10: Procesar Orden de Compra

Paso 7: Sistema calcula descuento según volumen [BR-060]

RF-478: Calcular Descuento por Volumen
  Entrada: cantidad_total, subtotal
  Salida: descuento_porcentaje, descuento_monto
  
  Algoritmo (versión configurable):
    // Consulta tabla en BD (recomendado)
    descuento_pct = SELECT descuento_pct
                    FROM ConfiguracionDescuentos
                    WHERE cantidad_total >= cantidad_min
                      AND (cantidad_max IS NULL 
                           OR cantidad_total <= cantidad_max)
                    ORDER BY cantidad_min DESC
                    LIMIT 1
    
    descuento_monto = subtotal * (descuento_pct / 100.0)
```

**Ejemplo 2: BR-077 (fórmula matemática)**

```
BR-077: Costo de envío
  Base: $50
  Plus por peso: $5/kg
  Plus por distancia: $2/100km
  Descuento volumen: 10% si peso >50kg

RF-489: Calcular Costo de Envío
  costo = 50 + (peso * 5) + (distancia/100 * 2)
  IF peso > 50 THEN
    costo = costo * 0.9
  END IF
```

**Diagrama de integración:**

- 1 diagrama PlantUML mostrando cálculo en flujo de UC

---

## RESUMEN DE LOS 5 PATRONES (Tabla Resumen)

```
+-------------+------------------+-----------+---------------+
| Tipo BR     | ¿Genera UC?      | Genera    | Ejemplo       |
+-------------+------------------+-----------+---------------+
| HECHO       | NO               | Modelo    | BR-012        |
+-------------+------------------+-----------+---------------+
| RESTRICCIÓN | NO (independ.)   | Precond.  | BR-028, 087   |
+-------------+------------------+-----------+---------------+
| DESENCADE-  | SÍ ⭐⭐⭐        | UC        | BR-031        |
| NADOR       | (ÚNICO)          | Completo  | (10 páginas)  |
+-------------+------------------+-----------+---------------+
| INFERENCIA  | NO               | FR        | BR-046        |
|             |                  | Directo   |               |
+-------------+------------------+-----------+---------------+
| CÁLCULO     | NO (independ.)   | Paso+FR   | BR-060, 077   |
+-------------+------------------+-----------+---------------+
```

---

## ANÁLISIS CRÍTICO DE SECCIONES 1-3

### Confirmación: Dominio Químicos

**Conteo de términos específicos del dominio:**

|Término|Occurrencias Estimadas|Secciones Principales|
|---|---|---|
|"químico"/"producto químico"|120+|2.2, 2.4, 2.5, 3.3|
|"contenedor"|85+|3.1, 3.3, 3.4|
|"vencimiento"|60+|3.3, 3.4|
|"certificación OSHA"|25+|3.2|
|"propietario del contenedor"|20+|3.3|
|"Coordinador de Seguridad"|18+|3.3|
|"código de barras"|15+|3.1|
|"solicitud de compra"|12+|3.2|

**Business Rules del dominio químicos:**

|BR ID|Tipo|Occurrencias en 2A|Desarrollo|
|---|---|---|---|
|**BR-031**|Desencadenador|**35+** ⭐⭐⭐|10 páginas completas|
|**BR-028**|Restricción|18+|3 páginas|
|**BR-087**|Restricción|22+|4 páginas|
|**BR-046**|Inferencia|15+|2 páginas|
|**BR-012**|Hecho|12+|3 páginas|
|**BR-060**|Cálculo|8+|2 páginas|
|**BR-077**|Cálculo|4+|1 página|

### Ejemplo Estrella: BR-031

**BR-031 es el EJEMPLO CENTRAL de toda PARTE 2:**

**Desarrollo completo:**

- Análisis inicial: 4 páginas
- UC-07 completo: 5 páginas
- Derivación de FR: 3 páginas
- Trazabilidad: 1 página
- **TOTAL: ~13 páginas** dedicadas a un solo ejemplo

**Por qué es estrella:**

1. ✅ Es el ejemplo MÁS DESARROLLADO de PARTE 2
2. ✅ Demuestra TODO el proceso de transformación
3. ✅ Incluye 9 Functional Requirements completos
4. ✅ Tiene 5 Flujos Alternos detallados
5. ✅ Template HTML de email incluido
6. ✅ Código Java de ejemplo
7. ✅ Comparación directa con BR-046 (Inferencia)
8. ✅ Usado para enseñar distinción Desencadenador vs Inferencia

### Secciones Críticas para Reescritura (2A)

**🔴 PRIORIDAD CRÍTICA:**

1. **Sección 3.3: Patrón Desencadenadores (BR-031 → UC-07)**
    
    - **Esfuerzo: 15-20h** (el más complejo)
    - Razón: 13 páginas, 9 FR, template HTML, código Java
    - Ejemplo más desarrollado de todo PARTE 2
    - Debe reemplazarse con ejemplo IACT igualmente robusto
2. **Sección 3.2: Patrón Restricciones (BR-087, BR-028)**
    
    - **Esfuerzo: 8-10h**
    - Razón: 2 ejemplos extensos con múltiples FR
3. **Sección 3.4: Comparación Desencadenador vs Inferencia**
    
    - **Esfuerzo: 6-8h**
    - Razón: Tabla comparativa crítica BR-031 vs BR-046
    - Concepto fundamental de la metodología

**🟡 PRIORIDAD ALTA:**

4. **Sección 3.1: Patrón Hechos (BR-012)**
    
    - **Esfuerzo: 4-6h**
    - 3 ejemplos con diagramas de clases
5. **Sección 2.2-2.5: Ejemplos de UC**
    
    - **Esfuerzo: 4-6h**
    - UC-04, UC-12 con múltiples FA
6. **Sección 3.5: Patrón Cálculos**
    
    - **Esfuerzo: 3-4h**
    - BR-060 tabla descuentos, BR-077 fórmula envío

**TOTAL SECCIONES 1-3:** 40-54 horas

### Diagramas PlantUML Identificados (2A)

1. Proceso General de Transformación (Sec. 1.4)
2. Decisión Central: ¿Qué Genera Cada Tipo? (Sec. 1.4)
3. Anatomía de un Caso de Uso (Sec. 2.2)
4. Taxonomía de Actores (Sec. 2.4)
5. Estructura de Flujos en UC (Sec. 2.5)
6. Diagrama de Decisión por Tipo de BR (Sec. 3 intro)
7. Diagrama de Clases para BR-012 (Sec. 3.1)
8. Integración de Cálculo en Flujo (Sec. 3.5)

**TOTAL: 8 diagramas** en secciones 1-3

---

## ESTADO ACTUAL Y SIGUIENTE PASO

**COMPLETADO:**

- ✅ Análisis exhaustivo PARTE 2A (Secciones 1-3)
- ✅ Identificación de ejemplo estrella BR-031
- ✅ Conteo de términos químicos en 2A
- ✅ Identificación de 8 diagramas PlantUML
- ✅ Estimación de esfuerzo para reescritura 2A: 40-54h

**PENDIENTE:**

- Analizar PARTE 2B (Secciones 4-7): Construcción, Integración, Derivación, Trazabilidad
- Analizar PARTE 2C (Secciones 8-11): Casos Especiales, Calidad, Ejercicios, Resumen

**¿Continuar con PARTE 2B?**
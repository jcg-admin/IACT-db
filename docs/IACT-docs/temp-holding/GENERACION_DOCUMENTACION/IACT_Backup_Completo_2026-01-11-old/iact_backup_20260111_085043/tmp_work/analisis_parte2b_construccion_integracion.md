# ANÁLISIS PARTE 2B: CONSTRUCCIÓN E INTEGRACIÓN (Secciones 4-7)

**Fecha:** 2026-01-08
**Documento:** PARTE_2.md (UID: 20251208041455144132)
**Análisis:** Secciones 4-7 (~2,000 líneas, 33% del documento)
**Rango:** Construcción de UC, Integración de BR, Derivación de FR, Trazabilidad

---

## SECCIÓN 4: CONSTRUCCIÓN DE CASOS DE USO

### 4.1 Proceso de Construcción en 7 Pasos

**Diagrama incluido:**
- Proceso Completo de Construcción de Caso de Uso (1 diagrama PlantUML)

**Los 7 pasos presentados:**
```
PASO 1: Identificar Actor Primario
PASO 2: Definir Objetivo del UC
PASO 3: Establecer Precondiciones
PASO 4: Escribir Flujo Normal ← NÚCLEO (más esfuerzo)
PASO 5: Identificar Flujos Alternos
PASO 6: Establecer Postcondiciones
PASO 7: Documentar BR Aplicadas
```

**Observación crítica:**
> "PASO 4 es el NÚCLEO del UC. Aquí se invierte mayor esfuerzo."

### 4.2 Paso 1: Identificar Actor Primario

**Pregunta guía:** "¿Quién quiere que esto ocurra?"

**Ejemplo aplicado (BR-031 → UC-07):**
```
BR-031: "SI químico vence ENTONCES notificar propietario..."

Análisis:
  Comportamiento: "notificar"
  
  ¿Quién se beneficia?
    - Propietario recibe notificación → Se beneficia
    - Coordinador recibe notificación → Se beneficia
  
  ¿Quién INICIA?
    - NO es propietario (él RECIBE, no inicia)
    - NO es coordinador (él RECIBE, no inicia)
    - ES el SISTEMA (inicia automáticamente por schedule)
  
Decisión: Actor Primario = Sistema (tiempo)
```

**3 errores comunes documentados:**
1. Confundir actor primario con secundario
2. Usar componente técnico como actor
3. Múltiples actores primarios

**Plantilla de decisión:**
```
Pregunta 1: ¿Es automático/periódico?
  SÍ → Actor: Sistema (tiempo)
  NO → Continuar

Pregunta 2: ¿Es sistema externo?
  SÍ → Actor: [Nombre del Sistema]
  NO → Continuar

Pregunta 3: ¿Es persona con rol específico?
  SÍ → Actor: [Nombre del Rol]
```

### 4.3 Paso 2: Definir Objetivo del Caso de Uso

**Pregunta guía:** "¿Qué resultado tiene valor para el actor?"

**Ejemplo aplicado (UC-07):**
```
Actor: Sistema (tiempo)

Objetivo:
  "El sistema quiere notificar a propietarios sobre vencimientos 
   para que puedan tomar acción antes de que químicos caduquen"

Nombre del UC: "Notificar Vencimiento de Químico"
  - Verbo: Notificar
  - Objeto: Vencimiento de Químico
  - Claro y específico

Stakeholders:
  - Propietario: Quiere saber con anticipación para renovar
  - Coordinador: Quiere supervisar cumplimiento normativo
  - Universidad: Quiere minimizar riesgos
```

**Ejemplos de buenos nombres:**
```
✓ Solicitar Producto Químico
✓ Aprobar Solicitud de Compra
✓ Transferir Contenedor Entre Ubicaciones
✓ Generar Reporte Mensual de Inventario
✓ Registrar Entrada de Mercancía
```

**Ejemplos de malos nombres:**
```
✗ Solicitudes (no es verbo)
✗ Gestión de Productos (muy vago)
✗ Sistema de Inventario (es módulo, no acción)
```

### 4.4 Paso 3: Establecer Precondiciones

**Pregunta guía:** "¿Qué debe existir o ser cierto para que esto pueda iniciar?"

**4 categorías de precondiciones:**

```
CATEGORÍA 1: Autenticación y Autorización
  - Usuario autenticado
  - Usuario tiene rol [X]
  - Usuario tiene certificación [Z] [BR-087]

CATEGORÍA 2: Existencia de Datos
  - Existen productos en catálogo
  - Contenedor registrado en inventario

CATEGORÍA 3: Estado del Sistema
  - Sistema en horario de operación
  - Servidor SMTP disponible

CATEGORÍA 4: Condiciones de Negocio
  - Cliente sin facturas vencidas [BR-115]
  - Aprobador asignado a departamento
```

**Ejemplo aplicado (UC-07):**
```
Precondiciones:
  1. Existen contenedores registrados en el sistema
     (Categoría: Datos)
  
  2. Servidor SMTP configurado y accesible
     (Categoría: Sistema)
  
  3. Al menos un contenedor tiene fecha_vencimiento dentro de 30 días
     (Categoría: Negocio - "soft")
```

**Ejemplo UC-04 (más complejo):**
```
Precondiciones:
  1. Usuario autenticado en el sistema
  2. Usuario tiene rol "Solicitante" o superior
  3. SI producto es clase peligrosa (1-4):
     ENTONCES usuario tiene certificación OSHA vigente [BR-087]
  4. Existen productos en catálogo
  5. Sistema en horario de operación
```

**Diferencia precondición vs validación:**
```
PRECONDICIÓN:
  - Debe cumplirse ANTES de iniciar UC
  - Si no cumple, UC NO puede ejecutarse
  - Ejemplo: "Usuario autenticado"

VALIDACIÓN EN PASO:
  - Se verifica DURANTE la ejecución
  - Si falla, se maneja con flujo alterno
  - Ejemplo: "Sistema verifica stock" (paso 5)
```

### 4.5 Paso 4: Escribir Flujo Normal (El Núcleo)

**LA SECCIÓN MÁS IMPORTANTE DE LA CONSTRUCCIÓN**

**Pregunta guía:** "¿Qué pasa cuando todo sale perfecto?"

**Proceso detallado en 7 subpasos:**
```
PASO 4.1: Listar acciones de alto nivel (3-7 acciones)
PASO 4.2: Descomponer en pasos observables
PASO 4.3: Numerar secuencialmente (1, 2, 3...)
PASO 4.4: Alternar actor-sistema (cuando natural)
PASO 4.5: Usar presente indicativo
PASO 4.6: Identificar dónde aplican BR
PASO 4.7: Revisar longitud (ideal: 5-10 pasos)
```

**Granularidad de pasos:**
```
DEMASIADO ALTO NIVEL:
  ✗ "Sistema procesa la orden"
    (¿Cómo la procesa? Demasiado vago)

DEMASIADO BAJO NIVEL:
  ✗ "Sistema abre conexión a base de datos"
  ✗ "Sistema ejecuta SELECT * FROM Productos"
    (Demasiados detalles de implementación)

NIVEL CORRECTO:
  ✓ "Sistema consulta productos en catálogo"
  ✓ "Sistema calcula costo total"
  ✓ "Sistema registra solicitud"
    (Nivel de abstracción apropiado)
```

**Técnica de alternancia:**
```
PATRÓN TÍPICO (con interacción):
1. Actor proporciona entrada
2. Sistema procesa entrada
3. Sistema muestra resultado
4. Actor proporciona más entrada
5. Sistema procesa
6. Sistema registra resultado

PATRÓN BATCH (sin alternancia):
1. Sistema obtiene fecha actual
2. Sistema consulta registros
3. Sistema filtra según criterio
4. Sistema procesa cada registro
5. Sistema registra en log
```

**Subpasos (cuándo usar):**
```
USAR cuando:
  - Un paso tiene múltiples acciones relacionadas
  - Hay iteración (PARA CADA)
  
FORMATO:
  4. Sistema procesa cada contenedor:
     4.1 Sistema obtiene propietario
     4.2 Sistema obtiene email
     4.3 Sistema genera contenido
     4.4 Sistema envía email
     4.5 Sistema registra notificación

LÍMITE:
  - Máximo 2 niveles (4.1, NO 4.1.1)
  - Máximo 10 subpasos por paso principal
```

**Ejemplo de construcción paso a paso (UC-04):**
```
CASO: UC-04 "Solicitar Producto Químico"

PASO 4.1: Lista conceptual
  - Usuario elige producto
  - Usuario especifica cantidad
  - Sistema calcula costo
  - Usuario confirma
  - Sistema registra
  - Sistema notifica

PASO 4.2: Descomposición detallada
  "Usuario elige producto" →
    1. Usuario selecciona "Nueva Solicitud"
    2. Sistema muestra catálogo
    3. Usuario selecciona producto

  "Sistema calcula costo" →
    5. Sistema obtiene precio
    6. Sistema calcula subtotal
    7. Sistema calcula descuento [BR-060]
    8. Sistema muestra costo

RESULTADO: 12 pasos finales
```

**Flujo Normal completo UC-04:**
```
1. Usuario selecciona "Nueva Solicitud"
2. Sistema muestra catálogo de productos químicos
3. Usuario selecciona producto
4. Usuario especifica cantidad
5. Sistema obtiene precio
6. Sistema calcula subtotal
7. Sistema calcula descuento [BR-060]
8. Sistema muestra desglose
9. Usuario confirma
10. Sistema verifica monto >$500 [BR-028]
11. SI monto <= $500:
      Registra "Aprobada"
      Actualiza inventario
      Muestra confirmación
    SINO:
      Ir a FA-1 [BR-028]
```

**Términos químicos en construcción de flujo:**
- "catálogo de productos químicos" (3×)
- "producto químico" (5×)
- "inventario" (2×)

### 4.6 Paso 5: Identificar Flujos Alternos

**Pregunta guía:** "¿Qué puede salir mal o diferente?"

**Proceso detallado:**
```
PASO 5.1: Por cada paso, preguntarse:
  - ¿Qué puede fallar?
  - ¿Qué validación puede fallar?
  - ¿Qué decisión puede tomar otro camino?

PASO 5.2: Identificar tipos de FA:
  - Errores de validación
  - Errores técnicos
  - Variaciones de negocio
  - Cancelación por usuario

PASO 5.3: Documentar cada FA:
  a. Punto de desviación
  b. Condición que lo activa
  c. Qué pasa diferente
  d. Cómo termina

PASO 5.4: Nombrar descriptivamente
  FA-1: Usuario Sin Certificación Requerida

PASO 5.5: Priorizar por probabilidad
```

**5 categorías de flujos alternos:**

```
TIPO A: Error de Validación
  Patrón:
    Xa. Sistema detecta dato inválido/faltante
    Xb. Sistema muestra mensaje de error
    Xc. Sistema indica qué corregir
    Xd. Retornar a paso X

TIPO B: Restricción de Negocio Violada
  Patrón:
    Xa. Sistema detecta que BR no se cumple
    Xb. Sistema aplica consecuencia de BR
    Xc. Sistema notifica a quien corresponda
    Xd. UC termina o continúa con proceso especial

TIPO C: Error Técnico
  Patrón:
    Xa. Sistema no puede conectar con servicio
    Xb. Sistema registra error en log
    Xc. Sistema espera N segundos
    Xd. Sistema reintenta (máximo M veces)
    Xe. Si falla: Notificar admin, terminar

TIPO D: No Hay Datos
  Patrón:
    Xa. Sistema ejecuta búsqueda
    Xb. Sistema no encuentra registros
    Xc. Sistema muestra mensaje informativo
    Xd. UC termina o retorna

TIPO E: Usuario Cancela
  Patrón:
    *a. En cualquier momento antes de paso X
    *b. Usuario presiona "Cancelar"
    *c. Sistema descarta cambios temporales
    *d. UC termina sin completar
```

**Ejemplo completo UC-04 (7 flujos alternos):**

```
FA-1: Solicitud Requiere Aprobación [BR-028]
  10a. Sistema detecta monto >$500
  10b. Sistema identifica gerente
  10c. Sistema registra "Pendiente Aprobación"
  10d. Sistema envía email a gerente
  10e. UC termina (continuará con UC-09)

FA-2: Producto Sin Stock Disponible
  2a. Sistema consulta catálogo
  2b. NO hay productos con stock>0
  2c. Sistema muestra mensaje
  2d. UC termina

FA-3: Cantidad Excede Stock
  4a. Sistema verifica stock
  4b. cantidad_solicitada > stock_disponible
  4c. Sistema muestra error con stock disponible
  4d. Retornar a paso 4

FA-4: Usuario Sin Certificación OSHA [BR-087]
  3a. Sistema detecta producto clase 1-4
  3b. Sistema verifica certificaciones
  3c. NO existe certificación OSHA vigente
  3d. Sistema muestra mensaje denegación
  3e. Sistema registra intento en log auditoría
  3f. Retornar a paso 2

FA-5: Error al Calcular Descuento
  7a. Sistema invoca cálculo descuento
  7b. Función falla (tabla vacía)
  7c. Sistema registra error
  7d. Sistema asume descuento=0%
  7e. Continuar con paso 8

FA-6: Usuario Cancela Solicitud
  *a. Cualquier momento antes de paso 9
  *b. Usuario presiona "Cancelar"
  *c. Sistema descarta datos temporales
  *d. Sistema muestra "Solicitud cancelada"
  *e. Retornar a menú principal

FA-7: Error al Registrar Solicitud
  11a. Sistema intenta INSERT en BD
  11b. BD retorna error (constraint, timeout)
  11c. Sistema registra error en log
  11d. Sistema muestra mensaje error
  11e. Sistema ofrece: "Reintentar" o "Cancelar"
  11f. Si Reintentar: Volver a paso 11
  11g. Si Cancelar: UC termina sin completar
```

**Notación de punto de desviación:**
```
Xa.  → Después del paso X
3-7a. → Entre pasos 3 y 7
*a.  → En cualquier momento
```

**Términos químicos en flujos alternos:**
- "producto químico peligroso" (4×)
- "certificación OSHA" (6×)
- "stock disponible" (3×)
- "contenedor" (en otros UC, 8×)

### 4.7 Paso 6: Establecer Postcondiciones

**Pregunta guía:** "Si todo salió bien, ¿qué cambió en el sistema?"

**Proceso:**
```
PASO 6.1: Identificar cambios de estado
PASO 6.2: Identificar notificaciones enviadas
PASO 6.3: Identificar actualizaciones de inventario
PASO 6.4: Incluir inferencias (BR Tipo 4)
PASO 6.5: Escribir como ESTADO RESULTANTE
```

**Ejemplo UC-04:**
```
Postcondiciones (Flujo Normal):
  - Solicitud registrada con estado "Aprobada"
  - Número único de solicitud generado
  - Inventario reservado actualizado (stock_reservado += cantidad)
  - Usuario notificado de confirmación
  - Log de transacciones actualizado
  - Auditoría registrada

Postcondiciones (FA-1: Requiere Aprobación):
  - Solicitud registrada con estado "Pendiente Aprobación"
  - Registro en AprobacionesPendientes creado
  - Gerente notificado por email
  - Solicitante notificado de envío a aprobación
  - Log actualizado
```

**Garantías (concepto avanzado):**
```
GARANTÍAS MÍNIMAS (incluso si falla):
  - Sistema registró intento en log
  - No se corrompió integridad de datos
  - Transacciones con rollback completo
  - Usuario recibió mensaje de error

GARANTÍAS DE ÉXITO (cuando termina bien):
  - Solicitud completa registrada
  - Todos los campos obligatorios válidos
  - Todas las notificaciones enviadas
  - Todas las actualizaciones atómicas
```

### 4.8 Paso 7: Documentar Business Rules Aplicadas

**Formato:**
```
Business Rules Aplicadas:
  - BR-NNN: [Descripción de cómo/dónde se aplica]
```

**Ejemplo UC-04:**
```
Business Rules Aplicadas:
  - BR-028: Restricción aprobación >$500
            Ubicación: Paso 10 + FA-1
  
  - BR-060: Cálculo descuento por volumen
            Ubicación: Paso 7
  
  - BR-087: Restricción certificación OSHA
            Ubicación: Precondición + FA-4
  
  - BR-046: Inferencia estado "Reservado"
            Ubicación: Postcondición
```

**Estadísticas Sección 4:**
- **4 ejemplos completos** de UC construidos
- **7 subpasos** en proceso de construcción
- **5 categorías** de flujos alternos
- **7 flujos alternos** en UC-04
- **12 pasos** en flujo normal UC-04

---

## SECCIÓN 5: INTEGRACIÓN DE MÚLTIPLES BUSINESS RULES

### 5.1 Concepto de Integración

**Realidad del análisis:**
```
CASO TÍPICO:
  Un UC NO se deriva de una sola BR
  Un UC integra 3-7 BR de diferentes tipos

EJEMPLO UC-04:
  - BR-012 (Hecho): Modelo de dominio
  - BR-087 (Restricción): Precondición + FA
  - BR-028 (Restricción): Validación + FA
  - BR-060 (Cálculo): Paso del flujo
  - BR-046 (Inferencia): Postcondición
  
RESULTADO: 5 BR de 4 tipos en UN SOLO UC
```

### 5.2 Orden de Integración Recomendado

**6 pasos secuenciales:**
```
PASO 1: HECHOS (Tipo 1)
  - Definir modelo de dominio primero
  - Establece estructura base

PASO 2: RESTRICCIONES como PRECONDICIONES (Tipo 2)
  - Agregar restricciones ANTES
  - Permisos, autorizaciones

PASO 3: DESENCADENADOR (Tipo 3)
  - Si hay Desencadenador, GENERA el UC
  - Escribir flujo básico

PASO 4: CÁLCULOS (Tipo 5)
  - Integrar como pasos del flujo
  - Ubicación lógica

PASO 5: RESTRICCIONES como VALIDACIONES (Tipo 2)
  - Agregar validaciones DURANTE
  - Crear flujos alternos

PASO 6: INFERENCIAS (Tipo 4)
  - Agregar en postcondiciones
  - Ocurren automáticamente
```

### 5.3 Ejemplo Completo: UC-04 con 5 BR Integradas

**EL EJEMPLO MÁS COMPLETO DE INTEGRACIÓN**

**BR a integrar:**
- BR-012 (Hecho): Código único
- BR-087 (Restricción): Certificación OSHA
- BR-028 (Restricción): Aprobación >$500
- BR-060 (Cálculo): Descuento volumen
- BR-046 (Inferencia): Estado Reservado

**Proceso de integración paso a paso (6 pasos):**

```
PASO 1: Aplicar BR-012 (Hecho) → Modelo
  Resultado: Entidad Contenedor con codigo_barras UNIQUE
  Impacto: Consultado en UC, no afecta flujo directamente

PASO 2: Aplicar BR-087 (Restricción) → Precondición
  Análisis: Debe verificarse ANTES
  
  Integración:
    Precondiciones:
      - SI producto clase 1-4:
        ENTONCES certificación OSHA vigente [BR-087]
    
    FA-4: Usuario Sin Certificación [BR-087]
      3a. Sistema detecta peligroso sin certificación
      3b. Sistema deniega acceso
      3c. UC termina

PASO 3: NO hay Desencadenador
  UC-04 NO generado por Desencadenador
  Identificado por otras técnicas (Parte 3)

PASO 4: Aplicar BR-060 (Cálculo) → Paso en Flujo
  Análisis: Necesita subtotal primero
  
  Integración:
    Paso 6: Sistema calcula subtotal
    Paso 7: Sistema calcula descuento [BR-060]
    Paso 8: Sistema muestra desglose

PASO 5: Aplicar BR-028 (Restricción) → Validación + FA
  Análisis: Monto se conoce DURANTE el flujo
  
  Integración:
    Paso 10: Sistema verifica monto >$500 [BR-028]
    
    FA-1: Requiere Aprobación [BR-028]
      10a. Sistema detecta monto >$500
      10b. Sistema registra "Pendiente"
      10c. Sistema notifica gerente
      10d. UC termina (continuará UC-09)

PASO 6: Aplicar BR-046 (Inferencia) → Postcondición
  Análisis: Cambio automático no observable
  
  Integración:
    Postcondiciones:
      - Solicitud "Aprobada"
      - Contenedor "Reservado" [BR-046]
      - Inventario actualizado
```

**UC-04 COMPLETO resultante:**
- **12 pasos** en flujo normal
- **7 flujos alternos**
- **5 BR integradas** de 4 tipos
- **4 FR derivados** por BR
- **Total ~20 FR** en UC completo

### 5.4 Proceso para Identificar BR que van Juntas

**3 técnicas:**

```
TÉCNICA 1: Análisis por Entidad
  - Identificar entidad central (Solicitud)
  - Buscar BR que mencionan esa entidad
  - Agrupar en UC que maneja entidad

TÉCNICA 2: Análisis por Flujo
  - Identificar proceso (Solicitar)
  - Buscar BR que afectan proceso
  - Integrar según orden lógico

TÉCNICA 3: Análisis por Stakeholder
  - Identificar actor (Solicitante)
  - Buscar BR que afectan acciones
  - Agrupar en UC del actor
```

**Estadísticas Sección 5:**
- **1 ejemplo completo** de integración (UC-04)
- **6 pasos** de integración
- **5 BR integradas** en ejemplo
- **3 técnicas** para identificar BR relacionadas

---

## SECCIÓN 6: DERIVACIÓN DE FUNCTIONAL REQUIREMENTS

### 6.1 Principio Fundamental

```
REGLA DE ORO:
  Cada paso del flujo normal genera ≥1 FR
  Pasos complejos generan 2-5 FR
  
GRANULARIDAD:
  1 FR = 1 acción atómica del sistema
  
TRAZABILIDAD:
  FR → UC Paso N → BR (si aplica)
```

### 6.2 Proceso de Derivación (3 pasos)

```
PASO 1: Identificar acciones del SISTEMA
  - Solo pasos donde "Sistema" es sujeto
  - Ignorar acciones del actor

PASO 2: Descomponer pasos complejos
  - Si múltiples acciones → Múltiples FR
  - Criterio: ¿Acciones más atómicas?

PASO 3: Documentar cada FR
  - ID único
  - Descripción
  - Derivado de: UC-XX Paso Y
  - Implementa: BR-ZZZ
  - Algoritmo/Query
```

### 6.3 Ejemplo de Derivación (UC-07)

**Ejemplo 1: Paso simple → 1 FR**
```
UC-07 Paso 1: "Sistema verifica fecha actual"

Derivación: 1 acción atómica

RF-301: Obtener Fecha Actual del Servidor
  Descripción: El sistema debe obtener fecha actual
  Derivado de: UC-07 Paso 1
  Implementa: BR-031 (condición)
  Query: SELECT CURDATE() FROM DUAL;
  Prioridad: Alta
```

**Ejemplo 2: Paso único complejo → 1 FR**
```
UC-07 Paso 3: "Sistema filtra contenedores
               DATEDIFF <= 30 y estado = ACTIVO"

Derivación: Técnicamente 1 SELECT

RF-303: Filtrar Contenedores Próximos a Vencer
  Descripción: Filtrar donde diferencia <= 30 días
  Derivado de: UC-07 Paso 3
  Implementa: BR-031 (condición: 30 días)
  
  Query SQL:
    SELECT c.*
    FROM Contenedores c
    WHERE DATEDIFF(c.fecha_vencimiento, CURDATE()) <= 30
      AND DATEDIFF(c.fecha_vencimiento, CURDATE()) >= 0
      AND c.estado = 'ACTIVO'
  
  Prioridad: Alta
```

**Ejemplo 3: Paso con subpasos → Múltiples FR**
```
UC-07 Paso 4: Sistema itera sobre cada contenedor:
  4.1 Consulta asignación
  4.2 Obtiene propietario
  4.3 Obtiene email
  4.4 Obtiene coordinador
  4.5 Obtiene email coordinador
  4.6 Genera contenido
  4.7 Envía email propietario
  4.8 Envía email coordinador
  4.9 Registra notificación

Derivación: 9 subpasos → 6 FR
  4.1+4.2 → RF-304 (Obtener Propietario)
  4.3 → RF-305 (Validar Email)
  4.4+4.5 → RF-306 (Obtener Coordinador)
  4.6 → RF-307 (Generar Contenido)
  4.7+4.8 → RF-308 (Enviar Email)
  4.9 → RF-309 (Registrar Notificación)

Total: 6 FR del paso 4
```

**RF-308 completo (ejemplo detallado):**
```
RF-308: Enviar Email vía Protocolo SMTP

Descripción:
  El sistema debe invocar servicio SMTP para enviar email
  con manejo de reintentos en caso de fallo.

Derivado de: UC-07 Paso 4.8 y 4.9
Implementa: BR-031 (mecanismo: envío)
Prioridad: Alta

Parámetros SMTP (tabla Config_SMTP):
  - servidor_smtp: "smtp.gmail.com"
  - puerto: 587
  - usuario: cuenta sistema
  - password: cifrado
  - usar_tls: TRUE
  - timeout_segundos: 30

Lógica de envío:
  TRY
    conexion = SMTP.connect(servidor, puerto, timeout)
    IF usar_tls THEN conexion.starttls()
    conexion.login(usuario, password)
    conexion.sendmail(from, to, subject, body)
    conexion.quit()
    RETURN SUCCESS
  CATCH SMTPException
    LOG ERROR
    RETURN FAILURE

Manejo de reintentos:
  intentos = 0
  max_intentos = 3
  WHILE intentos < max_intentos
    resultado = enviar_email()
    IF resultado = SUCCESS THEN BREAK
    intentos++
    IF intentos < max THEN WAIT 60 segundos
  END WHILE
  
  IF intentos = max AND FAILURE THEN
    registrar_notificacion_fallida()
    alertar_administrador()
```

### 6.4 Granularidad: ¿Cuándo Dividir un Paso?

**4 casos documentados:**

```
CASO 1: Paso simple → 1 FR
  Paso: "Sistema consulta catálogo"
  Derivación: 1 FR con SELECT simple

CASO 2: Múltiples consultas independientes → Múltiples FR
  Paso: "Sistema obtiene producto, proveedor y precio"
  Derivación: 3 FR (uno por consulta)

CASO 3: Algoritmo complejo → 1 FR detallado
  Paso: "Sistema calcula descuento según volumen"
  Derivación: 1 FR con algoritmo IF-THEN-ELSE

CASO 4: Iteración → 1 FR + N FR acciones internas
  Paso: "Sistema procesa cada item: calcula, valida, registra"
  Derivación: 1 FR iteración + 3 FR acciones
```

### 6.5 Numeración de FR

**Sistema recomendado: Por Módulo**
```
RF-001 a RF-099: Autenticación y Seguridad
RF-100 a RF-199: Gestión de Usuarios
RF-200 a RF-299: Solicitudes
RF-300 a RF-399: Notificaciones
RF-400 a RF-499: Permisos
RF-500 a RF-599: Reportes
```

**Alternativa: Secuencial simple**
```
RF-001, RF-002, RF-003, ...
```

**Estadísticas Sección 6:**
- **9 FR derivados** de UC-07 (ejemplo completo)
- **4 casos** de granularidad explicados
- **2 sistemas** de numeración propuestos
- **1 ejemplo** de FR con reintentos (RF-308)

---

## SECCIÓN 7: TRAZABILIDAD BIDIRECCIONAL

### 7.1 Forward Tracing (Análisis de Impacto)

**Objetivo:** "Si una BR cambia, ¿qué hay que actualizar?"

**Proceso:**
```
1. Identificar BR que cambia
2. Buscar en Matriz de Trazabilidad: BR → UC
3. Para cada UC afectado: UC → FR
4. Para cada FR afectado: FR → Código
5. IMPACTO TOTAL: UC, FR, código, tests, docs
```

**Ejemplo completo: BR-028 cambia de $500 a $1,000**

```
CAMBIO: BR-028 umbral $500 → $1,000

FORWARD TRACING:

BR-028 → UC-04 (afectado)
  Cambios:
    - Paso 11: "monto >$1000" (cambiar umbral)
    - FA-1: "11a. monto >$1000" (cambiar condición)
    - Precondición: NO afectada
    - Postcondición: NO afectada

UC-04 → RF-205, RF-206
  RF-205: Comparar Monto con Umbral
    Cambio: umbral = 1000 (antes 500)
    
  RF-206: Identificar Gerente
    Cambio: NO afectado

RF-205 → Código
  SolicitudService.java:
    private static final int UMBRAL = 1000;
    
  O en BD:
    UPDATE Configuracion 
    SET umbral_aprobacion = 1000

Código → Tests
  SolicitudServiceTest.java:
    testRequiereAprobacion_MontoMenor(): $999
    testRequiereAprobacion_MontoExacto(): $1000
    testRequiereAprobacion_MontoMayor(): $1001

ESTIMACIÓN ESFUERZO:
  - Actualizar UC-04: 15 min
  - Actualizar RF-205: 10 min
  - Modificar código: 30 min
  - Actualizar tests: 1 hora
  - Testing QA: 2 horas
  ─────────────────────
  TOTAL: ~4 horas
```

### 7.2 Backward Tracing (Justificación)

**Objetivo:** "¿Por qué existe este código?"

**Pregunta:** "¿Por qué línea 145 en ProductService.java?"

**Proceso:**
```
1. Identificar línea de código
2. Buscar comentario/anotación → FR
3. Buscar FR en docs → UC
4. Buscar UC en docs → BR
5. Buscar BR en catálogo → Fuente
```

**Ejemplo completo:**

```
1. LÍNEA DE CÓDIGO:
   ProductService.java línea 145:
     if (solicitud.getMonto() > 500) { ... }

2. COMENTARIO:
   // Implementa RF-205

3. FR-205 en documentación:
   "Comparar monto con umbral de aprobación"
   Derivado de: UC-04 Paso 11
   Implementa: BR-028

4. UC-04 en documentación:
   "Solicitar Producto Químico"
   Paso 11: "Sistema verifica si monto >$500"
   Business Rules: BR-028

5. BR-028 en catálogo:
   "Solicitudes >$500 requieren aprobación"
   Fuente: Política Financiera v2.3, Sección 4.2
   Vigencia: 2023-06-01

JUSTIFICACIÓN COMPLETA:
  "Esta línea existe porque la Política Financiera 
   Corporativa v2.3 (Sec 4.2, vigente desde junio 2023) 
   establece que solicitudes >$500 requieren aprobación 
   gerencial. Se documentó como BR-028, se transformó en 
   UC-04 (paso 11 + FA-1), se derivó como RF-205, y se 
   implementó en esta línea."
```

### 7.3 Matriz de Trazabilidad

**Formato completo:**

```
+--------+--------+-------------------+----------------------------+----------+
| BR ID  | Tipo   | UC IDs            | FR IDs                     | Código   |
+--------+--------+-------------------+----------------------------+----------+
| BR-012 | Hecho  | (modelo)          | (esquema BD)               | Entity   |
+--------+--------+-------------------+----------------------------+----------+
| BR-028 | Restr. | UC-04 (P11,FA1)   | RF-205,206,207,208,209     | Solic.   |
|        |        | UC-09 (P3)        | RF-355                     | Srv.145  |
+--------+--------+-------------------+----------------------------+----------+
| BR-031 | Desen. | UC-07 (completo)  | RF-301,302,303,304,305,    | Expir.   |
|        |        |                   | 306,307,308,309            | Srv.     |
+--------+--------+-------------------+----------------------------+----------+
| BR-046 | Infer. | -                 | RF-305 (directo)           | Cont.    |
|        |        |                   |                            | Srv.89   |
+--------+--------+-------------------+----------------------------+----------+
| BR-060 | Cálc.  | UC-04 (P7)        | RF-478                     | Calc.    |
|        |        | UC-10 (P8)        |                            | Srv.223  |
+--------+--------+-------------------+----------------------------+----------+
| BR-087 | Restr. | UC-04 (Prec,FA4)  | RF-401,402,403,404         | Perm.    |
|        |        | UC-12 (Prec)      |                            | Srv.67   |
+--------+--------+-------------------+----------------------------+----------+
```

**Herramientas sugeridas:**
- Excel/Google Sheets (simple)
- JIRA/Requirements Tool (profesional)
- Código: Anotaciones `@ImplementsBR("BR-028")`

**Estadísticas Sección 7:**
- **2 tipos** de tracing (forward, backward)
- **1 ejemplo completo** de forward tracing (4h esfuerzo)
- **1 ejemplo completo** de backward tracing (justificación)
- **1 matriz** completa con 6 BR

---

## ANÁLISIS CRÍTICO SECCIONES 4-7

### Confirmación Dominio Químicos (2B)

**Conteo de términos específicos:**

| Término | Occurrencias Estimadas | Secciones |
|---------|----------------------|-----------|
| "producto químico" | 45+ | 4.4, 4.5, 5.3 |
| "contenedor" | 38+ | 4.4, 6.3, 7.3 |
| "solicitud" | 55+ | 4.4, 4.5, 5.3 |
| "certificación OSHA" | 18+ | 4.4, 4.6, 5.3 |
| "vencimiento" | 25+ | 6.3 |
| "inventario" | 12+ | 4.4, 4.7 |
| "Coordinador de Seguridad" | 8+ | 6.3 |
| "catálogo de productos" | 6+ | 4.5 |

**Business Rules referenciadas:**

| BR ID | Tipo | Occurrencias 2B | Desarrollo |
|-------|------|----------------|------------|
| **BR-028** | Restricción | **25+** | Forward/backward tracing completo |
| **BR-031** | Desencadenador | **22+** | 9 FR derivados (UC-07) |
| **BR-087** | Restricción | **15+** | Integración en UC-04 |
| **BR-060** | Cálculo | **8+** | Integración paso 7 |
| **BR-046** | Inferencia | **6+** | Postcondición |
| **BR-012** | Hecho | **4+** | Modelo de dominio |

### UC-04: El Ejemplo Central de Integración

**UC-04 "Solicitar Producto Químico" es el ejemplo MÁS DESARROLLADO de integración:**

**Desarrollo completo en Sección 5:**
- Integración de 5 BR: 6 páginas
- 6 pasos de integración documentados
- 12 pasos en flujo normal
- 7 flujos alternos detallados
- 4 precondiciones
- 5 postcondiciones diferentes
- ~20 FR derivados total

**Por qué es crítico:**
1. ✅ Ejemplo MÁS COMPLETO de integración múltiple BR
2. ✅ Demuestra todos los tipos de integración
3. ✅ Aparece en múltiples secciones (4, 5, 7)
4. ✅ Usado para enseñar construcción paso a paso
5. ✅ Matriz de trazabilidad completa

### Secciones Críticas para Reescritura (2B)

**🔴 PRIORIDAD CRÍTICA:**

1. **Sección 5.3: UC-04 con 5 BR Integradas**
   - **Esfuerzo: 12-15h** (más complejo de 2B)
   - Razón: 6 páginas, integración completa, 7 FA
   - Ejemplo central de toda la metodología de integración
   - Debe reemplazarse con caso IACT igualmente complejo

2. **Sección 6.3: Derivación de 9 FR de UC-07**
   - **Esfuerzo: 8-10h**
   - Razón: 9 FR con queries/algoritmos completos
   - RF-308 muy detallado (manejo SMTP, reintentos)

3. **Sección 7.1-7.2: Forward y Backward Tracing**
   - **Esfuerzo: 6-8h**
   - Razón: Ejemplos completos con estimación de esfuerzo
   - Análisis de impacto de cambio BR-028

**🟡 PRIORIDAD ALTA:**

4. **Sección 4.5: Escribir Flujo Normal**
   - **Esfuerzo: 6-8h**
   - UC-04 construcción paso a paso
   - Granularidad, alternancia, subpasos

5. **Sección 4.6: Identificar Flujos Alternos**
   - **Esfuerzo: 5-7h**
   - 7 FA completos de UC-04
   - 5 categorías de FA

6. **Sección 4.4: Precondiciones (con BR-087)**
   - **Esfuerzo: 3-4h**
   - 4 categorías de precondiciones
   - Ejemplos con certificación OSHA

**🟢 PRIORIDAD MEDIA:**

7. **Sección 7.3: Matriz de Trazabilidad**
   - **Esfuerzo: 2-3h**
   - Tabla con 6 BR

**TOTAL SECCIONES 4-7:** 42-55 horas

### Diagramas PlantUML Identificados (2B)

1. Proceso Completo de Construcción (Sec. 4.1)

**TOTAL: 1 diagrama** en secciones 4-7
(Menos diagramas, más texto/ejemplos en estas secciones)

---

## RESUMEN PARTE 2B

### Conceptos Clave

**SECCIÓN 4: Construcción de UC**
- 7 pasos de construcción
- Paso 4 (Flujo Normal) es el núcleo
- Granularidad, alternancia, subpasos
- 5 categorías de flujos alternos

**SECCIÓN 5: Integración de BR**
- Un UC integra 3-7 BR típicamente
- 6 pasos de integración secuencial
- UC-04: 5 BR de 4 tipos diferentes

**SECCIÓN 6: Derivación de FR**
- 1 paso → 1+ FR
- Granularidad: acción atómica
- UC-07: 9 FR derivados

**SECCIÓN 7: Trazabilidad**
- Forward: Análisis de impacto (BR→Código)
- Backward: Justificación (Código→BR)
- Matriz completa en tabla

### Ejemplos Completos

**UC-04:** El más desarrollado de integración
- 12 pasos flujo normal
- 7 flujos alternos
- 5 BR integradas
- ~20 FR derivados

**UC-07:** El más desarrollado de derivación
- 9 FR con algoritmos completos
- RF-308: SMTP con reintentos
- Template HTML email

**BR-028:** El más trazado
- Forward tracing: cambio $500→$1000
- Backward tracing: justificación línea 145
- Estimación impacto: 4 horas

### Estadísticas Generales 2B

- **Líneas analizadas:** ~2,000 (33% de PARTE 2)
- **Ejemplos completos:** 3 principales (UC-04, UC-07, BR-028)
- **Flujos alternos:** 7 en UC-04, 5 en UC-07
- **FR derivados:** 9 de UC-07, ~20 de UC-04
- **Términos químicos:** 200+ ocurrencias estimadas
- **BR químicos:** 6 principales (028, 031, 087, 060, 046, 012)
- **Diagramas:** 1 PlantUML

---

## ESTIMACIÓN FINAL PARTE 2B

**Esfuerzo de reescritura estimado:**

| Prioridad | Secciones | Horas |
|-----------|-----------|-------|
| 🔴 Crítica | 5.3, 6.3, 7.1-7.2 | 26-33h |
| 🟡 Alta | 4.5, 4.6, 4.4 | 14-19h |
| 🟢 Media | 7.3 | 2-3h |
| **TOTAL** | **Secciones 4-7** | **42-55h** |

**Comparación con 2A:**
- PARTE 2A (Sec 1-3): 40-54h
- PARTE 2B (Sec 4-7): 42-55h
- Similar complejidad en ambas partes

---

## SIGUIENTE PASO

**PENDIENTE:**
- ✅ PARTE 2A analizada (Sec 1-3): 40-54h
- ✅ PARTE 2B analizada (Sec 4-7): 42-55h
- ⏳ PARTE 2C por analizar (Sec 8-11): ~1,600 líneas restantes

**PRÓXIMO ANÁLISIS:**
PARTE 2C incluirá:
- Sección 8: Casos Especiales
- Sección 9: Calidad y Validación
- Sección 10: Ejercicios Prácticos (4 ejercicios)
- Sección 11: Resumen y Siguientes Pasos

**Estimación preliminar 2C:** 20-30h (menos complejo que 2A/2B)

---

**Archivo guardado en:** `/tmp/analisis_parte2b_construccion_integracion.md`
**Fecha:** 2026-01-08

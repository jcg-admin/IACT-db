# PLANTILLAS PARTE 3 - TEMPLATES REUTILIZABLES

## ÍNDICE DE PLANTILLAS

```
1. Plantilla UC Estándar (Completa)
2. Plantilla UC Simplificada (Básica)
3. Plantilla System Event (Larman)
4. Plantilla System Operation (Larman)
5. Plantilla System Responsibility (Larman)
6. Checklist de Completitud UC
7. Matriz de Trazabilidad UC-BR
8. Plantilla de Consolidación UC
```

---

## 1. PLANTILLA UC ESTÁNDAR (COMPLETA)

```
═══════════════════════════════════════════════════════════════
UC-[XXX]: [NOMBRE DEL CASO DE USO]
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: UC-[XXX]
NOMBRE: [Nombre descriptivo del caso de uso]
ACTOR PRINCIPAL: [Actor que inicia el UC]
NIVEL: [Usuario (User Goal) | Sistema (System Goal)]
TIPO: [CRUD | Consulta | Transaccional | Reporte | Seguridad]
TÉCNICA: [CRUD | Larman - System Event | Larman - System Operation | 
          Larman - System Responsibility | UI-Driven | Stakeholder]
CRITICIDAD: [BAJA | MEDIA | ALTA | CRÍTICA]
═══════════════════════════════════════════════════════════════

───────────────────────────────────────────────────────────────
DESCRIPCIÓN
───────────────────────────────────────────────────────────────

[Descripción breve (2-3 oraciones) de qué hace este UC]

[Incluir contexto de negocio si es relevante]

[Explicar valor que aporta al usuario]

───────────────────────────────────────────────────────────────
ACTORES
───────────────────────────────────────────────────────────────

Primario:
  - [Actor Principal]: [Rol en el UC]

Secundarios:
  - [Actor Secundario 1]: [Rol en el UC]
  - [Actor Secundario 2]: [Rol en el UC]
  - [Sistema Externo]: [Si aplica]

───────────────────────────────────────────────────────────────
PRECONDICIONES
───────────────────────────────────────────────────────────────

PRE-1: [Condición que debe cumplirse antes de iniciar]
PRE-2: [Otra condición necesaria]
PRE-3: [Estado del sistema requerido]
PRE-4: [Permisos o autorizaciones necesarias]
PRE-5: [Datos que deben existir]

───────────────────────────────────────────────────────────────
POSTCONDICIONES
───────────────────────────────────────────────────────────────

** Éxito (Flujo Normal) **

POST-1: [Estado final del sistema si UC fue exitoso]
POST-2: [Datos persistidos en BD]
POST-3: [Notificaciones o eventos generados]
POST-4: [Cambios en estado de entidades]
POST-5: [Logs o auditoría registrada]

** Fracaso (Flujos Alternos) **

POST-F1: [Estado del sistema si UC falló]
POST-F2: [Qué NO cambió en BD (rollback)]
POST-F3: [Mensaje de error mostrado]
POST-F4: [Log de error registrado]

───────────────────────────────────────────────────────────────
FLUJO NORMAL (Happy Path)
───────────────────────────────────────────────────────────────

**Paso 1: [Título del paso]**
```
Acción: [Qué hace el actor]

Sistema responde:
  - [Acción del sistema 1]
  - [Acción del sistema 2]
  - [Validación si aplica]

Query/Lógica (si aplica):
  [SQL query o pseudocódigo]

Resultado esperado: [Qué se logra]
```

**Paso 2: [Título del paso]**
```
[Misma estructura que Paso 1]
```

**Paso 3: [Título del paso]**
```
[Misma estructura]
```

[Continuar con todos los pasos del flujo normal]

**Paso N: [Finalizar]**
```
Sistema:
  - [Muestra confirmación]
  - [Actualiza UI]
  - [Registra en auditoría]

UC termina exitosamente
```

───────────────────────────────────────────────────────────────
FLUJOS ALTERNOS (Excepciones y Variantes)
───────────────────────────────────────────────────────────────

**FA-1: [Nombre del flujo alterno]**
```
Trigger: [Qué desencadena este flujo]
         (En qué paso del flujo normal ocurre)

Paso FA-1.1: [Primer paso del flujo alterno]
  [Descripción de la acción]

Paso FA-1.2: [Siguiente paso]
  [Descripción]

Resultado:
  - UC retorna a Paso X del flujo normal, O
  - UC termina en fallo, O
  - UC termina en éxito (variante)
```

**FA-2: [Otro flujo alterno]**
```
[Misma estructura que FA-1]
```

[Continuar con todos los flujos alternos]

───────────────────────────────────────────────────────────────
REQUERIMIENTOS NO FUNCIONALES
───────────────────────────────────────────────────────────────

**NFR-[XXX].1: Performance**
```
• [Tiempo de respuesta esperado]
• [Throughput si aplica]
• [Límites de escalabilidad]
```

**NFR-[XXX].2: Seguridad**
```
• [Autenticación requerida]
• [Autorización específica]
• [Encriptación si aplica]
• [Protección contra ataques]
```

**NFR-[XXX].3: Usabilidad**
```
• [Experiencia de usuario esperada]
• [Accesibilidad (WCAG)]
• [Responsive design]
```

**NFR-[XXX].4: Confiabilidad**
```
• [Disponibilidad esperada]
• [Manejo de errores]
• [Recuperación ante fallos]
```

[Agregar más categorías según necesidad: Mantenibilidad, 
Portabilidad, etc.]

───────────────────────────────────────────────────────────────
REGLAS DE NEGOCIO APLICADAS
───────────────────────────────────────────────────────────────

```
BR-XXX: [Enunciado de la regla de negocio]
  Implementado en: [Dónde se implementa en el UC]
  Flujo: [Paso específico o FA]

BR-YYY: [Otra regla de negocio]
  Implementado en: [Ubicación]
  Validación: [Tipo de validación]

[Continuar con todas las BR aplicadas]
```

───────────────────────────────────────────────────────────────
MOCKUP ASCII (Interfaz Visual)
───────────────────────────────────────────────────────────────

```
[Dibujo ASCII de la interfaz principal]

Ejemplo:
┌─────────────────────────────────────────────────────────────┐
│ TÍTULO DE LA PÁGINA                             [Usuario ▼] │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ [Contenido principal]                                       │
│                                                             │
│ [Campos del formulario o tabla]                             │
│                                                             │
│ [Botones de acción]                                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘

[Agregar modals, mensajes de error, confirmaciones, etc.]
```

───────────────────────────────────────────────────────────────
NOTAS TÉCNICAS
───────────────────────────────────────────────────────────────

**Implementación sugerida:**
```
[Notas sobre cómo implementar aspectos técnicos complejos]
[Librerías recomendadas]
[Patrones de diseño aplicables]
```

**Optimizaciones:**
```
[Índices de BD necesarios]
[Estrategias de cache]
[Queries optimizadas]
```

**Consideraciones especiales:**
```
[Casos edge]
[Limitaciones conocidas]
[Deuda técnica]
```

───────────────────────────────────────────────────────────────
FIN UC-[XXX]
───────────────────────────────────────────────────────────────
```

---

## 2. PLANTILLA UC SIMPLIFICADA (BÁSICA)

**Para UC simples que no requieren tanta documentación:**

```
═══════════════════════════════════════════════════════════════
UC-[XXX]: [NOMBRE]
═══════════════════════════════════════════════════════════════

TIPO: [CRUD | Consulta | etc.]
ACTOR: [Actor principal]

───────────────────────────────────────────────────────────────
DESCRIPCIÓN
───────────────────────────────────────────────────────────────
[2-3 oraciones describiendo el UC]

───────────────────────────────────────────────────────────────
PRECONDICIONES
───────────────────────────────────────────────────────────────
- [Precondición 1]
- [Precondición 2]

───────────────────────────────────────────────────────────────
FLUJO NORMAL
───────────────────────────────────────────────────────────────
1. [Paso 1]
2. [Paso 2]
3. [Paso 3]
4. [Paso N]

───────────────────────────────────────────────────────────────
FLUJOS ALTERNOS
───────────────────────────────────────────────────────────────
**FA-1: [Nombre]**
- [Descripción breve]

**FA-2: [Nombre]**
- [Descripción breve]

───────────────────────────────────────────────────────────────
POSTCONDICIONES
───────────────────────────────────────────────────────────────
Éxito:
- [Resultado 1]
- [Resultado 2]

Fracaso:
- [Qué no cambió]

═══════════════════════════════════════════════════════════════
FIN UC-[XXX]
═══════════════════════════════════════════════════════════════
```

---

## 3. PLANTILLA SYSTEM EVENT (LARMAN)

**Para UC identificados por eventos del sistema:**

```
═══════════════════════════════════════════════════════════════
UC-[XXX]: [NOMBRE DEL EVENT]
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: UC-[XXX]
TÉCNICA: Larman - System Event
ACTOR: [Actor que genera el evento]
EVENT: [Nombre del event: consultarEstado, cancelarSolicitud, etc.]

───────────────────────────────────────────────────────────────
EVENT SPECIFICATION
───────────────────────────────────────────────────────────────

Event Name: [eventName]
Event Type: [External | Internal | Temporal]
Event Parameters:
  - param1: [Tipo] [Descripción]
  - param2: [Tipo] [Descripción]

Event Trigger:
  [Qué hace el actor para generar este event]
  Ejemplo: "Usuario hace clic en botón 'Consultar Estado'"

System Response:
  [Qué hace el sistema en respuesta]
  Ejemplo: "Sistema ejecuta query y muestra lista de solicitudes"

───────────────────────────────────────────────────────────────
DIAGRAMA DE SECUENCIA (PlantUML)
───────────────────────────────────────────────────────────────

```plantuml
@startuml
actor [Actor] as actor
participant "Sistema" as sistema

actor -> sistema : event([params])
activate sistema

sistema -> sistema : validarParams()
sistema -> sistema : procesarEvento()

sistema --> actor : respuesta
deactivate sistema
@enduml
```

───────────────────────────────────────────────────────────────
FLUJO NORMAL (DETALLADO)
───────────────────────────────────────────────────────────────

[Seguir estructura de plantilla estándar]

**Paso 1: Event recibido**
```
Event: [eventName]([params])

Sistema:
  - Captura event
  - Valida params
  - Inicia procesamiento
```

[Continuar con pasos detallados]

───────────────────────────────────────────────────────────────
OPERATION CONTRACTS (Opcional)
───────────────────────────────────────────────────────────────

**Contract: [eventName]**
```
Operation: [eventName]([param1]: Type, [param2]: Type)
Preconditions:
  - [Pre-1]
  - [Pre-2]
Postconditions:
  - Instance of [Entity] created (if applies)
  - [Entity].attribute set to [value]
  - Association [X]-[Y] formed
```

═══════════════════════════════════════════════════════════════
FIN UC-[XXX] (System Event)
═══════════════════════════════════════════════════════════════
```

---

## 4. PLANTILLA SYSTEM OPERATION (LARMAN)

**Para UC identificados por operaciones del sistema:**

```
═══════════════════════════════════════════════════════════════
UC-[XXX]: [NOMBRE DE LA OPERATION]
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: UC-[XXX]
TÉCNICA: Larman - System Operation
OPERATION: [operationName]

───────────────────────────────────────────────────────────────
OPERATION SPECIFICATION
───────────────────────────────────────────────────────────────

Operation Signature:
  [operationName]([param1]: Type, [param2]: Type): ReturnType

Purpose:
  [Qué logra esta operación]

Responsibilities:
  - [Responsabilidad 1: calcular, validar, persistir, etc.]
  - [Responsabilidad 2]
  - [Responsabilidad 3]

Side Effects:
  - [Cambios en BD]
  - [Eventos generados]
  - [Notificaciones enviadas]

───────────────────────────────────────────────────────────────
SYSTEM SEQUENCE DIAGRAM
───────────────────────────────────────────────────────────────

```
Actor → Sistema : operationName(params)
Sistema → Sistema : validateParams()
Sistema → Sistema : executeLogic()
Sistema → Database : persist(data)
Sistema → Actor : result
```

───────────────────────────────────────────────────────────────
ALGORITHM / BUSINESS LOGIC
───────────────────────────────────────────────────────────────

```pseudocode
function operationName(param1, param2):
    // Step 1: Validate
    IF NOT valid(param1):
        THROW ValidationError
    
    // Step 2: Business Logic
    result = calculate(param1, param2)
    
    // Step 3: Persist
    database.save(result)
    
    // Step 4: Notify
    notify_stakeholders(result)
    
    RETURN result
```

───────────────────────────────────────────────────────────────
FLUJO DETALLADO
───────────────────────────────────────────────────────────────

[Seguir estructura de plantilla estándar]

═══════════════════════════════════════════════════════════════
FIN UC-[XXX] (System Operation)
═══════════════════════════════════════════════════════════════
```

---

## 5. PLANTILLA SYSTEM RESPONSIBILITY (LARMAN)

**Para UC de responsabilidades del sistema (típicamente seguridad, auditoría):**

```
═══════════════════════════════════════════════════════════════
UC-[XXX]: [RESPONSABILIDAD DEL SISTEMA]
═══════════════════════════════════════════════════════════════

IDENTIFICADOR: UC-[XXX]
TÉCNICA: Larman - System Responsibility
CATEGORÍA: [Security | Audit | Monitoring | Backup | etc.]
CRITICIDAD: [Típicamente ALTA o CRÍTICA]

───────────────────────────────────────────────────────────────
RESPONSIBILITY SPECIFICATION
───────────────────────────────────────────────────────────────

Responsibility:
  [Enunciado claro de la responsabilidad]
  Ejemplo: "El sistema DEBE prevenir acceso no autorizado"

Obligation:
  [Por qué el sistema tiene esta responsabilidad]
  Ejemplo: "Requerimiento regulatorio GDPR"

Scope:
  [Alcance de la responsabilidad]
  Ejemplo: "Aplica a TODOS los UC del sistema"

Implementation:
  [Cómo se implementa generalmente]
  Ejemplo: "JWT tokens, RBAC, rate limiting"

───────────────────────────────────────────────────────────────
SECURITY REQUIREMENTS (si aplica)
───────────────────────────────────────────────────────────────

**Authentication:**
- [Método de autenticación]
- [Mecanismos de verificación]

**Authorization:**
- [Roles y permisos]
- [Control de acceso]

**Data Protection:**
- [Encriptación]
- [Hashing de passwords]

**Attack Prevention:**
- [Rate limiting]
- [CSRF protection]
- [SQL injection prevention]
- [XSS prevention]

───────────────────────────────────────────────────────────────
AUDIT REQUIREMENTS (si aplica)
───────────────────────────────────────────────────────────────

**What to Log:**
- [Eventos a registrar]
- [Datos a capturar]

**Log Format:**
- [Estructura del log]
- [Campos obligatorios]

**Retention:**
- [Tiempo de retención]
- [Política de purga]

**Compliance:**
- [Regulaciones aplicables]
- [Estándares a cumplir]

───────────────────────────────────────────────────────────────
FLUJO DETALLADO
───────────────────────────────────────────────────────────────

[Estructura estándar de flujo normal + alternos]

═══════════════════════════════════════════════════════════════
FIN UC-[XXX] (System Responsibility)
═══════════════════════════════════════════════════════════════
```

---

## 6. CHECKLIST DE COMPLETITUD UC

**Usar esta checklist para verificar que cada UC está completo:**

```
═══════════════════════════════════════════════════════════════
CHECKLIST: UC-[XXX] [NOMBRE]
═══════════════════════════════════════════════════════════════

SECCIÓN 1: IDENTIFICACIÓN
─────────────────────────────────────────────────────────────
☐ UC tiene identificador único (UC-XXX)
☐ Nombre es descriptivo y empieza con verbo
☐ Actor principal está identificado
☐ Nivel está especificado (Usuario/Sistema)
☐ Tipo está especificado (CRUD/Consulta/etc.)
☐ Técnica de identificación está documentada

SECCIÓN 2: DESCRIPCIÓN
─────────────────────────────────────────────────────────────
☐ Descripción es clara y concisa (2-4 oraciones)
☐ Propósito del UC está explicado
☐ Valor de negocio está mencionado
☐ Contexto está provisto si es necesario

SECCIÓN 3: ACTORES
─────────────────────────────────────────────────────────────
☐ Actor primario está identificado
☐ Actores secundarios listados (si aplican)
☐ Sistemas externos listados (si aplican)
☐ Rol de cada actor está descrito

SECCIÓN 4: PRECONDICIONES
─────────────────────────────────────────────────────────────
☐ Al menos 2 precondiciones listadas
☐ Precondiciones son verificables
☐ Estado del sistema está especificado
☐ Permisos necesarios están mencionados
☐ Datos requeridos están identificados

SECCIÓN 5: POSTCONDICIONES
─────────────────────────────────────────────────────────────
☐ Postcondiciones de éxito están listadas
☐ Postcondiciones de fallo están listadas
☐ Cambios en BD están documentados
☐ Eventos/Notificaciones están mencionados
☐ Estado final del sistema está claro

SECCIÓN 6: FLUJO NORMAL
─────────────────────────────────────────────────────────────
☐ Flujo tiene al menos 4 pasos
☐ Cada paso tiene título descriptivo
☐ Responsabilidad está clara (Actor vs Sistema)
☐ Validaciones están incluidas
☐ Queries/Lógica están documentadas
☐ Flujo termina con postcondición clara

SECCIÓN 7: FLUJOS ALTERNOS
─────────────────────────────────────────────────────────────
☐ Al menos 2 flujos alternos están documentados
☐ Trigger de cada FA está especificado
☐ Pasos del FA están numerados (FA-X.1, FA-X.2)
☐ Punto de retorno está especificado
☐ Casos de error están cubiertos
☐ Validaciones fallidas tienen FA

SECCIÓN 8: REQUERIMIENTOS NO FUNCIONALES
─────────────────────────────────────────────────────────────
☐ Al menos 3 categorías NFR están documentadas
☐ NFR de Performance están especificados
☐ NFR de Seguridad están especificados
☐ NFR son medibles y verificables
☐ NFR tienen valores objetivo específicos

SECCIÓN 9: REGLAS DE NEGOCIO
─────────────────────────────────────────────────────────────
☐ Al menos 2 BR están referenciadas
☐ Cada BR tiene identificador (BR-XXX)
☐ Ubicación de implementación está especificada
☐ Trazabilidad BR → UC está clara

SECCIÓN 10: MOCKUPS
─────────────────────────────────────────────────────────────
☐ Al menos 1 mockup ASCII está incluido
☐ Interfaz principal está dibujada
☐ Mensajes de error están mostrados
☐ Confirmaciones están ilustradas
☐ Mockups son comprensibles

SECCIÓN 11: NOTAS TÉCNICAS
─────────────────────────────────────────────────────────────
☐ Notas de implementación están incluidas
☐ Optimizaciones están mencionadas
☐ Índices de BD están especificados
☐ Consideraciones especiales están documentadas

CALIDAD GENERAL
─────────────────────────────────────────────────────────────
☐ UC es comprensible sin contexto externo
☐ Longitud apropiada (200-800 líneas)
☐ Sin ambigüedades
☐ Ortografía y gramática correctas
☐ Formato consistente

═══════════════════════════════════════════════════════════════
RESULTADO:
☐☐☐☐☐ [XX/60 checks completos]

EVALUACIÓN:
  55-60: ⭐⭐⭐ Excelente, listo para implementación
  45-54: ⭐⭐  Bueno, revisar secciones incompletas
  35-44: ⭐    Aceptable, completar más detalles
  <35:   ❌    Insuficiente, reescribir UC

═══════════════════════════════════════════════════════════════
```

---

## 7. MATRIZ DE TRAZABILIDAD UC-BR

**Plantilla para documentar trazabilidad entre Business Rules y UC:**

```
═══════════════════════════════════════════════════════════════
MATRIZ DE TRAZABILIDAD: BUSINESS RULES → USE CASES
═══════════════════════════════════════════════════════════════

Proyecto: [Nombre del proyecto]
Fecha: [YYYY-MM-DD]
Versión: [X.X]

┌───────┬────────────────────────┬─────────────┬──────────────┐
│ BR ID │ Enunciado BR           │ UC que      │ Paso/FA      │
│       │                        │ Implementan │              │
├───────┼────────────────────────┼─────────────┼──────────────┤
│BR-001 │[Enunciado de la regla] │ UC-40       │ Paso 5       │
│       │                        │ UC-41       │ Paso 3       │
│       │                        │             │              │
├───────┼────────────────────────┼─────────────┼──────────────┤
│BR-002 │[Otra regla]            │ UC-42       │ FA-2         │
│       │                        │             │              │
├───────┼────────────────────────┼─────────────┼──────────────┤
│BR-003 │[Otra regla más]        │ UC-40       │ Paso 6       │
│       │                        │ UC-43       │ Paso 4, FA-1 │
│       │                        │ UC-44       │ FA-3         │
└───────┴────────────────────────┴─────────────┴──────────────┘

ESTADÍSTICAS:
────────────────────────────────────────────────────────────
Total BR documentadas:          [XX]
Total UC implementando BR:      [YY]
BR sin UC (huérfanas):          [ZZ] ⚠️
UC sin BR (sin justificación):  [WW] ⚠️

COVERAGE:
────────────────────────────────────────────────────────────
BR con al menos 1 UC:   [XX/Total] ([XX%])
Objetivo:               100%

TOP BR MÁS REFERENCIADAS:
────────────────────────────────────────────────────────────
1. BR-015: [Enunciado] → [X] UC
2. BR-022: [Enunciado] → [Y] UC
3. BR-008: [Enunciado] → [Z] UC

BR SIN IMPLEMENTAR (Requieren atención):
────────────────────────────────────────────────────────────
⚠️  BR-005: [Enunciado] → No implementada en ningún UC
⚠️  BR-018: [Enunciado] → No implementada en ningún UC

═══════════════════════════════════════════════════════════════
```

---

## 8. PLANTILLA DE CONSOLIDACIÓN UC

**Para documentar proceso de consolidación de UC duplicados/similares:**

```
═══════════════════════════════════════════════════════════════
CONSOLIDACIÓN DE CASOS DE USO
═══════════════════════════════════════════════════════════════

Proyecto: [Nombre]
Fecha: [YYYY-MM-DD]
Analista: [Nombre]

CASO DE CONSOLIDACIÓN #[X]
───────────────────────────────────────────────────────────────

UC CANDIDATOS A CONSOLIDAR:
  • UC-[X]: [Nombre UC 1]
  • UC-[Y]: [Nombre UC 2]
  • UC-[Z]: [Nombre UC 3]

SIMILITUDES IDENTIFICADAS:
────────────────────────────────────────────────────────────
  ☑ Mismo actor principal
  ☑ Mismo objetivo de negocio
  ☑ Flujos muy similares (> 70% overlap)
  ☐ Misma entidad principal
  ☐ Precondiciones idénticas
  ☐ Postcondiciones equivalentes

DIFERENCIAS RELEVANTES:
────────────────────────────────────────────────────────────
  • UC-[X]: [Diferencia específica]
  • UC-[Y]: [Diferencia específica]
  • UC-[Z]: [Diferencia específica]

DECISIÓN:
────────────────────────────────────────────────────────────
  ☑ CONSOLIDAR en UC-[Nuevo ID]: [Nombre Consolidado]
  ☐ MANTENER SEPARADOS (justificación: [razón])

UC CONSOLIDADO RESULTANTE:
───────────────────────────────────────────────────────────────

Identificador: UC-[Nuevo ID]
Nombre: [Nombre consolidado que cubre todos los casos]

Mapeo:
  UC-[X] → Flujo Normal + FA-1
  UC-[Y] → FA-2
  UC-[Z] → FA-3

Estructura:
  • Flujo Normal: [De cuál UC se deriva principalmente]
  • FA-1: [Mapeo a UC-X]
  • FA-2: [Mapeo a UC-Y]
  • FA-3: [Mapeo a UC-Z]

IMPACTO:
───────────────────────────────────────────────────────────────
UC Antes:       [X] UC separados
UC Después:     [1] UC consolidado
Reducción:      [X-1] UC eliminados
Complejidad:    [Aumentó/Disminuyó/Igual]

JUSTIFICACIÓN:
───────────────────────────────────────────────────────────────
[Explicar por qué consolidar es mejor que mantener separados]
[Beneficios: menor redundancia, mantenibilidad, claridad]
[Costos: UC más complejo, más FAs]

TRAZABILIDAD:
───────────────────────────────────────────────────────────────
UC-[X] (eliminado) → UC-[Nuevo] (FA-1)
UC-[Y] (eliminado) → UC-[Nuevo] (FA-2)
UC-[Z] (eliminado) → UC-[Nuevo] (FA-3)

═══════════════════════════════════════════════════════════════
```

---

## GUÍA DE USO DE PLANTILLAS

### ¿Cuándo usar cada plantilla?

```
┌─────────────────────┬──────────────────────────────────────┐
│ Plantilla           │ Usar cuando...                       │
├─────────────────────┼──────────────────────────────────────┤
│ UC Estándar         │ • UC de complejidad media-alta      │
│ (Completa)          │ • UC crítico para el negocio        │
│                     │ • Requiere documentación detallada   │
├─────────────────────┼──────────────────────────────────────┤
│ UC Simplificada     │ • UC muy simple (< 5 pasos)         │
│                     │ • CRUD básico sin lógica compleja    │
│                     │ • Documentación rápida necesaria     │
├─────────────────────┼──────────────────────────────────────┤
│ System Event        │ • UC identificado por evento externo │
│                     │ • Enfoque Larman aplicable           │
│                     │ • Necesitas diagramas de secuencia   │
├─────────────────────┼──────────────────────────────────────┤
│ System Operation    │ • UC es una operación compleja       │
│                     │ • Requiere especificación de lógica  │
│                     │ • Algoritmos o cálculos involucrados │
├─────────────────────┼──────────────────────────────────────┤
│ System              │ • UC de seguridad, auditoría, backup │
│ Responsibility      │ • Responsabilidades no funcionales   │
│                     │ • Requisitos regulatorios            │
├─────────────────────┼──────────────────────────────────────┤
│ Checklist           │ • Revisar completitud de UC          │
│                     │ • QA de documentación                │
│                     │ • Antes de pasar a desarrollo        │
├─────────────────────┼──────────────────────────────────────┤
│ Matriz              │ • Verificar trazabilidad             │
│ Trazabilidad        │ • Encontrar BR no implementadas      │
│                     │ • Análisis de impacto de cambios     │
├─────────────────────┼──────────────────────────────────────┤
│ Consolidación       │ • Encontraste UC duplicados          │
│                     │ • Quieres reducir cantidad de UC     │
│                     │ • Optimización post-identificación   │
└─────────────────────┴──────────────────────────────────────┘
```

### Tips de Uso

```
✓ Adapta las plantillas a tu proyecto (no uses TODO)
✓ Mantén consistencia en formato entre UC
✓ Usa plantilla simplificada para UC triviales
✓ Usa plantilla completa para UC complejos/críticos
✓ Llena checklist al terminar cada UC
✓ Actualiza matriz de trazabilidad regularmente
✓ Documenta decisiones de consolidación
```

---

**FIN DE PLANTILLAS PARTE 3**

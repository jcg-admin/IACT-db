---
name: ba-requirements-analysis
description: "Use when modeling and specifying requirements in BABOK. ba:requirements-analysis — model requirements with use cases and user stories, apply INVEST, verify and validate requirements, define design options."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["requirements modeling", "requirements specification BABOK", "use case model", "BABOK analysis", "requirements design"]
updated_at: 2026-04-17 00:00:00
---

# /ba-requirements-analysis — BABOK: Requirements Analysis & Design Definition

> *"The purpose of requirements analysis is not to produce a perfect document — it is to create a shared understanding between business and technology of what needs to be built and why. The document is the artifact; the understanding is the goal."*

Ejecuta la Knowledge Area **Requirements Analysis & Design Definition** de BABOK v3. Modela y especifica los requisitos usando use cases y user stories, aplica criterios INVEST, verifica y valida los requisitos, y define las opciones de diseño de la solución.

**THYROX Stage:** Stage 7 DESIGN/SPECIFY.

**Outputs clave:** Specified Requirements · Use Case Model · User Stories · Design Options.

---

## KAs relacionadas — contexto de uso

| KA | Intensidad relativa | Relación |
|----|-------------------|---------|
| **Requirements Analysis & Design Definition** | **Alta** (esta KA) | Modelado, especificación y verificación de requisitos |
| Elicitation & Collaboration | Alta | Provee las necesidades que esta KA convierte en requisitos especificados |
| Strategy Analysis | Alta | Provee el gap analysis y capacidades requeridas como punto de partida |
| Requirements Life Cycle | Alta | Consume los requisitos especificados para gestionar su trazabilidad y cambios |
| Solution Evaluation | Baja | Verifica a posteriori si los requisitos especificados fueron implementados correctamente |

---

## Pre-condición

Requiere necesidades articuladas de al menos una de:
- `{wp}/ba-elicitation.md` con stakeholder needs confirmados
- `{wp}/ba-strategy.md` con gap analysis y capacidades requeridas

---

## Cuándo usar este paso

- Cuando las necesidades del negocio están articuladas y deben convertirse en requisitos especificados
- Al modelar procesos de negocio y casos de uso del sistema
- Cuando se necesita verificar que los requisitos son completos, consistentes y no ambiguos

## Cuándo NO usar este paso

- Si las necesidades del negocio no están claras — ir primero a `ba:elicitation` o `ba:strategy`
- Si el trabajo es gestionar requisitos ya especificados — ir a `ba:requirements-lifecycle`

---

## Actividades

### 1. Modelado de requisitos

**Use Cases (para especificar funcionalidad del sistema):**

| Sección | Contenido |
|---------|-----------|
| **Nombre** | Verbo + objeto: "Procesar Solicitud de Crédito" |
| **Actor principal** | Quién inicia el UC |
| **Trigger** | Qué evento inicia el UC |
| **Precondiciones** | Estado del sistema antes de que el UC ejecute |
| **Flujo principal** | Pasos numerados del escenario nominal |
| **Flujos alternativos** | Variaciones del flujo principal que también son exitosas |
| **Flujos de excepción** | Qué pasa cuando algo falla o sale del flujo normal |
| **Postcondiciones** | Estado del sistema después del UC exitoso |
| **Reglas de negocio** | Reglas que aplican en el contexto de este UC |

**User Stories (para contextos ágiles):**

```
Como [rol del usuario],
quiero [capacidad / feature],
para [beneficio de negocio / objetivo].
```

**Criterios de aceptación (Given/When/Then):**

```
Dado [contexto / precondición],
cuando [acción del usuario],
entonces [resultado esperado del sistema].
```

### 2. INVEST criteria para User Stories

Verificar cada User Story contra los criterios INVEST:

| Criterio | Pregunta | Señal de problema |
|---------|---------|-----------------|
| **I — Independent** | ¿Puede implementarse sin depender de otra story? | Muchas stories que deben hacerse juntas |
| **N — Negotiable** | ¿El detalle de implementación es flexible? | Story que especifica tecnología o arquitectura |
| **V — Valuable** | ¿Entrega valor al usuario al completarse? | Story técnica sin valor de negocio visible |
| **E — Estimable** | ¿El equipo puede estimar el esfuerzo? | Story con demasiada ambigüedad o tamaño |
| **S — Small** | ¿Puede completarse en 1-3 días? | Story que tarda más de un sprint |
| **T — Testable** | ¿Puede verificarse si está completa? | Story sin criterios de aceptación |

### 3. Verificación vs Validación

Distinción fundamental en BABOK:

| Dimensión | Verificación | Validación |
|-----------|-------------|-----------|
| **Pregunta** | ¿El requisito está bien escrito? | ¿El requisito resuelve la necesidad real? |
| **Criterio** | Cumple estándares de calidad del documento | Cumple la necesidad del stakeholder |
| **Quién lo hace** | BA + revisores técnicos | Stakeholders del negocio |
| **Cuándo** | Al especificar el requisito | Al validar con los stakeholders |
| **Técnica** | Walkthrough · Inspección · Checklist IEEE 829 | Prototipo · UAT · Walkthrough con usuario |

**Checklist de verificación (calidad del requisito individual):**

| Criterio | Pregunta |
|---------|---------|
| **Completitud** | ¿Describe completamente la necesidad? ¿No hay información faltante? |
| **Consistencia** | ¿No contradice otros requisitos? |
| **No ambigüedad** | ¿Solo puede interpretarse de una forma? |
| **Verificabilidad** | ¿Puede probarse que fue implementado? |
| **Factibilidad** | ¿Es técnica y operacionalmente realizable? |
| **Trazabilidad** | ¿Puede rastrearse a una necesidad de negocio? |

### 4. Priorización con MoSCoW

Clasificar requisitos por prioridad con los stakeholders:

| Categoría | Criterio | Regla de asignación |
|-----------|---------|---------------------|
| **Must Have** | Sin esto el sistema no puede operar | ≤ 60% de los requisitos; si más, el scope es demasiado grande |
| **Should Have** | Importante pero hay workaround aceptable | 20-30% de los requisitos |
| **Could Have** | Deseable si hay tiempo y presupuesto | 10-20% de los requisitos |
| **Won't Have** | Fuera del alcance de esta versión | Documentar para versiones futuras |

### 5. Definición de opciones de diseño

El BA define opciones de diseño de alto nivel (qué, no cómo):

| Opción | Descripción | Ventajas | Desventajas | Restricciones |
|--------|-------------|---------|------------|---------------|
| Opción A | [descripción de la solución] | [lista] | [lista] | [restricciones que aplican] |
| Opción B | [descripción alternativa] | [lista] | [lista] | [restricciones] |

> **Nota BABOK:** El BA define opciones de diseño de alto nivel. El diseño detallado (arquitectura, tecnologías específicas, estructuras de datos) es responsabilidad del equipo técnico, no del BA.

---

## Routing Table

| Situación | Próxima KA recomendada |
|-----------|----------------------|
| Los requisitos especificados necesitan trazabilidad y gestión de cambios | `ba:requirements-lifecycle` |
| Se necesita información adicional para completar la especificación | `ba:elicitation` |
| La solución fue implementada y se necesita evaluar el valor entregado | `ba:solution-evaluation` |
| Los requisitos especificados requieren análisis estratégico adicional | `ba:strategy` |
| Hay una brecha en la especificación identificada en revisión | Nueva iteración de `ba:requirements-analysis` |

---

## Artefacto esperado

`{wp}/ba-requirements-analysis.md`

usar template: [ba-requirements-analysis-template.md](./assets/ba-requirements-analysis-template.md)

---

## Red Flags — señales de Requirements Analysis mal ejecutado

- **User Stories que especifican la implementación** — "Como usuario quiero que el sistema use PostgreSQL con índices en la columna email" es un requisito técnico disfrazado de story; el BA debe capturar la necesidad de negocio, no la implementación
- **Must Have > 60% del total** — si más del 60% es Must Have, el scope es demasiado grande o el equipo no está priorizando realmente
- **Criterios de aceptación ausentes** — una User Story sin criterios de aceptación es irrechazable por definición; el equipo no sabe cuándo terminó
- **Verificación sin validación** — requisitos que pasan el checklist técnico (verificados) pero que los stakeholders no reconocen como sus necesidades (no validados) generan un sistema formalmente correcto pero inútil
- **Use Cases sin flujos de excepción** — modelar solo el happy path asegura que los casos de error no se especifican y se implementan incorrectamente

---

## Criterio de completitud

**Requirements Analysis está completo cuando:**
1. Todos los requisitos tienen ID único y criterios de aceptación verificables
2. Use Case Model o User Stories cubren el 100% de las capacidades del gap analysis de Strategy
3. Verificación completada: todos los requisitos son completos, consistentes, no ambiguos, verificables y factibles
4. Validación completada: stakeholders clave confirmaron que los requisitos representan sus necesidades
5. Priorización MoSCoW documentada con Must Have ≤ 60% del total

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: ba:requirements-analysis
flow: ba
ba_ka: requirements_analysis_design
```

**Al COMPLETAR:**
```yaml
methodology_step: ba:requirements-analysis  # completado — requisitos especificados y validados
flow: ba
ba_ka: requirements_analysis_design
```

## Siguiente paso

Usar la **Routing Table** — la transición más frecuente es hacia `ba:requirements-lifecycle` para gestionar los requisitos especificados, o hacia `ba:solution-evaluation` cuando la solución ya está implementada.

---

## Reference Files

### Assets
- [ba-requirements-analysis-template.md](./assets/ba-requirements-analysis-template.md) — Template completo: Use Case Model con UC-NNN detallado (flujo principal/alternativo/excepción), User Stories con Given/When/Then e INVEST check, verificación de 6 criterios, validación con stakeholders, MoSCoW con regla ≤60% Must Have, opciones de diseño alto nivel, routing

### References
- [analysis-techniques.md](./references/analysis-techniques.md) — Decision tables (estructura, verificación de completitud), decision trees (cuándo preferir sobre tabla), BPMN básico (elementos, swimlanes, VSM), modelado de datos (ERD crow's foot, data dictionary, reglas de negocio), checklist de verificación de modelos

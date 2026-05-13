---
name: rm-elicitation
description: "Use when starting requirements gathering or when stakeholder needs are unknown. rm:elicitation — plan and conduct requirements elicitation using structured techniques, confirm results with stakeholders."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["RM elicitation", "requirements discovery", "requirements collection RM", "requirements lifecycle", "RM cycle"]
updated_at: 2026-04-17 00:00:00
---

# /rm-elicitation — Requirements Management: Elicitation

> *"You cannot specify what you don't understand. Elicitation is not asking what people want — it's discovering what they need."*

Ejecuta el paso **Elicitation** del ciclo de Requirements Management. Recopila necesidades de stakeholders usando técnicas estructuradas y confirma los resultados antes de avanzar al análisis.

**THYROX Stage:** Stage 1 DISCOVER / Stage 3 DIAGNOSE.

---

## Foco en el ciclo RM

| Paso | Intensidad relativa | Rol en el ciclo |
|------|-------------------|----------------|
| **Elicitation** | **Alta** (este paso) | Recopilación de necesidades de stakeholders — punto de entrada |
| Analysis | Media | Consume los resultados de elicitación para evaluar calidad y prioridad |
| Specification | Baja | Formaliza los requisitos analizados — requiere elicitación completa |
| Validation | Baja | Confirma que la especificación resuelve las necesidades elicitadas |
| Management | Baja | Gestiona cambios que pueden requerir re-elicitar nuevas necesidades |

---

## Pre-condición

- Work package activo con contexto inicial del problema o sistema a analizar.
- Stakeholders identificados (al menos una lista inicial — se puede refinar durante la elicitación).
- Para re-elicitaciones: `{wp}/rm-analysis.md` con gaps identificados que justifican volver a elicitar.

---

## Cuándo usar este paso

- Al inicio del ciclo RM, antes de cualquier análisis o especificación
- Cuando el análisis identificó gaps en los requisitos (`on_gaps_found` → volver a este paso)
- Cuando stakeholders clave no fueron incluidos en elicitaciones previas
- Cuando el scope del proyecto cambia y hay nuevas necesidades por descubrir

## Cuándo NO usar este paso

- Si los requisitos ya están completamente documentados y validados — avanzar a `rm:analysis`
- Si la elicitación previa fue exhaustiva y no hay nuevas fuentes de información
- Sin stakeholders disponibles — programar primero las sesiones antes de iniciar

---

## Actividades

### 1. Planificar la elicitación

Antes de cualquier sesión, definir:

| Decisión | Contenido |
|----------|-----------|
| **Stakeholders a incluir** | Lista por rol/área con nivel de participación esperado |
| **Técnicas a usar** | Selección justificada (ver tabla de técnicas) |
| **Calendario de sesiones** | Fechas, duración, modalidad (presencial/remota) |
| **Preguntas guía** | Lista de temas y preguntas abiertas por sesión |
| **Materiales de apoyo** | Documentos existentes, prototipos, flujos de proceso actuales |

### 2. Técnicas de elicitación — selección según contexto

| Técnica | Cuándo usar | Ventajas | Limitaciones |
|---------|-------------|----------|--------------|
| **Entrevistas estructuradas** | Stakeholders clave con alta influencia; contexto complejo | Alto detalle; explora en profundidad | Costoso en tiempo; sesgo del entrevistador |
| **Entrevistas semi-estructuradas** | Stakeholders con conocimiento tácito del proceso | Flexible; permite exploración de temas emergentes | Menos comparable entre entrevistados |
| **Workshops JAD** (Joint Application Development) | Múltiples stakeholders; necesidad de consenso; proyectos grandes | Consenso rápido; identifica conflictos en tiempo real | Requiere facilitador experimentado; dominancia de voces fuertes |
| **Observación directa (Shadowing)** | Procesos operacionales; comportamiento real vs declarado | Captura comportamiento real (no lo que dicen que hacen) | Efecto Hawthorne; no captura casos excepcionales |
| **Prototipos** (low-fi / hi-fi) | Validar comprensión de req visuales/funcionales; stakeholders no técnicos | Reduce ambigüedad; feedback temprano | Puede anclar expectativas; costo de construcción |
| **Encuestas / Cuestionarios** | Base amplia de stakeholders; validar hipótesis; datos cuantitativos | Alcance amplio; datos estandarizados | Baja tasa de respuesta; sin profundidad; sesgo de diseño |
| **Análisis de documentos** | Sistemas existentes; regulaciones; contratos; procesos documentados | Baseline objetivo; sin bias de stakeholder | Documentación desactualizada; solo captura estado formal |

> **Criterio de combinación:** Usar siempre al menos una técnica directa (entrevista/shadowing) con una de validación (encuesta/workshop/prototipo). No depender de una sola técnica — el sesgo de una técnica se compensa con otra.

### 3. Conducir la elicitación

**Para entrevistas:**
- Preguntas abiertas primero: *"¿Qué hace el sistema actualmente?"*, *"¿Qué le falta?"*, *"¿Qué le causa más frustración?"*
- Preguntas de profundización: *"¿Puede dar un ejemplo concreto?"*, *"¿Con qué frecuencia ocurre?"*
- Evitar preguntas que implican la solución: *"¿Le gustaría que el sistema hiciera X?"* → sesgo de confirmación

**Para workshops JAD:**
- Facilitador neutral (no el analista que tiene hipótesis previas)
- Técnica de votación anónima para evitar dominancia
- Documentar desacuerdos — son tan valiosos como los consensos

**Para observación:**
- Observar sin intervenir en las primeras sesiones
- Documentar: qué hace, cómo lo hace, cuándo, con qué herramientas, qué errores comete
- Preguntar al final, no durante — la observación primero

### 4. Confirmar resultados con stakeholders

Antes de avanzar al análisis, confirmar que lo recopilado es correcto:

| Técnica de confirmación | Cuándo usar |
|------------------------|-------------|
| **Member checking** | Devolver el resumen escrito al stakeholder para validación |
| **Walkthrough de resultados** | Presentar los hallazgos en reunión breve y recoger feedback |
| **Prototipo de confirmación** | Si la elicitación fue sobre requisitos funcionales visuales |

> Sin confirmación, los resultados de la elicitación son la interpretación del analista, no los requisitos del stakeholder. Este paso es obligatorio.

---

## Artefacto esperado

`{wp}/rm-elicitation.md`

usar template: [elicitation-report-template.md](./assets/elicitation-report-template.md)

---

## Red Flags — señales de elicitación mal ejecutada

- **Solo una fuente de información** — un único stakeholder o una única técnica produce requisitos sesgados
- **Requisitos expresados como soluciones** — *"necesitamos un dashboard"* es solución; la necesidad es *"ver el estado del proceso en tiempo real"*
- **Sin confirmación con stakeholders** — los hallazgos son la interpretación del analista, no los requisitos del cliente
- **Stakeholders de alto impacto no incluidos** — descubrir stakeholders clave en la fase de validación genera re-trabajo masivo
- **Shadowing/observación sin preguntas post-sesión** — la observación sin contexto captura comportamiento pero pierde el "¿por qué?"
- **Workshop sin facilitador neutral** — si el analista facilita y tiene hipótesis previas, confirmará sus hipótesis en lugar de descubrir las necesidades reales
- **Requisitos no confirmados antes de analizar** — analizar requisitos que el stakeholder no reconoce como suyos desperdicia el trabajo de análisis

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: rm:elicitation
flow: rm
```

**Al COMPLETAR** (hallazgos confirmados con stakeholders):
```yaml
methodology_step: rm:elicitation  # completado → listo para rm:analysis
flow: rm
```

## Siguiente paso

Cuando los hallazgos están confirmados con stakeholders → `rm:analysis`

Si en `rm:analysis` se identifican gaps → retornar a `rm:elicitation` con lista específica de gaps a cubrir.

---

## Limitaciones

- La elicitación no puede capturar requisitos que los stakeholders no conocen aún — las necesidades latentes emergen durante el diseño o las pruebas; planificar validaciones iterativas
- El sesgo cultural puede afectar la elicitación en entornos multinacionales — adaptar las técnicas al contexto
- La observación directa solo es posible para procesos existentes; para sistemas nuevos, usar prototipos o workshops de visión

---

## Reference Files

### Assets
- [elicitation-report-template.md](./assets/elicitation-report-template.md) — Template del reporte de elicitación: plan, hallazgos por sesión, requisitos candidatos, confirmación con stakeholders

### References
- [elicitation-techniques.md](./references/elicitation-techniques.md) — 7 técnicas de elicitación con árbol de decisión, protocolos, ventajas/limitaciones y patrones de combinación

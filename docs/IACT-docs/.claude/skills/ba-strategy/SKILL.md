---
name: ba-strategy
description: "Use when analyzing the business problem and defining the change strategy in BABOK. ba:strategy — analyze current state, define future state, assess risks of the change, identify gaps, recommend solution approach."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["business need analysis", "current state analysis", "future state definition", "BABOK strategy", "change strategy BA"]
updated_at: 2026-04-17 00:00:00
---

# /ba-strategy — BABOK: Strategy Analysis

> *"Strategy Analysis is the bridge between understanding the current state and defining what needs to change. Without this bridge, requirements are solutions in search of a problem."*

Ejecuta la Knowledge Area **Strategy Analysis** de BABOK v3. Analiza el estado actual del negocio, define el estado futuro deseado, evalúa los riesgos del cambio, identifica los gaps entre ambos estados, y recomienda el enfoque de solución más adecuado.

**THYROX Stage:** Stage 3 DIAGNOSE / Stage 5 STRATEGY.

**Outputs clave:** Current State Analysis · Future State Definition · Gap Analysis · Risk Assessment · Solution Recommendation.

---

## KAs relacionadas — contexto de uso

| KA | Intensidad relativa | Relación |
|----|-------------------|---------|
| **Strategy Analysis** | **Alta** (esta KA) | Análisis del problema de negocio y definición del cambio |
| Elicitation & Collaboration | Alta | Provee el conocimiento del estado actual; re-elicitar si faltan datos |
| Requirements Analysis | Alta | Consume el gap analysis para especificar requisitos |
| Requirements Life Cycle | Baja | Gestiona los requisitos que emergen del strategy |
| Solution Evaluation | Baja | Verifica a posteriori si la solución cerró los gaps identificados |

---

## Pre-condición

Requiere comprensión del dominio de negocio, obtenida de:
- `{wp}/ba-elicitation.md` con necesidades de los stakeholders articuladas, O
- Documentación del negocio disponible (procesos, métricas, restricciones)

---

## Cuándo usar este paso

- Cuando hay un problema de negocio o una oportunidad que analizar antes de definir requisitos
- Cuando se necesita justificar el cambio con análisis del estado actual vs futuro
- Cuando los stakeholders tienen perspectivas diferentes sobre qué necesita cambiar

## Cuándo NO usar este paso

- Si el estado futuro ya está definido y acordado — ir directamente a `ba:requirements-analysis`
- Si el trabajo es solo gestionar requisitos existentes sin análisis estratégico — ir a `ba:requirements-lifecycle`

---

## Actividades

### 1. Análisis del estado actual (Current State)

Entender el negocio como existe hoy — sin juzgar, sin proponer soluciones:

| Dimensión | Preguntas | Herramienta |
|-----------|-----------|------------|
| **Procesos** | ¿Cómo se hacen las cosas hoy? ¿Cuáles son los pasos? ¿Dónde están los cuellos de botella? | Process Map / VSM |
| **Personas** | ¿Quiénes ejecutan los procesos? ¿Qué skills tienen? ¿Qué roles faltan? | Org chart + competency map |
| **Tecnología** | ¿Qué sistemas existen? ¿Cómo se integran? ¿Qué limitaciones tienen? | Technology landscape |
| **Métricas** | ¿Cómo se mide el rendimiento actual? ¿Cuáles son los KPIs? | Performance dashboard |
| **Problemas** | ¿Cuáles son los pain points documentados? ¿Con qué frecuencia y magnitud? | Issue log + incidentes |
| **Limitaciones** | ¿Qué restricciones existen (regulatorias, técnicas, de recursos)? | Constraints document |

**SWOT para el estado actual:**

| | Positivo | Negativo |
|--|---------|---------|
| **Interno** | Fortalezas | Debilidades |
| **Externo** | Oportunidades | Amenazas |

### 2. Business Need y problem statement

Articular con precisión qué problema de negocio justifica el cambio:

| Elemento | Descripción | Ejemplo |
|----------|-------------|---------|
| **Problema** | Qué no funciona en el estado actual | "El proceso de aprobación de créditos tarda 5 días hábiles" |
| **Impacto** | Consecuencia cuantificada del problema | "30% de los solicitantes abandona el proceso; pérdida estimada de $500K/año" |
| **Stakeholders afectados** | Quiénes sufren el problema | "Clientes solicitantes, equipo de créditos, ventas" |
| **Métricas del problema** | Cómo se mide el problema hoy | "Tiempo promedio de aprobación: 5.2 días; tasa de abandono: 31%" |

### 3. Definición del estado futuro (Future State)

El estado futuro describe cómo debería funcionar el negocio después del cambio:

| Elemento | Descripción |
|----------|-------------|
| **Objetivos del cambio** | Qué debe lograrse — expresado en términos de negocio, no de tecnología |
| **Métricas de éxito** | Cómo se medirá que el estado futuro fue alcanzado |
| **Capacidades requeridas** | Qué capacidades nuevas o mejoradas necesita el negocio |
| **Restricciones del futuro** | Qué debe preservarse del estado actual |
| **Asunciones** | Qué se asume como verdad sobre el entorno futuro |

### 4. Gap Analysis

La brecha entre el estado actual y el futuro define el trabajo de cambio:

| Dimensión | Estado actual | Estado futuro | Gap | Prioridad |
|-----------|--------------|--------------|-----|-----------|
| Proceso de aprobación | 5.2 días promedio | < 24 horas | Automatización del flujo | Alta |
| Integración con buró | Manual | Automatizada | API con buró de crédito | Alta |
| Notificaciones | Email manual | Push automático | Sistema de notificaciones | Media |

**Clasificar cada gap:**

| Categoría | Descripción |
|-----------|-------------|
| **Capability gap** | Capacidad que no existe en el estado actual |
| **Performance gap** | Capacidad que existe pero no al nivel requerido |
| **Knowledge gap** | Información o habilidades faltantes |
| **Process gap** | Proceso que debe crearse o rediseñarse |

### 5. Evaluación de riesgos del cambio

| Riesgo | Descripción | Probabilidad | Impacto | Respuesta |
|--------|-------------|-------------|---------|-----------|
| Adopción | Usuarios rechazan el nuevo proceso | Media | Alto | Plan de change management |
| Técnico | Integración con sistemas legacy es compleja | Alta | Alto | PoC antes del desarrollo |
| Negocio | Requisitos regulatorios cambian durante el proyecto | Baja | Alto | Monitorear y revisar |

### 6. Recomendación de solución

Basada en el análisis, recomendar el enfoque:

| Opción | Descripción | Pros | Contras | Costo estimado | Recomendación |
|--------|-------------|------|---------|---------------|---------------|
| **Opción A** | Automatización total | Mayor ROI | Mayor costo | $$$ | [sí/no] |
| **Opción B** | Automatización parcial | Menor riesgo | ROI menor | $$ | [sí/no] |
| **Status quo** | Sin cambios | Sin costo | No resuelve el problema | $ | No |

---

## Routing Table

| Situación | Próxima KA recomendada |
|-----------|----------------------|
| La estrategia está definida y se necesita especificar los requisitos | `ba:requirements-analysis` |
| Se necesita más información del estado actual | `ba:elicitation` |
| Los requisitos del cambio estratégico necesitan trazabilidad | `ba:requirements-lifecycle` |
| La solución fue implementada y se necesita evaluar si cerró los gaps | `ba:solution-evaluation` |

---

## Artefacto esperado

`{wp}/ba-strategy.md`

usar template: [strategy-analysis-template.md](./assets/strategy-analysis-template.md)

---

## Red Flags — señales de Strategy Analysis mal ejecutado

- **Estado futuro que describe tecnología, no capacidades** — "el estado futuro es implementar un CRM con Salesforce" es una solución, no un estado futuro; el estado futuro describe "el equipo de ventas tiene visibilidad completa del historial del cliente en tiempo real"
- **Gap analysis sin métricas** — un gap sin cuantificación es una opinión; el gap analysis debe mostrar la brecha en términos medibles
- **Omitir el SWOT del estado actual** — analizar solo los problemas del estado actual sin sus fortalezas lleva a soluciones que rompen lo que ya funciona
- **Recomendación sin opciones evaluadas** — si el BA presenta una sola opción, no hubo análisis estratégico real
- **Business Need sin impacto cuantificado** — "mejora la satisfacción del cliente" sin número es marketing, no análisis; el Business Need debe tener el costo del problema cuantificado

---

## Criterio de completitud

**Strategy Analysis está completo cuando:**
1. Gap analysis documentado con métricas cuantitativas (estado actual vs target para cada gap)
2. Business Need con impacto cuantificado ($, tiempo, o métrica de negocio)
3. Recomendación de solución con ≥ 2 opciones evaluadas y justificación
4. Risk Assessment del cambio con al menos 3 riesgos y planes de respuesta

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: ba:strategy
flow: ba
ba_ka: strategy_analysis
```

**Al COMPLETAR:**
```yaml
methodology_step: ba:strategy  # completado — gaps definidos, recomendación lista
flow: ba
ba_ka: strategy_analysis
```

## Siguiente paso

Usar la **Routing Table** — la transición más frecuente desde Strategy Analysis es hacia `ba:requirements-analysis` con los gaps bien definidos como punto de partida.

---

## Reference Files

### Assets
- [strategy-analysis-template.md](./assets/strategy-analysis-template.md) — Template completo: Current State (procesos/métricas/pain points/SWOT), Business Need con impacto cuantificado, Future State (objetivos/métricas de éxito/capacidades/restricciones), Gap Analysis con categorización, Risk Assessment, ≥2 opciones de solución con ROI, routing

### References
- [gap-analysis-guide.md](./references/gap-analysis-guide.md) — Dimensiones del estado actual (7 dimensiones), cómo cuantificar (métricas de tiempo/calidad/costo/satisfacción), Business Need formato preciso (qué es vs qué no es), categorías de gaps BABOK (capability/performance/knowledge/process), SWOT aplicado al dominio, evaluación comparativa de opciones con matriz de dimensiones

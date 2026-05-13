---
name: ba-solution-evaluation
description: "Use when evaluating whether a solution delivered the expected business value in BABOK. ba:solution-evaluation — measure solution performance with KPIs, assess value realization, identify limitations, recommend next steps."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["solution evaluation", "value realization", "solution performance KPI", "BABOK evaluation", "solution assessment"]
updated_at: 2026-04-17 00:00:00
---

# /ba-solution-evaluation — BABOK: Solution Evaluation

> *"A solution is only as good as the value it delivers. Building the right thing correctly is not enough — the BA must confirm that the solution actually resolved the business need that justified the investment."*

Ejecuta la Knowledge Area **Solution Evaluation** de BABOK v3. Mide el performance de la solución implementada usando KPIs, evalúa la realización del valor de negocio, identifica limitaciones de la solución, y recomienda los próximos pasos (mejoras, nuevas iniciativas o cierre).

**THYROX Stage:** Stage 11 TRACK/EVALUATE / Stage 12 STANDARDIZE.

**Outputs clave:** Solution Performance Assessment · Value Realization Report · Recommendations · BA Lessons Learned.

---

## KAs relacionadas — contexto de uso

| KA | Intensidad relativa | Relación |
|----|-------------------|---------|
| **Solution Evaluation** | **Alta** (esta KA) | Medir si la solución entregó el valor de negocio esperado |
| Strategy Analysis | Alta | Provee el baseline del estado actual y las métricas de éxito a comparar |
| Business Analysis Planning | Media | Provee el plan de evaluación y los stakeholders a consultar |
| Requirements Analysis | Baja | Las especificaciones sirven de referencia para verificar la cobertura de la solución |
| Requirements Life Cycle | Baja | Verifica que los requisitos validados corresponden a los implementados |

---

## Pre-condición

Requiere:
- La solución implementada en producción o en uso real (no en staging)
- Métricas del estado actual (baseline) definidas en `ba:strategy` o `ba:planning`
- Datos reales de uso de la solución (mínimo 2-4 semanas de datos en producción)

---

## Cuándo usar este paso

- Cuando la solución ha sido implementada y está en uso real por los usuarios
- En revisiones periódicas post-implementación (30, 60, 90 días)
- Cuando el sponsor pregunta "¿valió la pena la inversión?"

## Cuándo NO usar este paso

- Antes de que la solución esté en uso real — la evaluación sin datos reales es solo proyección
- Para evaluar si la solución fue construida correctamente (eso es QC/testing) — este paso evalúa si la solución entrega valor de negocio

---

## Actividades

### 1. Medir performance de la solución

Comparar las métricas actuales (post-implementación) vs el baseline (pre-implementación):

**KPI Dashboard:**

| KPI | Baseline (pre-impl) | Target (estado futuro) | Actual (post-impl) | % de mejora | Estado |
|-----|--------------------|-----------------------|--------------------|-------------|--------|
| [KPI 1 — ej: tiempo de proceso] | [valor] | [objetivo] | [valor real] | [%] | ✅/⚠️/❌ |
| [KPI 2 — ej: tasa de error] | [valor] | [objetivo] | [valor real] | [%] | ✅/⚠️/❌ |
| [KPI 3 — ej: satisfacción usuario] | [valor] | [objetivo] | [valor real] | [%] | ✅/⚠️/❌ |

**Clasificación del estado de cada KPI:**

| Estado | Criterio |
|--------|---------|
| ✅ Logrado | ≥ 90% del target alcanzado |
| ⚠️ Parcial | 60-89% del target alcanzado |
| ❌ No logrado | < 60% del target alcanzado |

### 2. Evaluación de value realization

La realización de valor va más allá de los KPIs — evalúa si el business need original fue resuelto:

| Dimensión | Evaluación |
|-----------|-----------|
| **Business Need** | ¿El problema original que justificó el proyecto fue resuelto? |
| **Stakeholder Satisfaction** | ¿Los usuarios consideran que la solución satisface sus necesidades? |
| **ROI** | ¿El beneficio realizado justifica el costo de la inversión? |
| **Adoption** | ¿Los usuarios están usando la solución como fue diseñada? |
| **Side effects** | ¿La solución introdujo problemas no anticipados? |

**Técnicas para evaluar value realization:**

| Técnica | Cuándo usar | Output |
|---------|-------------|--------|
| **Encuesta de satisfacción** | Para medir percepción de los usuarios | NPS o CSAT score |
| **Análisis de adopción** | Métricas de uso real (logs, analytics) | % de usuarios activos, features usadas |
| **Entrevistas post-implementación** | Para entender el "por qué" detrás de los números | Insights cualitativos |
| **Análisis financiero** | Para ROI y cost savings | Comparación costo vs beneficio |
| **Observación de uso** | Para detectar workarounds que los usuarios crearon | Comportamientos no anticipados |

### 3. Identificar limitaciones de la solución

Toda solución tiene limitaciones que deben documentarse:

| Tipo de limitación | Descripción | Impacto |
|-------------------|-------------|---------|
| **Funcional** | Capacidades que la solución no tiene y que los usuarios necesitan | [impacto en el negocio] |
| **De performance** | La solución funciona correctamente pero es lenta o no escala | [impacto en la adopción] |
| **De usabilidad** | Difícil de usar; requiere más training del esperado | [impacto en la adopción] |
| **De integración** | No se integra bien con otros sistemas | [impacto en procesos adyacentes] |
| **De datos** | Datos sucios, incompletos o inconsistentes afectan los resultados | [impacto en confiabilidad] |

### 4. Lecciones aprendidas del proceso de BA

Capturar lecciones del trabajo de análisis de negocio realizado durante el proyecto:

| KA BABOK | Situación | Impacto | Acción recomendada |
|---------|-----------|---------|-------------------|
| **Elicitation** | Técnicas usadas vs efectividad | [impacto en la calidad de los requisitos] | [recomendación] |
| **Strategy** | Precisión del gap analysis vs la realidad | [impacto] | [recomendación] |
| **Requirements Analysis** | Requisitos que cambiaron más durante el desarrollo | [impacto en el scope] | [recomendación] |
| **Requirements Lifecycle** | Gestión de cambios — qué funcionó, qué no | [impacto en el proceso] | [recomendación] |
| **BA Planning** | Precisión del BA Plan vs el trabajo real | [impacto] | [recomendación] |

### 5. Recomendaciones

Basadas en la evaluación, definir los próximos pasos:

| Tipo de recomendación | Criterio | Acción |
|----------------------|---------|--------|
| **Iniciativa nueva** | KPIs logrados; business need resuelto; usuarios satisfechos; nuevo gap identificado | Iniciar nueva KA de Strategy Analysis |
| **Mejora de la solución** | KPIs parcialmente logrados; limitaciones funcionales que deben resolverse | Re-iniciar `ba:requirements-analysis` con los gaps identificados |
| **Corrección** | KPIs no logrados; solución no usada como diseñada | Investigar con `ba:elicitation` + `ba:strategy` |
| **Cierre** | KPIs logrados; business need resuelto; no hay nuevas necesidades identificadas | Cerrar la iniciativa de BA |

---

## Routing Table

| Situación | Próxima KA recomendada |
|-----------|----------------------|
| Evaluación positiva; nueva necesidad identificada | `ba:strategy` (nueva iniciativa) |
| Evaluación parcial; hay gaps que resolver | `ba:requirements-analysis` (nueva iteración) |
| Evaluación negativa; necesita re-análisis del problema | `ba:elicitation` + `ba:strategy` |
| Evaluación positiva; no hay nuevas necesidades | Cierre de la iniciativa BABOK |
| Limitaciones de datos que impiden la evaluación | `ba:elicitation` para obtener más datos |

---

## Artefacto esperado

`{wp}/ba-solution-evaluation.md`

usar template: [solution-evaluation-template.md](./assets/solution-evaluation-template.md)

---

## Red Flags — señales de Solution Evaluation mal ejecutada

- **Evaluación solo con los datos del sponsor** — si solo se recopila la perspectiva del sponsor sin hablar con los usuarios finales, la evaluación está sesgada hacia la perspectiva ejecutiva
- **KPIs evaluados sin baseline** — "el tiempo de proceso mejoró" sin un número de baseline no puede cuantificarse ni verificarse
- **Evaluación realizada demasiado pronto** — evaluar la solución a los 3 días de implementación no da tiempo a que los usuarios se adapten; mínimo 2-4 semanas de uso real
- **Limitaciones ignoradas por presión política** — documentar que la solución tiene limitaciones no es fracaso del proyecto; ignorar las limitaciones es un fracaso del BA
- **Lecciones aprendidas del BA omitidas** — las lecciones de la propia práctica de BA son el input más valioso para mejorar el siguiente proyecto; omitirlas por presión de cierre es una oportunidad perdida

---

## Criterio de completitud

**Solution Evaluation está completo cuando:**
1. KPI Dashboard completado con baseline, target y valor actual para cada KPI del Business Need original
2. Value Realization Summary con veredicto claro (Sí / Parcialmente / No) y evidencia cuantitativa
3. Limitaciones documentadas con prioridad de resolución
4. Lecciones aprendidas del proceso de BA completadas por KA
5. Recomendación clara sobre próximos pasos (nueva iniciativa / mejora / cierre)

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: ba:solution-evaluation
flow: ba
ba_ka: solution_evaluation
```

**Al COMPLETAR:**
```yaml
methodology_step: ba:solution-evaluation  # completado
flow: ba
ba_ka: solution_evaluation
```

## Siguiente paso

Usar la **Routing Table** — esta es la última KA del ciclo BABOK típico. Si la evaluación es positiva y no hay nuevas necesidades, el trabajo de BA para esta iniciativa está completo. Si hay nuevas necesidades o mejoras identificadas, iniciar un nuevo ciclo de BA.

---

## Reference Files

### Assets
- [solution-evaluation-template.md](./assets/solution-evaluation-template.md) — Template completo: KPI Dashboard (baseline/target/actual/% mejora/estado), Value Realization Summary, evaluación por técnica (encuesta/adopción/entrevistas), limitaciones por tipo, lecciones aprendidas por KA BABOK, recomendaciones con 4 tipos de acción, routing

### References
- [evaluation-techniques.md](./references/evaluation-techniques.md) — Marco de evaluación BABOK (3 preguntas), clasificación de KPIs (leading/lagging/process/outcome), períodos de medición por tipo de proyecto, NPS/CSAT/CES con cálculos y benchmarks, métricas de adopción por tipo de solución, workarounds como señal de adopción, cálculo ROI/payback, protocolo de entrevistas post-implementación, agenda de PIR

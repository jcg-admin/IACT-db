# Solution Evaluation — [Nombre del proyecto]

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: ba:solution-evaluation
evaluation_date: [fecha]
evaluation_period: [ej: 30 días post-go-live]
author: [nombre]
status: Borrador
```

---

## KPI Dashboard

| KPI | Baseline (pre-impl) | Target (estado futuro) | Actual (post-impl) | % de mejora | Estado |
|-----|:------------------:|:---------------------:|:-----------------:|:-----------:|:------:|
| [ej: Tiempo promedio de proceso] | [valor] | [target] | [valor real] | [%] | ✅/⚠️/❌ |
| [ej: Tasa de error] | [valor] | [target] | [valor real] | [%] | ✅/⚠️/❌ |
| [ej: Satisfacción usuario (NPS)] | [valor] | [target] | [valor real] | [pts] | ✅/⚠️/❌ |
| [ej: Costo por transacción] | [valor] | [target] | [valor real] | [%] | ✅/⚠️/❌ |

**Leyenda:**
- ✅ Logrado: ≥ 90% del target alcanzado
- ⚠️ Parcial: 60-89% del target alcanzado
- ❌ No logrado: < 60% del target alcanzado

**Resumen KPI:** [#] de [#] KPIs logrados · [#] parciales · [#] no logrados

---

## Value Realization Summary

| Dimensión | Evaluación |
|-----------|-----------|
| **Business Need original** | [descripción del problema que justificó el proyecto] |
| **¿Fue resuelto?** | ✅ Sí / ⚠️ Parcialmente / ❌ No — [justificación con evidencia] |
| **Satisfacción de stakeholders** | [puntaje NPS/CSAT / evidencia cualitativa] |
| **ROI estimado** | Costo implementación: [$] · Beneficio anual: [$] · Payback: [meses] |
| **Adopción** | [% usuarios activos] / [features más usadas] / [features no usadas] |
| **Side effects** | [problemas no anticipados detectados, si los hay] |

---

## Evaluación por técnica

### Encuesta de satisfacción

**Muestra:** [# respondientes] de [# total usuarios] ([%] de cobertura)

| Pregunta | Resultado | Referencia sectorial |
|---------|:---------:|:--------------------:|
| NPS: "¿Recomendaría esta solución?" | [score] | [benchmark si disponible] |
| CSAT: "¿Está satisfecho con la solución?" | [%] | — |
| CES: "¿Qué tan fácil es usar la solución?" | [1-7] | — |

**Verbatims destacados:**
- Positivos: "[cita textual]"
- Negativos: "[cita textual]"

---

### Análisis de adopción

| Métrica | Valor | Período |
|---------|:-----:|:-------:|
| Usuarios activos / Usuarios totales habilitados | [%] | [últimos 30 días] |
| Sesiones promedio por usuario / semana | [#] | [período] |
| Feature principal: [nombre] — uso | [%] | [período] |
| Feature secundaria: [nombre] — uso | [%] | [período] |
| Workarounds detectados (usuarios que evitan usar X) | [#] | [período] |

**Señales de baja adopción:**
- [ ] Usuarios que siguen usando el proceso manual en paralelo
- [ ] Features diseñadas como primarias con < 20% de uso
- [ ] Aumento de tickets de soporte al usar la solución

---

### Entrevistas post-implementación

| Stakeholder | Rol | Fecha | Satisfacción (1-5) | Insight clave |
|-------------|-----|-------|:-----------------:|---------------|
| [nombre] | [rol] | [fecha] | [#] | [hallazgo principal] |
| [nombre] | [rol] | [fecha] | [#] | |

**Temas recurrentes en las entrevistas:**
1. [tema positivo recurrente]
2. [tema negativo recurrente / solicitud de mejora]

---

## Limitaciones identificadas

| Tipo | Descripción | Impacto en el negocio | Prioridad para resolución |
|:----:|-------------|----------------------|:------------------------:|
| Funcional | [capacidad que falta] | [impacto cuantificado] | Alta / Media / Baja |
| Performance | [lentitud o problema de escala] | [impacto en adopción] | |
| Usabilidad | [dificultad de uso] | [impacto en adopción] | |
| Integración | [problema con sistemas adyacentes] | [impacto en procesos] | |
| Datos | [calidad o disponibilidad de datos] | [impacto en confiabilidad] | |

---

## Lecciones aprendidas del proceso de BA

| KA BABOK | Situación observada | Impacto | Recomendación para próximo proyecto |
|---------|--------------------|---------|------------------------------------|
| **BA Planning** | [precisión del BA Plan vs trabajo real] | [impacto] | [recomendación] |
| **Elicitation** | [técnicas más/menos efectivas] | [impacto en calidad de requisitos] | [recomendación] |
| **Strategy Analysis** | [precisión del gap analysis] | [impacto] | [recomendación] |
| **Requirements Analysis** | [requisitos que cambiaron más] | [impacto en scope] | [recomendación] |
| **Requirements Lifecycle** | [gestión de cambios — qué funcionó] | [impacto en proceso] | [recomendación] |

---

## Recomendaciones

| Tipo | Criterio | Acción concreta |
|:----:|---------|----------------|
| [ ] Nueva iniciativa | KPIs logrados; nuevo gap identificado | Iniciar `ba:strategy` para nueva necesidad |
| [ ] Mejora de la solución | KPIs parciales; limitaciones funcionales críticas | Re-iniciar `ba:requirements-analysis` con gaps |
| [ ] Corrección urgente | KPIs no logrados; problema sistémico | Investigar con `ba:elicitation` + `ba:strategy` |
| [ ] Cierre | KPIs logrados; Business Need resuelto; sin nuevas necesidades | Cerrar iniciativa BABOK |

**Decisión recomendada:** [tipo seleccionado + justificación]

---

## Evaluación de completitud

- [ ] KPI Dashboard completo con baseline, target y valor actual para cada KPI del Business Need original
- [ ] Value Realization Summary con veredicto claro (Sí / Parcialmente / No) y evidencia cuantitativa
- [ ] Mínimo 2-4 semanas de datos reales de producción (no staging)
- [ ] Limitaciones documentadas con prioridad de resolución
- [ ] Lecciones aprendidas del proceso de BA por KA
- [ ] Recomendación clara sobre próximos pasos

---

## Routing — próxima KA

| Situación | Próxima KA |
|-----------|-----------|
| Evaluación positiva; nueva necesidad identificada | `ba:strategy` (nueva iniciativa) |
| Evaluación parcial; hay gaps que resolver | `ba:requirements-analysis` (nueva iteración) |
| Evaluación negativa; necesita re-análisis | `ba:elicitation` + `ba:strategy` |
| Evaluación positiva; sin nuevas necesidades | Cierre de la iniciativa BABOK |
| Datos insuficientes para evaluar | `ba:elicitation` para obtener más datos |

**Decisión:** [selección + razón basada en la evaluación]

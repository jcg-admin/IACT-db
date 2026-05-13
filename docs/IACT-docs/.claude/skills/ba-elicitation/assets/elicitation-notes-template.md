# Elicitation Notes — [Nombre del proyecto / Iteración N]

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: ba:elicitation
iteration: [N]
author: [nombre]
status: Borrador
```

---

## Actividades de elicitación ejecutadas

### [Técnica 1 — ej: Entrevistas individuales]

| Stakeholder | Rol | Fecha | Duración | Temas cubiertos | Hallazgos clave |
|-------------|-----|-------|----------|----------------|----------------|
| [nombre] | [rol] | [fecha] | [min] | [temas] | [hallazgos] |
| [nombre] | [rol] | [fecha] | [min] | [temas] | [hallazgos] |

**Observaciones de la sesión:**
[Contexto adicional, dinámicas, restricciones mencionadas informalmente]

---

### [Técnica 2 — ej: Taller JAD]

| Fecha | Facilitador | Participantes | Duración | Temas cubiertos | Acuerdos alcanzados |
|-------|------------|--------------|----------|----------------|---------------------|
| [fecha] | [nombre] | [lista] | [horas] | [temas] | [acuerdos] |

**Puntos de conflicto no resueltos:**
| Conflicto | Posición A | Posición B | Plan de resolución |
|-----------|-----------|-----------|-------------------|
| [conflicto] | [stakeholder + posición] | [stakeholder + posición] | [cómo se resolverá] |

---

### [Técnica 3 — ej: Observación / Shadowing]

| Usuario observado | Proceso observado | Fecha | Duración | Observaciones clave |
|------------------|------------------|-------|----------|---------------------|
| [nombre] | [proceso] | [fecha] | [horas] | [observaciones] |

**Diferencias proceso descrito vs proceso real:**
| Paso del proceso | Lo que dijo el usuario | Lo que se observó |
|-----------------|----------------------|------------------|
| [paso] | [descripción verbal] | [lo observado realmente] |

---

## Resultados confirmados

| Hallazgo ID | Descripción del hallazgo | Confirmado por | Fecha | Método de confirmación |
|-------------|--------------------------|---------------|-------|----------------------|
| H-001 | [descripción factual] | [nombre/rol] | [fecha] | [email / minuta / firma] |
| H-002 | [descripción] | [nombre] | [fecha] | [método] |

---

## Necesidades articuladas (sin solución)

> **Formato BABOK:** Necesidad = qué lograr, no cómo lograrlo.

| Need ID | Stakeholder | Necesidad (qué lograr) | Contexto / frecuencia | Impacto si no se resuelve | Prioridad inicial |
|---------|-------------|------------------------|----------------------|--------------------------|------------------|
| NEED-001 | [nombre/rol] | [descripción de la necesidad] | [contexto y frecuencia] | [impacto cuantificado si posible] | Alta / Media / Baja |
| NEED-002 | | | | | |

---

## Gaps identificados

| Gap ID | Descripción del gap | Tipo | Stakeholder / info faltante | Plan para cerrar | Urgencia |
|--------|--------------------|----|-----------------------------|-----------------|----|
| GAP-001 | [qué información falta] | Stakeholder / Proceso / Datos | [quién falta / qué falta] | [plan] | Alta / Media |
| GAP-002 | | | | | |

---

## Evaluación de completitud de esta iteración

- [ ] Todas las técnicas planificadas en el BA Plan ejecutadas
- [ ] Resultados confirmados por los stakeholders relevantes (100% de H-NNN confirmados)
- [ ] Necesidades articuladas sin mezclar con soluciones
- [ ] Gaps identificados con plan de resolución
- [ ] Conflictos del taller documentados con plan de resolución

**¿Se requiere nueva ronda de elicitación?** [ ] Sí — por GAP-NNN · [ ] No

---

## Routing — próxima KA

| Situación | Próxima KA |
|-----------|-----------|
| La elicitación reveló problema estratégico sin análisis | `ba:strategy` |
| Suficiente información para modelar requisitos | `ba:requirements-analysis` |
| Requisitos elicitados necesitan trazabilidad | `ba:requirements-lifecycle` |
| Elicitación insuficiente (gaps críticos) | Nueva ronda `ba:elicitation` |
| Solución existente → evaluar si cumplió las necesidades | `ba:solution-evaluation` |

**Decisión para este proyecto:** [KA seleccionada + razón basada en los hallazgos]

```yml
type: Referencia General
category: Escalabilidad
version: 1.0
purpose: Guía de cómo adaptar THYROX según complejidad del proyecto.
goal: Decidir qué estructura y fases usar según tamaño del trabajo.
updated_at: 2026-04-17 02:46:00
owner: workflow-discover
```

# Escalabilidad por Complejidad

## Propósito

THYROX se adapta al tamaño del proyecto. Esta guía explica qué estructura usar.

---

## Decision Framework

- **< 30 minutos:** Solo work-log
- **30 min - 2 horas:** Work-log + documento simple
- **2 - 8 horas:** Work-logs + epics/ (MEDIUM)
- **8+ horas:** FULL STRUCTURE con sub-agents

---

## Proyectos Pequeños (<2 horas)

**Estructura simplificada:**
- 1 work-log (snapshot inicial)
- 1 documento mutable (donde se captura todo)

**Fases activas:** 1, 2, 6, 7
**Sin:** Sub-agents, JSON metadata

**Ejemplo:**
```
work-logs/2026-03-26-10-00-quick-fix-typo.md
documento: TASK-FIX-TYPO.md (todo en uno)
```

---

## Proyectos Medianos (2-8 horas)

**Estructura balanceada:**
- work-logs/ granulares (1 por STEP importante)
- epics/YYYY-MM-DD-HH-MM-nombre/ con estructura PHASE-based
- project.json — opcional, activar si el proyecto tiene >50 issues o necesita tracking de métricas estructurado

**Fases activas:** 1, 2, 3, 4, 5, 6, 7
**Con:** Algunas fases pueden ser rápidas
**Sub-agents:** Validación manual entre PHASEs

**Ejemplo:**
```
work-logs/
  2026-03-26-10-00-decision-feature-x.md
  2026-03-26-10-15-analisis-requisitos.md
  2026-03-26-11-00-design-aprobado.md

epics/2026-03-26-10-00-feature-x/
  project.json
  PLAN.md
  analisis/
  specification/
  tasks/
  implementation/
```

---

## Proyectos Grandes (8+ horas)

**Estructura completa:**
- work-logs/ muy granulares (1 por STEP)
- epics/YYYY-MM-DD-HH-MM-nombre/ completo
- project.json con timing data
- exit-conditions.md rigurosas
- sub-agents para validación automática

**Fases activas:** 1-7 con rigor completo
**Con:** Iteraciones, validaciones, análisis cuantitativos
**Sub-agents:** Validación automática entre PHASEs

**Ejemplo:**
```
work-logs/
  2026-03-26-10-00-decision-big-project.md
  2026-03-26-10-15-step1-inventario.md
  2026-03-26-10-30-step2-conflictos.md
  2026-03-26-11-00-estrategia-aprobada.md

epics/2026-03-26-10-00-big-project/
  project.json (timing data)
  exit-conditions.md (100% compliance)
  PLAN.md, analisis/, estrategia/, specification/, tasks/, implementation/
```

---

## Sub-Agents para Validación

Para proyectos MEDIANOS y GRANDES, usar sub-agents para validación entre PHASEs:

### Validación After PHASE 1 (ANALYZE)

Sub-agent revisa:
- [ ] Requisitos están claros?
- [ ] Documentación está completa?
- [ ] Stakeholders aprobaron?
- [ ] Referencias al 100%?

Feedback: "Ready for PHASE 2" o "Missing: [X]"

### Validación After PHASE 4 (STRUCTURE)

Sub-agent revisa:
- [ ] Design es implementable?
- [ ] Tasks pueden ejecutarse atómicamente?
- [ ] Estimaciones son realistas?
- [ ] Criterios de éxito son verificables?

Feedback: "Ready for PHASE 5" o "Refine: [X]"

### Validación After PHASE 6 (EXECUTE)

Sub-agent revisa:
- [ ] Todos los tasks completados?
- [ ] Tests pasados?
- [ ] Code quality OK?
- [ ] Commits siguen convención?

Feedback: "Ready for PHASE 7" o "Fix: [X]"

### Cómo Invocar Sub-Agents

```
"Sub-agent, valida que completamos PHASE 1.
Checkea: exit-conditions.md y project.json (si aplica)"
```

---

## Tracking & Metrics

### JSON Metadata

Cada proyecto tiene `project.json` que captura:

```json
{
  "phases": {
    "phase_1": { "status": "completed", "duration_minutes": 15 },
    "phase_2": { "status": "in_progress", "duration_minutes": 30 }
  },
  "timing": {
    "total_duration_minutes": 45,
    "breakdown_by_phase": { ... }
  }
}
```

### Work-Logs

Cada work-log tiene metadata:
```
phase: 2
step: step-1-inventario
duration_minutes: 15
status: completed
```

### Analysis

Después de PHASE 7, puedes:
- Comparar: Estimado vs Real
- Analizar: Cuáles PHASEs toman más tiempo
- Optimizar: Patrones para proyectos futuros

---

**Última actualización:** 2026-04-17

---

## Escalabilidad con methodology skill activo

Cuando `now.md::flow` tiene un valor activo, la lógica de escalabilidad cambia:
los stages donde el flow tiene methodology skills anclados son **recomendados con alta prioridad**.
En proyectos pequeños pueden abreviarse, pero no omitirse completamente sin justificación documentada.

**Regla de precedencia:** stages con anclaje de methodology skill > regla de tamaño (guía, no constraint hard).

### Stages recomendados por flow activo

| Flow | Namespace | Stages obligatorios | Stages opcionales (según tamaño) |
|------|-----------|--------------------|---------------------------------|
| `pdca` | `pdca:` | 3, 10, 11, 12 | 1, 2, 4, 5, 6, 7, 8, 9 |
| `dmaic` | `dmaic:` | 2, 3, 10, 11, 12 | 1, 4, 5, 6, 7, 8, 9 |
| `rup` | `rup:` | 1, 3, 5, 7, 10, 11, 12 | 2, 4, 6, 8, 9 |
| `rm` | `rm:` | 1, 3, 5, 7, 9, 10, 11 | 2, 4, 6, 8, 12 |
| `pm` | `pm:` | 1, 3, 5, 6, 7, 10, 11, 12 | 2, 4, 8, 9 |
| `ba` | `ba:` | 1, 2, 3, 5, 6, 7, 10, 11, 12 | 4, 8, 9 |
| `lean` | `lean:` | 2, 3, 10, 11 | 1, 4, 5, 6, 7, 8, 9, 12 |
| `pps` | `pps:` | 1, 2, 3, 6, 10, 11 | 4, 5, 7, 8, 9, 12 |
| `sp` | `sp:` | 1, 2, 3, 5, 6, 10, 11, 12 | 4, 7, 8, 9 |
| `cp` | `cp:` | 1, 2, 3, 5, 6, 10, 11 | 4, 7, 8, 9, 12 |
| `bpa` | `bpa:` | 1, 2, 3, 5, 10, 11 | 4, 6, 7, 8, 9, 12 |

### Regla de convivencia

El workflow stage y el methodology skill son **complementarios**, no excluyentes:
- El workflow stage produce sus artefactos THYROX (ej: `analyze/*.md`)
- El methodology skill produce sus artefactos metodológicos (ej: `analyze/dmaic-define.md`)
- Ambos conviven en el mismo cajón de fase

### Fuente de verdad

El campo `flow:` en `now.md` determina si aplica esta regla.
- `flow: null` → escalabilidad normal (solo regla de tamaño)
- `flow: dmaic` → stages 2, 3, 10, 11, 12 son recomendados con alta prioridad para este WP
- `flow: sp` → stages 1, 2, 3, 5, 6, 10, 11, 12 son recomendados con alta prioridad para este WP

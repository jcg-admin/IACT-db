```yml
created_at: 2026-04-16 19:32:39
project: THYROX
status: Aprobado
author: NestorMonroy
context: ÉPICA 40 — multi-methodology
```

# ADR: Terminología THYROX — Épica, Stage, y desambiguación con metodologías

## Contexto

THYROX usaba "FASE N" para dos niveles distintos:
- El número secuencial de iniciativa del proyecto (`FASE 40: multi-methodology`)
- Las etapas internas del WP (`Phase 1: DISCOVER`)

Con el soporte de múltiples metodologías (PDCA, DMAIC, PMBOK, RUP, etc.), 4 etapas internas colisionaban directamente con nombres de pasos de esas metodologías: MEASURE (DMAIC), ANALYZE (DMAIC), PLAN (PDCA/PMBOK), EXECUTE (PMBOK).

## Decisión

### 1. Nivel superior: FASE → ÉPICA

El número secuencial de iniciativa del proyecto pasa de llamarse `FASE N` a `ÉPICA N`.
Corresponde al concepto de **Epic** en Agile/PMBOK — agrupa trabajo relacionado con un objetivo concreto.

```
ÉPICA 40: multi-methodology     ← antes: FASE 40
ÉPICA 39: plugin-distribution   ← antes: FASE 39
```

### 2. Etapas internas del WP: Phase → Stage

Las 12 etapas del ciclo THYROX dentro de un WP pasan de `Phase N` a `Stage N`.

```
Stage 1 — DISCOVER    ← antes: Phase 1 — DISCOVER
Stage 10 — IMPLEMENT  ← antes: Phase 10 — EXECUTE
```

### 3. Renaming de 4 etapas que colisionan con metodologías

| # | Anterior | Nuevo | Colisión resuelta |
|---|----------|-------|-------------------|
| 2 | MEASURE | **BASELINE** | DMAIC:Measure |
| 3 | ANALYZE | **DIAGNOSE** | DMAIC:Analyze |
| 6 | PLAN | **SCOPE** | PDCA:Plan, PMBOK:Planning |
| 10 | EXECUTE | **IMPLEMENT** | PMBOK:Executing, RUP:Construction |

Las otras 8 etapas no cambian: DISCOVER, CONSTRAINTS, STRATEGY, DESIGN/SPECIFY, PLAN EXECUTION, PILOT/VALIDATE, TRACK/EVALUATE, STANDARDIZE.

### 4. Convención de namespace para pasos de metodología

Los pasos de metodología activa siempre se escriben con prefijo:
```
pdca:plan     pdca:do       pdca:check    pdca:act
dmaic:define  dmaic:measure dmaic:analyze dmaic:improve  dmaic:control
pmbok:initiating  pmbok:planning  pmbok:executing  pmbok:closing
```

### 5. Estructura de now.md con múltiples niveles

```yaml
epic: ÉPICA 40 — multi-methodology          # iniciativa (antes: FASE)
stage: Stage 10 — IMPLEMENT                  # etapa THYROX (antes: phase)
flow: pdca                                   # metodología activa (nuevo)
methodology_step: pdca:do                    # paso de la metodología (nuevo)
```

## Consecuencias

### Inmediatas (este ADR registra la decisión)
- Toda referencia nueva usa la terminología aprobada
- CLAUDE.md, glosario y references se actualizan de forma incremental

### Migración incremental (no big-bang)
- `workflow-*` skills se renombran cuando se trabaja en ellos (no todos a la vez)
- `workflow-measure` → `workflow-baseline` al tocar ese skill
- `workflow-analyze` → `workflow-diagnose` al tocar ese skill
- `workflow-plan` → `workflow-scope` al tocar ese skill
- `workflow-execute` → `workflow-implement` al tocar ese skill
- `session-start.sh` se actualiza en ÉPICA 40 Stage 10 IMPLEMENT

### No cambia
- Numeración histórica (ÉPICA 1..39 existentes se leen como "antes se llamaban FASE N")
- `T-NNN` para tareas atómicas
- Nombres de los 8 stages sin conflicto

## Referencias cruzadas
- `multi-methodology-patterns-analysis.md` — análisis de patrones que motivó esta decisión
- ADR registra decisión; migración concreta en task-plan de ÉPICA 40

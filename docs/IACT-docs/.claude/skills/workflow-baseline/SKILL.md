---
name: workflow-baseline
description: "Use when you need to establish baselines and quantify the current state before analyzing. Phase 2 MEASURE — recopila datos cuantitativos, define métricas de éxito y baseline del WP."
allowed-tools: Read Glob Grep Bash
disable-model-invocation: true
effort: medium
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-session-phase.sh 'Phase 2'"
updated_at: 2026-04-20 13:08:54
---

# /workflow-measure — Stage 2: BASELINE

Inicia o retoma Stage 2 BASELINE del work package activo.

---

## Contexto de sesión

1. Identificar WP activo: `ls -t .thyrox/context/work/ | head -1`
2. Leer síntesis DISCOVER: `cat .thyrox/context/work/[WP]/discover/*-analysis.md`
3. Leer `context/now.md` — verificar `phase`
4. Verificar si ya existe `work/.../measure/`:
   - Si existe con baseline documentado → Phase 2 ya completó. Proponer `/thyrox:analyze`.

---

## Fase a ejecutar: Phase 2 MEASURE

Sin datos cuantitativos, es imposible saber si la solución funcionó.
La medición define el "antes" contra el cual se evaluará el "después" en Phase 11 TRACK/EVALUATE.

### Qué medir

Dependiendo del tipo de WP:

**Para features/bugs técnicos:**
- Performance actual: latencias, throughput, error rates
- Cobertura de tests existente
- Deuda técnica cuantificada (archivos afectados, LOC, complejidad ciclomática)
- Tiempo actual de operación / ejecución manual

**Para procesos de trabajo:**
- Tiempo actual por tarea (baseline temporal)
- Frecuencia de problemas recurrentes
- Costo actual del proceso

**Para investigación/análisis:**
- Número de fuentes revisadas
- Criterios de evaluación definidos con sus pesos
- Estado actual de documentación

### Métricas de éxito

REQUERIDO: definir qué significa "éxito medible" para este WP.
- Formato: `{métrica} mejorará de {baseline} a {target} medido por {método}`
- Ejemplos:
  - "Latencia del endpoint /api/users bajará de 450ms a <100ms medido por benchmark"
  - "Cobertura de tests subirá de 34% a >80% medido por jest --coverage"
  - "Tiempo de deploy manual bajará de 20min a <2min medido por cronómetro"

### Artefactos

REQUERIDO: `work/.../measure/{nombre-wp}-baseline.md`

```yml
created_at: YYYY-MM-DD HH:MM:SS
project: [Nombre del proyecto]
work_package: YYYY-MM-DD-HH-MM-SS-nombre
phase: Phase 2 — MEASURE
author: [Nombre]
status: Borrador
```

Contenido mínimo:
- **Baseline actual**: datos cuantitativos del estado actual
- **Métricas de éxito**: qué se va a mejorar y cuánto
- **Método de medición**: cómo se va a verificar el éxito
- **Fecha de medición**: cuándo se tomó el baseline

---

## Validaciones pre-gate

Antes de presentar el gate 2→3:
- `work/.../measure/{nombre-wp}-baseline.md` existe con datos cuantitativos
- Al menos una métrica de éxito definida con valor target
- Método de medición documentado (cómo verificar el éxito)

## Gate humano

⏸ STOP — Presentar baseline y métricas de éxito propuestas.
Esperar confirmación explícita. NO continuar sin respuesta.
Al aprobar: actualizar `context/now.md::phase` a `Phase 3`.

---

## Exit criteria

Phase 2 completa cuando:
- `work/.../measure/{nombre-wp}-baseline.md` existe con datos cuantitativos
- Métricas de éxito definidas y aprobadas por el usuario
- Usuario confirmó el baseline y métricas en esta sesión

**Detectar:** Si `work/.../measure/` tiene `*-baseline.md`, Phase 2 ya completó.
Al terminar: proponer `/thyrox:analyze` para Phase 3.

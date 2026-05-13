---
name: workflow-strategy
description: "Use when designing a solution after constraints are documented. Phase 5 STRATEGY — investiga alternativas arquitectónicas y produce solution-strategy.md con Key Ideas + ADRs."
allowed-tools: Read Glob Grep Bash
disable-model-invocation: true
effort: high
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-session-phase.sh 'Phase 5'"
updated_at: 2026-04-20 13:51:04
---

# /workflow-strategy — Phase 5: STRATEGY

Inicia o retoma Phase 5 STRATEGY del work package activo.

---

## Contexto de sesión

1. Identificar WP activo: `ls -t .thyrox/context/work/ | head -1`
2. Leer síntesis DISCOVER: `cat .thyrox/context/work/[WP]/discover/*-analysis.md`
3. Leer `context/now.md` — verificar `phase`
4. Verificar si ya existe `*-solution-strategy.md`:
   - Si existe con decisiones documentadas → Phase 5 ya completó. Proponer `/thyrox:plan`.
5. Listar tech skills activos: `ls .claude/skills/ | grep -v thyrox`

---

## Fase a ejecutar: Phase 5 STRATEGY

Investigar alternativas antes de decidir previene decisiones sin evidencia.

0. REQUERIDO: Leer `skills/workflow-strategy/references/solution-strategy.md` antes de empezar.
   Basar las Key Ideas en los hallazgos de `work/.../discover/` y `work/.../analyze/`.

1. REQUERIDO: Crear `work/.../strategy/{nombre-wp}-solution-strategy.md` usando `assets/solution-strategy.md.template`
   - Nombre descriptivo: `skill-activation-solution-strategy.md`, no `solution-strategy.md`

2. **Key Ideas** — definir conceptos centrales que guían la solución (desde discover/ y analyze/)

3. **Research** — listar unknowns → investigar alternativas → documentar pros/cons por cada uno

4. **Pre-design check** — verificar que las decisiones respetan:
   - ADRs existentes en `context/decisions/`
   - `constitution.md` si existe
   - Restricciones documentadas en Phase 4 CONSTRAINTS (y Phase 1 DISCOVER si Phase 4 no se ejecutó)

5. **Decisions** — documentar decisiones fundamentales con justificación
   - Para decisiones arquitectónicas importantes: crear ADR en `context/decisions/`
   - Usar `../workflow-discover/assets/adr.md.template`

6. **Post-design re-check** — re-verificar después de diseñar
   (las decisiones pueden cambiar al profundizar — revisar consistency con Phase 1)

Ver [solution-strategy](references/solution-strategy.md) para estructura completa (Tech Stack, Patterns, Quality Goals).

---

## Validaciones pre-gate (TD-028, TD-029, TD-031, TD-033)

Antes de presentar el gate 5→6:
- **TD-031 deep review**: revisar `{nombre-wp}-analysis.md` de Phase 1 — ¿la estrategia responde a todos los hallazgos?
- **TD-028 re-evaluación de tamaño**: ¿el WP sigue siendo micro/pequeño/mediano/grande? Si cambió, ajustar fases activas (ver tabla abajo)
- **TD-029 criterios**: `{nombre-wp}-solution-strategy.md` existe con 5 secciones · ADRs creados si aplica
- **TD-033 now.md**: `git add .thyrox/context/now.md` antes de commits y gates

## Re-evaluación de tamaño post-estrategia

Después de completar la estrategia, revisar si el scope cambió respecto al tamaño estimado en Phase 1:

| Si el scope cambió a...    | Siguiente fase | Fases a agregar |
|---------------------------|----------------|-----------------|
| Sigue siendo micro/pequeño | Phase 10 EXECUTE | Ninguna |
| Pasó a mediano/grande      | Phase 6 PLAN   | 6, 7, 8 |

Si el tamaño sube: actualizar `{nombre-wp}-exit-conditions.md` agregando las fases adicionales antes de continuar.

---

## Gate humano

⏸ STOP — Presentar las decisiones clave (Key Ideas, Decisions, alternativas descartadas).
Esperar confirmación explícita. NO continuar sin respuesta.
Al aprobar:
1. Actualizar `context/now.md::phase` a `Phase 6`
2. Actualizar `{nombre-wp}-solution-strategy.md::status` a `Aprobado — {fecha}`

---

## Exit criteria

Phase 5 completa cuando:
- `work/.../*-solution-strategy.md` existe con las 5 secciones obligatorias
- Decisiones documentadas con justificación
- Usuario confirmó la estrategia explícitamente en esta sesión

**Detectar:** Si `work/.../*-solution-strategy.md` existe con decisiones documentadas, Phase 5 ya completó.
Al terminar: proponer `/thyrox:plan` para Phase 6.

---

## Referencias de calibración

> Para análisis de flujos agentic con calibración real (6 patrones operacionales con evidencia de sesión): ver `.claude/references/agentic-calibration-workflow-example.md`

```yml
type: ADR
id: ADR-016
title: Migración de /workflow_* commands → skills hidden
status: Accepted
created_at: 2026-04-08
work_package: 2026-04-08-17-04-20-framework-evolution
depends_on: ADR-015 Addendum (Corrección 1 — 3 modos de triggering)
```

# ADR-016: Migración de `/workflow_*` commands → skills hidden

## Contexto

### Hallazgos que motivaron esta decisión

**H-NEW-2 — Skills hidden como sustituto completo de commands/**

La nueva documentación oficial de Claude Code (Mar 2026) documenta el modo `disable-model-invocation: true` como un frontmatter que convierte un skill en "hidden":
- El modelo NO lo auto-selecciona (no aparece en el Skill tool del modelo)
- El USUARIO puede invocarlo mediante `/<name>` — comportamiento idéntico a commands/
- Soporta frontmatter YAML completo: hooks, description, metadata

Este hallazgo abre una alternativa que no existía en el análisis de ADR-015: migrar los 7 archivos de `commands/` a `skills/` con `disable-model-invocation: true`, manteniendo la UX idéntica para el usuario.

**H-SCHED-1 — Sinergia `/loop` con skills hidden**

La migración a `skills/` permite usar la sinergia `/loop 10m /workflow_execute`:
- El skill `/loop` puede invocar `/<name>` de otros skills
- Los commands/ clásicos también son invocables por `/loop`, pero sin frontmatter (sin hooks automáticos)
- Con skills hidden + frontmatter hooks, cada invocación de `/workflow_execute` actualiza `now.md::phase` automáticamente (once: true)

**Spike T-011 confirmó:** `disable-model-invocation: true` funciona correctamente — el skill creado en `skills/` no apareció en el Skill tool del modelo, confirmando el modo hidden.

### Restricciones relevantes

- `workflow_init.md` es un comando de inicialización de tech skills, no un workflow de fase — no migra
- La UX del usuario (`/<name>`) debe permanecer idéntica
- La migración requiere spike exitoso (completado: T-011 PASS)

---

## Opciones Consideradas

| Opción | Descripción | Pros | Contras |
|--------|------------|------|---------|
| **A — Mantener en commands/** | Sincronizar contenido en commands/ sin cambio de ubicación | Sin riesgo de migración, UX idéntica | Sin frontmatter → sin hooks automáticos; sin sinergia `/loop`; no refleja arquitectura actualizada |
| **B — Migrar a skills hidden** *(elegida)* | Mover a `skills/` con `disable-model-invocation: true` + frontmatter | Hooks automáticos; sinergia `/loop`; refleja arquitectura real (Capa 3 = skills hidden) | Requiere spike de verificación (completado) |
| C — Duplicar en ambos | Mantener commands/ Y crear skills/ | Compatibilidad máxima | Duplicación; mantenimiento doble; contra DA-002 de ADR-015 |

**Opción B elegida** porque: el spike T-011 confirmó que el mecanismo funciona, la UX es idéntica, se ganan hooks automáticos para `now.md::phase`, y la sinergia `/loop` queda habilitada.

---

## Decisión

### D-01: Migrar los 7 `/workflow_*` a `.claude/skills/` con `disable-model-invocation: true`

Los 7 archivos de fase pasan de `.claude/commands/` a `.claude/skills/` con el siguiente frontmatter:

```yaml
---
description: /workflow_{fase} — Phase N: NOMBRE. Inicia o retoma {fase} del work package activo.
disable-model-invocation: true
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "echo 'phase: Phase N' >> .claude/context/now.md"
updated_at: YYYY-MM-DD
---
```

**Hook event:** `UserPromptSubmit` + `once: true` — confirmado en spike T-011 (DA-004).

### D-02: `workflow_init.md` permanece en `commands/`

`workflow_init.md` no es un workflow de fase — es un inicializador de tech skills. No tiene frontmatter de fase ni hooks de `now.md`. Permanece en `commands/`.

### D-03: Eliminar los 7 archivos de `commands/` post-migración

Una vez que los 7 skills estén en `skills/` con contenido sincronizado, eliminar los 7 archivos de `commands/`. `commands/` queda con solo `workflow_init.md`.

### D-04: Actualizar tabla Capa 3 en ADR-015

Capa 3 cambia de "`/workflow_*` commands" a "skills hidden con `disable-model-invocation: true`". Documentado en ADR-015 Addendum Corrección 4.

---

## Implicación sobre la tabla de 5 capas (ADR-015 D-01)

| Capa | Pre-FASE 22 | Post-FASE 22 |
|------|-------------|-------------|
| 0 — Hooks | SessionStart | SessionStart + **Stop** + **PostCompact** |
| 1 — CLAUDE.md | CLAUDE.md | CLAUDE.md + `.claude/rules/` (sublayer) |
| 2 — SKILLs | pm-thyrox (~430 líneas) + N skills | pm-thyrox (~40 líneas catálogo) + N skills + **7 workflow skills hidden** |
| 3 — /workflow_* | 7 archivos en commands/ | **Vacío** (los 7 migran a Capa 2 como hidden) |
| 4 — Agentes nativos | Sin cambio | Sin cambio |

**Nota:** La Capa 3 queda sin contenido post-FASE 22 (solo `workflow_init.md` permanece en commands/ como caso especial). Los 7 workflow skills pasan a Capa 2 como skills hidden — la distinción model-invocable vs user-invocable ocurre dentro de Capa 2.

---

## Criterio de Revisión

Revisar esta decisión cuando:
- Los `/workflow_*` skills queden obsoletos (reemplazados por agentes PTC nativos en Capa 4)
- O cuando Claude Code introduzca un mecanismo de commands/ con soporte de frontmatter equivalente

---

## Status

**Status:** Accepted — 2026-04-08
**Work package:** `2026-04-08-17-04-20-framework-evolution`
**Spike de verificación:** T-011 PASS (ver execution-log del WP)
**Depende de:** ADR-015 Addendum (Corrección 1: 3 modos triggering)

## Addendum — FASE 23 (2026-04-09)

**Cambio de nomenclatura:** Los 7 skills migrados en esta FASE usan guiones (kebab-case) en lugar
de underscores, resolviendo TD-019. Los paths y comandos mencionados en este ADR como
`workflow_analyze`, `workflow_*.md`, `/workflow_{fase}` corresponden ahora a:
`workflow-analyze/SKILL.md`, `workflow-*/SKILL.md`, `/workflow-{fase}`.

El campo `name:` en el frontmatter oficial de Claude Code solo acepta `a-z`, `0-9`, `-` (hyphens)
— underscores no son válidos. La migración a hyphens es el único formato correcto per docs oficiales.

**WP:** `2026-04-08-23-55-52-workflow-restructure`

## Addendum — FASE 31 (2026-04-11)

**Interfaz pública:** A partir de FASE 31, la interfaz pública del framework es `/thyrox:*` (plugin namespace via `.claude-plugin/plugin.json`). Los skills `workflow-*` son la implementación interna — sin cambios en su lógica ni frontmatter. Esta separación interfaz/implementación complementa esta decisión definiendo la capa de presentación.

**Lo que cambia en FASE 31:**
- Nuevo: `.claude-plugin/plugin.json` (manifest del plugin) + `commands/*.md` (thin wrappers)
- Nuevo: `/thyrox:analyze`, `/thyrox:strategy`, … como comandos de usuario final
- Sin cambio: `workflow-*/SKILL.md` — implementación intacta
- `session-start.sh`: strings `/workflow-*` → `/thyrox:*` (solo display)

Ver **ADR-019** para el razonamiento completo de la decisión de plugin.

**WP:** `2026-04-11-10-52-25-thyrox-commands-namespace`

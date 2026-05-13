```yml
created_at: 2026-04-13 20:45:00
type: Requirements Specification (retrospectiva)
wp: 2026-04-12-10-10-50-skill-authoring-modernization
fase: FASE 33
phase: 4 — STRUCTURE (no completada en su momento — stream timeout)
status: Retrospectiva post-ejecución
nota: >
  Este artefacto no pudo crearse durante Phase 4 (múltiples stream idle timeouts
  bloquearon la sesión). Se crea retroactivamente como referencia de investigación.
  El trabajo real ya fue ejecutado y commiteado en Phase 6 (commits C1–C6).
```

# Requirements Spec — skill-authoring-modernization (FASE 33)

> **Nota de contexto:** Este documento es la spec que Phase 4 debería haber producido.
> Fue bloqueado por `CLAUDE_STREAM_IDLE_TIMEOUT_MS` insuficiente (~30s default).
> Se reconstruye post-ejecución como referencia para FASEs similares.
> Ver `lessons-learned.md` L-001..L-003 para el análisis del problema.

---

## Scope

- **18 archivos** en `.claude/references/` (13 CREATE + 5 UPDATE)
- **2 archivos de cierre** (`thyrox/SKILL.md` + `technical-debt.md`)
- **1 fix de referencia** (`scheduled-tasks.md` L284)

---

## SPEC-001: `skill-authoring.md` — UPDATE

**Archivo:** `.claude/references/skill-authoring.md`
**Acción:** Actualizar (840 → ~1163 líneas)
**Gaps cubiertos:** GAP-001, GAP-002, GAP-003, GAP-004, GAP-005, GAP-006, GAP-014, GAP-015

### Secciones a agregar

| Sección nueva | Gap | Contenido requerido | Fuente canónica |
|---------------|-----|--------------------|--------------------|
| Frontmatter completo | GAP-001 | Todos los campos del frontmatter de Skills: `name`, `description`, `user-invocable`, `disable-model-invocation`, `model`, `tools`, `paths`, `context`, `agent` | `claude-code-components.md` §Skills |
| Modos de invocación | GAP-002 | Tres modos: default (LLM evalúa), `disable-model-invocation: true` (tool call directo), `user-invocable: false` (solo programático) | `claude-code-components.md` §invocation |
| Context budget optimization | GAP-003 | `disable-model-invocation: true` reduce context budget; cuándo activarlo; impacto en performance | `claude-code-components.md` §context budget |
| Variables de sustitución | GAP-004 | `$ARGUMENTS`, `$ARGUMENTS[0]..N`, `${CLAUDE_SKILL_DIR}`, `${CLAUDE_SESSION_ID}` — sintaxis y ejemplos | `claude-code-components.md` §variables |
| Inyección dinámica | GAP-005 | Backtick syntax `` `!comando` `` para contexto dinámico al invocar el skill | `claude-code-components.md` §dynamic injection |
| Context isolation | GAP-006 | `context: fork` + campo `agent:` — crear sub-agente aislado desde el skill | `claude-code-components.md` §context |
| Description budget | GAP-014 | Límite de 250 chars, truncación silenciosa, descripción ocupa ~1% del context window total | `claude-code-components.md` §description |
| Activación condicional | GAP-015 | Campo `paths:` — activar skill solo cuando ciertos archivos están en el contexto activo | `claude-code-components.md` §paths |

**Criterio de completitud:**
- [ ] Cada campo del frontmatter tiene tipo, descripción y ejemplo
- [ ] Los 3 modos de invocación tienen tabla comparativa
- [ ] Variables de sustitución tienen ejemplo de uso real
- [ ] `paths:` tiene ejemplo con glob patterns

---

## SPEC-002: `agent-authoring.md` — CREATE

**Archivo:** `.claude/references/agent-authoring.md`
**Acción:** Crear nuevo (~350 líneas)
**Gaps cubiertos:** GAP-007, GAP-008, GAP-009, GAP-010, GAP-011, GAP-012

### Secciones requeridas

| # | Sección | Contenido | Gap | Fuente |
|---|---------|-----------|-----|--------|
| 1 | Cuándo un agente (vs SKILL vs Hook) | Regla de decisión rápida, casos de uso típicos | — | `skill-vs-agent.md` |
| 2 | Frontmatter completo | Todos los campos: `name`, `description`, `tools`, `model`, `skills`, `memory`, `background`, `isolation`, `permissionMode`, `async_suitable` | GAP-007 | `claude-code-components.md` §Subagents |
| 3 | `skills:` field | Cómo inyectar contenido completo de skills en el agente, diferencia con `@import` | GAP-008 | `claude-code-components.md` §skills field |
| 4 | `memory:` — 3 scopes | `user` / `project` / `local` — cuándo usar cada uno, impacto en persistencia | GAP-009 | `claude-code-components.md` §memory |
| 5 | `background: true` | Ejecución asíncrona, patrones de orquestación, `run_in_background` | GAP-010 | `claude-code-components.md` §background |
| 6 | `isolation: worktree` | Git worktree aislado, cleanup automático, casos de uso | GAP-011 | `claude-code-components.md` §isolation |
| 7 | Permission modes (6) | Tabla: `default`, `acceptEdits`, `autoEdit`, `bypassPermissions`, `plan`, `restricted` | GAP-012 | `claude-code-components.md` §permissionMode |
| 8 | Tool restrictions | Cómo restringir herramientas disponibles, `allowed_tools` vs `denied_tools` | — | `agent-spec.md` |
| 9 | Naming y ubicación | `.claude/agents/`, kebab-case, cuándo un agente hereda skills automáticamente | — | `agent-spec.md` |
| 10 | Anti-patrones | No usar `model:` innecesario, no duplicar CLAUDE.md en description, no hacer agentes para tareas de 1 paso | — | Derivado |

**Criterio de completitud:**
- [ ] Tabla de 6 permission modes con columna "cuándo usar"
- [ ] Ejemplos de `skills:` con un skill real del proyecto
- [ ] Diferencia `background: true` vs `run_in_background` en el Agent tool explicada

---

## SPEC-003: `claude-authoring.md` — CREATE

**Archivo:** `.claude/references/claude-authoring.md`
**Acción:** Crear nuevo (~280 líneas)

### Secciones requeridas

| # | Sección | Contenido | Fuente |
|---|---------|-----------|--------|
| 1 | Regla core | CLAUDE.md = instrucciones universales que aplican SIN excepción a TODA sesión | `skill-vs-agent.md` |
| 2 | Jerarquía de 4 niveles | enterprise → user → project → subdirectorio — precedencia y merging | `memory-hierarchy.md` |
| 3 | `@path/to/file` imports | Sintaxis, cuándo usar, límite de profundidad, ciclos | `claude-howto/02-memory/` |
| 4 | `/init` command | Bootstrapping desde cero, qué genera, cuándo invocar | `claude-howto/02-memory/` |
| 5 | Estructura recomendada | Secciones tipo: Locked Decisions, Reglas de edición, Flujo de sesión, Configuración | THYROX CLAUDE.md |
| 6 | Límites de tamaño | Cuándo hacer split con @imports, umbral razonable (~200 líneas) | Derivado |
| 7 | Qué NO incluir | Condicional → SKILL, side effects → Agent, reacción a evento → Hook | `skill-vs-agent.md` |
| 8 | Anti-patrones | CLAUDE.md como SKILL, instrucciones que aplican solo a veces, workflows larges inline | Derivado |

**Criterio de completitud:**
- [ ] La regla "CLAUDE.md = universal sin excepción" está en la primera sección, en bold
- [ ] La jerarquía tiene diagrama o tabla con ejemplos de path reales
- [ ] Anti-patrones tienen contraejemplo correcto al lado

---

## SPEC-004: `hook-authoring.md` — CREATE

**Archivo:** `.claude/references/hook-authoring.md`
**Acción:** Crear nuevo (~320 líneas)

### Secciones requeridas

| # | Sección | Contenido | Fuente |
|---|---------|-----------|--------|
| 1 | Cuándo un Hook es correcto | Acción determinística ante evento del sistema — no LLM | `hooks.md` |
| 2 | Tipos de eventos — tabla completa | PreToolUse, PostToolUse, Stop, SessionStart, SessionResume, Notification, etc. | `hooks.md` |
| 3 | Configuración en settings.json | `hooks:`, `event:`, `command:`, `matcher:`, timeout | `hooks.md` |
| 4 | Output control — semántica | `suppressOutput` (suprime stdout del hook, NO el tool result), `additionalContext`, `updatedInput`, `permissionDecision` | `hook-output-control.md` |
| 5 | Patrones de uso | sync-state, pre-flight check, logging, notificación de equipo | `claude-howto/06-hooks/` |
| 6 | Errores frecuentes | Archivo no ejecutable (`chmod +x`), paths relativos vs absolutos, stdout contaminado | `hook-output-control.md` |
| 7 | Testing de hooks | Cómo probar un hook aislado, `echo` para debug, errores silenciosos | Derivado |

**Criterio de completitud:**
- [ ] Tabla de eventos tiene columna "disponible en" (CLI / Desktop / Web)
- [ ] `suppressOutput` tiene nota EXPLÍCITA: "suprime stdout del hook, NO el resultado del tool"
- [ ] Al menos 2 ejemplos de hook completos (script + configuración en settings.json)

---

## SPEC-005: `component-decision.md` — CREATE

**Archivo:** `.claude/references/component-decision.md`
**Acción:** Crear nuevo (~250 líneas)
**Gap cubierto:** GAP-013

### Secciones requeridas

| # | Sección | Contenido | Fuente |
|---|---------|-----------|--------|
| 1 | Flowchart de decisión | Mermaid — árbol de decisión: ¿aplica siempre? → CLAUDE.md; ¿reacciona a evento? → Hook; ¿tarea autónoma compleja? → Agent; ¿instrucción bajo demanda? → SKILL | Análisis Phase 1 |
| 2 | Tabla comparativa 6 tipos | SKILL / CLAUDE.md / Agent / Hook / Plugin / Command — columnas: cuándo, persistencia, trigger, ejemplo | Análisis Phase 1 |
| 3 | Regla rápida por tipo | 1 línea memorable por tipo (e.g. "Hook = acción determinística ante evento del sistema") | Derivado |
| 4 | Casos concretos | 4 casos: refactor skill, directory-specific CLAUDE.md, secure-reviewer Agent, brand-voice SKILL | Análisis Phase 1 §5 |
| 5 | Casos ambiguos | Cómo resolver cuando hay 2+ opciones válidas — criterio de desempate | Análisis Phase 1 §4 |
| 6 | Anti-patrones | Agent como CLAUDE.md, Hook como SKILL, Plugin cuando bastaría un Command | Derivado |

**Criterio de completitud:**
- [ ] Flowchart renderizable en GitHub (mermaid válido)
- [ ] Tabla comparativa cubre los 6 tipos (no solo 4)
- [ ] Al menos 1 caso ambiguo con resolución documentada

---

## SPEC-006..SPEC-018: Grupos B, C, D

> Ver `skill-authoring-modernization-plan.md` §2 para descripción completa de cada archivo.
> Todos fueron ejecutados en Phase 6. Spec retrospectiva simplificada:

| SPEC | Archivo | Secciones principales | Fuente canónica |
|------|---------|----------------------|----------------|
| SPEC-006 | `advanced-features.md` | Planning Mode, Extended Thinking, Auto Mode, Worktrees, Sandboxing, Agent Teams, Channels | `claude-howto/09-advanced-features/` |
| SPEC-007 | `cli-reference.md` | Todos los flags, 30+ env vars con descripción, subcomandos `claude auth/mcp/agents` | `claude-howto/10-cli/` |
| SPEC-008 | `memory-patterns.md` | Patrones de estado (now.md/focus.md), @imports, auto-memory, memory: en subagents | `memory-hierarchy.md` |
| SPEC-009 | `tool-patterns.md` | Herramienta correcta por tarea (tabla), parallel calls, Edit vs Write, restricciones | `tool-execution-model.md` |
| SPEC-010 | `testing-patterns.md` | SDD práctico, CI/CD con `claude -p`, code review automation | `sdd.md` |
| SPEC-011 | `multimodal.md` | Leer imágenes/PDFs/notebooks/screenshots con Read tool, limitaciones | Claude Code docs |
| SPEC-012 | `output-formats.md` | `--output-format`, `--json-schema`, jq patterns, structured output | `claude-howto/10-cli/` |
| SPEC-013 | `stream-resilience.md` | `CLAUDE_STREAM_IDLE_TIMEOUT_MS`, TTFToken, StopFailure, `--resume`, recovery | `claude-howto/06-hooks/` + `10-cli/` |
| SPEC-014 | `streaming-errors.md` | Catálogo de errores (causas/fixes), anti-patrón diagnóstico, matriz de diagnóstico | `claude-howto/06-hooks/` + `10-cli/` |
| SPEC-015 | `long-running-calls.md` | `--max-turns`, background vs print mode, síntesis del padre, worktrees, checkpoints | `claude-howto/10-cli/` + `04-subagents/` |
| SPEC-016 | `mcp-integration.md` (update) | +85 líneas: `claude mcp serve`, code-execution-with-MCP, env var expansion | `claude-howto/10-cli/` |
| SPEC-017 | `plugins.md` (update) | +81 líneas: restricciones seguridad subagents-in-plugins, `bin/`, `claude plugin` | `claude-howto/07-plugins/` |
| SPEC-018 | `scheduled-tasks.md` (fix L284) | 1 línea: `/tmp/reference/...` → `advanced-features.md` local | — |

---

## Criterios de no-duplicación

| Regla | Descripción |
|-------|-------------|
| ND-01 | `agent-authoring.md` documenta GAP-007..012 — `skill-authoring.md` NO menciona campos de agentes |
| ND-02 | `component-decision.md` absorbe GAP-013 completo — no duplicar flowchart en otros archivos |
| ND-03 | `hooks.md` y `hook-output-control.md` son fuentes canónicas — `hook-authoring.md` referencia, no duplica |
| ND-04 | `claude-code-components.md` no se modifica — es fuente de verdad |
| ND-05 | `plugins.md` solo recibe adición mínima — no se reescribe |

---

## Estrategia de ejecución (Phase 6)

Esta spec fue la base para la ejecución con 4 agentes paralelos:

| Agente | SPECs | Estado real |
|--------|-------|-------------|
| Agent-A | SPEC-001..005 (authoring group) | Completado — commits `d02fb5f`, `850d1d8` |
| Agent-B | SPEC-006..007 (platform) | Completado — commit `0e8174b` |
| Agent-C | SPEC-008..012 (patterns) | Completado — commit `583a937` |
| Agent-D | SPEC-013..018 (streaming + updates) | Completado — commits `1f18ea8`, `1357f3c`, `1c2f29d` |

---

## Por qué Phase 4 falló (referencia)

Ver `lessons-learned.md` L-001..L-003:

1. **L-001** — TTFToken = f(tamaño del contexto). Con ~300KB de contexto acumulado, el tiempo hasta el primer token superó el `CLAUDE_STREAM_IDLE_TIMEOUT_MS` default (~30s).
2. **L-002** — `settings.json` se lee al arrancar. El fix de `CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000` requería reiniciar la sesión.
3. **L-003** — Diagnosticar el timeout dentro de la sesión afectada (4 diagramas Ishikawa) agravó el problema.

**Fix aplicado:** Nueva sesión con `CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000` + Phase 4 omitida por aprobación explícita del usuario. Se procedió a Phase 6 con el plan de Phase 3 como guía.

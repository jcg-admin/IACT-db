---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-howto
domain: context-scope
repo: claude-howto
---

# Context-Scope: Hallazgos de claude-howto

## Patrones identificados

### Patrón 1 — Memory hierarchy de 8 niveles con precedencia explícita
**Descripción:** Claude Code carga memoria en orden estricto de precedencia: (1) Managed Policy (sistema), (2) Managed Drop-ins, (3) Project Memory (CLAUDE.md), (4) Project Rules (.claude/rules/), (5) User Memory (~/.claude/CLAUDE.md), (6) User Rules (~/.claude/rules/), (7) Local Project Memory (CLAUDE.local.md), (8) Auto Memory. Los niveles superiores tienen mayor precedencia.
**Fuente:** 02-memory/README.md:213-239
**Relevancia:** Alta

### Patrón 2 — Auto Memory como capa de aprendizaje automático
**Descripción:** Auto Memory (`~/.claude/projects/<project>/memory/`) es escrita por Claude durante sesiones, no por el usuario. La entrypoint es MEMORY.md (primeras 200 líneas / 25KB cargadas en startup). Topic files se cargan on-demand, no en startup. Requiere v2.1.59+.
**Fuente:** 02-memory/README.md:406-495
**Relevancia:** Alta

### Patrón 3 — Skill description budget y progressive disclosure
**Descripción:** Las descripciones de skills (Level 1 metadata) están limitadas al 1% del context window (fallback: 8,000 chars). Solo se carga el nombre en startup; las instrucciones (Level 2) se cargan cuando se activa el skill; los recursos bundled (Level 3) se cargan on-demand. Esto permite tener muchos skills sin penalidad de contexto.
**Fuente:** 03-skills/README.md:30-63, 99-103
**Relevancia:** Alta

### Patrón 4 — claudeMdExcludes para monorepos
**Descripción:** En monorepos grandes, `claudeMdExcludes` en settings permite excluir CLAUDE.md files específicos del contexto usando glob patterns. Útil para CLAUDE.md de vendors o sub-proyectos irrelevantes.
**Fuente:** 02-memory/README.md:274-290
**Relevancia:** Media

### Patrón 5 — @import syntax para context sin duplicación
**Descripción:** CLAUDE.md soporta `@path/to/file` para incluir contenido externo. Soporta paths relativos y absolutos, recursividad hasta depth 5, approval dialog en primera importación externa. No se evalúa dentro de code spans.
**Fuente:** 02-memory/README.md:170-191
**Relevancia:** Alta

### Patrón 6 — Context window monitoring con /context
**Descripción:** El comando `/context` visualiza el uso del context window como un colored grid. También muestra warnings cuando hay demasiados skills y se truncan sus descripciones.
**Fuente:** 01-slash-commands/README.md:60, 03-skills/README.md:729
**Relevancia:** Media

### Patrón 7 — "Summarize from checkpoint" como gestión activa del contexto
**Descripción:** En checkpoints, la opción "Summarize from here" comprime la conversación desde ese punto hacia adelante en un AI-generated summary, liberando context window. Los mensajes originales se preservan en el transcript. Solo afecta el contexto visible, no los archivos.
**Fuente:** 08-checkpoints/README.md:52-57, checkpoint-examples.md:318-331
**Relevancia:** Alta

### Patrón 8 — cc-context-stats para monitoreo en tiempo real
**Descripción:** El proyecto referencia `cc-context-stats` (GitHub: luongnv89/cc-context-stats) como herramienta externa que agrega context zones al status bar: Plan (verde), Code (amarillo), Dump (naranja). Cuando el zone cambia, es señal de hacer checkpoint y empezar fresh.
**Fuente:** 08-checkpoints/README.md:288-291
**Relevancia:** Media

### Patrón 9 — Subagent memory scope controlable
**Descripción:** Subagents pueden tener su propio directorio de memoria persistente via el campo `memory` en frontmatter. Scopes: `user` (`~/.claude/agent-memory/<name>/`), `project` (`.claude/agent-memory/<name>/`), `local`. Las primeras 200 líneas de MEMORY.md se auto-cargan en el system prompt del subagent.
**Fuente:** 04-subagents/README.md:416-458
**Relevancia:** Alta

### Patrón 10 — --add-dir para contexto multi-directorio
**Descripción:** El flag `--add-dir` permite cargar CLAUDE.md de directorios adicionales más allá del cwd. Requiere `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`.
**Fuente:** 02-memory/README.md:516-531
**Relevancia:** Baja

## Conceptos clave

- **CLAUDE.local.md** — personal overrides por proyecto, no va a git. Usar .gitignore.
- **Managed Policy** — archivos de sistema: macOS `/Library/Application Support/ClaudeCode/CLAUDE.md`, Linux `/etc/claude-code/CLAUDE.md`, Windows `C:\Program Files\ClaudeCode\CLAUDE.md`
- **Settings hierarchy** de 5 niveles: managed policy > managed-settings.d/ > user settings > project settings > local settings
- **Path-specific rules** — YAML frontmatter `paths: src/api/**/*.ts` en `.claude/rules/` para activar reglas solo en ciertas rutas
- **`CLAUDE_CODE_DISABLE_AUTO_MEMORY`** env var — controla auto memory: `0` = forzar on, `1` = forzar off

## Notas adicionales

El patrón más importante para gestión del contexto es la combinación de: (a) progressive disclosure en skills para no desperdiciar tokens, (b) checkpoint + summarize para sesiones largas, y (c) claudeMdExcludes para monorepos.

La documentación del repo es muy clara en que CLAUDE.md debe mantenerse bajo 300 líneas (idealmente bajo 100). "Less is More" es la regla principal para CLAUDE.md efectivos.

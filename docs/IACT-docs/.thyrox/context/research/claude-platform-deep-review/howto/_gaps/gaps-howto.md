---
type: deep-review-gaps
created_at: 2026-04-14
source: /tmp/reference/claude-howto/
topic: gaps vs .claude/references/ (36 archivos existentes)
---

# Gaps — Claude How-To vs .claude/references/

Análisis de topics presentes en claude-howto que NO están cubiertos (o están cubiertos parcialmente) en los 36 archivos de referencia existentes en `.claude/references/`.

## Referencias existentes (36 archivos)

Para referencia del lector: los 36 archivos en `.claude/references/` cubren estos dominios:
`advanced-features`, `agent-authoring`, `agent-spec`, `benchmark-skill-vs-claude`, `checkpointing`, `claude-authoring`, `claude-code-components`, `cli-reference`, `command-execution-model`, `component-decision`, `conventions`, `examples`, `hook-authoring`, `hook-output-control`, `hooks`, `long-context-tips`, `long-running-calls`, `mcp-integration`, `memory-hierarchy`, `memory-patterns`, `multimodal`, `output-formats`, `permission-model`, `plugins`, `prompting-tips`, `scheduled-tasks`, `sdd`, `skill-authoring`, `skill-vs-agent`, `state-management`, `stream-resilience`, `streaming-errors`, `subagent-patterns`, `testing-patterns`, `tool-execution-model`, `tool-patterns`

---

## Gaps encontrados: 11

### Gap 1 — Clean Code Rules para generación de código

- Origen: `clean-code-rules.md`, todo el archivo
- Estado en references: No cubierto
- Descripción: El repo tiene un archivo completo de reglas de código limpio (funciones <20 líneas, single responsibility, error handling con excepciones, etc.) destinado a guiar la generación de código por Claude. Ningún reference file existente cubre estándares de calidad de código generado.
- Impacto: Medio — afecta la consistencia del código producido por el proyecto
- Acción recomendada: Crear `code-quality-rules.md` con las reglas de Clean Code adaptadas al stack del proyecto (Node.js, React, Python)

### Gap 2 — Auto Memory architecture y `claudeMdExcludes`

- Origen: `02-memory/README.md`, sección Auto Memory; sección `claudeMdExcludes`
- Estado en references: Cubierto parcialmente — `memory-hierarchy.md` cubre los 8 niveles pero NO cubre Auto Memory (escritura automática por Claude en `~/.claude/projects/`) ni `claudeMdExcludes` (exclusión de archivos de la memoria automática)
- Impacto: Alto — Auto Memory es un mecanismo activo que puede generar memoria no esperada; `claudeMdExcludes` es la herramienta de control
- Acción recomendada: Actualizar `memory-hierarchy.md` con sección de Auto Memory y `claudeMdExcludes`

### Gap 3 — Refactoring methodology (Martin Fowler catalog)

- Origen: `03-skills/refactor/references/refactoring-catalog.md`; `03-skills/refactor/SKILL.md`
- Estado en references: No cubierto
- Descripción: El repo incluye un catálogo completo de refactorings de Martin Fowler con ejemplos de código: Extract Method, Inline Method, Introduce Parameter Object, Replace Conditional with Polymorphism, etc. También un workflow de 6 fases para refactoring seguro con mapeo de code smells a refactorings.
- Impacto: Medio — útil para cualquier sesión de refactoring guiado por Claude
- Acción recomendada: Crear `refactoring-patterns.md` con el catálogo y el workflow de 6 fases

### Gap 4 — MCP Apps y MCP Elicitation

- Origen: `05-mcp/README.md`, secciones MCP Apps y MCP Elicitation
- Estado en references: No cubierto — `mcp-integration.md` cubre MCP general pero no MCP Apps (componentes UI interactivos dentro de herramientas MCP) ni MCP Elicitation (solicitud de input adicional al usuario, v2.1.49+)
- Impacto: Medio — MCP Elicitation cambia el modelo de interacción; MCP Apps habilita UI dentro de MCP
- Acción recomendada: Actualizar `mcp-integration.md` con secciones de MCP Apps y MCP Elicitation

### Gap 5 — Agent Teams (experimental) y TeammateIdle/TaskCompleted hooks

- Origen: `04-subagents/README.md`, sección Agent Teams; `06-hooks/README.md`, eventos TeammateIdle y TaskCompleted
- Estado en references: No cubierto — `subagent-patterns.md` cubre patrones de subagentes pero no el sistema experimental de Agent Teams (shared task list + mailbox, `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`)
- Impacto: Bajo (experimental) pero relevante si se adopta paralelismo avanzado
- Acción recomendada: Agregar sección en `subagent-patterns.md` o crear `agent-teams.md` cuando el feature salga de experimental

### Gap 6 — `!`command`` dynamic context injection en skills

- Origen: `01-slash-commands/README.md`, sección Dynamic Context; `01-slash-commands/commit.md`
- Estado en references: No cubierto — `skill-authoring.md` cubre authoring de skills pero no el mecanismo `!`command`` para inyectar output de comandos bash como contexto dinámico
- Impacto: Alto — `!`command`` es una feature de alto valor para skills que necesitan estado del sistema (git status, env vars, etc.)
- Acción recomendada: Actualizar `skill-authoring.md` con sección de dynamic context injection

### Gap 7 — Worktree isolation en subagentes

- Origen: `04-subagents/README.md`, sección Worktree Isolation; frontmatter `isolation: worktree`
- Estado en references: No cubierto — `subagent-patterns.md` no menciona `isolation: worktree` como patrón de aislamiento
- Impacto: Alto — worktree isolation es el mecanismo para paralelismo seguro sin conflictos de git
- Acción recomendada: Actualizar `subagent-patterns.md` con patrón de worktree isolation

### Gap 8 — Plugin userConfig con keychain y ${CLAUDE_PLUGIN_DATA}

- Origen: `07-plugins/README.md`, secciones userConfig, CLAUDE_PLUGIN_DATA, LSP support
- Estado en references: Cubierto parcialmente — `plugins.md` cubre arquitectura general pero no `userConfig` con keychain storage, `${CLAUDE_PLUGIN_DATA}` como directorio de estado persistente, ni soporte LSP via `.lsp.json`
- Impacto: Medio — necesario para plugins que requieren credenciales o estado persistente
- Acción recomendada: Actualizar `plugins.md` con secciones de state management y credential handling

### Gap 9 — Planning Mode (`/plan` + `opusplan` model)

- Origen: `09-advanced-features/planning-mode-examples.md`; `10-cli/README.md`, sección Models
- Estado en references: Cubierto parcialmente — `advanced-features.md` menciona planning mode pero no documenta el workflow completo (plan → review → approve → execute) ni los 5 escenarios con estimaciones de tiempo
- Impacto: Medio — planning mode es una estrategia de reducción de riesgo para proyectos complejos
- Acción recomendada: Actualizar `advanced-features.md` con sección expandida de Planning Mode + workflow

### Gap 10 — `cc-context-stats` integration para monitoreo de context window

- Origen: `08-checkpoints/README.md`, sección Context Monitoring
- Estado en references: No cubierto — `long-context-tips.md` tiene tips para contextos largos pero no menciona la integración específica de `cc-context-stats` como herramienta de monitoreo de uso de tokens en tiempo real
- Impacto: Bajo-Medio — herramienta práctica para proyectos con contextos grandes
- Acción recomendada: Actualizar `long-context-tips.md` con sección de cc-context-stats

### Gap 11 — Voice Dictation, Channels (Discord/Telegram), Web Sessions

- Origen: `09-advanced-features/README.md`; `LEARNING-ROADMAP.md`, sección New Features
- Estado en references: No cubierto — `advanced-features.md` existe pero no cubre Voice Dictation (STT 20 idiomas), Channels (integración Discord/Telegram, Research Preview), ni Web Sessions
- Impacto: Bajo (features periféricas para el proyecto actual) pero completan el panorama de la plataforma
- Acción recomendada: Actualizar `advanced-features.md` con subsecciones de estos features

---

## Items correctamente cubiertos: 25+

Los siguientes topics del repo claude-howto tienen cobertura adecuada en los references existentes:

| Topic howto | Cubierto en reference |
|-------------|----------------------|
| Memory 8-level hierarchy | `memory-hierarchy.md` |
| Memory patterns y path-specific | `memory-patterns.md` |
| CLAUDE.md authoring y golden rules | `claude-authoring.md` |
| Skill progressive disclosure | `skill-authoring.md` |
| Skill vs Agent decision | `skill-vs-agent.md` |
| Skill frontmatter fields | `claude-code-components.md` |
| Hook system (26 events) | `hooks.md` |
| Hook authoring patterns | `hook-authoring.md` |
| Hook output control (JSON) | `hook-output-control.md` |
| MCP general + transports + OAuth | `mcp-integration.md` |
| Plugin architecture | `plugins.md` |
| Subagent patterns + isolation | `subagent-patterns.md` |
| Agent authoring | `agent-authoring.md` |
| Checkpoint / rewind | `checkpointing.md` |
| CLI reference + flags | `cli-reference.md` |
| Command execution model | `command-execution-model.md` |
| Permission model | `permission-model.md` |
| Tool execution model | `tool-execution-model.md` |
| Long context tips | `long-context-tips.md` |
| State management | `state-management.md` |
| Streaming errors | `streaming-errors.md` |
| Stream resilience | `stream-resilience.md` |
| Testing patterns | `testing-patterns.md` |
| Scheduled tasks | `scheduled-tasks.md` |
| Component decision matrix | `component-decision.md` |

---

## Recomendación

**Crear 3 nuevos reference files + actualizar 5 existentes.**

### Nuevos (alto valor):
1. `code-quality-rules.md` — Clean Code rules para generación de código (Gap 1)
2. `refactoring-patterns.md` — Fowler catalog + workflow 6 fases (Gap 3)
3. `agent-teams.md` — cuando Agent Teams salga de experimental (Gap 5, diferido)

### Actualizaciones (prioridad alta):
1. `memory-hierarchy.md` — agregar Auto Memory + `claudeMdExcludes` (Gap 2)
2. `skill-authoring.md` — agregar `!`command`` dynamic context injection (Gap 6)
3. `subagent-patterns.md` — agregar worktree isolation (Gap 7)
4. `mcp-integration.md` — agregar MCP Apps + MCP Elicitation (Gap 4)
5. `plugins.md` — agregar userConfig/keychain + CLAUDE_PLUGIN_DATA (Gap 8)

### Actualizaciones (prioridad baja):
- `advanced-features.md` — Planning Mode workflow + Voice/Channels/Web (Gaps 9, 11)
- `long-context-tips.md` — cc-context-stats integration (Gap 10)

---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-code-ultimate-guide
domain: constraints
repo: claude-code-ultimate-guide
---

# Restricciones y Limitaciones: Hallazgos de claude-code-ultimate-guide

## Patrones identificados

### Patrón 1 — Context window de 200K tokens con presupuesto real ~140-150K
**Descripción:** El contexto de 200K tokens se divide en: system prompt (5-15K), CLAUDE.md files (1-10K), conversation history (variable), tool results (variable), response buffer (40-45K). El espacio usable real es ~140-150K tokens.
**Fuente:** core/architecture.md:326-360
**Relevancia:** Alta

### Patrón 2 — Sub-agents limitados a depth=1
**Descripción:** La herramienta Task spawna sub-agentes que no pueden spawn sub-sub-agentes. Profundidad máxima = 1. Previene explosión recursiva, contaminación de contexto y costos impredecibles.
**Fuente:** core/architecture.md:492-558
**Relevancia:** Alta

### Patrón 3 — Límite de MCPs: <10 servidores, <80 tools totales
**Descripción:** Anthropic recomienda menos de 10 MCP servers activos por proyecto y menos de 80 herramientas totales. Más allá de estos umbrales, la sobrecarga de definiciones de herramientas consume 15-20K tokens del presupuesto de contexto.
**Fuente:** core/context-engineering.md:535-553
**Relevancia:** Alta

### Patrón 4 — Sesiones locales, no sincronizadas
**Descripción:** Las sesiones se almacenan localmente en `~/.claude/projects/<encoded-path>/`. No se sincronizan entre máquinas. El resume (`--resume`) está limitado al directorio de trabajo donde se creó la sesión (path-encoded).
**Fuente:** ops/observability.md:128-138
**Relevancia:** Media

### Patrón 5 — Degradación predictable en sesiones largas
**Descripción:** 15-25 turns: drift de constraints. 80-100K tokens: instrucciones del inicio ignoradas. >5 archivos simultáneos: cambios inconsistentes. El modelo no "colapsa" sino que gradualmente prioriza contexto reciente sobre el anterior.
**Fuente:** core/architecture.md:449-463
**Relevancia:** Alta

### Patrón 6 — Desktop App no disponible en Linux
**Descripción:** Claude Code Desktop solo está disponible en macOS y Windows. Linux únicamente tiene acceso al CLI. Features exclusivas del Desktop (visual diff, live preview, PR monitoring, file attachments) no están disponibles para usuarios de Linux.
**Fuente:** ultimate-guide.md:335-339
**Relevancia:** Media

### Patrón 7 — Chain-of-thought puede degradar performance en tareas largas
**Descripción:** Los datos de ingeniería de Anthropic muestran que el CoT puede reducir el rendimiento en tareas agenticas largas (+20 tool calls). Los tokens de razonamiento extienden el contexto, acelerando el context rot. Regla: usar CoT para pasos de razonamiento aislados complejos, no como estrategia general.
**Fuente:** core/context-engineering.md:155-159
**Relevancia:** Media

### Patrón 8 — Paths siempre protegidos incluso en bypassPermissions
**Descripción:** `.git/`, `.claude/`, archivos de shell config (`.bashrc`, `.zshrc`) y configs de herramientas (`.gitconfig`, `.mcp.json`, `.claude.json`) siempre requieren confirmación, incluso en modo `--dangerously-skip-permissions`.
**Fuente:** ultimate-guide.md:1076-1088
**Relevancia:** Alta

## Conceptos clave

- 200K nominal ≠ 200K usable (sistema ocupa ~50-60K de overhead)
- Sub-agents: depth=1, no más
- MCP budget: cada servidor añade tokens de overhead
- Sesiones son locales y path-scoped
- CoT tiene trade-offs en tareas largas
- Algunos paths son inmutables por diseño de seguridad

## Notas adicionales

El flag `ANTHROPIC_MODEL` en variables de entorno tiene precedencia sobre el setting `model` en settings.json. El flag `cleanupPeriodDays: 0` elimina todas las sesiones al inicio y deshabilita la persistencia de sesiones — útil para entornos con datos sensibles pero destructivo para flujos de trabajo normales.

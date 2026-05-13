---
type: deep-review-domain
created_at: 2026-04-14
source: /tmp/reference/claude-howto/
topic: architecture
---

# Architecture — Claude Code How-To

## Patrones

### Patrón 1: Jerarquía de memoria de 8 niveles con precedencia explícita

La arquitectura de memoria tiene 8 niveles ordenados por precedencia (mayor → menor):
1. Managed Policy (enterprise, inmutable)
2. Managed Drop-ins (enterprise, parcialmente configurable)
3. Project Memory (CLAUDE.md en raíz del proyecto)
4. Project Rules (.claude/rules/*.md)
5. User Memory (~/.claude/CLAUDE.md)
6. User Rules (~/.claude/rules/*.md)
7. Local Project Memory (CLAUDE.local.md, gitignored)
8. Auto Memory (escritura automática en ~/.claude/projects/)

La precedencia es top-down: niveles superiores sobreescriben inferiores. Esta arquitectura permite layering de contexto desde enterprise hasta personal.

Fuente: `02-memory/README.md`, sección Memory Hierarchy.

### Patrón 2: Skills como sistema de invocación con 3 niveles de carga

Las skills tienen arquitectura de progressive disclosure con 3 niveles:
- **Level 1 (minimal)**: SKILL.md con frontmatter + descripción corta. Se carga siempre.
- **Level 2 (standard)**: Contenido completo del SKILL.md. Se carga cuando se invoca la skill.
- **Level 3 (verbose)**: Referencias adicionales en `references/`. Se carga on-demand.

El `SLASH_COMMAND_TOOL_CHAR_BUDGET` controla el budget de Level 2. Los `@imports` en SKILL.md cargan referencias de Level 3. Esta arquitectura minimiza tokens por defecto.

Fuente: `03-skills/README.md`, sección Progressive Disclosure.

### Patrón 3: Hook system con 26 eventos y 4 tipos de handlers

Los 26 eventos se organizan por ciclo de vida:
- Session: SessionStart, SessionEnd
- Conversation: ConversationStart, PreMessage, PostMessage
- Tools: PreTool, PostTool (+ variantes por herramienta específica)
- Git: PreCommit, PostCommit, PrePush
- Agents: AgentStart, AgentEnd, TeammateIdle, TaskCompleted
- Permissions: PermissionDenied

Los 4 tipos de handlers: command (bash script), http (webhook), prompt (instrucciones al modelo), agent (subagente dedicado).

Fuente: `06-hooks/README.md`, tabla de 26 eventos.

### Patrón 4: Plugin architecture con 4 fuentes y estado persistente

Los plugins tienen arquitectura multi-source:
- npm packages
- pip packages
- git-subdir (subdirectorio de un repo git)
- GitHub (directamente desde repo)

Cada plugin tiene: `.claude-plugin/plugin.json` (manifiesto), `${CLAUDE_PLUGIN_DATA}` (directorio de estado persistente entre sesiones), `userConfig` con keychain para credenciales, LSP support via `.lsp.json`.

Fuente: `07-plugins/README.md`, secciones Plugin Sources y State Management.

### Patrón 5: Subagent architecture con frontmatter de configuración

Los subagentes se definen como archivos markdown con frontmatter YAML. Campos disponibles:
- `memory`: archivos CLAUDE.md adicionales a cargar
- `background`: ejecutar en background (boolean)
- `isolation: worktree`: sandbox en git worktree separado
- `initialPrompt`: prompt de activación automática
- `hooks`: hooks propios del agente
- `skills`: skills disponibles para el agente
- `mcpServers`: MCP servers accesibles al agente
- `effort`: low/medium/high
- `model`: modelo específico a usar

Fuente: `04-subagents/README.md`, sección Frontmatter Fields.

### Patrón 6: MCP con transports múltiples y OAuth 2.0

MCP soporta 3 transports: HTTP (recomendado), Stdio, SSE (deprecated). La autenticación usa OAuth 2.0 con `authServerMetadataUrl` para override del discovery endpoint. Los MCP Apps son componentes de UI interactivos que viven dentro de herramientas MCP. El tool search (`ENABLE_TOOL_SEARCH`) es auto-enabled para repos con muchas herramientas.

Fuente: `05-mcp/README.md`, secciones Transports, Authentication, MCP Apps.

## Conceptos

- **Layered context**: memoria como stack de 8 niveles con precedencia explícita
- **Progressive disclosure**: skills que cargan más contexto solo cuando se necesita
- **Event-driven automation**: hooks como sistema de eventos para automatización
- **Composable agents**: subagentes configurables via frontmatter como building blocks
- **Plugin namespace**: `.claude-plugin/` como convención de empaquetado de extensiones

## Notas

La arquitectura general de Claude Code sigue el patrón "small primitives + composición". Cada feature (memoria, skills, hooks, MCP, subagentes, plugins) es ortogonal a los demás y se pueden combinar. Esta ortogonalidad es un diseño explícito que el repo documenta en su filosofía de "combinations over features".

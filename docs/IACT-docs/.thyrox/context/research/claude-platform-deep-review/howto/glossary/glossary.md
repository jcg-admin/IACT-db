---
type: deep-review-domain
created_at: 2026-04-14
source: /tmp/reference/claude-howto/
topic: glossary
---

# Glossary — Claude Code How-To

## Patrones

### Patrón 1: Terminología de features con nombres oficiales vs nombres anteriores

El repo documenta la evolución del naming:
- "Slash Commands" → "Skills" (v2.0+). El repo mantiene "01-slash-commands/" por compatibilidad pero clarifica que el término correcto actual es "skills".
- "Custom commands" → legacy term; "skill" es el término actual
- "Claude CLI" → no usar; "Claude Code" es el nombre oficial

El glosario implícito del repo incluye advertencias sobre nomenclatura deprecada.

Fuente: `STYLE_GUIDE.md`, sección Vocabulary; `01-slash-commands/README.md`.

### Patrón 2: Definiciones de artefactos de configuración

Términos técnicos con definiciones precisas en el repo:

- **CLAUDE.md**: archivo de memoria primario del proyecto. Cargado automáticamente en cada sesión. Límite recomendado: 300 líneas.
- **SKILL.md**: archivo de definición de una skill. Contiene frontmatter YAML + instrucciones del agente.
- **Auto Memory**: notas escritas automáticamente por Claude en `~/.claude/projects/<project>/memory/`.
- **Managed Policy**: nivel más alto de la jerarquía de memoria; configurado por administrador enterprise; inmutable para el usuario.
- **Checkpoint**: snapshot del estado de conversación + filesystem creado automáticamente por cada prompt de usuario.
- **Worktree**: rama git aislada usada para ejecutar subagentes sin contaminar el árbol principal.

Fuente: `02-memory/README.md`; `03-skills/README.md`; `04-subagents/README.md`; `08-checkpoints/README.md`.

### Patrón 3: Terminología de agentes y orquestación

- **Subagent**: instancia de Claude Code lanzada por otra instancia para ejecutar tareas paralelas o especializadas.
- **Agent Teams**: sistema experimental donde múltiples subagentes comparten una task list y mailbox. Activado con `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`.
- **TeammateIdle**: evento hook disparado cuando un agente del equipo está inactivo.
- **TaskCompleted**: evento hook disparado cuando un agente completa una tarea asignada.
- **Background agent**: subagente ejecutándose en background; el usuario puede continuar trabajando.
- **Resumable agent**: subagente que puede ser reanudado después de interrumpirse.

Fuente: `04-subagents/README.md`.

### Patrón 4: Terminología de MCP

- **MCP (Model Context Protocol)**: protocolo para conectar Claude Code con servicios externos.
- **MCP Server**: servicio que expone herramientas a Claude Code via MCP.
- **MCP Transport**: mecanismo de comunicación entre Claude Code y un MCP server (HTTP, Stdio, SSE).
- **MCP Elicitation**: capacidad de un MCP tool de solicitar input adicional al usuario interactivamente (v2.1.49+).
- **MCP Apps**: componentes de UI interactivos que viven dentro de herramientas MCP.
- **Tool Search**: feature que permite a Claude buscar herramientas disponibles en MCP servers con muchas herramientas. Activado con `ENABLE_TOOL_SEARCH`.

Fuente: `05-mcp/README.md`.

### Patrón 5: Terminología de hooks

- **Hook**: script o handler que se ejecuta en respuesta a un evento del ciclo de vida de Claude Code.
- **Can Block**: propiedad de un evento que indica si el hook puede detener la operación.
- **Component-scoped hook**: hook definido en el frontmatter de una skill o subagente (solo activo cuando ese componente está activo).
- **`once` field**: campo de hook que indica que el hook solo debe ejecutarse una vez por sesión.
- **PermissionDenied**: evento disparado cuando Claude Code rechaza ejecutar una operación por falta de permisos.

Fuente: `06-hooks/README.md`.

### Patrón 6: Terminología de niveles de skill (effort)

- **low**: tarea simple, sin necesidad de planificación extensa.
- **medium**: tarea moderada, puede requerir múltiples pasos.
- **high**: tarea compleja, requiere planificación y múltiples herramientas.

También usado en subagentes para controlar la profundidad del razonamiento del modelo.

Fuente: `03-skills/README.md`; `04-subagents/README.md`.

## Conceptos

- **Naming evolution**: el ecosistema Claude Code tiene términos deprecados que coexisten con términos actuales
- **Feature-specific vocabulary**: cada módulo (MCP, hooks, subagentes) tiene terminología propia
- **Frontmatter vocabulary**: los campos de frontmatter son en sí mismos un vocabulario técnico del ecosistema

## Notas

El repo no tiene un glosario centralizado — los términos se definen en contexto dentro de cada módulo. Esto facilita el aprendizaje progresivo pero dificulta la referencia rápida. Un glosario centralizado sería un gap de documentación a considerar.

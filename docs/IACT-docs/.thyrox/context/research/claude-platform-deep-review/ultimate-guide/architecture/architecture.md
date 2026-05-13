---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-code-ultimate-guide
domain: architecture
repo: claude-code-ultimate-guide
---

# Arquitectura Interna: Hallazgos de claude-code-ultimate-guide

## Patrones identificados

### Patrón 1 — Master loop: el corazón de Claude Code
**Descripción:** `while (claude_response.has_tool_call): result = execute_tool(tool_call); claude_response = send_to_claude(result)`. Sin intent classifier, sin task router, sin RAG/embedding pipeline, sin DAG orchestrator. El modelo decide todo.
**Fuente:** core/architecture.md:84-157
**Relevancia:** Alta

### Patrón 2 — Evolución de búsqueda: RAG → grep agentico
**Descripción:** Las primeras versiones de Claude Code usaban RAG con Voyage embeddings. Anthropic cambió a búsqueda con ripgrep después de que benchmarks internos mostraron mejor performance con menor complejidad operacional. Filosofía: "Search, Don't Index". Trade-off: latencia/tokens por simplicidad/seguridad.
**Fuente:** core/architecture.md:38-42
**Relevancia:** Alta

### Patrón 3 — Presupuesto de contexto detallado
**Descripción:** System prompt: 5-15K (tool definitions + safety instructions + behavioral guidelines). CLAUDE.md files: 1-10K. Conversation history: variable. Tool results: variable. Response buffer reservado: 40-45K. Usable real: ~140-150K de 200K.
**Fuente:** core/architecture.md:326-360
**Relevancia:** Alta

### Patrón 4 — System prompts publicados por Anthropic
**Descripción:** Los system prompts de Claude Code son públicamente publicados por Anthropic como parte de su compromiso de transparencia. Contienen: tool definitions, safety instructions, behavioral guidelines (task-first, MVP-first, no over-engineering), context instructions.
**Fuente:** core/architecture.md:365-389
**Relevancia:** Media

### Patrón 5 — Sub-agentes: isolation model y tipos
**Descripción:** Sub-agentes tienen su propia ventana de contexto, reciben solo la descripción de la tarea, tienen acceso a las mismas herramientas excepto Task (no pueden spawnar sub-sub-agentes), retornan solo texto de resumen. Tipos: Explore (solo read-only), Plan (sin Edit/Write), Bash (solo Bash), general-purpose (todas las herramientas).
**Fuente:** core/architecture.md:492-558
**Relevancia:** Alta

### Patrón 6 — Agent Teams: coordinación git-based (experimental v2.1.32+)
**Descripción:** Múltiples instancias Claude trabajando en paralelo en un codebase compartido. Team lead delega subtareas, teammates se comunican via mailbox peer-to-peer. Git-based locking: los agentes reclaman tareas escribiendo lock files en `.claude/tasks/`. Requiere: flag `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` + Opus 4.6.
**Fuente:** guide/workflows/agent-teams.md:1-200
**Relevancia:** Alta

### Patrón 7 — Archivos JSONL como storage de sesiones
**Descripción:** Sesiones almacenadas como JSON Lines en `~/.claude/projects/<encoded-path>/`. Pueden ser buscadas, reproducidas y analizadas programáticamente. El path es codificado del directorio de trabajo absoluto.
**Fuente:** core/glossary.md:88 ("JSONL transcript")
**Relevancia:** Media

### Patrón 8 — Managed settings: 5 scopes con precedencia
**Descripción:** Scope 1 (más alto): Managed (server, MDM profile, registry) para políticas org-wide que no pueden ser overrideadas. Scope 2: Command line. Scope 3: Local (settings.local.json, gitignored). Scope 4: Project (settings.json, committed). Scope 5: User (~/.claude/settings.json).
**Fuente:** core/settings-reference.md:14-28
**Relevancia:** Alta

### Patrón 9 — Métodos de entrega de managed settings
**Descripción:** Managed settings pueden entregarse via: servidor (Claude.ai admin console), macOS MDM (plist com.anthropic.claudecode), Windows registry (HKLM\\SOFTWARE\\Policies\\ClaudeCode), o archivos en directorios específicos del SO. También soporte de drop-in directory (managed-settings.d/*.json).
**Fuente:** core/settings-reference.md:30-36
**Relevancia:** Media

### Patrón 10 — 11 capacidades nativas auditables
**Descripción:** Event Hooks, Skill-Scoped Hooks, Background Agents, Explore Subagent (/explore), Plan Subagent (/plan), Task Tool, Agent Teams, Per-Task Model Selection, MCP Protocol Integration, Permission Modes, Session Memory. Estos son los building blocks del sistema extensible.
**Fuente:** core/architecture.md:165-215
**Relevancia:** Alta

## Conceptos clave

- Master loop = simplicidad intencional, no limitación
- 8 herramientas core; extensión vía MCP
- Grep/ripgrep reemplazó RAG — "Search, Don't Index"
- Sub-agents: depth=1, isolation, resumen como output
- 5 scopes de configuración con precedencia clara
- Managed settings para gobernanza organizacional

## Notas adicionales

El repositorio tiene un documento `core/visual-reference.md` con 20 diagramas ASCII y un directorio `guide/diagrams/` con 40+ diagramas Mermaid interactivos. Cubren: model selection, agent lifecycle, memory hierarchy, multi-agent patterns, security threats.

La arquitectura Agent Teams usa cada agente con una ventana de contexto de 1M tokens (no los 200K del contexto estándar de Claude Code CLI). Esto está documentado en agent-teams.md como característica específica del modo experimental.

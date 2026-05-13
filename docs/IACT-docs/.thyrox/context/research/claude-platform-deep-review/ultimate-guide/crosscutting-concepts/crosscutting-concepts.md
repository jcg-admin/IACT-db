---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-code-ultimate-guide
domain: crosscutting-concepts
repo: claude-code-ultimate-guide
---

# Crosscutting Concepts: Hallazgos de claude-code-ultimate-guide

## Hooks

### Patrón 1 — 4 tipos de hooks con semántica distinta
**Descripción:** `command` (shell script), `http` (POST webhook), `prompt` (single-turn LLM call), `agent` (full multi-turn sub-agent). Los hooks son el mecanismo de automatización más potente del sistema.
**Fuente:** core/glossary.md:86 ("Hook types")
**Relevancia:** Alta

### Patrón 2 — 6 eventos de lifecycle
**Descripción:** PreToolUse (antes de ejecutar herramienta, puede bloquear), PostToolUse (después de herramienta, post-processing), UserPromptSubmit (al enviar prompt, antes de que Claude procese), Notification, SessionStart (setup scripts), SessionEnd (cleanup, auto-rename). Stop (Claude a punto de dejar de responder).
**Fuente:** core/glossary.md:103-116
**Relevancia:** Alta

### Patrón 3 — Re-inyección de tarea vía PostToolUse
**Descripción:** Un hook PostToolUse puede prefijar prompts reintentados con el task original cuando `CLAUDE_TOOL_EXIT_CODE != 0`. Mitiga el "failure-triggered context drift" sin requerir intervención manual.
**Fuente:** core/architecture.md:478-487
**Relevancia:** Media

## MCP (Model Context Protocol)

### Patrón 4 — MCP como extensión del tool arsenal
**Descripción:** MCP extiende las 8 herramientas core añadiendo capabilities externas sin modificar el loop central. Servidores clave: Serena (símbolo-aware navigation + session memory), grepai (semantic search + call graph, Ollama-based), Context7 (docs oficiales de librerías), Sequential (razonamiento multi-paso estructurado), Playwright (browser automation).
**Fuente:** core/architecture.md:276-282
**Relevancia:** Alta

### Patrón 5 — MCP estandarizado por Linux Foundation
**Descripción:** Enero 2026: MCP se convierte en standard oficial via Agentic AI Foundation bajo Linux Foundation. Garantiza estabilidad enterprise a largo plazo.
**Fuente:** guide/ecosystem/mcp-servers-ecosystem.md:72-77
**Relevancia:** Media

### Patrón 6 — MCPB Bundle Format para instalación determinista
**Descripción:** Nuevo formato estandarizado para instalación de MCP servers en un click, reemplazando gestión de dependencias en runtime. Reduce fricción de adopción y asegura instalaciones deterministas.
**Fuente:** guide/ecosystem/mcp-servers-ecosystem.md:91-96
**Relevancia:** Media

### Patrón 7 — MCP Apps (herramientas interactivas)
**Descripción:** Claude ahora soporta herramientas interactivas via MCP Apps spec. Ejemplos: Slack drafting, Figma diagrams, Asana timelines. Diferente de MCP servers para automatización.
**Fuente:** guide/ecosystem/mcp-servers-ecosystem.md:98-104
**Relevancia:** Media

## Agents (Agentes personalizados)

### Patrón 8 — Agentes como personas especializadas con tool restrictions
**Descripción:** Un agente es un archivo markdown con: rol (persona especializada), lista de herramientas (subset de las 8 core), instrucciones de comportamiento. Se almacenan en `.claude/agents/`. El setting `agent` en settings.json puede ejecutar el thread principal como un agente nombrado.
**Fuente:** core/glossary.md:27 ("Agent"); core/settings-reference.md:69-76
**Relevancia:** Alta

### Patrón 9 — Evaluación de agentes con métricas específicas
**Descripción:** Métricas: task completion rate, correctness, relevance, hallucination rate, tool call success rate, tool selection accuracy, tool call efficiency, response time, token efficiency, context utilization, cost per task. Se pueden implementar via hooks y post-processing.
**Fuente:** guide/roles/agent-evaluation.md:35-100
**Relevancia:** Media

## Memory

### Patrón 10 — Auto-memories (v2.1.32+)
**Descripción:** Claude puede almacenar automáticamente contexto de proyecto aprendido en un memory file persistente across sessions. No requiere gestión manual.
**Fuente:** core/glossary.md:37 ("Auto-memories")
**Relevancia:** Media

### Patrón 11 — Jerarquía de memoria: Local > Project > Global
**Descripción:** `.claude/` (local, gitignored, más específico) overridea el project CLAUDE.md (committed, compartido), que overridea el global `~/.claude/CLAUDE.md`. Las reglas más específicas siempre ganan.
**Fuente:** core/glossary.md:93 ("Memory hierarchy")
**Relevancia:** Alta

## Skills

### Patrón 12 — Skills 2.0: Capability Uplift vs Encoded Preference
**Descripción:** "Capability Uplift" enseña a Claude una nueva capacidad que no tiene nativament. "Encoded Preference" fuerza convenciones específicas que Claude no aplicaría por defecto. Esta distinción determina cuándo usar skills vs CLAUDE.md rules.
**Fuente:** core/glossary.md:43 ("Capability Uplift"), 71 ("Encoded Preference")
**Relevancia:** Alta

### Patrón 13 — Skill evals para medir calidad de skills
**Descripción:** Skills 2.0 introduce criterios de evaluación automatizados que miden: calidad de respuesta del skill, confiabilidad de invocación, consistencia de output. Parte del framework de evaluación de agents.
**Fuente:** core/glossary.md:120 ("Skill evals")
**Relevancia:** Media

## Plugins

### Patrón 14 — Plugin como paquete distribuible
**Descripción:** Un plugin empaqueta agents, skills, commands y hooks bajo un manifiesto `plugin.json`. Instalable desde el marketplace. El namespace público es `/thyrox:*` para plugins propios (relevante para el proyecto THYROX).
**Fuente:** core/glossary.md:102 ("Plugin")
**Relevancia:** Alta

### Patrón 15 — SE-CoVe: verificación de cadena via agentes independientes
**Descripción:** Community plugin implementando Chain-of-Verification con agentes de revisión independientes para validación automatizada de outputs. Basado en investigación de Meta (arXiv:2309.11495).
**Fuente:** core/glossary.md:112 ("SE-CoVe")
**Relevancia:** Baja

## Conceptos clave

- Hooks = automatización en lifecycle events (6 tipos de evento, 4 tipos de hook)
- MCP = extensión del arsenal de herramientas sin tocar el core
- Skills: Capability Uplift (nuevo poder) vs Encoded Preference (convención forzada)
- Plugins = paquetes distribuibles (agents + skills + commands + hooks)
- Memory: jerarquía Local > Project > Global
- Auto-memories (v2.1.32+): aprendizaje persistente automático

## Notas adicionales

El framework Vitals (community plugin) detecta hotspots del codebase via score combinado de git churn × complejidad × acoplamiento de módulos. Útil para dirigir refactorizaciones.

La herramienta `mcp-scan` de Snyk puede escanear skills y MCP servers en busca de vulnerabilidades de supply chain. `skills-ref validate` verifica compliance con la spec de skills.

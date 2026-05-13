---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-howto
domain: requirements
repo: claude-howto
---

# Requirements: Hallazgos de claude-howto

## Patrones identificados

### Patrón 1 — Setup mínimo viable en 15 minutos
**Descripción:** El primer requerimiento funcional es copiar un slash command y ejecutarlo. El setup completo en 1 hora incluye: commands, project memory, un skill. El setup de fin de semana cubre hooks, subagents, MCP y plugins.
**Fuente:** README.md:141-176
**Relevancia:** Alta

### Patrón 2 — Prerrequisitos explícitos por milestone
**Descripción:** Antes de avanzar a Level 2, el usuario debe verificar: sabe crear slash commands, configuró CLAUDE.md, creó y restauró checkpoints, usa `claude` y `claude -p`. Si hay gaps, links directos al tutorial correspondiente.
**Fuente:** LEARNING-ROADMAP.md:220-228
**Relevancia:** Alta

### Patrón 3 — Instalación por scope (proyecto vs usuario)
**Descripción:** Cada feature tiene instrucciones de instalación diferenciadas: project-scope (`.claude/`) vs user-scope (`~/.claude/`). Los archivos de proyecto van a git. Los personales son locales.
**Fuente:** QUICK_REFERENCE.md:1-70 (Installation Quick Commands)
**Relevancia:** Alta

### Patrón 4 — Variables de entorno para credenciales externas
**Descripción:** MCP servers requieren tokens en variables de entorno (`GITHUB_TOKEN`, `DATABASE_URL`, `SLACK_TOKEN`). Nunca hardcodear en archivos de configuración. El patrón `${VAR:-default}` permite defaults.
**Fuente:** 05-mcp/README.md:390-415
**Relevancia:** Alta

### Patrón 5 — Node.js como dependencia implícita para MCP
**Descripción:** La mayoría de MCP servers se instalan via `npx`. Windows requiere `cmd /c npx` en lugar de `npx` directamente. Node.js debe estar instalado para usar MCP.
**Fuente:** 05-mcp/README.md:77-115
**Relevancia:** Media

## Conceptos clave

- **Estructura de directorios** fundamental:
  - `.claude/commands/` — slash commands de proyecto
  - `.claude/agents/` — subagents de proyecto
  - `.claude/skills/` — skills de proyecto
  - `.claude/settings.json` — hooks y configuración
  - `.mcp.json` — MCP servers de proyecto
  - `CLAUDE.md` — project memory (va a git)
  - `~/.claude/` — todo lo anterior a nivel usuario

- **Versión mínima de Claude Code**: 2.1+ para la mayoría de features. Algunas requieren versiones específicas (auto memory: v2.1.59+, managed drop-ins: v2.1.83+, HTTP hooks: v2.1.63+).

- **Modelos soportados**: Claude Sonnet 4.6, Opus 4.6, Haiku 4.5

## Notas adicionales

El repo incluye un `--bare` flag para Claude Code que omite hooks, skills, plugins, MCP, auto memory y CLAUDE.md — útil para debugging o sessions minimalistas.

La estructura `managed-settings.d/` (v2.1.83+) permite drop-ins de configuración organizacional, fusionados alfabéticamente.

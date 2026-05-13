---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-code-ultimate-guide
domain: requirements
repo: claude-code-ultimate-guide
---

# Requisitos y Setup: Hallazgos de claude-code-ultimate-guide

## Patrones identificados

### Patrón 1 — Instalación multi-plataforma con métodos alternativos
**Descripción:** Instalación universal vía npm (`npm install -g @anthropic-ai/claude-code`), alternativas para macOS (Homebrew, shell script), Windows (PowerShell, npm), Linux (npm, shell script). Incluye comandos de mantenimiento: `claude update`, `claude doctor`, `claude --version`.
**Fuente:** ultimate-guide.md:254-300
**Relevancia:** Alta

### Patrón 2 — Comandos de autenticación para CI/CD
**Descripción:** `claude auth login` permite autenticarse desde CLI sin interacción. Otros: `claude auth status`, `claude auth logout`. Necesario para devcontainers y pipelines automatizados.
**Fuente:** ultimate-guide.md:301-305
**Relevancia:** Alta

### Patrón 3 — Requisito de suscripción activa
**Descripción:** Claude Code requiere suscripción activa de Anthropic. Los modelos disponibles varían según plan. La configuración `availableModels` puede restringir qué modelos están disponibles en equipos.
**Fuente:** ultimate-guide.md:371-373; core/settings-reference.md:139-148
**Relevancia:** Media

### Patrón 4 — Paths específicos por plataforma
**Descripción:** macOS/Linux usan `~/.claude/`; Windows usa `%USERPROFILE%\.claude\`. `~/.claude.json` (distinto de `~/.claude/settings.json`) almacena OAuth session, MCP server configs, per-project trust state y preferencias como `editorMode`.
**Fuente:** ultimate-guide.md:351-358; core/settings-reference.md:37
**Relevancia:** Media

### Patrón 5 — Canal de release configurable
**Descripción:** `autoUpdatesChannel: "latest" | "stable"`. El canal "stable" va aproximadamente una semana detrás de "latest" y omite versiones con regresiones mayores. Relevante para equipos que necesitan estabilidad.
**Fuente:** core/settings-reference.md:94-100
**Relevancia:** Media

## Conceptos clave

- Instalación sin requisitos especiales (solo Node.js/npm en la ruta universal)
- `claude doctor` para verificar salud del sistema después de actualizaciones
- `~/.claude.json` es diferente de `~/.claude/settings.json` — mezclarlos causa errores de validación
- La autenticación headless (`auth login`) es clave para CI/CD

## Notas adicionales

El repositorio documenta un flag importante: `CLAUDE_CODE_ATTRIBUTION_HEADER=false` en settings.json para mitigar un bug de caché (ver risks-technical-debt). Para DevContainers, la autenticación debe ser configurada explícitamente.

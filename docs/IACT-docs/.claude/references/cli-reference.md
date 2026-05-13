```yml
type: Reference
title: CLI Reference — Claude Code
category: Claude Code Platform — CLI
version: 1.0
created_at: 2026-04-13
updated_at: 2026-04-14 20:07:36
owner: thyrox (cross-phase)
purpose: Todos los flags, 30+ env vars y subcomandos del CLI — claude auth, mcp, agents
```

# CLI Reference — Claude Code

Referencia completa de todos los flags, env vars y subcomandos del CLI de Claude Code. Esta es la fuente definitiva para env vars — otros archivos de referencia apuntan aquí.

---

## Subcomandos

| Comando | Descripción | Ejemplo |
|---------|-------------|---------|
| `claude` | Iniciar REPL interactivo | `claude` |
| `claude "query"` | REPL con prompt inicial | `claude "explain this project"` |
| `claude -p "query"` | Print mode — query y salir | `claude -p "explain this function"` |
| `claude -c` | Continuar conversación más reciente | `claude -c` |
| `claude -r "session"` | Resumir sesión por ID o nombre | `claude -r "auth-refactor"` |
| `claude update` | Actualizar a la última versión | `claude update` |
| `claude auth login` | Login (soporta `--email`, `--sso`) | `claude auth login --email user@example.com` |
| `claude auth logout` | Logout de la cuenta actual | `claude auth logout` |
| `claude auth status` | Estado de auth (exit 0 si logged in, 1 si no) | `claude auth status` |
| `claude mcp` | Configurar servidores MCP | `claude mcp` |
| `claude mcp serve` | Correr Claude Code como MCP server | `claude mcp serve` |
| `claude agents` | Listar subagentes configurados | `claude agents` |
| `claude auto-mode defaults` | Imprimir reglas default de auto mode como JSON | `claude auto-mode defaults` |
| `claude remote-control` | Iniciar servidor Remote Control | `claude remote-control` |
| `claude plugin` | Gestionar plugins (install, enable, disable) | `claude plugin install my-plugin` |
| `claude doctor` | Diagnóstico de instalación y configuración | `claude doctor` |

---

## Flags Core

| Flag | Descripción | Ejemplo |
|------|-------------|---------|
| `-p, --print` | Responder sin modo interactivo (print mode) | `claude -p "query"` |
| `-c, --continue` | Cargar la conversación más reciente | `claude --continue` |
| `-r, --resume` | Resumir sesión por ID o nombre | `claude --resume auth-refactor` |
| `-v, --version` | Mostrar versión | `claude -v` |
| `-w, --worktree` | Iniciar en git worktree aislado | `claude -w` |
| `-n, --name` | Nombre de display de la sesión | `claude -n "auth-refactor"` |
| `--from-pr <number>` | Resumir sesiones vinculadas a un GitHub PR | `claude --from-pr 42` |
| `--bare` | Modo minimal: omite hooks, skills, plugins, MCP, auto memory, CLAUDE.md | `claude --bare` |
| `--init` / `--init-only` | Correr hooks de inicialización | `claude --init` |
| `--maintenance` | Correr hooks de mantenimiento y salir | `claude --maintenance` |
| `--disable-slash-commands` | Deshabilitar todos los skills y slash commands | `claude --disable-slash-commands` |
| `--no-session-persistence` | Deshabilitar guardado de sesión (print mode) | `claude -p --no-session-persistence "query"` |

---

## Model y Razonamiento

| Flag | Descripción | Ejemplo |
|------|-------------|---------|
| `--model` | Seleccionar modelo (sonnet, opus, haiku, o nombre completo) | `claude --model opus` |
| `--fallback-model` | Fallback automático cuando el modelo está sobrecargado | `claude -p --fallback-model sonnet "query"` |
| `--agent` | Especificar agente para la sesión | `claude --agent my-custom-agent` |
| `--agents JSON` | Definir subagentes customizados vía JSON | ver sección Agents Configuration |
| `--effort` | Nivel de esfuerzo de thinking (`low`, `medium`, `high`, `max`) | `claude --effort high` |

### Modelos disponibles

| Modelo | ID corto | ID completo | Contexto |
|--------|----------|-------------|----------|
| Opus 4.6 | `opus` | `claude-opus-4-6` | 1M tokens |
| Sonnet 4.6 | `sonnet` | `claude-sonnet-4-6` | 1M tokens |
| Haiku 4.5 | `haiku` | `claude-haiku-4-5` | 1M tokens |
| Opusplan | `opusplan` | — | Opus planifica, Sonnet ejecuta |

```bash
# Modelos por alias
claude --model opus "complex architectural review"
claude --model haiku -p "format this JSON"

# Con fallback para confiabilidad
claude -p --model opus --fallback-model sonnet "analyze architecture"
```

---

## System Prompt

| Flag | Modo | Descripción | Ejemplo |
|------|------|-------------|---------|
| `--system-prompt` | Interactive + Print | Reemplaza el system prompt completo | `claude --system-prompt "You are a Python expert"` |
| `--system-prompt-file` | Solo Print | Carga prompt desde archivo | `claude -p --system-prompt-file ./prompt.txt "query"` |
| `--append-system-prompt` | Interactive + Print | Agrega al system prompt default | `claude --append-system-prompt "Always use TypeScript"` |

```bash
# Persona completa custom
claude --system-prompt "You are a senior security engineer. Focus on vulnerabilities."

# Instrucciones adicionales
claude --append-system-prompt "Always include unit tests with code examples"

# Prompt complejo desde archivo (solo print mode)
claude -p --system-prompt-file ./prompts/code-reviewer.txt "review main.py"
```

---

## Tools y Permisos

| Flag | Descripción | Ejemplo |
|------|-------------|---------|
| `--tools` | Restringir tools built-in disponibles | `claude -p --tools "Bash,Edit,Read" "query"` |
| `--allowedTools` | Tools que ejecutan sin confirmación | `"Bash(git log:*)" "Read"` |
| `--disallowedTools` | Tools removidos del contexto | `"Bash(rm:*)" "Edit"` |
| `--dangerously-skip-permissions` | Omitir todos los prompts de permiso | `claude --dangerously-skip-permissions` |
| `--permission-mode` | Iniciar en modo de permiso especificado | `claude --permission-mode auto` |
| `--permission-prompt-tool` | MCP tool para gestión de permisos | `claude -p --permission-prompt-tool mcp_auth "query"` |
| `--enable-auto-mode` | Desbloquear auto permission mode | `claude --enable-auto-mode` |

### Modos de permiso

| Modo | Comportamiento |
|------|----------------|
| `default` | Solo lectura; pide confirmación para otras acciones |
| `acceptEdits` | Lectura y edición automática; pide confirmación para comandos |
| `plan` | Solo lectura (modo research, sin edits) |
| `auto` | Todas las acciones con clasificador de seguridad en background (Research Preview) |
| `bypassPermissions` | Todas las acciones sin checks (peligroso) |
| `dontAsk` | Solo tools pre-aprobados; todos los demás denegados |

```bash
# Solo lectura para code review
claude --permission-mode plan "review this codebase"

# Restricción a tools seguros
claude --tools "Read,Grep,Glob" -p "find all TODO comments"

# Bloquear operaciones peligrosas
claude --disallowedTools "Bash(rm -rf:*)" "Bash(git push --force:*)"
```

---

## Output y Formato

| Flag | Opciones | Descripción | Ejemplo |
|------|----------|-------------|---------|
| `--output-format` | `text`, `json`, `stream-json` | Formato de output (print mode) | `claude -p --output-format json "query"` |
| `--input-format` | `text`, `stream-json` | Formato de input (print mode) | `claude -p --input-format stream-json` |
| `--verbose` | — | Logging verbose | `claude --verbose` |
| `--include-partial-messages` | — | Incluir eventos de streaming (requiere `stream-json`) | `claude -p --output-format stream-json --include-partial-messages "query"` |
| `--json-schema` | JSON schema string | Output JSON validado contra schema | `claude -p --json-schema '{"type":"object"}' "query"` |
| `--max-budget-usd` | número | Gasto máximo en print mode | `claude -p --max-budget-usd 5.00 "query"` |

```bash
# Texto plano (default)
claude -p "explain this code"

# JSON para uso programático
claude -p --output-format json "list all functions in main.py"

# Streaming JSON para procesamiento en tiempo real
claude -p --output-format stream-json "generate a long report"

# Output estructurado con schema validado
claude -p --json-schema '{"type":"object","properties":{"bugs":{"type":"array"}}}' \
  "find bugs in this code and return as JSON"
```

---

## Workspace y Directorios

| Flag | Descripción | Ejemplo |
|------|-------------|---------|
| `--add-dir` | Agregar directorios adicionales al contexto | `claude --add-dir ../apps ../lib` |
| `--setting-sources` | Fuentes de settings separadas por coma | `claude --setting-sources user,project` |
| `--settings` | Cargar settings desde archivo o JSON inline | `claude --settings ./settings.json` |
| `--plugin-dir` | Cargar plugins desde directorio (repetible) | `claude --plugin-dir ./my-plugin` |

```bash
# Trabajar en múltiples directorios
claude --add-dir ../frontend ../backend ../shared "find all API endpoints"

# Settings custom
claude --settings '{"model":"opus","verbose":true}' "complex task"
```

---

## MCP

| Flag | Descripción | Ejemplo |
|------|-------------|---------|
| `--mcp-config` | Cargar servidores MCP desde JSON | `claude --mcp-config ./mcp.json` |
| `--strict-mcp-config` | Solo usar el MCP config especificado | `claude --strict-mcp-config --mcp-config ./mcp.json` |
| `--channels` | Subscribirse a MCP channel plugins | `claude --channels discord,telegram` |

```bash
# Cargar GitHub MCP server
claude --mcp-config ./github-mcp.json "list open PRs"

# Strict mode — solo servidores especificados
claude --strict-mcp-config --mcp-config ./production-mcp.json "deploy to staging"
```

---

## Session Management

| Flag | Descripción | Ejemplo |
|------|-------------|---------|
| `--session-id` | Usar session ID específico (UUID) | `claude --session-id "550e8400-..."` |
| `--fork-session` | Crear nueva sesión al resumir | `claude --resume abc123 --fork-session` |
| `--remote "task"` | Crear sesión web en claude.ai | `claude --remote "implement API"` |
| `--teleport` | Resumir sesión web localmente | `claude --teleport` |

```bash
# Continuar última conversación
claude -c

# Resumir sesión nombrada
claude -r "feature-auth" "continue implementing login"

# Fork para experimentar
claude --resume feature-auth --fork-session "try OAuth instead"

# Sesión web y retomar localmente
claude --remote "implement auth"
claude --teleport
```

---

## Avanzado

| Flag | Descripción | Ejemplo |
|------|-------------|---------|
| `--chrome` / `--no-chrome` | Habilitar/deshabilitar integración Chrome/Edge | `claude --chrome` |
| `--ide` | Auto-conectar a IDE si disponible | `claude --ide` |
| `--max-turns` | Limitar turnos autónomos (no-interactivo) | `claude -p --max-turns 3 "query"` |
| `--debug` | Modo debug con filtros | `claude --debug "api,mcp"` |
| `--enable-lsp-logging` | Logging LSP verbose | `claude --enable-lsp-logging` |
| `--betas` | Beta headers para requests API | `claude --betas interleaved-thinking` |
| `--sandbox` / `--no-sandbox` | Habilitar/deshabilitar sandboxing | `claude --sandbox` |
| `--remote-control, --rc` | Sesión interactiva con Remote Control | `claude --rc` |
| `--teammate-mode` | Modo de display para agent teams | `claude --teammate-mode tmux` |
| `--tmux` | Crear sesión tmux para worktree | `claude --tmux` |

---

## Agents Configuration

El flag `--agents` acepta un JSON object definiendo subagentes custom para la sesión.

```json
{
  "agent-name": {
    "description": "Requerido: cuándo invocar este agente",
    "prompt": "Requerido: system prompt del agente",
    "tools": ["Opcional", "array", "de", "tools"],
    "model": "opcional: sonnet|opus|haiku"
  }
}
```

### Ejemplo completo

```bash
claude --agents '{
  "security-auditor": {
    "description": "Security specialist for vulnerability analysis",
    "prompt": "You are a security expert. Find vulnerabilities and suggest fixes.",
    "tools": ["Read", "Grep", "Glob"],
    "model": "opus"
  },
  "documenter": {
    "description": "Documentation specialist",
    "prompt": "You are a technical writer. Create clear, comprehensive documentation.",
    "tools": ["Read", "Write"],
    "model": "haiku"
  }
}' "audit this codebase"

# Desde archivo
claude --agents "$(cat ~/.claude/agents.json)" "review the auth module"
```

### Prioridad de agentes

1. **CLI-defined** (`--agents` flag) — Session-specific, mayor prioridad
2. **User-level** (`~/.claude/agents/`) — Todos los proyectos
3. **Project-level** (`.claude/agents/`) — Proyecto actual

---

## Variables de Entorno

Referencia completa de todas las env vars de Claude Code.

### Autenticación y modelo

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `ANTHROPIC_API_KEY` | API key para autenticación | `sk-ant-...` |
| `ANTHROPIC_MODEL` | Override del modelo default | `claude-opus-4-6` |
| `ANTHROPIC_CUSTOM_MODEL_OPTION` | Opción de modelo custom para API | — |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Override del ID de modelo Opus | `claude-opus-4-6` |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Override del ID de modelo Sonnet | `claude-sonnet-4-6` |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Override del ID de modelo Haiku | `claude-haiku-4-5` |

### Razonamiento y thinking

| Variable | Descripción | Valores |
|----------|-------------|---------|
| `MAX_THINKING_TOKENS` | Budget de tokens para extended thinking | `16000` (default varía) |
| `CLAUDE_CODE_EFFORT_LEVEL` | Nivel de esfuerzo de reasoning | `low` / `medium` / `high` / `max` |

### Streaming y timeouts

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `CLAUDE_STREAM_IDLE_TIMEOUT_MS` | Timeout de stream inactivo en milisegundos | `120000` (2 min, default: ~10000) |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | Override del porcentaje de auto-compaction | `80` |

**Importante para Extended Thinking:** El extended thinking con `--effort high` o `--effort max` produce períodos de silencio mientras Claude razona. Si `CLAUDE_STREAM_IDLE_TIMEOUT_MS` es bajo, el stream puede cortarse. Aumentar a 60000-120000 ms cuando se use `--effort high/max`.

### Features toggles

| Variable | Descripción | Valores |
|----------|-------------|---------|
| `CLAUDE_CODE_SIMPLE` | Modo minimal (equivale a `--bare`) | `true` / `1` |
| `CLAUDE_CODE_DISABLE_AUTO_MEMORY` | Deshabilitar actualizaciones automáticas de CLAUDE.md | `true` / `1` |
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` | Deshabilitar background tasks | `1` |
| `CLAUDE_CODE_DISABLE_CRON` | Deshabilitar tareas programadas (scheduled tasks) | `1` |
| `CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS` | Deshabilitar instrucciones relacionadas con git | `true` / `1` |
| `CLAUDE_CODE_DISABLE_TERMINAL_TITLE` | Deshabilitar actualizaciones del título del terminal | `true` / `1` |
| `CLAUDE_CODE_DISABLE_1M_CONTEXT` | Deshabilitar ventana de contexto de 1M tokens | `true` / `1` |
| `CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK` | Deshabilitar fallback a no-streaming | `true` / `1` |

### Features habilitables

| Variable | Descripción | Valores |
|----------|-------------|---------|
| `CLAUDE_CODE_ENABLE_TASKS` | Habilitar Task List feature | `true` / `1` |
| `CLAUDE_CODE_TASK_LIST_ID` | Directorio de tareas nombrado compartido entre sesiones | `my-project-sprint-3` |
| `CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION` | Toggle de prompt suggestions | `true` / `false` |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | Habilitar agent teams experimental | `1` |
| `CLAUDE_CODE_NEW_INIT` | Usar nuevo flujo de inicialización | `1` |

### Subagentes y plugins

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `CLAUDE_CODE_SUBAGENT_MODEL` | Modelo para ejecución de subagentes | `sonnet` |
| `CLAUDE_CODE_PLUGIN_SEED_DIR` | Directorio para archivos seed de plugins | `./my-plugins` |
| `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` | Env vars a eliminar en subprocesos (comma-separated) | `"SECRET_KEY,DB_PASSWORD"` |

### MCP y tools

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `MAX_MCP_OUTPUT_TOKENS` | Máximo de tokens para output de MCP tools | `50000` |
| `ENABLE_TOOL_SEARCH` | Habilitar tool search capability | `true` |
| `SLASH_COMMAND_TOOL_CHAR_BUDGET` | Character budget para slash command tools | `50000` |

### Ejemplo completo de configuración por env vars

```bash
# .env o ~/.bashrc

# Auth
export ANTHROPIC_API_KEY=sk-ant-...

# Modelo y reasoning
export ANTHROPIC_MODEL=claude-opus-4-6
export CLAUDE_CODE_EFFORT_LEVEL=medium
export MAX_THINKING_TOKENS=16000

# Stream — aumentar para extended thinking
export CLAUDE_STREAM_IDLE_TIMEOUT_MS=60000

# Features
export CLAUDE_CODE_ENABLE_TASKS=true
export CLAUDE_CODE_TASK_LIST_ID=my-project

# Deshabilitar cosas no necesarias
export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=true
export CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION=false
```

### Autenticación — variables adicionales

| Variable | Descripción |
|----------|-------------|
| `ANTHROPIC_AUTH_TOKEN` | OAuth token (alternativa a API key) |
| `ANTHROPIC_BASE_URL` | Endpoint API custom (proxies, deployments privados) |
| `ANTHROPIC_CUSTOM_HEADERS` | Headers custom para requests API. Formato: `Name: Value`, newline-separated |
| `CLAUDE_CODE_USER_EMAIL` | Email de usuario para autenticación sincrónica |
| `CLAUDE_CODE_ORGANIZATION_UUID` | UUID de organización para autenticación sincrónica |
| `CLAUDE_CODE_ACCOUNT_UUID` | Override del UUID de cuenta para autenticación |
| `CLAUDE_CONFIG_DIR` | Path custom del directorio de config (override de `~/.claude`) |
| `CLAUDE_ENV_FILE` | Path custom del archivo de environment |

### Cloud providers (Bedrock, Vertex, Foundry)

| Variable | Descripción |
|----------|-------------|
| `CLAUDE_CODE_USE_BEDROCK` | Usar AWS Bedrock (`1` para habilitar) |
| `CLAUDE_CODE_USE_VERTEX` | Usar Google Vertex AI (`1` para habilitar) |
| `CLAUDE_CODE_USE_FOUNDRY` | Usar Microsoft Foundry (`1` para habilitar) |
| `AWS_BEARER_TOKEN_BEDROCK` | API key de Bedrock para autenticación |
| `CLAUDE_CODE_SKIP_BEDROCK_AUTH` | Saltar auth AWS para Bedrock (`1` para saltar) |
| `CLAUDE_CODE_SKIP_FOUNDRY_AUTH` | Saltar auth Azure para Foundry (`1` para saltar) |
| `CLAUDE_CODE_SKIP_VERTEX_AUTH` | Saltar auth Google para Vertex (`1` para saltar) |
| `ANTHROPIC_FOUNDRY_API_KEY` | API key para Microsoft Foundry |
| `ANTHROPIC_FOUNDRY_BASE_URL` | Base URL del recurso Foundry |
| `ANTHROPIC_FOUNDRY_RESOURCE` | Nombre del recurso Foundry |
| `VERTEX_REGION_CLAUDE_3_5_HAIKU` | Override de región Vertex AI para Claude 3.5 Haiku |
| `VERTEX_REGION_CLAUDE_3_7_SONNET` | Override de región Vertex AI para Claude 3.7 Sonnet |
| `VERTEX_REGION_CLAUDE_4_0_OPUS` | Override de región Vertex AI para Claude 4.0 Opus |
| `VERTEX_REGION_CLAUDE_4_0_SONNET` | Override de región Vertex AI para Claude 4.0 Sonnet |
| `VERTEX_REGION_CLAUDE_4_1_OPUS` | Override de región Vertex AI para Claude 4.1 Opus |

### Timeouts y límites

| Variable | Descripción |
|----------|-------------|
| `BASH_DEFAULT_TIMEOUT_MS` | Timeout default para comandos bash (ms) |
| `BASH_MAX_TIMEOUT_MS` | Timeout máximo para comandos bash (ms) |
| `BASH_MAX_OUTPUT_LENGTH` | Longitud máxima del output de bash |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | Tokens máximos de output por respuesta (default: 32 000; hasta 128 000 para Opus/Sonnet 4.6) |
| `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` | Override del límite de tokens para lectura de archivos |
| `CLAUDE_CODE_EXIT_AFTER_STOP_DELAY` | Auto-exit de SDK mode después de esta duración idle (ms) |
| `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS` | Timeout para hooks SessionEnd (ms) |
| `CLAUDE_CODE_API_KEY_HELPER_TTL_MS` | Intervalo de refresh de credenciales para `apiKeyHelper` (ms) |
| `CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS` | Timeout de git clone de plugin marketplace (ms, default: 120000) |
| `MCP_TIMEOUT` | Timeout de inicio de servidor MCP (ms) |
| `MCP_TOOL_TIMEOUT` | Timeout de ejecución de tool MCP (ms) |

### Control de comportamiento

| Variable | Descripción |
|----------|-------------|
| `CLAUDECODE` | Establecido en `1` en entornos que Claude Code spawna (Bash tool, tmux). Usar para detectar si un script corre dentro de Claude Code |
| `CLAUDE_CODE_SHELL` | Override de detección automática del shell |
| `CLAUDE_CODE_SHELL_PREFIX` | Prefijo de comando añadido a todos los comandos bash |
| `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` | Mantener working directory entre llamadas bash (`1` para habilitar) |
| `CLAUDE_CODE_PLAN_MODE_REQUIRED` | Requerir plan mode para sesiones |
| `CLAUDE_CODE_SKIP_FAST_MODE_NETWORK_ERRORS` | Permitir fast mode cuando el status check de org falla por error de red (`1`; útil con proxies corporativos) |
| `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` | Directorios adicionales desde los que cargar archivos CLAUDE.md |
| `CLAUDE_CODE_TMPDIR` | Directorio temporal custom para operaciones de Claude Code |
| `USE_BUILTIN_RIPGREP` | Usar el binario ripgrep built-in en lugar del del sistema |

### Context window y compactación — variables adicionales

| Variable | Descripción |
|----------|-------------|
| `CLAUDE_CODE_AUTO_COMPACT_WINDOW` | Capacidad en tokens usada para cálculos de compactación. Valor menor que la ventana real del modelo trata a este como si fuera más pequeño a efectos de compactación |

### Telemetría y observabilidad

| Variable | Descripción |
|----------|-------------|
| `CLAUDE_CODE_ENABLE_TELEMETRY` | Habilitar telemetría (`1` para habilitar) |
| `DISABLE_TELEMETRY` | Deshabilitar telemetría (`1` para deshabilitar) |
| `DISABLE_ERROR_REPORTING` | Deshabilitar reporte de errores (`1` para deshabilitar) |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` | Equivale a `DISABLE_AUTOUPDATER` + `DISABLE_FEEDBACK_COMMAND` + `DISABLE_ERROR_REPORTING` + `DISABLE_TELEMETRY` juntos |

### Feature toggles — variables adicionales

| Variable | Descripción |
|----------|-------------|
| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` | Deshabilitar adaptive thinking (`1` para deshabilitar) |
| `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` | Deshabilitar beta features experimentales (`1` para deshabilitar) |
| `CLAUDE_CODE_DISABLE_FAST_MODE` | Deshabilitar fast mode completamente (`1` para deshabilitar) |
| `CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY` | Deshabilitar prompts de feedback survey (`1` para deshabilitar) |
| `ENABLE_CLAUDEAI_MCP_SERVERS` | Habilitar servidores MCP de Claude.ai |
| `CLAUDE_CODE_USE_POWERSHELL_TOOL` | Habilitar la herramienta PowerShell en Windows (requiere `defaultShell: "powershell"` en settings) |
| `FORCE_AUTOUPDATE_PLUGINS` | Forzar auto-update de plugins (`1` para habilitar) |
| `IS_DEMO` | Habilitar modo demo |

### Prompt caching

| Variable | Descripción |
|----------|-------------|
| `DISABLE_PROMPT_CACHING` | Deshabilitar todo el prompt caching (`1` para deshabilitar) |
| `DISABLE_PROMPT_CACHING_HAIKU` | Deshabilitar prompt caching para requests al modelo Haiku |
| `DISABLE_PROMPT_CACHING_SONNET` | Deshabilitar prompt caching para requests al modelo Sonnet |
| `DISABLE_PROMPT_CACHING_OPUS` | Deshabilitar prompt caching para requests al modelo Opus |

### Proxy y red

| Variable | Descripción |
|----------|-------------|
| `HTTP_PROXY` | URL de proxy HTTP para requests de red |
| `HTTPS_PROXY` | URL de proxy HTTPS para requests de red |
| `NO_PROXY` | Lista de hosts que bypass el proxy (comma-separated) |
| `CLAUDE_CODE_PROXY_RESOLVES_HOSTS` | Permitir que el proxy resuelva DNS |
| `CLAUDE_CODE_CLIENT_CERT` | Path del certificado cliente para mTLS |
| `CLAUDE_CODE_CLIENT_KEY` | Path de la clave privada cliente para mTLS |
| `CLAUDE_CODE_CLIENT_KEY_PASSPHRASE` | Passphrase para clave mTLS encriptada |

### UI y display — variables adicionales

| Variable | Descripción |
|----------|-------------|
| `DISABLE_COST_WARNINGS` | Deshabilitar mensajes de aviso de costo |
| `DISABLE_INSTALLATION_CHECKS` | Deshabilitar avisos de instalación |
| `DISABLE_AUTOUPDATER` | Deshabilitar el auto-updater |
| `DISABLE_FEEDBACK_COMMAND` | Deshabilitar el comando `/feedback` (también acepta el nombre legacy `DISABLE_BUG_COMMAND`) |
| `CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL` | Saltar instalación automática de extensión IDE (`1` para saltar) |

### Agent teams — variables adicionales

| Variable | Descripción |
|----------|-------------|
| `CLAUDE_CODE_TEAM_NAME` | Nombre del equipo para agent teams |

### Variables no verificadas (community/legacy)

| Variable | Descripción |
|----------|-------------|
| `CLAUDE_CODE_MAX_TURNS` | Turnos agénticos máximos antes de detener |
| `CLAUDE_CODE_SKIP_SETTINGS_SETUP` | Saltar el flujo de configuración del primer uso |
| `CLAUDE_CODE_DISABLE_TOOLS` | Lista de tools a deshabilitar (comma-separated) |
| `CLAUDE_CODE_DISABLE_MCP` | Deshabilitar todos los servidores MCP (`1` para deshabilitar) |
| `CLAUDE_CODE_HIDE_ACCOUNT_INFO` | Ocultar email/org de la UI |
| `DISABLE_NON_ESSENTIAL_MODEL_CALLS` | Deshabilitar flavor text y llamadas no esenciales al modelo |

---

## Patrones de Integración

### CI/CD — GitHub Actions

```yaml
name: AI Code Review
on: [pull_request]
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code
      - name: Run Code Review
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude -p --output-format json \
            --max-turns 1 \
            "Review PR for security vulnerabilities and code quality.
            Output as JSON with 'issues' array" > review.json
```

### CI/CD — Jenkins

```groovy
pipeline {
    agent any
    stages {
        stage('AI Review') {
            steps {
                sh '''
                    claude -p --output-format json \
                      --max-turns 3 \
                      "Analyze test coverage and suggest missing tests" \
                      > coverage-analysis.json
                '''
            }
        }
    }
}
```

### Script piping

```bash
# Analizar logs de error
tail -1000 /var/log/app/error.log | claude -p "summarize errors and suggest fixes"

# Code review de archivo específico
cat src/auth.ts | claude -p "review this authentication code for security issues"

# Analizar historial git
git log --oneline -50 | claude -p "summarize recent development activity"
```

### Batch processing

```bash
# Procesar múltiples archivos
for file in src/*.ts; do
  echo "Processing $file..."
  claude -p --model haiku "summarize this file: $(cat $file)" >> summaries.md
done

# Generar tests para todos los módulos
for module in $(ls src/modules/); do
  claude -p "generate unit tests for src/modules/$module" > "tests/$module.test.ts"
done
```

### JSON API patterns con jq

```bash
# Output estructurado
claude -p --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array"}}}' \
  "analyze main.py and return function list"

# Parsear con jq
claude -p --output-format json "list all API endpoints" | jq '.endpoints[]'

# Procesamiento condicional
RESULT=$(claude -p --output-format json "is this code secure? answer with {secure: boolean, issues: []}" < code.py)
if echo "$RESULT" | jq -e '.secure == false' > /dev/null; then
  echo "Security issues found!"
  echo "$RESULT" | jq '.issues[]'
fi

# Filtrar por severidad
claude -p --output-format json "list issues" | jq -r '.issues[] | select(.severity=="high")'

# Convertir a CSV
claude -p --output-format json "list functions" | jq -r '.functions[] | [.name, .lineCount] | @csv'
```

### Combinaciones útiles de flags

| Caso de uso | Comando |
|-------------|---------|
| Quick code review | `cat file \| claude -p "review"` |
| Output estructurado | `claude -p --output-format json "query"` |
| Exploración segura | `claude --permission-mode plan` |
| Autonomía con seguridad | `claude --enable-auto-mode --permission-mode auto` |
| CI/CD integration | `claude -p --max-turns 3 --output-format json` |
| Resumir trabajo | `claude -r "session-name"` |
| Modelo específico | `claude --model opus "complex task"` |
| Modo minimal | `claude --bare "quick query"` |
| Budget acotado | `claude -p --max-budget-usd 2.00 "analyze code"` |

---

## References

- [advanced-features](advanced-features.md) — Planning Mode, Extended Thinking, Auto Mode, Worktrees, Sandboxing, Agent Teams, Remote/Web, Channels, Voice, Task List
- [scheduled-tasks](scheduled-tasks.md) — Scheduled tasks, background tasks, headless mode
- [permission-model](permission-model.md) — Modelo de permisos en dos planos
- [mcp-integration](mcp-integration.md) — Configuración de MCP servers
- [Documentación oficial CLI Reference](https://code.claude.com/docs/en/cli-reference)
- [Documentación oficial Headless Mode](https://code.claude.com/docs/en/headless)

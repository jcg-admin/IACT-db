```yml
type: Reference
title: Settings Reference — settings.json Completo
category: Claude Code Platform — Configuración
version: 1.0
created_at: 2026-04-15
owner: thyrox (cross-phase)
purpose: Referencia exhaustiva de todas las keys de settings.json — tipos, defaults, scope y sintaxis de reglas de permiso
```

# Settings Reference — settings.json

Referencia completa de `settings.json` para Claude Code v2.1.81+.

**Complementa:** `cli-reference.md` (env vars + flags) · `permission-model.md` (lógica allow/ask/deny) · `hooks.md` (configuración de hooks)

---

## Scope y Precedencia

| Prioridad | Scope | Ubicación | Compartido | Propósito |
|-----------|-------|-----------|-----------|-----------|
| 1 (máx) | **Managed** | `managed-settings.json` (system-level) | Sí (IT) | Políticas org — no sobreescribibles |
| 2 | **Command line** | Flags `--` al inicio | No | Override temporal de sesión |
| 3 | **Local** | `.claude/settings.local.json` | No (gitignored) | Personal, project-specific |
| 4 | **Project** | `.claude/settings.json` | Sí (committed) | Settings de equipo |
| 5 (mín) | **User** | `~/.claude/settings.json` | No | Defaults personales globales |

**Arrays:** `permissions.allow`, `sandbox.filesystem.allowWrite`, `allowedHttpHookUrls` se **concatenan** entre scopes (no reemplazan).

**Deny override:** `permissions.deny` toma precedencia absoluta sobre cualquier `allow`/`ask` en cualquier scope.

**Entrega de managed settings:**
- macOS MDM: plist `com.anthropic.claudecode`
- Windows: registry `HKLM\SOFTWARE\Policies\ClaudeCode`
- File: `managed-settings.json` en `/Library/Application Support/ClaudeCode/` (macOS), `/etc/claude-code/` (Linux/WSL), `C:\Program Files\ClaudeCode\` (Windows)
- Drop-ins: `managed-settings.d/*.json` — merged alfabéticamente

> **Nota:** `~/.claude.json` almacena OAuth session, MCP server configs y preferencias como `editorMode`. No poner esas keys en `settings.json` — causa errores de validación de schema.

---

## Core Configuration

| Key | Tipo | Default | Scope | Descripción |
|-----|------|---------|-------|-------------|
| `$schema` | string | none | all | URL de JSON Schema para IDE autocomplete (`https://json.schemastore.org/claude-code-settings.json`) |
| `model` | string | `"default"` | all | Modelo por defecto. Aliases: `"sonnet"`, `"opus"`, `"haiku"`, `"opusplan"`, o IDs completos. `ANTHROPIC_MODEL` env var toma precedencia |
| `agent` | string | none | all | Ejecutar el hilo principal como subagente nombrado (debe existir en `.claude/agents/`) |
| `language` | string | `"english"` | all | Idioma de respuesta de Claude y de voz |
| `cleanupPeriodDays` | number | `30` | all | Sesiones inactivas borradas al inicio. `0` = borrar todos los transcripts y deshabilitar persistencia |
| `autoUpdatesChannel` | string | `"latest"` | all | Canal de releases: `"latest"` o `"stable"` (~1 semana de retraso) |
| `alwaysThinkingEnabled` | boolean | `false` | all | Habilitar extended thinking por defecto en todas las sesiones |
| `includeGitInstructions` | boolean | `true` | all | Incluir instrucciones de git en el system prompt. `false` cuando usas custom git workflow skill |
| `voiceEnabled` | boolean | none | user | Habilitar push-to-talk. Requiere cuenta Claude.ai |
| `effortLevel` | string | `"medium"` | all | Nivel de razonamiento persistente: `"low"`, `"medium"`, `"high"`. `CLAUDE_CODE_EFFORT_LEVEL` toma precedencia |
| `defaultShell` | string | `"bash"` | all | Shell para comandos `!`: `"bash"` o `"powershell"` |
| `fastModePerSessionOptIn` | boolean | `false` | all | Si `true`, fast mode no persiste entre sesiones |
| `disableAutoMode` | string | none | all | `"disable"` para desactivar auto mode del ciclo Shift+Tab |
| `showClearContextOnPlanAccept` | boolean | `false` | all | Mostrar opción "clear context" en la pantalla de plan accept |
| `feedbackSurveyRate` | number | none | all | Probabilidad (0–1) de que aparezca la encuesta de calidad. `0` = suprimir |
| `companyAnnouncements` | array | none | all | Mensajes mostrados al inicio (cíclicos aleatoriamente) |
| `availableModels` | array | none | all | Restringir modelos seleccionables via `/model`, `--model`, etc. |
| `env` | object | none | all | Variables de entorno aplicadas a cada sesión |
| `skipWebFetchPreflight` | boolean | `false` | all | Saltar el blocklist check de WebFetch (schema only) |

---

## Plans y Memory

| Key | Tipo | Default | Scope | Descripción |
|-----|------|---------|-------|-------------|
| `plansDirectory` | string | `"~/.claude/plans"` | all | Directorio donde `/plan` guarda sus outputs |
| `autoMemoryEnabled` | boolean | `true` | all | Habilitar/deshabilitar auto-memory entre sesiones |
| `autoMemoryDirectory` | string | none | user/local/managed | Directorio custom para auto-memory. No disponible en project settings (seguridad) |

---

## Permissions

### Keys principales

| Key | Tipo | Default | Scope | Descripción |
|-----|------|---------|-------|-------------|
| `permissions.allow` | array | `[]` | all | Reglas que permiten uso de tool sin prompt. Arrays se concatenan entre scopes |
| `permissions.ask` | array | `[]` | all | Reglas que requieren confirmación del usuario |
| `permissions.deny` | array | `[]` | all | Reglas que bloquean uso de tool. Precedencia absoluta |
| `permissions.additionalDirectories` | array | `[]` | all | Directorios adicionales a los que Claude tiene acceso |
| `permissions.defaultMode` | string | `"default"` | all | Modo por defecto: `"default"`, `"acceptEdits"`, `"plan"`, `"bypassPermissions"` |
| `permissions.disableBypassPermissionsMode` | string | none | all | `"disable"` para prevenir `bypassPermissions`. Deshabilita `--dangerously-skip-permissions` |
| `allowManagedPermissionRulesOnly` | boolean | `false` | managed | Solo aplican reglas de managed settings — ignora user y project |

### Sintaxis de reglas de permiso

Formato: `Tool` o `Tool(specifier)`. Evaluación: deny > ask > allow. Primera regla que coincide gana.

| Tool | Patrón | Ejemplo |
|------|--------|---------|
| `Bash` | Pattern de comando con wildcards | `Bash(npm run *)`, `Bash(git *)` |
| `Read` | Path pattern | `Read(.env)`, `Read(./secrets/**)` |
| `Edit` | Path pattern | `Edit(src/**)`, `Edit(*.ts)` |
| `Write` | Path pattern | `Write(*.md)` |
| `WebFetch` | `domain:hostname` | `WebFetch(domain:example.com)` |
| `WebSearch` | Sin especificador | `WebSearch` |
| `Task` | Nombre de agente | `Task(Explore)` |
| `Agent` | Nombre de agente | `Agent(researcher)` |
| `MCP` | `mcp__server__tool` | `mcp__memory__*` |

**Prefijos de path para Read/Edit:**

| Prefijo | Significado |
|---------|-------------|
| `//` | Ruta absoluta desde filesystem root |
| `~/` | Relativo a home directory |
| `/` | Relativo a project root |
| `./` o sin prefijo | Ruta relativa (directorio actual) |

**Wildcards Bash:** `*` coincide en cualquier posición. `Bash(ls *)` (espacio antes de `*`) coincide `ls -la` pero NO `lsof`. `Bash(*)` equivale a `Bash` (todo). El sufijo legacy `:*` está deprecated.

```json
{
  "permissions": {
    "allow": ["Edit(*)", "Bash(npm run *)", "Bash(git *)"],
    "ask":   ["Bash(git push *)"],
    "deny":  ["Read(.env)", "Read(./secrets/**)"],
    "defaultMode": "acceptEdits"
  }
}
```

---

## Hooks

| Key | Tipo | Default | Scope | Descripción |
|-----|------|---------|-------|-------------|
| `hooks` | object | none | all | Comandos a ejecutar en lifecycle events. Ver `hooks.md` para formato completo, 19 eventos y env vars |
| `disableAllHooks` | boolean | `false` | all | Deshabilitar todos los hooks y custom status line |
| `allowedHttpHookUrls` | array | none | all | URL patterns permitidos para HTTP hooks. Empty = bloquear todos. Arrays se concatenan |
| `httpHookAllowedEnvVars` | array | none | all | Env vars que HTTP hooks pueden interpolar en headers |
| `allowManagedHooksOnly` | boolean | `false` | managed | Solo hooks managed y SDK. Bloquea user, project y plugin hooks |

---

## MCP Servers

| Key | Tipo | Default | Scope | Descripción |
|-----|------|---------|-------|-------------|
| `enableAllProjectMcpServers` | boolean | `false` | all | Auto-aprobar todos los MCP servers en `.mcp.json` del proyecto |
| `enabledMcpjsonServers` | array | none | all | Allowlist de servers específicos de `.mcp.json` a aprobar |
| `disabledMcpjsonServers` | array | none | all | Blocklist de servers específicos de `.mcp.json` a rechazar |
| `allowedMcpServers` | array | none | managed | Allowlist de MCP servers por `serverName`, `serverCommand`, o `serverUrl`. Undefined = sin restricciones; array vacío = lockdown |
| `deniedMcpServers` | array | none | managed | Blocklist de MCP servers. Toma precedencia sobre `allowedMcpServers` |
| `allowManagedMcpServersOnly` | boolean | `false` | managed | Solo servers de managed settings son usables |
| `channelsEnabled` | boolean | `false` | managed | Permitir channels para usuarios Team/Enterprise |

---

## Sandbox

Aislamiento de comandos bash (macOS, Linux, WSL2).

| Key | Tipo | Default | Scope | Descripción |
|-----|------|---------|-------|-------------|
| `sandbox.enabled` | boolean | `false` | all | Habilitar sandboxing de comandos bash |
| `sandbox.failIfUnavailable` | boolean | `false` | all | Error al inicio si sandbox requerida pero no disponible |
| `sandbox.autoAllowBashIfSandboxed` | boolean | `true` | all | Auto-aprobar bash cuando el sandbox está activo |
| `sandbox.excludedCommands` | array | `[]` | all | Comandos que bypass el sandbox (corren en entorno real) |
| `sandbox.allowUnsandboxedCommands` | boolean | `true` | all | Permitir `dangerouslyDisableSandbox`. `false` = sandboxing estricto |
| `sandbox.enableWeakerNestedSandbox` | boolean | `false` | all | Sandbox débil para Docker sin privilegios (Linux/WSL2) |
| `sandbox.network.allowedDomains` | array | `[]` | all | Dominios permitidos para tráfico saliente (soporta `*.example.com`) |
| `sandbox.network.allowUnixSockets` | array | `[]` | all | Unix sockets específicos accesibles (SSH agents, Docker) |
| `sandbox.network.allowAllUnixSockets` | boolean | `false` | all | Permitir todas las conexiones Unix socket |
| `sandbox.network.allowLocalBinding` | boolean | `false` | all | Permitir binding a localhost ports (macOS) |
| `sandbox.network.httpProxyPort` | number | none | all | Puerto de proxy HTTP custom (1–65535) |
| `sandbox.network.allowManagedDomainsOnly` | boolean | `false` | managed | Solo dominios de managed settings son permitidos |
| `sandbox.filesystem.allowWrite` | array | `[]` | all | Paths adicionales con write access. Merged entre scopes + `Edit(...)` allow rules |
| `sandbox.filesystem.denyWrite` | array | `[]` | all | Paths sin write access. Merged con `Edit(...)` deny rules |
| `sandbox.filesystem.denyRead` | array | `[]` | all | Paths sin read access |
| `sandbox.filesystem.allowRead` | array | `[]` | all | Re-permitir paths dentro de regiones `denyRead`. Toma precedencia |

```json
{
  "sandbox": {
    "enabled": true,
    "excludedCommands": ["git", "docker"],
    "filesystem": {
      "allowWrite": ["/tmp/build"],
      "denyRead": ["~/.aws/credentials"]
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org"],
      "allowUnixSockets": ["/var/run/docker.sock"]
    }
  }
}
```

---

## Model Configuration

| Key | Tipo | Default | Scope | Descripción |
|-----|------|---------|-------|-------------|
| `effortLevel` | string | `"medium"` | all | Profundidad de razonamiento: `"low"`, `"medium"`, `"high"`. Escrito automáticamente por `/effort` |
| `modelOverrides` | object | none | all | Mapeo de model IDs Anthropic a IDs de provider (ej. Bedrock ARNs) |
| `alwaysThinkingEnabled` | boolean | `false` | all | Extended thinking por defecto |

**Aliases de modelo:**

| Alias | Descripción |
|-------|-------------|
| `"default"` | Modelo recomendado para tu tipo de cuenta |
| `"sonnet"` | Claude Sonnet 4.6 |
| `"opus"` | Claude Opus 4.6 |
| `"haiku"` | Modelo Haiku rápido |
| `"sonnet[1m]"` | Sonnet con 1M token context |
| `"opusplan"` | Opus para planning, Sonnet para ejecución |

---

## Display y UX

| Key | Tipo | Default | Scope | Descripción |
|-----|------|---------|-------|-------------|
| `statusLine` | object | none | all | Custom status line. El command recibe JSON via stdin con `context_window.used_percentage`, etc. |
| `fileSuggestion` | object | none | all | Script custom para `@` autocomplete de paths. Recibe `{"query": "..."}` y devuelve paths (max 15) |
| `outputStyle` | string | `"Default"` | all | Estilo de respuesta: `"Default"`, `"Explanatory"` (añade razonamiento), `"Learning"` (pair-programming), o nombre de archivo en `.claude/styles/` |
| `spinnerTipsEnabled` | boolean | `true` | all | Mostrar tips mientras Claude trabaja |
| `spinnerVerbs` | object | none | all | Personalizar verbos del spinner (`mode: "replace"` o `"append"`) |
| `spinnerTipsOverride` | object | none | all | Override de tips con strings custom |
| `respectGitignore` | boolean | `true` | all | Respetar `.gitignore` en el file picker `@` |
| `prefersReducedMotion` | boolean | `false` | all | Reducir animaciones UI (accesibilidad) |
| `teammateMode` | string | `"auto"` | all | Display de agent teams: `"auto"`, `"in-process"`, `"tmux"` |

---

## Authentication

| Key | Tipo | Default | Scope | Descripción |
|-----|------|---------|-------|-------------|
| `apiKeyHelper` | string | none | all | Script shell que genera un auth token temporal (short-lived credentials) |
| `forceLoginMethod` | string | none | all | Restringir login a `"claudeai"` o `"console"` |
| `forceLoginOrgUUID` | string | none | all | UUID de organización para auto-seleccionar en login. Requiere `forceLoginMethod` |

---

## Attribution

| Key | Tipo | Default | Scope | Descripción |
|-----|------|---------|-------|-------------|
| `attribution.commit` | string | Git trailer co-authored-by | all | Texto de atribución en commits. String vacío = deshabilitar |
| `attribution.pr` | string | Mensaje con link | all | Texto de atribución en PRs. String vacío = deshabilitar |
| `includeCoAuthoredBy` | boolean | `true` | all | **DEPRECATED** — usar `attribution` en su lugar |

---

## Worktrees

| Key | Tipo | Default | Scope | Descripción |
|-----|------|---------|-------|-------------|
| `worktree.symlinkDirectories` | array | `[]` | all | Directorios a symlinkar desde el repo principal en cada worktree (ej. `node_modules`) |
| `worktree.sparsePaths` | array | `[]` | all | Directorios a checkout en cada worktree via git sparse-checkout (monorepos grandes) |

---

## Plugins y Marketplaces

| Key | Tipo | Default | Scope | Descripción |
|-----|------|---------|-------|-------------|
| `enabledPlugins` | object | none | all | Enable/disable plugins por key (`plugin-name@marketplace`) |
| `extraKnownMarketplaces` | object | none | project | Añadir marketplaces custom. `source: "settings"` para declarar plugins inline |
| `strictKnownMarketplaces` | array | none | managed | Allowlist de marketplaces permitidos |
| `blockedMarketplaces` | array | none | managed | Blocklist de marketplaces bloqueados |
| `pluginTrustMessage` | string | none | managed | Mensaje custom en el trust warning de instalación |
| `pluginConfigs` | object | none | all | Configs de MCP server por plugin `plugin@marketplace` (schema only) |

---

## Global Config `~/.claude.json`

Estas keys van en `~/.claude.json`, NO en `settings.json` (causaría error de schema).

| Key | Tipo | Default | Descripción |
|-----|------|---------|-------------|
| `autoConnectIde` | boolean | `false` | Auto-conectar a IDE cuando Claude Code inicia desde terminal externo |
| `autoInstallIdeExtension` | boolean | `true` | Auto-instalar extensión IDE en terminal VS Code |
| `editorMode` | string | `"normal"` | Key binding: `"normal"` o `"vim"`. Escrito automáticamente por `/vim` |
| `showTurnDuration` | boolean | `true` | Mostrar duración de turno después de respuestas |
| `terminalProgressBarEnabled` | boolean | `true` | Progress bar en ConEmu, Ghostty 1.2.0+, iTerm2 3.6.6+ |

---

## Ejemplo Completo

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "model": "sonnet",
  "language": "english",
  "cleanupPeriodDays": 30,
  "autoUpdatesChannel": "stable",
  "effortLevel": "medium",
  "includeGitInstructions": true,
  "plansDirectory": "./plans",
  "worktree": {
    "symlinkDirectories": ["node_modules"],
    "sparsePaths": ["packages/my-app"]
  },
  "permissions": {
    "allow": ["Edit(*)", "Write(*)", "Bash(npm run *)", "Bash(git *)"],
    "ask":   ["Bash(git push *)"],
    "deny":  ["Read(.env)", "Read(./secrets/**)"],
    "defaultMode": "acceptEdits"
  },
  "enableAllProjectMcpServers": true,
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [{ "type": "command", "command": "./scripts/lint.sh" }]
      }
    ]
  },
  "sandbox": {
    "enabled": false
  }
}
```

---

## Env Vars Clave

Las env vars se pueden poner en el dict `env` de `settings.json` o en el shell. Ver `cli-reference.md` para la lista completa (+100 variables).

| Variable | Descripción |
|----------|-------------|
| `ANTHROPIC_MODEL` | Modelo a usar. Toma precedencia sobre `model` setting |
| `ANTHROPIC_API_KEY` | API key para acceso directo a Anthropic API |
| `ANTHROPIC_BASE_URL` | Endpoint custom (proxies, deployments privados) |
| `CLAUDE_CODE_EFFORT_LEVEL` | Nivel de esfuerzo: `low`, `medium`, `high`, `max`, `auto` |
| `CLAUDE_CODE_DISABLE_AUTO_MEMORY` | `1` = deshabilitar auto-memory |
| `CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS` | `1` = deshabilitar instrucciones git en system prompt |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | Umbral de auto-compact (1–100, default ~95%) |
| `BASH_DEFAULT_TIMEOUT_MS` | Timeout default para comandos bash (ms) |
| `BASH_MAX_OUTPUT_LENGTH` | Longitud máxima de output bash |
| `MCP_TIMEOUT` | Timeout de inicio de MCP servers (ms) |
| `DISABLE_TELEMETRY` | `1` = deshabilitar telemetría |
| `HTTP_PROXY` / `HTTPS_PROXY` | URLs de proxy para requests de red |

---

## Referencias

- [cli-reference](./cli-reference.md) — Lista completa de flags CLI y 100+ env vars
- [permission-model](./permission-model.md) — Lógica detallada de allow/ask/deny, precedencia
- [hooks](./hooks.md) — Formato completo de hooks, 19 eventos, variables de entorno
- [mcp-integration](./mcp-integration.md) — Configuración de MCP servers
- [memory-hierarchy](./memory-hierarchy.md) — Sistema de 8 niveles de memoria y settings enterprise

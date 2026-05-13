```yml
type: Reference
title: MCP Integration — Model Context Protocol
category: Claude Code Platform — MCP
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Servidores MCP (HTTP/stdio/SSE), OAuth, elicitation, canales push y límites de herramientas
```

# MCP Integration — Model Context Protocol

Referencia para integrar servidores MCP (Model Context Protocol) con Claude Code. MCP proporciona acceso en tiempo real a APIs externas, bases de datos y servicios — a diferencia de la memoria (estática), MCP es live.

## Cuándo usar MCP vs otras alternativas

| Necesidad | Mecanismo |
|-----------|----------|
| Datos que cambian frecuentemente (GitHub PRs, DB queries) | **MCP** |
| Instrucciones persistentes (convenciones, reglas) | CLAUDE.md / Memory |
| Conocimiento del dominio de proyecto | Skill / SKILL.md |
| Acceso a archivos del proyecto | Read/Grep/Glob tools |
| Integración con APIs externas en tiempo real | **MCP** |
| Notificaciones push a Claude Code | MCP Channels |

## Tipos de servidores MCP

| Tipo | Transporte | Caso de uso |
|------|-----------|-------------|
| **HTTP** | REST over HTTP | APIs remotas (Notion, Stripe, GitHub) |
| **Stdio** | stdin/stdout local | Herramientas locales (git, database local) |
| **SSE** | Server-Sent Events | Streaming de datos en tiempo real |

> **Nota:** El transporte SSE está deprecado en favor de `http`. Sigue siendo soportado para compatibilidad con servidores legacy.

## Instalación básica

```bash
# HTTP transport (APIs remotas)
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Stdio transport (servidores locales)
claude mcp add --transport stdio github -- npx @modelcontextprotocol/server-github

# Verificar servidores activos
claude mcp list

# Probar conexión
/mcp test
```

## Configuración en archivos

Los servidores MCP se configuran en `.mcp.json` (proyecto) o `~/.claude.json` (usuario):

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.github.com/mcp"
    },
    "database": {
      "command": "npx",
      "args": ["@mcp/server-database"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL:-postgresql://localhost/dev}"
      }
    },
    "local-tools": {
      "type": "stdio",
      "command": "./scripts/mcp-server.sh"
    }
  }
}
```

**Interpolación de variables de entorno:**
- `${VAR}` — error si VAR no está definida
- `${VAR:-default}` — usa `default` si VAR no está definida

## Alcances (scopes) y deduplicación

| Ubicación | Alcance | Commiteado |
|-----------|---------|------------|
| `.mcp.json` | Proyecto (equipo) | Sí |
| `~/.claude.json` | Usuario (todos los proyectos) | No |
| Plugin `.mcp.json` | Plugin (cuando activo) | Con el plugin |

**Deduplicación por nombre:** Local > Proyecto > Usuario (el primero gana). Si `github` está en `.mcp.json` y en `~/.claude.json`, usa el de `.mcp.json`.

> **Nota de nomenclatura (v2.1+):** Los nombres de alcance cambiaron en versiones recientes. Lo que antes se llamaba `project` ahora se llama `local` (privado al usuario actual, almacenado en `~/.claude.json` bajo el path del proyecto). Lo que antes era `global` ahora es `user` (todos los proyectos, en `~/.claude.json`). Los servidores en `.mcp.json` del proyecto requieren aprobación explícita en el primer uso.

## Autenticación OAuth

Claude Code maneja el flujo OAuth automáticamente. Los tokens se guardan en el keychain del sistema.

```bash
# OAuth automático (flujo browser)
claude mcp add --transport http notion https://notion.example.com/mcp

# Con credenciales pre-configuradas
claude mcp add --transport http myservice https://example.com/mcp \
  --client-id "client-id" \
  --client-secret "secret" \
  --callback-port 8080
```

**Override de metadata OAuth (v2.1.64+):**

```json
{
  "mcpServers": {
    "my-server": {
      "type": "http",
      "url": "https://mcp.example.com/mcp",
      "oauth": {
        "authServerMetadataUrl": "https://auth.example.com/.well-known/openid-configuration"
      }
    }
  }
}
```

**Comportamiento:**
- Tokens almacenados en keychain del sistema (seguro, específico de máquina)
- Step-up auth soportado para operaciones privilegiadas
- Discovery de metadata cacheado para reconexiones rápidas

## Límites de herramientas MCP

| Límite | Valor | Efecto |
|--------|-------|--------|
| **Descripción por server** | 2KB (v2.1.84+) | Previene context bloat |
| **Output warning** | 10K tokens | Warning mostrado |
| **Output máximo default** | 25K tokens | Truncado |
| **Persistencia a disco** | 50K chars | Guardado como archivo temporal |

**Tool search automático:** Cuando las descripciones de herramientas MCP superan el 10% del context window, se activa tool search para evitar cargar todas al contexto.

## Acceso a recursos MCP

```bash
# Referencia a recurso específico
@github:https://api.github.com/repos/owner/repo
@notion:notion://page/PAGE_ID
```

Los recursos MCP son distintos de las herramientas — son datos accesibles por referencia (como archivos), no funciones a ejecutar.

## Elicitación — servidores MCP que piden input

Los servidores MCP pueden solicitar input del usuario mid-workflow mediante el evento `Elicitation`:

```
MCP Server requiere input
    ↓
Evento: Elicitation
    ↓
Claude presenta diálogo al usuario
    ↓
Evento: ElicitationResult (usuario responde)
    ↓
MCP Server recibe respuesta
```

**Hooks relevantes:**
```json
{
  "hooks": {
    "Elicitation": [
      {
        "hooks": [{
          "type": "command",
          "command": "./scripts/validate-mcp-input.sh"
        }]
      }
    ],
    "ElicitationResult": [
      {
        "hooks": [{
          "type": "command",
          "command": "./scripts/process-mcp-response.sh"
        }]
      }
    ]
  }
}
```

**Cuándo usar:** Servidores MCP que necesitan confirmación del usuario (deploy approval, configuración inicial). Evitar en scripts (no habrá usuario disponible).

## Actualizaciones dinámicas de herramientas

Los servidores MCP pueden actualizar sus herramientas disponibles sin reiniciar la sesión mediante `list_changed` notifications. Claude Code detecta el cambio y actualiza la lista de herramientas automáticamente.

## MCP en CLI

```bash
# Cargar configuración específica
claude --mcp-config ./custom-mcp.json "query"

# Modo estricto — solo usar la config especificada
claude --strict-mcp-config --mcp-config ./production-mcp.json "deploy"

# Suscribirse a canales MCP (mensajes push)
claude --channels discord,telegram
```

## Canales MCP — push messaging

Los Canales (Research Preview) permiten que servidores MCP envíen mensajes a una sesión de Claude Code en ejecución:

```bash
# Suscribirse a canales al iniciar
claude --channels discord,telegram
```

Casos de uso: alertas de CI/CD que llegan a la sesión activa, notificaciones de deploys, mensajes de monitoreo.

## Managed MCP para Enterprise

Los administradores pueden controlar qué servidores MCP están disponibles:

```
~/.config/ClaudeCode/managed-mcp.json  (Linux)
%APPDATA%\ClaudeCode\managed-mcp.json  (Windows)

Settings disponibles:
- allowedServers: [...] → whitelist de servidores
- deniedServers: [...] → blocklist de servidores
```

## Ejemplo completo — GitHub MCP

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.github.com/mcp",
      "oauth": {
        "authServerMetadataUrl": "https://github.com/.well-known/openid-configuration"
      }
    }
  }
}
```

```bash
# Entonces Claude puede:
claude "List all open PRs with failing CI"
claude "Create a PR for branch feature-auth"
claude "Get the diff for PR #123"
```


## `claude mcp serve` — Exponer Claude Code como servidor MCP

```bash
# Lanzar Claude Code como servidor MCP al que otros clientes pueden conectarse
claude mcp serve
```

**Que hace:** Convierte Claude Code en un servidor MCP. Otros clientes MCP (IDEs,
herramientas externas, otros agentes) pueden conectarse y usar las herramientas
de Claude Code a traves del protocolo MCP.

**Casos de uso:**
- Integrar Claude Code como backend en IDEs con soporte MCP
- Exponer capacidades de Claude Code a herramientas de terceros
- Arquitecturas multi-agente donde Claude Code actua como servidor de herramientas

## Code-execution-with-MCP pattern

Patron para ejecutar codigo de forma segura via un servidor MCP especializado:

```json
{
  "mcpServers": {
    "code-executor": {
      "command": "npx",
      "args": ["@mcp/sandbox-executor"],
      "env": {
        "SANDBOX_IMAGE": "python:3.11-slim",
        "TIMEOUT_SECONDS": "30"
      }
    }
  }
}
```

El patron: Claude analiza el codigo, delega la ejecucion al MCP server (corriendo
en Docker/sandbox), el server devuelve stdout/stderr/exit code, Claude interpreta
el resultado. Esto aisla la ejecucion de codigo del filesystem del host.

## Env var expansion en `mcpServers`

Las variables de entorno se pueden referenciar en la configuracion de MCP servers:

```json
{
  "mcpServers": {
    "mi-server": {
      "command": "node",
      "args": ["./mcp-server.js"],
      "env": {
        "API_KEY": "${MY_API_KEY}",
        "DATABASE_URL": "${DB_URL:-postgresql://localhost/dev}",
        "REGION": "${AWS_REGION}"
      }
    }
  }
}
```

**Sintaxis:**
- `${VAR}` — error si VAR no esta definida en el entorno
- `${VAR:-default}` — usa `default` si VAR no esta definida

Mantiene secretos fuera de los archivos de configuracion commitados al repositorio.

## `--strict-mcp-config` — Validacion estricta de config MCP

```bash
# Solo usar los servidores MCP del archivo especificado (ignora user/project config)
claude --strict-mcp-config --mcp-config ./production-mcp.json "consulta"
```

**Comportamiento:**
- Carga solo los servidores MCP del archivo especificado en `--mcp-config`
- Ignora `~/.claude.json` y `.mcp.json` del proyecto
- Rechaza configuraciones MCP invalidas en lugar de ignorarlas silenciosamente

**Cuando usar:**
- Entornos de produccion: garantizar que solo servidores aprobados esten disponibles
- CI/CD: configuracion deterministica sin dependencias de archivos locales del usuario
- Auditorias de seguridad: control exacto de que servidores MCP tiene acceso Claude

---

## Comparación: MCP vs Hooks vs Skills para integraciones

| Aspecto | MCP | Hook | Skill |
|---------|-----|------|-------|
| **Datos en tiempo real** | ✅ | ❌ | ❌ |
| **Ejecutar acciones externas** | ✅ | ✅ | ❌ |
| **Instrucciones persistentes** | ❌ | ❌ | ✅ |
| **Push notifications** | ✅ (Channels) | ❌ | ❌ |
| **Configuración** | `.mcp.json` | `settings.json` | `SKILL.md` |
| **Invocación** | Auto por Claude | Event-driven | Por Claude o usuario |


## Instalación HTTP con header de autenticación

```bash
# HTTP con header de autorización estático
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"
```

## Nota Windows — transporte stdio

En Windows nativo (no WSL), usar `cmd /c` para comandos `npx`:

```bash
claude mcp add --transport stdio my-server -- cmd /c npx -y @some/mcp-package
```

## Claude.ai MCP Connectors

Los servidores MCP configurados en la cuenta de Claude.ai están disponibles automáticamente en Claude Code sin configuración adicional.

- Disponible también en modo `--print` (v2.1.83+) para uso no interactivo y scripts.
- Para deshabilitar: `ENABLE_CLAUDEAI_MCP_SERVERS=false claude`
- Solo disponible para usuarios autenticados con cuenta Claude.ai.

## Comandos CLI adicionales

```bash
# Ver detalles de un servidor específico
claude mcp get github

# Eliminar un servidor
claude mcp remove github

# Resetear aprobaciones de servidores del proyecto
claude mcp reset-project-choices

# Importar configuración desde Claude Desktop
claude mcp add-from-claude-desktop
```

## MCP Prompts como slash commands

Los servidores MCP pueden exponer prompts que aparecen como slash commands en Claude Code:

```
/mcp__<server>__<prompt>
```

Ejemplo: si el servidor `github` expone un prompt `review`, se invoca como `/mcp__github__review`.

## Env var expansion — campos adicionales

La expansión de variables de entorno funciona en `command`, `args`, `env`, `url` y `headers`:

```json
{
  "mcpServers": {
    "api-server": {
      "type": "http",
      "url": "${API_BASE_URL:-https://api.example.com}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}",
        "X-Custom": "${CUSTOM_HEADER:-default-value}"
      }
    }
  }
}
```

## MCP Apps

MCP Apps es la primera extensión oficial de MCP: permite que las llamadas a herramientas MCP devuelvan componentes UI interactivos que se renderizan directamente en el chat. En lugar de respuestas de texto plano, los servidores MCP pueden entregar dashboards, formularios, visualizaciones de datos y flujos multi-paso — todo inline en la conversación.

## Subagent-scoped MCP

Los servidores MCP pueden definirse en el frontmatter de un subagente usando la clave `mcpServers:`, limitando su alcance a ese agente específico:

```yaml
---
mcpServers:
  my-tool:
    type: http
    url: https://my-tool.example.com/mcp
---

You are an agent with access to my-tool for specialized operations.
```

Los servidores MCP de subagente solo están disponibles dentro del contexto de ejecución de ese agente. Ver también [claude-code-components](claude-code-components.md).

## Plugin-provided MCP servers

Los plugins pueden incluir sus propios servidores MCP. Se pueden definir de dos formas:

1. **`.mcp.json` standalone** — archivo `.mcp.json` en el directorio raíz del plugin
2. **Inline en `plugin.json`** — dentro del manifiesto del plugin

Usar `${CLAUDE_PLUGIN_ROOT}` para referenciar paths relativos al directorio del plugin:

```json
{
  "mcpServers": {
    "plugin-tools": {
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/dist/mcp-server.js"],
      "env": {
        "CONFIG_PATH": "${CLAUDE_PLUGIN_ROOT}/config.json"
      }
    }
  }
}
```

## `settings.json` — claves MCP

Claves configurables en `settings.json` (o managed settings):

| Clave | Tipo | Scope | Descripción |
|-------|------|-------|-------------|
| `enableAllProjectMcpServers` | boolean | all | Aprobar automáticamente todos los servidores en `.mcp.json` del proyecto (evita prompts de confirmación) |
| `enabledMcpjsonServers` | string[] | all | Allowlist de servidores específicos de `.mcp.json` a aprobar |
| `disabledMcpjsonServers` | string[] | all | Blocklist de servidores específicos de `.mcp.json` a rechazar |
| `allowedMcpServers` | array | managed | Allowlist de servidores que los usuarios pueden configurar (por `serverName`, `serverCommand` o `serverUrl`) |
| `deniedMcpServers` | array | managed | Blocklist de servidores bloqueados; toma precedencia sobre `allowedMcpServers` |
| `allowManagedMcpServersOnly` | boolean | managed | Solo los servidores definidos en managed settings son usables |
| `channelsEnabled` | boolean | managed | Habilitar canales para usuarios Team/Enterprise |
| `allowedChannelPlugins` | array | managed | Allowlist de plugins de canal que pueden enviar mensajes (vacío = bloquea todos) |

```json
{
  "enableAllProjectMcpServers": true,
  "enabledMcpjsonServers": ["github", "database"],
  "disabledMcpjsonServers": ["untrusted-server"]
}
```

## Variables de entorno — MCP

| Variable | Descripción |
|----------|-------------|
| `MAX_MCP_OUTPUT_TOKENS` | Máximo tokens de output por llamada MCP (default: 25000) |
| `ENABLE_TOOL_SEARCH` | Umbral para tool search: `auto` (default, 10% del context), `auto:<N>` (activa al superar N tools), `true` (siempre activo), `false` (desactivado). Requiere Sonnet 4 o Opus 4 — Haiku no soportado |
| `MCP_TIMEOUT` | Timeout de arranque del servidor MCP (ms) |
| `MCP_TOOL_TIMEOUT` | Timeout de ejecución de tool MCP (ms) |
| `MCP_CLIENT_SECRET` | Client secret OAuth para MCP |
| `MCP_OAUTH_CALLBACK_PORT` | Puerto para callback OAuth de MCP |
| `ENABLE_CLAUDEAI_MCP_SERVERS` | Habilitar servidores MCP de Claude.ai (`false` para deshabilitar) |
| `CLAUDE_CODE_DISABLE_MCP` | Deshabilitar todos los servidores MCP (`1` para deshabilitar) |

## Managed MCP — configuración completa

Rutas del archivo `managed-mcp.json` por sistema operativo:

| OS | Path |
|----|------|
| macOS | `/Library/Application Support/ClaudeCode/managed-mcp.json` |
| Linux | `~/.config/ClaudeCode/managed-mcp.json` |
| Windows | `%APPDATA%\ClaudeCode\managed-mcp.json` |

**Claves soportadas:**
- `allowedMcpServers` — whitelist; matching por `serverName`, `serverCommand`, `serverUrl` (soporta glob)
- `deniedMcpServers` — blocklist; toma precedencia cuando ambas reglas coinciden

```json
{
  "allowedMcpServers": [
    { "serverName": "github", "serverUrl": "https://api.github.com/mcp" },
    { "serverCommand": "company-mcp-server" }
  ],
  "deniedMcpServers": [
    { "serverName": "untrusted-*" },
    { "serverUrl": "http://*" }
  ]
}
```

## OAuth — clientes pre-configurados

Claude Code incluye clientes OAuth pre-configurados para servicios comunes como Notion y Stripe (v2.1.30+). Para estos servicios, el flujo OAuth funciona sin necesidad de registrar manualmente un `client-id` / `client-secret`.

## Solución de problemas comunes

| Síntoma | Causa probable | Solución |
|---------|----------------|----------|
| Servidor no encontrado | Package no instalado | `npm install -g @modelcontextprotocol/server-github` |
| Authentication failed | Token no definido | `echo $GITHUB_TOKEN` — re-exportar si vacío |
| Connection timeout | Red o firewall | `ping api.github.com` — verificar proxy/firewall |
| MCP server crashes | Env vars faltantes | Verificar todas las variables requeridas; revisar logs en `~/.claude/logs/` |

## Referencias

- `claude-howto/05-mcp/README.md` — Documentación oficial de MCP (fuente externa)
- [hooks](hooks.md) — Eventos de Elicitation en hooks
- [plugins](plugins.md) — Bundling de MCP servers en plugins
- [claude-code-components](claude-code-components.md) — Frontmatter `mcpServers` en subagentes

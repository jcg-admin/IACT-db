```yml
type: Reference
title: Plugins — Arquitectura y Distribución
category: Claude Code Platform — Extensibilidad
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Arquitectura de plugin — manifest plugin.json, namespace /name:cmd, distribución, seguridad de subagentes
```

# Plugins — Arquitectura y Distribución

Referencia para crear, estructurar y distribuir plugins de Claude Code.
Un plugin empaqueta comandos, agentes, skills, hooks y servidores MCP en una unidad instalable con un solo comando.

## Cuándo usar un plugin vs comando standalone

| Criterio | Plugin | Standalone |
|----------|--------|------------|
| ¿Múltiples componentes? | ✅ Plugin | ❌ Redundante |
| ¿Compartir con equipo? | ✅ Plugin | ❌ Copiar archivos |
| ¿Configuración automática? | ✅ Plugin | ❌ Manual |
| ¿Tarea personal simple? | ❌ Overkill | ✅ Slash command |
| ¿Dominio especializado único? | ❌ Overkill | ✅ Skill |
| ¿Análisis especializado? | ❌ Crear manualmente | ✅ Subagente |

**Regla general:** Plugin cuando necesitas bundlear múltiples features, compartir con un equipo, o distribuir con versioning automático. Slash command/skill para workflows personales rápidos.

## Manifest (plugin.json)

El único archivo requerido. Va en `.claude-plugin/plugin.json`:

```json
{
  "name": "my-plugin",
  "description": "Descripción del plugin",
  "version": "1.0.0",
  "author": {
    "name": "Nombre del autor"
  },
  "homepage": "https://example.com",
  "repository": "https://github.com/user/repo",
  "license": "MIT"
}
```

**Nota:** El separador `:` en `/plugin-name:command` viene **exclusivamente** de la arquitectura de plugins. No existe para comandos standalone o skills.

## Estructura completa de un plugin

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json           # Manifest (obligatorio)
├── commands/                 # Slash commands (archivos .md)
│   ├── task-1.md             → /my-plugin:task-1
│   └── task-2.md             → /my-plugin:task-2
├── agents/                   # Subagentes del plugin
│   └── specialist.md
├── skills/                   # Skills con SKILL.md
│   └── skill-1.md
├── hooks/
│   └── hooks.json            # Hooks del plugin
├── .mcp.json                 # Servidores MCP
├── .lsp.json                 # Servidores LSP (code intelligence)
├── bin/                      # Ejecutables añadidos al PATH del Bash tool
├── settings.json             # Configuración por defecto (solo key `agent` soportada)
├── templates/
├── scripts/
└── tests/
```

## Opciones del manifest

### Configuración por usuario (`userConfig`)

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "userConfig": {
    "apiKey": {
      "description": "API key del servicio",
      "sensitive": true
    },
    "region": {
      "description": "Región de despliegue",
      "default": "us-east-1"
    }
  }
}
```

Los campos `sensitive: true` se guardan en el keychain del sistema, no en archivos de configuración en texto plano.

### Directorio de datos persistente (`${CLAUDE_PLUGIN_DATA}`)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "command": "node ${CLAUDE_PLUGIN_DATA}/track-usage.js"
      }
    ]
  }
}
```

`${CLAUDE_PLUGIN_DATA}` sobrevive sesiones y se limpia solo al desinstalar el plugin.

### Plugin inline via settings

```json
{
  "pluginMarketplaces": [
    {
      "name": "inline-tools",
      "source": "settings",
      "plugins": [
        {
          "name": "quick-lint",
          "source": "./local-plugins/quick-lint"
        }
      ]
    }
  ]
}
```

## Distribución

### Fuentes soportadas

| Fuente | Sintaxis | Ejemplo |
|--------|---------|---------|
| **Path relativo** | String | `"./plugins/my-plugin"` |
| **GitHub** | `{ "source": "github", "repo": "..." }` | `{ "source": "github", "repo": "org/plugin", "ref": "v1.0" }` |
| **Git URL** | `{ "source": "url", "url": "..." }` | Git genérico con tag/branch opcional |
| **Git subdir** | `{ "source": "git-subdir", ... }` | Monorepo con subdirectorio |
| **npm** | `{ "source": "npm", "package": "..." }` | `@acme/claude-plugin` |
| **pip** | `{ "source": "pip", "package": "..." }` | `claude-data-plugin` |

### Tipos de marketplace

| Tipo | Alcance | Autoridad |
|------|---------|-----------|
| **Oficial** | Global | Anthropic |
| **Comunidad** | Global | Community |
| **Organización** | Interno | Empresa |
| **Personal** | Individual | Desarrollador |

## Ciclo de vida

### Comandos de instalación

```bash
# CLI
claude plugin install <name>@<marketplace>
claude plugin uninstall <name>
claude plugin list
claude plugin enable <name>
claude plugin disable <name>
claude plugin validate           # Valida estructura del plugin

# Desde slash command
/plugin install plugin-name
/plugin install github:username/repo
/plugin install ./path/to/plugin
```

### Desarrollo local

```bash
# Cargar plugin sin instalar (se puede repetir para múltiples)
claude --plugin-dir ./my-plugin
claude --plugin-dir ./plugin-a --plugin-dir ./plugin-b
```

### Hot-reload durante desarrollo

```bash
/reload-plugins     # Re-lee manifests, commands, agents, hooks sin reiniciar
```

## Seguridad de subagentes en plugins

Los subagentes definidos en plugins tienen restricciones de seguridad. Los siguientes campos **NO están permitidos** en el frontmatter de subagentes de plugin:

- `hooks` — No pueden registrar lifecycle hooks
- `mcpServers` — No pueden configurar servidores MCP
- `permissionMode` — No pueden modificar el modelo de permisos

Esto previene que los plugins escalen privilegios más allá de su alcance declarado.

### Restricciones heredadas por sub-agentes en plugins

Los agentes invocados **desde** un plugin heredan las restricciones del plugin:

- Un plugin NO puede escalar privilegios a traves de sub-agentes
- Los sub-agentes lanzados por un plugin no pueden acceder a recursos fuera del
  scope declarado del plugin
- El principio de minimo privilegio aplica transitivamente: si el plugin no tiene
  acceso a un recurso, sus sub-agentes tampoco

**Implicacion de diseno:** Al disenar un plugin, declarar explicitamente en el
manifest todos los recursos que necesita — incluyendo los que necesitaran sus
sub-agentes. Un plugin que subestima su scope declarado no podra escalar en runtime.

## Directorio `bin/` — Ejecutables del plugin

El directorio `bin/` dentro del plugin contiene scripts ejecutables que se
aaden al `PATH` del Bash tool cuando el plugin esta activo:

```
my-plugin/
├── bin/
│   ├── myplugin-lint      # Disponible como: myplugin-lint en Bash tool
│   └── myplugin-deploy    # Disponible como: myplugin-deploy en Bash tool
└── .claude-plugin/
    └── plugin.json
```

**Convencion de naming:** Prefijo del nombre del plugin para evitar colisiones
con otros comandos del sistema (`myplugin-command`, no simplemente `command`).

**Uso desde Claude:**

```bash
# Claude puede invocar estos ejecutables directamente
myplugin-lint src/
myplugin-deploy --env staging
```

**Caso de uso tipico:** Wrappers de herramientas CLI especificas del plugin,
scripts de deploy, utilitarios de validacion propios del dominio del plugin.

## `claude plugin` commands — Gestion de plugins desde CLI

```bash
# Listar plugins instalados
claude plugin list

# Instalar plugin local
claude plugin install ./path/to/my-plugin

# Instalar plugin desde marketplace
claude plugin install plugin-name@marketplace

# Desinstalar plugin
claude plugin uninstall plugin-name

# Habilitar plugin deshabilitado
claude plugin enable plugin-name

# Deshabilitar plugin sin desinstalar
claude plugin disable plugin-name

# Validar estructura del plugin (desarrollo)
claude plugin validate
```

**Desarrollo local sin instalar:**

```bash
# Cargar plugin sin instalar (util durante desarrollo)
claude --plugin-dir ./my-plugin

# Multiples plugins
claude --plugin-dir ./plugin-a --plugin-dir ./plugin-b

# Hot-reload durante desarrollo (sin reiniciar)
/reload-plugins
```


## Soporte LSP

Los plugins pueden incluir servidores LSP para inteligencia de código en tiempo real:

```json
{
  "python": {
    "command": "pyright-langserver",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".py": "python",
      ".pyi": "python"
    }
  }
}
```

## Contexto THYROX

**Estado actual (FASE 31):** THYROX implementa la arquitectura de plugin (Opción D) para crear el namespace `/thyrox:*`:
- `.claude-plugin/plugin.json` — manifest del framework
- `commands/*.md` — wrappers delgados sobre los skills `workflow-*` internos
- La interfaz pública es `/thyrox:*`; la implementación son los skills `workflow-*` (ADR-019)

**Patrón clave — Wrapper delgado:**

```markdown
# commands/analyze.md → /thyrox:analyze
Thin wrapper. Invoca /workflow-analyze internamente.
```

Los skills `workflow-*` son implementación interna; los comandos del plugin son la interfaz pública distribuible. Esta separación permite actualizar la implementación sin cambiar la interfaz del usuario.

## Referencias

- `claude-howto/07-plugins/README.md` — Documentación oficial claude-howto (fuente externa)
- [skill-vs-agent](skill-vs-agent.md) — Cuándo usar skill, subagente, o comando
- [claude-code-components](claude-code-components.md) — Frontmatter completo de skills y agentes
- ADR-019 — Decisión de arquitectura plugin namespace THYROX

## LSP — Referencia completa de campos

Los plugins pueden incluir servidores LSP. Hay dos ubicaciones válidas de configuración:
- Archivo `.lsp.json` en el directorio raíz del plugin
- Clave inline `lsp` dentro de `plugin.json`

### Tabla de campos

| Campo | Requerido | Descripción |
|-------|-----------|-------------|
| `command` | Sí | Binario del servidor LSP (debe estar en PATH) |
| `extensionToLanguage` | Sí | Mapea extensiones de archivo a language IDs |
| `args` | No | Argumentos de línea de comando para el servidor |
| `transport` | No | Método de comunicación: `stdio` (default) o `socket` |
| `env` | No | Variables de entorno para el proceso del servidor |
| `initializationOptions` | No | Opciones enviadas durante la inicialización LSP |
| `settings` | No | Configuración de workspace pasada al servidor |
| `workspaceFolder` | No | Override del path de workspace folder |
| `startupTimeout` | No | Tiempo máximo (ms) para esperar el inicio del servidor |
| `shutdownTimeout` | No | Tiempo máximo (ms) para shutdown graceful |
| `restartOnCrash` | No | Reiniciar automáticamente si el servidor falla |
| `maxRestarts` | No | Máximo de intentos de restart antes de abandonar |

### Ejemplos por lenguaje

**Go (gopls):**

```json
{
  "go": {
    "command": "gopls",
    "args": ["serve"],
    "extensionToLanguage": {
      ".go": "go"
    }
  }
}
```

**TypeScript:**

```json
{
  "typescript": {
    "command": "typescript-language-server",
    "args": ["--stdio"],
    "extensionToLanguage": {
      ".ts": "typescript",
      ".tsx": "typescriptreact",
      ".js": "javascript",
      ".jsx": "javascriptreact"
    }
  }
}
```

### Plugins LSP del marketplace oficial

| Plugin | Lenguaje | Binario | Instalación |
|--------|----------|---------|-------------|
| `pyright-lsp` | Python | `pyright-langserver` | `pip install pyright` |
| `typescript-lsp` | TypeScript/JavaScript | `typescript-language-server` | `npm install -g typescript-language-server typescript` |
| `rust-lsp` | Rust | `rust-analyzer` | `rustup component add rust-analyzer` |

### Capacidades LSP disponibles

Una vez configurado, el servidor LSP provee:
- **Diagnósticos instantáneos** — errores y warnings aparecen inmediatamente después de editar
- **Navegación de código** — ir a definición, buscar referencias, implementaciones
- **Información al hover** — type signatures y documentación al pasar el cursor
- **Listado de símbolos** — explorar símbolos en el archivo actual o workspace

## Marketplace — Schema de `marketplace.json`

Los marketplaces de plugins se definen en `.claude-plugin/marketplace.json`:

```json
{
  "name": "my-team-plugins",
  "owner": "my-org",
  "plugins": [
    {
      "name": "code-standards",
      "source": "./plugins/code-standards",
      "description": "Enforce team coding standards",
      "version": "1.2.0",
      "author": "platform-team"
    },
    {
      "name": "deploy-helper",
      "source": {
        "source": "github",
        "repo": "my-org/deploy-helper",
        "ref": "v2.0.0"
      },
      "description": "Deployment automation workflows"
    }
  ]
}
```

| Campo | Requerido | Descripción |
|-------|-----------|-------------|
| `name` | Sí | Nombre del marketplace en kebab-case |
| `owner` | Sí | Organización o usuario que mantiene el marketplace |
| `plugins` | Sí | Array de entradas de plugins |
| `plugins[].name` | Sí | Nombre del plugin (kebab-case) |
| `plugins[].source` | Sí | Fuente del plugin (string de path u objeto source) |
| `plugins[].description` | No | Descripción breve del plugin |
| `plugins[].version` | No | String de versión semántica |
| `plugins[].author` | No | Nombre del autor del plugin |

**Nota sobre fuentes `github`/`url`:** Además del campo `ref` (branch/tag), soportan `sha` (commit hash) para pinning exacto de versión.

### Modo strict en marketplace

| Configuración | Comportamiento |
|---------------|----------------|
| `strict: true` (default) | El `plugin.json` local es autoritativo; la entrada del marketplace lo complementa |
| `strict: false` | La entrada del marketplace es la definición completa del plugin |

### Distribución del marketplace

**GitHub (recomendado):**
```bash
/plugin marketplace add owner/repo-name
```

**Otros servicios git** (URL completa requerida):
```bash
/plugin marketplace add https://gitlab.com/org/marketplace-repo.git
```

**Repositorios privados:** Soportados via git credential helpers o tokens de entorno. El usuario debe tener acceso de lectura al repositorio.

**Submission al marketplace oficial:** [claude.ai/settings/plugins/submit](https://claude.ai/settings/plugins/submit) o [platform.claude.com/plugins/submit](https://platform.claude.com/plugins/submit).

## Configuración administrada — Settings para plugins

Administradores pueden controlar el comportamiento de plugins a nivel organización:

| Setting | Tipo | Alcance | Descripción |
|---------|------|---------|-------------|
| `enabledPlugins` | object | all | Habilitar/deshabilitar plugins por clave `plugin-name@marketplace-name` |
| `extraKnownMarketplaces` | object | project | Agregar marketplaces adicionales (soporta `source: "settings"` para inline) |
| `strictKnownMarketplaces` | array | managed only | Allowlist de marketplaces permitidos; array vacío bloquea todos |
| `blockedMarketplaces` | array | managed only | Blocklist de fuentes de marketplace (verificado antes de descargar) |
| `deniedPlugins` | — | managed only | Blocklist de plugins específicos que no pueden instalarse |
| `enabledPlugins` | object | all | Allowlist de plugins habilitados por defecto |
| `allowedChannelPlugins` | array | managed only | Allowlist de channel plugins que pueden enviar mensajes |
| `pluginTrustMessage` | string | managed only | Mensaje personalizado agregado al warning de confianza de plugin antes de instalar |

```json
{
  "enabledPlugins": {
    "formatter@acme-tools": true,
    "experimental@acme-tools": false
  },
  "strictKnownMarketplaces": [
    "my-org/*",
    "github.com/trusted-vendor/*"
  ]
}
```

**Nota:** Con `strictKnownMarketplaces` configurado, los usuarios solo pueden instalar plugins de marketplaces en el allowlist — útil para entornos enterprise que requieren distribución controlada.

## Variables de entorno para plugins

| Variable | Descripción |
|----------|-------------|
| `CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS` | Timeout de git clone del marketplace en ms (default: 120000) |
| `FORCE_AUTOUPDATE_PLUGINS` | Forzar auto-updates de plugins (`1` para habilitar) |

## Ciclo de vida completo — Comandos adicionales

Comandos slash adicionales no listados en la sección de instalación:

```bash
# Ver detalles de un plugin
/plugin info plugin-name

# Actualizar plugin a nueva versión
/plugin update plugin-name

# Listar solo plugins instalados
/plugin list --installed
```

## Publicar un plugin

Pasos para publicar:

1. Crear estructura del plugin con todos sus componentes
2. Escribir el manifest `.claude-plugin/plugin.json`
3. Crear `README.md` con documentación y ejemplos de uso
4. Probar localmente con `claude --plugin-dir ./my-plugin`
5. Verificar todos los componentes (comandos, agentes, MCP, hooks, LSP)
6. Hacer submit al marketplace
7. Esperar revisión y aprobación
8. Publicado — los usuarios pueden instalar con un comando

## Buenas prácticas

### Hacer
- Usar nombres de plugin claros y descriptivos (kebab-case)
- Incluir README completo con ejemplos de uso
- Versionar el plugin con semver (MAJOR.MINOR.PATCH)
- Probar todos los componentes integrados antes de publicar
- Documentar todos los requisitos explícitamente
- Mantener compatibilidad hacia atrás
- Mantener el plugin cohesivo y enfocado en un dominio
- Prefijar ejecutables de `bin/` con el nombre del plugin para evitar colisiones

### No hacer
- No agrupar features no relacionados en un mismo plugin
- No hardcodear credenciales — usar `userConfig` con `sensitive: true`
- No omitir tests
- No ignorar el versionado
- No sobrecomplicar las dependencias entre componentes
- No olvidar manejar errores gracefully

## Troubleshooting

### Plugin no instala
- Verificar compatibilidad de versión de Claude Code: `/version`
- Validar sintaxis de `plugin.json` con un JSON validator
- Verificar conexión a internet (para plugins remotos)
- Revisar permisos del directorio: `ls -la plugin/`

### Componentes no cargan
- Verificar que los paths en `plugin.json` coincidan con la estructura real de directorios
- Revisar permisos de scripts: `chmod +x scripts/`
- Revisar sintaxis de los archivos de componentes
- Revisar logs: `/plugin debug plugin-name`

### MCP no conecta
- Verificar que las variables de entorno están configuradas
- Verificar instalación y salud del servidor MCP
- Probar la conexión MCP independientemente: `/mcp test`
- Revisar configuración en el directorio `mcp/`

### Comandos no disponibles después de instalar
- Confirmar que el plugin se instaló correctamente: `/plugin list --installed`
- Verificar que el plugin está habilitado: `/plugin status plugin-name`
- Reiniciar Claude Code: `exit` y reabrir
- Revisar conflictos de nombres con comandos existentes

### Problemas de ejecución de hooks
- Verificar permisos de los archivos de hook
- Revisar sintaxis del hook y nombres de eventos
- Revisar logs de hooks para detalles de errores
- Probar hooks manualmente si es posible

## Notas de versión

| Feature | Versión mínima |
|---------|---------------|
| `userConfig` con `sensitive` | v2.1.83+ |
| `${CLAUDE_PLUGIN_DATA}` | v2.1.78+ |
| Inline plugin via `source: 'settings'` | v2.1.80+ |

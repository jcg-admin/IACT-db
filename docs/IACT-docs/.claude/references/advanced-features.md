```yml
type: Reference
title: Advanced Features — Claude Code
category: Claude Code Platform — Features Avanzadas
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Planning Mode, Extended Thinking, Auto Mode, Worktrees, Sandboxing, Agent Teams y Channels
```

# Advanced Features — Claude Code

Features avanzadas de Claude Code: Planning Mode, Extended Thinking, Auto Mode, Worktrees, Sandboxing, Agent Teams, Remote Control, Web Sessions, Channels, Voice, Task List.

Para tareas programadas y background tasks, ver [scheduled-tasks](scheduled-tasks.md).
Para todos los flags y env vars, ver [cli-reference](cli-reference.md).

---

## Planning Mode

Planning mode es un enfoque de dos fases: Claude primero analiza la tarea y produce un plan detallado; solo después de aprobación ejecuta.

### Activación

```bash
# Flag CLI — inicio de sesión en plan mode
claude --permission-mode plan

# Slash command dentro del REPL
/plan Implement user authentication system

# Alias de modelo: Opus planifica, Sonnet ejecuta
claude --model opusplan "design and implement the new API"

# Como default en settings
# "permissions": { "defaultMode": "plan" }
```

Keyboard: `Shift+Tab` cicla entre permission modes (incluye `plan`). `Ctrl+G` abre el plan actual en editor externo.

`/ultraplan <prompt>` — workflow end-to-end: Claude redacta el plan, lo abre en el browser para revisión, luego ejecuta remotamente o devuelve al terminal local.

### Cuándo usar

| Usar | No usar |
|------|---------|
| Refactoring multi-archivo complejo | Bug fixes simples |
| Nuevas features con múltiples módulos | Cambios de formato |
| Cambios arquitectónicos | Edits de un solo archivo |
| Migraciones de base de datos | Queries rápidas |
| Rediseños de API | |

### Integración con THYROX Phase 1 ANALYZE

Planning Mode y Phase 1 ANALYZE son complementarios pero distintos:

- **Phase 1 ANALYZE** — Claude entiende el problema antes de planificar (THYROX methodology)
- **Planning Mode** — Claude produce un plan detallado y espera aprobación antes de ejecutar (Claude Code feature)

Recomendación: Activar `--permission-mode plan` al inicio de FASEs complejas. El planning mode alinea con el principio THYROX "ANALYZE first".

### Limitaciones

- En `plan` mode, Claude solo puede leer archivos — no puede editar ni ejecutar comandos
- El plan es un artefacto de conversación, no un archivo persistente (usar `Ctrl+G` para exportarlo)
- `--system-prompt-file` no está disponible en modo interactivo

---

## Extended Thinking

Extended Thinking es el modo de razonamiento profundo donde Claude descompone el problema, evalúa enfoques alternativos y razona edge cases antes de responder.

### Activación

```bash
# Flag CLI
claude --effort high "complex architectural review"

# Slash command dentro del REPL
/effort high

# Env vars
export MAX_THINKING_TOKENS=16000
export CLAUDE_CODE_EFFORT_LEVEL=high   # low | medium | high | max
```

Keyboard: `Option+T` / `Alt+T` — toggle extended thinking. `Ctrl+O` — ver el razonamiento (verbose mode).

Beta header para thinking entre tool calls:
```bash
claude --betas interleaved-thinking "complex multi-step task"
```

### Niveles de esfuerzo (Opus 4.6)

| Nivel | Símbolo | Descripción |
|-------|---------|-------------|
| `low` | ○ | Razonamiento mínimo, más rápido |
| `medium` | ◐ | Balanceado (default) |
| `high` | ● | Razonamiento profundo |
| `max` | ★ | Máximo — solo Opus 4.6 |

Los modelos Sonnet 4.6 y Haiku 4.5 tienen budget fijo de hasta 31,999 tokens. El keyword `"ultrathink"` en el prompt activa razonamiento profundo independientemente del nivel.

### Cuándo vale el costo

| Vale | No vale |
|------|---------|
| Decisiones arquitectónicas | Queries simples |
| Debugging de bugs difíciles | Formatear código |
| Diseño de sistemas con trade-offs complejos | Cambios de configuración triviales |
| Análisis de seguridad exhaustivo | Preguntas con respuesta directa |

### Relación con stream idle timeout

Extended thinking puede generar períodos de silencio prolongado (Claude "piensa" sin producir output visible). Esto puede disparar el timeout de stream inactivo:

```bash
# Aumentar timeout cuando se usa extended thinking con --effort high/max
export CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000   # 2 minutos (default: 10000)
```

Ver [cli-reference](cli-reference.md#variables-de-entorno) para la referencia completa de `CLAUDE_STREAM_IDLE_TIMEOUT_MS`.

---

## Auto Mode

Auto Mode (Research Preview, desde marzo 2026) usa un clasificador de seguridad en background que revisa cada acción antes de ejecutarla. Permite autonomía máxima con guardrails.

### Requisitos

- **Plan requerido:** Team, Enterprise, o API — no disponible en Pro/Max
- **Modelos:** Claude Sonnet 4.6 o Opus 4.6
- **Provider:** Solo Anthropic API (no Bedrock, Vertex, ni Foundry)
- **Costo adicional:** El clasificador corre en Claude Sonnet 4.6

### Activación

```bash
# Desbloquear auto mode para la sesión
claude --enable-auto-mode
# Luego Shift+Tab para ciclar hasta "auto"

# O directamente
claude --permission-mode auto

# Como default en settings
# "permissions": { "defaultMode": "auto" }

# Ver reglas default en JSON
claude auto-mode defaults
```

### Cómo funciona el clasificador

Orden de evaluación para cada acción:

1. **Allow/deny rules explícitas** — se verifican primero
2. **Reads y edits** — auto-aprobados sin clasificador
3. **Clasificador Sonnet 4.6** — evalúa la acción
4. **Fallback** — vuelve a preguntar al usuario si hay 3 bloqueos consecutivos o 20 totales

### Acciones bloqueadas por default

| Acción | Ejemplo |
|--------|---------|
| Pipe-to-shell installs | `curl \| bash` |
| Envío de datos sensibles al exterior | API keys, credentials via red |
| Deploys a producción | Comandos con target production |
| Borrado masivo | `rm -rf` en directorios grandes |
| Cambios de IAM | Modificaciones de permisos y roles |
| Force push a main | `git push --force origin main` |

### Acciones permitidas por default

| Acción | Ejemplo |
|--------|---------|
| Operaciones de archivos locales | Read, Write, Edit en el proyecto |
| Instalar dependencias declaradas | `npm install`, `pip install` desde manifests |
| HTTP de solo lectura | `curl` para fetch de documentación |
| Push a la rama actual | `git push origin feature-branch` |

### Configuración enterprise

```bash
# Ver reglas default en JSON
claude auto-mode defaults
```

El managed setting `autoMode.environment` permite a administradores definir infraestructura confiable — entornos CI/CD, targets de deploy y patrones de infraestructura — para que el clasificador los trate como contextos seguros.

### Alternativa sin Team plan

El script `09-advanced-features/setup-auto-mode-permissions.py` siembra `~/.claude/settings.json` con reglas conservativas que emulan auto mode sin el clasificador:

```bash
# Preview sin cambios
python3 setup-auto-mode-permissions.py --dry-run

# Aplicar baseline conservativo
python3 setup-auto-mode-permissions.py

# Añadir capacidades opcionales
python3 setup-auto-mode-permissions.py --include-edits --include-tests
python3 setup-auto-mode-permissions.py --include-git-write --include-packages
python3 setup-auto-mode-permissions.py --include-gh-read --include-gh-write
```

---

## Git Worktrees

Worktrees permiten aislar trabajo en ramas git paralelas sin stashing ni cambios de branch.

### Activación

```bash
# Iniciar en worktree aislado
claude --worktree
# o
claude -w
```

Los worktrees se crean en `<repo>/.claude/worktrees/<name>`.

### Configuración avanzada

```json
{
  "worktree": {
    "sparsePaths": ["packages/my-package", "shared/"]
  }
}
```

`sparsePaths` activa sparse-checkout — útil en monorepos para reducir uso de disco y tiempo de clonado.

### Tools y hooks de worktree

| Item | Descripción |
|------|-------------|
| `ExitWorktree` | Tool para salir y limpiar el worktree actual |
| `WorktreeCreate` | Hook event al crear worktree |
| `WorktreeRemove` | Hook event al eliminar worktree |

Auto-cleanup: si no se hacen cambios en el worktree, se limpia automáticamente al terminar la sesión.

### Integración con agentes THYROX

En `.claude/agents/*.md`, el campo `isolation: worktree` instruye al agente a trabajar en worktree dedicado. Ver [agent-spec](agent-spec.md) para la especificación completa.

### Casos de uso

- Feature branches paralelas sin afectar el working tree principal
- Experimentos desechables en ambiente aislado
- Tests en aislamiento
- Sparse-checkout de paquetes específicos en monorepos

---

## Sandboxing

Sandboxing provee aislamiento OS-level de filesystem y red para comandos Bash. Complementa las permission rules con una capa de seguridad adicional.

### Activación

```bash
claude --sandbox      # Habilitar
claude --no-sandbox   # Deshabilitar (default)

# Dentro del REPL
/sandbox
```

### Configuración

```json
{
  "sandbox": {
    "enabled": true,
    "failIfUnavailable": true,
    "filesystem": {
      "allowWrite": ["/Users/me/project"],
      "allowRead": ["/Users/me/project", "/usr/local/lib"],
      "denyRead": ["/Users/me/.ssh", "/Users/me/.aws"]
    },
    "enableWeakerNetworkIsolation": true
  }
}
```

| Setting | Descripción |
|---------|-------------|
| `sandbox.enabled` | Habilitar/deshabilitar |
| `sandbox.failIfUnavailable` | Fallar si sandboxing no puede activarse |
| `sandbox.filesystem.allowWrite` | Paths permitidos para escritura |
| `sandbox.filesystem.allowRead` | Paths permitidos para lectura |
| `sandbox.filesystem.denyRead` | Paths denegados para lectura |
| `sandbox.enableWeakerNetworkIsolation` | Aislamiento de red más débil (requerido en macOS) |

**Nota macOS:** El aislamiento completo de red no está disponible en macOS. Usar `enableWeakerNetworkIsolation: true` para restricciones parciales.

### Cuándo activar

- Ejecutar código generado o no confiable
- Prevenir modificaciones accidentales fuera del proyecto
- Restringir acceso de red durante tareas automatizadas
- Remote control sessions con `claude remote-control --sandbox`

---

## Agent Teams

Agent Teams (experimental) habilita múltiples instancias de Claude Code colaborando en una tarea. Deshabilitado por default.

### Activación

```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

O en settings JSON:
```json
{ "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" }
```

### Cómo funciona

- Un **team lead** coordina la tarea global y delega subtareas a teammates
- Cada **teammate** trabaja independientemente con su propio context window
- Una **task list compartida** habilita auto-coordinación entre miembros
- Los teammates se definen en `.claude/agents/` o con `--agents` flag

### Modos de display

```bash
# Split panes de tmux (requiere tmux o iTerm2)
claude --teammate-mode tmux

# Mismo proceso terminal (default)
claude --teammate-mode in-process

# Automático — selecciona el mejor modo
claude --teammate-mode auto
```

### Diferencia con sub-agents normales

| Agent Teams | Sub-agents normales |
|-------------|---------------------|
| Múltiples instancias Claude Code | Tool calls `Agent()` dentro de una sesión |
| Cada teammate tiene su proceso | Subagentes corren en el mismo proceso |
| Coordinación vía task list compartida | Coordinación vía return values |
| Experimental — puede cambiar | Estable |

Ver [subagent-patterns](subagent-patterns.md) para patrones de sub-agents normales.

---

## Remote Control

Remote Control permite continuar una sesión Claude Code local desde el teléfono, tablet o cualquier browser. La sesión sigue corriendo en tu máquina — nada se mueve a la nube.

**Disponibilidad:** Pro, Max, Team, Enterprise (v2.1.51+).

### Activación

```bash
# Iniciar servidor Remote Control
claude remote-control

# Con nombre personalizado
claude remote-control --name "Auth Refactor"

# Con sandboxing habilitado
claude remote-control --sandbox

# Dentro del REPL
/remote-control
/remote-control "Auth Refactor"
```

### Conectar desde otro dispositivo

1. **Session URL** — impresa en la terminal al iniciar
2. **QR code** — presionar `spacebar` después de iniciar
3. **Por nombre** — buscar en claude.ai/code o Claude mobile app (iOS/Android)

### Seguridad

- Sin puertos inbound abiertos en tu máquina
- Solo HTTPS outbound sobre TLS
- Tokens de alcance reducido de vida corta
- Cada sesión remota es independiente

### Limitaciones

- Una sesión remota por instancia de Claude Code
- La terminal debe permanecer abierta en el host
- Timeout de ~10 minutos si la red es inalcanzable

### Remote Control vs Web Sessions

| Aspecto | Remote Control | Web Sessions |
|---------|---------------|--------------|
| Ejecución | Corre en tu máquina | Corre en Anthropic cloud |
| Herramientas locales | Acceso completo a MCP local, archivos, CLI | Sin dependencias locales |
| Caso de uso | Continuar trabajo local desde otro dispositivo | Empezar fresh desde cualquier browser |

---

## Web Sessions

Web Sessions permiten correr Claude Code en el browser en claude.ai/code, o crear sesiones web desde el CLI.

### Crear sesión web desde CLI

```bash
claude --remote "implement the new API endpoints"
```

Inicia una sesión Claude Code en claude.ai accesible desde cualquier browser.

### Retomar sesión web localmente

```bash
# Retomar sesión web en la terminal local
claude --teleport

# Dentro del REPL
/teleport
```

### Casos de uso

- Empezar trabajo en una máquina y continuar en otra
- Compartir URL de sesión con teammates
- Usar la UI web para diff visual, luego cambiar a terminal para ejecución

---

## Channels

Channels (Research Preview) empuja eventos de servicios externos hacia una sesión Claude Code activa vía MCP servers. Claude reacciona a notificaciones en tiempo real sin polling.

### Activación

```bash
# Subscribirse a channel plugins al inicio
claude --channels discord,telegram

# Múltiples fuentes
claude --channels discord,telegram,imessage,webhooks
```

### Integraciones disponibles

| Integración | Descripción |
|-------------|-------------|
| **Discord** | Recibir y responder mensajes Discord en la sesión |
| **Telegram** | Recibir y responder mensajes Telegram en la sesión |
| **iMessage** | Recibir notificaciones iMessage en la sesión |
| **Webhooks** | Recibir eventos de fuentes webhook arbitrarias |

### Configuración enterprise

```json
{
  "allowedChannelPlugins": ["discord", "telegram"]
}
```

`allowedChannelPlugins` es un managed setting que controla qué channel plugins están permitidos en la organización.

### Cómo funciona

1. MCP servers actúan como channel plugins conectados a servicios externos
2. Mensajes y eventos entrantes se pushean a la sesión activa
3. Claude puede leer y responder dentro del contexto de la sesión
4. No requiere polling — eventos se pushean en tiempo real

---

## Voice Dictation

Voice Dictation provee input de voz push-to-talk para Claude Code.

### Activación

```bash
/voice
```

### Características

| Feature | Detalle |
|---------|---------|
| Push-to-talk | Mantener tecla para grabar, soltar para enviar |
| 20 idiomas | STT con soporte multilingüe |
| Keybinding personalizable | Via `/keybindings` |
| Requisito de cuenta | Requiere cuenta Claude.ai para procesamiento STT |

**Disponibilidad:** Desktop app y Claude Code en web. No disponible en CLI puro sin UI.

---

## Task List

Task List provee tracking persistente de tareas que sobrevive context compactions.

### Activación

```bash
export CLAUDE_CODE_ENABLE_TASKS=true
```

Keyboard: `Ctrl+T` — toggle de la vista de task list en sesión.

### Task directories compartidos entre sesiones

```bash
# Directorio de tareas compartido por nombre entre sesiones
export CLAUDE_CODE_TASK_LIST_ID=my-project-sprint-3
```

`CLAUDE_CODE_TASK_LIST_ID` permite que múltiples sesiones compartan la misma task list — útil para workflows de equipo o proyectos multi-sesión.

### Por qué importa la persistencia

Las tasks persisten cuando el historial de conversación se recorta (context compaction). Sin Task List, los items de trabajo de largo plazo pueden perderse en implementaciones complejas de múltiples pasos.

---

## Prompt Suggestions

Prompt Suggestions muestra comandos de ejemplo basados en el historial git y el contexto actual de conversación.

```bash
# Deshabilitar suggestions
export CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION=false
```

- Aparecen como texto gris debajo del prompt de input
- `Tab` acepta la suggestion
- `Enter` acepta y envía inmediatamente

---

## Desktop App

La Desktop App provee una aplicación standalone con diff visual, sesiones paralelas y conectores integrados.

**Disponibilidad:** macOS y Windows (Pro, Max, Team, Enterprise).

### Features principales

| Feature | Descripción |
|---------|-------------|
| **Diff view** | Revisión visual file-by-file con inline comments; Claude lee comentarios y revisa |
| **App preview** | Auto-inicia dev servers con browser embebido para verificación en vivo |
| **PR monitoring** | Integración GitHub CLI con auto-fix de CI failures y auto-merge |
| **Parallel sessions** | Múltiples sesiones en sidebar con aislamiento automático por Git worktree |
| **Scheduled tasks** | Tareas recurrentes (hourly, daily, weekdays, weekly) mientras la app está abierta |
| **Rich rendering** | Rendering de código, markdown y diagramas con syntax highlighting |

### Handoff desde CLI

```bash
/desktop
```

Transfiere la sesión CLI actual a la Desktop App.

### Configuración de app preview

`.claude/launch.json` en el proyecto:
```json
{
  "command": "npm run dev",
  "port": 3000,
  "readyPattern": "ready on",
  "persistCookies": true
}
```

### Connectors

Conectores de servicios externos para contexto enriquecido:

| Connector | Capacidad |
|-----------|-----------|
| **GitHub** | PR monitoring, issue tracking, code review |
| **Slack** | Notificaciones, contexto de canales |
| **Linear** | Issue tracking, sprint management |
| **Notion** | Documentación, acceso a knowledge base |
| **Asana** | Gestión de tareas y proyectos |
| **Calendar** | Awareness de schedule y contexto de reuniones |

**Nota:** Los connectors no están disponibles en sesiones remotas (cloud).

### Remote y SSH sessions

- **Remote sessions** — Corren en infraestructura Anthropic cloud; continúan aunque la app esté cerrada. Accesibles desde claude.ai/code o la app móvil de Claude
- **SSH sessions** — Conectan a máquinas remotas via SSH con acceso completo al filesystem y herramientas remotas. Requiere Claude Code instalado en la máquina remota

### Permission modes en Desktop

| Modo | Comportamiento |
|------|----------------|
| **Ask permissions** (default) | Revisar y aprobar cada edición y comando |
| **Auto accept edits** | Ediciones de archivos auto-aprobadas; comandos requieren aprobación manual |
| **Plan mode** | Revisar el enfoque antes de cualquier cambio |
| **Bypass permissions** | Ejecución automática (solo en sandbox, controlado por admin) |

### Features enterprise

- **Admin console** — Controlar acceso al Code tab y permission settings para la organización
- **MDM deployment** — Desplegar via MDM en macOS o MSIX en Windows
- **SSO integration** — Requerir single sign-on para miembros de la organización
- **Managed settings** — Gestionar centralmente configuración de equipo y disponibilidad de modelos

---

## References

- [cli-reference](cli-reference.md) — Todos los flags, env vars y subcomandos
- [scheduled-tasks](scheduled-tasks.md) — Loop, cron, background tasks, headless mode
- [subagent-patterns](subagent-patterns.md) — Patrones de coordinación multi-agente
- [permission-model](permission-model.md) — Modelo de permisos en dos planos
- [Documentación oficial Advanced Features](https://code.claude.com/docs/en/interactive-mode)
- [Documentación oficial Agent Teams](https://code.claude.com/docs/en/agent-teams)
- [Documentación oficial Remote Control](https://code.claude.com/docs/en/remote-control)
- [Documentación oficial Scheduled Tasks](https://code.claude.com/docs/en/scheduled-tasks)
- [Documentación oficial Chrome Integration](https://code.claude.com/docs/en/chrome)
- [Documentación oficial Headless Mode](https://code.claude.com/docs/en/headless)
- [Documentación oficial Desktop App](https://code.claude.com/docs/en/desktop)
- [Documentación oficial Keybindings](https://code.claude.com/docs/en/keybindings)

---

## Permission Modes

Los 6 modos de permiso disponibles en Claude Code controlan qué acciones puede ejecutar Claude sin aprobación explícita.

| Modo | Comportamiento |
|------|----------------|
| `default` | Solo lee archivos; pide confirmación para todas las demás acciones |
| `acceptEdits` | Lee y edita archivos; pide confirmación para comandos |
| `plan` | Solo lee archivos (modo investigación, sin ediciones) |
| `auto` | Todas las acciones con clasificador de seguridad en background (Research Preview) |
| `bypassPermissions` | Todas las acciones, sin verificación de permisos (peligroso) |
| `dontAsk` | Solo las herramientas pre-aprobadas se ejecutan; el resto se deniega |

### Activación

```bash
# Ciclar entre los 6 modos con teclado
Shift+Tab          # macOS, Linux
Alt+M              # Windows/Linux

# Flag CLI
claude --permission-mode plan
claude --permission-mode auto

# Default en settings
# "permissions": { "defaultMode": "plan" }

# Slash command (dentro del REPL)
/plan
```

### Casos de uso

| Modo | Cuándo usar |
|------|-------------|
| `default` | Desarrollo interactivo con revisión por acción |
| `acceptEdits` | Workflows de automatización de edición de archivos |
| `plan` | Code review — leer y analizar sin modificar |
| `auto` | Trabajo autónomo con guardrails de seguridad |
| `bypassPermissions` | Solo en sandbox controlado, con autorización admin |

---

## Background Tasks

Background Tasks permite ejecutar operaciones de larga duración sin bloquear la conversación.

### Comandos de gestión

```bash
/task list             # Listar todas las tareas activas
/task status bg-1234   # Ver progreso de una tarea
/task show bg-1234     # Ver output en vivo de una tarea
/task cancel bg-1234   # Cancelar una tarea
```

### Uso básico

```
User: Run the full test suite in the background

Claude: Starting tests in background (task-id: bg-1234)
You can continue working while tests run.

User: Meanwhile, let's refactor the auth module

Claude: [Trabaja en el módulo mientras los tests corren]

[Cuando los tests completan]

Claude: Background task bg-1234 completed:
- 245 tests passed
- 3 tests failed
View results: /task show bg-1234
```

### Configuración

```json
{
  "backgroundTasks": {
    "enabled": true,
    "maxConcurrentTasks": 5,
    "notifyOnCompletion": true,
    "autoCleanup": true,
    "logOutput": true
  }
}
```

Keyboard: `Ctrl+B` — ver las tareas corriendo en background.

---

## Scheduled Tasks

Scheduled Tasks ejecutan prompts automáticamente en un schedule recurrente o como recordatorios únicos. Session-scoped: corren mientras Claude Code está activo y se limpian al terminar la sesión. Disponible desde v2.1.72+.

### El comando `/loop`

```bash
# Intervalo explícito
/loop 5m check if the deployment finished

# Lenguaje natural
/loop check build status every 30 minutes
```

También se soportan expresiones cron estándar de 5 campos.

### Recordatorios únicos

```
remind me at 3pm to push the release branch
in 45 minutes, run the integration tests
```

### Herramientas de gestión

| Herramienta | Descripción |
|-------------|-------------|
| `CronCreate` | Crear una nueva tarea programada |
| `CronList` | Listar todas las tareas activas |
| `CronDelete` | Eliminar una tarea programada |

### Límites y comportamiento

| Aspecto | Detalle |
|---------|---------|
| **Máximo por sesión** | 50 tareas |
| **Expiración de recurrentes** | 3 días |
| **Jitter recurrente** | Hasta 10% del intervalo (máx 15 minutos) |
| **Jitter único** | Hasta 90 segundos en límites :00/:30 |
| **Fires perdidos** | Sin catch-up — se saltan si Claude Code no estaba activo |
| **Persistencia** | No persisten entre reinicios |

### Cloud Scheduled Tasks

```
/schedule daily at 9am run the test suite and report failures
```

`/schedule` crea tareas en infraestructura Anthropic que persisten entre reinicios y no requieren que Claude Code esté corriendo localmente.

### Deshabilitar

```bash
export CLAUDE_CODE_DISABLE_CRON=1
```

---

## Headless Mode (Print Mode)

Print mode (`claude -p`) corre Claude Code sin input interactivo — para automatización, CI/CD y batch processing. Reemplaza el flag `--headless` de versiones anteriores.

### Uso básico

```bash
# Ejecutar tarea específica
claude -p "Run all tests"

# Procesar contenido via pipe
cat error.log | claude -p "Analyze these errors"

# Con output estructurado
claude -p --output-format json "Analyze code quality"

# Limitar turns autónomos
claude -p --max-turns 5 "refactor this module"

# Con validación de schema
claude -p --json-schema '{"type":"object","properties":{"issues":{"type":"array"}}}' \
  "find bugs in this code"

# Sin persistencia de sesión
claude -p --no-session-persistence "one-off analysis"
```

### Ejemplo: GitHub Actions

```yaml
# .github/workflows/code-review.yml
name: AI Code Review
on: [pull_request]
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code
      - name: Run Claude Code Review
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude -p --output-format json \
            --max-turns 3 \
            "Review this PR for code quality, security, and test coverage" > review.json
```

---

## Session Management

### Comandos de sesión

| Comando | Descripción |
|---------|-------------|
| `/resume` | Retomar una conversación por ID o nombre |
| `/rename` | Nombrar la sesión actual |
| `/fork` | Bifurcar la sesión actual en una nueva rama |
| `claude -c` | Continuar la conversación más reciente |
| `claude -r "session"` | Retomar sesión por nombre o ID |

### Uso

```bash
# Continuar última conversación
claude -c

# Retomar sesión nombrada
claude -r "auth-refactor" "finish this PR"

# Dentro del REPL — renombrar
/rename auth-refactor

# Bifurcar para explorar alternativa sin perder el original
/fork

# O desde la CLI
claude --resume auth-refactor --fork-session "try OAuth instead"
```

---

## Interactive Features

### Keyboard shortcuts — tabla completa

| Shortcut | Descripción |
|----------|-------------|
| `Ctrl+C` | Cancelar input/generación actual |
| `Ctrl+D` | Salir de Claude Code |
| `Ctrl+G` | Editar plan en editor externo |
| `Ctrl+L` | Limpiar pantalla del terminal |
| `Ctrl+O` | Toggle verbose output (ver razonamiento) |
| `Ctrl+R` | Búsqueda reversa en historial |
| `Ctrl+T` | Toggle vista de task list |
| `Ctrl+B` | Ver tareas corriendo en background |
| `Esc+Esc` | Rewind código/conversación |
| `Shift+Tab` / `Alt+M` | Ciclar modos de permiso |
| `Option+P` / `Alt+P` | Cambiar modelo |
| `Option+T` / `Alt+T` | Toggle extended thinking |

**Readline (edición de línea):**

| Shortcut | Acción |
|----------|--------|
| `Ctrl+A` | Mover al inicio de línea |
| `Ctrl+E` | Mover al final de línea |
| `Ctrl+K` | Cortar hasta el final de línea |
| `Ctrl+U` | Cortar hasta el inicio de línea |
| `Ctrl+W` | Borrar palabra hacia atrás |
| `Ctrl+Y` | Pegar (yank) |
| `Tab` | Autocompletar |
| `↑ / ↓` | Historial de comandos |

### Keybindings personalizados

`/keybindings` abre `~/.claude/keybindings.json` para edición (v2.1.18+).

```json
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+e": "chat:externalEditor",
        "ctrl+u": null,
        "ctrl+k ctrl+s": "chat:stash"
      }
    },
    {
      "context": "Confirmation",
      "bindings": {
        "ctrl+a": "confirmation:yes"
      }
    }
  ]
}
```

`null` desvincula un shortcut default. Los bindings soportan acordes (secuencias multi-tecla: `"ctrl+k ctrl+s"`).

**Contextos disponibles:** `Chat`, `Confirmation`, `Global`, `Autocomplete`, `HistorySearch`, `Settings`, `Tabs`, `Help`, `Transcript`, `Task`, `ThemePicker`, `Attachments`, `Footer`, `MessageSelector`, `DiffDialog`, `ModelPicker`, `Select` — 18 contextos en total.

**Teclas reservadas (no se pueden reasignar):** `Ctrl+C` (interrupt), `Ctrl+D` (exit). Conflictos comunes: `Ctrl+B` (tmux prefix), `Ctrl+A` (GNU Screen prefix), `Ctrl+Z` (process suspend).

### Vim Mode

```
/vim     # Activar desde el REPL
/config  # También disponible desde config
```

Soporta navegación completa (`h/j/k/l`, `w/b/e`, `gg/G`) y text objects (`iw/aw`, `i"/a"`, `i(/a(`). `Esc` para NORMAL, `i/a/o` para INSERT.

### Bash Mode

Ejecutar comandos shell directamente con prefijo `!`:

```bash
! npm test
! git status
! cat src/index.js
```

### Multi-line input

```
User: \
> Implement a user authentication system
> with the following requirements:
> - JWT tokens
> - Email verification
> \end
```

---

## Chrome Integration

Chrome Integration conecta Claude Code al browser Chrome o Edge para automatización web y debugging en vivo. Beta feature disponible desde v2.0.73+ (Edge support desde v1.0.36+).

### Activación

```bash
# Al inicio
claude --chrome      # Habilitar
claude --no-chrome   # Deshabilitar

# Dentro de una sesión
/chrome
```

"Enabled by default" persiste la activación para todas las sesiones futuras. Claude Code comparte el estado de login del browser — puede interactuar con apps autenticadas.

### Capacidades

| Capacidad | Descripción |
|-----------|-------------|
| **Live debugging** | Leer logs de consola, inspeccionar DOM, debuggear JavaScript en tiempo real |
| **Design verification** | Comparar páginas renderizadas contra mockups |
| **Form validation** | Testear submissions, validación de inputs y manejo de errores |
| **Web app testing** | Interactuar con apps autenticadas (Gmail, Google Docs, Notion, etc.) |
| **Data extraction** | Scraping y procesamiento de contenido web |
| **Session recording** | Grabar interacciones del browser como GIF |

### Permisos por sitio

La extensión Chrome gestiona acceso por sitio. Otorgar o revocar acceso para sitios específicos a través del popup de la extensión. Claude Code solo interactúa con sitios explícitamente permitidos.

Claude controla el browser en una ventana visible — las acciones ocurren en tiempo real. Ante login o CAPTCHA, Claude pausa y espera que el usuario lo resuelva manualmente.

### Limitaciones conocidas

- Solo Chrome y Edge — Brave, Arc y otros Chromium no están soportados
- No disponible en WSL
- No soportado con Bedrock, Vertex, ni Foundry como API providers

---

## Managed Settings (Enterprise)

Managed Settings permite a administradores enterprise desplegar configuración de Claude Code en toda la organización usando herramientas nativas de gestión de plataforma.

### Métodos de despliegue

| Plataforma | Método | Desde |
|------------|--------|-------|
| macOS | Managed plist files (MDM) | v2.1.51+ |
| Windows | Windows Registry | v2.1.51+ |
| Cross-platform | Managed config files | v2.1.51+ |
| Cross-platform | Managed drop-ins (`managed-settings.d/`) | v2.1.83+ |

### Managed drop-ins

Desde v2.1.83, múltiples archivos de settings en `managed-settings.d/` se fusionan en orden alfabético:

```
~/.claude/managed-settings.d/
  00-org-defaults.json
  10-team-policies.json
  20-project-overrides.json
```

### Settings disponibles

| Setting | Descripción |
|---------|-------------|
| `disableBypassPermissionsMode` | Impedir que usuarios habiliten bypass permissions |
| `availableModels` | Restringir qué modelos pueden seleccionar los usuarios |
| `allowedChannelPlugins` | Controlar qué channel plugins están permitidos |
| `autoMode.environment` | Configurar infraestructura confiable para auto mode (CI/CD, targets de deploy) |

### Ejemplo: macOS plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>disableBypassPermissionsMode</key>
  <true/>
  <key>availableModels</key>
  <array>
    <string>claude-sonnet-4-6</string>
    <string>claude-haiku-4-5</string>
  </array>
</dict>
</plist>
```


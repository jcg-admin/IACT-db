```yml
type: Reference
title: Hooks — Automatizacion de workflows en Claude Code
category: Cross-phase
version: 1.1
created_at: 2026-04-09 19:30:00
updated_at: 2026-04-14 20:07:15
owner: thyrox (cross-phase)
purpose: Referencia de hooks de Claude Code para configurar comportamiento deterministico. Usar cuando se disenian automatizaciones, PostToolUse reactivos, gates de validacion o sincronizacion de estado.
source: https://code.claude.com/docs/hooks-guide y /hooks
```

# Hooks — Automatizacion de workflows en Claude Code

Los hooks son comandos shell, endpoints HTTP o prompts LLM que se ejecutan automaticamente
en puntos especificos del ciclo de vida de Claude Code. Proveen control deterministico
sobre el comportamiento de Claude — garantizan que ciertas acciones ocurren sin depender
de que el LLM decida ejecutarlas.

---

## Los cuatro tipos de hooks

| Tipo | Campo | Cuando usar |
|------|-------|-------------|
| `command` | `command: "bash script.sh"` | Operaciones shell, sincronizacion de estado, validaciones |
| `http` | `url: "http://..."` | Servicios externos, audit logs compartidos |
| `prompt` | `prompt: "Evalua si..."` | Decisiones que requieren juicio LLM (no logica determinista) |
| `agent` | `prompt: "Verifica que..."` | Verificacion que requiere leer archivos o correr comandos |

### Diferencia entre prompt y agent hooks

- **prompt hook** — evaluacion single-turn: el LLM recibe el prompt y retorna una decision estructurada. Sin herramientas.
- **agent hook** — lanza un subagente dedicado que puede usar herramientas (Read, Grep, Bash, etc.) y razonamiento multi-paso. Mas potente, mas lento.

---

## Eventos del ciclo de vida

Claude Code soporta **26 hook events**:

| Evento | Cuando dispara | Puede bloquear | Matcher input | Uso tipico |
|--------|---------------|----------------|---------------|-----------|
| `SessionStart` | Al iniciar o reanudar sesion | No | startup/resume/clear/compact | Cargar contexto, inyectar estado |
| `InstructionsLoaded` | Despues de cargar CLAUDE.md o rules file | No | (ninguno) | Modificar o filtrar instrucciones |
| `UserPromptSubmit` | Al enviar un prompt | Si (exit 2) | (ninguno) | Filtrar prompts, inyectar contexto adicional |
| `PreToolUse` | Antes de ejecutar herramienta | Si (exit 2 o deny) | Nombre de herramienta | Bloquear operaciones destructivas, modificar input |
| `PermissionRequest` | Dialog de permiso mostrado al usuario | Si | Nombre de herramienta | Auto-aprobar o denegar |
| `PermissionDenied` | Usuario deniega un prompt de permiso | No | Nombre de herramienta | Logging, analytics, enforcement de policy |
| `PostToolUse` | Despues de herramienta exitosa | No (ya ocurrio) | Nombre de herramienta | Sincronizar estado, validar resultado, notificar |
| `PostToolUseFailure` | Despues de herramienta fallida | No | Nombre de herramienta | Log de errores, feedback a Claude |
| `Notification` | Notificacion enviada | No | Tipo de notificacion | Notificaciones personalizadas |
| `SubagentStart` | Al lanzar subagente | No | Agent type name | Inyectar contexto al agente |
| `SubagentStop` | Al terminar subagente | Si | Agent type name | Verificar resultado del agente |
| `Stop` | Al terminar de responder Claude | Si (exit 2) | (ninguno) | Verificar completitud, forzar validacion |
| `StopFailure` | Error de API termina el turno | No | (ninguno) | Error recovery, logging |
| `TeammateIdle` | Teammate del agent team en idle | Si | (ninguno) | Coordinacion de teammates |
| `TaskCompleted` | Tarea marcada completa | Si | (ninguno) | Acciones post-tarea |
| `TaskCreated` | Tarea creada via TaskCreate | No | (ninguno) | Task tracking, logging |
| `ConfigChange` | Archivo de config cambia | Si (excepto policy) | (ninguno) | Reaccionar a cambios de configuracion |
| `CwdChanged` | Directorio de trabajo cambia | No | (ninguno) | Setup especifico de directorio |
| `FileChanged` | Archivo vigilado cambia | No | (ninguno) | Recargar env, sync state |
| `PreCompact` | Antes de compactacion | No | manual/auto | Guardar estado critico |
| `PostCompact` | Despues de compactacion | No | (ninguno) | Re-inyectar contexto perdido |
| `WorktreeCreate` | Worktree siendo creado | Si (retorna path) | (ninguno) | Inicializacion de worktree |
| `WorktreeRemove` | Worktree siendo removido | No | (ninguno) | Cleanup de worktree |
| `Elicitation` | MCP server solicita input del usuario | Si | (ninguno) | Validacion de input |
| `ElicitationResult` | Usuario responde a una elicitacion | Si | (ninguno) | Procesamiento de respuesta |
| `SessionEnd` | Al terminar sesion | No | (ninguno) | Cleanup, git check |

### Matchers especiales por evento

**InstructionsLoaded matcher values:**

| Valor | Descripcion |
|-------|-------------|
| `session_start` | Instrucciones cargadas al inicio de sesion |
| `nested_traversal` | Instrucciones cargadas durante traversal de directorio anidado |
| `path_glob_match` | Instrucciones cargadas via path glob pattern matching |

**Notification matcher values:**

| Valor | Descripcion |
|-------|-------------|
| `permission_prompt` | Notificacion de solicitud de permiso |
| `idle_prompt` | Notificacion de estado idle |
| `auth_success` | Autenticacion exitosa |
| `elicitation_dialog` | Dialog mostrado al usuario |

**SessionEnd reason field values:**

| Valor | Descripcion |
|-------|-------------|
| `clear` | Usuario limpio la sesion |
| `logout` | Usuario cerro sesion |
| `prompt_input_exit` | Usuario salio via prompt input |
| `other` | Otra razon |

---

## Estructura de configuracion

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/mi-script.sh",
            "async": false,
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Campos de configuracion

| Campo | Descripcion | Ejemplo |
|-------|-------------|---------|
| `matcher` | Pattern para filtrar por nombre de herramienta (case-sensitive) | `"Write"`, `"Edit\|Write"`, `"*"` |
| `hooks` | Array de definiciones de hook | `[{ "type": "command", ... }]` |
| `type` | Tipo de hook: `command`, `prompt`, `http`, `agent` | `"command"` |
| `command` | Comando shell a ejecutar | `"$CLAUDE_PROJECT_DIR/.claude/hooks/format.sh"` |
| `timeout` | Timeout en segundos (default 60) | `30` |
| `once` | Si `true`, el hook corre solo una vez por sesion | `true` |
| `async` | Si `true`, no bloquea a Claude (ver Async hooks) | `false` |

### Matchers por evento

El `matcher` filtra cuando dispara el hook dentro del evento:

- **PreToolUse / PostToolUse / PermissionRequest**: nombre de herramienta (`Bash`, `Write|Edit`, `mcp__.*`)
- **SessionStart**: como inicio (`startup`, `resume`, `clear`, `compact`)
- **InstructionsLoaded**: `session_start`, `nested_traversal`, `path_glob_match`
- **Notification**: `permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_dialog`
- **PreCompact / PostCompact**: tipo de compactacion (`manual`, `auto`)
- **UserPromptSubmit / Stop**: sin matcher — siempre dispara

**Patrones de matcher:**

| Pattern | Descripcion | Ejemplo |
|---------|-------------|---------|
| Exact string | Coincide con herramienta especifica | `"Write"` |
| Regex pattern | Coincide con multiples herramientas | `"Edit\|Write"` |
| Wildcard | Coincide con todas las herramientas | `"*"` o `""` |
| MCP tools | Patron servidor y herramienta | `"mcp__memory__.*"` |

### Campo `if` (filtro fino por argumentos)

Filtra no solo por nombre de herramienta sino por sus argumentos:

```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "command",
      "if": "Bash(git *)",
      "command": "bash .claude/scripts/check-git.sh"
    }
  ]
}
```

Solo aplica en eventos de herramienta: `PreToolUse`, `PostToolUse`, `PostToolUseFailure`,
`PermissionRequest`, `PermissionDenied`. En otros eventos, un hook con `if` nunca corre.

Ejemplos de sintaxis `if`:
- `Bash(git *)` — cualquier comando git
- `Write(/context/work/*)` — escrituras en WP directory
- `Edit(/*.md)` — edicion de cualquier markdown
- `Bash(rm *)` — cualquier rm

---

## Input/Output del hook

### Input (stdin para command hooks, body para HTTP hooks)

Cada evento envia campos comunes + campos especificos:

```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/home/user/project",
  "hook_event_name": "PostToolUse",
  "permission_mode": "acceptEdits",
  "agent_id": "agent-abc123",
  "agent_type": "main",
  "worktree": "/path/to/worktree",
  "tool_name": "Write",
  "tool_use_id": "toolu_01ABC123...",
  "tool_input": {
    "file_path": "/home/user/project/context/work/2026-04-09-nombre/analysis/file.md",
    "content": "..."
  },
  "tool_response": { "filePath": "...", "success": true }
}
```

**Campos comunes:**

| Campo | Descripcion |
|-------|-------------|
| `session_id` | Identificador unico de sesion |
| `transcript_path` | Path al archivo de transcript de la conversacion (.jsonl) |
| `cwd` | Directorio de trabajo actual |
| `hook_event_name` | Nombre del evento que disparo el hook |
| `permission_mode` | Modo de permisos activo |
| `agent_id` | Identificador del agente que corre este hook |
| `agent_type` | Tipo de agente (`"main"`, nombre de tipo de subagente, etc.) |
| `worktree` | Path al git worktree, si el agente corre en uno |

Para PreToolUse/PostToolUse: `tool_name` + `tool_input` + `tool_response` (solo Post) + `tool_use_id`.

**Campo especial Stop/SubagentStop:** Ambos reciben `last_assistant_message` con el mensaje final de Claude antes de parar. Util para evaluar completitud de tareas.

### Exit codes

| Codigo | Efecto |
|--------|--------|
| `0` | Permitir. Si hay JSON en stdout, se procesa. |
| `2` | Bloquear. Stderr se envia a Claude como feedback. |
| Otro | Error no bloqueante. Ejecucion continua. |

Solo `exit 2` bloquea — `exit 1` NO bloquea (comportamiento contrario a convencion Unix).

### Salida JSON estructurada (exit 0 + stdout JSON)

Para control fino, salir con exit 0 e imprimir JSON:

```json
{
  "continue": true,
  "stopReason": "Optional message if stopping",
  "suppressOutput": false,
  "systemMessage": "Optional warning message",
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "File is in allowed directory",
    "updatedInput": {
      "file_path": "/modified/path.js"
    }
  }
}
```

**Campos universales:**
- `continue: false` — Claude para completamente
- `stopReason` — mensaje al usuario cuando `continue: false`
- `suppressOutput: true` — omite stdout del debug log
- `systemMessage` — advertencia al usuario

**Campos en `hookSpecificOutput` por evento:**

| Evento | Campo | Valores / Descripcion |
|--------|-------|-----------------------|
| PreToolUse | `permissionDecision` | `"allow"`, `"deny"`, `"ask"` |
| PreToolUse | `permissionDecisionReason` | Explicacion de la decision |
| PreToolUse | `updatedInput` | Input modificado de la herramienta |
| PostToolUse | `additionalContext` | Contexto adicional para Claude |
| PostToolUse | decision `"block"` | Envia feedback a Claude |
| PermissionRequest | `decision.behavior` | `"allow"` o `"deny"` |
| PermissionRequest | `decision.message` | Mensaje personalizado |
| PermissionRequest | `decision.interrupt` | `false` por defecto |

---

## Variables de entorno

| Variable | Disponibilidad | Descripcion |
|----------|---------------|-------------|
| `CLAUDE_PROJECT_DIR` | Todos los hooks | Path absoluto al root del proyecto |
| `CLAUDE_ENV_FILE` | SessionStart, CwdChanged, FileChanged | Path a archivo para persistir vars de entorno entre sesiones |
| `CLAUDE_CODE_REMOTE` | Todos los hooks | `"true"` si corre en entornos remotos |
| `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS` | SessionEnd hooks | Timeout configurable en ms para SessionEnd hooks |
| `CLAUDE_PLUGIN_ROOT` | Plugin hooks | Path al directorio del plugin |
| `CLAUDE_PLUGIN_DATA` | Plugin hooks | Path al directorio de datos del plugin |

### CLAUDE_ENV_FILE para persistir variables de entorno

`SessionStart`, `CwdChanged`, y `FileChanged` pueden escribir a `CLAUDE_ENV_FILE` para
persistir variables de entorno que estaran disponibles en el siguiente turno:

```bash
#!/bin/bash
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export NODE_ENV=development' >> "$CLAUDE_ENV_FILE"
fi
exit 0
```

---

## Patrones de uso para thyrox

### PostToolUse para sincronizar estado (Automatico-B)

El patron reactivo: cuando Claude escribe un archivo, el hook sincroniza estado.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/sync-wp-state.sh"
          }
        ]
      }
    ]
  }
}
```

El script lee `tool_input.file_path` de stdin y decide si sincronizar.

### Stop hook para validacion pre-termino

Verificar que todos los checkboxes del task-plan esten completos antes de que Claude pare:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "agent",
            "prompt": "Verifica que todas las tareas en *-task-plan.md tienen [x]. Si hay [ ] pendientes, retorna ok:false con las tareas faltantes. $ARGUMENTS",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

### PreToolUse para bloquear operaciones destructivas

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "if": "Bash(rm -rf *)",
            "command": "echo 'rm -rf bloqueado por hook' >&2 && exit 2"
          }
        ]
      }
    ]
  }
}
```

### Async hooks para tareas de fondo

Para operaciones lentas (tests, builds) que no deben bloquear a Claude:

```json
{
  "type": "command",
  "command": "bash .claude/scripts/run-tests.sh",
  "async": true,
  "timeout": 120
}
```

Los async hooks no pueden bloquear (la accion ya ocurrio). Su output se entrega en el
siguiente turno de conversacion como `systemMessage` o `additionalContext`.

### Hook pairs (UserPromptSubmit + Stop)

Patron para operaciones que requieren estado before/after — ej: tracking de consumo de tokens:

1. `UserPromptSubmit` guarda estado pre-mensaje (ej: conteo de tokens actual)
2. `Stop` calcula el delta y reporta

Ambos hooks pueden usar el mismo script, diferenciando por `hook_event_name` en el JSON de entrada.
El `session_id` permite aislar estado por sesion (ej: en `/tmp/claude-context-{session_id}.json`).

---

## Donde configurar hooks

| Ubicacion | Scope | Compartible |
|-----------|-------|-------------|
| `~/.claude/settings.json` | Todos los proyectos | No |
| `.claude/settings.json` | Proyecto actual | Si (commiteable) |
| `.claude/settings.local.json` | Proyecto actual | No (gitignored) |
| Managed policy | Organizacion completa | Si (enforced) |
| Plugin `hooks/hooks.json` | Mientras el plugin esta activo | Si |
| Frontmatter de SKILL | Mientras el skill esta activo | Si |
| Frontmatter de Agent | Mientras el agente corre | Si |

### Hooks en SKILL frontmatter

Los hooks de Skills/Agents solo estan activos mientras el componente esta activo.
El campo `once: true` garantiza que el hook corre solo una vez por sesion:

```yaml
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-phase.sh 'Phase 1'"
```

**Eventos soportados en component hooks:** `PreToolUse`, `PostToolUse`, `Stop`

### Hooks en frontmatter de subagente

Cuando un hook `Stop` esta definido en el frontmatter de un subagente, se convierte
automaticamente en `SubagentStop` scoped a ese subagente. Esto garantiza que el hook
solo dispara cuando ese subagente especifico completa, no cuando la sesion principal para:

```yaml
---
name: code-review-agent
description: Automated code review subagent
hooks:
  Stop:
    - hooks:
        - type: prompt
          prompt: "Verify the code review is thorough and complete."
  # Stop se convierte automaticamente a SubagentStop para este subagente
---
```

### Plugin hooks

Los plugins pueden incluir hooks en `hooks/hooks.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Ejecucion de hooks

| Aspecto | Comportamiento |
|---------|---------------|
| **Timeout default** | 60 segundos por hook (configurable con campo `timeout`) |
| **Paralelizacion** | Todos los hooks matching corren en paralelo |
| **Deduplicacion** | Comandos de hook identicos son deduplicados |
| **Entorno** | Corre en el directorio actual con el entorno de Claude Code |

---

## Limitaciones importantes

1. **Hooks command no pueden invocar comandos slash** (`/workflow-execute`, etc.)
2. **Timeout default: 60 segundos** para command hooks; 30s para prompt; 60s para agent (SessionEnd configurable via `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS`)
3. **PostToolUse no puede deshacer** la accion (ya ocurrio)
4. **PermissionRequest no dispara** en modo no-interactivo (`-p`)
5. **Bash(safe-cmd *) no permite** `safe-cmd && otro` — Claude Code trata operadores shell
   como comandos separados
6. **Checkpointing no captura cambios de bash** — cambios hechos por scripts de hooks
   no son revertibles via `/rewind` (ver reference checkpointing.md)
7. **HTTP hooks y env vars** — requieren lista explicita `allowedEnvVars` para interpolacion
   de variables en URLs; previene filtracion accidental a endpoints remotos

---

## Precedencia de decisiones

Cuando multiples hooks del mismo evento retornan decisiones:
`deny` > `defer` > `ask` > `allow`

El mas restrictivo gana. Las `deny` rules de settings.json tienen precedencia sobre
`allow` de hooks — un hook no puede loosen restricciones mas alla de lo que las reglas
permiten, solo endurecerlas.

---

## Seguridad

### Advertencia general

Los hooks ejecutan comandos shell arbitrarios. Eres completamente responsable de:
- Los comandos que configuras
- Permisos de acceso/modificacion de archivos
- Potencial perdida de datos o danos al sistema
- Probar hooks en entornos seguros antes de produccion

### Consideraciones especiales

- **Workspace trust:** Los output commands `statusLine` y `fileSuggestion` requieren
  aceptacion de workspace trust antes de tomar efecto.
- **`disableAllHooks`** — Respeta la jerarquia de managed settings: configuracion a nivel
  de organizacion puede forzar la deshabilitacion de hooks que usuarios individuales no
  pueden sobreescribir.
- **HTTP hooks** — Requieren `allowedEnvVars` explicito para usar interpolacion de variables
  de entorno en URLs.

### Best practices

| Hacer | No hacer |
|-------|---------|
| Validar y sanitizar todos los inputs | Confiar en datos de input ciegamente |
| Citar variables shell: `"$VAR"` | Usar sin citar: `$VAR` |
| Bloquear path traversal (`..`) | Permitir paths arbitrarios |
| Usar paths absolutos con `$CLAUDE_PROJECT_DIR` | Hardcodear paths |
| Saltar archivos sensibles (`.env`, `.git/`, keys) | Procesar todos los archivos |
| Probar hooks en aislamiento primero | Deployar hooks sin probar |
| Usar `allowedEnvVars` explicito para HTTP hooks | Exponer todas las env vars a webhooks |

---

## Debugging

### Modo debug

```bash
claude --debug
```

Muestra logs detallados de ejecucion de hooks.

### Verbose mode

`Ctrl+O` en Claude Code habilita verbose mode — muestra progreso de ejecucion de hooks.

### Probar hooks en forma independiente

```bash
# Probar con JSON de ejemplo
echo '{"tool_name": "Bash", "tool_input": {"command": "ls -la"}}' | python3 .claude/hooks/validate-bash.py

# Verificar exit code
echo $?
```

### Troubleshooting comun

**Hook no ejecuta:**
- Verificar sintaxis JSON correcta en la configuracion
- Verificar que el matcher coincide con el nombre de la herramienta
- Asegurarse de que el script existe y es ejecutable: `chmod +x script.sh`
- Correr `claude --debug` para ver logs de ejecucion
- Verificar que el hook lee JSON de stdin (no de argumentos)

**Hook bloquea inesperadamente:**
- Probar hook con JSON de muestra: `echo '{"tool_name": "Write", ...}' | ./hook.py`
- Verificar exit code: debe ser 0 para allow, 2 para block
- Revisar stderr (mostrado en exit code 2)

**Errores de parsing JSON:**
- Siempre leer de stdin, no de argumentos del comando
- Usar parsing JSON propio (no manipulacion de strings)
- Manejar campos faltantes con valores default

---

## Ver tambien

- [permission-model](permission-model.md) — Plano A (gates SKILL) vs Plano B (permisos herramienta)
- [checkpointing](checkpointing.md) — Interaccion entre hooks bash y rewind
- [claude-code-components](claude-code-components.md) — Skills, Agents, Context
- `.claude/settings.json` — Configuracion vigente del proyecto

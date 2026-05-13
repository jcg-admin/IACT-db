```yml
type: Reference
title: Hook Authoring — Guía para Crear Hooks de Claude Code
category: Authoring — Hooks
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Crear hooks — eventos disponibles, output control, patrones, errores comunes
```

# Hook Authoring — Guía para Crear Hooks de Claude Code

Guía completa para crear hooks en Claude Code. Cubre los tipos de eventos, configuración en settings.json, semántica del output control, y patrones comunes con ejemplos.

Para la referencia técnica de eventos y configuración general de THYROX, ver [hooks.md](hooks.md).
Para la semántica detallada de los campos de salida, ver [hook-output-control.md](hook-output-control.md).

---

## 1. Cuándo un Hook es la solución correcta

Un hook es correcto cuando:

| Situación | Por qué un hook |
|-----------|-----------------|
| Necesitas que algo ocurra **siempre** ante un evento del sistema | 100% determinístico — el harness lo ejecuta, no el LLM |
| Validar o transformar datos **antes** de que Claude los use | PreToolUse puede modificar inputs o bloquear la acción |
| Reaccionar **después** de que Claude hace algo | PostToolUse corre tras cada tool exitosa |
| Ejecutar lógica al inicio/fin de sesión | SessionStart / Stop / SessionEnd |
| Agregar contexto que Claude necesita para el próximo turno | Hooks pueden inyectar via `additionalContext` |

**NO usar un hook cuando:**

- Lo que necesitas es que Claude **razone** sobre algo → SKILL o CLAUDE.md
- Es una tarea que requiere múltiples pasos y herramientas → Agent
- Es conocimiento especializado que Claude debe tener disponible → SKILL
- La lógica depende del contexto de la conversación → Claude lo maneja mejor inline

**Señal clave:** Si el comportamiento debe ocurrir sin importar lo que diga el modelo, es un hook.

---

## 2. Tipos de eventos — tabla completa

Claude Code soporta 26 eventos. Los más usados en práctica:

### Eventos principales

| Evento | Cuándo dispara | Puede bloquear | Uso típico |
|--------|---------------|----------------|-----------|
| `SessionStart` | Al iniciar o reanudar sesión | No | Cargar estado, verificar entorno |
| `UserPromptSubmit` | Al enviar un prompt | Sí (exit 2) | Filtrar prompts, inyectar contexto |
| `PreToolUse` | Antes de ejecutar una herramienta | Sí (allow/deny/ask) | Validar antes de ejecutar, transformar input |
| `PermissionRequest` | Al mostrar diálogo de permiso | Sí (auto-approve/deny) | Aprobar/denegar según política |
| `PostToolUse` | Después de herramienta exitosa | No (ya ocurrió) | Sincronizar estado, agregar contexto |
| `PostToolUseFailure` | Después de herramienta fallida | No | Log de errores, feedback a Claude |
| `Stop` | Al terminar Claude de responder | Sí (exit 2) | Verificar completitud, validaciones finales |
| `SessionEnd` | Al terminar sesión | No | Cleanup, git check, logging |
| `PreCompact` | Antes de compactación | No | Guardar estado crítico |
| `PostCompact` | Después de compactación | No | Re-inyectar contexto perdido |

### Eventos de agentes y tareas

| Evento | Cuándo dispara | Cuándo usar |
|--------|---------------|-------------|
| `SubagentStart` | Al lanzar un subagente | Inyectar contexto al agente, setup |
| `SubagentStop` | Al terminar un subagente | Verificar resultado, cleanup del agente |
| `TeammateIdle` | Teammate termina y no tiene más trabajo | Coordinar equipos de agentes |
| `TaskCompleted` | Tarea marcada completa en Agent Teams | Post-task: validación, dashboards |

### Eventos de sistema

| Evento | Cuándo dispara | Uso |
|--------|---------------|-----|
| `InstructionsLoaded` | Después de cargar un CLAUDE.md o rules file | Modificar instrucciones cargadas |
| `ConfigChange` | Al cambiar settings.json | Audit de cambios de configuración |
| `CwdChanged` | Al cambiar el directorio de trabajo | Setup específico por directorio |
| `FileChanged` | Al cambiar un archivo vigilado | Recargar env, sync state |
| `WorktreeCreate` | Al crear un git worktree | Inicializar el worktree |
| `WorktreeRemove` | Al remover un git worktree | Cleanup del worktree |

### Eventos MCP

| Evento | Cuándo dispara |
|--------|---------------|
| `Elicitation` | Un MCP server solicita input del usuario |
| `ElicitationResult` | El usuario responde a un elicitation |

---

## 3. Configuración en settings.json

### Estructura base

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "PatternOpcional",
        "if": "FiltroFino(argumento)",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/mi-script.sh",
            "timeout": 30,
            "async": false,
            "once": false
          }
        ]
      }
    ]
  }
}
```

### Campos de configuración

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| `matcher` | Filtra por nombre de herramienta (regex) | `"Write"`, `"Edit\|Write"`, `"mcp__.*"` |
| `if` | Filtro fino por argumentos del tool | `"Bash(git *)"`, `"Write(/.claude/*)"`  |
| `type` | Tipo de hook: `command`, `http`, `prompt`, `agent` | `"command"` |
| `command` | Comando shell a ejecutar (solo `type: command`) | `"python3 .claude/hooks/check.py"` |
| `url` | URL del webhook (solo `type: http`) | `"https://my-api.com/hook"` |
| `prompt` | Prompt LLM (solo `type: prompt` o `agent`) | `"Verifica que las tareas estén completas"` |
| `timeout` | Timeout en segundos | `30` (default: 60) |
| `async` | Si true: no bloquea — resultado llega después | `true` |
| `once` | Si true: solo corre una vez por sesión | `true` |

### Dónde configurar

| Ubicación | Scope | Compartible |
|-----------|-------|-------------|
| `~/.claude/settings.json` | Todos los proyectos | No |
| `.claude/settings.json` | Proyecto actual | Sí (git) |
| `.claude/settings.local.json` | Proyecto actual | No (gitignored) |
| Frontmatter de SKILL | Solo mientras el skill está activo | Sí |
| Frontmatter de Agent | Solo mientras el agente corre | Sí |

### Matchers por evento

| Evento | Matcher | Descripción |
|--------|---------|-------------|
| `PreToolUse` / `PostToolUse` | Nombre del tool | `"Write"`, `"Edit\|Write"`, `"Bash"` |
| `SessionStart` | Tipo de inicio | `"startup"`, `"resume"`, `"clear"`, `"compact"` |
| `PreCompact` / `PostCompact` | Tipo de compactación | `"manual"`, `"auto"` |
| `UserPromptSubmit` / `Stop` | Sin matcher | Siempre dispara |

---

## 4. Output control — semántica de cada campo

Los hooks comunican sus decisiones via stdout (JSON) y exit codes. Es crítico entender qué controla cada campo:

### Exit codes

| Exit Code | Efecto |
|-----------|--------|
| `0` | Permitir. Si hay JSON en stdout, se procesa. |
| `2` | **Bloquear**. stderr se muestra como error a Claude. |
| Cualquier otro | Error no bloqueante. Ejecución continúa. |

**IMPORTANTE:** Solo `exit 2` bloquea. `exit 1` NO bloquea (contrario a la convención Unix estándar).

### `suppressOutput` — controla el stdout del hook, NO el tool result

```json
{ "suppressOutput": true }
```

**Lo que hace:** Suprime el stdout del hook en el debug log de Claude Code.
**Lo que NO hace:** No puede suprimir el resultado de un tool (ej: `"The file has been updated successfully."`). Ese string viene de la plataforma antes de que el hook PostToolUse corra.

### `additionalContext` — inyecta contexto al modelo (PostToolUse / UserPromptSubmit)

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Advertencia: posible API key hardcoded en línea 42 del archivo modificado"
  }
}
```

Claude ve este contexto en su próximo turno. Útil para: escaneo de secretos, linting post-escritura, análisis adicional.

### `updatedInput` — modifica el input al tool ANTES de ejecutarlo (PreToolUse)

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "updatedInput": {
      "file_path": "/path/normalizado.js",
      "content": "// Contenido sanitizado\n..."
    }
  }
}
```

Solo funciona en PreToolUse. Útil para: normalización de paths, sanitización de contenido, transformaciones previas.

### `permissionDecision` — decide allow/deny/ask (PreToolUse)

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Operación destructiva bloqueada por política de seguridad"
  }
}
```

| Valor | Efecto |
|-------|--------|
| `"allow"` | Ejecuta el tool sin preguntar al usuario |
| `"deny"` | Bloquea el tool, muestra reason al usuario |
| `"ask"` | Muestra el diálogo estándar de permiso |

### `continue` — detiene completamente a Claude

```json
{ "continue": false, "stopReason": "Validación fallida: tests no pasan" }
```

En Stop hooks: si `continue: false`, Claude no continúa y muestra `stopReason` al usuario.

### Matriz de capacidades por evento

| Campo | PreToolUse | PostToolUse | UserPromptSubmit | Stop |
|-------|-----------|------------|-----------------|------|
| `continue` | Si | Si | Si | Si |
| `suppressOutput` | Si | Si | Si | Si |
| `systemMessage` | Si | Si | Si | Si |
| `permissionDecision` | Si | No | No | No |
| `updatedInput` | Si | No | No | No |
| `additionalContext` | No | Si | Si | No |

---

## 5. Patrones comunes con ejemplos

### Patrón: sync-state (PostToolUse Write)

Cuando Claude escribe un archivo, actualizar el estado del proyecto automáticamente.

**settings.json:**
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

**Script `sync-wp-state.sh`:**
```bash
#!/bin/bash
# Lee el evento de stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin)['tool_input']['file_path'])" 2>/dev/null)

# Solo sincronizar si es un archivo de WP
if [[ "$FILE_PATH" == *"/context/work/"* ]]; then
    echo "Sincronizando estado para: $FILE_PATH" >&2
    python3 .claude/scripts/update-project-state.py "$FILE_PATH"
fi
exit 0
```

### Patrón: pre-flight check (PreToolUse Bash)

Validar comandos Bash antes de ejecutarlos.

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
            "command": "echo 'rm -rf bloqueado por política de seguridad' >&2 && exit 2"
          }
        ]
      }
    ]
  }
}
```

**Ejemplo avanzado con JSON output:**
```python
#!/usr/bin/env python3
import json, sys, re

BLOCKED_PATTERNS = [
    r"rm\s+-rf\s+/",
    r"DROP\s+TABLE",
    r"git\s+push\s+.*--force.*main",
]

data = json.load(sys.stdin)
command = data.get("tool_input", {}).get("command", "")

for pattern in BLOCKED_PATTERNS:
    if re.search(pattern, command, re.I):
        output = {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": f"Comando bloqueado por patrón de seguridad: {pattern}"
            }
        }
        print(json.dumps(output))
        sys.exit(0)

sys.exit(0)
```

### Patrón: logging (Stop hook)

Registrar resumen de sesión al terminar.

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/log-session.sh",
            "async": true
          }
        ]
      }
    ]
  }
}
```

**Script `log-session.sh`:**
```bash
#!/bin/bash
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
SESSION_ID=$(echo "$1" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('session_id','unknown'))" 2>/dev/null)

mkdir -p .claude/logs
echo "[$TIMESTAMP] Session ended: $SESSION_ID" >> .claude/logs/sessions.log
exit 0
```

### Patrón: notificación (Stop hook)

Notificar al usuario cuando Claude termina una tarea larga.

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/notify.sh",
            "async": true
          }
        ]
      }
    ]
  }
}
```

**Script `notify.sh`:**
```bash
#!/bin/bash
# macOS notification
if command -v osascript &>/dev/null; then
    osascript -e 'display notification "Claude ha terminado" with title "Claude Code"'
fi
# Linux notification
if command -v notify-send &>/dev/null; then
    notify-send "Claude Code" "Tarea completada"
fi
exit 0
```

### Patrón: session-resume (PostCompact)

Re-inyectar contexto crítico después de compactación.

```json
{
  "hooks": {
    "PostCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/session-resume.sh"
          }
        ]
      }
    ]
  }
}
```

**Script `session-resume.sh`:**
```bash
#!/bin/bash
# Leer estado del proyecto y retornar como additionalContext
if [ -f "context/now.md" ]; then
    NOW_CONTENT=$(cat context/now.md)
    python3 -c "
import json, sys
output = {
    'hookSpecificOutput': {
        'hookEventName': 'PostCompact',
        'additionalContext': '''Estado del proyecto post-compactación:\n$NOW_CONTENT'''
    }
}
print(json.dumps(output))
"
fi
exit 0
```

---

## 6. Errores frecuentes y cómo evitarlos

### Script no ejecutable

```bash
# Error: "Permission denied" al ejecutar el hook
# Solución: dar permisos de ejecución
chmod +x .claude/scripts/mi-hook.sh
```

**Verificar antes de commitear:**
```bash
ls -la .claude/scripts/*.sh
# Deben mostrar -rwxr-xr-x (con x)
```

### Paths relativos que no funcionan

```json
// Malo — path relativo que falla cuando cwd cambia
{ "command": "bash scripts/hook.sh" }

// Correcto — usar variable de entorno del proyecto
{ "command": "bash $CLAUDE_PROJECT_DIR/.claude/scripts/hook.sh" }
```

**Variables de entorno disponibles en hooks:**
- `$CLAUDE_PROJECT_DIR` — directorio raíz del proyecto
- `$CLAUDE_SESSION_ID` — ID de la sesión actual

### stdout contaminado

Un hook `command` que imprime texto no-JSON en stdout puede confundir al parser de Claude Code.

```bash
# Malo — stdout contaminado
#!/bin/bash
echo "Procesando..."  # Esto va a stdout — Claude Code intenta parsearlo como JSON
do_something
exit 0

# Correcto — usar stderr para logs
#!/bin/bash
echo "Procesando..." >&2  # Stderr: solo para debugging, no interfiere
do_something
exit 0
```

**Regla:** stdout del hook es SOLO para JSON estructurado (o vacío). Todo texto de debugging va a stderr.

### Confundir exit codes

```bash
# Malo — exit 1 no bloquea (contrario a la intuición Unix)
if [ "$VALIDATION" = "failed" ]; then
    echo "Error: validación fallida" >&2
    exit 1  # NO bloquea — Claude continúa
fi

# Correcto — exit 2 bloquea
if [ "$VALIDATION" = "failed" ]; then
    echo "Error: validación fallida — corregir antes de continuar" >&2
    exit 2  # SÍ bloquea
fi
```

### Hook en frontmatter de SKILL que no tiene `once: true`

```yaml
# Malo — el hook corre en CADA UserPromptSubmit mientras el skill está activo
hooks:
  - event: UserPromptSubmit
    type: command
    command: "echo 'phase: Phase 1' >> context/now.md"

# Correcto — solo corre una vez por sesión
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "echo 'phase: Phase 1' >> context/now.md"
```

---

## 7. Testing de hooks

### Probar el JSON input manualmente

Los hooks reciben JSON en stdin. Para testear sin ejecutar Claude Code completo:

```bash
# Simular un PostToolUse Write
echo '{
  "session_id": "test-123",
  "hook_event_name": "PostToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/home/user/project/context/work/2026-04-13-test/file.md",
    "content": "contenido de prueba"
  },
  "tool_response": { "success": true }
}' | bash .claude/scripts/sync-wp-state.sh
```

```bash
# Simular un PreToolUse Bash
echo '{
  "session_id": "test-123",
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "rm -rf /tmp/test"
  }
}' | python3 .claude/scripts/validate-bash.py
echo "Exit code: $?"
```

### Verificar el JSON output

```bash
# El hook debería retornar JSON válido o nada
echo '{"tool_name": "Write", "tool_input": {"file_path": "/test.md"}}' \
  | bash .claude/scripts/mi-hook.sh \
  | python3 -m json.tool  # Valida que el output es JSON válido
```

### Test con dry-run

Para hooks que modifican estado, añadir una variable de entorno de dry-run:

```bash
#!/bin/bash
INPUT=$(cat)

if [ "$HOOK_DRY_RUN" = "1" ]; then
    echo "DRY RUN: Hook ejecutado con input:" >&2
    echo "$INPUT" | python3 -m json.tool >&2
    exit 0
fi

# Lógica real del hook
```

```bash
# Testear sin efectos secundarios
HOOK_DRY_RUN=1 echo '{"test": "data"}' | bash .claude/scripts/mi-hook.sh
```

### Verificar que el hook está registrado

```bash
# Ver la configuración actual de hooks
cat .claude/settings.json | python3 -m json.tool | grep -A 20 '"hooks"'
```

---

## WorktreeCreate y WorktreeRemove — Ciclo de vida de worktrees

Los coordinators con `isolation: worktree` (Patrón 3/5) crean y destruyen worktrees automáticamente.
Estos hooks permiten inyectar comportamiento en ese ciclo de vida.

### Configuración en hooks/hooks.json (no en settings.json)

A diferencia de los demás hooks, `WorktreeCreate` y `WorktreeRemove` se configuran
en `hooks/hooks.json` del repositorio (no en `.claude/settings.json`):

```json
{
  "hooks": {
    "WorktreeCreate": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"systemMessage\":\"Worktree creado. .thyrox/context compartido desde el repo principal.\"}'"
          }
        ]
      }
    ],
    "WorktreeRemove": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"systemMessage\":\"Worktree eliminado.\"}'"
          }
        ]
      }
    ]
  }
}
```

### Casos de uso

| Hook | Caso de uso | Ejemplo |
|------|-------------|---------|
| `WorktreeCreate` | Notificar al coordinator que el worktree está listo | Inyectar mensaje de contexto |
| `WorktreeCreate` | Setup específico del worktree | Crear symlinks, copiar .env |
| `WorktreeRemove` | Cleanup de recursos del worktree | Eliminar archivos temporales |
| `WorktreeRemove` | Notificar cierre del ciclo | Log del resultado |

### Notas importantes

- El worktree comparte `.thyrox/context/` con el repo principal — `now.md` es el mismo archivo
- Si el coordinator no hace cambios: el worktree se limpia automáticamente (sin hook necesario)
- `systemMessage` en el output inyecta texto en el contexto del agente del worktree

---

## Referencias

- [hooks.md](hooks.md) — Referencia técnica de hooks en THYROX (configuración, patrones, limitaciones)
- [hook-output-control.md](hook-output-control.md) — Semántica completa de todos los campos de output
- [component-decision.md](component-decision.md) — Cuándo Hook vs SKILL vs Agent vs CLAUDE.md
- `.claude/settings.json` — Configuración de hooks del proyecto THYROX
- `.claude/scripts/` — Scripts de hooks del proyecto como referencia

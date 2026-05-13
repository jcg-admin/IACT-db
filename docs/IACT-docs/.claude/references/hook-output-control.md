```yml
type: Reference
title: Hook Output Control — Campos de Salida y Semánticas
category: Claude Code Platform — Hooks
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Semántica de suppressOutput (stdout del hook), additionalContext, updatedInput y permissionDecision
```

# Hook Output Control — Campos de Salida y Semánticas

Referencia para controlar el comportamiento de los hooks mediante su JSON output.
Los hooks comunican sus decisiones vía stdout (JSON) y exit codes — no vía stderr ni valor de retorno.

## Distinción crítica: canales de output

| Canal | Qué es | Quién lo ve |
|-------|--------|-------------|
| **stdout del hook** (JSON) | Output del hook mismo | Claude Code (lo parsea) |
| **stderr del hook** | Mensajes de error | Debug log / usuario |
| **Tool result** (del tool) | Resultado del tool (Read, Edit, Bash...) | Claude (en el contexto) |

**`suppressOutput` controla el stdout del hook en el debug log — NO controla el tool result.**

El tool result (ej. `"The file has been updated successfully."`) es generado por la plataforma *antes* de que el hook PostToolUse corra. Son canales distintos e independientes.

## Exit codes

| Exit Code | Significado | Comportamiento |
|-----------|------------|----------------|
| **0** | Éxito | Continúa, parsea JSON stdout |
| **2** | Error bloqueante | Bloquea la operación, stderr se muestra como error |
| **Otro** | Error no bloqueante | Continúa, stderr se muestra en verbose mode |

## Estructura del JSON output

```json
{
  "continue": true,
  "stopReason": "Mensaje opcional si se detiene",
  "suppressOutput": false,
  "systemMessage": "Mensaje de advertencia opcional al usuario",
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "Archivo en directorio permitido",
    "updatedInput": {
      "file_path": "/path/modificado.js"
    }
  }
}
```

## Campos del nivel raíz

### `continue` (boolean)

Controla si Claude sigue procesando o se detiene.

```json
{ "continue": false, "stopReason": "Tarea completada" }
```

- `true` (default) → Claude continúa normalmente
- `false` → Claude termina la sesión con `stopReason` como mensaje

**Úsalo en:** Stop hooks para indicar que el agente no debe continuar.

### `suppressOutput` (boolean)

Suprime el stdout **del hook** del debug log interno de Claude Code.

```json
{ "suppressOutput": true }
```

**No afecta al tool result.** Si un Edit tool devuelve `"The file has been updated successfully."`, ese string es el tool result de la plataforma y no puede suprimirse desde el hook.

**Úsalo en:** Hooks de logging o validación donde el output del hook es verbose y no aporta valor al debug log.

### `systemMessage` (string)

Muestra un mensaje de advertencia al usuario (visible en la UI de Claude Code).

```json
{ "systemMessage": "⚠️ Archivo sensible modificado: revisar cambios" }
```

**Úsalo en:** PostToolUse para alertas que el usuario debe ver sin bloquear la operación.

## Campos en `hookSpecificOutput`

### `permissionDecision` y `permissionDecisionReason` — PreToolUse

Controla si el tool se ejecuta:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Operación destructiva bloqueada por política"
  }
}
```

| Valor | Efecto |
|-------|--------|
| `"allow"` | Ejecuta el tool sin pedir al usuario |
| `"deny"` | Bloquea el tool, muestra reason al usuario |
| `"ask"` | Muestra el diálogo de permiso estándar al usuario |

**Alternativa:** Exit code 2 con stderr también bloquea — pero `permissionDecision: "deny"` es más controlado y permite un mensaje limpio.

### `updatedInput` — PreToolUse

Modifica los parámetros del tool *antes* de ejecutarlo:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "updatedInput": {
      "file_path": "/path/modificado.js",
      "content": "// Contenido transformado\n..."
    }
  }
}
```

**Úsalo en:** Normalización de rutas, sanitización de contenido, transformaciones previas a escritura.

**Restricción:** Solo funciona en PreToolUse. PostToolUse no puede modificar un resultado ya emitido.

### `additionalContext` — PostToolUse

Añade contexto al mensaje que Claude recibe *después* de que el tool ejecutó:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Advertencias de seguridad: posible API key hardcoded en línea 42"
  }
}
```

**Úsalo en:** Análisis post-escritura (escaneo de secretos, lint), información adicional que Claude debe conocer.

**Restricción:** Añade información, no puede retirar el tool result ya emitido.

## Campos de UserPromptSubmit

```json
{
  "decision": "block",
  "reason": "Patrón peligroso detectado en el prompt",
  "additionalContext": "Sugerencia: use operaciones más específicas"
}
```

| Campo | Efecto |
|-------|--------|
| `"decision": "block"` | Previene que Claude procese el prompt |
| `"reason"` | Mensaje mostrado al usuario cuando se bloquea |
| `"additionalContext"` | Contexto añadido al prompt (cuando no se bloquea) |

## Matriz de capacidades por evento

| Campo | PreToolUse | PostToolUse | UserPromptSubmit | Stop |
|-------|-----------|------------|-----------------|------|
| `continue` | ✓ | ✓ | ✓ | ✓ |
| `suppressOutput` | ✓ | ✓ | ✓ | ✓ |
| `systemMessage` | ✓ | ✓ | ✓ | ✓ |
| `permissionDecision` | ✓ | ✗ | ✗ | ✗ |
| `updatedInput` | ✓ | ✗ | ✗ | ✗ |
| `additionalContext` | ✗ | ✓ | ✓ | ✗ |
| `decision: "block"` | via permissionDecision | via "block" | ✓ | ✓ |

## Qué NO pueden hacer los hooks PostToolUse

- **No pueden retirar el tool result ya emitido.** El resultado de un Edit, Write, o Bash ya está en el contexto de Claude cuando PostToolUse corre.
- **No pueden modificar retroactivamente** lo que Claude leyó o escribió.
- **Solo pueden agregar** (`additionalContext`) o mostrar advertencias (`systemMessage`).

**Para suprimir tool results verbosos:** La solución correcta es delegación a subagentes. Ver [subagent-patterns](subagent-patterns.md).

## Prompt-based hooks (Stop / SubagentStop)

Los eventos `Stop` y `SubagentStop` soportan evaluación LLM como hook:

```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "prompt",
        "prompt": "¿Completó Claude todas las tareas solicitadas? Revisa si hay archivos sin crear o errores sin resolver.",
        "timeout": 30
      }]
    }]
  }
}
```

Respuesta del LLM:
```json
{
  "decision": "approve",
  "reason": "Todas las tareas completadas",
  "continue": false,
  "stopReason": "Tarea completa"
}
```

`"decision": "approve"` permite que el agente continúe; `"continue": false` termina la sesión.

## Component-scoped hooks

Los hooks pueden definirse directamente en el frontmatter de un skill o agente:

```yaml
---
name: secure-operations
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/check.sh"
          once: true  # Solo corre una vez por sesión
---
```

`once: true` previene que el hook se repita en cada tool call de la sesión.

**Cuando un subagente define un hook `Stop`**, se convierte automáticamente en `SubagentStop` scoped a ese subagente.

## Ejemplo completo — PostToolUse security scanner

```python
#!/usr/bin/env python3
import json, sys, re

SECRET_PATTERNS = [
    (r"api[_-]?key\s*=\s*['\"][^'\"]+['\"]", "Posible API key hardcoded"),
]

def main():
    data = json.load(sys.stdin)
    if data.get("tool_name") not in ["Write", "Edit"]:
        sys.exit(0)

    content = data.get("tool_input", {}).get("content", "") or \
              data.get("tool_input", {}).get("new_string", "")
    warnings = [msg for pat, msg in SECRET_PATTERNS if re.search(pat, content, re.I)]

    if warnings:
        output = {
            "hookSpecificOutput": {
                "hookEventName": "PostToolUse",
                "additionalContext": "Advertencias de seguridad: " + "; ".join(warnings)
            }
        }
        print(json.dumps(output))

    sys.exit(0)

main()
```

## PermissionRequest — Output format propio

El evento `PermissionRequest` usa una estructura diferente a `PreToolUse`. En lugar de `permissionDecision`, su output va bajo `decision` anidado dentro de `hookSpecificOutput`:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "allow",
      "updatedInput": {},
      "message": "Permiso concedido automáticamente para archivos en src/",
      "interrupt": false
    }
  }
}
```

| Campo en `decision` | Tipo | Efecto |
|---------------------|------|--------|
| `behavior` | `"allow"` \| `"deny"` | Aprueba o bloquea la solicitud de permiso |
| `updatedInput` | object | Modifica el input del tool antes de ejecutar (igual que `updatedInput` en PreToolUse) |
| `message` | string | Mensaje mostrado al usuario |
| `interrupt` | boolean | Si `true`, interrumpe el flujo e interrumpe al usuario |

**Distinción clave:** `PreToolUse` usa `hookSpecificOutput.permissionDecision` (`"allow"/"deny"/"ask"`). `PermissionRequest` usa `hookSpecificOutput.decision.behavior` (`"allow"/"deny"`). Son estructuras distintas para eventos distintos.

## PostToolUse — decision: "block"

Además de `additionalContext`, PostToolUse soporta un `decision: "block"` que detiene el flujo y muestra el feedback a Claude:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "El archivo contiene secretos hardcodeados en línea 42"
  },
  "continue": false,
  "stopReason": "Operación bloqueada por política de seguridad"
}
```

O con `decision` explícito en el nivel raíz del `hookSpecificOutput` (según el contexto de integración):

```json
{
  "decision": "block",
  "reason": "Secreto detectado en archivo escrito"
}
```

**Cuándo usar `decision: "block"` vs `additionalContext`:**

| Mecanismo | Efecto | Cuándo usarlo |
|-----------|--------|---------------|
| `additionalContext` | Claude recibe el contexto y continúa | Advertencias no bloqueantes (audit, lint) |
| `continue: false` + `stopReason` | Detiene la sesión con mensaje | Violación de política severa |
| `decision: "block"` + `reason` | Detiene y muestra reason | Bloqueo de paso en pipeline |

**Restricción:** PostToolUse no puede deshacer lo que el tool ya hizo — solo puede agregar contexto o detener el flujo antes del próximo paso.

## Stop / SubagentStop — campo `last_assistant_message` en el input

Los hooks de `Stop` y `SubagentStop` reciben un campo adicional en el JSON de entrada:

```json
{
  "session_id": "abc123",
  "hook_event_name": "Stop",
  "transcript_path": "/path/to/transcript.jsonl",
  "last_assistant_message": "He creado los 3 archivos solicitados y ejecutado las pruebas. Todos pasan."
}
```

`last_assistant_message` contiene el último mensaje completo de Claude (o del subagente) antes de detenerse. Esto permite que los prompt hooks evalúen si la tarea está realmente completa sin necesidad de parsear el transcript completo.

**Uso típico en un prompt hook:**

```json
{
  "type": "prompt",
  "prompt": "El último mensaje de Claude fue: {{last_assistant_message}}. ¿Completó todas las tareas solicitadas? Devuelve decision: approve o continue: true con feedback.",
  "timeout": 30
}
```

**Nota:** `last_assistant_message` solo está disponible en `Stop` y `SubagentStop` — no en `PreToolUse`, `PostToolUse`, ni `UserPromptSubmit`.


## Referencias

- `claude-howto/06-hooks/README.md` — Documentación oficial de hooks (fuente externa)
- [hooks](hooks.md) — Tipos de hooks, eventos, configuración general en THYROX
- [subagent-patterns](subagent-patterns.md) — Solución arquitectónica para tool result clutter
- `TD-037` — Investigación Edit tool silent mode (RESUELTO)

```yml
type: Reference
title: Stream Resilience — Recovery Patterns para Streams y Llamadas Largas
category: Claude Code Platform — Reliability
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: CLAUDE_STREAM_IDLE_TIMEOUT_MS, TTFToken, --fallback-model y recovery patterns
```

# Stream Resilience — Recovery Patterns para Streams y Llamadas Largas

Guía práctica de recuperación cuando el stream falla, el modelo tarda demasiado,
o el contexto acumulado convierte la sesión en irrecuperable.
Derivada de la experiencia real de FASE 33 (`skill-authoring-modernization`).

Para el catálogo completo de errores con diagnóstico rápido, ver
[streaming-errors.md](streaming-errors.md).

---

## Los dos tipos de error de stream

Antes de aplicar cualquier fix, identificar cuál de los dos es:

| Error | Señal | Mecanismo |
|-------|-------|-----------|
| `Stream idle timeout: partial response received` | El stream cierra **sin emitir ningún token** (o muy pocos), antes o durante la respuesta | El cliente cierra la conexión por inactividad de tokens durante > `CLAUDE_STREAM_IDLE_TIMEOUT_MS` ms |
| `Request timed out` | El stream **sí emite tokens** pero el turno dura demasiado | El turno completo supera el límite de tiempo del request aunque haya actividad continua |

**Diferencias clave:**

- El idle timeout ocurre durante **silencio de tokens** (Extended Thinking procesando en background, TTFToken alto por contexto grande).
- El request timeout ocurre cuando la respuesta es **objetivamente muy larga** — el modelo emite tokens continuamente pero el turno tarda más de lo permitido.
- Los dos pueden coexistir: una tarea que genera 700+ líneas primero silencia durante el razonamiento (idle timeout) y, si ese silencio no la mata, puede durar demasiado (request timeout).

---

## CLAUDE_STREAM_IDLE_TIMEOUT_MS

### Qué controla

El tiempo máximo (en milisegundos) que el cliente de Claude Code espera sin recibir
tokens antes de cerrar el stream. Si el modelo está en razonamiento silencioso
(Extended Thinking) durante más tiempo que este valor, el stream se cierra y se
reporta `partial response received`.

### Valor recomendado

```bash
export CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000  # 2 minutos
```

120000 ms (2 min) cubre la mayoría de los periodos de Extended Thinking silencioso,
incluso en sesiones con contexto moderado-grande.

### Cómo configurar

**Opción 1 — settings.json (persistente, recomendada):**

```json
{
  "env": {
    "CLAUDE_STREAM_IDLE_TIMEOUT_MS": "120000"
  }
}
```

**Opción 2 — .env del proyecto:**

```bash
CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000
```

**Opción 3 — exportar en shell antes de lanzar:**

```bash
export CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000
claude
```

### Advertencia critica: requiere reinicio de sesion

`CLAUDE_STREAM_IDLE_TIMEOUT_MS` se lee **al arrancar Claude Code**, no en tiempo de
ejecucion. Si la variable se configura dentro de una sesion que ya esta sufriendo
timeouts, el fix **no aplica** hasta que se inicie una sesion nueva.

```
Patron incorrecto:
  [Sesion activa] -> Editar settings.json -> CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000
  -> Seguir en la misma sesion -> Timeout persiste <- Fix no aplica

Patron correcto:
  Editar settings.json -> CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000
  -> Cerrar sesion -> Iniciar nueva sesion -> Fix aplica desde el arranque
```

---

## Time-to-First-Token (TTFToken)

### Definicion

TTFToken es el tiempo que transcurre desde que el usuario envia el mensaje hasta
que el modelo emite **el primer token** de respuesta. Durante este tiempo, el
modelo esta procesando el contexto completo — no emite nada al stream.

### La relacion critica

```
TTFToken = f(tamano del contexto)

Mayor contexto -> mas tokens que el modelo debe procesar -> mayor TTFToken
Mayor TTFToken -> mas probable que supere CLAUDE_STREAM_IDLE_TIMEOUT_MS
-> timeout antes de cualquier output
```

**Implicacion practica:** A partir de cierto tamano de contexto, **cualquier tarea**
puede causar idle timeout, independientemente de la estrategia de generacion. Esto
incluye mensajes cortos, Write calls, o incluso respuestas de una sola linea.

### El anti-patron de diagnostico

**El diagnostico dentro de la sesion afectada agrava el problema.**

```
Sesion A sufre timeout
-> Se analiza el problema (agrega 100-200 lineas al contexto)
-> Nuevo intento -> TTFToken mayor -> timeout mas probable
-> Se analiza mas profundamente (agrega otros 100-200 lineas)
-> Nuevo intento -> timeout mas rapido aun
-> Loop de degradacion
```

Este patron es analogo a depurar un memory leak agregando logs que consumen mas
memoria. Identificado como causa sistemica en FASE 33 con 4 Ishikawa consecutivos.

**Solucion:** Diagnosticar en sub-agente con contexto limpio, o en sesion nueva.

---

## `--fallback-model` — Fallback automatico cuando el modelo principal falla

```bash
# El modelo principal es opus; si falla, usa sonnet automaticamente
claude -p --model opus --fallback-model sonnet "consulta compleja"
```

**Cuando activar:**
- Tareas criticas en CI/CD donde la disponibilidad importa mas que el modelo exacto
- Modelos mas capaces a veces estan sobrecargados (overloaded)
- Combinacion recomendada: `--model opus --fallback-model sonnet`

**Comportamiento:**
- Si el modelo principal devuelve overload o error recoverable, reintenta con el fallback
- El fallback no aplica a errores de timeout del stream (esos son errores del lado cliente)

---

## StopFailure hook — Guardar estado cuando el turno termina en error

El evento `StopFailure` se dispara cuando una API error termina el turno abruptamente.
Usalo para guardar estado antes de que la informacion se pierda.

```json
{
  "hooks": {
    "StopFailure": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/scripts/on-stop-failure.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

**Ejemplo de script `on-stop-failure.sh`:**

```bash
#!/bin/bash
# Guardar timestamp y session_id del fallo para diagnostico posterior
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
SESSION_ID="${CLAUDE_SESSION_ID:-unknown}"
echo "$TIMESTAMP -- StopFailure en sesion $SESSION_ID" \
  >> "$CLAUDE_PROJECT_DIR/.claude/logs/stop-failures.log"
```

**Patron de uso:**
- Registrar en que punto de la tarea ocurrio el fallo
- Hacer snapshot de archivos en progreso antes de que el contexto se pierda
- Enviar notificacion (webhook, Slack) si la tarea era critica

**Nota:** `StopFailure` no puede bloquear la terminacion del turno (no puede reintentarlo).
Solo permite ejecutar acciones de cleanup/logging.

---

## `--resume` — Retomar sesion interrumpida

```bash
# Retomar por nombre de sesion
claude --resume "nombre-sesion"
# o con alias corto
claude -r "nombre-sesion"

# Retomar por session ID (UUID)
claude --resume "550e8400-e29b-41d4-a716-446655440000"
```

**Cuando usar `--resume` vs sesion nueva:**

| Situacion | Recomendacion |
|-----------|---------------|
| Sesion interrumpida por error de red o cierre accidental | `--resume` — recupera el historial |
| Sesion con timeout por contexto masivo | Sesion nueva — `--resume` hereda el mismo contexto grande |
| Sesion con timeout por `CLAUDE_STREAM_IDLE_TIMEOUT_MS` bajo (ya corregido) | `--resume` puede funcionar si el contexto no es el problema |
| Sesion irrecuperable (TTFToken > timeout para cualquier respuesta) | Sesion nueva obligatoriamente |

---

## `--include-partial-messages` — Recuperar mensajes parciales de timeout

```bash
claude -p --output-format stream-json --include-partial-messages "consulta"
```

**Que hace:** Incluye en el output los eventos de streaming parciales antes del timeout.

**Casos de uso:**
- Recuperar trabajo parcial de una sesion que termino con timeout
- Debugging: ver hasta que punto llego el modelo antes del error
- Pipelines que necesitan output parcial para analisis de fallo

**Ejemplo de uso en recovery:**

```bash
# Intentar recuperar output parcial de la sesion fallida
claude -p --resume <session-id> \
  --output-format stream-json \
  --include-partial-messages \
  "continua desde donde quedaste" 2>&1 | tee partial-recovery.jsonl
```

---

## Checkpoints — Estado intermedio en tareas largas

Claude Code crea checkpoints automaticamente con cada prompt del usuario. Los
checkpoints incluyen: mensajes, archivos modificados, historial de herramientas
y contexto de sesion.

### Cuando los checkpoints ayudan

| Escenario | Accion |
|-----------|--------|
| Antes de una operacion de larga duracion | Checkpoint auto (ocurre con cada prompt) |
| Sesion se acerca al limite de contexto | `/rewind` -> "Summarize from here" — compacta sin perder puntos clave |
| Approach incorrecto | `Esc+Esc` -> rewind al checkpoint anterior |
| Tarea destruye archivos inadvertidamente | Rewind -> "Restore code and conversation" |

### Interfaz

```bash
# Abrir navegador de checkpoints
Esc + Esc    # doble escape
# o
/rewind
/checkpoint  # alias
```

### Integracion con StopFailure hook

```
1. Tarea larga en progreso
2. Error de stream -> StopFailure hook ejecuta on-stop-failure.sh
3. Script guarda el estado relevante (archivo en progreso, posicion en la tarea)
4. Al reanudar: /rewind para volver al ultimo checkpoint antes del error
5. Continuar desde el estado guardado
```

### Retencion

- Checkpoints persisten hasta 30 dias (configurable: `cleanupPeriodDays`)
- No son sustituto de git — usalos para exploracion; commitea los resultados

---

## `--fork-session` — Clonar sesion para experimentar sin riesgo

```bash
# Forking desde CLI: crea nueva sesion independiente a partir de la existente
claude --resume <session-id-o-nombre> --fork-session "descripcion-del-experimento"

# Desde dentro de la sesion (REPL)
/fork
```

**Casos de uso:**
- Probar un approach alternativo sin perder el estado actual
- Debugging: replicar el estado de la sesion para investigar el problema en una copia
- A/B comparison: comparar dos implementaciones partiendo del mismo punto

**La sesion original queda intacta.** El fork es una sesion nueva e independiente.

---

## Estrategias preventivas

Ordenadas por impacto para FASE 33 y tareas similares:

### 1. Configurar CLAUDE_STREAM_IDLE_TIMEOUT_MS antes de sesiones intensivas

```json
{
  "env": {
    "CLAUDE_STREAM_IDLE_TIMEOUT_MS": "120000"
  }
}
```

Aplicar en `~/.claude/settings.json` (global) o `.claude/settings.json` (proyecto).
**Requiere reiniciar la sesion para aplicar.**

### 2. Fragmentar tareas largas en turnos pequenos

En lugar de generar 700 lineas en un turno, dividir en 3-5 Write calls independientes,
cada uno generando una seccion del documento.

```
Turno incorrecto:
  "Crea el spec completo de 18 archivos con 40 lineas cada uno"
  -> 700+ lineas en respuesta narrativa -> timeout

Turnos correctos:
  "Crea la seccion de API endpoints" -> Write call -> commit
  "Crea la seccion de modelos de datos" -> Write call -> commit
  "Crea la seccion de configuracion" -> Write call -> commit
```

### 3. Usar sub-agentes para sintesis con contexto limpio

El sub-agente recibe solo las referencias a los archivos que necesita, no el historial
completo del padre. Contexto inicial pequeño = TTFToken bajo.

```yaml
# Agente de sintesis con herramientas limitadas y contexto limpio
---
name: document-synthesizer
description: Sintetiza outputs de multiples agentes en documento final
tools: Read, Write
---
```

### 4. `/compact` antes de la fase de sintesis

Si el contexto ya es grande, compactar antes de la tarea de sintesis reduce el TTFToken:

```bash
# Dentro de la sesion, antes de generar documentos largos
/compact
```

### 5. Nueva sesion si el contexto es irrecuperable

Si TTFToken > timeout para cualquier respuesta (incluso mensajes cortos), la unica
solucion es iniciar sesion nueva con `CLAUDE_STREAM_IDLE_TIMEOUT_MS` ya configurado.

---

## Checklist de recovery rapido

```
Error de stream detectado
|
+-- Idle timeout (sin tokens / TTFToken alto)
|   +-- CLAUDE_STREAM_IDLE_TIMEOUT_MS configurado? No -> configurar + nueva sesion
|   +-- Si configurado -> contexto acumulado grande?
|       +-- Si -> /compact o nueva sesion
|       +-- No -> fragmentar la tarea en turnos mas pequenos
|
+-- Request timeout (turno demasiado largo, si emite tokens)
    +-- Fragmentar en multiples turnos
    +-- Usar Write tool en lugar de respuesta narrativa larga
    +-- Delegar generacion larga a sub-agente
```

---

## Referencias

- [streaming-errors.md](streaming-errors.md) — Catalogo completo de errores con diagnostico
- [long-running-calls.md](long-running-calls.md) — `--max-turns`, background agents, worktrees
- [hooks.md](hooks.md) — Configuracion completa de hooks (StopFailure, SessionEnd)
- Ejemplo THYROX: `.thyrox/context/work/2026-04-13-19-18-59-ishikawa-stream-analysis/`

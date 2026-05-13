```yml
type: Reference
title: Streaming Errors — Catálogo Completo con Causas y Fixes
category: Claude Code Platform — Reliability
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Catálogo de errores de streaming con causas, fixes y matriz de diagnóstico rápido
```

# Streaming Errors — Catalogo Completo con Causas y Fixes

Catalogo de errores de streaming en Claude Code con causas, diagnostico y fixes.
Para patrones de recovery y configuracion preventiva, ver
[stream-resilience.md](stream-resilience.md).

---

## Catalogo de errores — tabla principal

| Error | Cuando ocurre | Causa comun | Fix inmediato |
|-------|--------------|-------------|---------------|
| `Stream idle timeout: partial response received` | Stream sin tokens por > `CLAUDE_STREAM_IDLE_TIMEOUT_MS` | Extended Thinking silencioso; TTFToken alto por contexto grande | `CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000` + nueva sesion |
| `Request timed out` | Turno demasiado largo (si emite tokens pero supera limite) | Respuesta muy larga (700+ lineas) o contexto masivo | Fragmentar tarea; delegar a sub-agente con Write tool |
| `StopFailure` | API error termina el turno abruptamente | Cualquier error de API: overload, timeout, network | Hook StopFailure para guardar estado; reintentar |
| `Context limit exceeded` | Contexto > limite del modelo | Contexto acumulado sin /compact durante sesion larga | `/compact` o nueva sesion |
| `Rate limit exceeded` | Demasiadas requests en ventana de tiempo | Batch sin throttling; agentes paralelos sin limite | Exponential backoff; reducir concurrencia de agentes |
| `Tool execution failed` | Herramienta retorna exit code != 0 | Script de hook con error; permisos insuficientes | Revisar script; `chmod +x`; verificar permisos |

---

## `Stream idle timeout: partial response received` — analisis profundo

### Mecanismo exacto

```
Usuario envia mensaje
    |
    v
Claude Code inicia stream HTTP hacia la API
    |
    v
Modelo comienza a procesar el contexto (razonamiento interno)
    |
    v  <-- SILENCIO: ningun token emitido al stream
    |
    v
Si tiempo_sin_token > CLAUDE_STREAM_IDLE_TIMEOUT_MS:
    CLIENTE cierra la conexion
    Error: "Stream idle timeout: partial response received"
```

El idle timer se **resetea con cada token emitido**. Si el modelo esta en
Extended Thinking (razonamiento silencioso), no emite tokens y el timer avanza.

### Por que Extended Thinking causa silencio

Extended Thinking es un proceso de razonamiento interno del modelo que:
- Ocurre **antes** de emitir la respuesta visible
- Puede durar entre 10 y 120+ segundos dependiendo de la complejidad
- No emite tokens al stream durante ese periodo
- Se activa automaticamente en modelos Sonnet 4.6 / Opus 4.6

### El problema de TTFToken con contexto masivo

**TTFToken (Time-to-First-Token)** es el tiempo antes del primer token de respuesta.

```
TTFToken = tiempo_de_razonamiento_previo + tiempo_de_procesamiento_del_contexto

Con 50KB de contexto:  TTFToken ~ 5-15 segundos  (OK para la mayoria de timeouts)
Con 200KB de contexto: TTFToken ~ 30-60 segundos (riesgo si timeout < 60000ms)
Con 500KB+ de contexto: TTFToken ~ 60-120+ segundos (timeout con valores default)
```

A partir de cierto tamano de contexto, **incluso mensajes cortos y Write calls**
pueden sufrir idle timeout porque el modelo necesita procesar todo el historial
antes de emitir el primer token.

### Diagnostico: distinguir TTFToken vs Extended Thinking

| Patron | Causa probable |
|--------|---------------|
| Error ocurre **antes de cualquier output** (cero tokens emitidos) | TTFToken alto por contexto grande |
| Error ocurre **despues de algunos tokens** (respuesta empezada y cortada) | Extended Thinking silencioso durante respuesta parcial |
| Error ocurre en sesiones largas pero no en sesiones frescas | Contexto acumulado aumentando TTFToken |

### Fixes

| Causa | Fix |
|-------|-----|
| `CLAUDE_STREAM_IDLE_TIMEOUT_MS` bajo | Configurar a 120000 en settings.json + **nueva sesion** |
| TTFToken alto por contexto masivo | `/compact` para reducir contexto; o nueva sesion |
| Extended Thinking silencioso + timeout bajo | Aumentar timeout a 120000 ms |
| Sesion irrecuperable (cualquier mensaje causa timeout) | Nueva sesion obligatorio |

---

## `Request timed out` — analisis

### Diferencia con stream idle timeout

| Aspecto | Stream idle timeout | Request timed out |
|---------|--------------------|--------------------|
| Emision de tokens | Ninguna (o muy pocos) | Si — el modelo esta activamente generando |
| Causa raiz | Silencio de tokens excede IDLE_TIMEOUT_MS | El turno completo dura mas del limite del request |
| Tipicamente ocurre | Antes o al inicio de la respuesta | Durante una respuesta muy larga |
| Fix principal | Aumentar IDLE_TIMEOUT_MS | Fragmentar la tarea en turnos menores |

### Causas comunes

1. **Respuesta narrativa muy larga:** El padre genera 700+ lineas de texto como respuesta
   directa. La generacion de texto emite tokens continuamente pero simplemente tarda
   demasiado.

2. **Contexto masivo + respuesta moderada:** El modelo procesa 500KB de contexto y
   luego genera 200 lineas. El tiempo total (procesamiento + generacion) supera el
   limite del request.

3. **Multiple reads grandes antes de responder:** El padre lee outputs de 3 agentes
   (100-500KB cada uno) en el mismo turno y luego intenta responder — tiempo total
   demasiado.

### Cuando fragmentar vs delegar a sub-agente

| Situacion | Estrategia |
|-----------|-----------|
| Tarea es lineal pero grande (documento de 5 secciones) | Fragmentar en 5 turnos, uno por seccion |
| Tarea requiere leer muchos archivos primero | Sub-agente: lee archivos y escribe resultado; padre solo recibe path del archivo resultante |
| Sintesis de outputs de multiples agentes | Padre usa Write tool directamente en lugar de respuesta narrativa |

**Patron recomendado para sintesis:**

```
Incorrecto (causa request timeout):
  Padre lee output_a.md + output_b.md + output_c.md
  Padre genera respuesta narrativa de 500 lineas
  -> Request timeout

Correcto (evita timeout):
  Padre llama Write(final-doc.md) con contenido compilado
  El contenido va al tool input, no como texto de respuesta
  -> El stream emite tokens continuamente (tool input); no hay silencio
```

---

## `StopFailure` — analisis

### Que es

`StopFailure` no es un error del stream en si — es un **evento de hook** que se
dispara cuando Claude termina un turno con un error de API en lugar de una respuesta
exitosa. Ocurre despues de que el error ya sucedio.

### Hook de StopFailure

```json
{
  "hooks": {
    "StopFailure": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/scripts/on-stop-failure.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Debugging de hooks que causan fallo

Si un Stop hook (diferente de StopFailure) devuelve exit code != 0, eso en si mismo
causa que Claude reporto un error:

```bash
# Verificar que el script del hook es ejecutable
chmod +x .claude/hooks/my-hook.sh

# Probar el script manualmente con datos de prueba
echo '{"session_id":"test","hook_event_name":"Stop"}' | .claude/hooks/my-hook.sh

# Ver stderr del hook (Claude lo captura y lo incluye en el error)
```

---

## `--verbose` y `--debug` — diagnostico avanzado

### `--verbose`

```bash
# Ver razonamiento interno y detalles de herramientas
claude --verbose "consulta"
```

Muestra:
- Tokens de Extended Thinking (razonamiento interno visible)
- Detalle de cada tool call y su output
- Metadata de la sesion

**Dentro de la sesion activa:**
- `Ctrl+O` — Toggle verbose output (ver razonamiento)

### `--debug`

```bash
# Debug filtrado por categoria
claude --debug "api" "consulta"        # Solo debug de API calls
claude --debug "api,mcp" "consulta"   # API + MCP debug
```

Muestra:
- Requests y responses HTTP a la API de Anthropic
- Detalles de conectividad MCP
- Metadata de sesion interna

### `MAX_THINKING_TOKENS` — controlar el razonamiento

```bash
# Limitar tokens de Extended Thinking (menos thinking = menos silencio potencial)
export MAX_THINKING_TOKENS=8192   # Budget reducido
export MAX_THINKING_TOKENS=31999  # Budget maximo (default para Sonnet/Haiku)
```

**Tradeoff:** Menor budget de thinking = respuestas mas rapidas pero potencialmente
menos profundas en tareas complejas.

---

## Anti-patron de diagnostico — critico para THYROX

### El problema

**Diagnosticar un timeout DENTRO de la sesion que lo sufre empeora la condicion.**

Cada analisis, cada Ishikawa, cada exploracion de causas agrega contexto al historial
de la sesion. Mayor contexto -> mayor TTFToken -> el siguiente intento tiene mas
probabilidad de timeout.

```
Sesion con 200KB de contexto (ya en zona de riesgo)
-> Analisis de causa raiz (agrega 100 lineas = ~5KB)
-> 205KB -> TTFToken aumenta
-> Siguiente intento: timeout mas rapido
-> Mas analisis (agrega 150 lineas = ~7KB)
-> 212KB -> TTFToken aumenta mas
-> Sesion irrecuperable
```

Documentado en FASE 33 como "loop de degradacion de contexto" — 4 Ishikawa
consecutivos, cada uno agravando el problema que intentaba diagnosticar.

### La solucion

```
Opcion A — Sub-agente con contexto limpio:
  Padre (contexto grande) invoca sub-agente
  Sub-agente recibe solo: descripcion del problema + referencias a archivos
  Sub-agente analiza desde cero sin el contexto acumulado del padre
  Sub-agente escribe diagnostico en archivo
  Padre lee solo el archivo de diagnostico (no el analisis inline)

Opcion B — Sesion nueva:
  Cerrar sesion actual
  Iniciar sesion nueva (CLAUDE_STREAM_IDLE_TIMEOUT_MS ya configurado)
  Nueva sesion tiene TTFToken bajo (contexto inicial pequeno)
  Hacer diagnostico en sesion nueva
```

---

## Matriz de diagnostico rapido

```
Tengo un error de stream. Como lo diagnostico?

Pregunta 1: El error ocurre ANTES de cualquier output?
  Si -> TTFToken alto
       -> Causa: contexto acumulado grande
       -> Fix: CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000 + nueva sesion

  No -> Hay alguna respuesta parcial antes del error?

Pregunta 2: El error ocurre DURANTE una respuesta larga?
  Si -> Request timeout (turno demasiado largo)
       -> Fix: fragmentar tarea; usar Write tool; sub-agente para generacion

  No -> El error ocurre en hooks?

Pregunta 3: Hay un hook configurado que podria fallar?
  Si -> StopFailure o hook con exit code != 0
       -> Fix: revisar script del hook; chmod +x; probar manualmente

  No -> Error ocurre solo en sesiones largas?

Pregunta 4: La sesion tiene mucho historial?
  Si -> Contexto acumulado
       -> Fix: /compact para reducir; o sesion nueva
  No -> Puede ser rate limit u overload temporal
       -> Fix: esperar unos minutos; exponential backoff
```

---

## Patrones THYROX: errores observados en FASE 33

### Secuencia de errores en la sesion de authoring

1. **Primera ocurrencia:** Padre intenta generar spec de 700+ lineas como respuesta
   narrativa. Extended Thinking silencioso durante ~60s. Idle timeout.

2. **Segunda ocurrencia:** Con Write tool pero contexto ya mas grande por el intento
   anterior + analisis. TTFToken > IDLE_TIMEOUT_MS. Timeout antes del primer token.

3. **Tercera ocurrencia:** Sin ningun tool call — solo anunciar la accion ya triggeriza
   suficiente razonamiento. Contexto irrecuperable.

4. **Cuarta ocurrencia:** `CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000` configurado en
   settings.json pero DENTRO de la sesion activa. Fix no aplica — settings.json se
   lee al arrancar.

### Leccion central

```
run_in_background (agentes paralelos)
  RESUELVE: contexto de subagentes (cada uno con su propio context window)
  RESUELVE: bloqueo del padre (no espera sincrónicamente)
  NO RESUELVE: timeout del turno de SINTESIS del padre
  NO RESUELVE: TTFToken alto del padre con contexto acumulado

Write tool (sintesis directa)
  RESUELVE: evita la fase de razonamiento narrativo previa
  RESUELVE: el contenido va al tool input, no como texto de respuesta
  NO RESUELVE: TTFToken alto si el contexto del padre es masivo
```

---

## Referencias

- [stream-resilience.md](stream-resilience.md) — Recovery patterns y configuracion preventiva
- [long-running-calls.md](long-running-calls.md) — Estrategias para llamadas largas
- [hooks.md](hooks.md) — StopFailure y otros eventos de error
- Ejemplo THYROX: `.thyrox/context/work/2026-04-13-19-18-59-ishikawa-stream-analysis/analysis/ishikawa-stream-analysis.md`

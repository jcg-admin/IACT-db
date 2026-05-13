```yml
type: Reference
title: Long-Running Calls — Estrategias para Llamadas y Tareas Largas
category: Claude Code Platform — Reliability
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: --max-turns, background vs print mode, síntesis del padre, worktrees y checkpoints para tareas largas
```

# Long-Running Calls — Estrategias para Llamadas y Tareas Largas

Guia para manejar tareas que toman tiempo: `--max-turns`, `--max-budget-usd`,
background agents, agent teams, worktrees, y checkpoints.
Derivada de la experiencia real de FASE 33 (`skill-authoring-modernization`).

Para errores especificos de stream, ver [streaming-errors.md](streaming-errors.md).
Para recovery cuando algo falla, ver [stream-resilience.md](stream-resilience.md).

---

## `--max-turns` — Limitar numero de turnos de agente

```bash
# Limitar a 3 turnos de agente en modo print
claude -p --max-turns 3 "refactorizar este modulo"

# En CI/CD con presupuesto de turnos definido
claude -p --max-turns 5 --output-format json "analizar cobertura de tests"
```

**Cuando usar:**
- CI/CD: definir un presupuesto de turnos para evitar loops infinitos
- Tareas con alcance conocido: si sabes que la tarea requiere <= N turnos
- Experimentos controlados: explorar cuanto hace el modelo en N turnos

**Comportamiento al alcanzar el limite:**
- Claude para y reporta el estado hasta donde llego
- No lanza error — es una terminacion controlada
- El output hasta ese punto esta disponible

---

## `--max-budget-usd` — Limitar costo en dolares

```bash
# No gastar mas de 2 dolares en esta query
claude -p --max-budget-usd 2.00 "analizar todo el codebase"

# Combinado con modelo mas economico
claude -p --model haiku --max-budget-usd 0.50 "formatear todos los JSONs"
```

**Cuando usar:**
- Experimentos: explorar cuanto hace el modelo con $X de presupuesto
- Batch jobs: controlar el costo de procesar N archivos
- Ambientes donde el costo es restriccion primaria

**Granularidad:**
- Se mide en USD, no en tokens
- Claude para cuando el presupuesto se agota
- El modelo mas economico (Haiku) maximiza el trabajo por dolar

---

## Background agents — `run_in_background: true`

Los agentes en background ejecutan asincrónicamente respecto al padre, con su
propio context window independiente.

### Como invocar background agents

En el frontmatter del agente (siempre background):

```yaml
---
name: mi-agente
description: Agente que siempre corre en background
background: true
tools: Read, Write, Bash
---
```

O en la invocacion del Agent tool:

```json
{
  "run_in_background": true,
  "prompt": "Analiza todos los archivos en src/ y genera un reporte"
}
```

### Diferencia con print mode (`-p`)

| Aspecto | `run_in_background=true` | Print mode (`-p`) |
|---------|--------------------------|-------------------|
| Tipo de ejecucion | Agente completo con herramientas | Query unica no-interactiva |
| Herramientas disponibles | Todas (segun configuracion) | Todas |
| Retorno al padre | Asincrono — padre no bloquea | N/A — es el agente principal |
| Output | Archivos escritos + resultado final | stdout solamente |
| Sesion | Separada del padre | Sin sesion |
| Uso tipico | Tareas paralelas largas | Pipelines CI/CD, batch queries |

### Cuando usar background vs print mode

```
Background agents: cuando el padre necesita continuar trabajando mientras
el sub-agente ejecuta. Util para paralelismo y tareas largas.

Print mode (-p): cuando quieres una sola query no-interactiva desde un
script externo, sin sesion persistente. Ideal para CI/CD.
```

---

## Insight critico: el padre sigue en riesgo de timeout en la SINTESIS

Este es el insight mas importante derivado de FASE 33.

### Lo que resuelven los agentes paralelos

```
run_in_background (Parallel Agents)
  RESUELVE: contexto de subagentes (cada uno tiene su propio context window)
  RESUELVE: bloqueo del padre (no espera sincronicamente)
  RESUELVE: distribucion de carga de trabajo entre multiples agentes
```

### Lo que NO resuelven

```
run_in_background (Parallel Agents)
  NO RESUELVE: timeout del turno de SINTESIS del padre
  NO RESUELVE: stream idle timeout del padre al razonar sobre grandes outputs
```

### Por que el padre sigue en riesgo

Despues de que los agentes paralelos terminan, el padre debe:
1. Leer los outputs de cada agente (potencialmente 100-500KB cada uno)
2. Razonar sobre esos outputs (Extended Thinking silencioso)
3. Generar una respuesta de sintesis (potencialmente 500+ lineas)

Si el padre intenta hacer los 3 pasos en un solo turno como respuesta narrativa,
sufre exactamente el mismo timeout que sufriria sin agentes paralelos.

### La solucion: Write tool en lugar de respuesta narrativa

```
Patron incorrecto (el padre todavia puede hacer timeout):
  Sub-agente A escribe output_a.md
  Sub-agente B escribe output_b.md
  Sub-agente C escribe output_c.md
  Padre lee los tres outputs
  Padre genera respuesta narrativa de 600 lineas (TIMEOUT)

Patron correcto (el padre no hace timeout):
  Sub-agente A escribe output_a.md
  Sub-agente B escribe output_b.md
  Sub-agente C escribe output_c.md
  Padre llama Write(final-doc.md) con el contenido compilado
  El contenido va al tool input del Write, no como texto de respuesta
  El stream emite tokens continuamente (tool input); no hay silencio prolongado
```

**Regla practica para el padre de agentes paralelos:**
> El padre orquesta y **escribe archivos**. No genera respuestas narrativas largas.

---

## Planning Mode — Plan antes de ejecutar en tareas largas

```bash
# Activar planning mode via CLI
claude --permission-mode plan "implementar sistema de cache"

# Dentro de la sesion
/plan Implementar autenticacion con JWT
```

**Como funciona:**
1. Claude analiza la tarea y genera un plan detallado
2. El usuario revisa y aprueba (o modifica) el plan
3. Claude ejecuta el plan aprobado

**Integracion con THYROX Phase 1 (ANALYZE):**
Planning mode es el equivalent tecnico de Phase 1-2 del framework THYROX.
Usarlo antes de tareas grandes previene el caso donde el modelo empieza a
ejecutar sin entender el alcance completo.

```bash
# Para tareas muy complejas: usar opusplan
# (Opus planifica, Sonnet ejecuta)
claude --model opusplan "disenar e implementar la capa de cache"
```

---

## Agent Teams — Equipos de agentes experimentales

```bash
# Habilitar via variable de entorno
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# O en settings.json
{
  "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
}
```

### Como funcionan

- Un **team lead** coordina la tarea general y delega subtareas a teammates
- Los **teammates** trabajan independientemente, cada uno con su propio context window
- Dos modos de display: `--teammate-mode default` o `--teammate-mode tmux`

### Diferencia con sub-agents normales

| Aspecto | Sub-agents normales | Agent Teams |
|---------|--------------------|-----------:|
| Coordinacion | El padre invoca cada agente explicitamente | Team lead coordina autonomamente |
| Visibilidad | Solo el padre ve todos los resultados | Los teammates pueden comunicarse |
| Escala | Apropiado para 2-5 tareas paralelas | Apropiado para proyectos muy grandes |
| Madurez | Estable | Experimental (puede cambiar) |

### Casos de uso

- Proyectos con muchos subsistemas independientes (frontend + backend + infra)
- Refactorizaciones masivas que afectan decenas de archivos
- Code review coordinado donde diferentes agentes revisan diferentes aspectos

> Nota: Agent Teams es experimental. Ver documentacion oficial para actualizaciones.

---

## Git Worktrees — Trabajo paralelo aislado

Git Worktrees permiten ejecutar Claude Code en una rama aislada sin afectar
el directorio de trabajo principal.

### Uso basico

```bash
# Iniciar Claude Code en un worktree aislado
claude --worktree
# o
claude -w
```

### Worktrees en subagentes

En el frontmatter de un agente:

```yaml
---
name: experimental-agent
description: Agente que trabaja en rama experimental
isolation: worktree
tools: Read, Write, Bash, Edit
---
```

`isolation: worktree` le da al agente su propio worktree de git — puede hacer
cambios sin afectar la rama principal del proyecto.

### Casos de uso

```
Feature paralelas: dos agentes trabajando en features diferentes,
cada uno en su propio worktree, sin conflictos de archivos.

A/B de codigo: comparar dos implementaciones en worktrees separados.

Refactorizacion segura: el agente trabaja en un worktree; si algo sale mal,
el worktree se descarta sin afectar el trabajo principal.
```

### Hooks de worktree

```json
{
  "hooks": {
    "WorktreeCreate": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/scripts/init-worktree.sh"
          }
        ]
      }
    ]
  }
}
```

**Auto-cleanup:** Si no se hacen cambios en el worktree, se elimina automaticamente
al terminar la sesion.

---

## Scheduled tasks — Tareas programadas

Para tareas recurrentes o programadas, ver [scheduled-tasks.md](scheduled-tasks.md).

Referencia rapida:

```bash
# Tarea recurrente (cada 5 minutos)
/loop 5m verificar si el deploy termino

# Recordatorio unico
/loop once at 3pm ejecutar los tests de integracion
```

Los scheduled tasks son scoped a la sesion — se borran cuando la sesion termina.
Para tareas que sobreviven reinicios, usar Desktop App scheduled tasks o CI/CD.

---

## Checkpoints — Estado intermedio en tareas largas

Los checkpoints se crean automaticamente con cada prompt del usuario.

### Cuando usar checkpoints en tareas largas

```
1. Inicio de tarea larga (checkpoint auto al primer prompt)
2. Completar milestone intermedio -> commit git (mas importante que el checkpoint)
3. Antes de operacion destructiva -> verificar que existe checkpoint reciente
4. Si la tarea falla -> Esc+Esc -> rewind al ultimo checkpoint bueno
5. Al terminar -> commit git de todo lo producido
```

### Integracion con `--resume`

```bash
# El checkpoint NO es lo mismo que la sesion
# Para retomar desde el ultimo punto, usar:
claude --resume "nombre-sesion"  # Retoma la sesion completa

# Para rewind dentro de la sesion:
Esc + Esc  # Abre el navegador de checkpoints
```

### Checkpoints vs git commits

| Aspecto | Checkpoint | Git commit |
|---------|-----------|------------|
| Granularidad | Cada prompt | Cada milestone |
| Permanencia | 30 dias | Permanente |
| Incluye | Conversacion + archivos | Solo archivos |
| Compartible | No | Si |

**Regla:** Checkpoints para explorar; git commits para preservar.

---

## Estrategia recomendada para THYROX (basada en FASE 33)

Estas recomendaciones son el resultado directo de la experiencia con timeouts,
parallelismo y sintesis de documentos largos.

### Para tareas > 5 archivos: paralelizar con 3-4 sub-agentes

```
Arquitectura recomendada:

Orquestador (padre):
  - Define los grupos de trabajo (Grupo A, B, C)
  - Invoca sub-agentes con run_in_background=true
  - Espera que todos completen
  - Llama Write() para el documento final (NO respuesta narrativa)
  - Hace commit

Sub-agente A (archivos 1-5):
  - Contexto limpio: recibe solo la lista de archivos a crear
  - Escribe archivos directamente
  - Termina

Sub-agente B (archivos 6-10):
  - Contexto limpio: recibe solo su lista
  - Escribe archivos directamente
  - Termina

Sub-agente C (archivos 11-15):
  - Contexto limpio: recibe solo su lista
  - Escribe archivos directamente
  - Termina
```

### El padre solo orquesta y commitea

El padre NO debe:
- Generar contenido de 100+ lineas como respuesta narrativa
- Leer todos los outputs de los sub-agentes y sintetizarlos en texto
- Acumular contexto de las ejecuciones de los sub-agentes

El padre SI debe:
- Invocar agentes con background=true
- Esperar resultados
- Usar Write tool para archivos de sintesis
- Hacer git commit de los resultados

### CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000 en settings.json

```json
{
  "env": {
    "CLAUDE_STREAM_IDLE_TIMEOUT_MS": "120000"
  }
}
```

Aplicar en `~/.claude/settings.json` para que aplique a todas las sesiones.

### /compact antes de la fase de sintesis

Si el orquestador tiene contexto acumulado antes de la fase de sintesis:

```bash
# Compactar antes de generar documentos finales
/compact
```

Esto reduce el TTFToken del padre, disminuyendo el riesgo de idle timeout
durante la generacion del documento de sintesis.

---

## Resumen rapido de flags de control

```bash
# Limitar turnos (CI/CD)
claude -p --max-turns 5 "tarea"

# Limitar costo
claude -p --max-budget-usd 2.00 "tarea"

# Fallback automatico de modelo
claude -p --model opus --fallback-model sonnet "tarea critica"

# Worktree aislado
claude -w

# Retomar sesion
claude -r "nombre-sesion"

# Fork para experimentar
claude --resume nombre --fork-session "experimento"

# Debug de API calls
claude --debug "api" "tarea"
```

---

## Referencias

- [streaming-errors.md](streaming-errors.md) — Catalogo de errores con diagnostico
- [stream-resilience.md](stream-resilience.md) — Recovery cuando algo falla
- [subagent-patterns.md](subagent-patterns.md) — Patrones de sub-agentes
- [scheduled-tasks.md](scheduled-tasks.md) — Tareas programadas completo
- [checkpointing.md](checkpointing.md) — Checkpoints y rewind
- Ejemplo THYROX: `.thyrox/context/work/2026-04-12-10-10-50-skill-authoring-modernization/analysis/stream-timeout-root-cause.md`

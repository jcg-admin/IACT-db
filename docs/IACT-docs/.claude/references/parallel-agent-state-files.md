```yml
created_at: 2026-04-20 13:53:00
project: THYROX
author: NestorMonroy
status: Borrador
```

# State Files para Ejecución Paralela de Agentes

## Convención de naming

| Contexto | Archivo | Propietario |
|----------|---------|-------------|
| Estado compartido / orquestador | `.thyrox/context/now.md` | Orquestador principal |
| Agente nativo en ejecución | `.thyrox/context/now-{agent-name}.md` | El agente |
| Skill especializado | `.thyrox/context/now-{skill-name}-{wp-id}.md` | El skill |
| Gate evaluador (paralelo) | `.thyrox/context/gate-{stage}-eval-{n}.json` | Evaluador N |
| Gate Merger output | `.thyrox/context/gate-{stage}-merged.json` | Merger |

## Dos tipos de state files — ciclos de vida distintos

### Tipo A — Gate evaluadores paralelos (coordinación Merger)

Agentes que operan en paralelo y son consumidos por un Merger antes de avanzar un gate.
Ejemplo: `gate-consistency-evaluator`, evaluadores de completitud/separabilidad.

```yml
agent_id: {agent-name}           # identificador único del agente
status: running|completed|failed  # estado actual
output_key: {nombre}             # qué output_key produce este agente
started_at: YYYY-MM-DD HH:MM:SS  # timestamp de inicio
timeout_at: YYYY-MM-DD HH:MM:SS  # timestamp de expiración (started_at + límite)
```

**Lifecycle:** orquestador lanza → agente escribe `status: running` → agente completa → Merger lee → Merger elimina el file.

### Tipo B — Agente secuencial con bookmark de sesión

Agentes que usan `now-{agent}.md` como bookmark de reanudación (para continuar si la sesión se interrumpe), NO como coordinación con un Merger.
Ejemplo: `task-executor`.

```yml
agent_id: task-executor
status: running                  # REQUERIDO — permite auto-cleanup en validate-session-close.sh
tarea_activa: T-NNN en curso
proximo_paso: descripción
wp: YYYY-MM-DD-HH-MM-SS-nombre
started_at: YYYY-MM-DD HH:MM:SS
```

**Lifecycle:** agente escribe al inicio → actualiza durante ejecución → al completar: actualiza `status: completed` → **elimina el file** (`rm .thyrox/context/now-task-executor.md`).

**Regla crítica:** `status: running|completed` es OBLIGATORIO en ambos tipos. Sin él, `validate-session-close.sh` no puede distinguir un agente activo de uno terminado.

## Protocolo de lectura por el Merger (Tipo A)

1. Leer todos los `now-{evaluator-N}.md` de los evaluadores paralelos
2. Verificar `status=completed` en cada uno antes de consolidar
3. Si algún evaluador tiene `status=running` y `timeout_at` expirado → tratarlo como `status=failed`
4. Si `status=failed`: Merger procede con N-1 evaluadores y registra el evaluador fallido como gap en el reporte
5. NUNCA inferir un output de un evaluador que no completó

## Reglas de cleanup

| Tipo | Quién elimina | Cuándo |
|------|--------------|--------|
| Gate eval (`gate-*-eval-*.json`) | Merger | Al consumir el resultado |
| now-{agent}.md Tipo A | Merger | Al confirmar recepción |
| now-{agent}.md Tipo B | El agente mismo | Al actualizar `status: completed` |
| now-{agent}.md con error | Persiste | Para diagnóstico manual |

## Verificación en validate-session-close.sh

`validate-session-close.sh` Check 2 lee el campo `status` antes de emitir WARN:

- `status: completed` → **auto-cleanup silencioso** (el script lo elimina sin WARN)
- `status: running` o `status` ausente → **WARN** (riesgo real de pérdida de resultado)
- `gate-{stage}-eval-*.json` sin su `gate-{stage}-merged.json` → **WARN** "gate files huérfanos"

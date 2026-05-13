```yml
type: Reference
title: Scheduling y Automatización THYROX
category: Phase 10 EXECUTE — Automatización
version: 1.0
created_at: 2026-04-16
owner: workflow-execute
purpose: Patrones de ejecución continua, /loop, Desktop Scheduled Tasks y CI/CD para THYROX
```

# Scheduling y Automatización THYROX

Guía de referencia para automatizar la ejecución del ciclo THYROX sin intervención manual.

---

## Mecanismos disponibles

| Mecanismo | Persistencia | Requiere | Caso de uso |
|-----------|-------------|----------|-------------|
| `/loop N` | Sesión | REPL activo | Avanzar Phase 10 durante sesión de trabajo |
| Desktop Scheduled Task | Entre reinicios | Desktop App abierto | Sync diario de estado, documentación nocturna |
| `/schedule` (Cloud) | Permanente | Plan Team/Enterprise | CI/CD, reporting automático sin máquina local |
| `claude -p` (headless) | N/A | CLI instalado | GitHub Actions, pipelines |

---

## 1. `/loop` — Ejecución continua en sesión

La forma más directa de auto-avanzar Phase 10 durante una sesión activa:

```bash
# Ejecutar /thyrox:loop cada 10 minutos
/loop 10m /thyrox:loop

# Para WPs con muchas tareas pequeñas
/loop 5m /thyrox:loop

# Para tareas más largas
/loop 30m /thyrox:loop

# Con cron expression (ejecutar a cada hora en punto)
/loop 0 * * * * /thyrox:loop
```

El comando `/thyrox:loop` se detiene automáticamente cuando:
- Detecta un gate humano (`[GATE]` en la descripción de la tarea)
- Hay un error de implementación
- Todas las tareas están `[x]`
- La fase activa no es Phase 10

### Gestión de tareas `/loop`

```
/task list              # Ver loops activos
/task cancel {id}       # Detener un loop específico
```

### Límites del loop

| Aspecto | Valor |
|---------|-------|
| Máximo loops por sesión | 50 |
| TTL recurrente | 3 días |
| Jitter | Hasta 10% del intervalo (máx 15 min) |
| Persistencia | Solo mientras Claude Code está activo |

---

## 2. Desktop App — Tareas programadas persistentes

Para tareas que deben ejecutarse aunque se reinicie Claude Code.
Las tareas de Desktop App sobreviven entre sesiones mientras el Desktop App esté abierto.

### Crear tarea de sync nocturno

Crear el archivo `~/.claude/scheduled-tasks/thyrox-nightly/SKILL.md`:

```markdown
# Thyrox Nightly Documentation Sync

Ejecutar al terminar cada día para mantener el estado documentado.

Frecuencia: daily

## Instrucciones

1. Leer `.thyrox/context/now.md` — identificar WP activo y fase
2. Leer el `*-task-plan.md` del WP activo:
   - Contar tareas completadas [x] vs pendientes [ ]
   - Identificar si hay bloqueos o errores
3. Actualizar `.thyrox/context/focus.md`:
   - Agregar entrada con fecha de hoy
   - Registrar progreso: "{N_completadas}/{N_total} tareas [x]"
   - Listar próximas 3 tareas pendientes
4. Si hay cambios sin commit → commit: `chore(state): nightly sync {date}`
5. Verificar que `now.md::updated_at` tiene timestamp de hoy
6. Reportar resumen: "Sync {date}: {estado del WP}"
```

### Crear tarea de health check semanal

Crear `~/.claude/scheduled-tasks/thyrox-weekly/SKILL.md`:

```markdown
# Thyrox Weekly Health Check

Frecuencia: weekly (lunes)

## Instrucciones

1. Leer `.thyrox/context/technical-debt.md`
2. Listar todos los WPs en `.thyrox/context/work/`
3. Identificar WPs con fase incompleta (sin lessons-learned.md)
4. Generar reporte en `.thyrox/context/research/weekly-{date}.md`:
   - WPs activos y su estado
   - Deuda técnica pendiente
   - Próximos pasos recomendados
5. Si hay TDs urgentes → agregar nota en `focus.md`
```

---

## 3. Cloud Routines — `/schedule`

Para automatización que no requiere máquina local activa (requiere plan Team/Enterprise):

```bash
# Sync de estado diario a las 9am
/schedule daily at 9am check .thyrox/context/now.md and update focus.md with today's priorities

# Reporte semanal los lunes
/schedule weekly monday at 8am generate a progress report from .thyrox/context/work/ and save to .thyrox/context/research/

# Alerta si un WP lleva más de 3 días sin commits
/schedule daily at 6pm check git log for thyrox commits in the last 72 hours. If none found, add a reminder to .thyrox/context/focus.md
```

---

## 4. CI/CD con `claude -p` (headless)

Para pipelines de GitHub Actions u otros sistemas CI/CD:

### GitHub Actions — documentación automática

```yaml
# .github/workflows/thyrox-docs.yml
name: THYROX Documentation Sync

on:
  push:
    branches: [main]
  schedule:
    - cron: '0 9 * * 1'  # Lunes 9am

jobs:
  sync-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code

      - name: Sync THYROX state
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude -p --max-turns 3 \
            "Read .thyrox/context/now.md and all *-task-plan.md files.
             Generate a JSON progress report with:
             - active_wp: nombre del WP activo
             - phase: fase actual
             - completed_tasks: número de [x]
             - pending_tasks: número de [ ]
             - blockers: lista de bloqueos
             Output ONLY the JSON." \
            --output-format json > thyrox-status.json

      - name: Upload status artifact
        uses: actions/upload-artifact@v4
        with:
          name: thyrox-status
          path: thyrox-status.json
```

### Script de validación pre-merge

```bash
#!/usr/bin/env bash
# scripts/validate-thyrox-state.sh
# Verifica que el estado THYROX es consistente antes de merge

claude -p --max-turns 2 \
  "Read .thyrox/context/now.md and check:
   1. Does the active branch match the WP's expected branch?
   2. Are there uncommitted changes in .thyrox/context/?
   3. Is now.md::updated_at from today?
   Report issues as JSON: {\"issues\": [...]}" \
  --output-format json
```

---

## 5. Loop externo con `claude -p` — sin ScheduleWakeup

Para entornos donde `ScheduleWakeup`/`CronCreate` no están disponibles (no Desktop App),
la estrategia correcta es un script shell externo que invoca `claude -p` en loop:

```bash
# bin/thyrox-loop.sh — ejecutar desde terminal, no desde Claude Code
bash bin/thyrox-loop.sh
```

El script lee el output de cada iteración y para cuando detecta un gate o completitud.
Fuente confirmada: `claude-howto/10-cli/README.md:34`, `09-advanced-features/README.md:782`

### Eliminación de prompts de herramientas (dentro del loop)

Para que cada iteración de `claude -p` no pida confirmaciones de herramientas,
el `settings.json` del proyecto ya tiene `permissions.allow` con `Edit(*)`, `Write(*)`, `Bash(git *)`.
Con `defaultMode: acceptEdits` + allow list, Phase 10 corre sin interrupciones de permisos.

Fuente: `setup-auto-mode-permissions.py:27-66`, `settings-reference.md:318-354`

**Nota sobre `ScheduleWakeup`:** No documentado en ninguna referencia (`claude-howto` ni `claude-code-ultimate-guide`). Probable feature interna no publicada. No usar como dependencia.

---

## 6. Patrones combinados

### Pattern: "Loop externo hasta gate" (sin Desktop App)

```bash
# Terminal externo — no requiere sesión Claude Code activa
bash bin/thyrox-loop.sh

# O con API key explícita:
ANTHROPIC_API_KEY=... bash bin/thyrox-loop.sh
```

### Pattern: "Auto-advance hasta el gate"

Cuando se inicia Phase 10 y se quiere avanzar automáticamente hasta encontrar un gate humano:

```bash
# Iniciar loop — se detendrá solo ante gates
/loop 10m /thyrox:loop

# Mientras el loop corre, Claude puede responder otras preguntas
# El loop reporta cada ejecución en la conversación
```

### Pattern: "Loop batch + revisión manual"

Para WPs con mezcla de tareas automáticas y gates:

```bash
# 1. Identificar el próximo gate
grep -n "GATE\|gate" .thyrox/context/work/*/plan-execution/*-task-plan.md

# 2. Ejecutar el batch automático hasta ese punto
/loop 10m /thyrox:loop    # Se detiene solo en [GATE]

# 3. Revisar y aprobar el gate manualmente
# 4. Reiniciar el loop para el siguiente batch
/loop 10m /thyrox:loop
```

### Pattern: "Documentación nocturna"

```bash
# En settings.json del Desktop App (Desktop App required):
{
  "scheduledTasks": [
    {
      "name": "thyrox-nightly",
      "schedule": "daily",
      "path": "~/.claude/scheduled-tasks/thyrox-nightly/SKILL.md"
    }
  ]
}
```

---

## Consideraciones

### Tareas que requieren gate humano

Marcar explícitamente en el task-plan con `[GATE]`:

```markdown
- [ ] [T-042] Revisar diseño de API con el equipo [GATE] (SPEC-5)
- [ ] [T-043] Deploy a producción [GATE] [irreversible] (SPEC-6)
```

El comando `/thyrox:loop` detecta `[GATE]` y se detiene automáticamente.

### Tareas irreversibles

Tareas con `irreversibility: irreversible` en su descripción nunca se ejecutan automáticamente — siempre requieren aprobación manual.

### Contexto del subagente en loop

Las tareas del loop corren en un subagente aislado. El Edit tool funciona en ese contexto sin bloquear la conversación principal. Ver [subagent-patterns](../../../references/subagent-patterns.md) para detalles.

---

## Referencias

- [scheduled-tasks](../../../references/scheduled-tasks.md) — `/loop`, CronCreate, Desktop App, Cloud Routines, `claude -p`
- [advanced-features](../../../references/advanced-features.md) — Auto Mode, Planning Mode
- [commit-convention](commit-convention.md) — Formato de commits para tareas del loop
- [workflow-execute/SKILL.md](../SKILL.md) — Reglas de Phase 10 EXECUTE

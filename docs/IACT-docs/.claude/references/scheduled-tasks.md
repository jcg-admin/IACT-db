```yml
type: Reference
title: Scheduled Tasks y Automatización
category: Claude Code Platform — Automatización
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: /loop, CronCreate, tareas programadas persistentes, print mode (-p) y CI/CD integration
```

# Scheduled Tasks y Automatización

Referencia para tareas programadas, automatización sin intervención y ejecución headless de Claude Code.

## Tareas programadas en sesión (`/loop` + CronCreate)

Las tareas programadas son **session-scoped**: corren mientras Claude Code está activo y se limpian al terminar la sesión. Disponibles desde v2.1.72+.

### Crear tareas con `/loop`

```bash
# Intervalo explícito
/loop 5m check if the deployment finished

# Lenguaje natural
/loop check build status every 30 minutes

# Cron expression estándar (5 campos)
/loop 0 */2 * * * run the integration test suite
```

### Recordatorios únicos

```
remind me at 3pm to push the release branch
in 45 minutes, run the integration tests
```

### Tools de gestión de cron

| Tool | Descripción |
|------|-------------|
| `CronCreate` | Crear tarea programada |
| `CronList` | Listar tareas activas |
| `CronDelete` | Eliminar tarea |

### Límites y comportamiento

| Aspecto | Detalle |
|---------|---------|
| **Máximo** | 50 tareas por sesión |
| **TTL recurrente** | 3 días, luego auto-expiran |
| **Jitter recurrente** | Hasta 10% del intervalo (máximo 15 minutos) |
| **Jitter único** | Hasta 90 segundos en límites :00/:30 |
| **Missed fires** | Sin catch-up — si Claude Code no corría, se omite |
| **Persistencia** | No persisten entre reinicios |

### Deshabilitar tareas programadas

```bash
export CLAUDE_CODE_DISABLE_CRON=1
```

> **Tip:** Las tareas programadas son session-scoped. Para automatización que debe sobrevivir reinicios, usar CI/CD pipelines, GitHub Actions, o Desktop App scheduled tasks.

## Cloud Scheduled Tasks — `/schedule`

Las Cloud Scheduled Tasks persisten entre reinicios y corren en infraestructura de Anthropic:

```bash
/schedule daily at 9am run the test suite and report failures
```

**Diferencia clave:** No requiere que Claude Code esté corriendo localmente. Para automatización que debe sobrevivir reinicios o ejecutarse sin presencia del usuario.

## Desktop App — Tareas programadas

El Desktop App soporta tareas recurrentes (independientes de `/loop`) que corren mientras la aplicación está abierta:

| Frecuencia | Ejemplos |
|------------|---------|
| `hourly` | Chequeo de build status |
| `daily` | Reportes de errores, backups |
| `weekdays` | Revisión de PRs pendientes |
| `weekly` | Resumen de métricas |

A diferencia de `/loop`, estas tareas sobreviven entre sesiones del REPL mientras el Desktop App esté corriendo.

## Por qué Edit tool funciona en tareas programadas

**Pregunta:** Las tareas programadas usan Edit — ¿cómo no bloquean si Edit siempre produce output?

**Respuesta:** El contexto de aislamiento.

Las tareas programadas ejecutan en un **subagente** (Agent tool). El Edit tool corre dentro del contexto aislado del subagente, no en el contexto principal. El output del tool (`"The file has been updated successfully."`) queda en el contexto del subagente. El usuario solo ve el resumen que el subagente devuelve.

```
Sesión principal
    │
    └─ Tarea programada → [subagente] → Edit × N → resultados aislados
                                         │
                          resumen ←──────┘  (lo único que llega al contexto principal)
```

Ver [subagent-patterns](subagent-patterns.md) para el patrón completo.

## Background Tasks

Las background tasks permiten operaciones largas sin bloquear la conversación.

```bash
User: Run the full test suite in the background

Claude: Starting tests in background (task-id: bg-1234)
You can continue working while tests run.
```

### Gestión de background tasks

```bash
/task list           # Listar tareas activas
/task status bg-1234 # Estado y progreso
/task show bg-1234   # Output actual
/task cancel bg-1234 # Cancelar
```

### Deshabilitar background tasks

```bash
export CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1
```

### Parallelismo con background tasks

```
User: Run the build in background    → task bg-5001
User: Also run linter in background  → task bg-5002
User: Meanwhile, let's implement the new API endpoint
Claude: [trabaja en API mientras build y linter corren]

[10 min después]
Claude: Build completed (bg-5001) ✅
Claude: Linter found 12 issues (bg-5002) ⚠️
```

## Modo headless / Print Mode (`claude -p`)

Para scripts, CI/CD, y automatización sin interacción del usuario. El flag `-p` es el modo no-interactivo actual; `--headless` es el flag legacy que reemplaza.

```bash
# Query simple y salir
claude -p "what does this function do?"

# Procesar contenido piped desde archivo
cat error.log | claude -p "explain this error"

# Procesar contenido piped desde stdin (echo)
echo "function foo() { return null; }" | claude -p "explain this"

# Continuar última conversación en modo print
claude -c -p "check for type errors"

# Limitar turnos autónomos
claude -p --max-turns 3 "refactor this module"

# Deshabilitar persistencia de sesión (análisis one-off)
claude -p --no-session-persistence "one-off analysis"
```

### Formatos de output

```bash
# Texto plano (default)
claude -p "explain this code"

# JSON para procesamiento programático
claude -p --output-format json "list all functions in main.py"

# Streaming JSON para procesamiento en tiempo real
claude -p --output-format stream-json "generate a long report"

# JSON con schema validado
claude -p --json-schema '{"type":"object","properties":{"bugs":{"type":"array"}}}' \
  "find bugs and return as JSON"
```

### Integración con CI/CD

**GitHub Actions — workflow completo:**

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
            "Review this PR for:
            - Code quality issues
            - Security vulnerabilities
            - Performance concerns
            - Test coverage
            Output results as JSON" > review.json

      - name: Post Review Comment
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const review = JSON.parse(fs.readFileSync('review.json', 'utf8'));
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: JSON.stringify(review, null, 2)
            });
```

**Snippet rápido (snippet anterior):**

```yaml
- name: AI Code Review
  run: |
    claude -p --output-format json \
      --max-turns 1 \
      "Review PR for security vulnerabilities. Output as JSON with 'issues' array" \
      > review.json
```

**Script piping:**

```bash
# Analizar logs
tail -1000 /var/log/app/error.log | claude -p "summarize errors and suggest fixes"

# Batch processing
for file in src/*.ts; do
  claude -p --model haiku "summarize this file: $(cat $file)" >> summaries.md
done
```

## Gestión de sesiones para automatización

```bash
# Continuar la sesión más reciente
claude -c

# Resumir sesión por nombre
claude -r "feature-auth" "continue implementing login"

# Fork de sesión para experimentar
claude --resume feature-auth --fork-session "try OAuth instead"

# Session específica por ID
claude --session-id "550e8400-..." "continue"
```

### Comandos de sesión dentro del REPL

```
/rename auth-refactor        # Nombrar la sesión actual
/fork                        # Fork inline — rama sin afectar el original
```

### Session Fork

```bash
# Crear branch de una sesión sin afectar la original
claude --resume abc123 --fork-session "test alternative approach"
```

La sesión original queda intacta. El fork se convierte en una sesión independiente nueva.

## Permission modes para automatización

### Tabla completa de modos

| Modo | Comportamiento |
|------|----------------|
| `default` | Solo lectura; solicita aprobación para todo lo demás |
| `acceptEdits` | Lee y edita archivos; solicita aprobación para comandos |
| `plan` | Solo lectura (modo research, sin edits) |
| `auto` | Todas las acciones con classifier de seguridad en background (Research Preview) |
| `dontAsk` | Solo tools pre-aprobados ejecutan; el resto se deniega |
| `bypassPermissions` | Todas las acciones sin verificación (peligroso) |

Ciclar modos con `Shift+Tab` en el REPL. Establecer default con `--permission-mode` o `permissions.defaultMode`.

```bash
# Solo lectura — audit sin modificaciones
claude --permission-mode plan "audit this codebase for security"

# Aceptar edits automáticamente — flujo sin fricción
claude --permission-mode acceptEdits "implement this feature"

# Auto mode — classifier de seguridad en background
claude --enable-auto-mode --permission-mode auto "refactor auth module"

# Herramientas específicas sin confirmación
claude --allowedTools "Bash(git log:*)" "Bash(git status:*)" "Read(*)"

# Bloquear operaciones peligrosas
claude --disallowedTools "Bash(rm -rf:*)" "Bash(git push --force:*)"
```

## Auto Mode — Safety Classifier

Auto Mode (Research Preview, marzo 2026) usa un clasificador de seguridad en background para revisar cada acción.

### Requisitos

| Requisito | Detalle |
|-----------|---------|
| **Plan** | Team, Enterprise, o API (no disponible en Pro ni Max) |
| **Modelo** | Claude Sonnet 4.6 o Opus 4.6 |
| **Provider** | Anthropic API únicamente (no compatible con Bedrock, Vertex ni Foundry) |
| **Costo adicional** | El classifier corre sobre Sonnet 4.6 — agrega tokens extra por sesión |

### Activación

```bash
claude --enable-auto-mode
# Luego Shift+Tab para ciclar hasta "auto" mode

# O directamente:
claude --permission-mode auto
```

```json
{
  "permissions": {
    "defaultMode": "auto"
  }
}
```

### Orden de evaluación del classifier

1. **Allow/deny rules** — Las reglas de permiso explícitas se evalúan primero
2. **Read-only/edits** — Lecturas de archivo y edits se aprueban automáticamente
3. **Classifier** — El classifier revisa la acción
4. **Fallback** — Después de 3 bloqueos consecutivos o 20 totales, vuelve a preguntar al usuario

**Acciones bloqueadas por defecto:**
- `curl | bash` (pipe-to-shell installs)
- Envío de datos sensibles al exterior
- Deploys a producción
- `rm -rf` masivo
- Cambios de IAM
- `git push --force` a main

**Acciones permitidas por defecto:**
- Operaciones de archivos locales
- `npm install`, `pip install` desde manifests
- HTTP de solo lectura
- Push a la rama actual

### Comandos de inspección

```bash
# Ver las reglas por defecto del classifier como JSON
claude auto-mode defaults
```

### `autoMode.environment` — enterprise

Para deployments enterprise, la managed setting `autoMode.environment` permite definir infraestructura confiable (CI/CD environments, deployment targets):

```json
{
  "autoMode": {
    "environment": "ci"
  }
}
```

### Alternativa sin plan Team — seeding manual de permisos

Si no se tiene un plan Team/Enterprise o se prefiere evitar el classifier, se puede sembrar `~/.claude/settings.json` con una baseline conservadora usando el script `setup-auto-mode-permissions.py`:

```bash
# Preview sin escribir cambios
python3 setup-auto-mode-permissions.py --dry-run

# Aplicar baseline conservadora (read-only + inspección local)
python3 setup-auto-mode-permissions.py

# Agregar capacidades adicionales solo cuando se necesitan
python3 setup-auto-mode-permissions.py --include-edits --include-tests
python3 setup-auto-mode-permissions.py --include-git-write --include-packages
python3 setup-auto-mode-permissions.py --include-gh-read --include-gh-write
```

| Categoría | Ejemplos incluidos |
|-----------|-------------------|
| Core read-only | `Read(*)`, `Glob(*)`, `Grep(*)`, `Agent(*)`, `WebSearch(*)`, `WebFetch(*)` |
| Inspección local | `Bash(git status:*)`, `Bash(git log:*)`, `Bash(cat:*)`, `Bash(find:*)` |
| Edits opcionales | `Edit(*)`, `Write(*)`, `NotebookEdit(*)` |
| Test/build opcionales | `Bash(pytest:*)`, `Bash(cargo test:*)`, `Bash(make:*)` |
| Git write opcionales | `Bash(git add:*)`, `Bash(git commit:*)`, `Bash(git stash:*)` |
| Package managers opcionales | `Bash(npm install:*)`, `Bash(pip install:*)` |
| GitHub CLI opcionales | `Bash(gh pr view:*)`, `Bash(gh pr create:*)` |

Las operaciones peligrosas (`rm -rf`, `sudo`, force push, `DROP TABLE`, `terraform destroy`) están excluidas intencionalmente. El script es idempotente.

**Fallback:** Después de 3 bloqueos consecutivos o 20 totales, vuelve a preguntar al usuario.

## Configuración de tareas programadas

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

### Configuración headless para CI/CD

Para pipelines CI/CD que usan `claude -p`, las siguientes claves controlan el comportamiento de la sesión no-interactiva:

```json
{
  "headless": {
    "exitOnError": true,
    "verbose": true,
    "timeout": 3600
  },
  "logging": {
    "level": "debug",
    "file": "./ci-claude.log"
  }
}
```

| Clave | Tipo | Descripción |
|-------|------|-------------|
| `headless.exitOnError` | `boolean` | Terminar con exit code no-cero si Claude encuentra un error |
| `headless.verbose` | `boolean` | Emitir output detallado del proceso |
| `headless.timeout` | `number` | Timeout de la sesión en segundos (default: sin límite) |
| `logging.level` | `string` | Nivel de log: `debug`, `info`, `warn`, `error` |
| `logging.file` | `string` | Path del archivo de log para la sesión |

## Variables de entorno relevantes

| Variable | Efecto |
|----------|--------|
| `CLAUDE_CODE_DISABLE_CRON` | Deshabilita tareas programadas |
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` | Deshabilita background tasks |
| `CLAUDE_CODE_EFFORT_LEVEL` | Nivel de razonamiento (`low`/`medium`/`high`/`max`) |
| `MAX_THINKING_TOKENS` | Budget de tokens para extended thinking |
| `CLAUDE_CODE_ENABLE_TASKS` | Habilita task list persistente |
| `CLAUDE_CODE_TASK_LIST_ID` | Nombre del directorio de tareas compartido entre sesiones |
| `CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION` | `false` para deshabilitar sugerencias de prompts |

## Ejemplo completo — monitoring de deployment

```bash
# Monitorear deploy cada 5 min, auto-detener al completar
/loop 5m check the deployment status of staging.
        If deploy succeeded, notify me and stop looping.
        If it failed, show the error logs.
```

## Referencias

- [advanced-features](advanced-features.md) — Planning Mode, Extended Thinking, Auto Mode, Worktrees, Sandboxing, Agent Teams, Remote/Web, Channels, Voice, Task List
- [cli-reference](cli-reference.md) — Referencia completa del CLI: flags, subcomandos y env vars
- [subagent-patterns](subagent-patterns.md) — Aislamiento de contexto (por qué Edit funciona en scheduled tasks)
- [permission-model](permission-model.md) — Modelo de permisos en dos planos

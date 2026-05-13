```yml
type: Reference
title: Claude Code — Referencia oficial de componentes (Skills, Agents, Context)
owner: thyrox
source: Documentación oficial Claude Code (code.claude.com/docs)
version: 1.0
created_at: 2026-04-09 00:30:00
updated_at: 2026-04-09 00:30:00
purpose: Referencia consolidada para crear Skills, Subagents y gestionar Context en Claude Code. Usar antes de crear cualquier componente nuevo.
```

# Claude Code — Referencia de Componentes

Referencia técnica extraída de la documentación oficial (code.claude.com/docs/skills, /sub-agents, y contexto relacionado). Cubre los tres tipos de componentes extensibles: **Skills**, **Subagents**, y gestión de **Context**.

---

## 1. SKILLS

### Qué es un skill

Un skill es un directorio con `SKILL.md` como entrypoint. El `name` del directorio (o el campo `name` del frontmatter) determina el comando `/name`. Claude lo carga cuando es relevante, o el usuario lo invoca directamente con `/name`.

```
.claude/skills/mi-skill/
├── SKILL.md          ← REQUERIDO — instrucciones principales
├── reference.md      ← opcional — docs detalladas
├── examples/         ← opcional — ejemplos de output
└── scripts/          ← opcional — scripts ejecutables
```

**Nota:** `.claude/commands/deploy.md` y `.claude/skills/deploy/SKILL.md` crean el mismo `/deploy`. Skills son el formato recomendado (soportan archivos adicionales, frontmatter avanzado).

### Frontmatter de Skills

```yaml
---
name: mi-skill              # Opcional. Si se omite: usa nombre del directorio.
                            # Validación: solo a-z, 0-9, - (hyphens). Máx 64 chars.
                            # ⚠ underscores NO son válidos en el campo name.
description: ...            # Recomendado. Claude lo usa para auto-seleccionar.
                            # ≤250 chars (truncado en el listado si excede).
argument-hint: [arg]        # Opcional. Hint en autocomplete. Ej: "[issue-number]"
disable-model-invocation: true  # Opcional. Previene invocación automática por Claude.
                                # DOBLE efecto: (1) bloquea auto-selección,
                                # (2) excluye description del context → ahorra tokens.
user-invocable: false       # Opcional. Oculta del menú /. Claude puede invocar; usuario no.
allowed-tools: Read Grep    # Opcional. Herramientas pre-aprobadas mientras el skill está activo.
model: sonnet               # Opcional. Modelo para este skill.
effort: high                # Opcional. Nivel de esfuerzo: low|medium|high|max (Opus 4.6 only).
context: fork               # Opcional. Ejecuta en subagente aislado.
agent: Explore              # Opcional. Qué subagente usar con context: fork.
hooks:                      # Opcional. Hooks del lifecycle de este skill.
  - event: UserPromptSubmit
    once: true
    type: command
    command: "..."
paths: "src/**/*.ts"        # Opcional. Solo activa si el usuario trabaja con estos archivos.
shell: bash                 # Opcional. bash (default) o powershell.
---
```

### Control de invocación

| Frontmatter | Usuario invoca | Claude invoca | En context |
|-------------|---------------|---------------|------------|
| (default) | Sí | Sí | Description siempre en context |
| `disable-model-invocation: true` | Sí | No | Description NO en context |
| `user-invocable: false` | No | Sí | Description siempre en context |

**Regla de context budget:** `disable-model-invocation: true` es tanto control de invocación como optimización de context. Úsalo en skills pesados (>50 líneas) que el usuario invoca manualmente.

### Sustituciones disponibles en SKILL.md

| Variable | Descripción |
|----------|-------------|
| `$ARGUMENTS` | Todos los argumentos al invocar el skill |
| `$ARGUMENTS[N]` o `$N` | Argumento por índice (0-based) |
| `${CLAUDE_SESSION_ID}` | ID de sesión actual |
| `${CLAUDE_SKILL_DIR}` | Directorio del SKILL.md — para referenciar scripts relativos |

### Inyección dinámica de context

Ejecuta comandos shell antes de que Claude vea el contenido:
```markdown
Estado actual: !`git status --short`
```

O bloque multi-línea:
````markdown
```!
node --version
git log --oneline -5
```
````

### Archivos de soporte

El `SKILL.md` debe referenciar los archivos adicionales para que Claude sepa cuándo cargarlos:
```markdown
## Recursos adicionales
- Detalles completos: [reference.md](reference.md)
- Ejemplos: [examples.md](examples.md)
```

**Tip:** Mantener `SKILL.md` < 500 líneas. Mover documentación detallada a archivos separados.

### Dónde viven los skills

| Ubicación | Path | Aplica a |
|-----------|------|----------|
| Enterprise | Managed settings | Todos los usuarios de la org |
| Personal | `~/.claude/skills/<name>/SKILL.md` | Todos tus proyectos |
| Project | `.claude/skills/<name>/SKILL.md` | Este proyecto |
| Plugin | `<plugin>/skills/<name>/SKILL.md` | Donde el plugin está habilitado |

Prioridad: enterprise > personal > project. Mismo nombre → gana mayor prioridad.

---

## 2. SUBAGENTS

### Qué es un subagent

Asistente de IA especializado con su propio context window, system prompt, herramientas restringidas y permisos independientes. Claude delega a él cuando la tarea coincide con su `description`. Los subagents **no pueden spawnar otros subagents**.

Diferencia clave con skills:
- **Skill**: corre inline en el context de la conversación principal
- **Subagent**: context completamente separado; retorna un resumen al terminar

### Frontmatter de Subagents

```yaml
---
name: mi-agente            # REQUERIDO. Kebab-case (a-z, 0-9, hyphens).
description: ...           # REQUERIDO. Cuándo delegar a este subagente.
tools: Read, Grep, Bash    # Opcional. Allowlist de herramientas. Hereda todo si omitido.
disallowedTools: Write     # Opcional. Denylist. Aplicado antes que tools.
model: sonnet              # Opcional. sonnet|opus|haiku|full-model-id|inherit. Default: inherit.
permissionMode: default    # Opcional. default|acceptEdits|auto|dontAsk|bypassPermissions|plan.
maxTurns: 10               # Opcional. Máx turnos agentic antes de parar.
skills:                    # Opcional. Skills a inyectar en el context del subagente al inicio.
  - workflow-analyze       #   Contenido COMPLETO inyectado (no solo disponible).
  - api-conventions        #   Subagentes NO heredan skills del parent.
mcpServers:                # Opcional. Servers MCP disponibles para este subagente.
  - playwright:            #   Inline definition (conecta al start, desconecta al stop).
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
  - github                 #   String reference: reutiliza conexión existente del parent.
hooks:                     # Opcional. Hooks del lifecycle de este subagente.
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-command.sh"
memory: project            # Opcional. user|project|local. Memoria persistente cross-session.
background: true           # Opcional. Siempre corre como background task. Default: false.
effort: high               # Opcional. Nivel de esfuerzo.
isolation: worktree        # Opcional. Corre en git worktree temporal aislado.
color: blue                # Opcional. red|blue|green|yellow|purple|orange|pink|cyan.
initialPrompt: "..."       # Opcional. Primer turno auto-submitido cuando corre como session principal.
---
```

### Control de herramientas

```yaml
# Allowlist: SOLO estas herramientas
tools: Read, Grep, Glob, Bash

# Denylist: TODAS menos estas
disallowedTools: Write, Edit

# Si ambos están: disallowedTools se aplica primero, luego tools sobre lo que queda.
```

### Permission modes

| Mode | Comportamiento |
|------|----------------|
| `default` | Standard — prompts normales |
| `acceptEdits` | Auto-acepta edición de archivos |
| `auto` | Clasificador background revisa comandos |
| `dontAsk` | Auto-deniega prompts (tools explícitamente permitidas siguen funcionando) |
| `bypassPermissions` | Salta todos los prompts ⚠ |
| `plan` | Solo lectura |

### Skills preloaded en subagents

```yaml
---
name: api-developer
skills:
  - api-conventions
  - workflow-execute
---
```

El contenido COMPLETO de cada skill se inyecta en el context del subagente al inicio. El subagente lo tiene disponible sin necesidad de invocarlo. Inverso de `context: fork` en skills.

### Memoria persistente

```yaml
memory: project  # .claude/agent-memory/<name>/ — compartible vía git
memory: user     # ~/.claude/agent-memory/<name>/ — cross-project
memory: local    # .claude/agent-memory-local/<name>/ — no va a git
```

El subagente recibe: instrucciones de read/write a su directorio + primeras 200 líneas / 25KB de `MEMORY.md`. Herramientas Read, Write, Edit se habilitan automáticamente.

### Dónde viven los subagents

| Ubicación | Path | Prioridad |
|-----------|------|-----------|
| Managed | Managed settings `.claude/agents/` | 1 (más alta) |
| CLI flag | `--agents '{...}'` | 2 |
| Project | `.claude/agents/` | 3 |
| Personal | `~/.claude/agents/` | 4 |
| Plugin | `<plugin>/agents/` | 5 (más baja) |

### Hooks de lifecycle de subagents en settings.json

```json
{
  "hooks": {
    "SubagentStart": [
      {
        "matcher": "db-agent",
        "hooks": [{ "type": "command", "command": "./scripts/setup-db.sh" }]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [{ "type": "command", "command": "./scripts/cleanup.sh" }]
      }
    ]
  }
}
```

`Stop` en frontmatter de subagente se convierte automáticamente a `SubagentStop` en runtime.

### Invocación de subagents

```text
# Natural language (Claude decide si delegar)
Use el code-reviewer para revisar los cambios recientes

# @-mention (garantiza este subagente para una tarea)
@"code-reviewer (agent)" revisa el módulo auth

# Sesión completa como subagente
claude --agent code-reviewer
```

---

## 3. CONTEXT MANAGEMENT

### Qué carga y cuándo

| Componente | Cuándo carga |
|------------|-------------|
| CLAUDE.md | Siempre — al inicio de sesión |
| Skill description (model-invocable) | Siempre en context al inicio |
| Skill description (disable-model-invocation) | **Nunca** — solo al invocar |
| Skill contenido completo | Solo al invocar (inline o subagente) |
| Subagent | Context separado, independiente del principal |

### Reglas de context budget

- `disable-model-invocation: true` = 0 costo de context hasta invocar. Usar en skills pesados.
- Subagents: el output verboso queda en su propio context → solo el resumen vuelve.
- Skills con `context: fork` ejecutan en subagente → aíslan su output del context principal.
- MCP tools: deferred por defecto. Solo el nombre consume context hasta que se usa la tool.

### Auto-compaction

- Se activa ~95% de capacidad. Preserva invocaciones de skills (última invocación de cada skill).
- Si un skill invocado es muy grande, se trunca post-compaction.
- `session-resume.sh` (PostCompact hook) puede re-inyectar contexto crítico si fue perdido.
- CLAUDE.md es el lugar para reglas persistentes — no depender del historial de conversación.

### Patrones de optimización

```
Problema                    → Solución
─────────────────────────────────────────────────────
Skill pesado en context     → disable-model-invocation: true
Output verboso (tests, logs)→ Delegarlo a subagente
Exploración read-only       → Explore subagent (Haiku, herramientas RO)
Tareas paralelas            → Múltiples subagentes simultáneos
Reglas que deben persistir  → CLAUDE.md (no conversación)
```

---

## 4. THYROX — Convenciones específicas

### Naming

```
Skills de fase:    workflow-analyze/SKILL.md  (kebab-case, name: workflow-analyze)
Tech skills:       backend-nodejs/SKILL.md    (kebab-case)
Framework skill:   thyrox/SKILL.md         (kebab-case)
Agentes:           task-executor.md           (kebab-case, en .claude/agents/)
```

### Frontmatter mínimo para workflow-* skills

```yaml
---
name: workflow-analyze       # kebab-case, hyphens only
description: Phase 1 ANALYZE — inicia o retoma el análisis del WP activo.
disable-model-invocation: true  # control + context budget
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "echo 'phase: Phase 1' >> context/now.md"
updated_at: YYYY-MM-DD HH:MM:SS
---
```

### Frontmatter mínimo para agentes en .claude/agents/

```yaml
---
name: task-executor          # REQUERIDO, kebab-case
description: ...             # REQUERIDO — patrón: "{qué hace}. Usar cuando {condición}."
tools:                       # Opcional — hereda todo si omitido
  - Read
  - Write
  - Bash
model: inherit               # Opcional — default: inherit
---
```

### Conflictos con agent-spec.md anterior (THYROX)

`agent-spec.md` (2026-04-07) tenía reglas que **difieren de docs oficiales**:

| Campo | agent-spec.md | Docs oficiales | Correcto |
|-------|--------------|----------------|---------|
| `model` | PROHIBIDO | Válido — `sonnet\|opus\|haiku\|inherit` | Docs oficiales |
| `tools` | REQUERIDO | Opcional (hereda si omitido) | Docs oficiales |
| `system_prompt` | PROHIBIDO (en frontmatter) | No existe como campo de frontmatter — body es el system prompt | Coinciden |

`agent-spec.md` requiere actualización (ver TD-024).

### Arquitectura de 5 capas (ADR-015)

```
Capa 0: Hooks (settings.json) — determinístico, 100% reliable
Capa 1: CLAUDE.md — siempre cargado, reglas base
Capa 2: Skills (.claude/skills/) — probabilístico o user-invocable
Capa 3: workflow-* (Capa 2 hidden) — disable-model-invocation: true
Capa 4: Agents (.claude/agents/) — context propio, subagentes especializados
```

---

## 5. PATRONES DE DISEÑO

### Cuándo usar Skill vs Subagent vs Hook

| Necesidad | Solución |
|-----------|----------|
| Instrucciones que Claude aplica al código | Skill (model-invocable) |
| Workflow que el usuario activa manualmente | Skill (disable-model-invocation: true) |
| Tarea con output verboso → preservar context | Subagent |
| Tarea especializada con herramientas restringidas | Subagent con tools allowlist |
| Comportamiento determinístico en eventos | Hook en settings.json |
| Reglas persistentes cross-sesión | CLAUDE.md |
| Conocimiento de dominio del proyecto | Skill o Subagent con memory |

### Skill con context: fork

```yaml
---
name: deep-research
context: fork
agent: Explore
---
Research $ARGUMENTS: 1. Find relevant files. 2. Analyze. 3. Summarize.
```

El skill content se convierte en el prompt del subagente Explore. El resultado vuelve al context principal.

### Subagent con skills preloaded

```yaml
---
name: phase-executor
skills:
  - workflow-execute
description: Ejecuta Phase 6 del WP activo con acceso completo al protocol workflow.
---
```

El subagente recibe el contenido completo de `workflow-execute/SKILL.md` inyectado en su context al inicio.

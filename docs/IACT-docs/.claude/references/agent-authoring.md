```yml
type: Reference
title: Agent Authoring — Guía para Crear Agentes Nativos Claude Code
category: Authoring — Agentes
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Crear agentes nativos Claude Code con GAP-007..012 — skills:, memory:, background:, isolation:, permissionMode
```

# Agent Authoring — Guía para Crear Agentes Nativos Claude Code

Guía completa para crear agentes (subagentes) nativos de Claude Code. Cubre todos los campos del frontmatter incluyendo los avanzados: `skills:`, `memory:`, `background:`, `isolation:` y `permissionMode`.

Para convenciones de THYROX específicas, ver [agent-spec.md](agent-spec.md).
Para decidir entre Agent vs SKILL vs Hook vs CLAUDE.md, ver [component-decision.md](component-decision.md).

---

## 1. Cuándo crear un agente

Crear un agente nativo cuando:

| Señal | Por qué un agente |
|-------|------------------|
| La tarea necesita herramientas propias diferentes al contexto principal | Los agentes declaran su propio `tools` — el SKILL usa las del padre |
| La tarea produce output verboso (logs, tests, análisis extenso) | El contexto del agente está aislado — el resultado solo vuelve como resumen |
| Se quiere ejecución en paralelo con otras tareas | Los agentes se lanzan con el `Agent` tool simultáneamente |
| Se necesita especialización de rol persistente y reutilizable | El body del agente es su system prompt completo |
| El output de la tarea contaminaría el contexto principal | Subproceso con contexto separado — zero pollution |

**NO crear un agente cuando:**

- Lo que quieres es metodología de trabajo → SKILL
- Quieres instrucciones que se aplican en toda sesión → CLAUDE.md
- Quieres comportamiento determinístico ante un evento del sistema → Hook
- La tarea es un paso simple de un solo tool → no vale el overhead

---

## 2. Frontmatter completo de agentes

```yaml
---
# ═══ CAMPOS REQUERIDOS ═══════════════════════════════════════════════════════
name: mi-agente              # REQUERIDO. Kebab-case (a-z, 0-9, hyphens).
                             # Debe coincidir exactamente con el nombre del archivo sin extensión.
description: |               # REQUERIDO. Cuándo Claude debe delegar a este agente.
  Analiza el código de autenticación y detecta vulnerabilidades. Usar cuando
  se revisan cambios en auth/, middleware/, o se solicita un security audit.

# ═══ HERRAMIENTAS ════════════════════════════════════════════════════════════
tools: Read, Grep, Glob      # Opcional. Allowlist — SOLO estas herramientas.
                             # Si se omite: hereda TODAS las tools del parent.
disallowedTools: Write, Edit # Opcional. Denylist — TODAS excepto estas.
                             # disallowedTools se aplica ANTES que tools.

# ═══ MODELO Y ESFUERZO ═══════════════════════════════════════════════════════
model: inherit               # Opcional. sonnet | opus | haiku | <model-id> | inherit.
                             # Default: inherit (hereda del parent).
effort: high                 # Opcional. low | medium | high | max (Opus 4.6 only).
maxTurns: 10                 # Opcional. Máximo de turnos agentic antes de parar.

# ═══ SKILLS PRELOADED (GAP-008) ══════════════════════════════════════════════
skills:                      # Opcional. Lista de skills a inyectar en el contexto
  - api-conventions          # del agente al inicio. Contenido COMPLETO — no solo metadata.
  - workflow-execute         # Los subagentes NO heredan skills del parent automáticamente.

# ═══ MEMORIA PERSISTENTE (GAP-009) ═══════════════════════════════════════════
memory: project              # Opcional. user | project | local.
                             # Ver §4 para explicación de cada scope.

# ═══ EJECUCIÓN EN BACKGROUND (GAP-010) ═══════════════════════════════════════
background: true             # Opcional. Si true: siempre corre como background task.
                             # Default: false. Ver §5.

# ═══ AISLAMIENTO CON WORKTREE (GAP-011) ══════════════════════════════════════
isolation: worktree          # Opcional. Corre en git worktree temporal aislado.
                             # Ver §6.

# ═══ PERMISSION MODE (GAP-012) ═══════════════════════════════════════════════
permissionMode: default      # Opcional. Ver §7 para los 6 modos disponibles.

# ═══ CAMPOS ADICIONALES ═══════════════════════════════════════════════════════
mcpServers:                  # Opcional. MCP servers disponibles para este agente.
  - playwright:              #   Inline definition (conecta al start, desconecta al stop).
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
  - github                   #   String reference: reutiliza conexión del parent.
hooks:                       # Opcional. Hooks del lifecycle de este agente.
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-command.sh"
color: blue                  # Opcional. red|blue|green|yellow|purple|orange|pink|cyan.
initialPrompt: "..."         # Opcional. Primer turno auto-submitido cuando corre como sesión principal.
---
```

---

## 3. Tabla: campos obligatorios vs opcionales

| Campo | Estado | Notas |
|-------|--------|-------|
| `name` | REQUERIDO | Kebab-case. Debe coincidir con nombre del archivo. |
| `description` | REQUERIDO | Patrón recomendado: `{qué hace}. Usar cuando {condición}.` Mínimo 20 chars. |
| `tools` | Opcional | Si se omite: hereda todo. Prefer omitir si el agente necesita acceso completo. |
| `disallowedTools` | Opcional | Alternativa a `tools`: denylist en lugar de allowlist. |
| `model` | Opcional | Default: inherit. Solo especificar si hay razón concreta (ej: Haiku para exploración rápida). |
| `effort` | Opcional | Solo relevante con Opus 4.6. En otros modelos se ignora. |
| `maxTurns` | Opcional | Limita consumo de tokens. Útil para agentes de análisis acotado. |
| `skills` | Opcional | Ver §4. Contenido completo inyectado — cuidado con el context budget. |
| `memory` | Opcional | Ver §4. Solo si el agente necesita persistencia cross-session. |
| `background` | Opcional | Solo si la tarea es larga y no bloquear al usuario es importante. |
| `isolation` | Opcional | Solo si el agente hace cambios que deben estar aislados del working tree. |
| `permissionMode` | Opcional | Default es suficiente para la mayoría de casos. |
| `mcpServers` | Opcional | Para agentes que necesitan acceso a datos externos. |
| `hooks` | Opcional | Lifecycle hooks scoped al agente. |
| `color` | Opcional | Identificación visual en la UI. |
| `initialPrompt` | Opcional | Solo útil cuando el agente corre como sesión principal via `--agent`. |

**Campos PROHIBIDOS en agentes nativos** (de agent-spec.md):

| Campo | Por qué prohibido |
|-------|------------------|
| `category` | Metadata del registry, sin semántica en agentes nativos |
| `skill_template` | Metadata del generador |
| `system_prompt` | El system prompt va en el body markdown, no en frontmatter |

---

## 4. `skills:` — inyección de skills en contexto del agente (GAP-008)

Los subagentes **no heredan skills del parent** automáticamente. Si un agente necesita acceso al contenido de un skill, debe declararlo en `skills:`.

```yaml
---
name: phase-executor
description: Ejecuta Phase 6 del WP activo. Usar cuando hay un task-plan aprobado y se necesita implementación completa.
skills:
  - workflow-execute      # Contenido completo de workflow-execute/SKILL.md inyectado al inicio
  - api-conventions       # Contenido completo de api-conventions/SKILL.md inyectado al inicio
---
```

**Diferencia crítica con `context: fork` en skills:**
- `skills:` en agente → el agente YA TIENE el contenido del skill desde el inicio (sin invocación)
- `context: fork` en skill → el skill SE CONVIERTE en el prompt del subagente al invocarse

**Cuándo usar:**
- El agente necesita seguir un protocolo definido en un skill (ej: workflow-execute)
- El agente necesita convenciones del proyecto (ej: api-conventions, commit-style)
- Usar con moderación — cada skill inyectado consume contexto del agente

---

## 5. `memory:` — memoria persistente cross-session (GAP-009)

El campo `memory` da al agente un directorio persistente que sobrevive entre sesiones.

```yaml
memory: project   # user | project | local
```

| Scope | Directorio | Cuándo usar |
|-------|-----------|-------------|
| `user` | `~/.claude/agent-memory/<name>/` | Conocimiento personal del agente cross-project. El usuario quiere que el agente recuerde preferencias entre todos sus proyectos. |
| `project` | `.claude/agent-memory/<name>/` | Conocimiento del agente sobre el proyecto específico. Compartible vía git. |
| `local` | `.claude/agent-memory-local/<name>/` | Conocimiento local del agente. No va a git (git-ignored). |

**Cómo funciona:**
- Las primeras **200 líneas** (o 25KB) de `MEMORY.md` se inyectan automáticamente en el system prompt del agente
- Archivos adicionales en el directorio se cargan on-demand
- Las tools `Read`, `Write`, `Edit` se habilitan automáticamente para el directorio de memoria
- El agente puede escribir/actualizar su propia memoria durante la ejecución

**Ejemplo:**

```yaml
---
name: researcher
memory: project
description: Investiga el codebase y documenta hallazgos. Usar cuando se necesita análisis de arquitectura o exploración profunda.
tools: Read, Grep, Glob, Bash
---

Eres un agente de investigación. Al inicio de cada sesión, revisa tu MEMORY.md
para recordar hallazgos previos. Actualiza tu memoria con nuevos insights.
```

---

## 6. `background: true` — ejecución en segundo plano (GAP-010)

```yaml
background: true
```

Cuando `background: true`, el agente corre como background task y no bloquea la conversación principal.

**Comportamiento:**
- La conversación principal continúa mientras el agente trabaja
- Los resultados se entregan como `systemMessage` en el siguiente turno
- `Ctrl+B` puede hacer background un agente que está corriendo (sin necesitar `background: true`)
- `Ctrl+F` mata todos los agentes en background

**Cuándo usar:**
- Análisis largos (tests, builds, exploración profunda) que no deben bloquear al usuario
- Tareas que el agente puede completar de forma independiente mientras el usuario sigue interactuando

**Restricción:** Los background subagents auto-deniegan cualquier permiso que no esté pre-aprobado. Si el agente necesita confirmaciones interactivas, NO usar `background: true`.

**Deshabilitar globalmente:**
```bash
export CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1
```

---

## 7. `isolation: worktree` — aislamiento con git worktrees (GAP-011)

```yaml
isolation: worktree
```

El agente recibe su propio git worktree temporal en un branch separado.

**Comportamiento:**
- El agente opera en un branch aislado — sus cambios NO afectan el working tree principal
- Si el agente no hace cambios: el worktree se limpia automáticamente
- Si el agente hace cambios: retorna el path del worktree y el nombre del branch al parent para revisión o merge

**Cuándo usar:**
- Implementación exploratoria que puede descartarse si no funciona
- Agentes que hacen cambios masivos que requieren revisión antes de aplicar al branch actual
- Workflows donde múltiples agentes trabajan en features paralelas sin conflictos

**Ejemplo:**

```yaml
---
name: feature-builder
isolation: worktree
description: Implementa features en worktree aislado. Usar cuando se quiere una implementación experimental que puede revisarse antes de merge.
tools: Read, Write, Edit, Bash, Grep, Glob
---
```

---

## 8. Permission modes (GAP-012)

El campo `permissionMode` controla cómo el agente maneja los prompts de permisos.

| Mode | Comportamiento | Cuándo usar |
|------|----------------|-------------|
| `default` | Comportamiento estándar — prompts normales al usuario | La mayoría de agentes |
| `acceptEdits` | Auto-acepta edición de archivos sin preguntar | Agentes de refactoring donde editar es su función |
| `auto` | Clasificador en background decide si aprobar comandos | Agentes semi-autónomos que necesitan balance seguridad/velocidad |
| `dontAsk` | Auto-deniega prompts (las tools explícitamente permitidas siguen funcionando) | Agentes read-only o de análisis que nunca deben modificar |
| `bypassPermissions` | Salta TODOS los prompts de permisos | Solo para agentes de confianza total en entornos controlados |
| `plan` | Solo lectura — no puede ejecutar acciones destructivas | Agentes de planificación, análisis de impacto |

**Nota de seguridad:** `bypassPermissions` es potencialmente peligroso. Úsarlo solo cuando el agente está completamente auditado y el entorno es seguro.

---

## 9. `tools:` — restricción de herramientas

**Tres opciones de configuración:**

```yaml
# Opción 1: Hereda TODAS las tools del parent (omitir el campo)
# Mejor para agentes que necesitan acceso completo

# Opción 2: Allowlist — SOLO estas herramientas
tools: Read, Grep, Glob, Bash

# Opción 3: Denylist — TODAS excepto estas
disallowedTools: Write, Edit

# Si ambas están presentes: disallowedTools se aplica PRIMERO, luego tools sobre lo que queda
```

**Restricción de subagentes spawneables:** Usando la sintaxis `Agent(nombre)`:

```yaml
tools: Agent(worker, researcher), Read, Bash
# Este agente SOLO puede spawnar 'worker' y 'researcher' — no otros agentes
```

**Conditional tool access:**

```yaml
tools: Read, Bash(npm:*), Bash(test:*)
# Puede ejecutar SOLO comandos npm:* y test:* via Bash
```

**Estrategia recomendada:**
1. Empezar restrictivo: solo las tools mínimas necesarias
2. Expandir solo cuando hay necesidad concreta
3. Agentes de análisis/revisión: prefer `Read, Grep, Glob` sin Write/Edit
4. Agentes de implementación: puede necesitar el set completo

---

## 10. Naming conventions y ubicación

**Formato de nombre:** kebab-case, solo `a-z`, `0-9`, `-` (hyphens). Máximo 64 caracteres.

**El nombre del campo `name` debe coincidir exactamente con el nombre del archivo sin extensión.**

```
# Correcto
.claude/agents/secure-reviewer.md  ->  name: secure-reviewer
.claude/agents/nodejs-expert.md    ->  name: nodejs-expert

# Incorrecto
.claude/agents/secure_reviewer.md  ->  underscores no válidos
.claude/agents/node.js-expert.md   ->  puntos no válidos
```

**Patrones de naming THYROX:**

| Patrón | Formato | Ejemplos |
|--------|---------|---------|
| Tech-expert | `{tech}-expert` | `nodejs-expert`, `react-expert`, `python-expert` |
| Workflow | `{tarea}-{rol}` | `task-executor`, `task-planner` |
| Utility | `{dominio}-{función}` | `tech-detector`, `skill-generator` |

**Ubicaciones posibles:**

| Ubicación | Prioridad | Alcance |
|-----------|-----------|---------|
| Managed settings `.claude/agents/` | 1 (más alta) | Organización |
| Via `--agents` CLI flag | 2 | Sesión actual |
| `.claude/agents/` (proyecto) | 3 | Proyecto actual |
| `~/.claude/agents/` (personal) | 4 | Todos los proyectos |
| Plugin `agents/` | 5 (más baja) | Donde el plugin está habilitado |

Cuando hay nombre duplicado, gana mayor prioridad.

---

## 11. Anti-patrones comunes

**No especificar `model:` sin razón concreta**

```yaml
# Incorrecto — fuerza un modelo innecesariamente
model: claude-sonnet-4-6

# Correcto para la mayoría de casos
# omitir el campo (hereda del parent)
```

**No duplicar CLAUDE.md en el body del agente**

El body del agente es su system prompt. No debe copiar instrucciones que ya están en CLAUDE.md — el agente opera en contexto propio pero recibe el CLAUDE.md del proyecto.

**No usar tools con sintaxis inválida**

```yaml
# Incorrecto — no existe sintaxis wildcard
tools: "*"

# Correcto para herencia completa — simplemente omitir el campo
```

**No crear agentes para tareas simples de un solo paso**

Un agente con body de 2 líneas para leer un archivo es overhead innecesario. Si la tarea cabe en el contexto principal sin contaminar, hacerla directamente.

**No olvidar que los subagentes no heredan skills del parent**

```yaml
# Si el agente necesita seguir el protocolo de workflow-execute:
---
name: mi-agente
skills:
  - workflow-execute  # Requerido explícitamente
---
```

---

## 12. Ejemplo canónico: coordinator de metodología (Patrón 3)

Coordinators que gestionan el flujo de una metodología completa. Usan `isolation: worktree`,
`background: true`, y precargan los skills de la metodología.

```yaml
---
name: pdca-coordinator
description: |
  Coordinator del ciclo PDCA (Plan-Do-Check-Act). Usar cuando el usuario quiere ejecutar
  una mejora continua con la metodología PDCA. Gestiona las 4 etapas del ciclo y actualiza
  now.md::methodology_step en cada transición.
tools: Read, Write, Edit, Glob, Grep, Bash
skills:
  - pdca-plan
  - pdca-do
  - pdca-check
  - pdca-act
background: true
isolation: worktree
color: blue
---

# pdca-coordinator

Gestiona el ciclo Plan-Do-Check-Act completo.

1. Leer .thyrox/context/now.md — verificar flow y methodology_step
2. Si methodology_step es null → iniciar en pdca:plan
3. En cada paso: activar el skill correspondiente, producir artefacto, actualizar now.md
4. Al completar pdca:act: preguntar si estandarizar o nuevo ciclo
```

**Patrón 5 — coordinator genérico:**

```yaml
---
name: thyrox-coordinator
description: |
  Coordinator genérico que lee .thyrox/registry/methodologies/{flow}.yml dinámicamente.
  Usar cuando la metodología está en el registry pero no tiene coordinator dedicado.
tools: Read, Write, Edit, Glob, Grep, Bash
background: true
isolation: worktree
---

# thyrox-coordinator

1. Leer now.md::flow → leer .thyrox/registry/methodologies/{flow}.yml
2. Resolver transiciones según type: cyclic|sequential|iterative|non-sequential|conditional
3. Actualizar now.md::methodology_step en cada transición
```

---

## 13. Forma canónica mínima (THYROX)

```yaml
---
name: task-executor
description: Ejecuta tareas atómicas de un task-plan.md. Usar cuando hay checkboxes T-NNN pendientes y se quiere implementar la siguiente tarea sin contexto de gestión.
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
---

Eres un agente de implementación especializado. Tu función es ejecutar UNA tarea
a la vez del task-plan.md activo.

## Protocolo

1. Leer el task-plan.md y encontrar la primera tarea `[ ]` pendiente
2. Implementar la tarea con los tools disponibles
3. Marcar la tarea como `[x]` cuando esté completa
4. Retornar un resumen de lo que se hizo
```

---

## Referencias

- [agent-spec.md](agent-spec.md) — Especificación formal de agentes en THYROX (naming, linter, convenciones)
- [claude-code-components.md](claude-code-components.md) — Referencia oficial completa (section Subagents)
- [skill-vs-agent.md](skill-vs-agent.md) — Tabla comparativa SKILL vs Agente, señales de confusión
- [component-decision.md](component-decision.md) — Flowchart de decisión entre todos los tipos
- [subagent-patterns.md](subagent-patterns.md) — Patrones de uso avanzados

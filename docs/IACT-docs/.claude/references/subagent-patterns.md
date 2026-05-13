```yml
type: Reference
title: Subagent Patterns — Aislamiento de Contexto y Delegación
category: Claude Code Platform — Arquitectura
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Patrones de aislamiento de contexto, worktree isolation, persistent memory, agent teams y background agents
```

# Subagent Patterns — Aislamiento de Contexto y Delegación

Patrones arquitectónicos para usar subagentes correctamente. Este archivo cubre el *cómo* usar subagentes para resultados concretos — no el *cuándo* elegir subagente vs skill (ver [skill-vs-agent](skill-vs-agent.md)).

## Principio fundamental: aislamiento de contexto

Cada subagente recibe un **context window fresco**, sin historial de la conversación principal. Solo recibe el contexto relevante para su tarea. Los resultados se **destilan** de vuelta al agente padre.

```
Main agent (contexto completo)
    │
    ├─ Agent(task-executor) ─── Edit × N → tool results aislados
    │                                        │
    │                        resumen ←───────┘
    │
    └─ [usuario ve solo el resumen]
```

**Consecuencia clave:** Si Claude llama `Edit × N` directamente en el contexto principal, el usuario ve N mensajes de `"The file has been updated successfully."`. Si los mismos Edits ocurren dentro de un subagente, el usuario solo ve el resumen que el subagente devuelve al padre.

## Patrón 1 — Context Pollution Prevention

**Problema:** Operaciones intensivas en tools (Edit, Bash) llenan el contexto con mensajes de éxito triviales.

**Solución:** Delegar a un subagente.

```
❌ Mal:  Claude → Edit × N  → N mensajes de éxito en pantalla
✅ Bien: Claude → Agent(task-executor) → Edit × N → 1 resumen al padre
```

El agente `task-executor` en THYROX ya implementa este patrón — ejecuta edits en su contexto aislado y reporta solo el resultado.

**Cuándo usar:** Implementaciones que modifican 3+ archivos, actualizaciones masivas de documentación, generación de código con múltiples writes.

## Patrón 2 — Worktree Isolation

El subagente trabaja en su propia rama git, sin afectar el working tree principal.

```yaml
---
name: feature-builder
isolation: worktree
description: Implementa features en un worktree git aislado
tools: Read, Write, Edit, Bash, Grep, Glob
---
```

**Comportamiento:**
- Si el subagente no hace cambios → worktree se limpia automáticamente
- Si hay cambios → devuelve el path del worktree y el nombre de la rama al padre

**Valores de retorno cuando hay cambios:**
```
worktree_path: /path/to/.git/worktrees/branch-name
branch_name:   subagent-feature-xyz-<timestamp>
```

El agente padre puede entonces revisar, testear o hacer merge del branch antes de integrarlo.

**Ciclo de vida:**

```
Main Working Tree
    │
    └─ Subagente con isolation: worktree
        │
        └─ Git Worktree (rama separada)
            │
            ├─ Sin cambios → limpieza automática
            └─ Con cambios → devuelve worktree_path + branch_name
                    │
                    └─ Padre revisa / testea / hace merge
```

**Buenas prácticas:**
- Usar cuando el trabajo del subagente es especulativo o puede conflictuar con cambios concurrentes
- Limpiar worktrees manualmente si es necesario: `git worktree prune`
- Siempre revisar el branch devuelto antes de hacer merge al main

**Cuándo usar:** Experimentos que pueden fallar, features paralelas, refactorings grandes que pueden necesitar iteración, probar enfoques alternativos sin arriesgar el trabajo actual.

Source: howto/04-subagents/README.md

## Patrón 3 — Persistent Memory

El subagente acumula conocimiento entre sesiones vía `MEMORY.md`.

```yaml
---
name: researcher
memory: user      # user | project | local
description: Investigador con memoria persistente
---

Consulta tu MEMORY.md al inicio de cada sesión para recordar contexto previo.
```

| Scope | Directorio | Caso de uso |
|-------|-----------|-------------|
| `user` | `~/.claude/agent-memory/<name>/` | Preferencias personales en todos los proyectos |
| `project` | `.claude/agent-memory/<name>/` | Conocimiento del proyecto compartido con el equipo |
| `local` | `.claude/agent-memory-local/<name>/` | Conocimiento local no commiteado |

**Comportamiento:** Las primeras 200 líneas de `MEMORY.md` se cargan automáticamente en el system prompt del subagente. Las tools Read, Write, Edit se habilitan automáticamente para que el agente gestione su memoria.

**Cuándo usar:** Agentes que construyen contexto incremental (rastreador de deuda técnica, investigador de codebase, agente de onboarding).

## Patrón 4 — Background Subagents

El subagente corre sin bloquear la conversación principal. **Hay dos planos independientes — no confundirlos.**

### Plano A — Agente declara compatibilidad (frontmatter)

```yaml
---
name: long-runner
background: true
description: Análisis de larga duración en background
---
```

`background: true` en el frontmatter declara que este agente es apto para ejecución async. Efecto: auto-deniega cualquier permiso que no esté pre-aprobado al correr en background. Ninguno de los agentes actuales de THYROX usa este campo — es opcional.

### Plano B — Orquestador invoca en background (tool call)

El orquestador pasa `run_in_background: true` al Agent tool, independientemente de si el agente tiene `background: true` en su frontmatter:

```
Agent({
  description: "...",
  run_in_background: true,
  prompt: "Analiza cobertura Phase 5→6 del WP activo"
})
```

**Output del sistema al lanzar:**

```
Async agent launched successfully.
agentId: abc123  (internal ID — no mencionar al usuario.
                  Usar SendMessage con to: 'abc123' para continuar.)
output_file: /tmp/claude-0/.../tasks/abc123.output
Do not duplicate this agent's work — avoid working with the same
files or topics it is using. Continue with other work or respond
to the user instead.
```

**Reglas de operación obligatorias:**

| Regla | Razón |
|-------|-------|
| **NO leer `output_file`** | Es el JSONL completo del transcript — desborda el context window |
| **NO duplicar trabajo** | Evitar tocar los mismos archivos que el agente en background |
| **NO hacer sleep/poll** | El sistema notifica automáticamente al completar |
| **Continuar con otra tarea** | El propósito del background es paralelismo — usarlo |

**Shortcuts interactivos:**
- `Ctrl+B` — Poner en background un subagente que está corriendo síncronamente
- `Ctrl+F` (dos veces) — Matar todos los agentes en background

**Cuándo usar `run_in_background: true`:** Tareas "fire-and-forget" donde perder la notificación es tolerable — análisis, auditorías, builds, test suites, research paralela. Cualquier tarea ≥ 30s que no bloquea el hilo principal.

**Cuándo NO:** Si necesitas el resultado antes de continuar (el agente padre depende del output), usar invocación síncrona. Si la tarea requiere garantía de entrega de notificación, ver sección siguiente.

### Limitaciones de notificación y compactación

**Las notificaciones son intra-sesión.** El modelo de notificación asume que la sesión sigue activa cuando el agente termina. Si la sesión se compacta antes de que el agente complete, la notificación se pierde — no hay queue ni re-entrega documentada.

**Tres bugs documentados** (fuente: `guide/core/claude-code-releases.md`):

| Bug | Versión fix | Descripción |
|-----|-------------|-------------|
| Invisibilidad post-compactación | v2.1.83 | El agente se vuelve invisible para la sesión padre durante compactación — puede causar duplicados |
| Race condition en polling | v2.1.81 | Output cuelga si el agente completa exactamente entre dos polling intervals |
| Streaming SDK mode | post-v2.1.83 | Notificaciones no entregadas cuando se usa Agent tool vía SDK con streaming |

**Patrón de mitigación — state file como fuente de verdad:**

El agente background escribe su resultado a un archivo en disco antes de terminar. El orquestador lee el archivo en el siguiente turno, independientemente de si la notificación llegó.

```
# El agente background escribe al WP activo antes de terminar:
Write({file: "{wp-path}/{topic}-result.md", content: hallazgos})

# El orquestador lee el archivo en el siguiente turno:
Read("{wp-path}/{topic}-result.md")
```

> "The state file survives context resets, /compact operations, and even full session restarts."
> — `guide/workflows/iterative-refinement.md:542`

**Anti-patrón — no prometer notificación verbal:**

```
# ❌ Incorrecto
"El agente corre en background — te aviso cuando complete."
→ Si la sesión se compacta, el aviso nunca llega.

# ✅ Correcto
"El agente corre en background — resultado en {ruta-del-artefacto} cuando termine."
→ El usuario sabe dónde buscar independientemente de la sesión.
```

**`SubagentStop` hook como intercepción robusta:**
Si se necesita reaccionar programáticamente a la completación de un subagente, `SubagentStop` en `settings.json` es el único punto de intercepción documentado que puede bloquear. Recibe `last_assistant_message` con el output final del subagente.

---

## Patrón 5 — Resumable Agents

El subagente puede continuar una conversación previa con contexto completo. Se integra con el Patrón 4: los agentes lanzados en background son continuables vía `SendMessage`.

### Continuar un agente en background (misma sesión)

```
# El agente ya fue lanzado con run_in_background: true
# Notificación de completado llega automáticamente
# Para continuar o enviar trabajo adicional antes de que termine:

SendMessage(to: 'abc123', message: "Analiza también el módulo de autorización")
```

El `agentId` devuelto al lanzar es el token de continuación — guardarlo si se quiere reanudar.

### Continuar en sesión posterior

```bash
# Primera invocación (sesión A)
> Use the code-analyzer agent to start reviewing the auth module
# Returns agentId: "abc123"

# Continuar más tarde (sesión B)
> Resume agent abc123 and analyze the authorization logic as well
```

Los transcripts se guardan en `~/.claude/projects/{project}/{sessionId}/subagents/agent-{agentId}.jsonl`.

**Cuándo usar:** Investigaciones largas en múltiples sesiones, refinamiento iterativo sin perder contexto, continuar agentes background con trabajo adicional.

## Patrón 6 — Agent Chaining

El output de un subagente alimenta a otro en secuencia.

```bash
> First use the code-analyzer subagent to find performance issues,
  then use the optimizer subagent to fix them
```

**Cuándo usar:** Workflows en dos fases (análisis → implementación), separación de roles (reviewer → fixer), pipelines de transformación.

## Patrón 7 — Agent Teams (Experimental)

Múltiples instancias de Claude Code trabajando en paralelo con coordinación via mailbox.

```
Team Lead (coordina)
    │
    ├── [Shared Task List + Dependency tracking]
    │
    ├── Teammate 1 (propio context window) ──┐
    ├── Teammate 2 (propio context window) ──┤ → Mailbox (mensajes inter-agente)
    └── Teammate 3 (propio context window) ──┘
```

**Diferencia vs Subagentes:**

| Aspecto | Subagentes | Agent Teams |
|---------|-----------|-------------|
| Delegación | Padre espera resultado | Teammates trabajan independientemente |
| Contexto | Fresh per subtask, results distilled | Cada teammate mantiene su propio context |
| Comunicación | Solo resultados al padre | Mensajes directos entre teammates via mailbox |
| Sesión | Resumable | No resumable (in-process) |
| Mejor para | Subtasks bien definidos | Trabajo complejo con comunicación inter-agente |

**Habilitar:**
```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

**Tamaño óptimo:** 3-5 teammates. Tareas de 5-15 minutos cada una. Asignar archivos/directorios distintos por teammate para evitar conflictos.

**Hook events para teams:** `TeammateIdle` (teammate sin trabajo pendiente), `TaskCompleted` (tarea marcada completa).

## Patrón 8 — Restrict Spawnable Subagents

Controla qué subagentes puede delegar un subagente dado:

```yaml
---
name: coordinator
description: Coordina trabajo entre agentes especializados
tools: Agent(worker, researcher), Read, Bash
---
```

El `coordinator` solo puede delegar a `worker` y `researcher`. No puede crear otros subagentes.

**Cuándo usar:** Arquitecturas con roles definidos, prevenir escalada de privilegios en sistemas multi-agente.

## Invocación de subagentes

| Método | Cuándo | Ejemplo |
|--------|--------|---------|
| **Automático** | Claude elige basado en descripción | Claude ve tarea de code review → invoca code-reviewer |
| **Explícito** | Usuario pide específicamente | `"Use the task-executor agent to..."` |
| **@-mention** | Garantiza invocación específica | `@"code-reviewer (agent)" review auth module` |
| **--agent flag** | Toda la sesión usa ese agente | `claude --agent code-reviewer` |
| **--agents JSON** | Define agentes para la sesión | `claude --agents '{"reviewer": {...}}'` |

**Para invocación automática:** Incluir "use PROACTIVELY" o "MUST BE USED" en la `description` del agente.

## Cuándo NO usar subagentes

| Escenario | Por qué no |
|-----------|-----------|
| Review rápido de código | Overhead innecesario, latencia |
| Tarea de un solo paso | Agrega complejidad sin beneficio |
| Context compartido necesario | Subagente recibe clean slate |
| Herramientas limitadas del parent | Subagente sin acceso si no se configuran |

## Configuración de tools en subagentes

```yaml
# Opción 1: Heredar todos los tools (omitir el campo)
---
name: full-access-agent
description: Agente con acceso completo
---

# Opción 2: Tools específicos
---
name: read-only-agent
tools: Read, Grep, Glob
---

# Opción 3: Bash restringido a comandos específicos
---
name: test-runner
tools: Read, Bash(npm test:*), Bash(pytest:*)
---
```

## Checklist de diseño

- [ ] El subagente tiene UNA responsabilidad clara
- [ ] La `description` incluye "use PROACTIVELY" si se quiere invocación automática
- [ ] Solo se otorgan los tools necesarios para su tarea
- [ ] Si hay tools que deben bloquearse explícitamente → usar `disallowedTools`
- [ ] Si necesita un modelo específico → declarar `model` (sonnet / opus / haiku / inherit)
- [ ] Si debe limitarse el número de turns → declarar `maxTurns`
- [ ] Si necesita skills precargados en contexto → usar `skills`
- [ ] Si necesita estado persistente → usar `memory` field
- [ ] Si puede correr sin bloquear → considerar `background: true` en frontmatter (declara compatibilidad) o `run_in_background: true` en la invocación (activa async inmediatamente). Son planos independientes — ver Patrón 4.
- [ ] Si hay riesgo de conflictos git → usar `isolation: worktree`
- [ ] Si el agente necesita hooks propios → definirlos en el frontmatter (no en settings.json global)
- [ ] Si viene de un plugin → verificar que no usa `hooks`, `mcpServers`, ni `permissionMode`

## Referencias

- `claude-howto/04-subagents/README.md` — Documentación oficial de subagentes (fuente externa)
- [skill-vs-agent](skill-vs-agent.md) — Cuándo crear SKILL vs agente nativo
- [hook-output-control](hook-output-control.md) — Por qué PostToolUse no puede suprimir tool results
- [agent-spec](agent-spec.md) — Spec formal de campos de agentes (obligatorios/prohibidos)
- `edit-tool-silent-mode-finding` — Investigación de TD-037 (RESUELTO)

---

## Ubicación de archivos y prioridad de carga

Los archivos de subagentes pueden almacenarse en múltiples ubicaciones con distintos alcances:

| Prioridad | Tipo | Ubicación | Alcance |
|-----------|------|-----------|---------|
| 1 (mayor) | **CLI-defined** | Via `--agents` flag (JSON) | Solo la sesión |
| 2 | **Project subagents** | `.claude/agents/` | Proyecto actual |
| 3 | **User subagents** | `~/.claude/agents/` | Todos los proyectos |
| 4 (menor) | **Plugin agents** | Directorio `agents/` del plugin | Via plugins |

Cuando hay nombres duplicados, la fuente de mayor prioridad prevalece. El comando `claude agents` muestra los overrides explícitamente.

**CLI-based configuration** — Define agentes para una sola sesión sin crear archivos:

```bash
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer. Use proactively after code changes.",
    "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  }
}'
```

---

## Campos de configuración completos

El frontmatter soporta más campos de los que muestra el checklist básico:

| Campo | Requerido | Descripción |
|-------|-----------|-------------|
| `name` | Sí | Identificador único (lowercase, hyphens) |
| `description` | Sí | Descripción de propósito. Incluir "use PROACTIVELY" para invocación automática |
| `tools` | No | Lista de tools. Omitir = heredar todos. Soporta `Agent(name)` para restringir subagentes hijos |
| `disallowedTools` | No | Lista de tools explícitamente prohibidos |
| `model` | No | `sonnet`, `opus`, `haiku`, model ID completo, o `inherit`. Default: subagent model configurado |
| `permissionMode` | No | `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan` |
| `maxTurns` | No | Máximo de turns agentic que puede ejecutar el subagente |
| `skills` | No | Lista de skills a precargar — inyecta el contenido completo del skill al context del subagente al iniciar |
| `mcpServers` | No | MCP servers disponibles para el subagente |
| `hooks` | No | Hooks con alcance al componente (PreToolUse, PostToolUse, Stop) |
| `memory` | No | Scope de memoria persistente: `user`, `project`, o `local` |
| `background` | No | `true` = siempre correr como background task |
| `effort` | No | Nivel de razonamiento: `low`, `medium`, `high`, o `max` |
| `isolation` | No | `worktree` = dar al subagente su propio git worktree |
| `initialPrompt` | No | Primer turn auto-enviado cuando el subagente corre como agente principal |

**Nota:** En v2.1.63, la herramienta `Task` fue renombrada a `Agent`. Las referencias `Task(...)` existentes siguen funcionando como alias.

### `disallowedTools` — bloqueo explícito

```yaml
---
name: safe-analyzer
description: Analizador de seguridad sin capacidad de modificación
tools: Read, Grep, Glob
disallowedTools: Write, Edit, Bash
---
```

Útil cuando se quiere que el subagente herede tools del padre pero bloquear específicamente algunos.

### `hooks` en subagentes — alcance por componente

```yaml
---
name: audited-runner
description: Runner con logging de seguridad
tools: Read, Bash, Edit
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/security-check.sh"
---
```

Los hooks definidos en el frontmatter del subagente tienen alcance solo a ese subagente — no afectan al agente padre ni a otros subagentes.

---

## Subagentes built-in

Claude Code incluye varios subagentes built-in siempre disponibles:

| Agente | Modelo | Propósito |
|--------|--------|-----------|
| **general-purpose** | Hereda | Tareas complejas multi-step con exploración y modificación |
| **Plan** | Hereda | Investigación de codebase para Plan Mode |
| **Explore** | Haiku | Exploración read-only del codebase (rápido, bajo latencia) |
| **Bash** | Hereda | Comandos de terminal en contexto separado |
| **statusline-setup** | Sonnet | Configurar el status line de Claude Code |
| **Claude Code Guide** | Haiku | Responder preguntas sobre features de Claude Code |

### Explore — niveles de profundidad

El subagente `Explore` acepta tres niveles de thoroughness explícitos:

- **"quick"** — Búsquedas rápidas con exploración mínima, bueno para encontrar patrones específicos
- **"medium"** — Exploración moderada, balance entre velocidad y completitud (default)
- **"very thorough"** — Análisis comprensivo en múltiples ubicaciones y convenciones de naming, puede tardar más

---

## Gestión de subagentes

### Comando `/agents` (recomendado)

```bash
/agents
```

Abre un menú interactivo para:
- Ver todos los subagentes disponibles (built-in, user, project)
- Crear nuevos subagentes con setup guiado
- Editar subagentes existentes y su acceso a tools
- Eliminar subagentes custom
- Ver cuáles están activos cuando hay duplicados entre fuentes

### Comando CLI `claude agents`

```bash
claude agents
```

Lista todos los agentes configurados agrupados por fuente (built-in, user-level, project-level). Indica **overrides** cuando un agente de mayor prioridad sombrea uno de menor prioridad con el mismo nombre.

### Session-wide agent via `settings.json`

Además del `--agent` flag en CLI, se puede configurar en `settings.json`:

```json
{
  "agent": "code-reviewer"
}
```

Toda la sesión usará ese agente como agente principal.

---

## Seguridad de subagentes en plugins

Los subagentes provistos por plugins tienen restricciones en su frontmatter por seguridad. Los siguientes campos **no están permitidos** en definiciones de subagentes de plugins:

- `hooks` — No pueden definir lifecycle hooks
- `mcpServers` — No pueden configurar MCP servers
- `permissionMode` — No pueden override de permission settings

Esto previene que plugins escalen privilegios o ejecuten comandos arbitrarios vía hooks de subagentes.

---

## Auto-compactación de contexto

El contexto de un subagente se compacta automáticamente al alcanzar ~95% de capacidad. Para override:

```bash
export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80
```

Útil para subagentes de larga duración que necesitan más margen antes de compactar.

---

## Agent Teams — campos adicionales (complementa Patrón 7)

### Habilitar via `settings.json`

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

### Modos de display

| Modo | Flag | Descripción |
|------|------|-------------|
| **auto** | `--teammate-mode auto` | Elige automáticamente el mejor modo para el terminal |
| **in-process** (default) | `--teammate-mode in-process` | Output inline en el terminal actual |
| **split-panes** | `--teammate-mode tmux` | Abre cada teammate en un pane separado de tmux o iTerm2 |

```bash
claude --teammate-mode tmux
```

O via `settings.json`:

```json
{
  "teammateMode": "tmux"
}
```

**Restricción:** Split-pane mode requiere tmux o iTerm2. No disponible en VS Code terminal, Windows Terminal, ni Ghostty.

**Navegación:** `Shift+Down` para navegar entre teammates en split-pane mode.

**Almacenamiento de configuración de teams:** `~/.claude/teams/{team-name}/config.json`

### Plan approval workflow

Para tareas complejas, el Team Lead crea un plan de ejecución antes de que los teammates comiencen. El usuario revisa y aprueba el plan, garantizando que el enfoque del equipo sea correcto antes de hacer cambios al código.

### Limitaciones documentadas

| Limitación | Descripción |
|------------|-------------|
| Sin session resumption | Teammates in-process no pueden reanudarse al terminar la sesión |
| Un equipo por sesión | No se pueden crear equipos anidados ni múltiples equipos en la misma sesión |
| Liderazgo fijo | El rol de Team Lead no puede transferirse a un teammate |
| Sin cross-session teams | Los teammates existen solo dentro de la sesión actual |
| Split-pane restrictions | Requiere tmux/iTerm2; no disponible en VS Code terminal, Windows Terminal, ni Ghostty |

---

## Mejores prácticas de system prompt

### Principios de diseño del prompt

**Hacer:**
- Iniciar con el agente generado por Claude, luego iterar para customizar
- Diseñar subagentes focalizados — UNA responsabilidad clara
- Escribir prompts detallados con instrucciones específicas, ejemplos y restricciones
- Limitar el acceso a tools — solo los necesarios para el propósito
- Versionar los project subagents en control de versiones para colaboración en equipo

**No hacer:**
- Crear subagentes con roles superpuestos
- Dar acceso innecesario a tools
- Usar subagentes para tareas simples de un solo paso
- Mezclar responsabilidades en el prompt de un subagente
- Olvidar pasar el contexto necesario

### Estructura de un prompt efectivo

1. **Ser específico sobre el rol**
   ```
   You are an expert code reviewer specializing in [specific areas]
   ```

2. **Definir prioridades claramente**
   ```
   Review priorities (in order):
   1. Security Issues
   2. Performance Problems
   3. Code Quality
   ```

3. **Especificar el formato de output**
   ```
   For each issue provide: Severity, Category, Location, Description, Fix, Impact
   ```

4. **Incluir pasos de acción**
   ```
   When invoked:
   1. Run git diff to see recent changes
   2. Focus on modified files
   3. Begin review immediately
   ```

### Estrategia de acceso a tools

1. **Empezar restrictivo** — Comenzar con solo los tools esenciales
2. **Expandir solo cuando sea necesario** — Agregar tools cuando los requisitos lo demanden
3. **Read-only cuando sea posible** — Usar Read/Grep para agentes de análisis
4. **Ejecución sandboxed** — Limitar Bash a patrones específicos de comandos

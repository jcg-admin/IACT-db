```yml
type: Reference
category: Claude Code Platform — Tool Execution
version: 1.0
purpose: Documentar todos los flujos de ejecución de Edit/Write y el modelo de permisos de herramientas
source: claude-howto deep-review + comportamiento observado
updated_at: 2026-04-14 20:08:02
```

# Tool Execution Model — Edit/Write Flows y Permission Model

Referencia unificada de dos mecanismos distintos que con frecuencia se confunden:

**Mecanismo A — Permission/Approval:** El harness de Claude Code decide si solicitar aprobación
antes de ejecutar una herramienta. Configurado en `settings.json`.

**Mecanismo B — Context Isolation:** El modelo Claude decide si ejecutar edits directamente
o delegarlos a un subagente. Afecta qué aparece en el context window del padre.

Estos mecanismos son **completamente independientes**. Un Edit puede ser auto-aprobado (sin
prompt) pero aún así saturar el context window del padre. Un subagente puede requerir
aprobación explícita (si el harness está en modo `default`) pero aislar el clutter.

---

## Mecanismo A — Permission/Approval Model

### Los 6 Permission Modes

| Mode | Comportamiento | Uso típico |
|------|---------------|-----------|
| `default` | Read: auto · Edit/Write: prompt · Bash: prompt | Sesión interactiva conservadora |
| `acceptEdits` | Read+Edit+Write: auto · Bash: prompt | Trabajo en archivos, sin shell libre |
| `plan` | Solo read, sin edits ni commands | Investigación / análisis |
| `dontAsk` | Solo herramientas pre-aprobadas en `allow` list | CI/CD, automatización |
| `auto` | Todas las acciones con safety classifier (Research Preview, Team/Enterprise) | Autonomía total con guardrails |
| `bypassPermissions` | Sin checks (peligroso) | Testing interno |

```mermaid
stateDiagram-v2
    [*] --> EvalMode : Tool call
    EvalMode --> AutoAccept : mode = acceptEdits/auto/bypassPermissions
    EvalMode --> MatchRules : Cualquier modo
    MatchRules --> Deny : Coincide deny rule
    MatchRules --> Ask : Coincide ask rule
    MatchRules --> Allow : Coincide allow rule
    MatchRules --> DefaultMode : Sin match → applica defaultMode
    DefaultMode --> AutoAccept : defaultMode = acceptEdits
    DefaultMode --> PromptUser : defaultMode = default
    Deny --> Blocked : [*]
    Ask --> PromptUser
    Allow --> AutoAccept
    PromptUser --> AutoAccept : Usuario aprueba
    PromptUser --> Blocked : Usuario deniega
    AutoAccept --> Execute : [*]
```

> **Precedencia:** `deny` siempre gana → luego `ask` → luego `allow` → luego `defaultMode`.
> El primer match en ese orden determina el resultado.

### Estructura de settings.json

```json
{
  "defaultMode": "acceptEdits",
  "permissions": {
    "allow": [
      "Write(/context/work/**)",
      "Bash(git add *)",
      "Bash(git commit *)"
    ],
    "ask": [
      "Edit(/.claude/scripts/*.sh)",
      "Edit(/.claude/settings.json)"
    ],
    "deny": [
      "Bash(git push --force *)",
      "Bash(rm -rf *)"
    ]
  }
}
```

**Nota:** Con `defaultMode: acceptEdits`, las reglas `Edit(...)` en `allow` son redundantes — ya están cubiertas por el defaultMode. Solo agregar reglas `Edit(...)` explícitas en `allow` cuando se necesite sobreescribir un `deny` específico.

**Semántica de patrones:**
- `Write(/context/work/**)` — ruta absoluta desde raíz del proyecto, soporta `*` y `**`
- `Bash(git add *)` — el `*` después del espacio acepta cualquier argumento
- Las reglas en `allow`/`ask`/`deny` anulan el `defaultMode` para los patrones que coinciden

### Herencia en Subagentes

Un subagente puede tener su propio `permissionMode` declarado en su YAML frontmatter:

```yaml
---
name: task-executor
description: Ejecutor de tareas atómicas
permissionMode: acceptEdits
---
```

- El `permissionMode` del subagente es **independiente** del del padre
- Las reglas `allow`/`ask`/`deny` de `settings.json` **se heredan** del padre al subagente
- Si el subagente tiene `permissionMode: acceptEdits`, auto-acepta Edits aunque el padre esté en `default`

### Background Subagents y Pre-aprobación

Los subagentes en background (`background: true`) **auto-deniegan cualquier permiso no pre-aprobado**:

```mermaid
flowchart TD
    A[Background subagent invoca tool] --> B{¿Está en allow list?}
    B -->|Sí| C[Auto-aprobado]
    B -->|No| D[Auto-denegado — no puede pedir permiso al usuario]
    C --> E[Ejecuta tool]
    D --> F[Tool call falla]
```

"Pre-aprobado" = explícitamente en la lista `allow` de `settings.json`. Los modos
`acceptEdits` o `auto` NO son suficientes para background agents — las reglas `allow`
son el único mecanismo.

### Scopes de settings.json y Precedencia

Claude Code aplica configuración desde 5 scopes en orden de prioridad (mayor → menor):

| Prioridad | Scope | Ubicación | Compartido? |
|-----------|-------|-----------|-------------|
| 1 | **Managed** | Server, MDM, registry o `managed-settings.json` del sistema | Sí (IT) |
| 2 | **Command line** | Flags `--` al arrancar | No |
| 3 | **Local** | `.claude/settings.local.json` | No (gitignored) |
| 4 | **Project** | `.claude/settings.json` | Sí (committed) |
| 5 | **User** | `~/.claude/settings.json` | No |

**Merging de arrays:** `permissions.allow`, `permissions.deny`, `permissions.ask` y
`sandbox.filesystem.allowWrite` se **concatenan y deduplicen** entre scopes — no se reemplazan.
El `deny` de cualquier scope tiene precedencia sobre el `allow` de cualquier otro scope.

**Managed delivery methods:** Server (Claude.ai admin console) · macOS MDM (`com.anthropic.claudecode`)
· Windows registry (`HKLM\SOFTWARE\Policies\ClaudeCode`) · archivo `managed-settings.json` en path
de sistema · directorio `managed-settings.d/*.json` (merged alfabéticamente).

**`allowManagedPermissionRulesOnly`** (managed only, default `false`) — Si `true`, las reglas
`allow`/`ask`/`deny` de user y project settings son ignoradas; solo aplican reglas del scope managed.

**`permissions.disableBypassPermissionsMode`** — Set a `"disable"` para bloquear el modo
`bypassPermissions` y el flag `--dangerously-skip-permissions`. Útil en managed deployments.

### Sintaxis Completa de Reglas de Permisos

Formato: `Tool` o `Tool(specifier)`. La evaluación es: deny primero → ask → allow → defaultMode.
El primer match determina el resultado.

| Tool | Patrón | Ejemplo |
|------|--------|---------|
| `Bash` | Command pattern con wildcards | `Bash(npm run *)`, `Bash(git *)` |
| `Read` | File path pattern | `Read(.env)`, `Read(./secrets/**)` |
| `Edit` | File path pattern | `Edit(src/**)`, `Edit(*.ts)` |
| `Write` | File path pattern | `Write(*.md)`, `Write(/context/work/**)` |
| `WebFetch` | `domain:hostname` | `WebFetch(domain:example.com)` |
| `WebSearch` | Sin specifier | `WebSearch` |
| `Task` | Agent name | `Task(Explore)` |
| `Agent` | Agent name | `Agent(researcher)` |
| `MCP` | `mcp__server__tool` o `MCP(server:tool)` | `mcp__memory__*` |

**Prefijos de path para Read/Edit/Write:**

| Prefijo | Significado |
|---------|-------------|
| `//` | Path absoluto desde raíz del filesystem |
| `~/` | Relativo al home directory |
| `/` | Relativo al project root |
| `./` o sin prefijo | Path relativo (directorio actual) |

**Notas sobre Bash wildcards:**
- `*` hace match en cualquier posición del string.
- `Bash(ls *)` (espacio antes de `*`) hace match de `ls -la` pero NO de `lsof`.
- `Bash(*)` equivale a `Bash` (hace match de todos los comandos).
- El sufijo legacy `:*` (ej: `Bash(npm:*)`) está deprecado.

**`permissions.additionalDirectories`** — Array de paths adicionales que Claude puede acceder
más allá del project root actual. Útil cuando el proyecto usa múltiples repos o shared libraries.

```json
{ "permissions": { "additionalDirectories": ["../shared-libs/"] } }
```

### Hook PermissionRequest — Override Dinámico de Permisos

Además de las reglas estáticas en `settings.json`, existe el hook event **`PermissionRequest`**
que se ejecuta cuando se muestra el dialog de permiso. Permite aprobar/denegar permisos
programáticamente desde un script:

```json
{
  "hooks": {
    "PermissionRequest": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/permission-check.sh"
          }
        ]
      }
    ]
  }
}
```

El hook retorna `hookSpecificOutput` con `decision.behavior: "allow"` o `"deny"`.
A diferencia de las reglas estáticas, este hook puede acceder al contexto completo del tool call
(path del archivo, comando exacto) para decisiones dinámicas.

**Diferencia vs reglas estáticas:**
- Reglas `allow`/`ask`/`deny` en settings.json: evaluación estática por patrón, antes del prompt.
- Hook `PermissionRequest`: evaluación dinámica vía script, cuando el prompt ya se iba a mostrar.

---

## Mecanismo B — Context Isolation (Subagent vs Main)

### El Problema: Context Pollution

Cuando Claude llama Edit/Write directamente en el contexto principal, cada call produce
un resultado visible en el context window:

```
→ Edit(file1.md) → "The file has been updated successfully."    [+N tokens]
→ Edit(file2.md) → "The file has been updated successfully."    [+N tokens]
→ Edit(file3.md) → "The file has been updated successfully."    [+N tokens]
```

En una sesión con 20 edits, esto consume tokens y hace el context difícil de navegar.

### La Solución: Subagent Context Isolation

```mermaid
flowchart TB
    subgraph "Main Agent Context (padre)"
        A["Claude padre\n50K tokens"]
        G["Resumen: 'Edits completados'\n(1 mensaje, N tokens)"]
    end

    subgraph "Subagent Context (aislado)"
        B["Claude subagente\n20K tokens frescos"]
        C["Edit(file1.md) → 'Updated'"]
        D["Edit(file2.md) → 'Updated'"]
        E["Edit(file3.md) → 'Updated'"]
    end

    A -->|"Agent tool\n(context clean slate)"| B
    B --> C
    B --> D
    B --> E
    B -->|"Solo summary"| G

    style C fill:#ffeeba
    style D fill:#ffeeba
    style E fill:#ffeeba
    style G fill:#d4edda
```

**Consecuencia clave:**
- ❌ `Main → Edit × N` = N mensajes "The file has been updated successfully." en el context padre
- ✅ `Main → Agent → Edit × N` = 1 resumen en el context padre, N mensajes quedan en el context del subagente

El subagente usa **su propio context window separado** ("fresh context window"). Los resultados de
Edit/Write son visibles en el transcript del subagente
(`.claude/projects/{id}/subagents/agent-{id}.jsonl`) pero **no saturan el context del padre**.

### Cuándo el Subagente Devuelve Resultados

El padre solo recibe el **output final del subagente** (lo que el subagente escribe en su respuesta),
no el histórico de tool calls. El "resultado destilado" es:

```mermaid
sequenceDiagram
    participant P as Padre
    participant S as Subagente

    P->>S: Agent tool (task description)
    S->>S: Read(file)      [interno]
    S->>S: Edit(file1.md)  [interno]
    S->>S: Edit(file2.md)  [interno]
    S->>S: Write(file3.md) [interno]
    S-->>P: "Completé N edits en X archivos. [resumen]"

    Note over P: El padre recibe SOLO el resumen.<br/>Los tool calls quedan en transcript del subagente.
```

---

## Todos los Flujos donde Aparece Edit/Write

### Flujo 1: Edit Directo en Contexto Principal

```mermaid
flowchart LR
    A[Claude] --> B[Edit tool call]
    B --> C{Permission check\nMecanismo A}
    C -->|allow| D[Ejecuta Edit]
    C -->|ask| E[Prompt usuario]
    C -->|deny| F[Bloqueado]
    E --> D
    D --> G["Result: 'Updated successfully'"]
    G --> H[Context window padre ← VISIBLE]
```

**Características:**
- Resultado visible en context del padre
- Aprobación determinada por settings.json
- N edits = N resultados en context

### Flujo 2: Edit en Subagente Foreground

```mermaid
flowchart LR
    A[Claude padre] --> B["Agent tool\n(foreground)"]
    B --> C[Subagente]
    C --> D[Edit tool call]
    D --> E{Permission check\nMecanismo A — heredado del padre}
    E -->|allow| F[Ejecuta Edit]
    F --> G["Result: 'Updated'"]
    G --> H[Context subagente ← AISLADO]
    C --> I[Resumen final]
    I --> J[Context padre ← SOLO RESUMEN]
```

**Características:**
- Resultado de Edit queda en context del subagente (aislado)
- Padre solo recibe el resumen final del subagente
- El `permissionMode` del subagente puede diferir del padre

### Flujo 3: Edit en Subagente Background

```mermaid
flowchart LR
    A[Claude padre] --> B["Agent tool\n(background: true)"]
    B --> C[Subagente background]
    C --> D[Edit tool call]
    D --> E{¿En allow list?}
    E -->|Sí| F[Auto-aprobado]
    E -->|No| G[Auto-denegado\nsin prompt posible]
    F --> H[Ejecuta Edit]
    H --> I[Context subagente aislado]
    C --> J["Notificación al padre\n(cuando termina)"]

    style G fill:#f8d7da
```

**Características:**
- Sin acceso al usuario para pedir permiso → requiere pre-aprobación via `allow` rules
- Context aislado igual que foreground
- El padre recibe notificación cuando el background task completa

### Flujo 4: Edit en PostToolUse Hook

```mermaid
flowchart LR
    A[Tool call principal] --> B[Tool execution]
    B --> C[PostToolUse hook trigger]
    C --> D["bash script\no Python"]
    D --> E{¿Script llama Edit?}
    E -->|Sí| F["Edit desde shell\n(fuera del context window)"]
    E -->|No| G["additionalContext\n(inyección en transcript)"]
    F --> H[Archivo modificado]
    H --> I[Context padre NO VE el edit\n(fue desde shell)]
```

**Nota crítica:** Los hooks ejecutan comandos shell externos. Si el hook modifica archivos
directamente vía `bash`, ese cambio no pasa por el Mecanismo A (permission check) ni por
el Mecanismo B (context isolation) — es una operación shell directa. El context del padre
**no verá** "The file has been updated successfully." — el hook es opaco al LLM.

Ver `hook-output-control.md` para la semántica completa de `suppressOutput`.

### Flujo 5: Edit en Scheduled Task (/loop)

```mermaid
flowchart LR
    A[/loop command] --> B[Scheduled execution\nen subagente aislado]
    B --> C[Edit tool call]
    C --> D{Permission check}
    D -->|allow en settings| E[Auto-aprobado]
    D -->|ask en settings| F["NO PUEDE preguntar\nal usuario\n(sesión separada)"]
    E --> G[Ejecuta Edit]
    G --> H[Context del loop\naislado del principal]
```

**Características:**
- Las tareas programadas corren en contextos aislados (similares a subagentes)
- Si el permiso requiere aprobación humana (`ask`), la tarea falla — debe estar en `allow`
- El Edit es funcional pero el usuario no ve el resultado hasta revisarlo explícitamente

Ver `scheduled-tasks.md` para detalles de `/loop` y `CronCreate`.

### Flujo 6: Edit en worktree Isolation

```mermaid
flowchart LR
    A["Agent(isolation: 'worktree')"] --> B[Subagente en worktree temporal]
    B --> C[Edit/Write en worktree]
    C --> D{¿Subagente hizo cambios?}
    D -->|Sí| E["Worktree preservado\n(path + branch retornados)"]
    D -->|No| F["Worktree eliminado\nautomáticamente"]
    E --> G[Padre puede revisar/mergear]
```

**Características:**
- Los Edits ocurren en un branch temporal aislado del repo
- Context isolation aplica igual (resultados en subagente, resumen al padre)
- Permite descartar trabajo experimental limpiamente

Ver `subagent-patterns.md` — sección "Worktree Isolation".

---

## Resumen Comparativo: Los Dos Mecanismos

```mermaid
quadrantChart
    title Mecanismo A (permission) vs Mecanismo B (context)
    x-axis "Sin permiso automático" --> "Con permiso automático"
    y-axis "Context padre saturado" --> "Context padre limpio"
    quadrant-1 "Ideal: auto-aprobado + sin clutter"
    quadrant-2 "Sin clutter pero requiere aprobación manual"
    quadrant-3 "Peor caso: manual + clutter"
    quadrant-4 "Auto-aprobado pero con clutter"

    "Edit directo + defaultMode=ask": [0.1, 0.1]
    "Edit directo + allow rule": [0.8, 0.1]
    "Subagente + ask rule": [0.1, 0.85]
    "Subagente + allow rule": [0.85, 0.9]
    "Background subagent + allow": [0.9, 0.95]
```

| Configuración | Aprobación | Context padre | Recomendado para |
|---------------|-----------|---------------|-----------------|
| Edit directo + `ask` rule | Manual (prompt) | Saturado | Archivos críticos con revisión |
| Edit directo + `allow` rule | Auto | Saturado | Edits simples, 1-2 archivos |
| Subagente + `ask` rule | Manual | Limpio | Tareas complejas con revisión |
| Subagente + `allow` rule | Auto | Limpio | **Patrón óptimo: task-executor** |
| Background + `allow` | Auto | Limpio | Tareas programadas, CI |

---

## Configuración Recomendada para Eliminar Prompts en Context Files

Para archivos que Claude edita frecuentemente (state files, WP artifacts), con `defaultMode: acceptEdits` las reglas `Edit(...)` son redundantes. Solo se necesitan las reglas `Write(...)`:

```json
{
  "defaultMode": "acceptEdits",
  "permissions": {
    "allow": [
      "Write(/context/now.md)",
      "Write(/context/focus.md)",
      "Write(/context/work/**)"
    ],
    "ask": [
      "Edit(/.claude/scripts/*.sh)",
      "Edit(/.claude/settings.json)"
    ],
    "deny": [
      "Bash(git push --force *)",
      "Bash(rm -rf *)"
    ]
  }
}
```

**Nota:** Las reglas `Edit(/context/*)` en `allow` son redundantes cuando `defaultMode: acceptEdits` está activo — el defaultMode ya aprueba todos los Edit automáticamente. Solo agregar `Edit(...)` explícitos en `allow` para sobreescribir un `deny` específico.

Esta configuración:
- ✅ Auto-acepta edits en archivos de sesión y WP artifacts (sin prompts)
- ✅ Pide confirmación para scripts y settings (cambios sensibles)
- ✅ Bloquea operaciones destructivas siempre
- ℹ️ No resuelve el context pollution — ese es el Mecanismo B (subagente)

---

## Mecanismo C — Sandbox (Layer 4)

La arquitectura de permisos tiene 4 capas. Los Mecanismos A y B documentados arriba
corresponden a las capas 1-2. Las capas 3-4 son complementarias:

| Capa | Mecanismo | Descripción |
|------|-----------|-------------|
| 1 | Interactive prompts | Dialog al usuario cuando no hay regla match |
| 2 | Allow/Deny/Ask rules (`settings.json`) | Reglas estáticas — **Mecanismo A** |
| 3 | Hooks (PreToolUse, PermissionRequest) | Scripts programáticos dinámicos |
| 4 | Sandbox (OS-level isolation) | Aislamiento a nivel de proceso — **Mecanismo C** |

### Native Sandbox (v2.1.0+)

Habilitado via `sandbox.enabled: true` en settings.json. Usa primitivas del OS:

| Platform | Mecanismo | Notas |
|----------|-----------|-------|
| macOS | Seatbelt (TrustedBSD MAC) | Kernel-level system call filtering |
| Linux/WSL2 | bubblewrap (namespaces + seccomp) | Requiere: `sudo apt-get install bubblewrap socat` |
| WSL1 | No soportado | bubblewrap requiere features de kernel no disponibles |
| Windows | Planificado | No disponible aún |

**Isolation model del sandbox:**
- Filesystem: read todo, write solo CWD (configurable via `sandbox.filesystem.allowWrite`)
- Network: SOCKS5 proxy + domain filtering (`sandbox.network.allowedDomains`)
- Process: entorno aislado; child processes heredan las mismas restricciones

**Interacción con Mecanismo A:**
- `sandbox.autoAllowBashIfSandboxed: true` (default) — Si sandbox está activo, los Bash commands
  que normalmente pedirían confirmación son auto-aprobados (el sandbox provee la seguridad).
- `sandbox.filesystem.allowWrite` se merges con las reglas `Edit(...)` en allow rules.
- `sandbox.filesystem.denyWrite` se merges con las reglas `Edit(...)` en deny rules.

**Cuándo usar sandbox vs reglas de permisos:**

| Necesidad | Herramienta |
|-----------|-------------|
| Bloquear comandos específicos | `deny` rules en settings.json |
| Aislar filesystem/network a nivel OS | `sandbox.enabled: true` |
| Auto-aprobar todo dentro del sandbox | `sandbox.autoAllowBashIfSandboxed: true` |
| Máxima seguridad (código no confiable) | Docker sandboxes (microVM, no native sandbox) |

---

## Variables de Entorno Relevantes al Permission Model

Estas env vars se pueden configurar en la shell antes de `claude`, o en `settings.json`
bajo la key `env` (que aplica a cada sesión automáticamente).

### Permission y modo de ejecución

| Variable | Descripción |
|----------|-------------|
| `CLAUDE_CODE_PLAN_MODE_REQUIRED` | Fuerza plan mode para la sesión |
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` | Deshabilita background tasks (`1` para deshabilitar) |
| `CLAUDE_CODE_DISABLE_CRON` | Deshabilita scheduled/cron tasks (`1` para deshabilitar) |

### Detección de contexto de ejecución

| Variable | Descripción |
|----------|-------------|
| `CLAUDECODE` | Seteada a `1` en entornos que Claude Code spawna (Bash tool, tmux). **No** seteada en hooks ni en status line commands. Usarla para detectar si un script corre dentro de Claude Code |
| `CLAUDE_CODE_REMOTE` | `"true"` si corre en remote environments. En remote, `permissions.defaultMode` solo acepta `acceptEdits` y `plan` |

### Timeouts relevantes para tool execution

| Variable | Descripción |
|----------|-------------|
| `BASH_DEFAULT_TIMEOUT_MS` | Timeout default de comandos bash (en ms) |
| `BASH_MAX_TIMEOUT_MS` | Timeout máximo de comandos bash (en ms) |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | Max output tokens por respuesta (default: 32K; 64K para Opus 4.6) |

---

## Nota: `permissions.defaultMode` vs Modos Runtime

La tabla "Los 6 Permission Modes" lista 6 modos, pero solo 4 pueden configurarse en
`permissions.defaultMode` de `settings.json`:

| Modo | Configurable en `settings.json`? | Descripción |
|------|----------------------------------|-------------|
| `default` | ✅ | Read auto; Edit/Write/Bash piden confirmación |
| `acceptEdits` | ✅ | Read+Edit+Write auto; Bash pide confirmación |
| `plan` | ✅ | Solo lectura, sin edits ni commands |
| `bypassPermissions` | ✅ (bloqueado si `disableBypassPermissionsMode`) | Sin checks — peligroso |
| `dontAsk` | ❌ (runtime/legacy) | Solo tools pre-aprobados en `allow` list |
| `auto` | ❌ (runtime, Team/Enterprise) | Safety classifier — no configurable via settings |

`dontAsk` y `auto` son modos que se activan via CLI flags o la interfaz de Claude Code,
no a través de `settings.json`. Las reglas `allow` en settings son el equivalente funcional
de `dontAsk` para tools específicos: permiten auto-aprobar herramientas concretas sin
necesidad de activar el modo `dontAsk` globalmente.

---

## Gaps en Documentación Oficial (claude-howto)

> Lo que **no está documentado** en claude-howto y se basa en comportamiento observado:

| Aspecto | Estado en claude-howto | Fuente alternativa |
|---------|----------------------|-------------------|
| Precedencia deny→ask→allow | No documentado | Observación + `permission-model.md` |
| Tool outputs de Edit en subagente no aparecen en padre | Mencionado vagamente ("results distilled") | `subagent-patterns.md` |
| Background subagents requieren `allow` explícito | Mencionado sin detallar | `scheduled-tasks.md` |
| Herencia de reglas allow/ask/deny a subagentes | No documentado | Comportamiento observado |
| Diferencia modo vs reglas en subagentes | No documentado | Inferido de 04-subagents README |

---

## Referencias Relacionadas

- [`subagent-patterns.md`](subagent-patterns.md) — 8 patrones de subagentes incluyendo context isolation
- [`hook-output-control.md`](hook-output-control.md) — semántica de suppressOutput y PostToolUse
- [`scheduled-tasks.md`](scheduled-tasks.md) — `/loop`, CronCreate, background tasks
- [`permission-model.md`](./permission-model.md) — modelo de dos planos de THYROX (gates metodológicos vs settings.json)

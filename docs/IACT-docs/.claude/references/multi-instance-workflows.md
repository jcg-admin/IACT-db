```yml
type: Reference
title: Multi-Instance Workflows — Escalado con Múltiples Sesiones
category: Claude Code Platform — Arquitectura
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Patrones para escalar más allá de una sesión — worktrees, parallel agents, git coordination
```

# Multi-Instance Workflows

Patrones para escalar más allá de una sola sesión de Claude Code. Cubre cuatro estrategias distintas con sus trade-offs, costos, y criterios de elección.

---

## Tabla de decisión — elegir el patrón correcto

| Criterio | Subagentes simples | Dual-Instance (Jon) | Boris pattern | Agent Teams |
|---|---|---|---|---|
| **Coordinación** | Automática (padre–hijo) | Manual (human gatekeeper) | Manual (human orchestrator) | Automática (git + mailbox) |
| **Eje de escala** | Vertical (delegación) | Vertical (plan ↔ execute) | Horizontal (5–15 paralelos) | Horizontal (coordinated) |
| **Tareas paralelas** | No — secuencial | No — 2 roles secuenciales | Sí — independientes | Sí — con coordinación |
| **Costo/mes estimado** | $50–100 | $100–200 | $500–1,000 | Alto (3x+ por sesión) |
| **Madurez** | Estable | Estable | Estable | Experimental (v2.1.32+) |
| **Mejor para** | Subtasks bien definidos | Spec-heavy, calidad > velocidad | Equipos, volumen alto | Análisis multi-capa, review coordinado |
| **Conflictos git** | N/A | N/A | Worktrees aislados | Resolución automática (limitada) |

**Regla de entrada rápida:**
- Tarea simple (<5 archivos, 1 dominio) → subagente simple o ninguno
- Necesito separar plan de ejecución, calidad crítica → Dual-Instance
- 10+ features en paralelo, equipo grande → Boris pattern
- Análisis multi-capa de un mismo codebase con coordinación → Agent Teams (experimental)

Fuente: `guide/workflows/agent-teams.md:64-75`, `guide/workflows/dual-instance-planning.md:42-68`, `guide/ultimate-guide.md:18562-18567`

---

## 1. Boris Cherny pattern — horizontal scaling con git worktrees

### Qué es

Boris Cherny (creador de Claude Code) documentó su workflow personal de 5–15 instancias en paralelo, cada una en su propio git worktree. No hay coordinación automática entre instancias: el humano actúa como scheduler.

Fuente: `guide/ultimate-guide.md:18613-18648`

### Cómo funciona

```
Human (scheduler)
    │
    ├── Terminal 1 (iTerm2 tab) → worktree: ../project-feature-a    → branch: feature-a
    ├── Terminal 2 (iTerm2 tab) → worktree: ../project-feature-b    → branch: feature-b
    ├── Terminal 3 (iTerm2 tab) → worktree: ../project-refactor-x   → branch: refactor-x
    ├── ...
    └── Terminal N (claude.ai/code) → --teleport sync con local
```

Cada instancia trabaja en su propio checkout. Las instancias no se comunican entre sí. El humano abre tabs, asigna trabajo, revisa PRs, desbloquea cuando hay impedimentos.

### Resultados documentados (Boris, enero 2026)

- 259 PRs mergeados en 30 días
- 497 commits, 40K líneas agregadas, 38K eliminadas
- Costo: ~$500–1,000/mes en API (Opus 4.6)
- Modelo usado: Opus 4.6 con adaptive thinking — más caro por token, pero menos correcciones, net más barato

**Advertencia crítica:** Boris es el creador de Claude Code, trabaja con arquitectura perfecta y recursos de Anthropic. Estos números no son representativos de un equipo promedio.

### Cómo iniciar worktrees

```bash
# Crear worktrees para cada instancia paralela
git worktree add ../project-agent1 -b feature-auth main
git worktree add ../project-agent2 -b feature-payments main
git worktree add ../project-agent3 -b refactor-db main

# Verificar worktrees activos
git worktree list

# Terminal 1
cd ../project-agent1 && claude

# Terminal 2
cd ../project-agent2 && claude

# Terminal 3
cd ../project-agent3 && claude

# Cuando termina una instancia, limpiar el worktree
git worktree remove ../project-agent1
```

```bash
# Buenas prácticas de naming
git worktree add ../project-$(date +%s)-auth -b feature/auth-$(date +%Y%m%d) main
```

### Ventajas

- Sin conflictos de archivos — cada instancia tiene su propio checkout
- Branching granular — cada worktree en su propia rama, PR independiente
- Sin setup especial — Claude Code estándar, sin feature flags
- Escala linealmente — agregar instancias es agregar tabs

### Limitaciones

- Requiere coordinación humana constante — sin coordinación automática
- Alto costo mensual ($500–1K) — solo justificado para equipos con volumen alto
- Requiere arquitectura modular — un monolito acoplado genera conflictos al hacer merge
- Cognitive load alto — el humano es el orchestrador de 5–15 sesiones

Fuente: `guide/ultimate-guide.md:18617-18648`, `guide/workflows/agent-teams.md:1065-1088`

---

## 2. Dual-Instance planning — Jon Williams pattern

### Qué es

Dos instancias con roles estrictamente separados: una planifica y revisa, la otra implementa. El humano es el gatekeeper: aprueba planes antes de que el implementador los ejecute.

Patrón documentado por Jon Williams (Product Designer, UK). Publicado en LinkedIn el 3 de febrero de 2026.

Fuente: `guide/workflows/dual-instance-planning.md:1-11`

### Arquitectura

```
Terminal 1: Claude Zero (Planner)
    - Explora el codebase en Plan Mode
    - Entrevista al usuario sobre requirements
    - Escribe planes detallados → .claude/plans/Review/
    - Revisa implementaciones post-ejecución
    - NUNCA edita código

         ↓ archivo en .claude/plans/Review/

Human (gatekeeper)
    - Revisa el plan
    - Aprueba: mv Review/ Active/
    - Rechaza: pide revisión a Claude Zero

         ↓ archivo en .claude/plans/Active/

Terminal 2: Claude One (Implementer)
    - Lee planes aprobados de .claude/plans/Active/
    - Implementa exactamente lo especificado
    - Hace commit después de cada paso lógico
    - Reporta completitud
    - NUNCA crea planes
```

### Configuración paso a paso

```bash
# Setup de directorios
mkdir -p .claude/plans/{Review,Active,Completed}
```

**Terminal 1 — Claude Zero:**
```bash
claude
# Primer mensaje:
# "You are Claude Zero (Planner). Your role:
#  - Explore codebase using Plan Mode (Shift+Tab twice)
#  - Interview user about requirements
#  - Write detailed plans to .claude/plans/Review/
#  - Review implementations after Claude One completes them
#  - NEVER edit code directly
#  - NEVER commit changes
#  Start by acknowledging this role."
```

**Terminal 2 — Claude One:**
```bash
claude
# Primer mensaje:
# "You are Claude One (Implementer). Your role:
#  - Read approved plans from .claude/plans/Active/
#  - Implement exactly as specified
#  - Commit changes after each logical step
#  - Report completion back to user
#  - NEVER create plans
#  - NEVER skip approval steps
#  Start by acknowledging this role."
```

**Aliases útiles:**
```bash
# Aprobar plan (mover a Active)
approve-plan() { mv ".claude/plans/Review/$1.md" ".claude/plans/Active/"; }

# Archivar plan completado
complete-plan() { mv ".claude/plans/Active/$1.md" ".claude/plans/Completed/"; }
```

### Flujo de trabajo (5 fases)

1. **Planning** — Claude Zero explora, entrevista, escribe plan en `Review/`
2. **Human review** — humano revisa checklist: requirements, approach, security, effort
3. **Implementation** — Claude One lee `Active/`, implementa, commitea por step
4. **Verification** — Claude Zero revisa contra el plan, reporta score y sugerencias
5. **Archive** — plan movido a `Completed/`

### Cuándo usar

- Especificaciones complejas o ambiguas — la entrevista de Claude Zero clarifica antes de codear
- Features security-critical — un Claude planifica, otro ejecuta, humano en el medio
- Developers con background de producto — el proceso de planificación rigoroso es muy valioso
- Budget <$300/mes — el dual-instance cuesta $100–200 vs $500–1K del Boris pattern

### Cuándo no usar

- Cambios simples (typos, refactors triviales) — overhead no justificado
- Espacio de problema desconocido — la planificación no puede anticipar lo que no se sabe
- Plazos muy ajustados donde velocidad > calidad
- Volumen alto de features paralelas — usar Boris pattern en cambio

### Cost analysis

| Escenario | Single instance | Dual instance | Ahorro |
|---|---|---|---|
| Feature simple (login form) | $5 | $6 | −$1 (single gana) |
| Feature media (auth system) | $35 (correcciones incluidas) | $24 | **$11 ahorrado** |
| Feature compleja (spec ambiguo) | $65 (correcciones incluidas) | $36 | **$29 ahorrado** |

**Punto de break-even:** features que requieren ≥2 loops de corrección → dual-instance es más barato.

Fuente: `guide/workflows/dual-instance-planning.md:614-640`

---

## 3. Agent Teams (experimental) — v2.1.32+

> **ADVERTENCIA:** Feature experimental. Requiere `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. No hay garantía de estabilidad. Sujeto a cambios o remoción. Reportar bugs a Anthropic GitHub Issues.

Fuente: `guide/workflows/agent-teams.md:10-17`

### Qué es

Múltiples instancias de Claude Code trabajando en paralelo con coordinación automática vía git y mailbox. A diferencia de Boris pattern (coordinación humana) o subagentes (padre–hijo), Agent Teams implementa coordinación peer-to-peer entre agentes.

**Introducido:** v2.1.32 (2026-02-05) como research preview.
**Modelo requerido:** Opus 4.6 mínimo.

### Arquitectura

```
Team Lead (sesión principal)
    - Descompone tareas en subtareas
    - Spawnea teammates
    - Coordina via shared task list + mailbox
    - Sintetiza hallazgos de todos los agentes
         │
         ├── [Shared Task List + Dependency tracking]
         │        (.claude/tasks/ — lock files por agente)
         │
         ├── Teammate 1 (contexto propio: 1M tokens)
         │       ↕ mensajes peer-to-peer via mailbox
         ├── Teammate 2 (contexto propio: 1M tokens)
         │       ↕
         └── Teammate 3 (contexto propio: 1M tokens)
```

**Distinción clave vs subagentes:**

| Aspecto | Subagentes | Agent Teams |
|---|---|---|
| Delegación | Padre espera resultado | Teammates trabajan independientemente |
| Comunicación | Solo resultados al padre | Mensajes directos peer-to-peer via mailbox |
| Contexto | Fresh per subtask | Cada teammate mantiene su propio contexto |
| Sesión | Resumable | No resumable (in-process) |
| Coordinación | Hierarchical | Peer-to-peer + synthesis |

Fuente: `guide/workflows/agent-teams.md:163-272`, `references/subagent-patterns.md:226-252`

### Habilitar

```bash
# Opción 1: variable de entorno (sesión actual)
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
claude

# Opción 2: persistente en ~/.bashrc o ~/.zshrc
echo 'export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1' >> ~/.bashrc

# Opción 3: settings.json (persistente)
# ~/.claude/settings.json:
# {
#   "env": {
#     "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
#   }
# }
```

**Verificación:**
```bash
> Are agent teams enabled?
# Respuesta esperada: "Yes, agent teams are enabled (experimental feature)..."
```

**Modos de display:**
```bash
# in-process (default) — output inline en terminal actual
claude

# split-panes — un pane de tmux por teammate (requiere tmux o iTerm2)
claude --teammate-mode tmux
# Navegar entre teammates: Shift+Down
```

Fuente: `guide/workflows/agent-teams.md:289-368`, `references/subagent-patterns.md:523-545`

### Cuándo usar Agent Teams

**Sí (casos validados):**
- Multi-layer code review: security + API + frontend simultáneos
- Análisis de hipótesis en paralelo (debugging producción)
- Refactoring de escala con boundaries claros (frontend/backend/tests en dirs distintos)
- Codebases >50K líneas — un solo agente llena 80–90% del contexto, sin espacio para razonar
- Tasks read-heavy donde cada agente cubre un subsistema diferente

**No (signal de anti-patrón):**
- Tareas simples (<5 archivos) — overhead no justificado
- Tasks write-heavy con archivos compartidos — merge conflicts
- Dependencies secuenciales (B requiere output de A)
- Budget ajustado — 3x costo vs single agent
- Monolitos con alto acoplamiento

**Árbol de decisión:**
```
¿Tarea simple (<5 archivos)?
    YES → single agent
    NO ↓
¿Tareas completamente independientes, sin shared state?
    YES → Boris pattern (multi-instance manual)
    NO ↓
¿Necesito separar planning de execution, calidad crítica?
    YES → Dual-Instance
    NO ↓
¿Read-heavy, análisis multi-capa?
    YES → Agent Teams ✓
    NO ↓
¿Write-heavy (muchas modificaciones de archivos compartidos)?
    YES → single agent
    NO ↓
¿Budget muy ajustado?
    YES → single agent
    NO → Agent Teams ✓ o consultar caso por caso
```

Fuente: `guide/workflows/agent-teams.md:849-878`

### Cómo crear un equipo (prompt template)

```
> Create a team to [TASK]:
> - Agent 1 ([SCOPE/CONTEXT]): [SPECIFIC MISSION]
> - Agent 2 ([SCOPE/CONTEXT]): [SPECIFIC MISSION]
> - Agent 3 ([SCOPE/CONTEXT]): [SPECIFIC MISSION]
>
> [FILES/DIRECTORIES TO ANALYZE]
```

**Ejemplo — multi-layer code review:**
```
> Review PR #42 with scope-focused analysis:
> - Security Scope: Check vulnerabilities, auth issues, data exposure (context: auth code, input validation)
> - API Scope: Review endpoint design, error handling (context: API routes, controllers)
> - Frontend Scope: Check UI patterns, accessibility (context: components, styles)
```

**Ejemplo — refactoring con boundaries claros:**
```
> Refactor auth system from JWT to OAuth2:
> - Agent 1: Backend endpoints (/api/auth/*)
> - Agent 2: Frontend components (src/components/auth/*)
> - Agent 3: Integration tests (tests/auth/)
> Coordinate changes via shared interfaces
```

Fuente: `guide/workflows/agent-teams-quick-start.md:127-135`, `guide/workflows/agent-teams.md:404-415`

### Limitaciones documentadas

| Limitación | Descripción | Mitigación |
|---|---|---|
| Solo Opus 4.6 | Todos los agentes deben usar el mismo modelo (no hay role-based model selection) | Workaround: procesos separados con `--model`, pero se pierde coordinación automática |
| Sin sesión resumable | Teammates in-process no pueden reanudarse al terminar la sesión | State files en git como fuente de verdad |
| Un equipo por sesión | Sin equipos anidados ni múltiples equipos en la misma sesión | — |
| Contexto aislado | Agentes no ven el contexto completo del otro — solo mensajes explícitos via mailbox | Diseñar tareas con mínimas inter-dependencias |
| Conflictos write-heavy | Múltiples agentes modificando el mismo archivo → merge conflicts | Single-writer pattern para archivos compartidos |
| Split-pane restrictions | Requiere tmux o iTerm2; no disponible en VS Code terminal, Windows Terminal, Ghostty | — |

Fuente: `guide/workflows/agent-teams.md:670-826`, `references/subagent-patterns.md:554-560`

### Cost analysis — Agent Teams

```
Single agent session (Opus 4.6):
    Input:  50K tokens @ $15/M = $0.75
    Output:  5K tokens @ $75/M = $0.38
    Total: $1.13

Agent Teams (3 agentes):
    Input:  150K tokens @ $15/M = $2.25
    Output:  15K tokens @ $75/M = $1.13
    Total: $3.38

Multiplicador: 3x
```

**Regla de oro:** Agent Teams justificado cuando el tiempo ahorrado > 2x el incremento de costo en tokens.

Fuente: `guide/workflows/agent-teams.md:726-752`

---

## 4. Subagentes simples — Task tool / Agent tool

Para completar la comparación: subagentes son la herramienta estándar para delegación intra-sesión. Ver `references/subagent-patterns.md` para documentación completa.

**En qué se diferencian de los patrones anteriores:**
- El padre espera el resultado antes de continuar (o usa `run_in_background: true` para async)
- Cada subagente recibe un context window fresco — solo el contexto pasado explícitamente
- Son "hijos" del agente padre, no peers
- No coordinan entre sí a menos que el padre los encadene explícitamente

**Cuándo subagente > multi-instance:**
- Subtask bien definida, acotada, sin necesidad de coordinar con otras tareas
- Solo se necesitan resultados de vuelta al padre — no paralelismo real
- Budget limitado — cero overhead de múltiples sesiones

---

## Comparación de los 4 patrones

| | Subagentes | Dual-Instance | Boris | Agent Teams |
|---|---|---|---|---|
| **Coordinación** | Padre–hijo automática | Human gatekeeper | Human orchestrator | Git + mailbox automático |
| **Paralelismo** | No | No (2 roles secuenciales) | Sí (5–15 instancias) | Sí (3–5 teammates) |
| **Setup** | Nativo | 2 terminales, directorios de planes | Multiple terminals + git worktrees | Feature flag + Opus 4.6 |
| **Costo/mes** | $50–100 | $100–200 | $500–1,000 | Alto (3x por sesión) |
| **Madurez** | Estable | Estable | Estable | Experimental |
| **Cognitive load** | Bajo | Medio | Alto (orchestrator) | Bajo (observer) |
| **Mejor para** | Subtasks acotados | Quality + spec-heavy | Volumen alto, equipo grande | Review coordinado, análisis multi-capa |
| **Requiere** | — | Disciplina de roles | Arquitectura modular, budget | Opus 4.6, git repo |

---

## Cuándo NO usar multi-instance

El 95% de los usuarios no necesitan multi-instance. Señales de que no corresponde:

- Arquitectura monolítica sin tests — genera merge conflicts y errores de integración
- Budget <$500/mes (Boris) o <$100/mes (cualquier patrón) — costo supera el beneficio
- Equipo no familiarizado con Claude Code básico — resolver primero los fundamentos
- Solo dev sin volumen alto — overhead de coordinación > beneficio
- Tareas secuenciales — si B depende de A, el paralelismo no ayuda

Fuente: `guide/ultimate-guide.md:18558-18574`

---

## Referencias

- `guide/workflows/agent-teams.md` — Documentación completa de Agent Teams (arquitectura, casos de uso, troubleshooting)
- `guide/workflows/agent-teams-quick-start.md` — Quick start de 5 minutos con prompts copy-paste
- `guide/workflows/dual-instance-planning.md` — Dual-instance completo con plan template
- `guide/ultimate-guide.md:18548-18664` — §9.17 Scaling Patterns (Boris pattern + dual-instance overview)
- `references/subagent-patterns.md` — Patrones de subagentes (delegación intra-sesión)

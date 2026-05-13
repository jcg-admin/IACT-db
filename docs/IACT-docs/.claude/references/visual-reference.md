```yml
type: Reference
title: Visual Reference — Diagramas Claude Code
category: Claude Code Platform — Referencia Visual
version: 1.0
created_at: 2026-04-15
owner: thyrox (cross-phase)
purpose: Diagramas ASCII consolidados — arquitectura, flujos de permisos, patrones de decisión
```

# Visual Reference — Diagramas Claude Code

Todos los diagramas en un solo lugar. Referencia visual rápida de conceptos clave de Claude Code.
Para documentación detallada → ver `./agent-spec.md` | `./conventions.md`

---

## Tabla de contenidos

**Arquitectura del sistema:**
1. [Master Loop](#1-master-loop)
2. [Hook Event Flow](#2-hook-event-flow)
3. [Data Privacy Flow](#3-data-privacy-flow)

**Context Management:**
4. [Context Management Zones](#4-context-management-zones)

**Flujos de permisos:**
5. [Permission Modes Cycle](#5-permission-modes-cycle)

**Árboles de decisión:**
6. [Search Tool Selection](#6-search-tool-selection)
7. [Trust Calibration Flow](#7-trust-calibration-flow)
8. [Quick Decision Tree](#8-quick-decision-tree)
9. [Adoption Decision Tree](#9-adoption-decision-tree)
10. [Methodology Selection](#10-methodology-selection)

**Patrones de workflow:**
11. [Workflow Pipeline (9 pasos)](#11-workflow-pipeline-9-pasos)
12. [Research → Spec → Code](#12-research--spec--code)
13. [Review Auto-Correction Loop](#13-review-auto-correction-loop)
14. [TDD Red-Green-Refactor Cycle](#14-tdd-red-green-refactor-cycle)
15. [UVAL Protocol Flow](#15-uval-protocol-flow)

**Seguridad:**
16. [MCP Rug Pull Attack](#16-mcp-rug-pull-attack)
17. [Docker Sandbox Architecture](#17-docker-sandbox-architecture)
18. [Security 3-Layer Defense](#18-security-3-layer-defense)
19. [Secret Exposure Timeline](#19-secret-exposure-timeline)

---

## 1. Master Loop

La arquitectura completa es un `while` loop simple — sin DAG, sin clasificador, sin RAG.

```
┌─────────────────────────────────────────────────────────────┐
│                    CLAUDE CODE MASTER LOOP                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   ┌──────────────┐                                          │
│   │  Your Prompt │                                          │
│   └──────┬───────┘                                          │
│          │                                                  │
│          ▼                                                  │
│   ┌──────────────────────────────────────────────────────┐  │
│   │                                                      │  │
│   │                  CLAUDE REASONS                      │  │
│   │        (No classifier, no routing layer)             │  │
│   │                                                      │  │
│   └────────────────────────┬─────────────────────────────┘  │
│                            │                                │
│                            ▼                                │
│                   ┌────────────────┐                        │
│                   │  Tool Call?    │                        │
│                   └───────┬────────┘                        │
│                           │                                 │
│              YES          │           NO                    │
│         ┌─────────────────┴─────────────────┐               │
│         │                                   │               │
│         ▼                                   ▼               │
│  ┌────────────┐                      ┌────────────┐         │
│  │  Execute   │                      │   Text     │         │
│  │   Tool     │                      │  Response  │         │
│  │            │                      │   (DONE)   │         │
│  └─────┬──────┘                      └────────────┘         │
│        │                                                    │
│        ▼                                                    │
│  ┌─────────────┐                                            │
│  │ Feed Result │                                            │
│  │  to Claude  │──────────────────┐                         │
│  └─────────────┘                  │                         │
│                                   │                         │
│                                   ▼                         │
│                          ┌────────────────┐                 │
│                          │   LOOP BACK    │                 │
│                          │  (Next turn)   │                 │
│                          └────────────────┘                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Hook Event Flow

Cómo los hooks interceptan el pipeline de ejecución de Claude Code:

```
┌─────────────────────────────────────────────────────────┐
│                      EVENT FLOW                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   User types message                                    │
│        │                                                │
│        ▼                                                │
│   ┌────────────────────┐                                │
│   │ UserPromptSubmit   │  ← Add context (git status)    │
│   └────────────────────┘                                │
│        │                                                │
│        ▼                                                │
│   Claude decides to run tool (e.g., Edit)               │
│        │                                                │
│        ▼                                                │
│   ┌────────────────────┐                                │
│   │ PreToolUse         │  ← Security check              │
│   └────────────────────┘                                │
│        │                                                │
│        ▼ (if allowed)                                   │
│   Tool executes                                         │
│        │                                                │
│        ▼                                                │
│   ┌────────────────────┐                                │
│   │ PostToolUse        │  ← Auto-format                 │
│   └────────────────────┘                                │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

Hooks disponibles: `UserPromptSubmit`, `PreToolUse`, `PostToolUse`, `Stop`.
Configurados en `settings.json` bajo la clave `hooks`.

---

## 3. Data Privacy Flow

Qué datos salen de tu máquina al usar Claude Code:

```
┌─────────────────────────────────────────────────────────────┐
│                    YOUR LOCAL MACHINE                       │
├─────────────────────────────────────────────────────────────┤
│  • Prompts you type                                         │
│  • Files Claude reads (including .env if not excluded!)     │
│  • MCP server results (SQL queries, API responses)          │
│  • Bash command outputs                                     │
│  • Error messages and stack traces                          │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼ HTTPS
┌─────────────────────────────────────────────────────────────┐
│                    ANTHROPIC API                            │
├─────────────────────────────────────────────────────────────┤
│  • Processes your request                                   │
│  • Stores conversation based on retention policy            │
│  • May use data for model training (if not opted out)       │
└─────────────────────────────────────────────────────────────┘
```

Usar `.claudeignore` para excluir archivos sensibles (`.env`, credenciales, etc.).

---

## 4. Context Management Zones

Cómo reaccionar según el uso de la context window (verificar con `/status`):

```
Context Usage
0%          50%         70%         90%       100%
├───────────┼───────────┼───────────┼──────────┤
│   GREEN   │  YELLOW   │  ORANGE   │   RED    │
│  work     │ selective │ /compact  │  /clear  │
│  freely   │ with care │   NOW     │ required │
└───────────┴───────────┴───────────┴──────────┘
              ▲                       ▲
              │                       │
         Be selective            Risk: forgetting
         about reads             instructions,
         and tool use            hallucinations
```

**Acciones por zona:**
- **Green (0-50%)** — Velocidad máxima. Leer archivos, explorar libremente.
- **Yellow (50-70%)** — Selectivo. Evitar lecturas de archivos innecesarias.
- **Orange (70-90%)** — Ejecutar `/compact` inmediatamente. El contexto se degrada.
- **Red (90%+)** — Ejecutar `/clear` y reiniciar. Las respuestas son poco fiables.

---

## 5. Permission Modes Cycle

Ciclar entre modos con `Shift+Tab`:

```
                 Shift+Tab              Shift+Tab
  ┌──────────┐ ────────────→ ┌───────────────┐ ────────────→ ┌───────────┐
  │ DEFAULT  │               │  AUTO-ACCEPT   │               │ PLAN MODE │
  │          │               │                │               │           │
  │ edit=ask │               │ edit=auto      │               │ edit=no   │
  │ exec=ask │               │ exec=ask       │               │ exec=no   │
  └──────────┘ ←──────────── └───────────────┘ ←──────────── └───────────┘
                 Shift+Tab              Shift+Tab
```

**Cuándo usar cada modo:**

| Modo | Usar cuando... | Nivel de riesgo |
|------|----------------|-----------------|
| **Default** | Desarrollo normal — revisar cada cambio | Bajo |
| **Auto-accept** | Tareas de confianza (formateo, refactoring) | Medio |
| **Plan mode** | Operaciones complejas/riesgosas — explorar antes | Ninguno |

**Atajos:**
- `Shift+Tab` — Ciclar al siguiente modo
- `Shift+Tab × 2` — Saltar a plan mode desde default
- `/plan` — Entrar a plan mode directamente
- `/execute` — Salir de plan mode

---

## 6. Search Tool Selection

Árbol de decisión de 3 niveles para elegir la herramienta de búsqueda correcta:

**Nivel 1: ¿Qué sabes?**

```
Do you know the EXACT text/pattern?
│
├─ YES → Use rg (ripgrep)
│  ├─ Known function name: rg "createSession"
│  ├─ Known import: rg "import.*React"
│  └─ Known pattern: rg "async function"
│
└─ NO → Go to Level 2
```

**Nivel 2: ¿Qué buscas?**

```
What's your search intent?
│
├─ "Find by MEANING/CONCEPT"
│  → Use grepai
│  └─ Example: grepai search "payment validation logic"
│
├─ "Find FUNCTION/CLASS definition"
│  → Use Serena
│  └─ Example: serena find_symbol --name "UserController"
│
├─ "Find by CODE STRUCTURE"
│  → Use ast-grep
│  └─ Example: async without error handling
│
└─ "Understand DEPENDENCIES"
   → Use grepai trace
   └─ Example: grepai trace callers "validatePayment"
```

**Nivel 3: Optimización**

```
Found too many results?
│
├─ rg → Add --type filter or narrow path
├─ grepai → Add --path filter or use trace
├─ Serena → Filter by symbol type (function/class)
└─ ast-grep → Add constraints to pattern
```

---

## 7. Trust Calibration Flow

Cuánto revisar el código generado por IA según el nivel de riesgo:

```
┌─────────────────────────────────────────────────────────┐
│                 TRUST CALIBRATION FLOW                  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  AI generates code                                      │
│         │                                               │
│         ▼                                               │
│  ┌──────────────┐                                       │
│  │ What type?   │                                       │
│  └──────────────┘                                       │
│    │    │    │                                          │
│    ▼    ▼    ▼                                          │
│  Boiler Business Security                               │
│  -plate  logic   critical                               │
│    │      │        │                                    │
│    ▼      ▼        ▼                                    │
│  Skim   Test +   Full review                            │
│  only   review   + tools                                │
│    │      │        │                                    │
│    └──────┴────────┘                                    │
│            │                                            │
│            ▼                                            │
│    Tests pass? ──No──► Debug & fix                      │
│            │                                            │
│           Yes                                           │
│            │                                            │
│            ▼                                            │
│        Ship it                                          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 8. Quick Decision Tree

Qué hacer según tu situación actual:

```
What do you need?
│
├─ Simple task ─────────────────→ Just ask Claude
│
├─ Complex task
│  ├─ Single session ───────────→ /plan + Tasks API
│  └─ Multi-session ────────────→ Tasks API + CLAUDE_CODE_TASK_LIST_ID
│
├─ Repeating task ──────────────→ Create agent or command
│
├─ Context >70% ────────────────→ /compact
│
├─ Context >90% ────────────────→ /clear (restart conversation)
│
├─ Need library docs ───────────→ Context7 MCP
│
├─ Deep debugging ──────────────→ Opus model + Alt+T (thinking)
│
├─ UI from design ──────────────→ Figma MCP or screenshot input
│
└─ Team rollout ────────────────→ Read adoption approaches
```

---

## 9. Adoption Decision Tree

Cómo elegir la estrategia de adopción de Claude Code:

```
Starting Claude Code?
│
├─ Need to ship today?
│   └─ YES → Turnkey Quickstart
│   └─ NO ↓
│
├─ Team needs shared conventions?
│   └─ YES → Turnkey + document what matters to you
│   └─ NO ↓
│
├─ Want to understand before configuring?
│   └─ YES → Autonomous Learning Path
│   └─ NO → Turnkey, adjust as you go
```

---

## 10. Methodology Selection

Qué metodología de desarrollo usar:

```
┌─ "I want quality code" ────────────→ TDD (test-driven-development skill)
│
├─ "I want to spec before code" ─────→ Spec-First workflow
│
├─ "I need to plan architecture" ────→ Plan-Driven workflow
│
├─ "I'm iterating on something" ─────→ Iterative Refinement
│
└─ "I need methodology theory" ──────→ methodologies reference
```

---

## 11. Workflow Pipeline (9 pasos)

El workflow recomendado para cada tarea:

```
  ┌─────────┐    ┌──────────┐    ┌────────────┐    ┌─────────────┐
  │ 1.START │───→│ 2./status│───→│ 3. plan?   │───→│ 4. describe │
  │ claude  │    │ check ctx│    │ Shift+Tab×2│    │ WHAT/WHERE  │
  └─────────┘    └──────────┘    │ (if risky) │    │ HOW/VERIFY  │
                                 └────────────┘    └──────┬──────┘
                                                          │
      ┌───────────────────────────────────────────────────┘
      │
      ▼
  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
  │ 5.review │───→│ 6. y/n   │───→│ 7. test  │───→│ 8.commit │───→│9./compact│
  │   diff   │    │ accept?  │    │   run    │    │ when done│    │ when >70%│
  └──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
```

**Principios clave:**
- **Paso 2**: Siempre verificar contexto antes de empezar. Si >70%, `/compact` primero.
- **Paso 3**: Usar plan mode para cualquier cosa riesgosa, compleja, o multi-archivo.
- **Paso 4**: Ser específico — prompts vagos producen resultados vagos.
- **Paso 5**: Leer cada diff. Nunca aceptar ciegamente.
- **Paso 9**: Compactar después de cada tarea para mantenerse en zona verde.

---

## 12. Research → Spec → Code

Usar Perplexity para investigación, luego Claude Code para implementación:

```
┌─────────────────────────────────────────────────────────┐
│ 1. PERPLEXITY (Deep Research)                           │
│    "Research best practices for JWT refresh tokens      │
│     in Next.js 15. Include security considerations,     │
│     common pitfalls, and library recommendations."      │
│                                                         │
│    → Output: 2000-word spec with sources               │
└───────────────────────┬─────────────────────────────────┘
                        ↓ Export as spec.md
┌─────────────────────────────────────────────────────────┐
│ 2. CLAUDE CODE                                          │
│    > claude                                             │
│    "Implement JWT refresh tokens following spec.md.     │
│     Use the jose library as recommended."               │
│                                                         │
│    → Output: Working implementation with tests         │
└─────────────────────────────────────────────────────────┘
```

---

## 13. Review Auto-Correction Loop

Patrón de code review iterativo donde Claude revisa, corrige y re-revisa:

```
┌─────────────────────────────────────────┐
│   Review Auto-Correction Loop           │
│                                          │
│   Review (identify issues)               │
│        ↓                                 │
│   Fix (apply corrections)                │
│        ↓                                 │
│   Re-Review (verify fixes)               │
│        ↓                                 │
│   Converge (minimal changes) → Done      │
│        ↑                                 │
│        └──── Repeat (max iterations)     │
└─────────────────────────────────────────┘
```

---

## 14. TDD Red-Green-Refactor Cycle

El ciclo iterativo en el corazón del Test-Driven Development:

```
                    ┌──────────────────────────┐
                    │                          │
                    ▼                          │
            ┌──────────────┐                   │
            │   RED        │                   │
            │              │                   │
            │  Write a     │                   │
            │  failing     │                   │
            │  test        │                   │
            └──────┬───────┘                   │
                   │                           │
                   │ Tests FAIL                │
                   │ (expected)                │
                   ▼                           │
            ┌──────────────┐                   │
            │   GREEN      │                   │
            │              │                   │
            │  Write       │                   │
            │  minimal     │                   │
            │  code to     │                   │
            │  pass        │                   │
            └──────┬───────┘                   │
                   │                           │
                   │ Tests PASS                │
                   │ (minimal)                 │
                   ▼                           │
            ┌──────────────┐                   │
            │   REFACTOR   │                   │
            │              │                   │
            │  Clean up    │                   │
            │  while tests │                   │
            │  stay green  │                   │
            └──────┬───────┘                   │
                   │                           │
                   │ Next feature              │
                   └───────────────────────────┘

Key rules:
  RED      → Test must FAIL before writing implementation
  GREEN    → Write ONLY enough code to pass (no more)
  REFACTOR → Improve structure, tests must stay green
  REPEAT   → One feature at a time, always in this order
```

---

## 15. UVAL Protocol Flow

Framework sistemático para aprender con IA sin perder tu propio criterio:

```
  ┌────────────────────────────────────────────────────────────┐
  │                    UVAL PROTOCOL                           │
  │         (Use AI without losing your edge)                  │
  └────────────────────────────────────────────────────────────┘

  ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
  │    U     │     │    V     │     │    A     │     │    L     │
  │UNDERSTAND│────→│  VERIFY  │────→│  APPLY   │────→│  LEARN   │
  │          │     │          │     │          │     │          │
  │ 15-min   │     │ Can you  │     │ Modify   │     │ Capture  │
  │ rule:    │     │ explain  │     │ the code │     │ insights │
  │          │     │ it back? │     │ yourself │     │ for long │
  │ 1.State  │     │          │     │          │     │ term     │
  │   problem│     │ Test:    │     │ Tasks:   │     │          │
  │ 2.Brain- │     │ explain  │     │ • Extend │     │ Methods: │
  │   storm  │     │ to a     │     │ • Modify │     │ • Notes  │
  │ 3.Find   │     │ colleague│     │ • Debug  │     │ • Teach  │
  │   gaps   │     │ without  │     │ • Adapt  │     │ • Blog   │
  │ 4.Ask    │     │ looking  │     │   to new │     │ • Review │
  │   smart  │     │ at code  │     │   context│     │   later  │
  └──────────┘     └──────────┘     └──────────┘     └──────────┘
       │                                                   │
       │              ◄── Repeat per concept ──►           │
       └───────────────────────────────────────────────────┘

  If VERIFY fails → go back to UNDERSTAND (you copied, didn't learn)
  If APPLY fails  → go back to VERIFY (you memorized, didn't understand)
```

---

## 16. MCP Rug Pull Attack

Cómo un servidor MCP malicioso puede explotar el modelo de aprobación única:

```
┌─────────────────────────────────────────────────────────────┐
│  1. Attacker publishes benign MCP "code-formatter"          │
│                         ↓                                    │
│  2. User adds to ~/.claude.json, approves once               │
│                         ↓                                    │
│  3. MCP works normally for 2 weeks (builds trust)           │
│                         ↓                                    │
│  4. Attacker pushes malicious update (no re-approval!)      │
│                         ↓                                    │
│  5. MCP exfiltrates ~/.ssh/*, .env, credentials             │
└─────────────────────────────────────────────────────────────┘
MITIGATION: Version pinning + hash verification + monitoring
```

---

## 17. Docker Sandbox Architecture

Aislamiento completo para sesiones autónomas de Claude Code:

```
┌──────────────────────────────────────────────────────────┐
│                     HOST MACHINE                          │
│                                                          │
│  ┌────────────────────────────────────────────────────┐  │
│  │              DOCKER SANDBOX (microVM)               │  │
│  │                                                    │  │
│  │  ┌──────────────┐  ┌───────────────────────────┐  │  │
│  │  │ Claude Code   │  │ Private Docker daemon     │  │  │
│  │  │ (--dsp mode)  │  │ (isolated from host)      │  │  │
│  │  └──────────────┘  └───────────────────────────┘  │  │
│  │                                                    │  │
│  │  ┌──────────────────────────────────────────────┐  │  │
│  │  │ Workspace: ~/my-project (synced with host)   │  │  │
│  │  │ Same absolute path as host                   │  │  │
│  │  └──────────────────────────────────────────────┘  │  │
│  │                                                    │  │
│  │  Base: Ubuntu, Node.js, Python 3, Go, Git,        │  │
│  │        Docker CLI, GitHub CLI, ripgrep, jq         │  │
│  │  User: non-root 'agent' with sudo                 │  │
│  └────────────────────────────────────────────────────┘  │
│                                                          │
│  Host Docker daemon: NOT accessible from sandbox          │
│  Host filesystem: NOT accessible (except workspace)       │
└──────────────────────────────────────────────────────────┘
```

---

## 18. Security 3-Layer Defense

Defensa en profundidad organizada en 3 capas temporales:

```
  ┌─────────────────────────────────────────────────────────────┐
  │                  SECURITY 3-LAYER DEFENSE                   │
  ├─────────────────────────────────────────────────────────────┤
  │                                                             │
  │  TIME ──────────────────────────────────────────────────►   │
  │         Before              During             After        │
  │                                                             │
  │  ┌─────────────────┐ ┌─────────────────┐ ┌───────────────┐ │
  │  │ LAYER 1         │ │ LAYER 2         │ │ LAYER 3       │ │
  │  │ PREVENTION      │ │ DETECTION       │ │ RESPONSE      │ │
  │  │                 │ │                 │ │               │ │
  │  │ • MCP vetting   │ │ • Prompt inject │ │ • Secret      │ │
  │  │   workflow      │ │   detection     │ │   rotation    │ │
  │  │ • Version       │ │ • Output        │ │ • MCP         │ │
  │  │   pinning       │ │   scanning      │ │   isolation   │ │
  │  │ • .claudeignore │ │ • Anomaly       │ │ • History     │ │
  │  │ • Input hooks   │ │   monitoring    │ │   rewriting   │ │
  │  │ • Safe MCP list │ │ • Secret leak   │ │ • Incident    │ │
  │  │ • Permissions   │ │   detection     │ │   reporting   │ │
  │  │ • Integrity     │ │ • Unicode/ANSI  │ │ • Post-mortem │ │
  │  │   scanning      │ │   filtering     │ │   & rotation  │ │
  │  │                 │ │                 │ │               │ │
  │  │  GOAL: Block    │ │  GOAL: Catch    │ │  GOAL: Limit  │ │
  │  │  threats at     │ │  attacks in     │ │  damage and   │ │
  │  │  entry points   │ │  real-time      │ │  recover fast │ │
  │  └─────────────────┘ └─────────────────┘ └───────────────┘ │
  │                                                             │
  │  Adoption path:                                             │
  │  Solo dev    → Layer 1 basics (output scanner)              │
  │  Team        → Layer 1 + 2 (+ injection hooks)              │
  │  Enterprise  → All 3 layers (+ ZDR + verification)          │
  │                                                             │
  └─────────────────────────────────────────────────────────────┘
```

---

## 19. Secret Exposure Timeline

Respuesta de emergencia cuando un secreto (API key, token, password) queda expuesto:

```
  SECRET EXPOSED — Emergency Response Timeline
  ═══════════════════════════════════════════════════════════

  0 min                15 min              1 hour             24 hours
  │                    │                   │                  │
  ▼                    ▼                   ▼                  ▼
  ┌──────────────────┐ ┌─────────────────┐ ┌────────────────┐
  │ FIRST 15 MIN     │ │ FIRST HOUR      │ │ FIRST 24H      │
  │ Stop the         │ │ Assess damage   │ │ Remediate      │
  │ bleeding         │ │                 │ │                │
  │                  │ │ 3. Audit git    │ │ 6. Rotate ALL  │
  │ 1. REVOKE key    │ │    history      │ │    related     │
  │    immediately   │ │    (rewrite if  │ │    credentials │
  │    (AWS/GH/      │ │     pushed)     │ │                │
  │     Stripe)      │ │                 │ │ 7. Notify team │
  │                  │ │ 4. Scan deps    │ │    /compliance │
  │ 2. Confirm       │ │    for leaked   │ │    (GDPR/SOC2) │
  │    exposure      │ │    keys         │ │                │
  │    scope         │ │                 │ │ 8. Document    │
  │    (local or     │ │ 5. Check CI/CD  │ │    incident    │
  │     pushed?)     │ │    logs         │ │    timeline    │
  │                  │ │                 │ │                │
  └──────────────────┘ └─────────────────┘ └────────────────┘

  SEVERITY GUIDE:
  ┌─────────────────────────────────────────────────────────┐
  │ Local only (not pushed)  → Revoke + rotate (steps 1-2) │
  │ Pushed to remote         → Full timeline (steps 1-8)   │
  │ Public repo exposure     → Assume compromised, rotate  │
  │                            EVERYTHING, check for abuse  │
  └─────────────────────────────────────────────────────────┘
```

---

*Ver también: `./agent-spec.md` | `./conventions.md`*

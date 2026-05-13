```yml
type: ADR
title: THYROX — Identidad como sistema de Agentic AI, independiente de plataforma
status: Accepted
created_at: 2026-04-18 06:00:00
work_package: 2026-04-17-17-58-13-goto-problem-fix
supersedes: null
related: adr-arquitectura-orquestacion-thyrox.md
```

# ADR: THYROX — Identidad como sistema de Agentic AI, independiente de plataforma

## Contexto

Desde ÉPICA 1, THYROX se describió como un "framework de gestión de proyectos para Claude Code".
Ese posicionamiento era incorrecto en dos dimensiones que este ADR corrige:

### Dimensión 1 — "Framework" no describe a THYROX

En ingeniería de software, "framework" es una estructura pasiva que el humano controla
(inversión de control: el framework llama al código del usuario). Ejemplos: Django, React, Spring.

THYROX no encaja en esa categoría. Según la taxonomía SoK (Systems of Knowledge) de Agentic AI:

| Característica de Agentic AI | Implementación en THYROX |
|-------------------------------|--------------------------|
| Agentes autónomos con herramientas | 23 agentes nativos (task-executor, coordinators, tech-experts, deep-review, diagrama-ishikawa) |
| Multi-agent coordination | 11 coordinators + thyrox-coordinator orquestador, worktree isolation |
| HITL checkpoints | Gates Stage N→N+1, GATE OPERACIÓN en settings.json |
| Agentic decision loops | /loop command — ejecución continua autónoma |
| Memoria persistente | thyrox-memory MCP (FAISS semántico) store/retrieve |
| Tool use real | Read/Write/Bash/MCP sobre el entorno real |
| Triggers reactivos | SessionStart / PostCompact / Stop hooks |
| Estado persistente entre sesiones | WP + now.md + context/ |
| Skills como políticas de comportamiento | SKILL.md define comportamiento del agente — no APIs para desarrolladores |

THYROX no es una librería que el humano importa. Es un sistema que actúa, decide, persiste estado
y orquesta agentes — con el humano como supervisor (HITL), no como ejecutor.

### Dimensión 2 — La identidad estaba acoplada a la plataforma

"THYROX para Claude Code" amarra la identidad del sistema a su implementación actual.
La naturaleza agentic de THYROX (agentes autónomos, multi-agent coordination, HITL, memoria)
es independiente de si la plataforma es Claude Code, otro LLM runtime, u otro proveedor.

Confundir identidad del sistema con plataforma de implementación produce dos problemas:
1. El sistema se percibe como un plugin de Claude Code, no como un sistema propio
2. Cualquier migración o portabilidad futura requiere re-definir la identidad

---

## Opciones Consideradas

| Opción | Descripción | Problema |
|--------|-------------|----------|
| A — Framework de gestión | Descripción original | Incorrect — "framework" implica pasividad; THYROX es activo y autónomo |
| B — Herramienta / Tool | "THYROX es una herramienta de..." | Impreciso — "herramienta" no captura la autonomía multi-agent |
| C — Plataforma de gestión | "THYROX es una plataforma..." | Confunde con plataformas de hosting/infraestructura |
| D — Sistema de Agentic AI *(elegida)* | "THYROX es un sistema de Agentic AI..." | Correcto — captura autonomía, multi-agent, HITL, memoria persistente |

**Opción D elegida** porque:
- Describe el comportamiento real del sistema (actúa, decide, persiste, coordina)
- Usa terminología de la taxonomía SoK — referenciable y defensible
- Separa la identidad del sistema de su implementación actual
- Permite nota explícita de implementación: "Implementado actualmente sobre Claude Code (Anthropic)"

---

## Decisión

### D-01: Identidad canónica — "sistema de Agentic AI"

THYROX se describe como:

> **Una oración:**
> THYROX es un sistema de Agentic AI que orquesta 23 agentes especializados con memoria
> persistente, gates HITL y 12 stages propios para gestión de proyectos. Implementado
> actualmente sobre Claude Code (Anthropic).

> **Un párrafo:**
> THYROX es un sistema de Agentic AI para gestión de proyectos. Orquesta 23 agentes nativos
> especializados en ejecución autónoma o paralela con worktree isolation. Incluye memoria
> persistente semántica (thyrox-memory MCP con FAISS), hooks reactivos (SessionStart /
> PostCompact / Stop), gates HITL en cada transición Stage N→N+1, y soporte nativo para
> 11 metodologías formales. Los Skills actúan como políticas de comportamiento del agente —
> no como APIs para desarrolladores. Los Work Packages son el estado persistente del agente
> entre sesiones. Implementado actualmente sobre Claude Code (Anthropic); la naturaleza
> agentic del sistema es independiente de la plataforma.

### D-02: Separación de capa conceptual y capa de implementación

| Capa | Descripción | Cómo documentar |
|------|-------------|-----------------|
| **Conceptual (identidad)** | THYROX es un sistema de Agentic AI | Sin mención de plataforma |
| **Implementación (actual)** | Claude Code (Anthropic), Skills nativos, agentes nativos | Como nota explícita: "Implementado actualmente sobre Claude Code (Anthropic)" |

La nota de implementación es obligatoria en documentos de identidad pública (README, ARCHITECTURE).
En documentación técnica interna (references/, skills/), el contexto Claude Code es implícito y correcto.

### D-03: Usos correctos de "framework" que NO cambian

Los siguientes usos de "framework" permanecen correctos y no deben alterarse:

| Uso | Razón |
|-----|-------|
| `BABOK framework`, `PMBOK framework`, `Lean framework` | Describen frameworks metodológicos reales — son frameworks en sentido correcto |
| `meta-framework layer` | Término técnico de la capa de orquestación (ADR meta-framework-orchestration) |
| `framework-evolution` | Nombre de WP histórico — retrocompat |
| `Meta-framework Orchestration Architecture` | Nombre de ADR técnico — inmutable |
| `framework: react`, `framework: webpack` | Campos de metadata de tech skills |
| `{framework}` en path variables | Placeholder de variable en nombres de archivo |
| `RUP es un framework` | Describe a RUP — correcto en sentido de proceso iterativo |
| Benchmark comparativo `sin framework` | Shorthand de "sin THYROX" en contexto de benchmark — correcto |

### D-04: Término "sistema" como sustituto posesivo

En contextos donde "del framework" o "al framework" eran adjetivos posesivos que se referían
a THYROX, el sustituto es "del sistema" o "al sistema".

```
ANTES:  "propagar aprendizajes al framework"
AHORA:  "propagar aprendizajes al sistema"

ANTES:  "Scripts del framework"
AHORA:  "Scripts del sistema"

ANTES:  "reglas del framework"
AHORA:  "reglas del sistema"
```

---

## Archivos actualizados

Aplicado en commits 9516573, 4ce2d37, 17f5013 de ÉPICA 41. Análisis completo en:
- `analyze/framework/thyrox-agentic-ai-positioning-review.md` (v1 — inventario inicial)
- `analyze/framework/thyrox-agentic-ai-deep-review-v2.md` (v2 — revisión exhaustiva)

Archivos de identidad pública actualizados:
- `README.md` — Propósito, Descripción General, Qué es THYROX
- `ARCHITECTURE.md` — Visión General, fuente de verdad, Hooks del sistema
- `.claude/skills/thyrox/SKILL.md` — description frontmatter + cuerpo
- `CONTRIBUTING.md` — 7 fases SDLC → 12 stages propios + path pm-thyrox → thyrox

Archivos de identidad interna actualizados:
- `.claude/CLAUDE.md`, `.claude/references/skill-vs-agent.md`
- `.claude/references/permission-model.md`, `.claude/references/conventions.md`
- `.claude/references/checkpointing.md`, `.claude/references/component-decision.md`
- `.claude/references/memory-hierarchy.md`, `.claude/references/state-management.md`
- `.claude/skills/workflow-standardize/SKILL.md`, `.claude/skills/workflow-track/SKILL.md`
- `.claude/skills/sphinx/SKILL.md`, `.thyrox/context/project-state.md`
- `.thyrox/context/focus.md`

---

## Consecuencias

**Positivas:**
- Identidad precisa — el sistema se describe por lo que hace, no por la tecnología que usa
- Portabilidad conceptual — THYROX puede implementarse sobre cualquier LLM runtime
- Coherencia con taxonomía SoK — términos defensibles ante la literatura técnica
- "Framework" liberado — puede usarse sin ambigüedad para describir BABOK/PMBOK/Lean

**Negativas:**
- Migración de documentación: ~35 archivos actualizados (ya ejecutado)
- Lectores acostumbrados al término "framework" pueden necesitar re-orientación
- "Sistema de Agentic AI" es más largo que "framework" en contextos donde el espacio es limitado

**Mitigaciones:**
- La nota "Implementado actualmente sobre Claude Code (Anthropic)" preserva el contexto de plataforma
- El análisis en v1/v2 documenta exactamente qué cambió y por qué — trazabilidad completa
- Los documentos históricos que usan "framework" son retrocompatibles (el lector entiende el antecedente)

---

## Status

**Status:** Accepted — 2026-04-18
**Work package:** `2026-04-17-17-58-13-goto-problem-fix`
**Aplicado:** commits 9516573, 4ce2d37, 17f5013

```yml
type: Reference
title: Development Methodologies — 15 Metodologías para Desarrollo AI-Asistido
category: Desarrollo — Metodología
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: 15 metodologías estructuradas para desarrollo AI-asistido, organizadas en pirámide de 6 tiers
```

# Development Methodologies

> 15 metodologías estructuradas para desarrollo AI-asistido, organizadas en pirámide de 6 tiers.
>
> **Fuente:** `guide/core/methodologies.md` (claude-code-ultimate-guide)

## Mapa en 2 ejes

Las 15 metodologías organizadas por Spec-First vs Code-First (eje Y) y Lean/Solo vs Enterprise/Governed (eje X):

```
                      SPEC / PLANNING FIRST
                                ▲
  ── lean · spec ──             │             ── governed · spec ──
                                │
  [Doc-Driven]  [SDD]           │    [BDD]  [ATDD]   [Req-Driven]
  [GSD]  [Plan-First]           │ [CDD] [ADR-Driven]  [DDD]  [BMAD]
                                │
  LEAN ─────────────────────────┼────────────────────────────────► ENTERPRISE
                                │
  ── lean · code ──             │             ── governed · code ──
                                │
  [Context Eng.]   [TDD]        │       [Multi-Agent]
  [Prompt Eng.]  [Iterative]    │       [Eval-Driven]       [FDD]
  [Ralph Loop]                  │           [JiTTesting]
                                │
                         CODE / EMERGENT
```

---

## Framework de decisión

```
¿Necesito calidad en el código?              → TDD
¿Quiero especificar antes de codificar?      → SDD / Spec Kit
¿Necesito planificar arquitectura?           → Plan-First / Plan Mode
¿Estoy iterando sobre algo existente?        → Iterative Refinement
¿Tengo stakeholders no técnicos?             → BDD / ATDD
¿Microservicios con contratos de API?        → CDD + Specmatic
¿Producto LLM-native?                        → Eval-Driven + Multi-Agent
¿Gobernanza enterprise?                      → BMAD + Spec Kit
```

---

## Las 15 metodologías — tabla de referencia rápida

| Metodología | Tier | Foco principal | Mejor para | Curva |
|-------------|------|----------------|------------|-------|
| **BMAD** | 1 — Orquestación | Gobernanza | Proyectos complejos con requisitos estables | Alta |
| **GSD** | 1 — Orquestación | Context rot | Solo devs, sesiones largas | Media |
| **Plan-First** | Fundacional | Planificación antes de código | Cualquier tarea >3 archivos | Baja |
| **SDD** | 2 — Especificación | Contratos | Cualquiera | Media |
| **Doc-Driven** | 2 — Especificación | Alineación de equipo | Cualquiera | Baja |
| **Req-Driven** | 2 — Especificación | Requisitos complejos | 20+ artefactos | Media |
| **DDD** | 2 — Especificación | Dominio de negocio | Lógica empresarial compleja | Muy Alta |
| **BDD** | 3 — Comportamiento | Colaboración stakeholders | Multi-rol | Media |
| **ATDD** | 3 — Comportamiento | Compliance | Regulado, criterios explícitos | Media |
| **CDD** | 3 — Comportamiento | APIs | Límites de servicios | Media |
| **FDD** | 4 — Entrega | Features | Equipos con entrega paralela | Media |
| **Context Eng.** | 4 — Entrega | Sesiones AI | Cualquiera | Baja |
| **TDD** | 5 — Implementación | Calidad | Cualquiera | Baja |
| **Eval-Driven** | 5 — Implementación | Outputs LLM | Productos AI | Media |
| **Multi-Agent** | 5 — Implementación | Complejidad | Tareas complejas | Media |
| **JiTTesting** | 5 — Implementación | Regresiones PRs | Alto volumen (Meta: 100M+ LoC) | Alta |
| **ADR-Driven** | 5 — Implementación | Trazabilidad | Decisiones arquitectónicas | Media |
| **Iterative** | 6 — Optimización | Refinamiento | Cualquiera | Baja |
| **Prompt Eng.** | 6 — Optimización | Fundación | Cualquiera | Muy Baja |

---

## Tier 1: Orquestación estratégica

### BMAD — Breakthrough Method for Agile AI-Driven Development

Invierte el paradigma tradicional: la documentación se convierte en la fuente de verdad, no el código. Usa agentes especializados (Analyst, PM, Architect, Developer, QA) orquestados con gobernanza estricta y `constitution.md` como guardrail estratégico.

**Cuándo usar:** Proyectos enterprise complejos con gobernanza y requisitos estables.
**Cuándo evitar:** MVPs, prototipado rápido, requisitos que evolucionan — BMAD es frágil cuando las specs cambian.

### GSD — Get Shit Done

Flujo de 6 fases (Initialize → Discuss → Plan → Execute → Verify → Complete) con contextos de 200K tokens frescos por tarea. Aborda context rot mediante reinicio de contexto sistemático.

---

## Tier Fundacional: Plan-First

> "Once the plan is good, the code is good." — Boris Cherny, creador de Claude Code

**No es solo el comando `/plan` — es una disciplina sistemática.**

### Cuándo planificar primero

| Complejidad | ¿Planificar? | Por qué |
|-------------|-------------|---------|
| >3 archivos modificados | ✅ Sí | Las dependencias cross-file necesitan arquitectura |
| >50 líneas cambiadas | ✅ Sí | Suficiente complejidad para errores |
| Cambios arquitectónicos | ✅ Sí | Requiere análisis de impacto |
| Codebase desconocida | ✅ Sí | Explorar antes de actuar |
| Fix obvio / typo | ❌ No | Overhead > tiempo de tarea |
| Cambio de una línea | ❌ No | Ejecutar directamente |

### Workflow Plan-First (3 fases)

1. **Exploración** (`Shift+Tab` → Plan Mode): Claude lee archivos, explora arquitectura. Sin edits → fuerza pensar antes de actuar. Propone enfoque con trade-offs.
2. **Validación** (tú revisas): El plan expone suposiciones y gaps. Más fácil corregir dirección ahora que después de 100 líneas escritas.
3. **Ejecución** (`Shift+Tab` de vuelta): Plan → código se convierte en traducción mecánica. Menos sorpresas.

**Plantilla para CLAUDE.md:**
```markdown
## Planning Policy
- ALWAYS plan first: API changes, database migrations, new features
- OPTIONAL planning: Bug fixes <10 lines, test additions
- NEVER skip: Changes affecting >2 modules
```

---

## Tier 2: Especificación y arquitectura

### SDD — Spec-Driven Development

Especificaciones ANTES del código. Una iteración bien estructurada = 8 no estructuradas. `CLAUDE.md` ES tu archivo de especificación.

**Herramientas SDD:**

| Herramienta | Caso de uso | Integración Claude |
|-------------|-------------|-------------------|
| **Spec Kit** (GitHub) | Greenfield, gobernanza | `/speckit.constitution`, `/speckit.specify`, `/speckit.plan` |
| **OpenSpec** | Brownfield, cambios | `/openspec:proposal`, `/openspec:apply` |
| **Specmatic** | Contratos API | MCP agent disponible |

### BDD — Behavior-Driven Development

Formato Given-When-Then para escenarios:

```gherkin
Feature: Order Management
  Scenario: Cannot buy without stock
    Given product with 0 stock
    When customer attempts purchase
    Then system refuses with error message
```

**Aplicado a agentes:** Pasar el archivo Gherkin a Claude antes de implementar. "Write failing tests for this feature file, then implement until they pass."

### ATDD — Acceptance Test-Driven Development

Criterios de aceptación definidos ANTES de codificar, colaborativamente ("Three Amigos": Business, Dev, Test). Particularmente efectivo para agentes porque necesitan condiciones de éxito inequívocas.

### JiTTesting — Just-in-Time Testing

Tests generados al momento del PR, diseñados para fallar, descartados después del merge. Sin costo de mantenimiento.

**Resultado en Meta (100M+ LoC):** 4x mejora detectando regresiones, 70% reducción en carga de revisión humana, 4 fallas graves de producción prevenidas.

**Aproximación hoy:** Antes de hacer merge de cualquier PR generado por agente: "generate tests that would catch regressions introduced by this diff specifically — I'll run them locally and discard them after the PR closes."

---

## Tier 5: Implementación

### TDD — Ciclo Red-Green-Refactor

```
1. Red:      Escribir test que falla
2. Green:    Código mínimo para pasar
3. Refactor: Limpiar, tests se mantienen en verde
```

Con Claude: ser explícito. "Write FAILING tests that don't exist yet."

**Verification Loops** — Patrón generalizado de TDD:

| Dominio | Herramienta de verificación |
|---------|---------------------------|
| Frontend | Browser preview (live reload) |
| Backend | Tests unit/integration |
| Types | TypeScript compiler |
| Style | ESLint, Prettier |
| Security | Semgrep, static analyzers |

### ADR-Driven Development

ADRs en inglés plano → skill `implement-adr` → ejecución nativa. Decisiones arquitectónicas como drivers de implementación.

```markdown
# ADR-001: Database Migration Strategy
## Context
Legacy MySQL schema needs migration to PostgreSQL.
## Decision
Use incremental dual-write pattern with feature flags.
## Consequences
- Positive: Zero-downtime migration
- Negative: Temporary code complexity
```

### Eval-Driven Development

TDD para LLMs. Tres tipos de evals:
- **Code-based:** `output == golden_answer`
- **LLM-based:** Otro Claude evalúa
- **Human grading:** Referencia, lento

---

## Combinaciones recomendadas

| Situación | Stack recomendado |
|-----------|-------------------|
| Solo dev, MVP | SDD + TDD |
| Equipo 5-10, greenfield | Spec Kit + TDD + BDD |
| Microservicios | CDD + Specmatic |
| SaaS existente (100+ features) | OpenSpec + BDD |
| Alta complejidad / compliance | BMAD + Spec Kit + Specmatic |
| Producto LLM-native | Eval-Driven + Multi-Agent |

---

## Referencias relacionadas

- [sdd](sdd.md) — Specification-Driven Development en detalle
- [testing-patterns](testing-patterns.md) — Patrones de testing prácticos
- [multi-instance-workflows](multi-instance-workflows.md) — Boris pattern, Agent Teams
- [context-engineering](context-engineering.md) — Context como disciplina de diseño

---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-code-ultimate-guide
domain: solution-strategy
repo: claude-code-ultimate-guide
---

# Estrategia de Solución: Hallazgos de claude-code-ultimate-guide

## Patrones identificados

### Patrón 1 — Plan-first como disciplina, no solo feature
**Descripción:** El /plan mode no es una feature opcional; es una disciplina. Boris Cherny (creador de Claude Code): "Once the plan is good, the code is good." La regla: planificar cuando se modifican >3 archivos, >50 líneas, cambios arquitectónicos, o codebase desconocida. El plan actúa como contrato de ejecución.
**Fuente:** core/methodologies.md:100-166
**Relevancia:** Alta

### Patrón 2 — The Trinity: Plan Mode + Extended Thinking + Sequential MCP
**Descripción:** Patrón avanzado que combina los 3 mecanismos para máximo razonamiento: Plan Mode (solo lectura fuerza pensamiento antes de acción), Extended Thinking (reasoning tokens extra), Sequential MCP (razonamiento multi-paso estructurado). Llamado "mechanic stacking" en el glosario.
**Fuente:** ultimate-guide.md tabla de contenidos:196-198; core/glossary.md:92 ("The Trinity")
**Relevancia:** Alta

### Patrón 3 — 15 metodologías organizadas en pirámide de 6 tiers
**Descripción:** El repositorio documenta 15 metodologías de desarrollo AI-asistido organizadas: Tier 1 (orquestación estratégica: BMAD, GSD), Tier 2 (spec & architecture: SDD, Doc-Driven, Req-Driven, DDD), Tier 3 (behavior & acceptance: BDD, ATDD, CDD), Tier 4 (feature delivery: FDD, Context Eng.), Tier 5 (implementation: TDD, Eval-Driven, Multi-Agent), Tier 6 (optimization).
**Fuente:** core/methodologies.md:79-400
**Relevancia:** Alta

### Patrón 4 — ADR-Driven Development como workflow nativo
**Descripción:** Workflow: escribir ADR en lenguaje natural → crear skill `implement-adr` → pasar el ADR como prompt al skill → Claude ejecuta basado en la guía arquitectónica del ADR. Conecta decisiones de arquitectura directamente con implementación.
**Fuente:** core/methodologies.md:347-396
**Relevancia:** Alta

### Patrón 5 — Dual-instance planning (Jon Williams pattern)
**Descripción:** Una instancia Claude Zero (planner: explora, escribe planes, revisa) + Claude One (implementer: lee planes, codifica, hace commits). El humano es el gatekeeper que aprueba planes antes de implementación. Planes fluyen por: Review/ → Active/ → Completed/. Costo ~$100-200/mes.
**Fuente:** guide/workflows/dual-instance-planning.md:1-70
**Relevancia:** Alta

### Patrón 6 — Event-driven agents (push-based automation)
**Descripción:** En lugar de invocar Claude Code manualmente, eventos externos (Linear card → "In Progress", GitHub issue labeled "claude-fix", Jira transition) disparan agentes automáticamente. Shift de pull-based a push-based. Requiere acceptance criteria claros en los tickets.
**Fuente:** guide/workflows/event-driven-agents.md:1-70
**Relevancia:** Media

### Patrón 7 — Verification loops como principio central
**Descripción:** "Give Claude a mechanism to verify its own output." Sin mecanismo de verificación, Claude no puede converger hacia una solución correcta — solo adivina. La verificación es por dominio: frontend (browser preview), backend (tests), tipos (TypeScript compiler), seguridad (Semgrep), accesibilidad (axe-core).
**Fuente:** core/methodologies.md:290-326
**Relevancia:** Alta

### Patrón 8 — Context engineering como fundación de todas las metodologías
**Descripción:** Thoughtworks Technology Radar (Nov 2025) designa "Context Engineering" como la disciplina broadening: diseño sistemático de información provista a LLMs. Sus 3 técnicas core: context setup (minimal system prompts, few-shot), context management para tareas largas, dynamic retrieval JIT.
**Fuente:** core/methodologies.md:107-109
**Relevancia:** Alta

### Patrón 9 — JiTTesting: testing efímero para código AI
**Descripción:** Tests generados on-the-fly al hacer PR, diseñados para fallar, descartados después del merge. Sin costo de mantenimiento de test suite. Meta la desplegó a 100M+ líneas: 4x mejora en capturar regresiones, 70% reducción en revisión humana. Implementable hoy con Claude sin infraestructura.
**Fuente:** core/methodologies.md:238-247
**Relevancia:** Media

## Conceptos clave

- Plan-first es el paradigma, no la excepción
- Las 15 metodologías cubren desde BMAD enterprise hasta TDD individual
- Verification loops (no "guess and hope") como principio de calidad
- ADR-Driven: arquitectura → implementación directa
- Event-driven: automatización push-based vs pull-based

## Notas adicionales

El "gstack" de Garry Tan (6 skills: strategic gate + architecture review + code review + release notes + browser QA + retrospective) es mencionado como ejemplo de composition de skills para un workflow completo.

La estrategia "Rev the Engine": múltiples rondas de análisis y planeamiento profundo antes de ejecutar, para detectar edge cases y failure modes temprano.

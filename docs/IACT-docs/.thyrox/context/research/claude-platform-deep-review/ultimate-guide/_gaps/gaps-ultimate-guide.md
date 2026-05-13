---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-code-ultimate-guide
domain: _gaps
repo: claude-code-ultimate-guide
---

# Gaps vs References Existentes: ultimate-guide

Referencias actuales en `.claude/references/` (36 archivos): advanced-features, agent-authoring, agent-spec, benchmark-skill-vs-claude, checkpointing, claude-authoring, claude-code-components, cli-reference, command-execution-model, component-decision, conventions, examples, hook-authoring, hook-output-control, hooks, long-context-tips, long-running-calls, mcp-integration, memory-hierarchy, memory-patterns, multimodal, output-formats, permission-model, plugins, prompting-tips, scheduled-tasks, sdd, skill-authoring, skill-vs-agent, state-management, stream-resilience, streaming-errors, subagent-patterns, testing-patterns, tool-execution-model, tool-patterns.

## Gaps identificados: 16

---

### Gap 1 — Context Engineering como disciplina completa
**Origen:** core/context-engineering.md (documento completo, ~600 líneas)
**Lo que cubre:** Distinción prompt engineering vs context engineering, presupuesto de tokens, jerarquía de 3 capas, arquitectura modular con path-scoping, team assembly, context lifecycle, quality measurement, técnicas de reducción, maturity model, token audit workflow.
**Estado en referencias existentes:** `long-context-tips.md` cubre tips tácticos de contexto largo; `memory-hierarchy.md` cubre la jerarquía de memoria. Pero ninguna cubre la disciplina de context engineering como sistema de diseño, el concepto de "context rot" con base matemática, path-scoping como arquitectura, el maturity model, ni el token audit workflow.
**Impacto:** Alto — es la disciplina fundacional que conecta CLAUDE.md, skills, y la efectividad del sistema completo.
**Acción recomendada:** Crear `context-engineering.md` con los conceptos de diseño de sistema (path-scoping, modular architecture, context budget math, maturity model).

---

### Gap 2 — Security hardening con CVEs y attack patterns
**Origen:** guide/security/security-hardening.md, guide/security/data-privacy.md, guide/security/sandbox-isolation.md
**Lo que cubre:** 15+ CVEs documentados (2025-2026), MCP Rug Pull pattern, Tool poisoning, Confused Deputy attack, MCP safe list vetted por comunidad, 5-minute MCP audit checklist, supply chain de skills (36.82% con flaws), tiers de retención de datos, sandbox isolation options.
**Estado en referencias existentes:** `permission-model.md` cubre el modelo de permisos. `mcp-integration.md` cubre MCP. Ninguna cubre CVEs específicos, patrones de ataque, supply chain de skills, ni retención de datos Anthropic.
**Impacto:** Alto — risk de seguridad real para cualquier proyecto usando MCP o skills de terceros.
**Acción recomendada:** Crear `security-hardening.md` con CVE tracker, MCP vetting, supply chain risks, y data retention tiers.

---

### Gap 3 — Production safety rules para equipos
**Origen:** guide/security/production-safety.md
**Lo que cubre:** 6 reglas no-negociables para producción (port stability, database safety, feature completeness, infrastructure lock, dependency safety, pattern following), implementaciones vía settings.json/hooks/CLAUDE.md para cada regla.
**Estado en referencias existentes:** Ninguna cubre reglas de producción específicas como principios operacionales.
**Impacto:** Alto para equipos en producción.
**Acción recomendada:** Crear `production-safety.md` con las 6 reglas y sus implementaciones concretas.

---

### Gap 4 — Enterprise governance
**Origen:** guide/security/enterprise-governance.md
**Lo que cubre:** Risk matrix local vs shared, AI Usage Charter template, MCP governance workflow + YAML registry, 4 guardrail tiers (Starter/Standard/Strict/Regulated) con settings.json copy-paste, policy enforcement en CI/CD, audit trail para SOC2/ISO27001, managed settings para IT deployment.
**Estado en referencias existentes:** Ninguna cubre gobernanza enterprise, charters, ni managed settings.
**Impacto:** Alto para organizaciones con múltiples equipos.
**Acción recomendada:** Crear `enterprise-governance.md` con charter template, tiers, y managed settings.

---

### Gap 5 — Session observability y cost tracking
**Origen:** guide/ops/observability.md, guide/ecosystem/third-party-tools.md
**Lo que cubre:** Session search tools (session-search.sh, cc-sessions.py), cost tracking (ccusage, ccburn, straude), session resume limitaciones y cross-folder migration, monitoring con proxies transparentes (cc-diag, claude-code-router), análisis de JSONL.
**Estado en referencias existentes:** `state-management.md` cubre gestión de estado de sesión del WP; `checkpointing.md` cubre rewind. Ninguna cubre observabilidad operacional de sesiones, búsqueda de historial, ni cost tracking.
**Impacto:** Medio — impacta optimización de costos y productividad en sesiones largas.
**Acción recomendada:** Crear `session-observability.md` con tools de búsqueda, cost tracking y monitoring.

---

### Gap 6 — Methodologies de desarrollo AI-asistido
**Origen:** core/methodologies.md
**Lo que cubre:** 15 metodologías organizadas en pirámide de 6 tiers. BMAD, GSD, Plan-First, SDD, Doc-Driven, DDD, BDD, ATDD, CDD, JiTTesting, FDD, Context Engineering, TDD, Eval-Driven, Multi-Agent, ADR-Driven. Mapa visual de metodologías en 2 ejes.
**Estado en referencias existentes:** `sdd.md` cubre SDD específicamente. `testing-patterns.md` cubre testing. Ninguna cubre el mapa completo de 15 metodologías, BMAD, BDD/ATDD, JiTTesting, ni el framework de decisión para elegir metodología.
**Impacto:** Alto — impacta el diseño de workflows de desarrollo completos.
**Acción recomendada:** Crear `development-methodologies.md` con el mapa de 15 metodologías y framework de decisión.

---

### Gap 7 — Multi-instance workflows (Boris pattern, agent teams)
**Origen:** guide/workflows/agent-teams.md, guide/workflows/dual-instance-planning.md
**Lo que cubre:** Agent Teams experimental (v2.1.32+, git-based coordination, peer-to-peer messaging), Boris Cherny pattern (horizontal scaling con git worktrees), dual-instance planning (Jon Williams), multi-instance vs agent teams decision framework, cost analysis por patrón.
**Estado en referencias existentes:** `subagent-patterns.md` cubre subagentes. Ninguna cubre multi-instance workflows con sesiones separadas de Claude, Agent Teams experimental, ni el Boris Cherny pattern.
**Impacto:** Alto — patrón clave para escalar trabajo complejo.
**Acción recomendada:** Crear `multi-instance-workflows.md` con Boris pattern, dual-instance, agent teams, y framework de decisión.

---

### Gap 8 — DevOps/SRE integration
**Origen:** guide/ops/devops-sre.md
**Lo que cubre:** FIRE framework (First Response/Investigate/Remediate/Evaluate), kubernetes troubleshooting workflows, incident response patterns, infrastructure as code con Claude, MCP de Kubernetes, guardrails para uso en producción.
**Estado en referencias existentes:** Ninguna cubre integración con workflows de DevOps/SRE.
**Impacto:** Medio para equipos con responsabilidades de operaciones.
**Acción recomendada:** Crear `devops-sre.md` con FIRE framework y patterns operacionales.

---

### Gap 9 — Team metrics para equipos AI-augmented
**Origen:** guide/ops/team-metrics.md
**Lo que cubre:** DORA foundation (4 métricas), DORA 2025 evolution (7 arquetipos, 8 dimensiones), SPACE framework, AI-specific metrics (cambio en CFR, comprehension debt tracking), vanity metrics a ignorar, tooling recomendado (LinearB, Faros.ai), implementation roadmap.
**Estado en referencias existentes:** Ninguna cubre métricas de equipo ni cómo DORA se comporta con AI.
**Impacto:** Medio para tech leads y engineering managers.
**Acción recomendada:** Crear `team-metrics.md` con DORA AI-augmented y SPACE.

---

### Gap 10 — Adoption approaches y decisión de configuración
**Origen:** guide/roles/adoption-approaches.md
**Lo que cubre:** Datos empíricos de adopción (scope matters, CLAUDE.md sweet spot 4-8KB, session limits 15-25 turns, script generation ROI), 4 starting points por contexto (limitado setup time, solo developer, small team, larger team), Turnkey quickstart, Autonomous learning path, Team adoption.
**Estado en referencias existentes:** Ninguna cubre estrategias de adopción ni datos empíricos sobre qué configuración funciona.
**Impacto:** Medio para onboarding de nuevos usuarios o equipos.
**Acción recomendada:** Crear `adoption-approaches.md` con datos empíricos y estrategias por contexto.

---

### Gap 11 — Context engineering tools ecosystem
**Origen:** guide/ecosystem/context-engineering-tools.md
**Lo que cubre:** Minimum Viable Context (MVC) concept, RTK (Rust Token Killer) con métricas de reducción por comando, Headroom (lossless compression), prompt compression tools (LLMLingua, PromptCrunch), AI gateways (LiteLLM, PortKey, Helicone), RAG optimization (Context7, Serena), Memory Systems, KV Cache infrastructure.
**Estado en referencias existentes:** `mcp-integration.md` cubre MCP. `long-context-tips.md` cubre tips tácticos. Ninguna cubre el ecosistema de herramientas de optimización de contexto.
**Impacto:** Medio — impacta costos y calidad en sesiones intensivas.
**Acción recomendada:** Crear `context-optimization-tools.md` con RTK, Headroom, y el ecosistema de herramientas.

---

### Gap 12 — GitHub Actions y CI/CD integration
**Origen:** guide/workflows/github-actions.md
**Lo que cubre:** `anthropics/claude-code-action` (v1.0, 6.2k stars), 5 patterns (PR review on @mention, automatic PR review on push, issue triage, security-focused review, scheduled maintenance), authentication alternatives, cost control, security checklist.
**Estado en referencias existentes:** `scheduled-tasks.md` cubre tareas programadas. Ninguna cubre la integración específica con GitHub Actions y claude-code-action.
**Impacto:** Alto para equipos con pipelines CI/CD.
**Acción recomendada:** Crear `github-actions.md` con los 5 patterns y configuración de claude-code-action.

---

### Gap 13 — Known issues y bugs activos
**Origen:** core/known-issues.md
**Lo que cubre:** 3 bugs de Prompt Cache (inflación de costos silenciosa), GitHub Issue auto-creation en repo incorrecto (privacy risk), workarounds específicos para cada bug, cómo monitorear salud del caché.
**Estado en referencias existentes:** Ninguna cubre bugs activos conocidos ni sus workarounds.
**Impacto:** Alto — los bugs de caché pueden multiplicar costos 10-20x sin saberlo.
**Acción recomendada:** Crear `known-issues.md` con bugs activos, workarounds y cómo detectarlos.

---

### Gap 14 — Settings reference completo
**Origen:** core/settings-reference.md
**Lo que cubre:** Los 5 scopes de settings con precedencia, todos los keys de settings.json documentados (50+), variables de entorno, managed settings delivery methods, diferencia entre settings.json y claude.json.
**Estado en referencias existentes:** `cli-reference.md` cubre comandos CLI. `permission-model.md` cubre permisos. Ninguna cubre el settings.json completo con todos sus keys.
**Impacto:** Medio — referencia operacional para configurar equipos.
**Acción recomendada:** Crear `settings-reference.md` con los keys más importantes y sus casos de uso.

---

### Gap 15 — Event-driven agents y automation
**Origen:** guide/workflows/event-driven-agents.md
**Lo que cubre:** Shift de pull-based a push-based automation, Linear-driven agent loop (Damian Galarza), generic event-to-agent pattern (5 componentes: event source, filter, context extraction, agent selection, output routing), guardrails para automatización.
**Estado en referencias existentes:** `scheduled-tasks.md` cubre tareas programadas. Ninguna cubre el patrón event-driven completo.
**Impacto:** Medio — patrón clave para automatización de workflows de proyecto.
**Acción recomendada:** Ampliar `scheduled-tasks.md` o crear `event-driven-automation.md` con el patrón completo.

---

### Gap 16 — Agent evaluation framework
**Origen:** guide/roles/agent-evaluation.md
**Lo que cubre:** Métricas de calidad de respuesta (task completion, correctness, hallucination rate), tool usage metrics (success rate, selection accuracy, efficiency, error recovery), performance metrics (response time, token efficiency, context utilization, cost per task), A/B testing de configuraciones de agentes.
**Estado en referencias existentes:** `agent-authoring.md` cubre creación. `benchmark-skill-vs-claude.md` cubre comparación skill vs Claude. Ninguna cubre evaluación sistemática de agentes personalizados.
**Impacto:** Medio — necesario para mejorar agentes iterativamente.
**Acción recomendada:** Crear `agent-evaluation.md` con las métricas y framework de evaluación.

---

## Resumen de gaps por impacto

| Impacto | Gaps | Acción |
|---------|------|--------|
| **Alto (6)** | context-engineering, security-hardening, production-safety, multi-instance-workflows, development-methodologies, github-actions | Crear references nuevas |
| **Alto (1)** | known-issues | Crear reference + actualizar periódicamente |
| **Medio (9)** | enterprise-governance, session-observability, devops-sre, team-metrics, adoption-approaches, context-optimization-tools, event-driven-automation, settings-reference, agent-evaluation | Crear o ampliar references |

## Temas YA bien cubiertos en referencias existentes

| Tema | Cubierto en |
|------|-------------|
| Hooks (authoring, output control, eventos) | hooks.md, hook-authoring.md, hook-output-control.md |
| Agents (authoring, spec, skill-vs-agent) | agent-authoring.md, agent-spec.md, skill-vs-agent.md |
| Skills (authoring) | skill-authoring.md |
| MCP integration | mcp-integration.md |
| Memory hierarchy | memory-hierarchy.md, memory-patterns.md |
| Permission model | permission-model.md |
| Plugins | plugins.md |
| Subagent patterns | subagent-patterns.md |
| Testing patterns | testing-patterns.md |
| State management | state-management.md |
| Checkpointing / rewind | checkpointing.md |
| SDD (Spec-Driven Development) | sdd.md |
| Streaming / errors | stream-resilience.md, streaming-errors.md |
| CLI reference | cli-reference.md |
| Tool patterns y execution model | tool-patterns.md, tool-execution-model.md |
| Scheduled tasks | scheduled-tasks.md |
| Long context tips | long-context-tips.md |
| Multimodal | multimodal.md |
| Output formats | output-formats.md |

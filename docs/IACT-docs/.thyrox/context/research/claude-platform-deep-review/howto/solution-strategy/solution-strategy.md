---
type: deep-review-domain
created_at: 2026-04-14
source: /tmp/reference/claude-howto/
topic: solution-strategy
---

# Solution Strategy — Claude Code How-To

## Patrones

### Patrón 1: Composición de features como estrategia central

El README define explícitamente la filosofía del repo: "combinations over features". El valor no está en cada feature aislado sino en cómo se combinan. El LEARNING-ROADMAP tiene una sección "Power Combinations" que documenta qué features se potencian mutuamente (memory + skills, hooks + subagents, MCP + checkpoints). La estrategia es enseñar integración, no solo uso individual.

Fuente: `README.md`, sección Why This Guide; `LEARNING-ROADMAP.md`, sección Power Combinations.

### Patrón 2: Templates reutilizables como estrategia de adopción

El repo provee templates listos para usar para memoria (project-CLAUDE.md, personal-CLAUDE.md, directory-api-CLAUDE.md), skills (code-review/SKILL.md, refactor/SKILL.md), subagentes (code-reviewer.md, debugger.md, secure-reviewer.md, test-engineer.md). La estrategia es reducir la fricción de adopción con artefactos copy-paste-ready.

Fuente: `02-memory/project-CLAUDE.md`; `03-skills/`; `04-subagents/`.

### Patrón 3: Automatización vía hooks como estrategia de integración continua

Los hooks transforman Claude Code de herramienta interactiva a sistema automatizado. La estrategia documentada: hooks para validación pre-commit, hooks para security scanning, hooks para context tracking, hooks para notificaciones (Discord/Slack). El hook system es la puerta de entrada a flujos CI/CD con Claude.

Fuente: `06-hooks/README.md`, secciones Use Cases y Examples.

### Patrón 4: MCP como estrategia de extensión del dominio

MCP permite que Claude Code acceda a cualquier sistema externo (bases de datos, APIs, herramientas de DevOps). La estrategia documentada es: primero identificar qué herramientas necesita el proyecto, luego configurar MCP servers apropiados (notion, github, filesystem). El repo DevOps Plugin ejemplifica MCP como estrategia de integración K8s/deploy.

Fuente: `05-mcp/README.md`; `07-plugins/devops-automation/README.md`.

### Patrón 5: Aislamiento vía worktrees como estrategia para paralelismo seguro

Git worktrees permiten ejecutar subagentes en ramas separadas sin contaminar el árbol principal. La estrategia documentada: `isolation: worktree` en el frontmatter del subagente activa aislamiento automático. Es la respuesta a "cómo ejecutar tareas paralelas sin conflictos de estado".

Fuente: `04-subagents/README.md`, sección Worktree Isolation.

### Patrón 6: Planning Mode como estrategia de reducción de riesgo

El `/plan` command (o `opusplan` model) crea un plan explícito antes de ejecutar cambios. La estrategia: para proyectos multi-día, cambios críticos, colaboraciones en equipo — planificar primero, aprobar el plan, luego ejecutar. Los ejemplos documentados incluyen rollback plans por fase como parte del plan.

Fuente: `09-advanced-features/planning-mode-examples.md`; `10-cli/README.md`, sección Models.

## Conceptos

- **Feature composition**: el valor emerge de combinaciones, no de features aislados
- **Zero-friction adoption**: templates copy-paste-ready como estrategia de reducción de fricción
- **Automation gateway**: hooks como puerta de entrada a flujos automatizados
- **Domain extension via MCP**: cualquier sistema externo accesible como herramienta de Claude
- **Safe parallelism**: worktree isolation como estrategia para tareas paralelas sin conflicto

## Notas

La filosofía de "combinations over features" es la clave conceptual más importante del repo. Ninguna feature individual es revolucionaria — la estrategia es su integración coherente. Esto tiene implicaciones directas para cómo documentar el proyecto THYROX: el valor está en los workflows compuestos, no en los skills individuales.

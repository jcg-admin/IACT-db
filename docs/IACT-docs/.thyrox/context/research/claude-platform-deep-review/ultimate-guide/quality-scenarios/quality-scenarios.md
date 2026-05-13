---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-code-ultimate-guide
domain: quality-scenarios
repo: claude-code-ultimate-guide
---

# Quality Scenarios y Workflows: Hallazgos de claude-code-ultimate-guide

## Patrones identificados

### Patrón 1 — GitHub Actions con @claude mention
**Descripción:** `anthropics/claude-code-action` (6.2k stars, v1.0). Dos modelos: interactive (@claude mention en PR/issue) y automated (push, PR open, schedule, label). Setup: `/install-github-app` dentro de Claude Code genera el workflow YAML automáticamente. Permisos requeridos: contents:write, pull-requests:write, issues:write.
**Fuente:** guide/workflows/github-actions.md:1-100
**Relevancia:** Alta

### Patrón 2 — TDD con Claude: requiere prompting explícito
**Descripción:** Sin instrucción explícita, Claude escribe implementación primero y luego tests que pasen contra esa implementación. Para TDD real, el prompt debe ser: "Write a FAILING test for [feature]. Do NOT write implementation yet." Configuración en CLAUDE.md con "TDD Workflow" section.
**Fuente:** guide/workflows/tdd-with-claude.md:38-70
**Relevancia:** Alta

### Patrón 3 — Spec-First: CLAUDE.md como contrato de spec
**Descripción:** CLAUDE.md IS el spec file. Tratar como contrato: 1. escribir spec en CLAUDE.md, 2. Claude lee spec automáticamente, 3. implementación sigue la spec, 4. verificar contra spec. PRD Quality Checklist de 6 dimensiones: Problem Clarity, Testable Criteria, Scope Boundaries, Observable Done, Requirements Clarity, Terminology.
**Fuente:** guide/workflows/spec-first.md:29-82
**Relevancia:** Alta

### Patrón 4 — DevOps/SRE: FIRE framework
**Descripción:** First Response (dar síntoma + contexto a Claude), Investigate (Claude analiza logs, metrics, config), Remediate (Claude propone, humano aprueba), Evaluate (postmortem, documentación). "Critical: Claude proposes, you approve" — especialmente para operaciones destructivas y producción.
**Fuente:** guide/ops/devops-sre.md:44-97
**Relevancia:** Alta

### Patrón 5 — Observabilidad de sesiones: session-search.sh
**Descripción:** Script bash zero-dependency para búsqueda de sesiones. Lista 10 sesiones recientes en ~15ms. Búsqueda de texto completo en ~400ms. Comandos: `cs`, `cs "authentication"`, `cs --since 7d`, `cs -p myproject "bug"`, `cs --json`. Output incluye el comando listo para copy-paste del `claude --resume`.
**Fuente:** guide/ops/observability.md:52-95
**Relevancia:** Media

### Patrón 6 — Cost tracking: ccusage
**Descripción:** `bunx ccusage` o `npx ccusage`. Reportes: diarios, mensuales, por sesión, o live monitoring contra ventanas de billing de 5 horas. Flag `--breakdown` para split por modelo (Opus/Sonnet/Haiku). JSON output con `--json` para scripting. También disponible como MCP server (@ccusage/mcp) y macOS widget.
**Fuente:** guide/ecosystem/third-party-tools.md:44-68
**Relevancia:** Media

### Patrón 7 — Workflow de migración entre AI tools (gradual/cold turkey/task-based)
**Descripción:** 3 estrategias documentadas: Gradual (semana 1-4, añadir progresivamente), Cold Turkey (día 1-7, solo Claude Code), Task-Based (Claude Code para features/debugging/reviews, copilot para autocomplete). Checklists por semana.
**Fuente:** ultimate-guide.md:1262-1291
**Relevancia:** Media

### Patrón 8 — Métricas DORA + SPACE para equipos AI-augmented
**Descripción:** Las 4 métricas DORA (Deployment Frequency, Lead Time, Change Failure Rate, MTTR) se comportan diferente con AI. DORA 2025 abandonó el modelo de 4 tiers por 7 arquetipos organizacionales y 8 dimensiones. AI eleva el riesgo de CFR si el review discipline no escala con la velocidad de generación.
**Fuente:** guide/ops/team-metrics.md:40-150
**Relevancia:** Media

### Patrón 9 — Figma MCP: 3-10x menos tokens que screenshots
**Descripción:** Figma tiene MCP server oficial. `get_design_context` extrae estructura React+Tailwind. `get_variable_defs` recupera design tokens. `get_code_connect_map` mapea componentes Figma → código. 3-10x menos tokens que analizar screenshots. Setup: `claude mcp add --transport http figma https://mcp.figma.com/mcp`.
**Fuente:** ultimate-guide.md:641-703
**Relevancia:** Media

### Patrón 10 — Sandbox isolation para autonomía segura
**Descripción:** Docker Sandboxes (microVM, Docker Desktop 4.58+), Native CC sandbox (Seatbelt/bubblewrap), Fly.io Sprites (Firecracker, cloud), E2B (Firecracker, multi-framework), Vercel Sandboxes, Cloudflare Sandbox SDK. El sandbox ES el boundary de seguridad; dentro se puede usar `--dangerously-skip-permissions`.
**Fuente:** guide/security/sandbox-isolation.md:1-150
**Relevancia:** Alta

## Conceptos clave

- GitHub Actions integration: interactive (@claude) y automated (events)
- TDD requiere prompting explícito para forcing el ciclo Red-Green-Refactor
- FIRE framework para DevOps/SRE
- Session search: `cc-sessions` y `session-search.sh` como herramientas clave
- Docker sandbox = safety boundary para automatización autónoma
- DORA metrics se comportan diferente post-AI adoption

## Notas adicionales

El repositorio documenta el patrón "Session Auto-Rename" con dos implementaciones: A) behavioral instruction en CLAUDE.md para rename mid-session, B) SessionEnd hook que genera título descriptivo con Haiku. Ambos complementarios.

La herramienta RTK (Rust Token Killer) puede reducir tokens de outputs de comandos un 60-90%. Integración via hook Claude Code con `rtk init --global`. Especialmente efectivo para outputs de test suites (vitest: 99%+ reducción).

```yml
type: Dashboard de Proyecto
category: Estado Actual
version: unknown
purpose: Dashboard del proyecto THYROX — estado actual y navegación
goal: Punto de entrada para entender estado actual y próximos pasos
updated_at: 2026-04-26 00:58:19
```

# Project State — THYROX

## Status General

**Versión:** unknown
**Estado:** Activo — framework thyrox con 0 FASEs completadas
**Última actualización:** 2026-04-26 00:58:19
**Branch activo:** `feature/project-setup`

---

## Agentes nativos (`29` agentes en `.claude/agents/`)

- `agentic-reasoning` — DEPRECATED — absorbido por deep-dive (Capa 7 calibración THYROX). Usar cuando
- `agentic-validator` — Valida código Python agentic contra el catálogo AP-01..AP-42. Detecta: violaci
- `ba-coordinator` — Coordinator para BABOK — Business Analysis Body of Knowledge (v3), no-secuenci
- `bpa-coordinator` — Coordinator para BPA — Business Process Analysis: As-Is (BPMN), identificació
- `cp-coordinator` — Coordinator para Consulting Process (McKinsey/BCG): Issue Tree, MECE, hipótesis
- `deep-dive` — Análisis adversarial de cualquier artefacto para determinar qué es verdadero, 
- `deep-review` — Use when analyzing coverage between consecutive WP phases, or analyzing architec
- `diagrama-ishikawa` — Especialista en análisis de causa raíz con diagramas de Ishikawa (espina de pe
- `dmaic-coordinator` — Coordinator para DMAIC — Six Sigma process improvement, 5 fases (Define/Measur
- `gate-consistency-evaluator` — Evalúa claims de un artefacto contra decisiones previas y artefactos de stages 
- `lean-coordinator` — Coordinator para Lean Six Sigma — eliminación de desperdicios, mejora de valu
- `mysql-expert` — Tech-expert para MySQL y bases de datos relacionales. Usar cuando se trabaja con
- `nodejs-expert` — Experto en Node.js, Express y ecosistema npm. Usar cuando el usuario necesite im
- `pattern-harvester` — Extrae patrones accionables de un corpus de archivos de análisis deep-dive y ca
- `pdca-coordinator` — Coordinator para PDCA — ciclo de mejora continua (Plan/Do/Check/Act), 4 stages
- `pm-coordinator` — Coordinator para PMBOK — gestión de proyectos PMI, 5 grupos de procesos (Init
- `postgresql-expert` — Tech-expert para PostgreSQL. Usar cuando se trabaja con PostgreSQL queries, sche
- `pps-coordinator` — Coordinator para PPS — Practical Problem Solving (Toyota TBP): Go-and-See, 5 W
- `react-expert` — Experto en React, hooks y ecosistema frontend. Usar cuando el usuario necesite i
- `rm-coordinator` — Coordinator para RM — Requirements Management: elicitación, análisis, especi
- `rup-coordinator` — Coordinator para RUP — Rational Unified Process: 4 fases iterativas (Inception
- `skill-generator` — Genera archivos de skill (.claude/skills/ o .claude/agents/) para una tecnologí
- `sp-coordinator` — Coordinator para Strategic Planning: PESTEL/SWOT, strategy formulation, Balanced
- `task-executor` — Ejecuta tareas atómicas de un task-plan.md. Usar cuando hay un task-plan con ch
- `task-planner` — Use when planning NEW work from scratch — breaks work into T-NNN tasks. NEVER 
- `task-synthesizer` — Consolida outputs existentes de análisis (cluster reports, gap analyses) en un 
- `tech-detector` — Detecta el stack tecnológico de un proyecto analizando archivos de configuraci�
- `thyrox-coordinator` — Coordinator genérico para THYROX — lee el YAML de metodología dinámicamente
- `webpack-expert` — Tech-expert para Webpack y bundling de assets. Conoce configuración de entry/ou

---

## FASEs completadas (0 total)

 |

Ver ROADMAP.md para detalle de cada FASE.

---

## Componentes del framework

### Skills activos (`.claude/skills/`)
- `thyrox/` — Framework principal 7 fases (motor del proyecto)
- Tech skills: backend-nodejs, db-mysql, db-postgresql, frontend-react, frontend-webpack, python-mcp, sphinx

### MCP servers
- `thyrox-memory` — Memoria semántica FAISS (store/retrieve)
- `thyrox-executor` — Ejecución subprocess con blocklist

### Scripts de gestión (`.claude/skills/thyrox/scripts/`)
- `update-state.sh` — Regenera este archivo desde el repo real
- `validate-session-close.sh` — Valida cierre de sesión
- `validate-phase-readiness.sh` — Valida readiness por fase
- `session-start.sh` — Hook SessionStart (inyecta contexto)
- `lint-agents.py` — Valida formato de agentes nativos

---

## Deuda técnica registrada

Ver `.thyrox/context/technical-debt.md` para TD-001 a TD-007.

---

## Próximos pasos

Ver ROADMAP.md sección "sin completar" y `context/focus.md` para WP activo.

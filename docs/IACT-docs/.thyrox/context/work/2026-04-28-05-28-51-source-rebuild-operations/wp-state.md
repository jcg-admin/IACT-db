```yml
project: IACT-docs
work_package: 2026-04-28-05-28-51-source-rebuild-operations
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #12 of 16 (tech-skeleton)
created_at: 2026-04-28 05:28:51
current_phase: Phase 1 — DISCOVER (DIFERIDO)
flow: thyrox
methodology_step: workflow-discover
author: NestorMonroy
status: DIFERIDO — 2026-04-29 (heavy: 203 inputs en temp-holding/. Iteracion futura cuando se priorice operations)
```

# WP-hijo #12 — Source Rebuild: operations

## Propósito

Crear cajón nuevo `source/operations/` para deployment, monitoring,
incident response, runbooks. Estructura **skeleton-first**: 3
archivos.

## Capa

**Tech (skeleton-first)** (capa 2).

## Pre-condiciones

- WPs #8-11 cerrados (backend, frontend, infrastructure, databases
  — operations consume convenciones de los 4 tiers).

## Decisiones del padre que aplican

- **Idea 9 + Decision 9 + 10 + 12.**

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Inventario de PROCs de ops/devops** | source/normativa/procedimientos/: PROC-OPS-001-deployment.rst, PROCED-DEVOPS-001-deploy_staging.rst, PROC-DEVOPS-001-devops_automation.rst, PROC-OPS-002-setup-entorno-desarrollo.rst, "Deployment del Backend IACT- README.rst". Decision 10 (re-autoría): los runbooks específicos pueden migrar acá; los PROCs metodológicos quedan en normativa/procedimientos/. |
| **Inventario de gestion/pm/deployment_plan.rst** | Plan de deploy estratégico — re-autoría parcial acá si aplica. |

## Acceptance criteria

- ✅ 3 archivos skeleton (mínimo) — pero estructura interna
  esperada: `deployment/`, `monitoring/`, `incident-response/`,
  `runbooks/` como subdirectorios con su `index.rst` cada uno
  (pero documentación dentro queda como skeleton).
- ✅ `overview.rst`: scope de operations, separación de concerns
  vs `normativa/procedimientos/`.
- ✅ `conventions.rst`: estructura de runbooks, formato de
  incident response, naming de dashboards.
- ✅ Versión 1.0.0.

## Alcance

**In-scope:** Skeleton de operations.

**Out-of-scope:** Runbooks detallados (se incorporan
incrementalmente).

## Estado

**Borrador (no iniciado).** Spawneado por T-019.

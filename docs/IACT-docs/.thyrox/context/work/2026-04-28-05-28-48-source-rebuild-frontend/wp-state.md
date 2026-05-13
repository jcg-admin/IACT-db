```yml
project: IACT-docs
work_package: 2026-04-28-05-28-48-source-rebuild-frontend
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #9 of 16 (tech-skeleton)
created_at: 2026-04-28 05:28:48
current_phase: Phase 11 — TRACK (CERRADO v1)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO v1 — 2026-04-29 (estructura minima creada en source/frontend/, commit 6d72de6)
```

# WP-hijo #9 — Source Rebuild: frontend (React + Webpack)

## Propósito

Crear cajón nuevo `source/frontend/` para React + Webpack con
estructura **skeleton-first**: 3 archivos (`index.rst` +
`overview.rst` + `conventions.rst`).

## Capa

**Tech (skeleton-first)** (capa 2).

## Pre-condiciones

- **H5:** WP #7 `source-rebuild-arquitectura-tecnica` cerrado.

## Decisiones del padre que aplican

- **Idea 9 (skeleton-first).**
- **Decision 9 + 10 + 12.**

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Inventario de ADRs frontend dispersos** | source/normativa/gobernanza/ADR-FRONT-001-frontend-modular-monolith.rst, ADR-FRONT-004-arquitectura-microfrontends.rst, "Gobernanza del Frontend-README.rst". Re-autoría con v1.0.0 fresh. |
| **Inventario gestion/pm/** | "Planificación y releases del frontend-README.rst" — re-autorear lo relevante a frontend (las release notes específicas pueden ir a gestion/releases/ — WP #16). |
| **Triage React vs Webpack** | Convenciones distintas — overview puede ser único pero conventions.rst puede dividirse en 2 secciones. |

## Acceptance criteria

- ✅ 3 archivos skeleton.
- ✅ `overview.rst`: scope React (componentes, state mgmt,
  routing) + Webpack (entry, output, loaders, plugins). SIN código.
- ✅ `conventions.rst`: naming (PascalCase para componentes,
  camelCase para hooks), estructura de carpetas, estilo.
- ✅ Versión 1.0.0.

## Alcance

**In-scope:** 3 archivos skeleton.

**Out-of-scope:** Componentes específicos, configuración Webpack
detallada, código React.

## Estado

**Borrador (no iniciado).** Spawneado por T-016.

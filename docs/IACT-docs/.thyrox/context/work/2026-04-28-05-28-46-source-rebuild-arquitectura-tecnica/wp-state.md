```yml
project: IACT-docs
work_package: 2026-04-28-05-28-46-source-rebuild-arquitectura-tecnica
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #7 of 16
created_at: 2026-04-28 05:28:46
current_phase: Phase 11 — TRACK (CERRADO v1 minimal — RBAC migrado)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO v1 minimal — 2026-04-29 (MODELO_RBAC migrado .md→.rst, otras secciones diferidas a v2)
opened_at: 2026-04-29 06:30:00
closed_at: 2026-04-29 06:45:00
```

# WP-hijo #7 — Source Rebuild: arquitectura_tecnica

## Propósito

Reconstruir `source/arquitectura_tecnica/` (15 archivos actuales)
+ **absorber `source/plantuml-guide/` (8 archivos)** según F-04 del
WP-padre. Provee architecture overview, decisiones técnicas
high-level, vistas y diagramas (PlantUML).

## Capa

**Spec / Tech** (capa 2).

## Pre-condiciones

- WP #6 `source-rebuild-requisitos` cerrado.

## Decisiones del padre que aplican

- **F-04:** `plantuml-guide/` se mueve a
  `arquitectura_tecnica/plantuml-guide/`.
- **Decision 12 (skeleton-first):** NO aplica acá — este WP NO
  es skeleton, es spec arquitectónico real.

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Migrar `plantuml-guide/` a `arquitectura_tecnica/plantuml-guide/`** | Re-autoría de los 8 archivos con v1.0.0 fresh + actualizar refs entrantes desde otros dominios. |
| **Inventario de los 15 archivos actuales** | Triage caso por caso. Algunos pueden necesitar fusión con plantuml-guide. |
| **Diseño de overview macro** | Architecture overview que sirva de "hub" para los cajones técnicos #8-11 (backend, frontend, infra, db). |

## Output crítico para WPs hermanos #8-11

Architecture overview es **input hard** (H5 del padre) para los
cajones técnicos skeleton-first. Sin él, los `overview.rst` de
backend/frontend/infra/db no pueden referenciar decisiones
arquitectónicas globales.

## Alcance

**In-scope:** Architecture overview macro, vistas, decisiones
arquitectónicas, plantuml-guide absorbido.

**Out-of-scope:** Detalles de implementación por tier (van en
WPs #8-11 skeleton-first).

## Estado

**Borrador (no iniciado).** Spawneado por T-014.

```yml
project: IACT-docs
work_package: 2026-04-28-05-28-53-source-rebuild-quality
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #14 of 16 (tech-skeleton)
created_at: 2026-04-28 05:28:53
current_phase: Phase 11 — TRACK (CERRADO v1)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO v1 — 2026-04-29 (estructura minima creada en source/)
```

# WP-hijo #14 — Source Rebuild: quality

## Propósito

Crear cajón nuevo `source/quality/` para testing strategy, coverage,
QA conventions. Estructura **skeleton-first**.

## Capa

**Tech (skeleton-first)** (capa 2).

## Pre-condiciones

- WPs #8-11 cerrados (quality define cómo se testean los 4 tiers).

## Decisiones del padre que aplican

- **Idea 9 + Decision 9 + 10 + 12.**

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Inventario de FRs/NFRs relacionados con testing** | Algunos NFRs definen qué se testea y a qué nivel. quality/ explica el cómo. |
| **Coordinar con templates `TPL_TST_Pruebas.rst`** | Si existe, este WP usa el template para describir el test strategy. |

## Acceptance criteria

- ✅ 3 archivos skeleton: `index.rst`, `overview.rst`,
  `conventions.rst`. Estructura esperada interna: `test-strategy.rst`,
  `unit-tests/`, `integration-tests/`, `e2e-tests/`, `coverage/`.
- ✅ `overview.rst`: pirámide de tests, scope por nivel, métricas
  de coverage objetivo.
- ✅ `conventions.rst`: naming de tests, ubicación, fixtures.
- ✅ Versión 1.0.0.

## Alcance

**In-scope:** Skeleton de quality strategy.

**Out-of-scope:** Tests específicos (van con código).

## Estado

**Borrador (no iniciado).** Spawneado por T-021.

```yml
project: IACT-docs
work_package: 2026-04-28-05-28-52-source-rebuild-onboarding
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #13 of 16 (tech-skeleton)
created_at: 2026-04-28 05:28:52
current_phase: Phase 11 — TRACK (CERRADO v1)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO v1 — 2026-04-29 (estructura minima creada en source/)
```

# WP-hijo #13 — Source Rebuild: onboarding

## Propósito

Crear cajón nuevo `source/onboarding/` para developer quickstart,
local-dev-setup, first-contribution. Estructura **skeleton-first**.

## Capa

**Tech (skeleton-first)** (capa 2).

## Pre-condiciones

- WPs #8-11 cerrados (onboarding referencia setup de los 4 tiers).

## Decisiones del padre que aplican

- **Idea 9 + Decision 9 + 10 + 12.**

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Coordinación con bootstrap-hardening WP** | bootstrap-hardening tiene F-NEW-7 sub-acciones para `readme.rst` (sección "First time setup") + `CONTRIBUTING.md`. Este WP onboarding debe **complementar, no duplicar**. Decisión: contenido de "cómo arrancar el proyecto IACT como dev" vive en `source/onboarding/`; el "cómo construir las docs" queda en readme.rst raíz / CONTRIBUTING.md. |

## Acceptance criteria

- ✅ 3 archivos skeleton (mínimo): `index.rst`, `overview.rst`,
  `conventions.rst`. Más probable estructura interna:
  `quickstart.rst`, `local-development-setup.rst`,
  `first-contribution.rst`.
- ✅ `overview.rst`: ruta del onboarding (5 minutos → 1 día → 1
  semana). SIN tutoriales detallados aún.
- ✅ Versión 1.0.0.

## Alcance

**In-scope:** Skeleton de onboarding del producto IACT.

**Out-of-scope:** Onboarding del repo de docs (eso es
bootstrap-hardening + readme.rst).

## Estado

**Borrador (no iniciado).** Spawneado por T-020.

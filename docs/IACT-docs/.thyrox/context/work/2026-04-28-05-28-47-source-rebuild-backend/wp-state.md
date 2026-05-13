```yml
project: IACT-docs
work_package: 2026-04-28-05-28-47-source-rebuild-backend
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #8 of 16 (first tech-skeleton)
created_at: 2026-04-28 05:28:47
current_phase: Phase 11 — TRACK (CERRADO v1)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO v1 — 2026-04-29 (estructura minima creada en source/backend/, commit 9502009)
```

# WP-hijo #8 — Source Rebuild: backend (DRF)

## Propósito

Crear cajón nuevo `source/backend/` para Django REST Framework con
estructura **mínima skeleton-first** (Decision 12): exactamente 3
archivos (`index.rst` + `overview.rst` + `conventions.rst`). Sin
documentar código (Decision 12 — código se documenta cuando exista).

## Capa

**Tech (skeleton-first)** (capa 2).

## Pre-condiciones — HARD

- **H5:** WP #7 `source-rebuild-arquitectura-tecnica` cerrado —
  architecture overview disponible para referencia.
- **H4:** WP `bootstrap-hardening` (externo) tiene F-NEW-8
  resuelto — `.thyrox/guidelines/backend-django.instructions.md`
  activo (no `backend-nodejs`).

## Decisiones del padre que aplican

- **Idea 9 (skeleton-first).**
- **Decision 9 (cajón propio para tech).**
- **Decision 10 (re-autoría con v1.0.0 fresh).**
- **Decision 12 (mínima inicial: 3 archivos).**

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Inventario de ADRs DRF dispersos** | source/normativa/gobernanza/ADR-DEVOPS-001-vagrant-mod-wsgi-IMPORTANTE-PRODUC.rst y otros relevantes. Re-autorearse en `backend/decisions/` o referenciados desde `overview.rst`. |
| **Inventario en temp-holding/** | Buscar contenido de DRF/Django ya documentado. |
| **Verificar tech-skill activo** | `.thyrox/guidelines/backend-django.instructions.md` debe existir y `backend-nodejs.instructions.md` desactivado (consecuencia de bootstrap-hardening F-NEW-8). |

## Acceptance criteria (de plan padre §"Tech-skeleton WPs")

- ✅ Existen exactamente 3 archivos: `index.rst`, `overview.rst`,
  `conventions.rst`.
- ✅ `overview.rst`: alcance, contexto DRF (settings, apps,
  middleware, urls), decisiones high-level. SIN código.
- ✅ `conventions.rst`: convenciones DRF basadas en STDs del WP #2
  + ADRs relevantes (PEP 8, viewsets vs APIView, serializers,
  permisos, paginación, errors).
- ✅ Versión inicial 1.0.0 en metadata.

## Alcance

**In-scope:** 3 archivos skeleton, refs a architecture_tecnica/.

**Out-of-scope:** Documentar endpoints, modelos, migrations, código
DRF concreto. Eso es sub-WP futuro (`source-rebuild-backend-api`,
etc.) cuando exista código a documentar.

## Estado

**Borrador (no iniciado).** Spawneado por T-015.

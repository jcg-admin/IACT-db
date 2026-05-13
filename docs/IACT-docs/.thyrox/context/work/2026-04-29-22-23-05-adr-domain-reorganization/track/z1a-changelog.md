```yml
created_at: 2026-04-29 22:55:00
project: IACT-docs
work_package: 2026-04-29-22-23-05-adr-domain-reorganization
phase: Phase 11 — TRACK
author: NestorMonroy
status: Cerrado
version: 1.0.0
```

# Z.1.A Changelog — ADR Domain Reorganization

## Resumen

Sub-WP del programa `modelo-rbac-improvement`. Implementa la
decisión D-06 Interpretación A.3: ADRs viven en el directorio
de su módulo de dominio, no en cajón centralizado.

## Métricas

| Métrica | Valor |
|---------|------:|
| Archivos movidos via git mv | **12** |
| Refs `:doc:` cascading rotas | **0** (verificado pre-move) |
| Directorios nuevos creados | **1** (`source/devops/`) |
| Toctrees actualizados | **5** (gobernanza, backend, frontend, quality, devops nuevo) |
| `source/index.rst` actualizado | DevOps agregado al toctree raíz |
| STD-007 v2.0.2 §4 actualizado | Convención de ubicación documentada |
| Build cold rebuild | **verde 0/0/0** con `SPHINX_NITPICKY=1` |
| Tiempo total | ~30 min |

## Added

- `source/devops/` (directorio nuevo).
- `source/devops/index.rst` (entry-point).
- Toctree DevOps en `source/index.rst`.
- Toctrees ADRs por módulo en `backend/`, `frontend/`, `quality/`,
  `devops/`.
- STD-007 v2.0.2 §4 nueva sub-tabla "Ubicación física de los
  ADRs por módulo" documentando la convención.

## Changed

- 12 ADRs movidos via `git mv`:
  - 4 `adr-back-*` → `source/backend/`
  - 5 `adr-front-*` → `source/frontend/`
  - 1 `adr-qa-*` → `source/quality/`
  - 2 `adr-devops-*` → `source/devops/`
- `source/normativa/gobernanza/index.rst`:
  - Removidos los 4 toctrees de ADRs no-gob (back, front, devops, qa).
  - Reescrito el listado introductorio con refs `:doc:` a los index
    de cada módulo destino.
  - Solo conserva el toctree de adr-gob-* (8 archivos).

## Removed

- 0 archivos eliminados (preservación total — solo re-ubicación).

## Status de promoción a CHANGELOG.md raíz

Pendiente del próximo merge a `main` con bump de versión:

- **Reorganización ADRs por dominio:** los `adr-MOD-*` ahora viven
  en `source/<modulo>/` siguiendo el principio de organización-por-
  dominio (ADR-GOB-001). 12 archivos movidos, 0 refs rotas.

## Lecciones aprendidas

1. **Cero `:doc:` refs entrantes** = move barato. La verificación
   `grep -rln ":doc:.*$prefix"` antes de mover predijo correctamente
   el costo (0 cascading refs). Sin esa verificación, hubiéramos
   asumido scope alto.

2. **`git mv` preserva contenido** — los `:ref:` labels viajan
   con el archivo. NO requirió actualización de labels.

3. **Toctrees son el único refresh requerido** cuando movemos
   archivos sin cambiar nombre. Sphinx resuelve refs por basename
   no por path completo (en muchos casos).

4. **Mode B partitioned** demostró su valor: Z.1.A cerró rápido
   y limpio (~30 min, 12 commits-equivalent en 1 commit lógico)
   sin tocar Z.1. Z.1 ahora resume con corpus reorganizado.

## Commits Z.1.A

(Pendientes de commit final tras este changelog)

## Implicación para Z.1

Z.1 (sub-WP padre paused en Phase 5 STRATEGY) ahora puede resumir
con:

- ADR-BACK-005 middleware se importará a `source/backend/`
  (ya alineado con A.3).
- adr-back-006 (nuevo técnico) se creará en `source/backend/`.
- adr-gob-009 (nuevo conceptual) se creará en
  `source/normativa/gobernanza/` (gob queda).
- adr-back-001..004 (legacy a supersede) ya están en
  `source/backend/` — el superseding se hace ahí.

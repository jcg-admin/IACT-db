# IACT-docs — Roadmap

> Trayectoria de iniciativas (ÉPICAs) del proyecto. Cada ÉPICA = 1 work package en `.thyrox/context/work/`.

## En curso

| ÉPICA | WP | Branch | Estado |
|-------|----|--------|--------|
| 4 | 2026-04-27-04-20-01-repository-diagnostics | feature/repository-diagnostics | Phase 11 TRACK (docs cerradas, pendiente CLOSURE-NOTICE) |
| 5 | 2026-04-27-05-26-20-zero-warnings-build | feature/repository-diagnostics | Phase 11 TRACK (docs cerradas, pendiente CLOSURE-NOTICE) |
| 6 | 2026-04-27-23-28-26-deployment-pipeline | feature/repository-diagnostics | Phase 10 EXECUTE (parcial — bloqueado por refs muertas) |
| 7 | 2026-04-28-00-19-57-source-references-audit | feature/repository-diagnostics | Phase 1 DISCOVER (audit-only, no fixes) |
| 9 | 2026-04-28-03-59-01-bootstrap-hardening | feature/solve-problem-docs | Phase 1 DISCOVER (Makefile guard + venv fix commiteados; F-NEW-8 + F-NEW-9 pendientes) |
| 10 | 2026-04-28-05-07-32-multi-wp-state-strategy | feature/solve-problem-docs | Phase 1 DISCOVER (creado, pausado — análisis preliminar heredado de ÉPICA 8) |
| — | 16 WPs-hijos `source-rebuild-*` (de ÉPICA 8) | feature/solve-problem-docs | 14 CERRADO v1 (skeleton/amplia) + 2 DIFERIDO (#10 infrastructure, #12 operations). Ver `track/children-status-summary.md` del padre |

## Completadas

| ÉPICA | WP | Cierre | Highlights |
|-------|----|--------|------------|
| 12 | 2026-04-29-05-51-27-methodology-recalibration | 2026-04-29 | Meta-WP post-saneamiento. Deep-review adversarial revelo over-engineering en propuesta I-017. Relocalizado I-016 a references/ lazy-load. Sesgo "realismo performativo metodologico" documentado |
| 11 | 2026-04-29-05-35-11-md-to-rst-saneamiento | 2026-04-29 | Saneamiento masivo md→rst del corpus `source/`. 19222 issues → 0 (build succeeded, 0 WARN/ERR/CRIT) en 11 batches. 9 scripts archivados como canalizacion post-conversion para reuso futuro |
| 8 | 2026-04-28-01-58-08-source-rebuild-strategy | 2026-04-28 | Strategy v2.0 con 3-dimension architecture; 14 Decisions; 16 WPs-hijos spawneados; 5 análisis de soporte. Ver `CLOSURE-NOTICE.md`. |
| 3 | 2026-04-26-02-39-17-git-workflow-documentation | 2026-04-26 | Convención feature/* + merge develop→main + git hooks + audit trail |
| 2 | 2026-04-23-18-51-33-plantuml-java-integration-impl | 2026-04-25 | PlantUML + Java integration, color system, central styles, 13 tareas |
| 1 | 2026-04-22-21-15-30-phase1-discover-iact-docs | 2026-04-22 | Phase 1 DISCOVER inicial del proyecto |

## Archivadas

| ÉPICA | WP | Archivado | Razón |
|-------|----|-----------|-------|
| — | 2026-04-25-04-44-30-monitor-behavior-analysis | 2026-04-27 | Sin actividad desde 2026-04-25; superseded por trabajo posterior. Ver `ARCHIVED.md`. |
| — | 2026-04-26-00-59-49-github-actions-phase2-testing | 2026-04-28 | Bloqueador conceptualmente roto (no existe rama `main`); CI actual (`validate.yml`) cubre el caso de uso original; supersedido por `bootstrap-hardening` WP. Ver `ARCHIVED.md`. |

> Las entradas archivadas se conservan como referencia. Si se decide retomar
> el trabajo en el futuro, abrir un WP nuevo con timestamp actual y referenciar
> los artefactos archivados como insumo de Phase 1 DISCOVER.

## Convenciones

- Branch por ÉPICA: `feature/{nombre-corto}` (ver `git-workflow-documentation` WP).
- Cada ÉPICA atraviesa hasta 12 stages THYROX (ver `.claude/skills/thyrox/SKILL.md`).
- Cierre de ÉPICA = `track/` + `CLOSURE-NOTICE.md` o `ARCHIVED.md` + entrada en CHANGELOG.md si hay bump de versión.

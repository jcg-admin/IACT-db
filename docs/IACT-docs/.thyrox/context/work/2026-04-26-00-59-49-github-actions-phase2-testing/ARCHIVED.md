```yml
project: IACT-docs
work_package: 2026-04-26-00-59-49-github-actions-phase2-testing
archived_at: 2026-04-28 05:01:10
archived_by: NestorMonroy
archive_reason: Bloqueador conceptualmente roto (no existe rama main); CI actual cubre el caso de uso original; supersedido por validate.yml + ÉPICA 8 source-rebuild-strategy
status: ARCHIVED
```

# ARCHIVED — github-actions-phase2-testing

**Archivado retroactivo** registrado durante revisión de ROADMAP en
ÉPICA 8 (source-rebuild-strategy, 2026-04-28).

## Estado al archivar

- `WP-STATE-FUTURE.md` ✓ (status: PENDING — awaiting Phase 1 merge to main)
- `github-actions-phase2-testing-risk-register.md` ✓ (5 risks)
- `plan-execution/` ✓ (8 tareas T-001..T-008 listas para ejecutar)
- Sin `wp-state.md` formal (solo el FUTURE), sin `track/`, sin
  `discover/`, sin ejecución.

## Razón del archivado

El bloqueador documentado en `WP-STATE-FUTURE.md` está **roto
conceptualmente**:

- **"Phase 1 WP must be MERGED to main branch"** — pero en este repo
  **no existe rama `main`**. La convención de ramas (formalizada en
  ÉPICA 3 `git-workflow-documentation`, 2026-04-26 — DESPUÉS de la
  creación de este WP) usa `develop` como integración + `feature/*`.
- **Phase 1 (`github-actions-setup`) YA está completa** — alcanzó
  Phase 12 STANDARDIZE: commits `3638fd5` (Phase 11), `1307c16`
  (Phase 12), `e237987` (cierre de sesión). Por lo tanto el
  pre-requisito de "Phase 1 lista" se cumple.
- El propósito del WP era extender CI con tests adicionales.
  **El CI actual** (`.github/workflows/validate.yml`) ya cubre el
  caso de uso central:
  - `bash scripts/setup.sh` (bootstrap)
  - `make clean` + `sphinx-build -W` (warnings as errors)
  - `validate-plantuml.sh`
  - artifact upload para PR preview
  Las 8 tareas planeadas (T-001..T-008) probablemente son redundantes
  o requieren replanteo a la luz del CI maduro.
- Adicionalmente, ÉPICA 8 (`source-rebuild-strategy`) introduce el
  WP `bootstrap-hardening` que cubre mejoras al pipeline de CI desde
  un ángulo más actualizado.

## Decisión

Archivar (no eliminar) — el contenido es referencia válida si en el
futuro se decide ampliar CI con tests específicos. Los 8 task plans
(`plan-execution/`) y el risk register quedan disponibles como
insumo para un nuevo WP que parta de Phase 1 DISCOVER con el flow
actual.

## Si se reanuda en el futuro

- Abrir un WP nuevo con timestamp actual.
- Phase 1 DISCOVER del nuevo WP debe:
  - Comparar las 8 tareas planeadas vs. lo que ya hace
    `validate.yml` (eliminar redundantes).
  - Re-evaluar el risk register con CI actual.
  - Reframe del bloqueador en términos de ramas reales del repo
    (`develop`, no `main`).

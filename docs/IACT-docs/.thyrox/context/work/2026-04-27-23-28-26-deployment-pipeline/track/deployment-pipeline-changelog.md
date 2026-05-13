```yml
created_at: 2026-04-27 23:28:26
updated_at: 2026-04-28 00:15:00
project: IACT-docs
work_package: 2026-04-27-23-28-26-deployment-pipeline
phase: Phase 11 — TRACK/EVALUATE (parcial — pendiente T-009/T-010)
author: NestorMonroy
status: Borrador
```

# WP Changelog — deployment-pipeline

> Registro del WP "Pipeline de Entrega de Documentación a Producción".
> Política dos-niveles: este archivo se actualiza durante el WP;
> CHANGELOG.md raíz solo en merge a main con bump de versión.

## Estado

| Phase | Status |
|-------|--------|
| 1 DISCOVER | ✅ |
| 3 ANALYZE | ✅ scope refinado |
| 5 STRATEGY | ✅ D1-D7 aprobadas |
| 8 PLAN EXECUTION | ✅ task-plan T-001..T-013 |
| 10 EXECUTE | ✅ T-001..T-008, T-012, T-013 implementados; T-009/T-010 pendientes (requieren acción humana post-merge) |
| 11 TRACK | parcial (este doc) |

## Added

### GitHub Actions workflows

- `.github/workflows/validate.yml` — workflow estricto que reemplaza el
  legacy ``sphinx-build.yml``. Triggers: PR a develop/main, push a
  feature/**, develop, main. Bootstrap completo (uv + libenchant +
  plantuml.jar bundled vía ``scripts/setup.sh``). Ejecuta
  ``sphinx-build -W`` (warnings as errors) + ``validate-plantuml.sh``.
  En PRs sube el HTML como artifact (retención 14 días).
- `.github/workflows/release.yml` — workflow de empaquetado y
  publicación. Trigger: ``push: tags: ['v*']``. Empaqueta
  ``iact-docs-${TAG}.tar.gz`` con HTML + LICENSE + readme + CHANGELOG.
  Genera SHA-256 como asset. Publica GitHub Release con
  ``softprops/action-gh-release@v2`` con release notes auto-generadas.
- `.github/workflows/dependabot-auto-merge.yml` — auto-merge de PRs de
  dependabot que sean ``patch`` o ``minor`` y pasen CI. ``major`` queda
  con comentario solicitando review humano.

### Procedimiento operacional

- `source/normativa/procedimientos/PROC-OPS-001-deployment.rst` —
  procedimiento para la rotación de operación: descargar release,
  verificar SHA-256, backup, despliegue al servidor on-premise,
  validación, rollback. Incluido en el toctree de procedimientos.

### Documentación del WP

- `discover/deployment-pipeline-analysis.md` (Phase 1)
- `deployment-pipeline-risk-register.md` (10 riesgos R-01..R-10)
- `analyze/deployment-pipeline-diagnose.md` (Phase 3 — scope refinado)
- `strategy/deployment-pipeline-solution-strategy.md` (Phase 5 —
  decisiones D1-D7 aprobadas)
- `plan-execution/deployment-pipeline-task-plan.md` (Phase 8 —
  task-plan T-001..T-011 + AC1..AC9)

## Changed

### Configuración dependabot

- `.github/dependabot.yml` reescrita:
  - Frecuencia: ``weekly`` → ``monthly`` (menos PRs por unidad de tiempo)
  - Open PRs limit: 5 → 3
  - Agregado ``include: scope`` en commit-message
  - Agregados ``labels``, ``reviewers``, ``assignees``
  - **Groups configurados** para reducir PRs ruidosas:
    - ``sphinx-ecosystem`` agrupa Sphinx, sphinx-*, sphinxcontrib-*,
      myst-parser, Furo, autodocsumm
    - ``build-tools`` agrupa uv, pip, setuptools, wheel
    - ``patches`` agrupa todo update tipo patch
  - Agregado ``package-ecosystem: github-actions`` para mantener
    ``actions/checkout``, ``setup-python`` etc. al día (también monthly,
    grupo único, limit 2)

### Versión del proyecto

- `pyproject.toml`: ``version = "1.0.0"`` → ``version = "1.1.0"``
  Bump MINOR por funcionalidad nueva backwards-compatible (pipeline,
  zero-warnings achievement, CNST_012, governance updates).

### Procedimientos

- `source/normativa/procedimientos/index.rst` — agregado
  ``PROC-OPS-001-deployment`` al toctree.

## Removed

- `.github/workflows/sphinx-build.yml` — workflow legacy que solo
  validaba en push a main, sin ``-W``, sin link checker, sin plantuml
  validator. Reemplazado completamente por ``validate.yml``.

## Decisiones aprobadas (de Phase 5 STRATEGY)

| ID | Decisión |
|----|----------|
| D1 | Tag manual (no semantic-release) |
| D2 | Primer release: v1.1.0 |
| D3 | Paquete: HTML + LICENSE + readme + CHANGELOG |
| D4 | SHA-256 adjunto |
| D5 | Release notes auto-generadas |
| D6 | validate.yml también en push a main (sin liberar) |
| D7 | Sin auto-cleanup de releases viejos |

## Pendiente (post-merge a main)

- **T-009 [HUMANO]** Crear PR ``feature/repository-diagnostics →
  develop`` y luego ``develop → main``. Mergear ambos. En main:
  ``git tag -a v1.1.0 -m "Release v1.1.0" && git push origin v1.1.0``.

- **T-010 [VERIFICAR]** Confirmar que ``release.yml`` corre tras el
  push del tag y produce:
  - GitHub Release ``v1.1.0`` con asset ``iact-docs-v1.1.0.tar.gz``.
  - Asset ``iact-docs-v1.1.0.tar.gz.sha256``.
  - Release notes auto-generadas.

- **T-011** Tras T-010 OK:
  - Actualizar este changelog con resultado.
  - Crear ``track/deployment-pipeline-lessons-learned.md``.
  - Crear ``CLOSURE-NOTICE.md`` para los 3 WPs simultáneamente
    (repository-diagnostics, zero-warnings-build, deployment-pipeline).

- **POST-CIERRE** Limpieza histórica de ``build/`` con ``git filter-repo``
  y force-push. Bloqueado hasta tener el primer release válido.

## Limpieza pendiente — branches dependabot huérfanas

5 branches dependabot acumuladas en remote (config previa permitía 5
PRs simultáneas y nunca se cerraban). Borrarlas requiere acción humana:

```bash
gh pr list --author "dependabot[bot]" --state open
# revisar y cerrar las que ya no aplican:
gh pr close <number>
# o eliminar branch directamente:
git push origin --delete dependabot/pip/anyio-4.13.0
git push origin --delete dependabot/pip/click-8.3.3
git push origin --delete dependabot/pip/ruamel-yaml-0.19.1
git push origin --delete dependabot/pip/sphinx-autodoc-typehints-3.6.1
git push origin --delete dependabot/pip/sphinx-tabs-3.5.0
```

Adicionalmente, habilitar en GitHub:
``Settings → General → Pull Requests → ☑ Automatically delete head branches``

## Verificación

```bash
$ source .venv/bin/activate
$ make clean && sphinx-build -W -b html -d build/doctrees source build/html
build succeeded.
$ echo $?
0
```

PROC-OPS-001 incluido en el build sin warnings.

## Status de promoción a CHANGELOG.md raíz

Pendiente de merge ``feature/repository-diagnostics → develop → main``
con tag ``v1.1.0``. Cuando ocurra:

- Crear sección ``## [1.1.0] — YYYY-MM-DD`` en CHANGELOG.md raíz.
- Promover entradas relevantes de los 3 WP-changelogs:
  - repository-diagnostics (15 hallazgos, governance)
  - zero-warnings-build (479 → 0 issues)
  - deployment-pipeline (este WP)

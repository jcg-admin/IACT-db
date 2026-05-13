```yml
created_at: 2026-04-27 23:49:52
project: IACT-docs
work_package: 2026-04-27-23-28-26-deployment-pipeline
phase: Phase 8 — PLAN EXECUTION
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Phase 8 PLAN EXECUTION — Task Plan

## DAG (orden de ejecución)

```
T-001 (validate.yml) ──┐
T-002 (remove old)   ──┼──► T-007 (syntax-check) ──► T-008 (commit/push)
T-003 (release.yml)  ──┘                                       │
                                                               │
T-004 (PROC-OPS-001) ────────────────────────────────────────►─┤
T-005 (bump version) ────────────────────────────────────────►─┤
T-006 (WP changelog) ────────────────────────────────────────►─┘
                                                               │
                                              ─── (post-merge a main por humano) ───
                                                               │
                                                               ▼
                                                  T-009 (tag v1.1.0)
                                                               │
                                                               ▼
                                                  T-010 (verificar release)
                                                               │
                                                               ▼
                                                  T-011 (lessons + closure)
```

## Tareas atómicas

- [ ] **T-001** Crear `.github/workflows/validate.yml` con triggers
      `pull_request: [develop, main]` + `push: ['feature/**', develop, main]`.
      Steps: setup uv + libenchant + plantuml.jar bundled, `sphinx-build -W`,
      `sphinx-build -b linkcheck`, `bash scripts/validate-plantuml.sh`.

- [ ] **T-002** Eliminar `.github/workflows/sphinx-build.yml` (legacy,
      reemplazado por validate.yml).

- [ ] **T-003** Crear `.github/workflows/release.yml` con trigger
      `push: tags: ['v*']`. Steps: setup, `sphinx-build -W`, empaquetar
      `iact-docs-${TAG}.tar.gz` con HTML + LICENSE + readme + CHANGELOG,
      generar SHA-256, publicar Release con `softprops/action-gh-release@v2`,
      adjuntar `.tar.gz` + `.sha256`, release notes auto-generadas.

- [ ] **T-004** Crear `source/normativa/procedimientos/PROC-OPS-001-deployment.rst`:
      procedimiento para la rotación de operación. Cubre: cómo descargar el
      release, verificar SHA-256, desempaquetar, desplegar al servidor on-premise,
      validar, rollback (descarga de versión previa). Sin URLs/hostnames específicos.

- [ ] **T-005** Bump `pyproject.toml`: `version = "1.0.0"` → `version = "1.1.0"`.

- [ ] **T-006** Actualizar `WP-changelog` del WP deployment-pipeline registrando
      todos los cambios anteriores. (Crear `track/deployment-pipeline-changelog.md`).

- [ ] **T-007** Validar sintaxis YAML de los 2 workflows con `python -c "import yaml; yaml.safe_load(open(...))"`.
      Build local final con `make clean && sphinx-build -W` (incluye PROC-OPS-001).

- [ ] **T-008** Commit en bloque (T-001..T-007) con Tim Pope body explicativo.
      Push a `feature/repository-diagnostics`.

### Bloque post-merge (requiere acción humana)

- [ ] **T-009** [HUMANO] Crear PR `feature/repository-diagnostics → develop`,
      mergear; luego PR `develop → main`, mergear. Crear tag con:
      ```
      git checkout main && git pull
      git tag -a v1.1.0 -m "Release v1.1.0 — pipeline + zero-warnings + CNST_012"
      git push origin v1.1.0
      ```

- [ ] **T-010** [VERIFICAR] El workflow `release.yml` corre tras el push del tag.
      GitHub Release `v1.1.0` aparece con:
      - `iact-docs-v1.1.0.tar.gz` adjunto (~25 MB esperado)
      - `iact-docs-v1.1.0.tar.gz.sha256`
      - Release notes auto-generadas (commits del WP)

- [ ] **T-011** Documentar resultado: actualizar `track/deployment-pipeline-changelog.md`,
      crear `track/deployment-pipeline-lessons-learned.md`, crear `CLOSURE-NOTICE.md`.
      Cierre simultáneo de los 3 WPs (`repository-diagnostics`, `zero-warnings-build`,
      `deployment-pipeline`) con sus respectivos `CLOSURE-NOTICE.md`.

## Criterios de aceptación globales

| # | Criterio | Verificación |
|---|----------|--------------|
| AC1 | `validate.yml` corre en cada PR y push a feature/develop/main | Visible en Actions tab |
| AC2 | `validate.yml` falla si hay cualquier warning de sphinx | `sphinx-build -W` exit ≠ 0 → workflow rojo |
| AC3 | `release.yml` corre solo en push de tag `v*` | Visible en Actions tab |
| AC4 | El `.tar.gz` contiene HTML + LICENSE + readme + CHANGELOG | Descargar y verificar contenido |
| AC5 | El `.sha256` matchea el `.tar.gz` | `sha256sum -c` en local |
| AC6 | Release notes incluyen commits desde tag previo | Visible en GitHub Release page |
| AC7 | PROC-OPS-001 documenta el procedimiento de descarga | Archivo presente, validado por sphinx -W |
| AC8 | `pyproject.toml` declara `version = "1.1.0"` | `grep version pyproject.toml` |
| AC9 | `make clean && sphinx-build -W` exit 0 (build local) | Pre-tag validation |

## Notas de implementación

- Todos los workflows usan `actions/checkout@v4`, `actions/setup-python@v5`.
- Para `softprops/action-gh-release@v2` se requiere `permissions: contents: write` en el job.
- El plantuml.jar se descarga via `bash scripts/setup.sh` (ya implementado en F-15).
- libenchant se instala via `apt-get install libenchant-2-2` en el runner Ubuntu.
- Para el smoke test de validate-plantuml.sh: ya existe en `scripts/`.

## Riesgos del plan

- **R-T-009** El humano olvida crear el tag → el pipeline nunca dispara.
  Mitigación: documentar en PROC-OPS-001 y mencionarlo en lessons-learned.
- **R-T-010** El primer release falla por permisos faltantes en el repo
  (`contents: write`). Mitigación: T-007 valida YAML pero no permisos —
  si T-010 falla, agregar `permissions: contents: write` al job.

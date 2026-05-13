```yml
created_at: 2026-04-27 23:46:43
project: IACT-docs
work_package: 2026-04-27-23-28-26-deployment-pipeline
phase: Phase 5 — STRATEGY
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Phase 5 STRATEGY — Deployment Pipeline (decisiones aprobadas)

## Contexto

Después del recorte de scope en Phase 3 ANALYZE (el ejecutor confirmó que
el WP termina en el empaquetado versionado, sin tocar servidores), las 7
decisiones técnicas D1-D7 fueron presentadas como recomendaciones y
**aprobadas por el ejecutor** en la conversación 27-abr 23:45.

Este documento las consolida como decisiones aprobadas y bloqueadas, lista
para Phase 8 PLAN EXECUTION.

## Decisiones aprobadas

### D1 — Creación del tag `v*`

**Decisión:** **Manual** — `git tag v{X.Y.Z} && git push origin v{X.Y.Z}`.

**Justificación:** mantiene consistencia con el commit-style Tim Pope ya
adoptado, sin agregar dependencias (semantic-release, bots). El operador
decide explícitamente cuándo cortar release. Migración a workflow_dispatch
o semantic-release queda diferida hasta que se valide el flujo manual.

### D2 — Versión del primer release

**Decisión:** **`v1.1.0`**.

**Justificación:**
- `pyproject.toml` declara `version = "1.0.0"` ya en `main`.
- El branch `feature/repository-diagnostics` agrega: setup script, hooks,
  CNST_012 (RBAC consolidado), zero-warnings achievement, ROADMAP/CHANGELOG,
  plugin manifest, política Tim Pope + dual-changelog, deployment pipeline.
- Eso es **bump MINOR** (funcionalidad nueva backwards-compatible), no
  PATCH (que sería solo bug fixes) ni MAJOR (que requeriría breaking
  change documentado).
- SemVer 2.0.0: `1.0.0 → 1.1.0`.

### D3 — Contenido del paquete `iact-docs-v{X.Y.Z}.tar.gz`

**Decisión:** **HTML completo + LICENSE + readme.rst + CHANGELOG.md**.

Estructura:

```
iact-docs-v1.1.0.tar.gz
├── html/                    ← contenido de build/html/
│   ├── index.html
│   ├── _static/
│   ├── _images/
│   └── (resto del HTML build)
├── LICENSE                  ← desde licence.rst rendered o como text
├── readme.rst               ← copia del root
└── CHANGELOG.md             ← copia del root
```

**Justificación:** el operador que despliega ve qué versión es y qué
cambió sin necesitar acceso al repo.

### D4 — Checksum

**Decisión:** **SHA-256 publicado como asset adjunto** —
`iact-docs-v{X.Y.Z}.tar.gz.sha256`.

Comando del workflow:
```bash
sha256sum iact-docs-v${TAG}.tar.gz > iact-docs-v${TAG}.tar.gz.sha256
```

**Justificación:** permite al operador verificar integridad sin re-clonar.
GitHub también provee checksums automáticos pero adjuntar el `.sha256` es
estándar y explícito.

### D5 — Release notes

**Decisión:** **Auto-generadas por GitHub** (commits desde el tag previo)
usando `softprops/action-gh-release@v2` con `generate_release_notes: true`.

**Justificación:** los commits Tim Pope ya tienen body explicativo; la
auto-generación de GitHub los lista en el release sin trabajo adicional.
Si el output no satisface, migrar a opción B (custom desde CHANGELOG.md
raíz) en un WP posterior.

### D6 — Validación en push directo a `main`

**Decisión:** **`validate.yml` corre también en `push: [main]`**, sin
disparar el release.

Triggers finales:

| Workflow | Triggers |
|----------|----------|
| `validate.yml` | `pull_request: [develop, main]`, `push: ['feature/**', develop, main]` |
| `release.yml` | `push: tags: ['v*']` |

**Justificación:** alguien podría pushear directo a `main` saltándose el
flujo `feature/* → develop → main`. Si pasa, igual queremos que se
valide. La separación garantiza que solo el push de tag libera.

### D7 — Releases viejos / rollback

**Decisión:** **Conservar todos los releases en GitHub**. No hay
auto-cleanup. El rollback es: el operador descarga la versión anterior
y la despliega.

**Justificación:** GitHub no impone límite práctico; cada release pesa
~25-30 MB, retener 100 releases ≈ 3 GB en assets, manejable. Trazabilidad
completa garantizada.

## Diseño final del pipeline (resumen)

```
┌──────────────────────────────────────────────────────────────┐
│ feature/xxx → push ─┐                                         │
│ develop → push    ──┼─► validate.yml ──► PASS o BLOQUEA       │
│ main → push       ──┤    (sphinx -W, linkcheck, plantuml)     │
│ PR → [develop,main]─┘                                         │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│ git tag v1.1.0                                                │
│ git push origin v1.1.0                                        │
│              │                                                │
│              ▼                                                │
│       release.yml                                             │
│       ├── setup (uv sync + libenchant)                        │
│       ├── make clean && sphinx-build -W                       │
│       ├── empaquetar HTML + LICENSE + readme + CHANGELOG      │
│       ├── sha256sum                                           │
│       └── softprops/action-gh-release                         │
│              │                                                │
│              ▼                                                │
│   GitHub Release v1.1.0 con:                                  │
│   - iact-docs-v1.1.0.tar.gz                                   │
│   - iact-docs-v1.1.0.tar.gz.sha256                            │
│   - Release notes auto-generadas                              │
└──────────────────────────────────────────────────────────────┘
              │
              ▼
   [Operador (rotación) descarga el .tar.gz]
   [Verifica sha256]
   [Despliega a su servidor — fuera del WP]
```

## Riesgos residuales aceptados

- **R-01** (deploy contenido roto) — mitigado por `-W` en validate.yml
  + linkcheck. No 100%: warnings de extensiones third-party podrían
  aparecer; se manejan caso por caso si surgen.
- **R-06** (eliminar build/ histórico antes del pipeline) — sigue
  bloqueado: el primer release v1.1.0 es la condición previa para
  ejecutar `git filter-repo` sobre `build/`.
- **R-07** (push directo a main libera) — mitigado por separación de
  triggers; solo tag `v*` libera.
- **R-09** (proceso post-release fuera del WP) — aceptado por scope.

## Restricción de orden global

Esta es la única restricción de orden global pendiente del proyecto:

```
Phase 10 EXECUTE de este WP termina con primer release v1.1.0
                                  │
                                  ▼
              ENTONCES (no antes):
              git filter-repo --path build --invert-paths
                                  │
                                  ▼
              git push --force-with-lease origin <branch>
                                  │
                                  ▼
              Cierre de los 3 WPs:
              - repository-diagnostics (CLOSURE-NOTICE)
              - zero-warnings-build (CLOSURE-NOTICE)
              - deployment-pipeline (CLOSURE-NOTICE)
```

## Próximo paso

**Phase 8 PLAN EXECUTION** — descomponer en tareas atómicas T-NNN:

- T-001 Crear `.github/workflows/validate.yml`
- T-002 Eliminar / reemplazar `.github/workflows/sphinx-build.yml`
- T-003 Crear `.github/workflows/release.yml`
- T-004 Crear `source/normativa/procedimientos/PROC-OPS-001-deployment.rst`
- T-005 Bump `pyproject.toml` version a `1.1.0`
- T-006 Actualizar CHANGELOG.md WP-level con entradas del WP
- T-007 Validar workflows en local con `act` (opcional) o syntax check
- T-008 Commit + push los archivos del pipeline
- T-009 (post-merge a main): crear tag `v1.1.0` y push
- T-010 (post-tag): verificar que `release.yml` corre y produce el asset
- T-011 Documentar resultado en lessons-learned + closure notice

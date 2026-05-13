```yml
created_at: 2026-04-27 04:20:01
project: IACT-docs
analysis_version: 1.0
author: NestorMonroy
status: Borrador
```

# Phase 1 DISCOVER — Repository Diagnostics

**WP:** `2026-04-27-04-20-01-repository-diagnostics`
**Rama:** `feature/repository-diagnostics`
**Pregunta:** ¿Qué problemas tiene el repositorio HOY, observados desde el inicio de los agentes?

Diagnóstico **solo lectura**: este WP reporta hallazgos. Las correcciones se planifican en WPs separados según prioridad.

---

## Clasificación de evidencia

Cada hallazgo se etiqueta:
- **OBSERVABLE** — verificado por tool_use en esta sesión
- **INFERRED** — derivado de observables con razonamiento explícito
- **SPECULATIVE** — hipótesis sin observable directo (NO usado para gates)

---

## Hallazgos

### F-01 — `build/` tracked en git contradice `.gitignore` (OBSERVABLE)

- `git ls-files build/ | wc -l` → **1126 archivos** tracked.
- `du -sh build/` → **64 MB** (el directorio más grande del repo, mayor que `.git/` 23 MB y `source/` 4.6 MB).
- `.gitignore` contiene **dos reglas contradictorias**:
  - Línea 2 (comentada): `# build/  (REMOVED: user wants build artifacts tracked for visibility)`
  - Línea final: `build/` (descomentada, en sección "Python packaging")
- También `**/*.doctree` está en gitignore, pero `git ls-files build/ | grep -c .doctree` → **352 .doctree files tracked**.

**Causa:** los archivos fueron commiteados antes de que existiera la regla; la regla nueva no des-trackea retroactivamente. Las dos reglas (comentada vs activa) reflejan una decisión revertida sin limpiar.

**Impacto:** clones lentos, diffs ruidosos, riesgo de merge conflicts por artefactos generados, repo 3× más grande de lo necesario.

### F-02 — `pyproject.toml` referencia `README.md` que no existe (OBSERVABLE)

- `pyproject.toml` línea: `readme = "README.md"`.
- `ls README.md` → no existe. Solo existe `readme.rst` (lowercase, .rst).
- `uv build` o `pip install -e .` fallarán al leer el readme.

### F-03 — `.githooks/` definidos pero no instalados (OBSERVABLE)

- `.githooks/commit-msg` y `.githooks/pre-push` existen y son ejecutables.
- `git config core.hooksPath` → **vacío**. Los hooks NO están activos en este clone.
- Commit reciente `a90d5c5 chore(git-workflow): add git hooks for conventional commit validation and branch protection` los agregó, pero nada los instala automáticamente al clonar.

**Impacto:** la validación de conventional commits y branch protection que el WP `git-workflow-documentation` documentó **no se ejecuta** en clones nuevos sin paso manual.

### F-04 — Entorno Python no inicializado / `make html` roto (OBSERVABLE)

- `make html` → `*** El comando 'sphinx-build' no fue encontrado`.
- `which sphinx-build` → no encontrado.
- `.venv/` no existe.
- `pyproject.toml` declara dependencias (Sphinx>=9.0.4, Furo, etc.) pero no hay sync.
- I-015 (validate-phase-completion.sh) requiere `make html` exit 0 — **bloquea cierre de cualquier WP** hasta resolver.

**Nota:** puede ser estado del worktree actual del agente; igualmente, no hay script de bootstrap (`make install`, `make setup`) en el Makefile o scripts/ que automatice esto.

### F-05 — `now.md` en estado inconsistente (OBSERVABLE)

`now.md` reporta simultáneamente:
- `current_phase: Phase 5 STRATEGY (COMPLETE)`
- `stage: Phase 5 — STRATEGY` / `stage_number: 5`
- `phase_8_decision_gate: "✅ READY FOR PHASE 10 — ..."` (sobre WP plantuml)
- `current_work: 2026-04-26-02-39-17-git-workflow-documentation`
- `next_decision_required: "User approval: proceed to Phase 5 STRATEGY"`
- `last_completed_work: ...iact-project-state-assessment WP (CLOSED 2026-04-26 03:00:00)`

El archivo mezcla estado de **3 WPs distintos** (plantuml-java-integration, git-workflow-documentation, iact-project-state-assessment) sin distinguir cuál está activo. Para un agente cold-boot, esto es ruido que invita a continuar el WP equivocado.

**Recientes commits (`70b309c`, `d6706b9`, `f1c4e5b`)** indican que `git-workflow-documentation` ya pasó por Phase 11 y 12 — pero `now.md` lo lista como activo en Phase 5.

### F-06 — WPs abiertos sin cierre formal (OBSERVABLE)

WPs sin `track/`, sin `CLOSURE-NOTICE.md`, sin `ARCHIVED.md`:

| WP | Último contenido | Estado declarado |
|----|------------------|-------------------|
| `2026-04-25-04-44-30-monitor-behavior-analysis` | strategy/, plan-execution/, execute/ | Sin marcador de cierre |
| `2026-04-26-00-59-49-github-actions-phase2-testing` | solo `WP-STATE-FUTURE.md` + `plan-execution/` | "PENDING (awaiting Phase 1 merge)" |
| `2026-04-26-02-39-17-git-workflow-documentation` | discover/…/standardize/ | Commits indican cierre, pero sin notice file |

I-011 dice: un WP solo se cierra cuando el ejecutor lo ordena explícitamente. Faltan los marcadores que materialicen ese cierre — ambigüedad para el próximo agente.

### F-07 — Falta `ROADMAP.md` y `CHANGELOG.md` en raíz (OBSERVABLE)

- `ls ROADMAP.md CHANGELOG.md` → ambos ausentes.
- CLAUDE.md (sección "Flujo de sesión") obliga a actualizar ROADMAP.md cada fase.
- Tabla de artefactos en SKILL.md menciona `CHANGELOG.md (raíz)` como excepción "actualizar SOLO en releases con bump de versión".
- Versión declarada en `pyproject.toml`: `1.0.0`. No hay tag git `v1.0.0` ni CHANGELOG que justifique esa versión.

### F-08 — Mismatch entre rama esperada por harness y por usuario (OBSERVABLE)

- Branch creado por harness al iniciar: `claude/repository-diagnostics-Gz5jw` (push automático a remote).
- Branch solicitado por el usuario en este WP: `feature/repository-diagnostics`.
- El branch `claude/...-Gz5jw` ya está en remote (`remotes/origin/claude/repository-diagnostics-Gz5jw`).

**Impacto:** existirán dos ramas con trabajo del mismo agente. El instructivo de harness (push a `claude/...`) entra en conflicto con la convención `feature/*` que el WP `git-workflow-documentation` estandarizó. Hay deuda de governance no resuelta.

### F-09 — `scripts/` casi vacío (OBSERVABLE)

- `ls scripts/` → solo `validate-plantuml.sh`.
- No existen scripts de: bootstrap del entorno, regenerar build, validar el WP activo, ejecutar I-015 desde la raíz.
- `.claude/scripts/validate-phase-completion.sh` existe pero no hay wrapper en `scripts/` que lo invoque.

### F-12 — `pyproject.toml` declara constraint imposible para Sphinx (OBSERVABLE)

- `pyproject.toml` declara `Sphinx>=9.0.4` Y `autodocsumm==0.2.14`.
- `autodocsumm==0.2.14` requiere `sphinx>=4.0,<9.0` → conflicto irresoluble.
- `uv sync` falla: `requirements are unsatisfiable`.
- `uv.lock` resuelve a `sphinx==8.2.3` (ignora la spec del pyproject) — el lock está "mintiendo" sobre la declaración.
- Solo `uv sync --frozen` funciona porque salta el solver.

**Causa raíz:** alguien cambió el constraint de Sphinx en pyproject sin actualizar `autodocsumm` ni regenerar el lockfile.

### F-13 — `enchant` (libsystem C) no está en bootstrap (OBSERVABLE)

- `sphinxcontrib-spelling` (en pyproject) requiere libsystem C `enchant` (no es paquete Python).
- Sin `libenchant-2-2` instalado, `make html` falla con `ExtensionError: enchant C library was not found`.
- `scripts/setup.sh` no lo instala automáticamente.
- En este worktree se instaló a mano con `apt-get install libenchant-2-2`.

### F-15 — `plantuml` (binario Java) no está en bootstrap (OBSERVABLE)

- `sphinxcontrib-plantuml` (en pyproject) es solo wrapper Python; requiere el binario `plantuml` (Java) en PATH.
- `source/conf.py:187` declara `plantuml = 'plantuml'` (busca el binario por nombre).
- Sin `plantuml` instalado, `make clean && make html` produce **270+ warnings idénticas** ("plantuml command 'plantuml' cannot be run") y los diagramas `.. uml::` quedan vacíos en el HTML aunque el build "succeed".
- `scripts/setup.sh` original no lo instalaba.
- El WP `2026-04-23-18-51-33-plantuml-java-integration-impl` integró PlantUML al proyecto pero asumió que el binario ya estaba en el sistema.

**Impacto:** documentación arquitectónica (UC, diagramas de secuencia) se publica sin diagramas en clones nuevos.

**Fix aplicado (idempotente, sin sudo en el caso happy):** descarga `plantuml.jar` v1.2024.7 a `tools/plantuml.jar` (gitignored, 22 MB). Wrapper `tools/bin/plantuml` (committeado) invoca `java -jar`. Si Java falta del sistema, `setup.sh` baja JRE portable Adoptium a `tools/jre/`. `conf.py` apunta al wrapper preferentemente, con fallback a `plantuml` en PATH y override via `PLANTUML_BIN`. Verificado: build OK con system plantuml desinstalado, 0 warnings de plantuml.

### F-14 — `requires-python = ">=3.11"` causa resolver failures futuros (INFERRED)

- Sin upper bound, `uv` resuelve dependencias para Python 3.11, 3.12, 3.13, 3.14, 3.15+.
- Para versiones futuras de Python, deps transitivas pueden no tener wheels o no soportar el rango. El resolver fallará intermitentemente con cada release nuevo de Python.
- Anti-patrón documentado en la comunidad uv/PEP 621.

### F-11 — Namespace `/thyrox:*` declarado en CLAUDE.md pero no implementado (OBSERVABLE)

- CLAUDE.md (Locked Decision #5, addendum FASE 31 + ADR-019) declara: "Interfaz pública del sistema → `/thyrox:*` (plugin namespace via `.claude-plugin/plugin.json`)".
- `find . -name "plugin.json"` → **no existe** ningún manifest.
- `.claude/commands/` contiene archivos planos (`discover.md`, `strategy.md`, …) → comandos accesibles como `/discover`, `/strategy` (sin namespace).
- El hook `session-start.sh` recomienda al usuario `/thyrox:strategy` — comando que **falla** porque el namespace `/thyrox:` no está registrado.
- Resultado: la "interfaz pública" definida en ADR-019 está documentada pero no funciona en este repo.

**Causa raíz:** el ADR cerró la decisión pero la implementación (crear el manifest) nunca se ejecutó como tarea.

### F-10 — Profusión de WPs cíclicos sobre el mismo tema (INFERRED desde nombres)

Secuencia de WPs:
- `2026-04-22 phase1-discover-iact-docs`
- `2026-04-25 iact-project-state-assessment`
- `2026-04-25 github-actions-setup`
- `2026-04-26 github-actions-phase2-testing` (PENDING)
- `2026-04-26 git-workflow-documentation`
- `2026-04-27 repository-diagnostics` (este WP)

**Patrón inferido:** auditorías repetidas del estado del proyecto, sin que cada una cierre con un set de cambios estructurales aplicados. Riesgo: WPs de "evaluar el proyecto" se vuelven el trabajo principal en lugar del trabajo entregable.

---

## Resumen ejecutivo

| ID | Hallazgo | Severidad | Tipo | Acción mínima |
|----|----------|-----------|------|---------------|
| F-01 | build/ tracked + gitignore contradictorio | Alta | Higiene git | Decidir: trackear o no, eliminar contradicción |
| F-02 | pyproject.readme apunta a archivo inexistente | Alta | Build broken | Crear README.md o cambiar a readme.rst |
| F-03 | .githooks/ no auto-instalados | Alta | Governance | Bootstrap script o doc en setup |
| F-04 | sphinx-build no disponible, no hay bootstrap | Alta | DX | Documentar `uv sync` + add a Makefile |
| F-05 | now.md mezcla 3 WPs | Alta | Estado de sesión | Reset now.md al WP activo real |
| F-06 | WPs sin marcador de cierre | Media | Governance | Aplicar I-011 (CLOSURE-NOTICE.md o ARCHIVED.md) |
| F-07 | ROADMAP.md / CHANGELOG.md ausentes | Media | THYROX compliance | Crear ambos como bootstrap |
| F-08 | Conflicto rama harness vs feature/* | Media | Governance | Decidir: ignorar harness branch o cambiar política |
| F-09 | scripts/ casi vacío | Baja | DX | Acumular scripts útiles del WP git-workflow |
| F-10 | WPs auto-referenciales repetidos | Media | Proceso | Capear: este WP solo reporta, no inicia más auditorías |
| F-11 | Namespace `/thyrox:*` declarado pero no implementado | Alta | Governance | Crear `.claude-plugin/plugin.json` (ADR-019 pendiente de ejecución) |
| F-12 | pyproject Sphinx>=9 vs autodocsumm<9 — conflicto | Alta | Build broken | `Sphinx>=8.2.3,<9.0` o subir autodocsumm |
| F-13 | enchant libsystem fuera del bootstrap | Alta | Build broken | apt/brew install en setup.sh |
| F-14 | `requires-python = ">=3.11"` sin upper bound | Media | Resolver fragility | Acotar a `<3.14` |
| F-15 | binario `plantuml` (Java) fuera del bootstrap | Alta | Build silent failure | apt/brew install plantuml en setup.sh |

---

## Stakeholders

- **NestorMonroy** — ejecutor humano, decide qué hallazgos se actúan.
- **Próximo agente cold-boot** — víctima principal de F-05 (now.md inconsistente) y F-06 (WPs ambiguos).
- **CI / GitHub Actions** — afectado por F-04 si los workflows usan sphinx-build asumiendo entorno listo.

---

## Síntomas observables

- Repo de 96 MB total, 64 MB en `build/` (66%) — clone lento.
- Cualquier comando que toque `make html` falla en este worktree.
- `now.md` no responde la pregunta "¿qué WP tengo activo?".

---

## Próximo paso recomendado

Phase 5 STRATEGY (mediano-pequeño WP): para cada hallazgo, decidir entre `fix-now` / `track-as-debt` / `accept-and-document`. **No** crear más WPs de auditoría (mitigar R-05 / F-10).

Stage de salida sugerido: este WP termina en Stage 11 TRACK con un changelog que apunta a WPs hijos por hallazgo de severidad Alta.

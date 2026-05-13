```yml
type: Metodología General
category: Convenciones
version: 1.1
purpose: Define convenciones del proyecto: ubicaciones de archivos, nombrado, estructura.
goal: Asegurar consistencia en todo el proyecto.
updated_at: 2026-04-14 20:40:00
```

# THYROX Conventions

## Propósito

Define convenciones del proyecto: ubicaciones de archivos, nombrado, estructura.

> Objetivo: Asegurar consistencia en todo el proyecto.

---

## File Locations

All THYROX workflow files are stored in the THYROX project structure:

```
/project/
├── ROADMAP.md                    Source of truth for progress
├── CHANGELOG.md                  Auto-generated from commits
├── ARCHITECTURE.md               Architectural decisions
├── CONTRIBUTING.md               Contribution guide
│
└── .claude/
    ├── CLAUDE.md                 Persistent context (Level 2)
    ├── context/                  Work produced by framework
    │   ├── project-state.md     Current phase/progress
    │   ├── decisions/           ADRs (adr-NNN.md)
    │   ├── analysis/            Diagnostics and audits (Phase 1, 7)
    │   ├── epics/               Planned work (Phase 3, 4, 5)
    │   └── work-logs/           Session journals (Phase 6)
    │
    └── skills/thyrox/        The SKILL (Level 1)
        ├── SKILL.md             Motor — canonical source
        ├── references/          Documentation loaded on demand
        ├── scripts/             Executable code (detect/convert/validate)
        └── assets/              Templates for output
```

## ROADMAP.md Format

### Structure

```markdown
# ROADMAP - Project Name

**Status:** [Planning / In Development / Beta / Production]
**Current Phase:** Phase N
**Last Updated:** YYYY-MM-DD
**Version:** X.Y.Z

## Progress Conventions

- [ ] = Pendiente (not started)
- [-] = En Progreso (in progress)
- [x] = Completado (YYYY-MM-DD)

## PHASE N: Feature Name

### Feature X
Brief description of what this feature does and why.

**Epic:** context/epics/YYYY-MM-DD-nombre/

- [ ] Subtask 1
- [-] Subtask 2 (started 2025-03-24)
- [x] Subtask 3 (2025-03-24)

**Dependencies:** List what this depends on
**Blocked by:** List what's blocking this

---

## Tabla de Contenidos

- [File Locations](#file-locations)
- [ROADMAP.md Format](#roadmap.md-format)
- [Progress Conventions](#progress-conventions)
- [PHASE N: Feature Name](#phase-n-feature-name)
- [Priority Mapping](#priority-mapping)
- [Traceability IDs](#traceability-ids)
- [Analysis vs Epic](#analysis-vs-epic)
- [Progress Conventions](#progress-conventions)
- [PHASE 1: Estructura Base](#phase-1-estructura-base)
- [PHASE 2: Sub-proyecto API](#phase-2-sub-proyecto-api)
- [PHASE 3: Sub-proyecto Build](#phase-3-sub-proyecto-build)
- [Conventional Commits Format](#conventional-commits-format)
- [Task Management with Claude Code](#task-management-with-claude-code)
- [Progress Tracking](#progress-tracking)
- [Dependency Management](#dependency-management)
- [Blocking and Waiting](#blocking-and-waiting)
- [Architectural Decisions](#architectural-decisions)
- [ADR-001: JWT for Authentication](#adr-001-jwt-for-authentication)
- [ADR-002: Use Stripe for Payments](#adr-002-use-stripe-for-payments)
- [Reference: Change Log Template](#reference-change-log-template)
- [[0.2.0] - 2025-03-28](#[0.2.0]---2025-03-28)
- [[0.1.0] - 2025-03-24](#[0.1.0]---2025-03-24)
- [Common Workflows](#common-workflows)
- [Best Practices](#best-practices)
- [When to Update What](#when-to-update-what)

---


## Priority Mapping

User stories con prioridades se mapean a fases de ejecución:

| Priority | Task Phase | Execution | MVP? |
|----------|-----------|-----------|------|
| P1 | Phase 3 tasks | Primero | Sí |
| P2 | Phase 4 tasks | Segundo | No |
| P3 | Phase 5 tasks | Último | No |

---

## Timestamp Format

Dos formatos según el contexto:

| Contexto | Formato | Ejemplo |
|----------|---------|---------|
| Nombres de directorio / filename | `YYYY-MM-DD-HH-MM-SS` (todo guiones) | `2026-04-07-01-41-49` |
| Valores de metadata en frontmatter | `YYYY-MM-DD HH:MM:SS` (ISO 8601 local) | `2026-04-07 01:41:49` |

**Comandos — OBLIGATORIO ejecutar, nunca inventar:**

```bash
# Para directorios y filenames:
date +%Y-%m-%d-%H-%M-%S          # → 2026-04-07-01-41-49

# Para valores de metadata (created_at, updated_at, etc.):
date '+%Y-%m-%d %H:%M:%S'        # → 2026-04-07 01:41:49
```

NUNCA usar solo `YYYY-MM-DD` — siempre incluir la hora.
NUNCA dejar `[YYYY-MM-DD HH:MM:SS]` como placeholder literal.

---

## Metadata Keys

**Regla:** Keys en inglés snake_case. Valores en español.

```yaml
# Correcto:
type: Análisis
created_at: 2026-04-07 01:41:49

# Incorrecto:
Tipo: Análisis
Fecha creación: 2026-04-07-01-41-49
```

**Nota legacy:** Artefactos en `context/work/` anteriores a 2026-04-07 usan keys
en español. No se migran. Ambos formatos son entendidos por Claude.

### Mapa español → inglés

| Español | Inglés |
|---------|--------|
| `Tipo` | `type` |
| `Categoría` | `category` |
| `Versión` | `version` |
| `Propósito` | `purpose` |
| `Objetivo` | `goal` |
| `Fase` | `phase` |
| `Estado` | `status` |
| `Autor` | `author` |
| `Proyecto` | `project` |
| `Activar si` | `activate_if` |
| `Fecha` / `Fecha creación` | `created_at` |
| `Fecha actualización` / `Última actualización` | `updated_at` |
| `Fecha cierre` | `closed_at` |
| `Fecha inicio` | `started_at` |
| `Fecha fin` | `ended_at` |
| `Fecha inicio prevista` | `planned_start` |
| `Fecha fin prevista` | `planned_end` |
| `Fecha inicio sesión` | `session_started_at` |
| `Fecha fin sesión` | `session_ended_at` |
| `Fecha completación` | `completed_at` |
| `ID work package` | `work_package_id` |
| `Total lecciones` | `total_lessons` |
| `Total tareas` | `total_tasks` |
| `Riesgos abiertos` | `open_risks` |
| `Riesgos cerrados` | `closed_risks` |
| `Responsable` | `owner` |
| `Revisor` | `reviewer` |
| `Aprobado por` | `approved_by` |
| `Severidad` | `severity` |
| `Fase actual` | `current_phase` |
| `Fase de origen` | `source_phase` |

Mapa completo en `scripts/migrate-metadata-keys.py` → `KEY_MAP`.

---

## Nomenclatura de Archivos

### Regla general

Los nombres de archivo deben ser:
- **Auto-explicativos** — el nombre describe el contenido sin abrirlo
- **Sin números secuenciales** — no NNN, no contadores arbitrarios
- **Equilibrados** — 2 a 5 palabras (ni una sola palabra ambigua, ni una frase)
- **kebab-case** — palabras en minúscula separadas por guiones

> **Scope:** aplica a archivos de proyecto (markdown, configs, scripts).
> **No aplica** a código fuente — cada lenguaje tiene su propia nomenclatura
> (Python: `snake_case.py`, JS: `camelCase.js` o `kebab-case.js`, etc.).

### Por tipo de artefacto

| Artefacto | Patrón | Ejemplo correcto | Ejemplo incorrecto |
|-----------|--------|------------------|--------------------|
| ADR | `adr-{tema}.md` | `adr-plugin-namespace.md` | `adr-019.md` |
| Error | `{descripcion}.md` (en `errors/`) | `stream-timeout-idle.md` | `ERR-016.md` |
| Lección | `{descripcion}.md` (en `lessons/`) | `script-sin-registrar.md` | `L-001-script-huerfano.md` |
| Patrón | `{nombre-patron}.md` (en `patterns/`) | `validate-wire-test.md` | `P-001-validate-wire-test.md` |
| WP dir | `YYYY-MM-DD-HH-MM-SS-{nombre}/` | `2026-04-14-09-13-51-context-migration/` | — (timestamp es funcional, no arbitrario) |
| Script | `{accion}-{objeto}.sh/.py` | `validate-session-close.sh` | `script1.sh` |
| Template | `{tipo}.md.template` | `task-plan.md.template` | `template-tasks.md` |
| Reference | `{tema}.md` | `tool-execution-model.md` | `ref-tools.md` |

### Nota sobre timestamps en WP

`YYYY-MM-DD-HH-MM-SS-{nombre}/` no viola la regla "sin números" porque el timestamp
es un dato objetivo (cuándo se creó), no un contador arbitrario. Provee ordenación
natural y unicidad sin coordinación manual.

### Nota sobre IDs internos de documentos

Los IDs de trazabilidad **dentro** de un documento (T-NNN en task-plan.md,
R-N en requirements, FR-NNN) son referencias internas, no nombres de archivo.
La regla de nomenclatura NO aplica a estos identificadores.

---

## Traceability IDs

IDs para trazabilidad cruzada dentro de documentos (no son nombres de archivo):

| Tipo | Formato | Ejemplo | Dónde se usa |
|------|---------|---------|-------------|
| Requirements | R-N | R-1, R-2 | requirements-analysis |
| Functional Requirements | FR-NNN | FR-001 | spec/requirements |
| Use Cases | UC-NNN | UC-001 | use-cases |
| Success Criteria | SC-NNN | SC-001 | quality-goals/spec |
| Tasks | T-NNN | T-001 | tasks.md |
| Checklist Items | CHK-NNN | CHK-001 | checklists |

**Regla:** Cada task (T-NNN) DEBE referenciar el requirement que satisface (R-N o FR-NNN).

---

## Analysis vs Epic

| Tipo | Qué es | Dónde va | Cuándo |
|------|--------|----------|--------|
| **Analysis** | Diagnóstico, hallazgos, investigación | `context/analysis/` | Phase 1 (ANALYZE) o Phase 7 (TRACK) |
| **Epic** | Plan de trabajo con spec + tasks + execution | `context/epics/YYYY-MM-DD-nombre/` | Phase 3+ (tiene epic.md + tasks.md) |

**Regla:** Si el trabajo tiene plan completo + tasks + ejecución + track (WP multi-stage) → es un epic. Si es solo hallazgos → es un analysis.
**Notes:** Any relevant context or decisions
**PRD:** Link to .claude/prds/feature.md if exists
**Epic:** Link to .claude/epics/feature/ if exists

### Feature Y
...
```

### Example

```markdown
# ROADMAP - THYROX

**Status:** In Development
**Current Phase:** Phase 2
**Last Updated:** 2025-03-24
**Version:** 0.1.0

## Progress Conventions

- [ ] = Pendiente
- [-] = En Progreso
- [x] = Completado (YYYY-MM-DD)

## PHASE 1: Estructura Base

### Project Setup
- [x] Initialize repository (2025-03-24)
- [x] Create directory structure (2025-03-24)
- [x] Write documentation (2025-03-24)

## PHASE 2: Sub-proyecto API

### User Authentication
- [x] Database schema (2025-03-24)
- [-] JWT service (started 2025-03-24)
- [ ] API endpoints
- [ ] Tests

**Dependencies:** JWT service blocks API endpoints
**PRD:** See .claude/prds/user-authentication.md

### Payment Integration
- [ ] Stripe client setup
- [ ] Subscription endpoints
- [ ] Webhook handler
- [ ] Tests

**Blocked by:** Stripe API credentials setup
**Notes:** Coordinate with ops team for credentials

## PHASE 3: Sub-proyecto Build

...
```

## Conventional Commits Format

All commits follow the [Conventional Commits](https://www.conventionalcommits.org/) standard:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type

- `feat`: A new feature
- `fix`: A bug fix
- `test`: Adding or updating tests
- `docs`: Documentation changes
- `refactor`: Code restructuring (no feature or bug fix)
- `perf`: Performance improvements
- `chore`: Build, CI/CD, dependencies, tooling
- `style`: Code style changes (formatting, missing semicolons, etc.)

### Scope

The scope is optional but recommended. Use the functional area:
- `api` - API changes
- `auth` - Authentication/authorization
- `db` - Database/models
- `ui` - User interface
- `tests` - Test suite
- `docs` - Documentation

### Examples

```
feat(api): add user login endpoint
fix(auth): handle token expiry correctly
test(api): add JWT validation tests
docs(readme): update setup instructions
refactor(db): simplify user model queries
perf(api): optimize query performance
chore(deps): update dependencies
```

### Benefits

- **Automatic CHANGELOG generation** - Tool reads commits and groups by type
- **Clear history** - Git log is instantly readable
- **Semantic versioning** - `feat` = minor, `fix` = patch, `BREAKING CHANGE` = major
- **CI/CD hooks** - Tooling can trigger based on commit type

## Task Management with Claude Code

### Native Commands

```bash
/task:show              # Show all available tasks
/task:create "Name"     # Create a new task
/task:next              # Show next available task
/task:complete <id>     # Mark task as complete
```

### With Dependencies

```bash
/task:create "Task 1"
/task:create "Task 2" --depends-on "task-1"
/task:create "Task 3" --depends-on "task-1,task-2"
```

### Parallel Execution

Multiple Claude Code sessions can work simultaneously:
- Each session calls `/task:show` to see available work
- Each session commits with Conventional Commits
- Git merges independent work automatically
- ROADMAP.md tracks overall progress

## Progress Tracking

### Daily Updates

At the start of each session:
1. Check ROADMAP.md for current phase
2. Review recent commits: `git log --oneline -10`
3. Update any in-progress items with current status

### Weekly Updates

Once a week:
1. Update CHANGELOG.md from recent commits
2. Archive completed features in ROADMAP.md
3. Update project-state.md with current progress

### Monthly Updates

Once a month:
1. Review decisions.md - any architectural changes?
2. Update VERSION in ROADMAP.md if releasing
3. Create git tag: `git tag -a v0.2.0 -m "Release v0.2.0"`

## Dependency Management

### In ROADMAP.md

```markdown
### Feature X
- [x] Task 1
- [ ] Task 2

**Dependencies:** Task 1 completes before Task 2
```

### In Claude Code

```bash
/task:create "Task 2" --depends-on "task-1"
```

### Parallel vs Sequential

```markdown
### Feature X
- [ ] Task 1: Database (can run in parallel)
- [ ] Task 2: API (can run in parallel)
- [ ] Task 3: Tests (depends on Task 1 and Task 2)

**Dependencies:** Task 3 waits on Task 1 and Task 2
**Parallel:** Task 1 and Task 2 can run simultaneously
```

## Blocking and Waiting

### Mark as Blocked

```markdown
### Feature X
- [ ] Task 1
- [ ] Task 2 (BLOCKED - waiting on external API keys)

**Blocked by:** External API credentials not yet available
**Waiting on:** Ops team to provide Stripe credentials
**ETA:** Expected 2025-03-25
```

### Standup Status

When asked for standup, reference blocked items:
```
In Progress: Task X (75%)
Blocked: Task Y (waiting on API keys from ops)
Next: Task Z (ready to start)
```

## Architectural Decisions

Use `.thyrox/context/decisions` to document ADRs:

```markdown
# Architectural Decision Records

## ADR-001: JWT for Authentication

**Status:** Accepted
**Date:** 2025-03-24
**Context:** Need stateless authentication for API
**Decision:** Use JWT tokens with refresh token rotation
**Consequences:** Requires token storage on client; expiry handling needed

---

## ADR-002: Use Stripe for Payments

**Status:** Accepted
**Date:** 2025-03-24
**Context:** Need payment processing for subscriptions
**Decision:** Use Stripe API instead of building custom solution
**Consequences:** Stripe dependency; webhook handling required
```

## Reference: Change Log Template

[CHANGELOG](../../CHANGELOG.md) is auto-generated but follows this format:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

## [0.2.0] - 2025-03-28

### Added
- User authentication with JWT tokens
- Payment integration with Stripe
- Subscription management endpoints

### Fixed
- Token expiry handling
- Concurrent request race condition

### Changed
- API error response format updated

### Deprecated
- Legacy authentication method

### Removed
- Debug logging endpoints

### Security
- Fixed SQL injection vulnerability in user queries

## [0.1.0] - 2025-03-24

### Added
- Initial project structure
- ROADMAP and documentation
```

## Common Workflows

### Adding a New Feature

1. Add to ROADMAP.md under appropriate PHASE
2. List subtasks (3-5 items)
3. If complex, create PRD at `.claude/prds/<feature>.md`
4. Create Claude Code tasks: `/task:create "Subtask"`
5. Mark dependencies in task creation
6. Start working, commit with conventional format
7. Update ROADMAP.md as tasks complete
8. When feature complete, move to next feature

### Generating Changelog

1. Review recent commits: `git log --oneline v0.1.0..HEAD`
2. Group by type (feat, fix, test, etc.)
3. Remove internal items (chore, refactor, docs)
4. Update CHANGELOG.md with new version
5. Create git tag: `git tag -a v0.2.0 -m "Release v0.2.0"`

### Handling Blockers

1. Add to ROADMAP.md: `(BLOCKED - reason)`
2. Note what's needed to unblock
3. Note ETA if known
4. Check daily in standup
5. Remove BLOCKED status when unblocked

### Parallel Execution

1. Break feature into independent tasks
2. Use `/task:create` with `--depends-on` only where needed
3. Assign different Claude Code sessions to different tasks
4. Each makes commits with different scopes (e.g., feat(api), feat(ui))
5. Git merges independently
6. ROADMAP.md shows parallel progress

## Error Tracking (AP-06)

Errores se documentan en `context/errors/ERR-NNN.md` usando el template [error-report.md.template](../skills/thyrox/assets/error-report.md.template).

**Campos obligatorios:** Qué pasó / Por qué / **Prevención** / Insight

**Reglas:**
- Cada error DEBE tener campo "Prevención" con acción concreta
- Si un error recurre (ej: ERR-002 → ERR-006), la "Prevención" del error anterior falló — escalar a regla en SKILL.md o CLAUDE.md
- Errores que recurren 2+ veces se convierten en locked decision en CLAUDE.md

**Feedback loop:** Error → Prevención → Si recurre → Regla en SKILL/CLAUDE

## Human Handoff (AP-04)

Cuando Claude necesita una decisión del usuario que no puede resolverse en la sesión actual:

1. **Sesión actual:** Agregar al campo `blockers:` en `now.md`
   ```yml
   blockers: ["Decidir stack tecnológico para API", "Aprobar diseño de DB schema"]
   ```

2. **Cross-sesión:** Agregar sección en `focus.md`
   ```markdown
   ### Decisiones pendientes del usuario
   - [ ] Decidir stack tecnológico para API (bloquea T-003)
   - [ ] Aprobar diseño de DB schema (bloquea Phase 4)
   ```

3. **Resolución:** Al decidir, eliminar de blockers/focus y documentar decisión en `context/decisions/`

## Best Practices

- **Update ROADMAP.md daily** — Keep it fresh and accurate
- **Use Conventional Commits** — Enables automation and clear history
- **Add dates when completing** — ROADMAP.md shows `[x] Task (2025-03-24)`
- **Link PRDs from ROADMAP.md** — Make it discoverable
- **Document blockers immediately** — Don't let them surprise you later
- **Commit frequently** — Small commits are easier to review and revert
- **Keep task scope small** — Ideally 2-4 hours of work per task
- **Review ROADMAP.md before starting session** — Context transfer is essential
- **Before deleting files, grep for references** — Run `grep -r "filename" .claude/` to find all mentions and update them. Use [detect_broken_references.py](../scripts/detect_broken_references.py) to validate after
- **Rename verification: usar siempre `grep -ri` (case-insensitive)** — `grep -r "term"` (minúsculas) no detecta `TERM` ni `Term` en headings H1/H2 ni cuerpos de documentos. Comando correcto para verificación post-rename:
  ```bash
  grep -ri "nombre-anterior" .claude/skills/ .claude/CLAUDE.md .claude/scripts/ .claude/references/ \
    --include="*.md" --include="*.sh" --include="*.json" --include="*.py" | \
    grep -v "context/work/" | grep -v "context/decisions/"
  ```
  Excluir `context/work/` (archivos históricos de WPs — correctos) y `context/decisions/` (ADRs inmutables). Resultado esperado: 0 líneas en archivos activos.

## When to Update What

| Update | When | Frequency |
|--------|------|-----------|
| ROADMAP.md | Task starts, task completes | Daily |
| CHANGELOG.md | After commit sequence | Weekly |
| decisions.md | Major architectural decision | As-needed |
| project-state.md | End of session | Weekly |
| focus.md | End of session | Every session |
| now.md | Start and end of session | Every session |
| context/errors/ | When error occurs | As-needed |
| Git tag | Release to production | With version bump |

<!-- SECTION OWNER: parallel-agent-conventions -->
## Parallel Agent Execution

### now-{agent-id}.md — Estado por agente

En ejecución paralela, cada agente escribe su estado en `context/now-{agent-id}.md`.
El archivo `context/now.md` permanece sin modificar (retrocompatibilidad).

**Formato del agent-id:** kebab-case, único por sesión. Ejemplos: `agent-a`, `task-executor-1`, `wp-paralelo-2`.

**Ciclo de vida:**
- Inicio: crear `context/now-{agent-id}.md` con `status: active`
- Cierre: actualizar `status: closed` y hacer commit

### ROADMAP.md — Solo lectura en ejecución paralela

Durante sesiones con múltiples agentes, ROADMAP.md NO se modifica directamente.
El progreso se registra en `{wp}-execution-log.md` de cada work package.
ROADMAP.md se actualiza al final en Phase 7 por el agente coordinador o el usuario.

### Ciclo de vida de now-{agent-id}.md

1. **Inicio de sesión:** crear `context/now-{agent-id}.md` con `status: active` y `current_work:`
2. **Durante trabajo:** actualizar `phase:` y tareas en progreso
3. **Cierre:** actualizar `status: closed` y hacer commit
4. **Descubrimiento:** al iniciar, ejecutar `ls context/now-*.md` para ver agentes activos

### Namespacing de ADRs por capa

| Capa | Path | Prefijo |
|------|------|---------|
| Cross-layer | `context/decisions/global/` | `ADR-GLOBAL-NNN` |
| API / backend | `context/decisions/api/` | `ADR-API-NNN` |
| Base de datos | `context/decisions/db/` | `ADR-DB-NNN` |
| Frontend / UI | `context/decisions/ui/` | `ADR-UI-NNN` |
| Deploy / infra | `context/decisions/deploy/` | `ADR-DEPLOY-NNN` |
| Framework | `context/decisions/framework/` | `ADR-FRAMEWORK-NNN` |

ADRs históricos en `context/decisions/` raíz (adr-001..adr-014) permanecen sin migrar.

### Handoff de sesión

Al iniciar sesión paralela:
1. `ls context/now-*.md` — identificar agentes activos (status: active)
2. Leer task-plans de WPs activos — evitar tareas ya en `[~]`
3. Crear propio `context/now-{agent-id}.md`

Al cerrar sesión:
1. Completar tareas en progreso o revertir claims `[~]` → `[ ]`
2. Actualizar `status: closed` en `context/now-{agent-id}.md`
3. Commit y push

### Recovery de claims abandonados

Un claim `[~]` es candidato a liberación si:
- El timestamp `claimed:` tiene más de 30 minutos
- `context/now-{agent-id}.md` tiene `status: closed` o no existe
- No hay commits recientes del agente en `git log`

**Protocolo de liberación:**
1. Verificar que el agente está inactivo (now-{agent-id}.md status: closed)
2. Cambiar `[~]` → `[ ]` en el task-plan (quitar @agent-id y timestamps)
3. Commit: `fix(task-plan): release abandoned claim T-NNN from {agent-id} (timeout/crash)`

**Umbral sugerido:** 30 minutos sin commit del agente.
**Evidencia de dogfooding:** 2 timeouts observados durante Phase 3-4 de este WP dejaron claims potencialmente huérfanos.

### Límite de tamaño para prompts de agentes

**Máximo recomendado: 800 palabras por prompt de agente.**

Prompts más largos aumentan el riesgo de timeout en ejecución paralela.
Si el contexto requiere más: dividir en agentes secuenciales o reducir archivos a leer.

Evidencia (FASE 13): prompts ~700 palabras → 0 timeouts. Prompts ~2500 palabras → 3 timeouts.

### Timestamps únicos en WPs creados en paralelo

Cuando dos WPs se crean en el mismo segundo, agregar sufijo al directorio:

```bash
# WP-1:
2026-04-07-03-08-03-a-parallel-agent-conventions/
# WP-2:
2026-04-07-03-08-03-b-agent-format-spec/
```

Sufijos: `-a`, `-b`, `-c`, ... en orden de creación.
Esto garantiza que `ls context/work/ | tail -1` devuelva un resultado determinista.

### Protocolo cuando Write está bloqueado en un agente

Si un agente no puede crear un archivo (Write denegado):

1. El agente incluye el contenido completo del archivo en su reporte final
2. El coordinador crea el archivo con el contenido reportado
3. El coordinador hace el commit correspondiente

Este es el comportamiento esperado — no un error del agente.
El coordinador siempre tiene Write habilitado; los agentes pueden tenerlo restringido.
<!-- END SECTION: parallel-agent-conventions -->

## State files — naming conventions

Define qué archivo de estado usa cada tipo de entidad en ejecución. Convención establecida en ADR-015 D-08.

| Tipo de entidad | Archivo de estado | Ejemplo |
|----------------|-------------------|---------|
| Orquestador / estado compartido | `context/now.md` | Estado de sesión single-agent o estado global |
| Agente nativo en ejecución | `context/now-{agent-name}.md` | `now-task-executor.md`, `now-task-planner.md` |
| Skill especializado activo | `context/now-{skill-name}-{wp-id}.md` | `now-security-audit-wp-auth.md` |

**Regla de section owner:** Cada entidad escribe únicamente en su propio archivo de estado.
`now.md` es territorio del orquestador — un agente o skill especializado NO sobreescribe `now.md`.

**Cuándo crear el archivo:** Al inicio de la ejecución. Cuándo eliminarlo: al completar (o moverlo a `work/{wp}/` como evidencia).

Ver también: [state-management.md](state-management.md) para el trigger map completo de cuándo actualizar cada campo.

---

## Longevidad de archivos (REGLA-LONGEV-001) (TD-026)

Los archivos vivos (ROADMAP.md, CHANGELOG.md, technical-debt.md) se degradan en performance del LLM cuando crecen sin límite.

**Umbral de tamaño:** 25,000 bytes (≈10,000 tokens).

**Acción cuando se supera el umbral (revisada — ÉPICA 41):**

Evaluar qué porción del archivo es **historial** vs. **estado activo**. El historial se elimina del archivo activo — NO se mueve a un archivo `-archive` o `-history`. El historial vive en git.

```bash
# Para ver el historial completo de cualquier archivo:
git log --oneline --follow -- ROADMAP.md
git log --oneline --follow -- CHANGELOG.md
git show HEAD~30:ROADMAP.md   # estado en cualquier punto del pasado
```

**Prohibido:** `{archivo}-history.md`, `{archivo}-archive.md` — violan I-002 (git es el historial).

**Excepción:** si el historial debe ser navegable sin acceso a git (documentación publicada, sitio estático), se puede mantener un `-archive`. THYROX no tiene este caso.

**Archivos a monitorear:** `ROADMAP.md`, `CHANGELOG.md`, `technical-debt.md`.

**Trigger de revisión:** cada 5 ÉPICAs, ejecutar: `wc -c ROADMAP.md CHANGELOG.md .thyrox/context/technical-debt.md`

---

## Timestamps en artefactos WP (TD-001)

Los artefactos de work package usan `created_at` (no `updated_at`) en su frontmatter YAML:

```yml
created_at: YYYY-MM-DD HH:MM:SS  # timestamp real del sistema — NO estimar
```

**Regla:** obtener timestamp real: `date '+%Y-%m-%d %H:%M:%S'`. NUNCA inventar ni estimar.

Los archivos de configuración del sistema (CLAUDE.md, skills/*.md, references/) usan `updated_at` y se actualiza en cada edición.

---

## CHANGELOG.md (raíz) — solo en releases (D2, ÉPICA 29, ÉPICA 41)

`CHANGELOG.md` (raíz del proyecto) se actualiza ÚNICAMENTE cuando hay un release con bump de versión semántico (`git tag vX.Y.Z`).

| Evento | Acción correcta |
|--------|-----------------|
| `git tag v2.9.0` (MINOR) | ✅ Actualizar `CHANGELOG.md` raíz |
| `git tag v3.0.0` (MAJOR) | ✅ Actualizar `CHANGELOG.md` raíz |
| Cierre de WP | ✅ Crear `{nombre-wp}-changelog.md` en Stage 12 |
| Sesión de trabajo | ❌ NO tocar `CHANGELOG.md` raíz |
| Stage 12 STANDARDIZE | ❌ NO tocar `CHANGELOG.md` raíz (excepto si el WP es un release completo) |

**Para el progreso de desarrollo de un WP:** usar `{nombre-wp}-changelog.md` en el WP (Stage 12). Ver template en `.claude/skills/workflow-track/assets/wp-changelog.md.template`.

**Prohibido:** `CHANGELOG-archive.md`, `CHANGELOG-history.md` — violan I-002. El historial de versiones vive en `git log --follow -- CHANGELOG.md`.

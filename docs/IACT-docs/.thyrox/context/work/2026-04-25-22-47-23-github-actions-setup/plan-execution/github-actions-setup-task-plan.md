```yml
created_at: 2026-04-26 00:00:00
project: IACT-docs
work_package: 2026-04-25-22-47-23-github-actions-setup
phase: Phase 8 — PLAN EXECUTION
author: Claude
status: Borrador
version: 1.1.0
total_tasks: 9
updated_at: 2026-04-26 00:20:00
```

# Task Plan — GitHub Actions Setup Phase 1 + Dependabot (ÉPICA: github-actions-setup)

> **Generado desde:** `design/github-actions-setup-requirements-spec.md`  
> **Alcance:** Create 6 files in `.github/` directory (3 issue templates, 1 PR template, 1 CI/CD workflow, 1 dependabot config)  
> **Ruta crítica:** T-001 → T-002/T-003/T-004 (parallelizable) → T-005 → T-006 → T-007 → T-008 → T-009  
> **Esfuerzo total:** ~2.8 horas implementation + validation  
> **Tamaño:** 6 core tasks + 3 validation/commit tasks = **9 tasks**

---

## Convención de tarea

**Opción C — Tareas genéricas con trazabilidad a spec**

Formato: `T-NNN [P] Descripción (SPEC-N)`
- `[P]` = paralelizable (puede ejecutarse simultáneamente con otras)
- `(SPEC-N)` = trazabilidad a especificación de Phase 7

---

## Grupo 1 — Issue Templates (Config + Bug Report)

> Crear los primeros templates. T-001 es bloqueante (config.yml debe existir para T-002/T-003 referencias).
> T-002 puede paralelizarse con T-003 una vez T-001 esté completo.

- [ ] **T-001** Create issue template config (SPEC-001)
  - **Archivo:** `.github/ISSUE_TEMPLATE/config.yml`
  - **Contenido:**
    ```yaml
    blank_issues_enabled: false
    contact_links:
      - name: Question or Discussion
        url: https://github.com/jcg-admin/IACT-docs/discussions
        about: Ask questions or start discussions
    ```
  - **Validación:** File exists, YAML syntax valid, no errors when pushed
  - **Commit:** Include in T-007
  - **Tiempo estimado:** 15 min
  - **Notas:** This file must exist before T-002/T-003 (config references them)

- [ ] **T-002** [P] Create bug report template (SPEC-002)
  - **Archivo:** `.github/ISSUE_TEMPLATE/bug-report.yml`
  - **Contenido:**
    ```yaml
    name: Bug Report
    description: Report a bug in IACT-docs or Sphinx build
    
    body:
      - type: markdown
        attributes:
          value: |
            Thank you for reporting a bug!
            Please provide as much detail as possible.
    
      - type: textarea
        id: description
        attributes:
          label: Description
          placeholder: Describe the bug...
        validations:
          required: true
    
      - type: textarea
        id: reproduction
        attributes:
          label: How to reproduce
          placeholder: |
            1. ...
            2. ...
        validations:
          required: true
    
      - type: textarea
        id: expected
        attributes:
          label: Expected behavior
          placeholder: What should happen...
        validations:
          required: true
    
      - type: textarea
        id: actual
        attributes:
          label: Actual behavior
          placeholder: What actually happens...
        validations:
          required: true
    
      - type: input
        id: environment
        attributes:
          label: Environment
          value: "Sphinx 9.0.4, Python 3.11, PlantUML 1.2025.0"
    ```
  - **Validación:** File exists, YAML syntax valid, form renders in GitHub UI
  - **Commit:** Include in T-007
  - **Tiempo estimado:** 20 min
  - **Notas:** Pre-populated environment field helps contributors provide consistent context

- [ ] **T-003** [P] Create feature request template (SPEC-003)
  - **Archivo:** `.github/ISSUE_TEMPLATE/feature-request.md`
  - **Contenido:**
    ```markdown
    # Feature Request
    
    ## Motivation
    Why do we need this feature?
    
    ## Proposed Solution
    How should this feature work?
    
    ## Alternatives Considered
    What other approaches could work?
    
    ## Acceptance Criteria
    How will we know it's done?
    - [ ] Criterion 1
    - [ ] Criterion 2
    
    ## Related Issues
    Closes #[issue_number]
    ```
  - **Validación:** File exists, Markdown syntax valid, all sections present
  - **Commit:** Include in T-007
  - **Tiempo estimado:** 15 min
  - **Notas:** Simpler Markdown format (vs YAML) for feature requests

---

## Grupo 2 — PR Template + Workflow

> T-004 es independiente (PR template doesn't reference config.yml).
> T-005 es independiente (workflow doesn't depend on templates).
> Ambas pueden paralelizarse con T-002/T-003.

- [ ] **T-004** [P] Create PR template (SPEC-004)
  - **Archivo:** `.github/PULL_REQUEST_TEMPLATE.md`
  - **Contenido:**
    ```markdown
    ## PR Checklist
    
    - [ ] Changes tested locally (`make html` succeeds)
    - [ ] RST title formatting follows conventions (overline/underline match)
    - [ ] Commit messages follow conventional format (type(scope): description)
    - [ ] Documentation updated if needed
    - [ ] No breaking changes to conf.py or dependencies
    
    ## Description
    [Brief description of changes]
    
    ## Related Issues
    Closes #[issue_number]
    
    ## Screenshots
    [If applicable]
    ```
  - **Validación:** File exists, Markdown syntax valid, template appears when user creates PR
  - **Commit:** Include in T-007
  - **Tiempo estimado:** 15 min
  - **Notas:** Appears automatically when user creates PR; not enforced but informational

- [ ] **T-005** [P] Create Sphinx build workflow (SPEC-005)
  - **Archivo:** `.github/workflows/sphinx-build.yml`
  - **Contenido:**
    ```yaml
    name: Sphinx Build Validation
    
    on:
      pull_request:
        branches: [main]
      push:
        branches: [main]
    
    jobs:
      build:
        runs-on: ubuntu-latest
        timeout-minutes: 15
    
        steps:
          - uses: actions/checkout@v3
          
          - name: Set up Python 3.11
            uses: actions/setup-python@v4
            with:
              python-version: '3.11'
          
          - name: Install dependencies
            run: |
              pip install -e .
          
          - name: Build Sphinx documentation
            run: |
              cd source
              make clean
              make html
          
          - name: Upload build artifacts
            if: always()
            uses: actions/upload-artifact@v3
            with:
              name: sphinx-build
              path: source/_build/html/
    ```
  - **Validación:** 
    - [ ] File exists at correct path
    - [ ] YAML syntax valid (GitHub Actions will report if errors)
    - [ ] Trigger test: Create PR on feature branch, verify workflow runs
    - [ ] Build succeeds (make html exit code 0)
    - [ ] PlantUML diagrams compile without timeout
    - [ ] Workflow reports pass/fail correctly
  - **Commit:** Include in T-007
  - **Tiempo estimado:** 1.5 horas (includes local testing)
  - **Notas:** Most complex spec; include testing on actual GitHub (create real PR or test branch)

---

## Grupo 3 — Validación y Commits

- [ ] **T-006** Validate all 5 files created correctly
  - **Verificación:**
    - [ ] `.github/ISSUE_TEMPLATE/config.yml` exists, YAML valid
    - [ ] `.github/ISSUE_TEMPLATE/bug-report.yml` exists, YAML valid
    - [ ] `.github/ISSUE_TEMPLATE/feature-request.md` exists, Markdown valid
    - [ ] `.github/PULL_REQUEST_TEMPLATE.md` exists, Markdown valid
    - [ ] `.github/workflows/sphinx-build.yml` exists, YAML valid
    - [ ] All file paths are correct (no typos in directory structure)
    - [ ] Running `make html` succeeds (workflow will work)
    - [ ] No syntax errors visible in any file
  - **Commit:** Include in T-007
  - **Tiempo estimado:** 15 min
  - **Notas:** Catch errors before final commit; prevents rework in Phase 10

- [ ] **T-007** Commit all changes
  - **Commit message:**
    ```
    feat(github-actions-setup): create Phase 1 CI/CD automation (5 files)
    
    - Create .github/ISSUE_TEMPLATE/config.yml (SPEC-001)
    - Create .github/ISSUE_TEMPLATE/bug-report.yml (SPEC-002)
    - Create .github/ISSUE_TEMPLATE/feature-request.md (SPEC-003)
    - Create .github/PULL_REQUEST_TEMPLATE.md (SPEC-004)
    - Create .github/workflows/sphinx-build.yml (SPEC-005)
    
    All 5 specifications from Phase 7 implemented.
    Cost estimate: 50 min/month (2.5% of free tier).
    Sphinx build validation on every PR to main.
    
    Closes Phase 8 PLAN EXECUTION.
    ```
  - **Git commands:**
    ```bash
    git add .github/
    git commit -m "feat(github-actions-setup): create Phase 1 CI/CD automation (5 files)"
    ```
  - **Validación:** Commit successful, no hook errors
  - **Tiempo estimado:** 5 min

- [ ] **T-008** Push to feature branch and update now.md
  - **Git command:**
    ```bash
    git push -u origin feature/project-setup
    ```
  - **Update now.md:**
    - `stage: 10` (advance to Phase 10 EXECUTE)
    - `current_phase: Phase 10 EXECUTE (Phase C Configuration...)`
    - `phase_8_decision_gate: "✅ READY FOR PHASE 10 — task plan complete, all 6 specs decomposed into 9 atomic tasks"`
  - **Validación:** Push successful, now.md updated
  - **Tiempo estimado:** 5 min
  - **Notas:** Transition to Phase 10 when approved

- [ ] **T-009** Create dependabot configuration (SPEC-006)
  - **Archivo:** `.github/dependabot.yml`
  - **Contenido:**
    ```yaml
    version: 2
    updates:
      - package-ecosystem: "pip"
        directory: "/"
        schedule:
          interval: "weekly"
        open-pull-requests-limit: 5
        commit-message:
          prefix: "chore(deps)"
    ```
  - **Validación:** File exists, YAML syntax valid, Dependabot dashboard shows repo enabled
  - **Commit:** Separate commit with message `"feat(github-actions-setup): add dependabot configuration (Phase 2)"`
  - **Tiempo estimado:** 10 min
  - **Notas:** Phase 2 enhancement; independent of T-001..T-008; can be executed after Phase 1 complete

---

## DAG de dependencias

```
T-001 (config.yml) — BLOQUEANTE
    ↓
    ├─→ T-002 [P] (bug-report.yml)
    ├─→ T-003 [P] (feature-request.md)
    ├─→ T-004 [P] (PULL_REQUEST_TEMPLATE.md)
    └─→ T-005 [P] (sphinx-build.yml)
    
    Todas pueden ejecutarse en paralelo UNA VEZ T-001 esté completo
    (técnicamente T-002/T-003 dependen de T-001, pero T-004/T-005 son independientes)
    
    ↓
    
T-006 (Validate all files) — SECUENCIAL
    ↓
T-007 (Commit Phase 1) — SECUENCIAL
    ↓
T-008 (Push Phase 1 + update now.md) — SECUENCIAL
    
T-009 (dependabot.yml) — INDEPENDIENTE
    ↓
    (Phase 2 can execute in parallel or sequentially after Phase 1)
```

**Ruta crítica Phase 1 (en serie):** T-001 (15 min) → T-002/T-003/T-004/T-005 (paralelo, máx 90 min) → T-006 (15 min) → T-007 (5 min) → T-008 (5 min)

**Tiempo total (Phase 1 + Phase 2):**
- Phase 1 secuencial: 15 + 90 + 15 + 5 + 5 = **130 minutos (~2.17 horas)**
- Phase 2: T-009 = **10 minutos**
- Total (si secuencial): 15 + 90 + 15 + 5 + 5 + 10 = **140 minutos (~2.33 horas)**
- Paralelo óptimo: max(T-001..T-005) + T-006 + T-007 + T-008 + T-009 = 15 + 90 + 15 + 5 + 5 + 10 = **140 minutos**

---

## Pasos de Ejecución (Phase 10 EXECUTE)

**Orden recomendado:**

**Phase 1 (Essential):**
1. **T-001 SOLO (15 min)** — Create config.yml first (bloqueante)
2. **T-002, T-003, T-004, T-005 EN PARALELO (90 min)** — 
   - T-002: 20 min
   - T-003: 15 min
   - T-004: 15 min
   - T-005: 90 min (longest; can run while others finish)
3. **T-006 (15 min)** — Validate all files exist and are syntactically correct
4. **T-007 (5 min)** — Commit all Phase 1 changes
5. **T-008 (5 min)** — Push and update now.md

**Phase 2 (Enhancement):**
6. **T-009 (10 min)** — Create dependabot.yml (can execute in parallel or after Phase 1)

**Decisiones de paralelización:**
- T-001 DEBE completarse antes de T-002/T-003 (configuración).
- T-004/T-005 pueden iniciarse inmediatamente (no dependen de T-001).
- T-002, T-003, T-004 pueden hacerse en paralelo (15-20 min máx).
- T-005 (workflow) toma más tiempo; ideal parallelizar con T-002/T-003/T-004.
- T-009 es independiente; puede ejecutarse en paralelo con T-001..T-008 o después de T-008.

---

## Criterios de Completitud

**Tarea completa = TODO lo siguiente es TRUE:**

- [ ] Archivo creado en ruta correcta
- [ ] Sintaxis válida (YAML/Markdown)
- [ ] Contenido coincide con SPEC de Phase 7
- [ ] No hay `[NEEDS CLARIFICATION]` en especificación
- [ ] Constraints de Phase 4 respetados
- [ ] Commit conventional format applied
- [ ] Push successful to feature branch

**Gate 8→10:** Todas las tareas [x] completadas Y T-006 validación pasó = Ready for Phase 10 EXECUTE

---

## Riesgos de Ejecución

| Riesgo | Probability | Mitigation |
|--------|-------------|-----------|
| YAML syntax error in workflow | MEDIA | Use GitHub's visual editor; validate locally before commit |
| PlantUML timeout on test | BAJA | Timeout set to 15 min (generous); diagrams usually compile fast |
| Python installation fails | BAJA | Python 3.11 widely available; actions/setup-python is stable |
| File created in wrong directory | BAJA | Double-check paths; use copy-paste from spec |

---

## Evidencia de respaldo

| Claim | Tipo | Fuente | Confianza | Origen |
|-------|------|--------|-----------|--------|
| 5 files are sufficient for Phase 1 scope | INFERRED | Phase 6 PLAN scope statement (5 files in-scope) | alta | nuevo |
| Tasks are atomic (15-30 min each) | INFERRED | T-001..T-005 effort estimates match spec estimates | media | nuevo |
| Workflow will work (HC/SC respected) | INFERRED | Phase 4 CONSTRAINTS validation in SPEC-005 | media | nuevo |
| Build succeeds locally | PROVEN | Phase 10 will test via PR trigger | pendiente | externo |

---

## Out-of-scope

Los siguientes ítems quedan fuera de este task-plan (Phase 8):

- **Phase 2 enhancements (remaining):** rst-lint.yml, ReadTheDocs deployment (deferred to Phase 2)
- **Branch protection rules:** Configuration requires admin role; can be tested in Phase 10 but not configured
- **Notifications:** Slack/email alerts (Phase 2)
- **Advanced CI/CD:** Matrix builds, coverage tracking, release automation (Phase 2+)

**Note:** dependabot.yml was moved IN-SCOPE as T-009 (Phase 2, added on request after Phase 10)

---

## Stopping Points

| SP | Task | Condición de parada |
|----|------|---------------------|
| SP-08-01 | Pre-T-001 | User confirms task-plan is clear and 5 files are implementable (Phase 7 exit gate) |
| SP-08-02 | Post-T-006 | All files validated; syntax errors fixed before T-007 commit |
| SP-08-03 | Post-T-008 | Push successful; now.md updated; ready for Phase 10 EXECUTE |

---

## Resumen de progreso

| Grupo | Tareas | Completadas | Pendientes |
|-------|--------|-------------|------------|
| **Grupo 1 (Templates)** | 3 | 0 | 3 |
| **Grupo 2 (PR + Workflow)** | 2 | 0 | 2 |
| **Grupo 3 (Validación)** | 3 | 0 | 3 |
| **Grupo 4 (Dependabot)** | 1 | 0 | 1 |
| **Total** | **9** | **0** | **9** |

---

**Documento creado:** 2026-04-26 00:00:00  
**Status:** Borrador — Ready for Phase 10 EXECUTE when approved  
**Next:** User confirms task-plan is clear, then transition to Phase 10 EXECUTE  
**Critical Path:** T-001 → T-002/T-003/T-004/T-005 (parallelizable) → T-006 → T-007 → T-008 [→ T-009 if dependabot requested]

---

## Instrucciones para Phase 10 EXECUTE

Cuando user apruebe y avancemos a Phase 10:

1. **Clone el task-plan:** Copiar checkboxes `- [ ]` a un área de tracking
2. **Ejecutar en orden:** Seguir DAG de dependencias
3. **Validar completitud:** Marcar `[x]` solo cuando ALL criterios de completitud sean TRUE
4. **Reportar bloqueadores:** Si algo falla, documentar en error-log (`.thyrox/context/errors/`)
5. **Iterar si es necesario:** max 3 rework iterations (gate 8→9); si supera, escalar

Commit Phase 1: `git commit -m "feat(github-actions-setup): Phase 10 EXECUTE Phase 1 complete — 5 files created"`
Commit Phase 2: `git commit -m "feat(github-actions-setup): Phase 10 EXECUTE Phase 2 complete — add dependabot.yml"`

Push: `git push -u origin feature/project-setup`

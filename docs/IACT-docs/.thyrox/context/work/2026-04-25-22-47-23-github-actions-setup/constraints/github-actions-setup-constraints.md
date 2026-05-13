```yml
created_at: 2026-04-25 23:45:00
project: IACT-docs
work_package: 2026-04-25-22-47-23-github-actions-setup
phase: Phase 4 — CONSTRAINTS
author: Claude
status: Borrador
hard_constraints: 5
soft_constraints: 4
version: 1.0.0
```

# Constraints — GitHub Actions CI/CD Setup

## Propósito

Delimitar el espacio de soluciones válidas antes de diseñar workflow de GitHub Actions.
Las restricciones técnicas y de plataforma definen qué configuraciones funcionarán y cuáles fallarán.

> **Diferencia clave:**
> - **HARD constraints:** Violarlas = solución INVÁLIDA (no funciona)
> - **SOFT constraints:** Violarlas = solución VÁLIDA pero PENALIZADA (más lenta, más cara, etc.)

---

## HARD Constraints — No negociables

### HC-001: GitHub Actions Free Tier Limit (2000 min/month)

**Categoría**: Plataforma (GitHub Actions)

**Descripción:** GitHub Actions free tier provides 2000 minutes/month. Exceeding this incurs charges.
The solution MUST estimate and respect this limit.

**Origen:** GitHub Actions official pricing tier (https://github.com/pricing)

**Evidencia:** GitHub official documentation; verified in Phase 1 DISCOVER analysis

**Impacto en diseño:**
- sphinx-build.yml must complete in <50 minutes per run
- Workflow must not trigger on every commit (only PRs + main branch)
- No matrix builds or parallelization that multiply execution time
- Estimated 50 min/month usage = 2.5% of free tier (safe margin)

**Alternativas eliminadas:**
- ❌ Trigger on every commit (too expensive)
- ❌ Daily scheduled builds (too expensive)
- ❌ Matrix builds for multiple Python versions (multiplies time)

---

### HC-002: Linux Runner Required (Ubuntu)

**Categoría**: Técnica (Sphinx build environment)

**Descripción:** Sphinx builds on IACT-docs project must run on Linux (Ubuntu) runner.
Windows/macOS runners are not suitable for documentation builds (PlantUML, Java dependencies).

**Origen:** Sphinx best practices; IACT-docs testing successful on Linux; Phase 1 analysis confirmed

**Evidencia:**
- Project builds successfully on `make html` (Linux)
- PlantUML/Java available on standard Ubuntu runners
- Official Sphinx CI uses Ubuntu runners

**Impacto en diseño:**
- Workflow must specify `runs-on: ubuntu-latest`
- No macOS-specific or Windows-specific syntax in workflow
- Dependencies must be Linux-compatible

**Alternativas eliminadas:**
- ❌ Windows runner (no PlantUML, Java setup complexity)
- ❌ macOS runner (not tested, unnecessary cost)

---

### HC-003: Python Version Compatibility (3.11)

**Categoría**: Técnica (pyproject.toml)

**Descripción:** IACT-docs pyproject.toml specifies `requires-python = ">=3.10"`.
The runner MUST use Python 3.11 (or compatible >=3.10).
Sphinx 9.0.4 requires Python 3.10+.

**Origen:** pyproject.toml official configuration; Sphinx 9.0.4 requirements

**Evidencia:**
- `/home/user/IACT-docs/pyproject.toml` line: requires-python = ">=3.10"
- Sphinx 9.0.4 official docs confirm >=3.10 requirement
- Local testing: Python 3.11 successful

**Impacto en diseño:**
- Workflow MUST include: `python-version: '3.11'` (or 3.10, but 3.11 recommended)
- `actions/setup-python@v4` action required
- No attempt to support Python 2.x or 3.9

**Alternativas eliminadas:**
- ❌ Python 3.9 (below requirement, Sphinx won't install)
- ❌ Python 2.x (obsolete, no Sphinx support)

---

### HC-004: PlantUML Java Dependency

**Categoría**: Técnica (Sphinx extension dependency)

**Descripción:** sphinxcontrib-plantuml extension requires:
1. PlantUML binary installed
2. Java Runtime Environment (JRE) available
3. Both MUST be available in GitHub Actions runner

**Origen:** sphinxcontrib-plantuml documentation; Phase 1 DISCOVER verified this works locally

**Evidencia:**
- `/usr/bin/java` verified on local environment
- `/usr/bin/plantuml` verified on local environment
- Sphinx build succeeds with PlantUML diagrams compiling
- Ubuntu standard runners include Java by default

**Impacto en diseño:**
- Workflow may need explicit `apt-get install plantuml` if not pre-installed on Ubuntu runner
- Cannot skip PlantUML installation and expect diagrams to compile
- Must handle PlantUML compilation time in timeout estimate (15-20 min total)

**Alternativas eliminadas:**
- ❌ Use non-Ubuntu runner without Java (PlantUML won't compile)
- ❌ Skip PlantUML in CI (defeats purpose; diagrams won't render)
- ❌ Use online PlantUML renderer (requires internet, less reliable)

---

### HC-005: Sphinx Build Output Validation

**Categoría**: Técnica (CI/CD gate)

**Descripción:** Workflow MUST validate Sphinx build exit code.
If `make html` exits with code 0, build succeeds. Any non-zero exit code is failure.
The workflow MUST fail the PR if Sphinx fails.

**Origen:** GitHub Actions best practice; Phase 1 DISCOVER: "Build validation before merge is core requirement"

**Evidencia:**
- Phase 1 DISCOVER problem statement: "No automated build validation"
- exit-conditions.md success criteria: "Build validation passes or fails with clear error messages"
- Risk register R-001: "Build fails on PR, blocking merges"

**Impacto en diseño:**
- Workflow MUST NOT have `continue-on-error: true` for Sphinx build step
- Failure must propagate to PR status (red X)
- Error log must be visible in workflow output
- PR cannot be merged if build fails (assumes branch protection configured)

**Alternativas eliminadas:**
- ❌ Allowing builds to fail silently (defeats purpose)
- ❌ Not checking exit codes (broken builds could merge)

---

## SOFT Constraints — Preferencias con peso

### SC-001: Cost Minimization (Target <60 min/month)

**Peso**: Alto

**Descripción:** The workflow should estimate and minimize monthly usage to stay well under the 2000 min/month free tier.
Target: ~50 min/month (2.5% of free tier).

**Razón:**
- Keeps project in free tier indefinitely
- No unexpected billing surprises
- Demonstrates cost-conscious CI/CD design

**Trade-off aceptable:**
- OK to use 100 min/month if build becomes more complex later
- NOT OK to use 500+ min/month (approaches paid tier)
- Can optimize caching later if time exceeds 100 min/month

**Design implication:** Trigger frequency matters more than individual run time.
- Current design: ~5-10 PRs/month × ~50 min max = ~50 min/month ✓

---

### SC-002: Build Speed (Target <10 min per run)

**Peso**: Medio

**Descripción:** Individual Sphinx build should complete in <10 minutes ideally, <15 min maximum.
Slow builds annoy contributors and increase cost.

**Razón:**
- Contributor feedback loop: fast feedback encourages more PRs
- Cost efficiency: faster builds = fewer minutes used
- Detection time: errors detected quickly

**Trade-off aceptable:**
- First run may be slower (pip install cache miss)
- PlantUML compilation adds 1-3 min (acceptable)
- Can add caching in Phase 2 to optimize further

**Design implication:** Workflow should use pip caching (phase 2 enhancement, not phase 1 blocker)

---

### SC-003: PlantUML Diagram Compilation

**Peso**: Medio

**Descripción:** PlantUML diagrams in documentation should compile without timeouts or errors in GitHub Actions runner.
Timeout should be generous (15-20 min for full build, not just PlantUML step).

**Razón:**
- Currently 6 domains with several PlantUML diagrams
- Risk R-007: "PlantUML Diagram Compilation Timeout" identified as LOW probability but possible
- Diagrams are core to IACT-docs value (architecture visualization)

**Trade-off aceptable:**
- Acceptable: Full build timeout of 15-20 min (allows PlantUML compilation)
- Acceptable: Optimize diagrams later if timeout occurs
- NOT acceptable: Removing diagrams from CI validation

**Design implication:** `timeout-minutes: 20` in workflow step (conservative estimate, can optimize)

---

### SC-004: Backward Compatibility (No Breaking Changes to Existing Code)

**Peso**: Alto

**Descripción:** GitHub Actions setup MUST NOT modify source code, Sphinx configuration, or dependencies.
Only CREATE new files in `.github/` directory.

**Razón:**
- Risk: Breaking existing builds while adding automation
- Scope: Phase 1 is CI/CD automation setup, not refactoring
- Reversibility: If workflow causes issues, must be removable without impact

**Trade-off aceptable:**
- OK to update .github files in Phase 2
- NOT OK to modify source/conf.py or source/**/*.rst
- NOT OK to add new dependencies to pyproject.toml in Phase 1

**Design implication:** Workflow file is standalone, no coupling to codebase internals

---

## Espacio de soluciones resultante

### Opciones viables

| Opción | Cumple HCs | Cumple SCs | Notas |
|--------|:----------:|:----------:|-------|
| **Opción A: GitHub Actions (ubuntu-latest, Python 3.11, trigger on PR+main)** | ✓✓✓✓✓ | ✓✓✓✓ | **RECOMENDADO.** Respeta todos los limits. Cost ~50 min/month. Fast feedback. Standard approach. |
| Opción B: GitHub Actions (ubuntu-latest, Python 3.10 instead of 3.11) | ✓✓✓✓✓ | ✓✓✓✓ | Válido pero no preferred (3.11 is more current). Minor trade-off. |
| Opción C: GitHub Actions with caching (Phase 2) | ✓✓✓✓✓ | ✓✓✓✓✓ | Mejora a SC-002. Deferred a Phase 2. |

### Opciones descartadas

| Opción | HC que viola | Por qué no aplica una excepción |
|--------|-------------|--------------------------------|
| TravisCI / CircleCI | HC-001 | External platform, not GitHub native; adds complexity. GitHub Actions is native & free tier sufficient. |
| Windows runner | HC-002 | PlantUML/Java setup more complex on Windows; Sphinx testing not validated on Windows. |
| Python 3.9 | HC-003 | Below pyproject.toml requirement (>=3.10). Sphinx 9.0.4 won't install. |
| Skip PlantUML validation | HC-004 | Defeats purpose of CI validation; diagrams could break without detection. |
| Trigger on every commit | HC-001 | Exceeds free tier (would use >500 min/month). Cost unacceptable. |
| Silent build failures | HC-005 | Violates core requirement (automated build validation). Would allow broken builds to merge. |

---

## Restricciones fuera de scope

| Restricción existente | Razón de exclusión |
|-------------|-------------------|
| Branch protection rules (require PR checks) | Phase 3 (RBAC). Can test workflow in Phase 1, but enforcement requires admin config. |
| Dependabot configuration | Phase 2 (Enhanced). Separate system, not core CI/CD. |
| ReadTheDocs deployment | Phase 2 (Enhanced). Hosting platform integration, not CI validation. |
| Code signing / GPG verification | Out of IACT-docs scope. Documentation doesn't require commit signing. |
| Multi-version builds (Python 3.10, 3.11, 3.12 matrix) | SC-001 violates cost limit. Phase 2: can add if cost envelope allows. |

---

## Verificación de restricciones

**Checklist para Phase 7 DESIGN/SPECIFY:**

- [ ] sphinx-build.yml respeta HC-001 (triggers, timeout < cost limit)
- [ ] ubuntu-latest runner specified (HC-002)
- [ ] python-version: 3.11 configured (HC-003)
- [ ] PlantUML installation step present if needed (HC-004)
- [ ] Sphinx exit code validation present (HC-005)
- [ ] Cost estimate documented (SC-001)
- [ ] Timeout generous (SC-002, SC-003)
- [ ] No changes to source code or deps (SC-004)

**Gate:** If any constraint violated, return to Phase 4 for clarification before proceeding.

---

## Stopping Point Manifest

| SP | Descripción | Estado |
|----|-------------|--------|
| SP-04 | Gate 4→6: usuario valida constraints antes de diseñar especificación | ⏳ Pendiente |

---

**Document created:** 2026-04-25 23:45:00  
**Status:** Borrador — Ready for user approval  
**Next:** User confirms constraints, then proceed to Phase 7 DESIGN/SPECIFY  
**Integration:** Exit conditions must verify all constraints are respected in Phase 7+ artifacts

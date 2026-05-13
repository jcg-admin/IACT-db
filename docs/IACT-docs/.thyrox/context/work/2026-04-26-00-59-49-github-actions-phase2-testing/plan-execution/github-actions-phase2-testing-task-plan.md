```yml
created_at: 2026-04-26 00:59:49
project: IACT-docs
work_package: 2026-04-26-00-59-49-github-actions-phase2-testing
phase: Phase 8 — PLAN EXECUTION
author: Claude
status: Borrador
version: 1.0.0
total_tasks: 8
```

# Task Plan — GitHub Actions Phase 2 Posterior Testing

## Overview

**Work Package:** github-actions-phase2-testing  
**Objective:** Live validation of Phase 1 CI/CD automation (6 files) via real PR, templates, Dependabot, cost monitoring  
**Duration:** ~2 hours (mostly waiting for Dependabot weekly trigger)  
**Scope:** 8 atomic testing tasks  
**Prerequisites:** Phase 1 WP merged to main branch  

---

## Tasks

### Grupo 1 — Workflow Validation

- [ ] **T-001** Create test feature branch
  - Create branch: `feature/github-actions-test`
  - Make minimal documentation change (e.g., typo fix in README)
  - Push to trigger sphinx-build.yml workflow
  - **Validación:** Branch exists, CI/CD triggered
  - **Tiempo estimado:** 5 min

- [ ] **T-002** Validate Sphinx build execution
  - Monitor GitHub Actions tab for sphinx-build.yml run
  - Verify: build succeeds (✓ green check)
  - Verify: build time < 10 minutes (should be ~45 sec + overhead)
  - Verify: exit code 0
  - **Validación:** Build passes, timing acceptable, no errors in logs
  - **Tiempo estimado:** 10 min (mostly waiting for workflow)

- [ ] **T-003** Validate artifact upload
  - Check workflow artifacts tab
  - Verify: `sphinx-build-html` artifact exists (success case)
  - Verify: artifact contains `index.html` (sample from `source/_build/html/`)
  - Verify: artifact retention = 7 days (configured in workflow)
  - **Validación:** Artifact uploaded, size > 100KB (HTML content)
  - **Tiempo estimado:** 5 min

### Grupo 2 — Template Validation

- [ ] **T-004** Test issue templates rendering
  - Go to Issues > New issue (on test branch, before merge)
  - Verify: Issue template selector appears
  - Verify: Three options visible:
    - Bug Report (bug-report.yml)
    - Feature Request (feature-request.md)
    - Questions → GitHub Discussions (config.yml redirect)
  - Click "Bug Report" → verify form fields appear (description, reproduction, expected, actual, environment)
  - **Validación:** All 3 templates render correctly, form fields present
  - **Tiempo estimado:** 10 min

- [ ] **T-005** Test PR template appearance
  - Create PR from feature branch to main
  - Verify: PR description field pre-populates with template
  - Verify: Checklist items visible (local testing, RST formatting, commits, documentation, breaking changes)
  - Verify: "Type of Change" section present (bug fix, feature, docs, config, breaking)
  - Verify: Testing instructions section present
  - **Validación:** PR template renders, all sections present, checklist functional
  - **Tiempo estimado:** 5 min

### Grupo 3 — Dependabot Validation

- [ ] **T-006** Verify Dependabot schedule
  - Settings > Code security & analysis > Dependabot
  - Verify: Dependabot enabled
  - Verify: Schedule shows "weekly" (configurable)
  - Verify: Last check timestamp (should be recent, within 24h of Phase 1 merge)
  - Note: First PR may take up to 7 days; document observed timeline
  - **Validación:** Dependabot dashboard shows enabled + weekly schedule
  - **Tiempo estimado:** 5 min

- [ ] **T-007** Observe Dependabot PR creation (optional, 1-week wait)
  - If dependencies need updates: Dependabot creates automatic PR
  - Verify: PR title format: "chore(deps): bump {package} from X to Y"
  - Verify: Sphinx build workflow runs on Dependabot PR
  - Verify: Build passes with updated deps
  - If no updates this week: Document "all dependencies current"
  - **Validación:** Dependabot PR created OR confirmed current
  - **Timing:** Deferred (requires 1 week waiting for weekly trigger)
  - **Tiempo estimado:** 5 min (if PR appears) OR skip if no updates

### Grupo 4 — Cost Monitoring

- [ ] **T-008** Baseline cost audit
  - GitHub Settings > Billing and plans > Usage (Actions)
  - Record: Current month's usage (in minutes)
  - Compare to baseline: 40-50 min/month estimate
  - Record timestamp
  - Verify: No charges (should show $0.00 for public repo)
  - Verify: Spending limit is $0 (or set appropriately)
  - Create audit log: `.thyrox/context/work/2026-04-26-00-59-49-github-actions-phase2-testing/track/github-actions-phase2-cost-audit.md`
  - **Validación:** Cost data recorded, $0 confirmed, spending limit verified
  - **Tiempo estimado:** 10 min

---

## Dependencias

```
T-001 (Create branch) — BLOQUEANTE
    ↓
T-002 (Build validation) — SECUENCIAL
    ↓
T-003 (Artifact validation) — SECUENCIAL
    
T-004 (Issue templates) — INDEPENDIENTE (no branch merge required, can test on branch)
T-005 (PR template) — DEPENDENCIA: T-001 (requires PR creation)

T-006 (Dependabot schedule) — INDEPENDIENTE (check dashboard anytime)
T-007 (Dependabot PR) — DEFERRED (1-week wait)

T-008 (Cost audit) — INDEPENDIENTE (check dashboard anytime)
```

**Ruta crítica:** T-001 → T-002 → T-003 → T-005 (8 min core path + 10 min waiting for CI = ~18 min)

**Tiempo total:** 
- Core path: T-001 + T-002 + T-003 + T-004 + T-005 + T-008 = ~45 min
- Optional: T-006, T-007 (can do in parallel; T-007 deferred to next week)

---

## Criterios de Completitud

**Tarea completa = TODO lo siguiente es TRUE:**

- [ ] Paso ejecutado según especificación
- [ ] Validación realizada (mensajes de error capturados si aplica)
- [ ] Resultado documentado en audit log
- [ ] Decisión: PASS (todo funciona) o FAIL (encontró issue)

**Gate 8→11:** Todas las tareas completadas (excepto T-007 deferred)

---

## Blockers/Riesgos

| Riesgo | Probabilidad | Acción |
|--------|------------|--------|
| Workflow doesn't trigger | BAJA | Check GitHub Actions tab; re-push if needed |
| Build fails on CI but passed locally | MEDIA | Review workflow logs; check Python/PlantUML versions |
| Templates don't render | BAJA | Verify YAML syntax; check GitHub UI rendering |
| Dependabot doesn't appear | BAJA | Check if dependencies are outdated; may require manual update |
| Cost audit shows unexpected charges | MUY BAJA | Public repo = zero overage; document if appears |

---

## Posterior Artifacts

**Si alguna tarea FALLA:**
1. Create error log: `.thyrox/context/work/2026-04-26-00-59-49-github-actions-phase2-testing/track/github-actions-phase2-errors.md`
2. Document issue + screenshot
3. Decide: Fix in Phase 1 (if bug) vs. Accept limitation (if design)
4. Create corrective task T-009, T-010, etc. if needed

**Si todas las tareas PASAN:**
1. Create success log: `.thyrox/context/work/2026-04-26-00-59-49-github-actions-phase2-testing/track/github-actions-phase2-validation-success.md`
2. Archive feature branch
3. Document lessons learned
4. Merge feature/github-actions-test to main (if not already)

---

## Instrucciones para Ejecución (Phase 10)

1. **Timing:** Execute after Phase 1 WP merged to main
2. **Environment:** GitHub UI (browser) + terminal (git commands)
3. **Reporting:** Create track/ artifacts documenting results
4. **Timeline:** 
   - Core validation: ~1 hour
   - Dependabot observation: Deferred to next week
   - Cost audit: Monthly (Day 1 of each month)

---

**Task Plan completado:** 2026-04-26 00:59:49  
**Status:** Borrador — Ready for Phase 10 EXECUTE cuando Phase 1 esté merged  
**Next Step:** Merge Phase 1 WP to main, luego ejecutar Phase 10 (testing)

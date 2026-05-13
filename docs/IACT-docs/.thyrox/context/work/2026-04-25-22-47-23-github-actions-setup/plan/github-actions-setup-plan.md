```yml
created_at: 2026-04-25 23:40:00
project: IACT-docs
work_package: 2026-04-25-22-47-23-github-actions-setup
phase: Phase 6 — SCOPE
author: Claude
status: Borrador
version: 1.0.0
```

# Plan — GitHub Actions Setup (Phase 1: Essential CI/CD Automation)

## Scope Statement

**Problema:** IACT-docs documentation project lacks automated CI/CD validation, leading to risk of broken builds being merged to main branch without detection.

**Usuarios:** 
- Documentation contributors: Will see automated feedback on PRs (build validation, template compliance)
- Project maintainers: Will have confidence that main branch builds successfully
- CI/CD system: Will validate Sphinx builds on every PR and push

**Criterios de éxito (Verificables):**
- ✅ 5 files created in `.github/` directory (templates + workflow)
- ✅ sphinx-build.yml workflow triggers on every PR to main
- ✅ Build validation passes or fails with clear error messages
- ✅ Issue templates guide contributors with structured forms
- ✅ PR template provides contribution checklist
- ✅ Monthly cost estimate remains <3% of GitHub Actions free tier (under 60 min/month)
- ✅ Zero breaking changes to existing codebase
- ✅ Documentation of all 5 files committed with conventional commits

---

## In-Scope (Phase 1: Essential)

**Configuration files to create (5 total):**

### Issue Templates (3 files)

1. **`.github/ISSUE_TEMPLATE/config.yml`**
   - Configures issue template menu (bug, feature request, question)
   - Maps to markdown/yaml template files
   - Estimated effort: 15 minutes

2. **`.github/ISSUE_TEMPLATE/bug-report.yml`**
   - Structured bug report form with fields: title, description, reproduction steps, expected vs actual, environment
   - Pre-populated with Sphinx version and extension hints
   - Estimated effort: 20 minutes

3. **`.github/ISSUE_TEMPLATE/feature-request.md`**
   - Feature request template with sections: motivation, proposed solution, alternatives, acceptance criteria
   - Markdown format (simpler than YAML form)
   - Estimated effort: 15 minutes

### Pull Request Template (1 file)

4. **`.github/PULL_REQUEST_TEMPLATE.md`**
   - Checklist: reviewed changes, tested locally, docs updated, follows RST conventions, commit messages conventional
   - Linked to GUIDELINES.rst for contribution standards
   - Estimated effort: 15 minutes

### GitHub Actions Workflow (1 file)

5. **`.github/workflows/sphinx-build.yml`**
   - Triggers on: push to main, PR to main
   - Steps: checkout, set up Python 3.11, install dependencies (pip install -e .), run Sphinx build (make html)
   - Outputs: success (green) or failure (red) with error log
   - Timeout: 15 minutes (covers Sphinx + PlantUML compilation)
   - Cost: ~50 minutes/month (under 3% of 2000 min free tier)
   - Estimated effort: 1.5 hours

---

## Out-of-Scope (Phase 2: Enhanced — Deferred)

| Excluido | Razón | Phase |
|---|---|---|
| **rst-lint.yml workflow** | RST linting/formatting checks deferred to Phase 2 (enhancement, not blocking) | Phase 2 |
| **dependabot.yml config** | Automated dependency updates deferred to Phase 2 (operational, not blocking) | Phase 2 |
| **Sphinx documentation hosting** | ReadTheDocs deployment deferred to Phase 2 (requires account setup, not CI/CD core) | Phase 2 |
| **Slack/email notifications** | Build failure notifications deferred to Phase 2 (nice-to-have, not MVP) | Phase 2 |
| **Branch protection rules** | GitHub branch protection enforcement tested but not configured (requires admin role) | Phase 3 |
| **Code coverage tracking** | Coverage metrics deferred (Sphinx docs don't need coverage, not applicable) | Out of project scope |
| **Release automation** | Automated releases/tags deferred (docs don't have releases like code) | Future consideration |

---

## Estimación de esfuerzo

| Componente | Tareas | Horas |
|---|---|---|
| Issue template config (config.yml) | T-001 | 0.25 |
| Bug report template (bug-report.yml) | T-002 | 0.33 |
| Feature request template (feature-request.md) | T-003 | 0.25 |
| Pull request template (PULL_REQUEST_TEMPLATE.md) | T-004 | 0.25 |
| Sphinx build workflow (sphinx-build.yml) | T-005 | 1.5 |
| **Subtotal Implementation** | **5 tasks** | **~2.6 hours** |
| Phase 6 PLAN | Plan definition | 1.0 |
| Phase 7 DESIGN/SPECIFY | Specification details | 1.0 |
| Phase 8 PLAN EXECUTION | Task breakdown & DAG | 0.5 |
| Phase 10 EXECUTE | File creation, testing, validation | 2.0 |
| Phase 11 TRACK/EVALUATE | Lessons learned, changelog | 0.5 |
| **Total Project** | | **~7.5 hours** |

**Classification:** MEDIANO (2-8 hours)  
**Phases activas:** 1 ✅, 6, 4 (REQUIRED), 7, 8, 10, 11 (optional: 2, 3, 5, 9, 12)

**NOTA:** Phase 4 CONSTRAINTS es CRÍTICA — debe completarse antes de Phase 7 DESIGN/SPECIFY

---

## Risk Mitigation (from github-actions-setup-risk-register.md)

| Risk | Severity | Mitigation | Owner |
|------|----------|-----------|-------|
| R-001: Workflow configuration error | MEDIUM | Test workflow locally with `act`; start minimal, add incrementally | Phase 10 |
| R-002: YAML syntax errors | LOW | Use GitHub's visual workflow editor; test before commit | Phase 7 |
| R-006: Sphinx environment mismatch | MEDIUM | Use Ubuntu runner; install PlantUML explicitly; document environment | Phase 8 |
| R-007: PlantUML timeout | LOW | Set 15-20 min timeout; can optimize later if needed | Phase 8 |
| R-008: Dependency conflict | MEDIUM | Use pyproject.toml (single source of truth); test locally first | Phase 7 |

All 8 risks mitigated at appropriate phases; no blockers identified for Phase 1.

---

## Constraints Validation (Phase 4 CONSTRAINTS — REQUIRED)

**This plan respects all HARD and SOFT constraints defined in Phase 4:**

### HARD Constraints — Scope compliance

| Constraint | Requirement | Plan compliance | Details |
|---|---|:---:|---|
| **HC-001: GitHub Actions free tier (2000 min/month)** | Target: <60 min/month | ✅ | Triggers: PR + main only (not every commit). Estimated 50 min/month = 2.5% of limit |
| **HC-002: Linux runner (Ubuntu)** | Must use ubuntu-latest | ✅ | workflow sphinx-build.yml explicitly specifies `runs-on: ubuntu-latest` |
| **HC-003: Python 3.11 compatibility** | >=3.10 from pyproject.toml | ✅ | workflow will specify `python-version: '3.11'`; Sphinx 9.0.4 requires >=3.10 |
| **HC-004: PlantUML Java dependency** | Java + PlantUML must be available | ✅ | workflow includes apt-get install plantuml (or relies on preinstalled); Ubuntu runners include Java |
| **HC-005: Sphinx exit code validation** | Build must fail if Sphinx fails | ✅ | workflow checks `make html` exit code; failure blocks PR merge |

**All HC respected:** ✅ Scope is technically feasible

### SOFT Constraints — Design preferences

| Constraint | Preference | Plan alignment | Trade-off |
|---|---|:---:|---|
| **SC-001: Cost minimization [HIGH]** | <60 min/month | ✅ | Estimate 50 min/month; PR-only triggers keep cost low |
| **SC-002: Build speed [MEDIUM]** | <10 min ideally, <15 max | ✅ | Timeout set to 15 min; covers Sphinx + PlantUML; within acceptable range |
| **SC-003: PlantUML compilation [MEDIUM]** | 15-20 min timeout | ✅ | Single step timeout generous; allows PlantUML to compile without pressure |
| **SC-004: Backward compatibility [HIGH]** | No breaking changes to source | ✅ | ONLY creates new files in `.github/`; no modifications to source/, conf.py, or pyproject.toml |

**All SC respected:** ✅ Scope aligns with preferences

### Constraints Impact on Phase 7 DESIGN/SPECIFY

**Phase 7 specifications MUST:**
1. Use `runs-on: ubuntu-latest` (HC-002)
2. Use `python-version: '3.11'` (HC-003)
3. Include `apt-get install plantuml` OR rely on preinstalled (HC-004)
4. NOT have `continue-on-error: true` for build step (HC-005)
5. Specify `timeout-minutes: 15` for build step (SC-003)
6. Trigger only on PR and main branch push (HC-001, SC-001)

**Verification checklist for Phase 7:**
- [ ] All HC-001..005 specifications integrated in SPEC-005 (sphinx-build.yml spec)
- [ ] All SC-001..004 preferences documented in SPEC-001..SPEC-004 (templates)
- [ ] No specification violates any constraint
- [ ] Cost/timeout/runner/Python version all explicitly documented

---

## Success Metrics (Go/No-Go Criteria)

### Phase 10 EXECUTE: Success = All TRUE
- [ ] 5 files created in `.github/` with correct paths
- [ ] sphinx-build.yml workflow file syntax valid (no YAML errors)
- [ ] Workflow triggers on PR (manual test: create PR on feature branch)
- [ ] Build output readable (success or clear error messages)
- [ ] PlantUML diagrams compile without timeout
- [ ] Cost estimate validated (<60 min/month simulated)
- [ ] All commits follow conventional format (type(scope): description)

### Phase 11 TRACK/EVALUATE: Success = All TRUE
- [ ] Execution time tracked against estimate (6-9h expected)
- [ ] Lessons learned documented (what went well, what to improve)
- [ ] Risk register closed (all 8 risks addressed or deferred)
- [ ] Changelog created with summary of Phase 1 completion

---

## Timeline

| Phase | Duration | Dates | Notes |
|-------|----------|-------|-------|
| Phase 1: DISCOVER | ✅ 1h | 2026-04-25 22:47 - 23:47 | Completed |
| Phase 6: PLAN | ⏳ 1h | 2026-04-25 (NOW) | Scope definition |
| Phase 4: CONSTRAINTS | ⏳ 0.75h | 2026-04-25 (NEXT) | **REQUIRED** — HC/SC that bound phase 7 |
| Phase 7: DESIGN/SPECIFY | 1h | 2026-04-25 | Respects Phase 4 constraints |
| Phase 8: PLAN EXECUTION | 0.5h | 2026-04-25 | Task breakdown T-001..005 |
| Phase 10: EXECUTE | 2-6h | 2026-04-25 or 2026-04-26 | File creation & validation |
| Phase 11: TRACK/EVALUATE | 0.5h | After Phase 10 | Lessons learned & changelog |
| **Total** | **7.25-8.25 hours** | **1-2 days** | Phase 4 adds 0.75h |

---

## Dependencies & Blockers

**External dependencies:** None (GitHub Actions is free tier, no account setup needed)

**Internal dependencies:**
- Sphinx 9.0.4 already installed ✅
- PlantUML already configured ✅
- pyproject.toml already defines all dependencies ✅
- Main branch protection not required for Phase 1 (can test on feature branch first)

**Blockers:** None identified

---

## Links & References

- **Phase 1 DISCOVER:** [github-actions-setup-analysis.md](../discover/github-actions-setup-analysis.md)
- **Phase 4 CONSTRAINTS (REQUIRED):** [github-actions-setup-constraints.md](../constraints/github-actions-setup-constraints.md) — HC/SC that bound this plan
- **Risk Register:** [github-actions-setup-risk-register.md](../github-actions-setup-risk-register.md)
- **Exit Conditions:** [github-actions-setup-exit-conditions.md](../github-actions-setup-exit-conditions.md)
- **Sphinx Reference:** [sphinx-doc/sphinx .github structure](https://github.com/sphinx-doc/sphinx/tree/master/.github) (analyzed in Phase 1)
- **ROADMAP:** [ROADMAP.md](../../../../../ROADMAP.md)

---

## Approval Gate (Phase 6 → 4 → 7)

**Entry Condition:** ✅ Phase 1 DISCOVER approved  
**Exit Condition:** Scope statement + In-Scope/Out-of-Scope + Constraints validation completed  
**Status:** Ready for Phase 4 CONSTRAINTS when user approves Phase 6 PLAN

**User Approval Required:**
- [ ] Scope is clear and achievable (Phase 6)
- [ ] In-Scope (5 files) aligns with expectations
- [ ] Out-of-Scope (Phase 2) deferral is acceptable
- [ ] Timeline (7.25-8.25 hours including Phase 4, 1-2 days) is feasible
- [ ] All Hard/Soft constraints understood and scope respects them ✅ (validated above)
- [ ] Ready to proceed to Phase 4 CONSTRAINTS (required step)

**Then Phase 4 → Phase 7:**
- Phase 4 CONSTRAINTS: 0.75h (documents HC/SC)
- Phase 7 DESIGN/SPECIFY: Respects all constraints

---

**Document updated:** 2026-04-25 23:50:00  
**Status:** Updated — Integrated Phase 4 CONSTRAINTS validation  
**Next:** User confirms scope + constraint compliance, then proceed to Phase 4 CONSTRAINTS, then Phase 7 DESIGN/SPECIFY

```yml
created_at: 2026-04-26 00:59:49
updated_at: 2026-04-26 00:59:49
project: IACT-docs
work_package: 2026-04-26-00-59-49-github-actions-phase2-testing
phase: Phase 1 — DISCOVER
status: Activo
```

# Risk Register — GitHub Actions Phase 2 Testing WP

---

## R-001: Workflow Doesn't Trigger on PR

**Severity:** MEDIUM  
**Probability:** LOW  
**Current State:** POTENTIAL

### Description
PR created but sphinx-build.yml doesn't execute (trigger configuration issue).

### Impact
- Cannot validate CI/CD automation
- Delays testing timeline

### Mitigation
1. Verify workflow is pushed to main branch
2. Verify triggers in yaml: `on: [pull_request, push]` with `branches: [main]`
3. Create PR from test branch to main
4. If no trigger: manually run workflow via GitHub UI
5. Check workflow logs for syntax/configuration errors

### Owner: Phase 10 (EXECUTE)

---

## R-002: Build Fails on CI (Environment Mismatch)

**Severity:** MEDIUM  
**Probability:** LOW  
**Current State:** POTENTIAL

### Description
Sphinx build succeeds locally but fails on ubuntu-latest runner (Python version, PlantUML, dependencies).

### Impact
- Workflow marked as failed (red X)
- Cannot validate CI/CD reliability
- Requires troubleshooting/debugging

### Mitigation
1. Review workflow logs for specific error message
2. Check Python 3.11 availability: `actions/setup-python@v4` handles this
3. Check PlantUML: Java pre-installed on ubuntu-latest
4. Check dependencies: pip caching enabled, installation should work
5. If failure: update workflow (e.g., add `apt-get install` step if needed)

### Owner: Phase 10 (EXECUTE)

---

## R-003: Templates Don't Render Correctly

**Severity:** LOW  
**Probability:** LOW  
**Current State:** POTENTIAL

### Description
Issue/PR templates exist but don't appear in GitHub UI or have rendering errors (YAML/Markdown syntax).

### Impact
- Templates not available to contributors
- Defeats purpose of Phase 1 setup
- Low impact: templates are optional (not required for issues)

### Mitigation
1. Verify YAML syntax: no parsing errors in bug-report.yml, dependabot.yml
2. Check GitHub UI: Issues > New > template selector
3. If not appearing: Verify files are in correct path (`.github/ISSUE_TEMPLATE/`)
4. Check GitHub docs for template naming conventions
5. If syntax error: Fix YAML/Markdown in workflow

### Owner: Phase 10 (EXECUTE)

---

## R-004: Dependabot Doesn't Create PRs

**Severity:** LOW  
**Probability:** LOW  
**Current State:** POTENTIAL

### Description
Dependabot.yml configured but no dependency update PRs created (no outdated dependencies, or Dependabot not enabled).

### Impact
- Cannot validate Dependabot automation
- Low impact: automation would work when updates are available
- Acceptable: "no updates available" is valid outcome

### Mitigation
1. Check GitHub Settings > Code security & analysis > Dependabot
2. Verify Dependabot enabled (toggle on)
3. Wait 1-7 days for weekly schedule trigger
4. If no PR after 1 week:
   - Check if dependencies are current (pip show -r requirements.txt)
   - Manually bump a dependency version to test (optional)
   - Document: "All dependencies current as of [date]"

### Owner: Phase 10 (EXECUTE) / Ongoing (TRACK)

---

## R-005: Unexpected Cost Charges

**Severity:** LOW  
**Probability:** VERY LOW  
**Current State:** UNLIKELY

### Description
GitHub Actions usage charged despite being public repo with 2000 free min/month.

### Impact
- Unexpected bill
- Zero actual risk (public repos don't get charged)

### Mitigation
1. Verify repository is PUBLIC (not private)
2. Verify spending limit in GitHub Settings: $0 or set appropriately
3. Monitor usage dashboard monthly
4. If charge appears: GitHub support to investigate (should not happen)

### Owner: Ongoing (TRACK)

---

## Risk Summary

| Risk | Phase 1 | Phase 10 | Ongoing |
|------|---------|----------|---------|
| R-001 (Trigger) | Identify | Monitor trigger | Track |
| R-002 (Build fail) | Identify | Test execution | Track |
| R-003 (Templates) | Identify | Validate rendering | Monitor |
| R-004 (Dependabot) | Identify | Check schedule | Monitor (weekly) |
| R-005 (Cost) | Identify | Audit | Track monthly |

---

**Risk Register Status:** ACTIVE  
**Total Risks Identified:** 5  
**High-risk items:** 0  
**Probability of issues:** LOW (~5% chance any risk materializes)  
**Date:** 2026-04-26 00:59:49

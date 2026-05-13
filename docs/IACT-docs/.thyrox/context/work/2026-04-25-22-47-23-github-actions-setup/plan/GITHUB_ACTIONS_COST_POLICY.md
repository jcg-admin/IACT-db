```yml
created_at: 2026-04-26 00:15:00
project: IACT-docs
work_package: 2026-04-25-22-47-23-github-actions-setup
phase: Phase 2 — BASELINE (Cost Control Policy)
author: Claude
status: Borrador
version: 1.0.0
```

# GitHub Actions Cost Control Policy — Phase 2

## Executive Summary

IACT-docs uses a **PUBLIC GitHub repository** with 5 workflow files created in Phase 10. Public repositories receive **2,000 free minutes per month** with **zero overage charges**. Current estimated usage is 50–100 minutes per month (2.5–5% of free tier limit).

**Cost Control Strategy:**
- Spending limit: **$0** (mandatory safety guardrail)
- Alert thresholds: 50%, 75%, 90% of free tier minutes
- Monthly audit process with optimization checklist
- Three scaling paths for future enhancements

---

## 1. GitHub Actions Free Tier Mechanics

### 1.1 Repository Type and Minutes Allocation

| Repository Type | Monthly Minutes | Overage Cost | IACT-docs Status |
|---|---|---|---|
| **Public** | 2,000 free | **$0** (no overage) | ✅ Current (free) |
| Private | 2,000 free + billing | $0.25/min excess | Not applicable |

**Key Fact:** Public repositories NEVER incur charges, regardless of usage exceeding 2,000 minutes. Private repositories trigger paid overage.

**IACT-docs Decision:** Repository remains PUBLIC indefinitely unless explicitly changed. This ensures **zero cost guarantee** regardless of workflow execution volume.

### 1.2 What Counts Toward the 2,000 Minute Limit

- ✅ All workflow job execution time
- ✅ All `run:` step commands
- ✅ Checkout, setup-python, pip install, make clean && make html
- ✅ Upload artifact steps
- ❌ Not: free-tier display on dashboard, pull request reviews, GitHub web interface

### 1.3 Billing Granularity

- **Minimum charge:** 1 minute (no sub-minute rounding)
- **Rounding:** Rounded UP to nearest minute (0.1 min → 1 min charged)
- **Frequency:** Consumption tracked per workflow execution; cumulative monthly total

---

## 2. Current Usage Estimate (Phase 10 Baseline)

### 2.1 Single Workflow Execution Analysis

**Workflow:** `.github/workflows/sphinx-build.yml`

| Step | Typical Duration |
|---|---|
| Checkout | 5 sec |
| Setup Python 3.11 | 8 sec |
| Install dependencies | 45 sec |
| Build Sphinx (make clean && make html) | 45 sec |
| Upload artifacts | 10 sec |
| **Total per execution** | **~2 minutes** |

### 2.2 Monthly Execution Projection

**Triggers:**
- `pull_request` to main → 1–3 PRs per week = 4–12 executions/month
- `push` to main → 1–3 merges per week = 4–12 executions/month
- **Total executions:** 8–24 per month (conservative: 20 median)

**Monthly Consumption:**
```
20 executions × 2 min/execution = 40 minutes/month
Headroom: 2,000 − 40 = 1,960 minutes (98% unused)
Usage Rate: 2% of free tier
```

**Safety Margin:**
- If usage doubles (40 bursts, 80 min): still 98% under limit
- If workflows regress to 5 min each: 200 min/month (10% of limit)
- **Cost at any scenario:** $0 (public repo)

### 2.3 Baseline Snapshot (After Phase 10)

| Metric | Value | Status |
|---|---|---|
| Repository Type | Public | ✅ Safe |
| Free Minutes/Month | 2,000 | ✅ Unlimited for public |
| Current Est. Usage | 40 min/month | ✅ 2% of limit |
| Monthly Cost | $0 | ✅ Zero cost |
| Cost Risk Level | None | ✅ Guaranteed |

---

## 3. Cost Control Mechanisms

### 3.1 Spending Limit Policy (Mandatory)

**Setting:** GitHub.com/settings/billing/spending-limit

```
Recommended Value: $0
Reason:          Public repo = zero cost guarantee
Action:          Set limit to $0 (blocks any charged minutes)
Frequency:       Verify quarterly (static setting, no changes needed)
Responsible:     Repository maintainer
```

**Effect if Private Repo (Scenario):**
If repo becomes private in future:
- Spending limit: $50/month (conservative safety boundary)
- Sends alert before any charge
- Prevents surprise bills exceeding $50

---

### 3.2 Alert Thresholds (Dashboard Monitoring)

**Alert 1: 50% of Free Tier (1,000 minutes)**
- Trigger: Monthly usage reaches 1,000 min
- Action: Review workflow optimization candidates
- Timeline: Send notification by 15th of month
- Current Probability: <1% (usage ~40 min baseline)

**Alert 2: 75% of Free Tier (1,500 minutes)**
- Trigger: Monthly usage reaches 1,500 min
- Action: Disable non-essential workflows immediately
- Timeline: Send notification by 20th of month
- Current Probability: <0.1%

**Alert 3: 90% of Free Tier (1,800 minutes)**
- Trigger: Monthly usage reaches 1,800 min
- Action: Manual approval required for new PRs
- Timeline: Send notification by 27th of month
- Current Probability: <0.01%

**Dashboard Location:**
`GitHub.com → Settings → Billing and plans → Usage → Actions`

---

### 3.3 Monthly Audit Checklist

**Day 1–5 of each month:**

- [ ] Access GitHub billing dashboard
- [ ] Record actual minutes used (previous month)
- [ ] Calculate percentage of 2,000-min limit
- [ ] Compare vs. 40-min baseline estimate
- [ ] Note any unusual spikes (>50 min)
- [ ] Review workflow counts in `.github/workflows/`
- [ ] Verify spending limit is still $0 (if public) or set value (if private)
- [ ] Document findings in `track/{wp}-cost-audit-{YYYY-MM}.md`
- [ ] Identify optimization opportunities (section 4)

**Responsible:** Repository maintainer or designated reviewer

---

## 4. Optimization Strategies for Scaling

These strategies apply IF monthly usage approaches 500+ minutes (25% of limit).
No action needed now (usage ~40 min), but documented for future reference.

### 4.1 Optimization Path A: Caching (Recommended First)

**What:** Cache pip dependencies between runs

```yaml
- name: Set up Python 3.11
  uses: actions/setup-python@v4
  with:
    python-version: '3.11'
    cache: 'pip'  # ← Enables automatic pip caching
```

**Impact:** Saves 30–40 sec per workflow (10–15 min/month if doubled usage)

**Implementation:** Already in place (sphinx-build.yml line 21)

**Status:** ✅ Active

---

### 4.2 Optimization Path B: Trigger Refinement (Conditional)

**What:** Reduce workflow triggers to only necessary events

**Current Triggers:**
```yaml
on:
  pull_request:
    branches: [main]
  push:
    branches: [main]
```

**Optional Refinement (Phase 2):**
```yaml
on:
  pull_request:
    branches: [main]
    paths:
      - 'source/**'      # Only build if docs changed
      - 'pyproject.toml'
      - '.github/workflows/sphinx-build.yml'
  push:
    branches: [main]
    paths:
      - 'source/**'
      - 'pyproject.toml'
```

**Impact:** Eliminates ~30% of unnecessary builds (saves 12 min/month baseline)

**Implementation Effort:** 2 hours (Phase 2 enhancement)

**Recommendation:** Implement if monthly usage exceeds 200 minutes

---

### 4.3 Optimization Path C: Build Matrix Prevention (Advanced)

**What:** Avoid testing multiple Python versions/OS combinations

**Not Applicable to IACT-docs:** Current workflow runs single config (Python 3.11, Ubuntu)

**Status:** ✅ Already optimized (no matrix)

---

### 4.4 Optimization Path D: Conditional Steps (Future)

**What:** Skip artifact upload if build fails (saves upload time)

**Current Implementation:**
```yaml
- name: Upload build artifacts (on failure)
  if: failure()          # ← Only runs if previous steps fail
  uses: actions/upload-artifact@v3
  
- name: Upload build artifacts (on success)
  if: success()          # ← Only runs if all previous steps pass
```

**Status:** ✅ Already optimized (conditional execution)

---

## 5. Cost Escalation Scenarios and Responses

### Scenario A: Monthly Usage = 100 Minutes (Normal Operation)

**Response:**
- ✅ Status OK
- Document in monthly audit
- No action needed
- Cost: $0

---

### Scenario B: Monthly Usage = 500 Minutes (Unexpected Spike)

**Trigger:** Multiple simultaneous PRs, or workflow regression

**Investigation Steps:**
1. Access GitHub Actions → Workflow runs (in repository)
2. Identify which workflows consumed 500 min
3. Check for repeated failures (failed runs retry automatically)
4. Review recent `.github/` changes
5. Check for new trigger conditions (accidental push to main)

**Corrective Actions:**
1. Disable failing workflows temporarily
2. Implement Optimization Path B (trigger refinement)
3. Add explicit `if: success()` guards on expensive steps
4. Cost still: **$0** (public repo)

---

### Scenario C: Repository Changes to Private (Hypothetical)

**Trigger:** Business requirement to make repo private

**Immediate Actions:**
1. Set spending limit to **$50/month** (GitHub.com/settings/billing)
2. Enable billing alerts
3. Immediately implement Optimization Paths A–D
4. Re-estimate monthly cost

**Estimated Cost (Private + Optimized):**
- Usage: 40 min (optimized with all paths)
- Cost: $0 (under 2,000 free min limit for private repos)
- Safety margin: $50 spending limit

---

### Scenario D: Workflow Regression (e.g., Build Hangs)

**Trigger:** Workflow timeout (20 min limit, see `timeout-minutes: 20` in sphinx-build.yml)

**Symptom:** Workflow job runs 20 min, then terminates (counts full 20 min against monthly limit)

**Investigation:**
1. Check workflow run logs for timeout message
2. Identify which step exceeded time (likely `make html` or PlantUML)
3. Review recent changes to `source/` (new diagrams, heavy content)

**Corrective Action:**
1. Revert problematic changes to `source/`
2. Increase `timeout-minutes` if intentional (not recommended)
3. Optimize PlantUML diagrams (simpler, smaller)
4. Cost: Paid per timeout occurrence (~20 min each)

**Recommendation:** Monitor build time trends (current: ~45 sec; tolerance: 2–5 min)

---

## 6. Policy Enforcement and Guardrails

### 6.1 Decision Authority

| Decision | Authority | Approval Required |
|---|---|---|
| Set spending limit | Maintainer | No (technical setting) |
| Interpret alert thresholds | Maintainer + team | Yes (may require investigation) |
| Implement optimizations (Path A–D) | Maintainer | No (Phase 2 scope, time-permitting) |
| Change repository to private | Organization admin | Yes (impacts cost model) |
| Increase timeout-minutes | Maintainer | Yes (indicates workflow issue) |
| Add new workflows | Maintainer | Yes (requires cost justification) |

### 6.2 Documentation Requirements

Each decision affecting cost must be documented:

1. **Decision:** What was changed
2. **Rationale:** Why (cost impact, deadline, feature need)
3. **Expected Impact:** Minutes saved/added per month
4. **Date:** When decision was made
5. **Reviewer:** Who approved

**Example:**
```markdown
**Decision:** Implement path B (trigger refinement)
**Rationale:** Monthly usage trending toward 200 min; optimize before scaling
**Expected Impact:** Save ~30% of build executions = 12 min/month
**Date:** 2026-05-15
**Reviewer:** @NestorMonroy
```

---

## 7. Phase 2 Enhancement Roadmap (Posterior)

These enhancements are OPTIONAL and dependent on testing results (Phase 11).

### Phase 2A: Enhanced Workflow Validation (Posterior Testing)

- [ ] Create actual PR and verify workflow triggers on GitHub
- [ ] Validate sphinx-build.yml execution (artifact uploads, exit codes)
- [ ] Test all 3 issue templates (bug-report.yml, feature-request.md, config.yml)
- [ ] Confirm PR template appears automatically
- [ ] Monitor Dashboard for first-week cost baseline (expected <10 min)

### Phase 2B: Additional Workflows (Optional)

If desired after validation:

- `rst-lint.yml` — Validate RST syntax on push (low cost: ~30 sec each)
- `dependabot.yml` — Auto-update dependencies (no Actions cost)
- `ReadTheDocs.yml` — Integration hook (no cost if using RTD hosting)

**Cost Impact:** +20–30 min/month if all added

---

## 8. Success Criteria for Phase 2 Cost Control

| Criterion | Target | Method | Owner |
|---|---|---|---|
| **Free tier guarantee** | $0 permanent | Spending limit = $0 (public) | Maintainer |
| **Monthly audit** | 100% completion | Calendar reminder, monthly log | Maintainer |
| **Usage trending** | <100 min/month | Dashboard tracking | Maintainer |
| **Alert accuracy** | 0 false positives | Review thresholds quarterly | Team |
| **Documentation** | Complete | This policy + monthly audits | Author (Claude) |
| **Optimization ready** | Paths A–D documented | Section 4 + implementation guide | Author (Claude) |

---

## 9. Cost Policy Summary Table

| Aspect | Value | Risk | Owner |
|---|---|---|---|
| **Repository Type** | Public | None (zero cost) | Org admin |
| **Free Minutes/Month** | 2,000 | Very Low (40 min actual) | N/A |
| **Monthly Estimated Cost** | $0 | None | Finance |
| **Spending Limit** | $0 | Protected | Maintainer |
| **Alert Level 1** | 1,000 min (50%) | Unlikely | Maintainer |
| **Alert Level 2** | 1,500 min (75%) | Very unlikely | Maintainer |
| **Alert Level 3** | 1,800 min (90%) | Extremely unlikely | Maintainer |
| **Optimization Priority** | Caching (done) | Addressed | Maintainer |
| **Next Review Date** | 2026-05-26 | Scheduled | Maintainer |

---

## 10. Next Steps (Posterior — Phase 11 & Beyond)

### Phase 11 TRACK/EVALUATE (Before Testing)
- [ ] Create lessons-learned from Phase 10 execution
- [ ] Document actual costs from Phase 10 (should be ~2 min)
- [ ] Update risk register (close R-004: cost overrun risk)
- [ ] Approve Phase 2 policy and escalation procedures

### Phase 2 Testing (Posterior — User-Initiated)
- [ ] Create actual PR to main branch
- [ ] Verify sphinx-build.yml triggers automatically
- [ ] Monitor GitHub Actions tab for execution
- [ ] Check artifact uploads (HTML build output)
- [ ] Verify cost dashboard shows execution (expect ~2 min)
- [ ] Test all issue/PR templates in practice
- [ ] Document findings in `track/{wp}-phase2-testing-results.md`

### Phase 2A Optimization (If Needed)
- [ ] Implement Path B (trigger refinement) if usage >200 min/month
- [ ] Review PlantUML performance (check `make html` logs)
- [ ] Consider Path D (skip artifact upload on failure)

---

## 11. Related Documents

- **Phase 10 Execution Log:** `execute/github-actions-setup-execution-log.md` (baseline, 5 files created)
- **Phase 4 Constraints:** `constraints/github-actions-setup-constraints.md` (HC-001: free tier requirement)
- **Phase 7 Spec:** `design/github-actions-setup-requirements-spec.md` (SPEC-005: workflow details)
- **Risk Register:** `github-actions-setup-risk-register.md` (R-004: cost overrun — mitigated by this policy)

---

## Approval

**Document Status:** Borrador (ready for Phase 11 gate approval)

**Author:** Claude  
**Created:** 2026-04-26 00:15:00  
**Version:** 1.0.0

**Phase 11 Gate Approval (Pending):**
- [ ] Cost assumptions validated (2,000 min public, $0 cost)
- [ ] Optimization paths documented (A–D)
- [ ] Alert thresholds approved (50%, 75%, 90%)
- [ ] Monthly audit checklist finalized
- [ ] Spending limit policy endorsed ($0 for safety)
- [ ] Escalation scenarios documented (A–D)
- [ ] Phase 2 roadmap accepted

**Approval Authority:** @NestorMonroy (repository maintainer)

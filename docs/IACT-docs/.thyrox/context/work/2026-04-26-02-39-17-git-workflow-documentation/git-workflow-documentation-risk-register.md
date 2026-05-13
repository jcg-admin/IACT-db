```yml
created_at: 2026-04-26 02:39:17
updated_at: 2026-04-26 02:39:17
project: IACT-docs
work_package: 2026-04-26-02-39-17-git-workflow-documentation
phase: Phase 1 — DISCOVER
status: Activo
author: claude
```

# Risk Register — Git Workflow Documentation WP

---

## R-001: Inconsistent Branching Practices in Current Repository

**Severity:** MEDIUM  
**Probability:** HIGH  
**Current State:** CONFIRMED (analysis required)

### Description
Current state of Git branching practices in the repository is undocumented. Branches may follow ad-hoc patterns rather than standardized `feature/*` convention. Risk that team lacks unified understanding of merge workflow.

### Impact
- New contributors may create branches with inconsistent naming
- Merge procedures may be manual/error-prone without documentation
- PR review process may lack clear expectations
- CI/CD pipeline may not enforce standards

### Mitigation
1. Audit current branch structure
2. Document actual patterns observed
3. Establish `feature/*` convention as standard
4. Define merge-to-develop and develop-to-main rules
5. Create examples with real scenarios

### Owner: Phase 1 DISCOVER (this WP)

---

## R-002: Missing Merge Strategy Documentation

**Severity:** MEDIUM  
**Probability:** HIGH  
**Current State:** CONFIRMED (Phase 1 investigation)

### Description
No formal documentation exists for merge procedures from feature/* branches to develop, and from develop to main. Without this, team members may use conflicting merge strategies (e.g., squash vs. merge-commit, fast-forward policies).

### Impact
- Commit history may be inconsistent
- Merge conflicts harder to track
- Rollback procedures unclear
- CI/CD integration points undefined

### Mitigation
1. Define merge strategy for feature → develop (recommendation: squash for feature clarity)
2. Define merge strategy for develop → main (recommendation: merge-commit for history)
3. Document fast-forward policies
4. Create step-by-step merge procedures
5. Document error recovery scenarios

### Owner: Phase 5 STRATEGY (when deciding approach)

---

## R-003: CI/CD Integration Unclear

**Severity:** MEDIUM  
**Probability:** MEDIUM  
**Current State:** POTENTIAL (depends on CI/CD state)

### Description
Current repository uses GitHub Actions (per system setup). Unclear how git branching strategy integrates with CI/CD:
- What triggers run on feature/* branches?
- What gates must pass before merge to develop?
- What validation required before main release?

### Impact
- Broken commits may merge to develop
- Production deployments (from main) may be blocked without clear reason
- Team doesn't understand gating requirements

### Mitigation
1. Map current GitHub Actions workflows
2. Document what CI gates protect each branch
3. Include CI gates in branching documentation
4. Create troubleshooting guide for CI failures

### Owner: Phase 6 SCOPE (define constraints)

---

## R-004: Lack of Step-by-Step Examples

**Severity:** LOW  
**Probability:** HIGH  
**Current State:** CONFIRMED (by design of this WP)

### Description
Even with clear rules, team members need concrete examples: exact git commands, expected outputs, how to handle merge conflicts, how to rollback.

### Impact
- Knowledge transfer incomplete
- Onboarding new developers slow
- Team defaults to searching StackOverflow instead of internal docs

### Mitigation
1. Include 3+ realistic scenarios in documentation
2. Show exact bash commands with expected output
3. Document common mistakes and recovery
4. Create troubleshooting checklist

### Owner: Phase 7 DESIGN/SPECIFY (create examples)

---

## R-005: Multi-Branch Complexity (future risk)

**Severity:** LOW  
**Probability:** LOW  
**Current State:** POTENTIAL

### Description
This WP documents feature/* → develop → main. Future: may need hotfix/* → main, release/* branches. Current design must not preclude these extensions.

### Impact
- Documented strategy becomes obsolete if scalability needed
- Redesign required mid-project (wasted effort)

### Mitigation
1. Design Phase 6 SCOPE to anticipate future patterns
2. Document only what's needed now, but note extension points
3. Make main branches (develop, main) immutable by design

### Owner: Phase 5 STRATEGY (anticipate future)

---

## Risk Summary

| Risk ID | Severity | Status | Owner |
|---------|----------|--------|-------|
| R-001 | MEDIUM | CONFIRMED | Phase 1 DISCOVER |
| R-002 | MEDIUM | CONFIRMED | Phase 5 STRATEGY |
| R-003 | MEDIUM | POTENTIAL | Phase 6 SCOPE |
| R-004 | LOW | CONFIRMED | Phase 7 DESIGN/SPECIFY |
| R-005 | LOW | POTENTIAL | Phase 5 STRATEGY |

**Total Risks:** 5  
**Active:** 3 (R-001, R-002, R-004 require action)  
**Blocking:** None (project can proceed with discovery)

---

**Risk Register Created:** 2026-04-26 02:39:17  
**Status:** Ready for Phase 1 DISCOVER analysis

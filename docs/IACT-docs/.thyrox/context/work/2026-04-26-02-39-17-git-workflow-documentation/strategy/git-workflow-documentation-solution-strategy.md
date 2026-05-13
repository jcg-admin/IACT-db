```yml
created_at: 2026-04-26 02:45:00
project: IACT-docs
work_package: 2026-04-26-02-39-17-git-workflow-documentation
phase: Phase 5 — STRATEGY
author: claude
status: Aprobado
version: 1.0.0
```

# Phase 5 STRATEGY: Git Workflow & Branching — Solution Strategy

**Work Package:** `2026-04-26-02-39-17-git-workflow-documentation`  
**Phase:** Phase 5 — STRATEGY  
**Status:** Complete  
**Duration:** Phase 5 Strategy Analysis  
**Objective:** Evaluate merge strategies and release management approaches to inform scope and design phases

---

## Executive Summary

Phase 5 analyzed five critical decisions for Git workflow standardization:

| Decision | Recommendation | Rationale |
|----------|---|---|
| **Feature → Develop Merge** | **Merge commits (--no-ff)** | **Complete audit trail, every commit visible, THYROX WP traceability** |
| **Develop → Main Merge** | **Merge commits (--no-ff)** | **Release traceability, complete history preservation, compliance auditability** |
| **Fast-Forward Policy** | **Forbid FF on all branches** | **Explicit merge commits, clear intent capture, audit trail required** |
| **Tagging Strategy** | **Annotated tags for releases** | **Release metadata, GPG signing, regulatory compliance documentation** |
| **Release Trigger** | **Manual gate (PR review → approval required)** | **Quality approval, coordination point, audit decision log** |

**Key Principle:** Maximum traceability strategy — every commit preserved, every merge explicit, full audit trail for compliance and WP history tracking.

---

## Decision Framework

### Background: Why These Decisions Matter

**Current State:**
- Repository has develop and main branches
- No formal merge strategy defined
- IACT is compliance/documentation system (regulatory requirements)
- Team members may use conflicting approaches
- Commit history must be auditable (requirement, not nice-to-have)

**Problem:**
- Develop and main branches need clear merge strategy
- IACT's role: document RBAC, normativa, compliance — everything must be traceable
- THYROX principle (I-003): git is only persistence; history is data
- WPs tracked in git — cannot lose commits

**Critical Constraint:**
IACT is **not a typical software project**. It documents compliance rules, RBAC models, normative processes. Audit trail is regulatory requirement, not optional.

**Solution:** Maximum traceability strategy — preserve ALL commits, explicit merge boundaries everywhere, full compliance auditability.

---

## Analysis: Key Ideas & Tradeoffs

### Decision 1: Feature → Develop Merge Strategy

**Options Analyzed:**

#### Option A: Squash Merge (feature/* → develop)
```bash
# Squash merges commits before merging
git switch develop
git merge --squash feature/my-feature
git commit -m "feat(scope): description [from feature/my-feature]"
```

**Pros:**
- ✅ Linear history on develop (easier to understand progression)
- ✅ Feature rollback is atomic (single commit, single revert)
- ✅ No "merge commit clutter" from intermediate commits

**Cons:**
- ❌ **CRITICAL:** Loses all intermediate feature commits
- ❌ Cannot audit individual feature commits (they're discarded)
- ❌ Breaks WP history traceability (Phase commits lost)
- ❌ Violates THYROX principle: git is persistence

**THYROX Fit:** ❌ No — contradicts I-003 (git as only persistence) and WP history tracking

#### Option B: Merge Commits (feature/* → develop)
```bash
# Creates explicit merge commit, preserves all feature commits
git switch develop
git merge --no-ff feature/my-feature
```

**Pros:**
- ✅ **CRITICAL:** Preserves ALL feature commits completely
- ✅ Full audit trail: can inspect every commit on feature
- ✅ WP history preserved (every commit visible in main line)
- ✅ Explicit merge intent recorded (who merged, when)
- ✅ Bisect works perfectly (every commit is candidate)
- ✅ Compliance auditable (what went into each integration point)

**Cons:**
- ⚠️ History has merge commits (but this is feature, not a bug)
- ⚠️ More commits in log (necessary for traceability)

**THYROX Fit:** ✅ **Excellent** — preserves full WP history, audit trail complete, I-003 compliance

#### Option C: Rebase (feature/* → develop)
```bash
# Replays feature commits on develop (rewrites history)
git rebase develop feature/my-feature
git switch develop
git merge --ff-only feature/my-feature
```

**Pros:**
- ✅ Linear history
- ✅ Preserves commits

**Cons:**
- ❌ Rewrites history (forces push needed)
- ❌ Breaks shared branch coordination (async team can't manage)
- ❌ Risk of commit loss on rebase failure

**THYROX Fit:** ❌ No — async distributed team, force-push unsafe

**RECOMMENDATION: Merge Commits with --no-ff (Option B)**

**Rationale:**
- **IACT is a compliance system** (documentación de normativa, RBAC)
- Audit trail is non-negotiable (regulatory requirements)
- Work packages tracked in git (THYROX I-003: git as persistence)
- Every commit must be visible and auditable
- Merge commits cost: minor (one extra commit per feature)
- Merge commits benefit: complete traceability for compliance
- Team is async/distributed → explicit merge commits are feature, not bug (clear integration points)

---

### Decision 2: Develop → Main Merge Strategy

**Context:** Main is **production/release branch** — different purpose than develop.

#### Option A: Squash Merge (develop → main)
```bash
git switch main
git merge --squash develop
git commit -m "chore(release): v1.2.3 release"
```

**Pros:**
- ✅ Main branch history is "clean" (only releases)
- ✅ Very linear (easy to understand releases)

**Cons:**
- ❌ **CRITICAL:** Lose all integration history — can't audit what went into release
- ❌ Rollback requires reverting the squashed commit (all features at once)
- ❌ Regression debugging: can't see which feature caused the bug
- ❌ Release notes generation impossible (no history of changes)

**THYROX Fit:** ❌ No — Work packages tracked in git history; squashing loses WP traceability

#### Option B: Merge Commits (develop → main)
```bash
git switch main
git merge --no-ff develop
# Creates merge commit preserving develop history
```

**Pros:**
- ✅ All integration history preserved in main
- ✅ Can audit what went into each release
- ✅ Rollback individual feature if needed (revert specific commit on develop, re-merge)
- ✅ Release notes can enumerate commits
- ✅ WP traceability preserved (important for THYROX)
- ✅ Main branch explicitly documents release boundaries

**Cons:**
- ⚠️ Main history includes all commits from develop (not "clean")
- ⚠️ Some visual clutter (but necessary for production traceability)

**THYROX Fit:** ✅ Excellent — preserves work package history, enables audit trail, supports rollback

**RECOMMENDATION: Merge Commits without Fast-Forward (Option B)**

**Rationale:**
- Main is **production/release** (permanent, must be auditable)
- Every commit on main represents released code (accountability required)
- THYROX principle: git is persistence (history is data)
- Support release notes generation and regulatory compliance
- Ability to rollback individual features > clean history

---

### Decision 3: Fast-Forward Policy

**Context:** Git's default behavior allows "fast-forward" merges (no explicit merge commit).

#### Option A: Allow Fast-Forward (default)
```bash
# If develop is ahead of main by N commits and no conflicts,
# FF merge just moves main pointer forward (no merge commit created)
git merge develop  # Result: no merge commit, main = develop
```

**Pros:**
- ✅ One less commit in history
- ✅ Simpler workflow (1 step merge)

**Cons:**
- ❌ Lose explicit merge boundaries (when did release happen?)
- ❌ Hard to tell release vs integration commits
- ❌ Cannot implement required "release checkpoints"

**THYROX Fit:** ❌ No — Loses explicit versioning/tagging boundaries

#### Option B: Forbid Fast-Forward (--no-ff)
```bash
# Always create explicit merge commit, even if FF possible
git merge --no-ff develop  # Result: creates merge commit
```

**Pros:**
- ✅ Explicit merge commits for every release
- ✅ Clear release boundaries in history
- ✅ Enable version tagging on merge commits
- ✅ Release documentation explicit

**Cons:**
- ⚠️ One extra commit per release (minor cost)

**THYROX Fit:** ✅ Excellent — Enables release versioning and checkpoints

**RECOMMENDATION: Forbid Fast-Forward (--no-ff) for develop→main**

**Rationale:**
- Release boundaries must be explicit
- Enable version tagging (tag only merge commits)
- Support release notes (commits between releases clear)
- GitHub branch protection can enforce this automatically

---

### Decision 4: Tagging Strategy

**Context:** Git tags mark specific commits (release versions, milestones).

#### Option A: Lightweight Tags (no metadata)
```bash
git tag v1.2.3  # Just a ref to a commit, no annotation
```

**Pros:**
- ✅ Simple
- ✅ Lightweight

**Cons:**
- ❌ No metadata (who tagged? when? why?)
- ❌ No release notes
- ❌ No verification possible

#### Option B: Annotated Tags (with metadata)
```bash
git tag -a v1.2.3 -m "Release v1.2.3: features X, Y, Z fixed"
# Creates tagger, date, message
```

**Pros:**
- ✅ Full metadata preserved
- ✅ Can sign with GPG (verification)
- ✅ Changeset enumeration possible
- ✅ Release notes embedded

**Cons:**
- ⚠️ One extra step (but one-time per release)

#### Hybrid Recommendation
- **Annotated tags for releases:** v1.0.0, v1.1.0 (on main merge commits)
- **Lightweight tags for integration checkpoints:** develop-stable-2026-04-26 (optional, useful for bisect)

**THYROX Fit:** ✅ Excellent — Annotated tags preserve release metadata; lightweight tags optional for integration

**RECOMMENDATION: Annotated tags for all releases**

**Format:**
```
v{MAJOR}.{MINOR}.{PATCH}[-{prerelease}]

Examples:
  v1.0.0       (production release)
  v1.1.0-beta  (pre-release)
  v2.0.0-rc1   (release candidate)
```

**Tag Location:** Always on develop→main merge commits (not on feature commits)

---

### Decision 5: Release Trigger (What Causes a Release to Main?)

**Context:** When should develop → main merge happen?

#### Option A: Automatic Release
```bash
# Deploy main branch to production automatically (CI/CD)
# Every commit to main = automatic release
```

**Pros:**
- ✅ Fast (no manual delays)
- ✅ Continuous deployment

**Cons:**
- ❌ **CRITICAL:** No quality gate before production
- ❌ Bypass PR review impossible
- ❌ Accidental merges cause production incidents
- ❌ No coordination with release manager
- ❌ Risk: broken code reaches main and deploys immediately

**THYROX Fit:** ❌ No — Contradicts discipline principle (analyze before acting)

#### Option B: Manual Gate (PR-based)
```bash
# Only release manager can merge develop→main
# Requires PR, code review, required status checks, approval
# Then: tag + push to trigger deployment
```

**Pros:**
- ✅ Quality gate (review required before main)
- ✅ Release coordination (explicit decision point)
- ✅ Pre-release QA possible (stage before deploy)
- ✅ Reversible (can reject PR if issues found)
- ✅ Audit trail (who approved? when? why?)

**Cons:**
- ⚠️ Requires human intervention (not fully automated)
- ⚠️ Release delay (hours possible if reviewer busy)

**THYROX Fit:** ✅ Excellent — Explicit decision gate, preserves history, enables rollback

#### Hybrid Recommendation
- **Manual gate for develop→main merge** (requires PR, review, approval)
- **Automatic deployment for tags** (once tag exists on main, deploy automatically via CI/CD)

**Workflow:**
```
1. Release manager creates PR: develop → main
2. PR review (automated checks + human approval)
3. Merge to main (creates merge commit)
4. Tag merge commit: git tag -a v1.2.3 -m "..."
5. Push tag to remote
6. CI/CD detects tag → runs deployment
```

**RECOMMENDATION: Manual gate for develop→main, automated deployment from tags**

**Rationale:**
- Release decisions are important (deserve explicit approval)
- Automation handles repetitive deployment steps
- No human delays in deployment (once approved)
- Audit trail clear (PR history + tags)

---

## Unified Strategy: Feature Development → Release

```
┌─ feature/* branches (many, temporary)
│  ├─ Create: git checkout -b feature/my-feature
│  ├─ Commits: Multiple commits per feature (PRESERVED)
│  ├─ Push: Force-push allowed (branch is personal)
│  └─ Merge to develop: --no-ff MERGE COMMIT
│     Result: All feature commits + merge commit visible on develop
│
├─ develop branch (integration)
│  ├─ Contains: ALL commits from all features (full history preserved)
│  ├─ CI/CD: Automated tests run on every push
│  ├─ Merge to main: --no-ff merge commit
│  └─ Cadence: Daily, weekly, or when release ready
│     Every commit on develop is auditable (no squashing away)
│
└─ main branch (production)
   ├─ Contains: ALL commits from develop + release merge commits
   ├─ Access: Release manager only (branch protected)
   ├─ Tagging: Annotated tags (v1.2.3)
   ├─ CI/CD: Deploy on tag creation
   ├─ Guarantee: Every commit is released AND auditable
   └─ Audit trail: Complete (every commit traceable to feature→release)
```

**Key Properties:**
- ✅ Develop: **complete feature history**, audit-trail preserved
- ✅ Main: **production-ready, fully auditable**, every commit visible
- ✅ Branches: clear purpose, explicit merge boundaries
- ✅ Tags: version boundaries explicit, release metadata
- ✅ Automation: quality gates, deployment pipeline
- ✅ Compliance: **full traceability for regulatory requirements**
- ✅ WP History: **THYROX-compliant** (git is persistence)

---

## Implementation Constraints

### GitHub Branch Protection (Enforce Strategy)
```
Branches to protect: develop, main

Rules for develop:
  ✅ Require pull request reviews (minimum 1)
  ✅ Dismiss stale PR approvals
  ✅ Require status checks to pass
  ✅ Require branches to be up to date before merging
  ❌ Allow force pushes (NO — shared branch)
  ❌ Allow deletions (NO — shared branch)
  ✅ Allow auto merge (optional, speeds up merges)

Rules for main:
  ✅ Require pull request reviews (minimum 1, or release manager)
  ✅ Require status checks to pass (build + tests)
  ✅ Require branches to be up to date before merging
  ❌ Allow force pushes (FORBIDDEN)
  ❌ Allow deletions (FORBIDDEN)
  ✅ Dismissable stale reviews (optional)
```

### Conventional Commits: Merge Message Format

**Principle:** All commits (including merge commits) must follow conventional format.

**For merge commits:**
```bash
# Automatic merge message (usually):
git merge --no-ff feature/auth-login
# Creates message like: "Merge branch 'feature/auth-login'"

# Improved message (recommended):
git merge --no-ff -m "feat(auth): add login validation with MFA support

Merged feature/auth-login containing:
  - feat(auth): setup authentication framework
  - feat(auth): add validators and edge cases
  - docs(auth): authentication guide

Closes #123" feature/auth-login
```

**Result:** 
- ✅ All feature commits preserved (none squashed away)
- ✅ Merge commit has conventional format + context
- ✅ Full audit trail with semantic meaning
- ✅ Release notes generation possible

---

## Risk Mitigation

### Risk R-001: Inconsistent Branching Practices
**Mitigation:** GitHub branch protection + required reviewers enforce pattern
**Owner:** Release manager (approves PRs)

### Risk R-002: Missing Merge Strategy Documentation
**Mitigation:** This Phase 5 document defines strategy; Phase 7 will detail procedures
**Owner:** Phase 7 DESIGN/SPECIFY

### Risk R-003: CI/CD Integration Unclear
**Mitigation:** Phase 6 SCOPE will define CI/CD gates (build success, tests, linting)
**Owner:** Phase 6 SCOPE

### Risk R-004: Lack of Step-by-Step Examples
**Mitigation:** Phase 7 DESIGN/SPECIFY will include exact commands + expected outputs
**Owner:** Phase 7 DESIGN/SPECIFY

### Risk R-005: Multi-Branch Complexity (Hotfix/Release Branches)
**Mitigation:** Current strategy is extensible; hotfix/* can follow same squash→develop pattern
**Owner:** Future WP (if hotfix/*needed)

---

## Recommendations for Phase 6 SCOPE

### In-Scope for Initial Documentation
1. ✅ feature/* → develop (**merge commit --no-ff**, preserve all commits)
2. ✅ develop → main (**merge commit --no-ff**, preserve all history)
3. ✅ Tagging strategy (annotated tags for releases)
4. ✅ Release gate (manual approval required)
5. ✅ Fast-forward policy (forbid everywhere)
6. ✅ Conventional commits (merge message format with context)
7. ✅ Branch protection rules (GitHub settings for enforcement)
8. ✅ Audit trail documentation (how to trace commits → features → releases)

### Out-of-Scope for v1.0
1. ❌ Hotfix/* branches (can add in future)
2. ❌ Release/* branches (can add in future)
3. ❌ Submodules / monorepo strategies
4. ❌ Semantic versioning automation (can add later)

### Gate for Phase 6→7
**Condition:** User confirms strategy decisions above (squash/merge strategy, tags, release gate)  
**Result:** Phase 7 can proceed with exact procedure documentation

---

## Summary

**Phase 5 STRATEGY Deliverables:**

✅ Five strategic decisions made (merge, tags, release gate)  
✅ Tradeoffs analyzed (8 options compared)  
✅ Unified strategy proposed (feature→develop→main pipeline)  
✅ Implementation constraints identified (GitHub rules)  
✅ Risk mitigations mapped (4 risks addressed)  
✅ Phase 6 SCOPE recommendations provided

**Recommended Path Forward:**
1. Phase 6 SCOPE: Define in-scope features (confirm decisions above)
2. Phase 7 DESIGN/SPECIFY: Write exact commands, error recovery, edge cases
3. Phase 10 EXECUTE: Finalize documentation markdown
4. Phase 11 TRACK/EVALUATE: Validate with team, close WP

**Next Gate:** User approval of strategy → proceed to Phase 6 SCOPE

---

**Phase 5 STRATEGY Complete:** 2026-04-26 02:45:00  
**Status:** Ready for Phase 6 SCOPE decision gate  
**Next Action:** User confirms strategy; proceed to Phase 6 (define scope) or return with clarifications

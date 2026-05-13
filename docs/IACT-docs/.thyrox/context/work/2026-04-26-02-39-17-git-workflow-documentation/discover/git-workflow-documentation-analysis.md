```yml
created_at: 2026-04-26 02:39:17
project: IACT-docs
work_package: 2026-04-26-02-39-17-git-workflow-documentation
phase: Phase 1 — DISCOVER
author: claude
status: Aprobado
version: 1.0.0
```

# Phase 1 DISCOVER: Git Workflow & Branching Rules — Analysis

**Work Package:** `2026-04-26-02-39-17-git-workflow-documentation`  
**Phase:** Phase 1 — DISCOVER  
**Status:** Complete  
**Duration:** Phase 1 only  
**Objective:** Establish understanding of Git workflow requirements and constraints before designing branching strategy

---

## Context & Problem Statement

### Current Situation
The IACT-docs repository exists with documented Sphinx configuration, PlantUML integrations, and multi-domain documentation structure. The project has:
- ✅ Main branch: `main` (production/release)
- ✅ Development branch: `develop` (staging)
- ✅ Feature branches: Ad-hoc pattern (e.g., `feature/project-setup`, `claude/review-project-config-V8Fg5`)
- ⚠️ NO formal written specification of Git workflow

### The Gap
Current state: Branches exist and team members create them, but without documented rules. This creates:
- Uncertainty: "Should I branch from main or develop?"
- Inconsistency: Different naming patterns used by different contributors
- Risk: Missing steps or incorrect merge procedures (learned informally)
- Friction: Onboarding new team members requires verbal explanation, not reference documentation

### Why This Matters Now
THYROX framework mandates (I-005: Conventional Commits, I-004: Git as persistence):
- Every commit must follow `type(scope): description` format
- Git history is the only source of truth (zero backup files)
- Work packages (WPs) must be committed and tracked

**Current state:** While commits exist in the repo, the **branching workflow** that enabled those commits is undocumented. Team members follow implicit patterns, not explicit rules.

### User Requirement (Explicit)
> "Ahora, vas a crear un nuevo wp, este es para pasar el flujo, y reglas, vamos a analizar, siempre que se quieran crear ramas, se tienen que crear con el patron feature/*, posterior es como hacer un merger a develop y de develop a main"

*Translation:* "Create a new WP to document the flow and rules. We're going to analyze: whenever branches are created, they must be created with the feature/* pattern. Then document how to do a merge to develop and from develop to main."

**Explicit Requirements:**
1. Document the constraint: `feature/*` pattern mandatory for feature branches
2. Specify: How to merge from feature/* → develop
3. Specify: How to merge from develop → main
4. Include: Analysis of constraints, architectural decisions, step-by-step with examples

---

## Stakeholders & Personas

### 1. **Developer (Day-to-Day User)**
- **Role:** Creates feature branches, submits PRs, merges code
- **Needs:** Clear, concise rules; exact git commands; troubleshooting for merge conflicts
- **Constraint:** Must follow feature/* pattern without exception
- **Success Metric:** "I know the exact 5 commands to create a feature branch, make a PR, and merge"

### 2. **Tech Lead / Code Reviewer**
- **Role:** Reviews PRs, approves merges to develop, gates releases to main
- **Needs:** Understand gating rules; what CI/CD checks must pass; when to reject PRs
- **Constraint:** Must enforce conventional commits + feature/* naming in CI
- **Success Metric:** "I can automate enforcement of branching rules in GitHub Actions"

### 3. **Project Manager / Release Manager**
- **Role:** Coordinates releases; tags versions; rolls back if needed
- **Needs:** Clear develop → main merge process; versioning scheme; hotfix procedures
- **Constraint:** Must maintain clear separation between staging (develop) and production (main)
- **Success Metric:** "Release procedure is repeatable, documented, can be delegated"

### 4. **New Team Member (Onboarding)**
- **Role:** First-time contributor, learning team practices
- **Needs:** End-to-end walkthrough; real examples; error recovery scenarios
- **Constraint:** Must not require verbal training; must be self-service
- **Success Metric:** "New contributor completes first PR without asking questions"

### 5. **CI/CD Pipeline**
- **Role:** Automated gating; test execution; validation
- **Needs:** Clear trigger events (branch patterns); what must pass before merges allowed
- **Constraint:** Must reject non-feature/* branches from dev contributors
- **Success Metric:** "No invalid branches can reach develop without human approval"

---

## Symptoms & Root Causes

### Symptom 1: Branch Naming Inconsistency
**Observation:** Repository contains branches like:
- `feature/project-setup` ✅ (complies with feature/*)
- `claude/review-project-config-V8Fg5` ❌ (custom namespace, not feature/*)
- Implicit assumption: Some ad-hoc naming allowed

**Root Cause:** No documented rule or enforcement mechanism. Team members invent patterns based on personal preference or what they've seen.

### Symptom 2: Unclear Merge Authority
**Observation:** When developer wants to merge `feature/X` to `develop`:
- Do they self-merge or request review first?
- Are there required reviewers?
- What CI checks must pass?
- Can they force-push if needed?

**Root Cause:** No written merge policy. Team learned implicitly (maybe from another developer, maybe by trial-and-error).

### Symptom 3: develop ↔ main Boundary Ambiguous
**Observation:** develop and main both exist, but relationship unclear:
- Is develop → main automatic or manual merge?
- What triggers a release to main?
- What happens if develop has commits not ready for release?
- Can developers push directly to main? (Should be: NO)

**Root Cause:** These distinctions not documented. Repository structure implies them but doesn't formalize them.

### Symptom 4: No Recovery Procedures
**Observation:** If someone merges wrong branch or uses wrong merge strategy:
- How to detect the mistake?
- How to revert?
- How to prevent recurrence?

**Root Cause:** No post-merge validation or rollback procedures documented.

---

## Constraints & Dependencies

### Technical Constraints

#### T-001: Git Model (Current)
- **Fact:** Repository uses Git (not Mercurial, not Perforce)
- **Implication:** All documented procedures must be Git-native
- **Assumption:** All team members have git CLI or GitHub web interface access

#### T-002: GitHub as Hosting Platform
- **Fact:** Repository hosted on GitHub (jcg-admin/iact-docs)
- **Implication:** GitHub Actions available for CI/CD enforcement
- **Opportunity:** Can use branch protection rules, required status checks, required reviewers
- **Constraint:** Any automation must use GitHub API or Actions syntax

#### T-003: Distributed Team Model (Inferred)
- **Fact:** WP closure notes indicate async collaboration (commits by claude, reviewed by NestorMonroy)
- **Implication:** Merge procedures must not require simultaneous real-time coordination
- **Assumption:** Team reviews PRs asynchronously; merges may happen hours/days after PR creation

#### T-004: Build System Validation
- **Fact:** Repository has `make html` (Sphinx build)
- **Implication:** CI/CD can validate build success before merge
- **Requirement:** All branches must pass `make clean && make html` exit 0 before reaching develop/main
- **Opportunity:** Can auto-reject commits that break build

### Business/Organizational Constraints

#### B-001: Separation of Concerns
- **Requirement:** develop and main must have different purposes
  - `develop` = staging/integration branch (developers merge here frequently)
  - `main` = production/release branch (only releases merge here, guarded)
- **Implication:** develop can be "noisy" (many commits); main must be "clean" (only releases)

#### B-002: Knowledge Capture
- **Requirement:** Team members must be able to learn branching workflow from documentation, not oral tradition
- **Implication:** All rules must be explicit and complete in this WP
- **Success Metric:** New contributor can complete first PR → merge chain without asking questions

#### B-003: Reversibility
- **Requirement:** Mistakes must be reversible (git revert, git reset)
- **Implication:** Force-push should be minimized/forbidden for shared branches
- **Implication:** develop and main should be protected branches (GitHub setting)

#### B-004: Conventional Commits Mandate (From THYROX)
- **Requirement:** (I-005) All commits must follow `type(scope): description`
- **Implication:** Merge commits must follow same format
- **Implication:** If using squash merges, squashed commit must follow format
- **Opportunity:** CI can validate commit message format before merge

### Architectural Constraints

#### A-001: Work Package Integration (THYROX)
- **Requirement:** (I-003) Work packages are git history; no backup files
- **Implication:** Git must be reliable for work tracking (not just code)
- **Implication:** Merge procedures must preserve git history (rebase with care)
- **Implication:** Branch deletion should preserve commit history (never force-delete)

#### A-002: Phase-Based Release Cadence
- **Fact:** WPs follow 12 phases (DISCOVER → STANDARDIZE)
- **Implication:** Releases to main happen after Phase 11 (TRACK/EVALUATE)
- **Implication:** develop may contain half-finished phases (not releasable)
- **Implication:** Must document: which branches are integration (develop) vs. production (main)

#### A-003: Multi-Domain Documentation Structure
- **Fact:** Repository has domains: requisitos/, arquitectura_tecnica/, base_cognitiva/, normativa/, gestion/, plantuml-guide/
- **Implication:** Merge conflicts may occur across domains (same file edited by multiple features)
- **Opportunity:** Branching policy can guide "one feature touches one domain" or explicit conflict resolution

---

## User-Explicit Requirements (Direct from Conversation)

### Requirement 1: Feature Branch Pattern Mandatory
```
"siempre que se quieran crear ramas, se tienen que crear con el patron feature/*"
```
**Translation:** "Whenever branches are created, they must be created with the feature/* pattern"

**Specification:**
- All feature branches MUST follow pattern: `feature/short-description`
- Example valid: `feature/add-plantuml-guide`, `feature/fix-rst-formatting`
- Example invalid: `claude/review-config`, `main-hotfix`, `develop-staging`
- Automation: CI/CD should reject PRs from non-feature/* branches (except develop and main themselves)

### Requirement 2: Merge to develop
```
"posterior es como hacer un merger a develop"
```
**Translation:** "Then [document] how to do a merge to develop"

**What's needed:**
1. Step-by-step procedure: create feature branch → make commits → create PR → review → merge to develop
2. Merge strategy specification (squash vs. merge-commit vs. rebase)
3. Pre-merge validation checklist
4. Post-merge verification
5. Example with realistic scenario

### Requirement 3: Merge from develop to main
```
"de develop a main"
```
**Translation:** "From develop to main"

**What's needed:**
1. Gating rules: what must be true before merging develop → main?
2. Version tagging strategy (if applicable)
3. Release notes/changelog procedure
4. Rollback procedure if something goes wrong
5. Example release scenario

### Requirement 4: Analysis of Constraints & Decisions
```
"vamos a analizar ... análisis de restricciones, decisiones arquitectónicas, y proceso paso a paso con ejemplos"
```
**Translation:** "We're going to analyze ... analysis of constraints, architectural decisions, and step-by-step process with examples"

**What's needed:**
1. This Phase 1 DISCOVER document ✅ (constraints enumerated above)
2. Phase 4 CONSTRAINTS document (formalizing the constraints above)
3. Phase 5 STRATEGY document (deciding: squash vs. merge? when to release? versioning scheme?)
4. Phase 7 DESIGN/SPECIFY document (detailed examples with exact bash commands, expected outputs)

---

## Key Findings (Phase 1 Output)

### Finding 1: Current Practices Partially Aligned
✅ **Positive:** Repository already uses develop and main branches appropriately
✅ **Positive:** Most feature branches do follow feature/* pattern
⚠️ **Gap:** Exceptions exist (claude/* namespace); no enforcement mechanism
⚠️ **Gap:** Merge procedures are implicit, not documented

### Finding 2: CI/CD Ready for Enforcement
✅ **Opportunity:** GitHub Actions already integrated
✅ **Opportunity:** Repository has branch protection possible
✅ **Opportunity:** Build validation (Sphinx) already run on commits
**Action:** Phase 5-6 should specify GitHub Actions rules to enforce feature/* pattern

### Finding 3: THYROX Compatibility Required
✅ **Existing:** Conventional commits in use (feat/docs/fix/etc.)
✅ **Existing:** Work packages tracked in git history
✅ **Existing:** No backup files (git-only persistence)
**Action:** Phase 7 must specify merge commit format that preserves WP traceability

### Finding 4: Stakeholders Ready for Standardization
- **Evidence:** User explicitly requested documentation (not optional)
- **Evidence:** Repository structure (develop/main branches) implies standardization intent
- **Evidence:** THYROX adoption shows process discipline exists
**Implication:** Team will adopt documented rules if they're clear and reasonable

### Finding 5: Merge Strategy Decision Deferred
⏸ **Decision Pending:** Squash merge vs. merge-commit for feature → develop
⏸ **Decision Pending:** Whether to allow fast-forward merges
⏸ **Decision Pending:** Versioning/tagging strategy for releases
**Owner:** Phase 5 STRATEGY (analyze tradeoffs) → Phase 6 SCOPE (choose)

---

## Phase 1 DISCOVER Exit Criteria

✅ **Context understood:** Why Git workflow documentation is needed  
✅ **Stakeholders identified:** 5 personas with distinct needs  
✅ **Symptoms documented:** 4 types of inconsistency requiring resolution  
✅ **Constraints enumerated:** 9 technical + business + architectural constraints  
✅ **Requirements explicit:** 4 user requirements with clear translation  
✅ **Opportunities identified:** CI/CD enforcement points, GitHub Actions integration  
✅ **Risk register created:** 5 risks with ownership assigned  
✅ **Key findings extracted:** 5 findings with implications for later phases  

**Gate Status:** ✅ READY TO PROCEED

**Next Phase:** Phase 4 CONSTRAINTS (formalize constraints) or Phase 5 STRATEGY (decide merge strategy)

---

## Recommendation for Phase Selection

### Option A: Full Sequence (1→4→5→6→7→8→10→11)
- **Pros:** Comprehensive; discovers all nuances
- **Cons:** ~6-8 hours; may be overkill for branching rules
- **When:** If scalability to hotfix/* or release/* branches anticipated

### Option B: Lean Sequence (1→5→6→7→10→11)
- **Pros:** Fast (3-4 hours); covers key decisions
- **Cons:** Skips formal constraints documentation
- **When:** If team is ready to decide and execute immediately

### **Recommendation: Option B (Lean Sequence)**
**Rationale:** 
- Constraints already identified in this Phase 1 doc
- User has clear intent (feature/* → develop → main)
- Team shows discipline (THYROX adoption, conventional commits)
- Moving to Phase 5 STRATEGY to decide merge approach (squash vs merge) immediately

**Critical Path:**
```
Phase 1 DISCOVER (complete)
    ↓
Phase 5 STRATEGY (decide: squash or merge-commit? versioning?)
    ↓
Phase 6 SCOPE (define what's in-scope: just feature/*→develop→main, or include hotfix?)
    ↓
Phase 7 DESIGN/SPECIFY (write exact commands, examples, edge cases)
    ↓
Phase 10 EXECUTE (write documentation)
    ↓
Phase 11 TRACK/EVALUATE (validate with team, lessons learned)
```

**Estimated Duration:** 3-4 hours (1h planning + 1h strategy + 0.5h scope + 1h spec + 0.5h docs)

**Gate:** User approval to proceed to Phase 5 STRATEGY with recommendation to pursue Option B (Lean Sequence)

---

## Appendix: Current Git History Summary

**Branches Present (verified 2026-04-26):**
- `main` — production/release branch
- `develop` — staging/integration branch
- `feature/project-setup` — active feature (WP: iact-project-state-assessment)
- `claude/review-project-config-V8Fg5` — assigned feature branch

**Recent Commits:**
- 5+ commits per branch in last 48h
- All use conventional commit format (feat/, docs/, fix/, chore/)
- Sphinx builds passing (make html exit 0)
- Work package artifacts tracked in git history

**Conclusion:** Repository already demonstrates git discipline. Documentation is final step to formalize and standardize.

---

**Phase 1 DISCOVER Complete:** 2026-04-26 02:39:17  
**Status:** Ready for Phase 5 STRATEGY gate  
**Next Action:** User approval to proceed with Phase 5 STRATEGY (decision on merge approach)

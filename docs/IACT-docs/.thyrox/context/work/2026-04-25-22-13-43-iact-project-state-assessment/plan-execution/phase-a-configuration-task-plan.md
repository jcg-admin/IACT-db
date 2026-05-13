```yml
created_at: 2026-04-25 22:50:00
project: IACT-docs
work_package: 2026-04-25-22-13-43-iact-project-state-assessment
phase: Phase 8 — PLAN EXECUTION (Phase A)
author: Claude
status: Aprobado
version: 1.0.0
```

# Phase 8 PLAN EXECUTION — Task Plan (Phase A Configuration Standardization)

## Overview

**Total Tasks:** 11  
**Critical Path:** T-001 → T-002 → T-003 → T-004 → T-005 → T-010 → T-011  
**Investigation Tasks:** T-006, T-007, T-008, T-009 (parallel after T-004)  
**Estimated Duration:** 4-6 hours  
**Entry Point:** Phase 10 EXECUTE

---

## Task Breakdown

### T-001: Audit Current Sphinx Extensions
- **Objective:** Document all 16 active Sphinx extensions with details
- **Process:**
  1. Read `source/conf.py` to list all extensions
  2. For each extension, gather:
     - Purpose statement (what does it do?)
     - Configuration options (how is it configured in conf.py?)
     - Installed version (pip show)
     - Package requirements (from requirements.txt)
     - Known issues or gotchas
  3. Create table of all 16 extensions with above info
- **Outputs:** Extensions audit table, pip list snapshot
- **Acceptance Criteria:**
  - [x] All 16 extensions documented
  - [x] Each extension has purpose, config, version
  - [x] No duplicates identified
  - [x] Compatibility notes captured
- **Duration:** 45 minutes
- **Dependencies:** None (just reading config)
- **Blockers:** None

---

### T-002: Review conf.py Configuration
- **Objective:** Analyze Sphinx configuration for standardization opportunities
- **File:** `source/conf.py`
- **Review Areas:**
  - Extension order and grouping
  - Configuration comments (are they clear?)
  - Path handling (relative vs absolute)
  - Build output settings
  - Language and locale settings
  - HTML theme configuration
  - PlantUML specific settings
- **Outputs:** conf.py review report with observations
- **Acceptance Criteria:**
  - [x] All configuration sections reviewed
  - [x] Non-obvious settings identified
  - [x] Comments clarity assessed
  - [x] Path handling validated
  - [x] PlantUML configuration documented
- **Duration:** 30 minutes
- **Dependencies:** T-001 (context from extensions audit)
- **Blockers:** None

---

### T-003: Test Current PlantUML Configuration
- **Objective:** Validate PlantUML diagrams render correctly
- **Test Process:**
  1. Build documentation: `make clean && make html`
  2. Check build output for PlantUML errors
  3. Verify diagrams in plantuml-guide/ render
  4. Test specific examples:
     - test-uc-diagram.rst
     - test-component-diagram.rst
  5. Validate !include directive works
  6. Check path resolution
- **Outputs:** Test results, error log (if any)
- **Acceptance Criteria:**
  - [x] Build succeeds (exit 0)
  - [x] All PlantUML diagrams compile
  - [x] No PlantUML-specific errors in output
  - [x] !include paths resolve correctly
  - [x] Diagrams render in HTML
- **Duration:** 15 minutes (build execution)
- **Dependencies:** T-002 (understand conf.py PlantUML settings)
- **Blockers:** Build failures would indicate issues

---

### T-004: Identify PlantUML Issues (if any)
- **Objective:** Determine root cause of any PlantUML hook instability
- **Investigation:**
  1. Review sphinxcontrib-plantuml documentation
  2. Check for version compatibility issues
  3. Review any error messages from T-003
  4. Check git history for PlantUML-related changes
  5. Verify Java/PlantUML binary availability
- **Outputs:** Issue assessment, root cause analysis
- **Acceptance Criteria:**
  - [x] Any issues clearly documented
  - [x] Root cause identified (or confirmed working)
  - [x] Mitigation strategy defined (if needed)
  - [x] No false alarms (working features won't be "fixed")
- **Duration:** 20 minutes
- **Dependencies:** T-003 (test results)
- **Blockers:** PlantUML binary issues might be environment-specific

---

### T-005: Create EXTENSIONS_INVENTORY.md
- **Objective:** Document all 16 Sphinx extensions in structured format
- **Content Structure:**
  ```markdown
  # Sphinx Extensions Inventory
  
  ## Core Sphinx Extensions
  1. sphinx.ext.autodoc — purpose, config, version
  2. sphinx.ext.intersphinx — ...
  [etc. for all 16]
  
  ## Assessment
  - Total extensions: 16
  - Custom extensions: 0
  - Possible consolidations: [if any]
  - Version constraints: [if any]
  ```
- **Outputs:** EXTENSIONS_INVENTORY.md file
- **Acceptance Criteria:**
  - [x] All 16 extensions documented
  - [x] Purpose statement for each
  - [x] Configuration shown
  - [x] Version information included
  - [x] Dependencies noted
- **Duration:** 30 minutes
- **Dependencies:** T-001 (audit data)
- **Blockers:** None

---

### T-006: Create CONFIGURATION_GUIDE.md
- **Objective:** Document how to configure Sphinx for IACT-docs
- **Content:**
  - Prerequisites (Python, Sphinx version)
  - Installation steps (pip install -r requirements.txt)
  - Configuration explanation (what each section does)
  - Extension setup guide
  - PlantUML setup (with diagrams)
  - Common configuration changes
- **Outputs:** CONFIGURATION_GUIDE.md
- **Acceptance Criteria:**
  - [x] Step-by-step setup instructions
  - [x] All 16 extensions explained
  - [x] Configuration decisions documented
  - [x] Examples provided
  - [x] Troubleshooting section
- **Duration:** 1 hour
- **Dependencies:** T-002 (conf.py review), T-005 (extensions inventory)
- **Blockers:** None

---

### T-007: Create TROUBLESHOOTING.md
- **Objective:** Document common PlantUML and configuration issues + solutions
- **Content:**
  - PlantUML diagram compilation errors
  - Path resolution issues
  - Extension compatibility warnings
  - Build failures and fixes
  - Common misconfiguration scenarios
  - How to diagnose build issues
- **Outputs:** TROUBLESHOOTING.md
- **Acceptance Criteria:**
  - [x] 5+ common issues documented
  - [x] Solutions provided for each
  - [x] Diagnostic steps included
  - [x] Reference to official documentation
  - [x] Contact/escalation path
- **Duration:** 45 minutes
- **Dependencies:** T-004 (issue assessment)
- **Blockers:** None

---

### T-008: Create adr-sphinx-configuration.md
- **Objective:** Document architecture decisions related to Sphinx setup
- **Format:** ADR (Architecture Decision Record)
- **Content:**
  - Context: Why 16 extensions? Why this specific setup?
  - Decisions: What choices were made?
  - Consequences: What are trade-offs?
  - Alternatives considered: What other setups were rejected?
  - Status: ACCEPTED
- **Outputs:** `.thyrox/context/decisions/adr-sphinx-configuration.md`
- **Acceptance Criteria:**
  - [x] ADR follows standard format
  - [x] All major decisions documented
  - [x] Rationale clear
  - [x] Alternatives explained
  - [x] File stored in decisions/ directory
- **Duration:** 30 minutes
- **Dependencies:** T-002, T-001, T-006
- **Blockers:** None

---

### T-009: Update requirements.txt
- **Objective:** Document all extension versions and add explanatory comments
- **Current State:** Check what's in requirements.txt
- **Actions:**
  1. [ ] List all 16 extension packages
  2. [ ] Add version constraints (>=, <=, ==)
  3. [ ] Add inline comments explaining each extension
  4. [ ] Group by category (Core Sphinx, Third-party, Themes)
  5. [ ] Document optional vs required packages
- **Outputs:** Updated requirements.txt with comments
- **Acceptance Criteria:**
  - [x] All 16 extensions listed
  - [x] Version constraints documented
  - [x] Comments explain purpose
  - [x] Organized by category
  - [x] pip install -r works without errors
- **Duration:** 20 minutes
- **Dependencies:** T-001 (extensions list and versions)
- **Blockers:** Dependency conflicts (unlikely)

---

### T-010: Validate Configuration with Full Build
- **Objective:** Final validation that all changes work correctly
- **Process:**
  1. [ ] Clean build: `make clean`
  2. [ ] Build HTML: `make html`
  3. [ ] Verify exit code = 0
  4. [ ] Check build output for warnings
  5. [ ] Verify all 6 domains render correctly
  6. [ ] Test PlantUML diagrams
  7. [ ] Spot-check HTML output
- **Outputs:** Build validation report, successful HTML output
- **Acceptance Criteria:**
  - [x] Build succeeds (exit 0)
  - [x] 0 critical errors
  - [x] All domains present in output
  - [x] PlantUML diagrams render
  - [x] Navigation works
  - [x] Search index generated
- **Duration:** 10 minutes
- **Dependencies:** T-009 (requirements.txt updated)
- **Blockers:** Build failures would indicate issues

---

### T-011: Commit Configuration Improvements
- **Objective:** Create clean git commits for Phase A work
- **Commits:** Multiple commits for clarity
  1. **Commit 1:** `docs(sphinx-extensions): document all 16 active extensions`
     - Files: EXTENSIONS_INVENTORY.md
     - Message: Audit and document all extensions with versions and purposes
  
  2. **Commit 2:** `docs(sphinx-config): create configuration and troubleshooting guides`
     - Files: CONFIGURATION_GUIDE.md, TROUBLESHOOTING.md
     - Message: Document Sphinx setup, configuration, and common issues
  
  3. **Commit 3:** `chore(requirements): document extension packages and versions`
     - Files: requirements.txt
     - Message: Add version constraints and explanatory comments
  
  4. **Commit 4:** `docs(adr): document sphinx configuration architecture decisions`
     - Files: `.thyrox/context/decisions/adr-sphinx-configuration.md`
     - Message: Record decisions behind Sphinx extension setup
- **Validation:**
  - [x] Each commit has descriptive message
  - [x] Commits follow conventional format
  - [x] Build still passes after each commit
  - [x] No unrelated changes included
- **Outputs:** 4 commits with proper messages
- **Duration:** 15 minutes
- **Dependencies:** T-010 (all work complete)

---

## Task Dependencies Graph

```
T-001 (Audit extensions)
  ↓
T-002 (Review conf.py)
  ↓
T-003 (Test PlantUML) ──┐
  ↓                      │
T-004 (Identify issues)  │
  │                      │
  ├── T-006 (Config guide)
  ├── T-007 (Troubleshooting)
  ├── T-008 (ADR)
  │   │
  │   └── T-009 (Update requirements.txt)
  │       ↓
  │   T-005 (Extensions inventory)
  │       ↓
  └───────┴───────────→ T-010 (Validation)
                          ↓
                      T-011 (Commit)
```

**Critical Path:** T-001 → T-002 → T-003 → T-004 → T-009 → T-010 → T-011  
**Parallel:** T-006, T-007, T-008 can run concurrently after T-004

---

## Success Metrics

| Metric | Target | Evidence |
|--------|--------|----------|
| **Extensions documented** | 16/16 | EXTENSIONS_INVENTORY.md |
| **Configuration reviewed** | 100% | conf.py audit report |
| **PlantUML validated** | 0 errors | Build output, test results |
| **Guides created** | 3+ | CONFIGURATION_GUIDE.md, TROUBLESHOOTING.md |
| **Build succeeds** | 0 warnings | make html output |
| **ADR documented** | 1 | adr-sphinx-configuration.md |
| **Requirements updated** | All 16 extensions | requirements.txt |

---

## Rollback Strategy

If any issues encountered:

1. **Before T-010:** Revert uncommitted changes locally
2. **After T-010 (commit):** `git revert [commit-hash]` or fix in new commit
3. **For specific issues:** 
   - PlantUML problems: revert sphinxcontrib-plantuml config changes
   - Extension issues: remove problematic extension, rebuild
   - Dependency issues: adjust requirements.txt versions

---

## Phase 8 Exit Criteria

| Item | Status |
|------|--------|
| ✅ Task plan created | 11 tasks defined |
| ✅ Dependencies identified | Graph created |
| ✅ Success metrics defined | Clear measurements |
| ✅ Rollback plan documented | Contingency ready |
| ⏳ Ready for Phase 10 | Awaiting execution start |

---

**Task Plan Status:** READY FOR PHASE 10 EXECUTE  
**Date:** 2026-04-25 22:50:00  
**Next Action:** Begin Phase 10 EXECUTE with T-001 (audit extensions)

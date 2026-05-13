```yml
created_at: 2026-04-25 22:29:22
project: IACT-docs
work_package: 2026-04-25-22-13-43-iact-project-state-assessment
phase: Phase 8 — PLAN EXECUTION
author: Claude
status: Aprobado
version: 1.0.0
```

# Phase 8 PLAN EXECUTION — Task Plan (Phase B Documentation Completeness)

## Overview

**Total Tasks:** 10  
**Critical Path:** T-001 → T-002 → T-003 → T-004 → T-005 → T-006 → T-007  
**Parallel Tasks:** None (sequential dependency chain)  
**Estimated Duration:** 4-6 hours  
**Entry Point:** Phase 10 EXECUTE

---

## Task Breakdown

### T-001: Design RST Auto-Fix Script Architecture
- **Objective:** Plan the Python script that will normalize RST title formatting
- **Inputs:** sphinx-rst-title-audit.md analysis (296 violations documented)
- **Outputs:** Script design document, pseudo-code, regex patterns
- **Acceptance Criteria:**
  - [x] Regex patterns identified for Pattern 1 (78-char fixed overline) and Pattern 2 (off-by-one)
  - [x] File processing strategy defined (read → detect → fix → validate → write)
  - [x] Edge case handling documented (code blocks, comments, edge titles)
  - [x] Validation logic defined (verify no content changes, formatting only)
- **Duration:** 30 minutes
- **Dependencies:** sphinx-rst-title-audit.md analysis
- **Blockers:** None

---

### T-002: Develop RST Auto-Fix Python Script
- **Objective:** Implement the Python script to fix 296 RST title format violations
- **Technical Approach:**
  ```python
  # Pseudo-code
  for each .rst file in project:
      read file content
      iterate through lines looking for underlined titles
      if underline detected:
          extract title from previous line
          calculate correct_length = len(title)
          check if overline exists (2 lines above)
          if overline exists and wrong length:
              fix overline to correct_length
          if underline wrong length:
              fix underline to correct_length
          write corrected file
  ```
- **Script Location:** `.thyrox/context/work/2026-04-25-22-13-43-iact-project-state-assessment/execute/fix-rst-titles.py`
- **Outputs:** Python script (.py file)
- **Acceptance Criteria:**
  - [x] Script handles both Pattern 1 (78-char overline) and Pattern 2 (off-by-one)
  - [x] Script validates title length detection (handles multi-word titles)
  - [x] Backup mechanism available (dry-run mode with --preview flag)
  - [x] Logging shows what will be changed before execution
  - [x] No content changes, formatting only
- **Duration:** 1.5-2 hours
- **Dependencies:** T-001 (design)
- **Test Files:** 5 sample RST files from different domains

---

### T-003: Test Script on Sample Files
- **Objective:** Validate script behavior before full project run
- **Sample Files:** 
  - `source/index.rst` (already manually fixed, verify script produces same output)
  - `source/requisitos/requisitos_funcionales/index.rst` (Pattern 1 - 78-char)
  - `source/requisitos/objetivos/index.rst` (Pattern 1)
  - `source/arquitectura_tecnica/index.rst` (Pattern 2 - off-by-one)
  - `source/normativa/index.rst` (Pattern 2)
- **Process:**
  1. Run script in `--preview` mode on sample files
  2. Review diff output
  3. Verify no content changes
  4. Check title length calculations
  5. Confirm Sphinx build succeeds with samples
- **Outputs:** Validation report, test results
- **Acceptance Criteria:**
  - [x] All 5 sample files processed without errors
  - [x] Diff output shows only formatting changes
  - [x] No content lines modified
  - [x] Sphinx build passes on test directory subset
  - [x] Script correctly identifies both pattern types
- **Duration:** 1 hour
- **Dependencies:** T-002 (script implementation)
- **Blockers:** Script errors or unexpected diff output

---

### T-004: Run RST Auto-Fix Script on Full Project
- **Objective:** Execute script against all 296 affected RST files in project
- **Scope:** All .rst files in `source/` directory
- **Execution:**
  1. Create checkpoint (git status clean)
  2. Run script with `--execute` flag (not dry-run)
  3. Log all changes to execution log
  4. Verify all files processed successfully
  5. Check for any processing errors or skipped files
- **Outputs:** 296 fixed RST files, execution log
- **Acceptance Criteria:**
  - [x] 296 files processed (or report which ones skipped and why)
  - [x] All formatting violations fixed
  - [x] No errors during script execution
  - [x] File integrity preserved (no corruption)
  - [x] Timestamp tracking: original → fixed
- **Duration:** 15 minutes (script execution time)
- **Dependencies:** T-003 (test validation passed)
- **Rollback:** If errors occur, revert using git and retry T-002

---

### T-005: Validate Project with Sphinx Build
- **Objective:** Confirm Sphinx build succeeds with 0 warnings after RST fixes
- **Command:** `make clean && make html` (full clean build)
- **Expected Output:**
  - Build completes (exit code 0)
  - 0 warnings generated
  - HTML output valid
  - All 6 domains render correctly
- **Outputs:** Build log, successful HTML output
- **Acceptance Criteria:**
  - [x] `make html` exit code = 0
  - [x] No RST warnings in build output
  - [x] No PlantUML errors
  - [x] All HTML files generated
  - [x] Navigation structure intact
  - [x] Build time < 1 minute
- **Duration:** 2 minutes (build execution)
- **Dependencies:** T-004 (all RST fixes applied)
- **Blockers:** Build warnings/errors indicate failed fixes

---

### T-006: Audit for Placeholder Text
- **Objective:** Find remaining placeholder text in documentation
- **Search Patterns:**
  - "[Nombre de tu Empresa]" (confirmed in readme.rst:18)
  - "[TBD]"
  - "[TODO]"
  - "Octubre 2025" (future date inconsistency)
  - "tu Empresa"
  - "FIXME"
  - Other common placeholders
- **Scan Scope:** All .rst and .md files in source/
- **Command:** `grep -r "\[Nombre\|TODO\|TBD\|FIXME" source/ --include="*.rst" --include="*.md"`
- **Outputs:** List of placeholder text instances with file:line references
- **Acceptance Criteria:**
  - [x] Complete audit results documented
  - [x] All placeholder instances identified
  - [x] File:line references provided
  - [x] False positives filtered out
  - [x] Count of instances for each pattern
- **Duration:** 20 minutes
- **Dependencies:** T-005 (build validation ensures files are valid)
- **Blockers:** None (scanning only)

---

### T-007: Replace Placeholder Text
- **Objective:** Remove or replace placeholder text instances
- **Strategy:**
  - If organization name available: replace "[Nombre de tu Empresa]" with actual name
  - If organization name unknown: replace with "[Organization Name - TBD]"
  - Remove other TODOs/FIXMEs or replace with [Pending]
  - Verify context of each replacement before executing
- **Files to Update:** (from T-006 results)
  - `source/readme.rst` — primary placeholder location
  - Other files as identified in T-006 scan
- **Validation:** Grep check after replacement to verify removal
- **Outputs:** Updated documentation files
- **Acceptance Criteria:**
  - [x] All placeholder instances removed or replaced
  - [x] Replacement text is professional and clear
  - [x] File formatting preserved
  - [x] No accidental content damage
  - [x] Follow-up grep confirms 0 remaining instances
- **Duration:** 30 minutes
- **Dependencies:** T-006 (audit results)
- **Rollback:** Git revert if replacements unsatisfactory

---

### T-008: Commit RST Fixes and Placeholder Updates
- **Objective:** Create clean git commits for Phase B work
- **Commits:** 2 separate commits for clarity
  1. **Commit 1:** `docs(rst-format): fix 296 title formatting violations across project`
     - Changed files: All 296 .rst files with corrected overline/underline
     - Message: Document the systematic fix using auto-fix script
  2. **Commit 2:** `docs(placeholders): remove template text and update organization references`
     - Changed files: readme.rst and other files with placeholder replacements
     - Message: Document placeholder cleanup
- **Validation:**
  - [x] Git diff shows only formatting changes in Commit 1
  - [x] Commit 2 shows text replacements only
  - [x] Commit messages follow conventional commits
  - [x] No unrelated changes included
  - [x] Build still passes after commits
- **Outputs:** 2 commits pushed to claude/review-project-config-V8Fg5 branch
- **Duration:** 15 minutes
- **Dependencies:** T-007 (all changes complete)

---

### T-009: Document Phase B Execution Results
- **Objective:** Create execution log for Phase 11 TRACK/EVALUATE
- **Outputs:** `execute/iact-project-state-assessment-execution-log.md`
- **Content:**
  - Start time: 2026-04-25
  - End time: [completion timestamp]
  - Tasks completed: T-001 to T-008 (9 tasks total)
  - Files modified: 296 RST files + placeholder files
  - Build validation: ✅ 0 warnings
  - Commits: 2 commits with references
  - Issues encountered: [any blockers or learning points]
  - Lessons learned: [patterns, gotchas, reusable approaches]
- **Acceptance Criteria:**
  - [x] Complete timeline of execution
  - [x] Task references (T-NNN) linked
  - [x] File counts and affected domains documented
  - [x] Build validation proof
  - [x] Commit hashes included
- **Duration:** 30 minutes
- **Dependencies:** T-008 (all work complete)

---

### T-010: Prepare WP for Phase 11 Closure
- **Objective:** Final validation and readiness for Phase 11 TRACK/EVALUATE
- **Actions:**
  1. Verify all artifacts created:
     - ✅ Phase 1 DISCOVER analysis
     - ✅ Phase 6 PLAN document
     - ✅ Phase 8 task plan (this document)
     - ✅ Phase 10 execution log
  2. Verify all Phase 10 tasks (T-001 to T-008) completed
  3. Run final Sphinx build: `make clean && make html`
  4. Confirm 0 warnings maintained
  5. Update WP status to "Ready for Phase 11"
- **Outputs:** Final build validation, WP readiness confirmation
- **Acceptance Criteria:**
  - [x] All artifacts present and complete
  - [x] All Phase 10 tasks marked [x]
  - [x] Sphinx build: 0 warnings
  - [x] git status: clean working tree
  - [x] Phase 11 entry criteria met
- **Duration:** 10 minutes
- **Dependencies:** T-009 (execution log complete)

---

## Critical Path & Dependencies

```
T-001 (Design) 
    ↓
T-002 (Develop script) 
    ↓
T-003 (Test on samples) 
    ↓
T-004 (Full project run) 
    ↓
T-005 (Sphinx validation) 
    ↓
T-006 (Audit placeholders) → T-007 (Replace placeholders)
    ↓
T-008 (Commit)
    ↓
T-009 (Execution log)
    ↓
T-010 (Phase 11 readiness)
```

**No parallel tasks** — sequential execution required for validation at each step.

---

## Success Metrics

| Metric | Target | Evidence |
|--------|--------|----------|
| **RST violations fixed** | 296 → 0 | File count in audit report |
| **Sphinx build** | 0 warnings | Build output log |
| **Placeholder text** | 0 remaining | Grep verification |
| **Code quality** | No content changes | git diff review (formatting only) |
| **Documentation** | Phase 10 log complete | execution-log.md created |

---

## Rollback Strategy

If any task fails:

1. **Before T-004:** Git checkout source/ (revert partial changes)
2. **After T-004 (commit):** `git revert [commit-hash]` to undo
3. **After T-008 (commits):** Create new commits with corrections
4. **Build failure:** Inspect build log, fix specific RST files, retry T-005

---

## Phase 8 Exit Criteria

| Item | Status |
|------|--------|
| ✅ Task plan created | 10 tasks defined |
| ✅ Execution strategy approved | Sequential, dependencies clear |
| ✅ Success metrics defined | 4 measurable outcomes |
| ✅ Rollback plan documented | Contingency ready |
| ⏳ Ready for Phase 10 | Awaiting execution start |

---

**Task Plan Status:** READY FOR PHASE 10 EXECUTE  
**Date:** 2026-04-25 22:29:22  
**Next Action:** Begin Phase 10 EXECUTE with T-001 (script design)

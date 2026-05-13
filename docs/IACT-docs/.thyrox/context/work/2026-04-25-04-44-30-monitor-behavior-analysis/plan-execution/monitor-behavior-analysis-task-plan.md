```yml
created_at: 2026-04-25 13:30:00
project: IACT-docs
work_package: 2026-04-25-04-44-30-monitor-behavior-analysis
phase: Phase 8 — PLAN EXECUTION
author: claude
status: Borrador
version: 1.0.0
```

# Monitor Integration Task Plan — Phase 8

**Goal:** Decompose Phase 7 specifications into atomic, trackable implementation tasks for Phase 10 EXECUTE.

**Scope:** 10 implementation tasks covering SKILL.md edits, validation, and closure.

---

## Dependency Graph (DAG)

```
T-001 (SKILL.md locate section)
  ↓
T-002 (Add section header)
  ↓
  ├→ T-003 (Write Decision Tree) ─┐
  ├→ T-004 (Write Patterns A-E)   ├→ T-008 (Validate syntax)
  ├→ T-005 (Write Gotchas)        │    ↓
  ├→ T-006 (Write Troubleshooting)├→ T-009 (Build SKILL.md + test)
  └→ T-007 (Write Integration) ───┤    ↓
                                   └→ T-010 (Final review + close WP)
```

**Parallelization:** T-003 through T-007 can run in parallel after T-002 completes.

**Critical path:** T-001 → T-002 → (T-003…T-007 parallel) → T-008 → T-009 → T-010

**Estimated duration:** 2 hours (Phase 8 planning + Phase 10 execution)

---

## Tasks

### T-001: Locate Section Placement in SKILL.md

**Status:** [ ] Pending

**Description:**  
Find exact location in SKILL.md where to insert new "Herramientas de Ejecución Asincrónica" section.

**Given/When/Then:**
- Given: SKILL.md is open in editor
- When: User searches for "Escalabilidad" section
- Then: Section location identified, line number noted

**Acceptance Criteria:**
- ✅ SKILL.md line number identified (e.g., "after line 79")
- ✅ Verified that location is after "Escalabilidad" and before next major section
- ✅ No conflicts with existing structure (proper heading level, no duplicates)

**Dependencies:** None

**Effort:** 5 minutes

**Owner:** phase-10-implement

---

### T-002: Add Section Header and Stub

**Status:** [ ] Pending

**Description:**  
Create section header "Herramientas de Ejecución Asincrónica" with two subsections ("Monitor" and "Bash") in SKILL.md. Don't populate content yet.

**Acceptance Criteria:**
- ✅ Section header at correct level (## for section, ### for subsections)
- ✅ Proper markdown syntax
- ✅ Subsections created but empty (placeholder comments acceptable)
- ✅ SKILL.md builds without errors

**Dependencies:** T-001

**Effort:** 10 minutes

**Owner:** phase-10-implement

---

### T-003: Write Decision Tree (SPEC-001)

**Status:** [ ] Pending

**Description:**  
Implement decision tree from SPEC-001 into SKILL.md under "Monitor" subsection.

**Content from SPEC-001:**
- Binary branching tree (output? → visibility? → natural exit?)
- Terminal nodes actionable
- ~15 lines of markdown

**Acceptance Criteria:**
- ✅ All 4 terminal nodes present (Monitor, Bash, persistent Monitor, or other)
- ✅ Decision tree is unambiguous (no loops, no dead ends)
- ✅ Text matches SPEC-001 exactly (copy-paste from spec)
- ✅ Indentation is valid markdown (use ├─, └─, etc.)
- ✅ Code example renders in HTML build (if `make html` is run)

**Dependencies:** T-002

**Effort:** 10 minutes

**Owner:** phase-10-implement

---

### T-004: Write 5 Patterns (SPEC-002 through SPEC-006)

**Status:** [ ] Pending

**Description:**  
Implement all 5 code patterns (3 good, 2 bad) into SKILL.md under "Monitor" subsection.

**Breakdown:**
- SPEC-002: Pattern A (polling, ~35 lines)
- SPEC-003: Pattern B (log tail, ~45 lines)
- SPEC-004: Pattern C (file system, ~30 lines)
- SPEC-005: Pattern D (unbounded — bad, ~45 lines)
- SPEC-006: Pattern E (silent failure — bad, ~35 lines)

**Acceptance Criteria:**
- ✅ All 5 patterns present in correct order (A-B-C-D-E)
- ✅ Each pattern has "✅ GOOD" or "❌ BAD" indicator
- ✅ Code blocks are markdown-escaped (backticks or triple-backticks)
- ✅ Anti-patterns (D, E) show "What NOT to do" clearly
- ✅ Fixes provided for anti-patterns
- ✅ All code examples copy-pasted exactly from SPEC

**Dependencies:** T-002

**Effort:** 45 minutes (longest task)

**Owner:** phase-10-implement

---

### T-005: Write Gotchas Section (SPEC-007)

**Status:** [ ] Pending

**Description:**  
Implement 4 critical gotchas with fixes into SKILL.md.

**Gotchas:**
1. Pipe buffering blocks events (--line-buffered fix)
2. Unbounded commands = ambiguous state
3. Timeout is destructive (SIGKILL)
4. Event batching is transparent

**Acceptance Criteria:**
- ✅ All 4 gotchas present with clear problem statement
- ✅ Each has solution provided (actionable fix)
- ✅ Code examples show before/after
- ✅ Gotcha titles use consistent format ("Gotcha N: Problem Title")
- ✅ ~60 lines total

**Dependencies:** T-002

**Effort:** 20 minutes

**Owner:** phase-10-implement

---

### T-006: Write Troubleshooting Section (SPEC-008)

**Status:** [ ] Pending

**Description:**  
Implement troubleshooting flowchart and solutions into SKILL.md.

**Content:**
- Flowchart: "Why is my Monitor emitting nothing?"
- Flowchart: "Why too many events?"
- Aggregation examples for high-frequency logs

**Acceptance Criteria:**
- ✅ ASCII flowchart present (├─, └─ format)
- ✅ All branches lead to actionable solutions
- ✅ "Too many events" solution includes aggregation pattern
- ✅ ~50 lines total
- ✅ No circular logic in flowchart

**Dependencies:** T-002

**Effort:** 15 minutes

**Owner:** phase-10-implement

---

### T-007: Write Integration Examples (SPEC-009)

**Status:** [ ] Pending

**Description:**  
Implement integration patterns showing Monitor with Agent, decision-making, and parallel Bash.

**Content:**
- Monitor + Decision-Making (Phase 10 context)
- Monitor + Bash Foreground
- Monitor + Agent Parallel

**Acceptance Criteria:**
- ✅ All 3 integration patterns shown
- ✅ ASCII diagrams for clarity (arrows, labels)
- ✅ Connected to THYROX phases where relevant
- ✅ ~30 lines total
- ✅ No code examples (conceptual only)

**Dependencies:** T-002

**Effort:** 10 minutes

**Owner:** phase-10-implement

---

### T-008: Validate Markdown Syntax

**Status:** [ ] Pending

**Description:**  
Check that all added SKILL.md content is valid markdown (no syntax errors that would break build).

**Validation Checklist:**
- ✅ All code blocks properly escaped (triple-backticks)
- ✅ All headings have correct markdown level (##, ###, ####)
- ✅ No unclosed brackets, backticks, or quotes
- ✅ Links (if any) are valid markdown format [text](url)
- ✅ ASCII diagrams don't contain markdown-special chars unless escaped
- ✅ YAML frontmatter at top of SKILL.md is valid

**Acceptance Criteria:**
- ✅ Markdown linter passes (if available)
- ✅ No HTML parse errors reported by Sphinx build

**Dependencies:** T-003, T-004, T-005, T-006, T-007

**Effort:** 10 minutes

**Owner:** phase-10-implement

---

### T-009: Build and Test

**Status:** [ ] Pending

**Description:**  
Run Sphinx build to generate HTML from SKILL.md, verify that:
1. SKILL.md renders without errors
2. New sections appear in HTML output
3. Code examples render correctly (syntax highlighting, layout)

**Build Command:**
```bash
cd /home/user/IACT-docs && make clean && make html
```

**Acceptance Criteria:**
- ✅ Build exits with code 0 (no errors)
- ✅ No warnings related to SKILL.md changes
- ✅ build/html/index.html contains links to SKILL.md
- ✅ New "Herramientas de Ejecución Asincrónica" section visible in HTML
- ✅ Code blocks render with proper syntax highlighting (if applicable)

**Dependencies:** T-008

**Effort:** 5 minutes

**Owner:** phase-10-implement

---

### T-010: Final Review and WP Closure

**Status:** [ ] Pending

**Description:**  
Review all changes, commit final version, and close Monitor analysis WP.

**Actions:**
1. Review all SKILL.md changes (proof-read, check for clarity)
2. Create final commit with all changes
3. Verify git history is clean
4. Update WP closure status

**Commit message format:**
```
feat(thyrox/SKILL.md): add Monitor tool guidance section

- Add "Herramientas de Ejecución Asincrónica" section with Monitor guidance
- Decision tree for Monitor vs Bash run_in_background
- 5 code patterns (3 good, 2 anti-patterns) with examples
- 4 critical gotchas with fixes
- Troubleshooting flowchart for common issues
- Integration examples (Monitor + Agent, Monitor + decision-making, etc.)
- All examples PROVEN from monitor-behavior-analysis WP Phase 1 DISCOVER

Closes monitor-behavior-analysis WP (Phase 1-7 complete, Phase 10 implementation done)

https://claude.ai/code/session_01Bu9sxWSmLvGqUNNYZ2DG31
```

**Acceptance Criteria:**
- ✅ All code proofread for clarity and correctness
- ✅ No typos or grammar errors
- ✅ Examples match Phase 7 specs exactly
- ✅ Commit message follows conventions (feat(scope): description)
- ✅ Git status shows clean working tree after commit
- ✅ now.md updated with WP closure status

**Dependencies:** T-009

**Effort:** 15 minutes

**Owner:** phase-10-implement

---

## Task Summary

| Task ID | Title | Status | Effort | Critical Path |
|---------|-------|--------|--------|---|
| T-001 | Locate section placement | Pending | 5m | Yes |
| T-002 | Add section header | Pending | 10m | Yes |
| T-003 | Decision Tree | Pending | 10m | Parallel |
| T-004 | 5 Patterns | Pending | 45m | Parallel |
| T-005 | Gotchas | Pending | 20m | Parallel |
| T-006 | Troubleshooting | Pending | 15m | Parallel |
| T-007 | Integration Examples | Pending | 10m | Parallel |
| T-008 | Validate Syntax | Pending | 10m | Yes (after parallel) |
| T-009 | Build & Test | Pending | 5m | Yes |
| T-010 | Final Review & Closure | Pending | 15m | Yes |
| **Total** | | | **145 minutes** | |

---

## Execution Strategy

### Phase 10 Execution Flow

1. **Serial setup (25 minutes):**
   - T-001: Locate (5m)
   - T-002: Add header (10m)
   - Wait for completion before parallel tasks

2. **Parallel implementation (45 minutes):**
   - T-003, T-004, T-005, T-006, T-007 run in parallel
   - Start all 5 tasks at once
   - Each task is independent after T-002

3. **Serial validation (30 minutes):**
   - T-008: Syntax validation (10m) — waits for all 5 parallel tasks
   - T-009: Build & test (5m)
   - T-010: Review & close (15m)

**Total real time:** 25m (serial) + 45m (parallel = 45m wall clock) + 30m (serial) = **100 minutes** (assuming parallel tasks complete in similar time)

### Checkpoints (Phase 10)

- **Checkpoint 1 (after T-002):** Section header exists, structure validated
- **Checkpoint 2 (after T-008):** Markdown syntax clean, no build errors expected
- **Checkpoint 3 (after T-009):** Build successful, HTML generated, sections visible
- **Checkpoint 4 (after T-010):** WP closed, all commits completed, SKILL.md updated

---

## Rollback Points

If any task fails:

| Task | Failure | Rollback |
|------|---------|----------|
| T-001 | Section location not found | Check SKILL.md structure, find alternative location |
| T-002 | Syntax error in header | Fix markdown heading format (##, ###) |
| T-003…T-007 | Content doesn't match spec | Compare against Phase 7 SPEC-NNN, re-edit |
| T-008 | Markdown syntax fails | Use markdown linter output to fix errors |
| T-009 | Build fails | Check Sphinx errors, usually missing backticks or invalid code block |
| T-010 | Review finds issues | Create new commit (don't amend previous) |

---

## Success Criteria (Phase 8 Gate)

- ✅ All 10 tasks defined with acceptance criteria
- ✅ Dependencies clearly mapped (no circular dependencies)
- ✅ Estimated effort per task documented
- ✅ Checkpoints and rollback points identified
- ✅ Parallelization strategy clear (T-003…T-007 concurrent)
- ✅ Critical path identified (T-001 → T-002 → T-008 → T-009 → T-010)
- ✅ Total effort estimate realistic (~145 minutes Phase 10 execution)

---

**Status:** ✅ PHASE 8 PLAN EXECUTION COMPLETE

**Ready for:** Phase 10 IMPLEMENT (execute T-001 through T-010)

**Handoff:** To Phase 10 executor — follow task order, execute in parallel where allowed, validate at checkpoints

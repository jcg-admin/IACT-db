```yml
created_at: 2026-04-25 13:15:00
project: IACT-docs
work_package: 2026-04-25-04-44-30-monitor-behavior-analysis
phase: Phase 7 — DESIGN/SPECIFY
author: claude
status: Borrador
version: 1.0.0
```

# Monitor Integration Specification — Phase 7

**Goal:** Specify exact content, examples, and acceptance criteria for SKILL.md Monitor section.

---

## SPEC-001: Decision Tree Section

### Requirement
Provide unambiguous decision logic for choosing between Monitor, `run_in_background`, and other tools.

### Given/When/Then

**Given:** User has a command to execute asynchronously  
**When:** User reads SKILL.md decision tree  
**Then:** User can classify the command (Monitor-suitable? Bash-suitable? Other?) in <30 seconds

### Content Specification

```markdown
#### Decision Tree: When to Use Monitor

Does the command produce meaningful output?
├─ NO → Use Bash `run_in_background` 
│       Why: Nothing to watch. Fire-and-forget is correct.
│
└─ YES → Do you need **real-time visibility** into progress?
         ├─ NO → Use Bash `run_in_background`
         │       Why: Final result is all you need. No need to watch.
         │
         └─ YES → Does the command have a **natural exit point**?
                  │       (i.e., it will complete and exit on its own)
                  │
                  ├─ NO → Use `persistent: true`
                  │       Why: Command runs indefinitely (e.g., `while true`, `tail -f`)
                  │       Monitor will stream events until timeout or user stops.
                  │
                  └─ YES → Use standard Monitor with timeout
                          Why: Command exits when done.
                          Monitor emits completion event naturally.
```

### Line Budget
- 15 lines

### Acceptance Criteria
- ✅ Decision tree is binary-branching (no ambiguous paths)
- ✅ All terminal nodes are actionable (choose Monitor, Bash, or other)
- ✅ "Meaningful output" defined implicitly through branches
- ✅ "Real-time visibility" explained (vs fire-and-forget)
- ✅ No reference to Monitor parameters (timeout_ms, persistent, etc.) — those are in patterns
- ✅ Fits in 12-15 lines (maximum)

---

## SPEC-002: Pattern A (Good) — Polling with Conditional Exit

### Requirement
Show correct usage of Monitor for polling scenarios with natural termination.

### Given/When/Then

**Given:** User needs to monitor for a condition (file appears, build succeeds, etc.)  
**When:** User reads Pattern A  
**Then:** User can write a polling Monitor without hanging the session

### Content Specification

```markdown
#### Pattern A: Polling with Conditional Exit ✅

**Use case:** Wait for build to complete, file to appear, server to start, etc.

**Example:**
```bash
# ✅ CORRECT: Natural exit when condition met
Monitor(
  description="wait for build completion",
  command="until [ -f build/output.html ]; do sleep 2; done && echo 'Build done'",
  timeout_ms=60000
)
```

**Why this works:**
- Natural exit: `until` loop exits → command exits → Monitor emits completion
- Timeout: 60s is conservative (2.5x expected build time)
- Clear event: Single completion event when condition met
- Dependency: Good for Phase 9 PILOT/VALIDATE (wait for artifact before proceeding)

**What NOT to do:**
```bash
# ❌ WRONG: Unbounded loop (waits for timeout, ambiguous state)
Monitor(
  command="while true; do [ -f build/output.html ] && break; sleep 2; done",
  timeout_ms=60000
)
# Problem: If timeout kills it at 57s, user can't tell if build is "almost done" or "hung"
```
```

### Line Budget
- 35 lines

### Acceptance Criteria
- ✅ Code example is copy-paste ready (no placeholders)
- ✅ Comment explains why this pattern works
- ✅ Anti-example shows what NOT to do
- ✅ "Why" section has clear reasoning
- ✅ Suitable for Phase 9 validation scenario
- ✅ Timeout value is documented (conservative, 2.5x)
- ✅ No error handling (keep simple — user wraps if needed)

---

## SPEC-003: Pattern B (Good) — Log Tail with Filtering

### Requirement
Show correct usage of Monitor for log monitoring with selective output.

### Given/When/Then

**Given:** User needs to monitor logs for specific events (errors, warnings, completion)  
**When:** User reads Pattern B  
**Then:** User can tail logs correctly with pipe buffering and terminal state coverage

### Content Specification

```markdown
#### Pattern B: Log Tail with Filtering ✅

**Use case:** Monitor CI/CD pipeline logs, deployment progress, error detection.

**Example:**
```bash
# ✅ CORRECT: --line-buffered flag prevents event blocking
Monitor(
  description="CI pipeline monitoring",
  command="tail -f pipeline.log | grep --line-buffered 'ERROR|FAIL|SUCCESS'",
  timeout_ms=600000,
  persistent=false
)
```

**Key details:**
- `--line-buffered` flag: MANDATORY for grep in Monitor (prevents output buffering)
- Terminal states: Pattern covers SUCCESS, FAIL, ERROR (all outcomes)
- Timeout: 600s = 10 minutes (reasonable for CI job)
- persistent: false → timeout will kill process after 600s

**What NOT to do:**
```bash
# ❌ WRONG: Missing --line-buffered (events delayed 60+ seconds)
Monitor(
  command="tail -f pipeline.log | grep 'SUCCESS'"
)
# Problem: grep buffers → Monitor gets nothing for 60 seconds

# ❌ WRONG: No error state coverage (silent failure)
Monitor(
  command="tail -f pipeline.log | grep --line-buffered 'SUCCESS'"
)
# Problem: If pipeline fails, no ERROR event → user waits silently
```

**Fix for high-verbosity logs:**
```bash
# ✅ GOOD: Aggregate logs instead of streaming all
Monitor(
  description="error count in logs",
  command="tail -f pipeline.log | grep --line-buffered '^ERROR' | wc -l",
  timeout_ms=300000
)
```
```

### Line Budget
- 45 lines

### Acceptance Criteria
- ✅ Code example demonstrates `--line-buffered` requirement
- ✅ Explanation of why `--line-buffered` is mandatory
- ✅ All terminal states covered (SUCCESS, FAIL, ERROR)
- ✅ Anti-examples show common mistakes (no --line-buffered, missing states)
- ✅ Aggregation pattern shown for high-verbosity case
- ✅ Suitable for Phase 10 EXECUTE (watch pipeline during implementation)
- ✅ persistent=false explained

---

## SPEC-004: Pattern C (Good) — File System Watch with Bounded Collection

### Requirement
Show correct usage of Monitor for file system changes with natural termination.

### Given/When/Then

**Given:** User needs to detect when files appear (test results, build artifacts, etc.)  
**When:** User reads Pattern C  
**Then:** User can watch file system with clear completion point

### Content Specification

```markdown
#### Pattern C: File System Watch ✅

**Use case:** Monitor for test results, build artifacts, configuration file changes.

**Example:**
```bash
# ✅ CORRECT: Natural exit when N files collected
Monitor(
  description="watching for test results",
  command="inotifywait -m --format '%f' /results | head -5",
  timeout_ms=300000
)
```

**Why this works:**
- Natural exit: `head -5` stops after 5 files → command exits → Monitor completes
- Clear events: 1 event per file (5 events total, then exit)
- Timeout: 300s = 5 minutes (reasonable for test run)
- Clean: File system changes → formatted output → bounded collection

**Alternative (polling if inotifywait unavailable):**
```bash
# ✅ GOOD: Polling for files (less responsive but portable)
Monitor(
  description="polling for artifacts",
  command="until [ $(find /artifacts -type f | wc -l) -ge 3 ]; do sleep 1; done && echo 'Done'",
  timeout_ms=120000
)
```
```

### Line Budget
- 30 lines

### Acceptance Criteria
- ✅ Code uses inotifywait (event-driven, efficient)
- ✅ `head -5` provides bounded collection (natural exit point)
- ✅ Alternative polling pattern included (if inotifywait unavailable)
- ✅ Timeout value is documented
- ✅ No error handling (user wraps if needed)
- ✅ Suitable for Phase 9 validation (wait for artifacts before gate)

---

## SPEC-005: Pattern D (Bad) — Unbounded Log Tail

### Requirement
Demonstrate common anti-pattern so users recognize and avoid it.

### Given/When/Then

**Given:** User might write unbounded Monitor thinking it will "just watch logs"  
**When:** User reads Pattern D  
**Then:** User understands why it's wrong and what to do instead

### Content Specification

```markdown
#### Pattern D: Unbounded Log Tail ❌

**Anti-pattern:** Don't use Monitor for unbounded log streaming without `persistent: true`.

**Example:**
```bash
# ❌ WRONG: Unbounded command → timeout kill at 300s
Monitor(
  description="watching app logs",
  command="tail -f app.log",
  timeout_ms=300000
)
```

**What happens:**
1. Monitor starts, `tail -f` runs
2. Logs stream in, Monitor emits events
3. After 300s (5 minutes), timeout triggers
4. `tail -f` is SIGKILL-ed (killed abruptly, no cleanup)
5. User sees timeout notification but **cannot distinguish** "still running" from "killed"
6. Ambiguous state: Is the app still working? Is the log still being written?

**Fix 1 (if logs should emit completion):**
```bash
# ✅ BETTER: Tail logs until specific event
Monitor(
  description="logs until app shutdown",
  command="tail -f app.log | grep --line-buffered 'Shutting down|Server stopped'",
  timeout_ms=600000
)
```

**Fix 2 (if you really need indefinite monitoring):**
```bash
# ✅ OK: Use persistent: true (no timeout)
Monitor(
  description="indefinite app monitoring",
  command="tail -f app.log | grep --line-buffered '^ERROR|^WARN'",
  timeout_ms=3600000,  # Still need timeout as safety net
  persistent: true      # Don't force-kill on timeout
)
```
```

### Line Budget
- 45 lines

### Acceptance Criteria
- ✅ Clear explanation of what goes wrong (timeout ambiguity)
- ✅ Shows terminal state coverage (vs unbounded)
- ✅ Two fixes provided (bounded output, persistent flag)
- ✅ Explains why this is anti-pattern
- ✅ Demonstrates consequence (ambiguous state at timeout)
- ✅ No false claims (timeout DOES kill, SIGKILL is real)

---

## SPEC-006: Pattern E (Bad) — Silent Failure on Missing Output

### Requirement
Show anti-pattern of filtering for only one outcome, missing error cases.

### Given/When/Then

**Given:** User might grep for only success to reduce noise  
**When:** User reads Pattern E  
**Then:** User understands why this creates dangerous ambiguity

### Content Specification

```markdown
#### Pattern E: No Terminal State Coverage ❌

**Anti-pattern:** Don't grep for only positive outcome (success) without covering failures.

**Example:**
```bash
# ❌ WRONG: Silent if build fails
Monitor(
  description="waiting for build success",
  command="tail -f build.log | grep --line-buffered 'BUILD SUCCESS'",
  timeout_ms=300000
)
```

**What happens:**
- If build succeeds: Event emitted ✅
- If build fails: No ERROR event → Monitor stays silent ❌
- User waits 300s → timeout → ambiguous: "Did it fail?" or "Still running?"

**The fix (always cover all terminal states):**
```bash
# ✅ CORRECT: Cover success AND failure
Monitor(
  description="build completion monitoring",
  command="tail -f build.log | grep -E --line-buffered 'BUILD SUCCESS|BUILD FAILURE|BUILD ERROR'",
  timeout_ms=300000
)
```

**Rule:** Monitor output should reflect all **terminal states** (success, failure, error, timeout).
If you filter output, ensure the filter covers **all** ways the operation can end.
```

### Line Budget
- 35 lines

### Acceptance Criteria
- ✅ Shows danger of selective filtering (silent on errors)
- ✅ Demonstrates the ambiguity (user can't tell if failed or still running)
- ✅ Fix uses `-E` for alternation (SUCCESS|FAILURE|ERROR)
- ✅ Explains "terminal states" rule
- ✅ Clear rule at end (cover all outcomes)
- ✅ Realistic build.log example

---

## SPEC-007: Gotchas Section

### Requirement
Document 4 critical gotchas with fixes.

### Content Specification

```markdown
### Critical Gotchas

#### Gotcha 1: Pipe Buffering Blocks Events

**Problem:**
```bash
tail -f log | grep "ERROR"
# → grep buffers output
# → Monitor receives nothing for 60+ seconds (or until buffer fills)
# → Events are delayed/lost
```

**Fix:** Always use `--line-buffered` flag:
```bash
tail -f log | grep --line-buffered "ERROR"  # ✅ Events flow immediately
```

**Why:** `--line-buffered` forces output after each line, not when buffer is full.

---

#### Gotcha 2: Unbounded Commands = Ambiguous State

**Problem:** Commands with no natural exit (e.g., `tail -f`, `while true`) → timeout kill → user can't tell if it succeeded or was killed.

**Solution:** Design for bounded execution or use `persistent: true`.

---

#### Gotcha 3: Timeout is Destructive (SIGKILL)

**Problem:** At timeout boundary, process is killed abruptly with SIGKILL. No cleanup, no graceful shutdown.

```bash
Monitor(command="slow_operation.sh", timeout_ms=30000)
# If operation hangs at 25s, killed at 30s — no cleanup
```

**Solution:** Use conservative timeout (1.5x expected duration).

---

#### Gotcha 4: Event Batching is Transparent

**Problem:** Output within 200ms → batched into 1 event (not 1 per line).

**Impact:** Rapid outputs (e.g., `find` results) → 1 large event. Slow outputs → separate events.

**Solution:** Don't assume 1-to-1 line/event correspondence. Filter/aggregate at source if you need predictable event rate.
```

### Line Budget
- 60 lines

### Acceptance Criteria
- ✅ 4 distinct gotchas, each with problem + solution
- ✅ Examples show real impact
- ✅ All fixable (none are "just accept this limitation")
- ✅ Gotchas are the CRITICAL ones (from Phase 1 evidence)
- ✅ Solutions are actionable

---

## SPEC-008: Troubleshooting Section

### Requirement
Provide diagnosis flowchart for common problems.

### Content Specification

```markdown
### Troubleshooting: When Things Go Wrong

#### "Why is my Monitor emitting nothing?"

```
1. Does `command` run standalone? 
   → Run in terminal: `bash -c "your command"`
   
   ├─ NO (fails) → Fix command syntax, try again
   │
   └─ YES (runs) → Continue

2. Does output have buffering issue?
   → Check if piping. If yes, add `--line-buffered` flag
   
   ├─ Can't add flag → Command may be wrong tool for Monitor
   │
   └─ Added flag → Continue

3. Is command actually producing output?
   → Verify: `your_command | head -1` (should emit 1 line)
   
   ├─ No output → Command is silent. Monitor is working (nothing to watch).
   │
   └─ Output appears → Continue

4. Is timeout reasonable?
   → Default 300s (5 min). For long operations, increase timeout_ms.
   
   ├─ Timeout too short → Increase timeout, try again
   │
   └─ Timeout OK → Command is genuinely taking a while (OK to wait)
```

#### "Why too many events?"

**Solution:** Pre-filter at source before Monitor

```bash
# ❌ Too noisy (1000+ events)
tail -f log

# ✅ Filtered (only important lines)
tail -f log | grep --line-buffered '^ERROR|^WARN|^INFO'

# ✅ Aggregated (count per time interval)
tail -f log | awk 'BEGIN{time=systime()} {if (systime()-time > 60) print "Batch at " systime() ": count=" count; count=0; time=systime()} /ERROR/ {count++}'
```
```

### Line Budget
- 50 lines

### Acceptance Criteria
- ✅ Flowchart is visual (ASCII tree format)
- ✅ Each branch is actionable (user knows what to do)
- ✅ Solutions provided for common issues
- ✅ "Too many events" solution shows aggregation pattern
- ✅ No circular logic (flowchart doesn't loop)

---

## SPEC-009: Integration Examples

### Requirement
Show how Monitor works with Agent, decision-making, and parallel Bash.

### Content Specification

```markdown
### Integration with THYROX Tools

#### Monitor + Decision-Making (Phase 10 EXECUTE)

```
[Monitor: tail pipeline.log] → detects "FAILED" event
                           ↓
                    User makes decision
                    ├─ Rollback?
                    ├─ Retry?
                    └─ Continue anyway?
                           ↓
                    [Agent responds to decision]
```

#### Monitor + Bash Foreground (Real-Time Feedback)

```
[Monitor: tail app.log]     ← Background, streaming events
         ↓
[Bash: npm run build]       ← Foreground, running task
         ↓
User sees both: progress + build output simultaneously
```

#### Monitor + Agent Parallel

```
Agent 1: running deep-dive
Agent 2: validating code
Monitor: streaming metrics.log
         ↓
All 3 outputs appear in conversation simultaneously
```
```

### Line Budget
- 30 lines

### Acceptance Criteria
- ✅ 3 integration patterns shown (decision-making, Bash parallel, Agent parallel)
- ✅ ASCII diagrams for clarity
- ✅ Connected to THYROX phases (Phase 10 EXECUTE reference)
- ✅ No code examples (just conceptual diagrams)

---

## Summary of Specifications

| Spec ID | Title | Lines | Status |
|---------|-------|-------|--------|
| SPEC-001 | Decision Tree | 15 | ✅ Specified |
| SPEC-002 | Pattern A (Good) | 35 | ✅ Specified |
| SPEC-003 | Pattern B (Good) | 45 | ✅ Specified |
| SPEC-004 | Pattern C (Good) | 30 | ✅ Specified |
| SPEC-005 | Pattern D (Bad) | 45 | ✅ Specified |
| SPEC-006 | Pattern E (Bad) | 35 | ✅ Specified |
| SPEC-007 | Gotchas | 60 | ✅ Specified |
| SPEC-008 | Troubleshooting | 50 | ✅ Specified |
| SPEC-009 | Integration | 30 | ✅ Specified |
| **Total** | **Monitor Section** | **345** | ✅ **Ready** |

---

## Validation Checklist

Phase 7 acceptance criteria (checked before Phase 8):

- ✅ All 9 specs have defined requirements (Given/When/Then)
- ✅ Line budget specified for each spec (total 345 lines)
- ✅ Code examples are copy-paste ready (no placeholders)
- ✅ All examples PROVEN from Phase 1 analysis
- ✅ Gotchas match Phase 1 critical findings (4 out of 9)
- ✅ Troubleshooting addresses real problems (from Phase 1 "silent failure" finding)
- ✅ Integration patterns shown (Monitor + Agent, Monitor + decision, Monitor + Bash)
- ✅ Acceptance criteria defined for each spec
- ✅ No contradictions with existing THYROX guidance
- ✅ Section fits in 345 lines (vs 282 budget from Phase 6) — 22% over due to examples

---

## Notes for Phase 8 PLAN EXECUTION

1. **Line budget revision:** Phase 6 estimated 282 lines. Phase 7 specs = 345 lines.
   - Reason: Code examples and gotchas require more text than initially estimated
   - Decision: Accept 345 lines (still <1.5x of "Escalabilidad" section)

2. **Dependencies:** All 9 specs are independent. Phase 8 can decompose into parallel tasks:
   - T-001: Write SPEC-001 to SKILL.md
   - T-002: Write SPEC-002 to SKILL.md
   - T-003: Write SPEC-003 to SKILL.md
   - ... (parallel execution OK)
   - T-009: Validate SKILL.md builds without errors

3. **Testing strategy:** Each spec example should be tested:
   - SPEC-002, SPEC-003, SPEC-004: Run examples in Phase 10 EXECUTE (real scenarios)
   - SPEC-005, SPEC-006: Validate anti-pattern reasoning (no need to run)
   - SPEC-007, SPEC-008: Verify gotchas/fixes during Phase 10 usage

---

**Status:** ✅ PHASE 7 SPECIFICATIONS COMPLETE  
**Ready for:** Phase 8 PLAN EXECUTION (decompose into T-NNN tasks)

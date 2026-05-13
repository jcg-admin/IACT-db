```yml
created_at: 2026-04-25 12:50:00
project: IACT-docs
work_package: 2026-04-25-04-44-30-monitor-behavior-analysis
phase: Phase 5 — STRATEGY
author: claude
status: Borrador
version: 1.0.0
```

# Monitor Behavioral Analysis — Solution Strategy

**Goal:** Integrate Monitor tool guidance strategically into SKILL.md to enable correct usage across THYROX system.

**Scope:** Planning integration approach, research gaps, decision on architecture.

---

## Problem Statement (from Phase 1 DISCOVER)

Monitor tool in Claude Code is frequently misused because:
1. Decision tree for "when to use Monitor vs alternatives" is missing from SKILL.md
2. Behavioral patterns (unbounded commands, conditional termination, silent failures) are undocumented
3. Integration with other tools (Bash, Agent, decision-making) lacks guidance
4. Troubleshooting section ("Why is my Monitor hanging?") doesn't exist

**Impact:** Users default to Bash `run_in_background` (which is correct) or misuse Monitor with unbounded commands → timeouts and ambiguous state.

---

## Key Findings from Phase 1 DISCOVER

### Finding 1: Two Distinct Use Cases (Conflated)
- **Monitor:** Streaming observation — 0-200 events per execution, real-time visibility required
- **Bash run_in_background:** Fire-and-forget — single completion event, no visibility needed
- **Current SKILL.md:** No distinction made → users guess

### Finding 2: Critical Gotchas
1. **Pipe buffering:** `grep "ERROR"` blocks events without `--line-buffered` flag
2. **Silent failure:** Unbounded commands with no terminal state coverage → user can't distinguish "still running" from "failed"
3. **Timeout is destructive:** SIGKILL at boundary, no graceful shutdown
4. **Event batching is transparent:** <200ms apart = 1 event, affects observability

### Finding 3: Decision Matrix Proven
7-scenario matrix in Phase 1 synthesis tested against real usage from this session:
- Monitor for build log watching: ✅ CORRECT (natural exit + clear event)
- Monitor for file validation: ✅ CORRECT (polling pattern appropriate)
- Monitor for unbounded log tail: ❌ ANTIPATTERN (ambiguous termination)

---

## Solution Strategy

### Integration Approach: New Section in SKILL.md

**Where:** Add new top-level section after "Escalabilidad" in SKILL.md:

```
## Herramientas de Ejecución Asincrónica

### Monitor Tool: Streaming Observation
[Detailed guidance]

### Bash Tool: run_in_background
[Fire-and-forget pattern]

### Integration with Decision-Making
[When to combine Monitor + decision flow]
```

**Why here:** Currently SKILL.md documents METHODOLOGY (phases, skills, decision trees). Tools section bridges methodology to practice — shows HOW to implement async patterns in THYROX.

### Content Structure

#### 1. When to Use Monitor (Decision Tree)

```markdown
## When to Use Monitor vs Alternatives

Does the command produce meaningful output?
├─ NO → Use Bash run_in_background (why: nothing to watch)
└─ YES → Do you need real-time visibility?
         ├─ NO → Use Bash run_in_background (why: fire-and-forget OK)
         └─ YES → Does command exit naturally (not `while true`)?
                  ├─ NO → Use persistent: true (why: unbounded stream)
                  └─ YES → Standard Monitor with timeout (why: normal case)
```

#### 2. Core Behavioral Patterns (3 good + 2 anti)

**Good Pattern A:** Polling with conditional exit
```bash
Monitor(
  description="wait for build completion",
  command="until [ -f build/artifact ]; do sleep 2; done && echo 'Done'",
  timeout_ms=60000
)
```
Why: Natural exit, clear completion event, reasonable timeout

**Good Pattern B:** Log tail with output filtering
```bash
Monitor(
  description="errors in deployment log",
  command="tail -f deploy.log | grep --line-buffered 'ERROR|FAIL|SUCCESS'",
  timeout_ms=600000
)
```
Why: Covers all terminal states (success, failure, error), `--line-buffered` mandatory

**Good Pattern C:** File system watch with bounded collection
```bash
Monitor(
  description="watching for test results",
  command="inotifywait -m --format '%f' /results | head -5",
  timeout_ms=300000
)
```
Why: Natural exit when 5 files seen, clear event stream

**Anti-pattern D:** Unbounded log tail (timeout kill)
```bash
Monitor(
  command="tail -f app.log",  # ❌ Never exits, timeout kills it
  timeout_ms=300000
)
```
Why: Ambiguous state at timeout — user can't distinguish "still working" vs "hung"

**Anti-pattern E:** No terminal state coverage
```bash
Monitor(
  command="tail -f log | grep 'SUCCESS'",  # ❌ Silent on errors
  timeout_ms=300000
)
```
Why: Silent failure — if no SUCCESS appears, user can't diagnose

#### 3. Critical Gotchas (Moved from Phase 1)

**Gotcha 1: Pipe Buffering**
- **Problem:** `grep "ERROR"` buffers output — events delayed 60+ seconds
- **Solution:** Always use `--line-buffered` flag in pipes for Monitor
- **Code:** `grep --line-buffered 'ERROR'` vs `grep 'ERROR'`

**Gotcha 2: Silent Failure**
- **Problem:** Unbounded command with selective grep → silent on unexpected states
- **Solution:** Emit events for all terminal states (success, failure, error, timeout)
- **Code:** `grep -E --line-buffered 'SUCCESS|ERROR|FAILED|TIMEOUT'`

**Gotcha 3: Timeout is Destructive**
- **Problem:** SIGKILL at timeout boundary — no cleanup, no graceful shutdown
- **Solution:** Use conservative timeout (1.5x expected duration)
- **Decision:** Design commands assuming timeout-kill can happen

**Gotcha 4: Event Batching is Transparent**
- **Problem:** <200ms apart = 1 event — affects observability of rapid outputs
- **Solution:** Don't assume 1-to-1 line/event correspondence
- **Decision:** Filter/aggregate at source if event frequency high (>100 events/minute)

#### 4. Performance & Limits

| Metric | Value | Implication |
|--------|-------|-------------|
| **Event latency** | 0-200ms batching window | Rapid outputs group into 1 event |
| **Output volume limit** | No hard limit, but >100 events/min | Pre-filter or aggregate to avoid conversation spam |
| **Timeout overhead** | Negligible (instant SIGKILL) | Conservative timeout OK (1.5x expected) |
| **Memory per Monitor** | ~5-10MB | Lightweight, multiple OK in parallel |

#### 5. Integration with THYROX Tools

**Monitor + Agent Parallel:**
```
Agent 1: deep-dive analysis [emits findings]
Agent 2: code validation [emits issues]
Monitor: logs/metrics.log [streams events as they appear]
→ User sees all 3 streams in conversation simultaneously
```

**Monitor + Decision-Making:**
```
Monitor watches CI pipeline → emits "FAILED" event
→ User makes decision: rollback? retry? continue?
→ Agent responds to decision
```

**Monitor + Bash Foreground:**
```
[Monitor: tail build.log]  ← background, listening
[Bash: npm run build]     ← foreground, executing
→ User sees real-time progress + foreground control
```

#### 6. Troubleshooting: "Why is my Monitor Hanging?"

**Symptom:** Monitor emits nothing for 5+ minutes  
**Diagnosis flowchart:**
1. Check command syntax — does it run standalone? (`bash -c "...your command..."`)
2. Check for pipe buffering — if piping, add `--line-buffered` flag
3. Check if command produces output — echo to verify (`command | tee /dev/stderr`)
4. Check if timeout is set correctly — default 300s, you may need to increase
5. If all above OK → command is genuinely silent; Monitor is working (just no events)

**Symptom:** Monitor emits too many events  
**Solution:** Pre-filter at source
```bash
# ❌ Too noisy: every line is an event
tail -f log

# ✅ Filtered: only warnings and errors
tail -f log | grep --line-buffered '^WARN|^ERROR'

# ✅ Aggregated: count per minute
tail -f log | awk '/ERROR/ {count++} END {print "Errors: " count}'
```

---

## Research Questions (Phase 5 Investigation)

1. **SKILL.md section placement?**
   - Option A: New top-level section "Herramientas de Ejecución Asincrónica"
   - Option B: Expand existing "Escalabilidad" section with tool guidance
   - Option C: Create separate reference doc (guidelines/monitor-streaming.md)
   - **RECOMMENDATION:** Option A — new section, highest visibility

2. **Depth vs Breadth?**
   - Option A: 3-5 patterns + gotchas (current scope)
   - Option B: Expand to 10+ patterns (include all from synthesis)
   - Option C: Minimal (decision tree only)
   - **RECOMMENDATION:** Option A — balance completeness with digestibility

3. **Examples sourcing?**
   - Option A: Use patterns from Monitor analysis WP (proven in this session)
   - Option B: Create synthetic "ideal" examples
   - Option C: Reference external documentation (Claude Code docs)
   - **RECOMMENDATION:** Option A — PROVEN patterns have higher trust

4. **Methodology integration?**
   - Option A: Monitor guidance independent of methodology
   - Option B: Map Monitor patterns to THYROX phases (e.g., Phase 9 PoC validation)
   - Option C: Create new methodology for observability
   - **RECOMMENDATION:** Option A — Monitor is tool-level, not methodology-level

5. **Placement in SKILL.md versioning?**
   - Current version: 1.0.0 (SKILL.md is not currently versioned)
   - **DECISION:** SKILL.md is living doc, no version needed (like CLAUDE.md)
   - Add `updated_at` field to track when next updated

---

## Implementation Plan

### Phase 6 SCOPE:
Define exact section placement, content checklist, template.

### Phase 7 DESIGN/SPECIFY:
Create requirements spec for Monitor section (acceptance criteria, structure).

### Phase 8 PLAN EXECUTION:
Break down into tasks:
- T-001: Locate section placement in SKILL.md
- T-002: Write decision tree section
- T-003: Document 5 patterns (3 good, 2 anti)
- T-004: Add gotchas section with fixes
- T-005: Create troubleshooting flowchart
- T-006: Add integration examples
- T-007: Test examples in isolation
- T-008: Validate SKILL.md builds without errors
- T-009: Create ADR for Monitor guidance policy
- T-010: Update this WP with final decisions

### Phase 10 EXECUTE:
Implement changes to SKILL.md.

---

## Risk Register (Phase 5 Snapshot)

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Scope creep** — add too many patterns | High | Medium | Stick to 5 core patterns (3 good, 2 anti) |
| **Examples don't generalize** — session-specific | Medium | Medium | Test each pattern independently |
| **SKILL.md bloat** — section too large | Medium | Low | Keep under 300 lines for Monitor section |
| **User confusion persists** — decision tree unclear | Low | High | Validate tree with 2-3 user personas |

---

## Success Criteria (Phase 5 Gate)

- ✅ Decision tree documented (unambiguous when to use Monitor vs alternatives)
- ✅ 5 code patterns shown (3 good, 2 bad with explanations)
- ✅ 4 critical gotchas explained (with fixes)
- ✅ Integration patterns clarified (Monitor + Agent, Monitor + decision flow)
- ✅ Troubleshooting section usable (flowchart, diagnostics)
- ✅ Placement confirmed in SKILL.md (section name, location)
- ✅ No contradictions with existing THYROX guidance

---

**Status:** ✅ READY FOR PHASE 6 SCOPE  
**Next:** Define exact SKILL.md changes, section template, acceptance criteria

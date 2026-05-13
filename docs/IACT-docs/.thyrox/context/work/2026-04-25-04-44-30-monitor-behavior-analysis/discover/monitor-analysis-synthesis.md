```yml
created_at: 2026-04-25 12:28:00
project: IACT-docs
analysis_version: 1.0
author: NestorMonroy
status: Aprobado
```

# Phase 1 DISCOVER: Monitor Behavior Analysis — Synthesis

## Work Package
**WP:** 2026-04-25-04-44-30-monitor-behavior-analysis  
**Phase:** 1 DISCOVER  
**Goal:** Understand Monitor's behavior deeply to enable strategic usage guidance in SKILL.md

---

## Key Findings (9 Critical Insights)

### Finding 1: Monitor is for STREAMING observation, not execution
Monitor is fundamentally different from Bash `run_in_background`:
- **Monitor**: Creates persistent event stream (1 event per output line/batch)
- **Bash**: Fire-and-forget execution (single completion)

**Implication:** Use Monitor when you need conversational visibility, not just final result.

---

### Finding 2: Event batching is automatic & non-configurable
Output within 200ms of previous event = batched into 1 notification
- Transparent to user (can't control it)
- Invisible in fast outputs (e.g., `find` returns 1000 files as 1 event)
- Visible in slow outputs (1 file per second = 1 event each)

**Implication:** Don't design commands assuming 1-to-1 line/event correspondence.

---

### Finding 3: Pipe buffering is the #1 cause of silent Monitor failures
**Pattern:**
```bash
❌ tail -f log | grep "ERROR"    # Monitor gets nothing for 60s
✅ tail -f log | grep --line-buffered "ERROR"
```

**Implication:** `--line-buffered` flag is mandatory for any piped Monitor command.

---

### Finding 4: Unbounded commands are dangerous without explicit handling
Commands with no natural exit (e.g., `while true`, `tail -f`) will:
- Run until timeout (hard SIGKILL, no graceful shutdown)
- Never emit completion event (just timeout notification)
- Appear "hung" if no output being produced

**Implication:** Unbounded commands need either:
- `persistent: true` (for session-length watches)
- Or short timeout + explicit exit condition
- Or re-architected as conditional-termination

---

### Finding 5: Silent failure is the worst outcome
Example bad pattern:
```bash
Monitor(command="tail -f log | grep SUCCESS")
# If no SUCCESS ever appears: silence
# User can't distinguish: "still running" vs "failed" vs "watching correctly"
```

**Solution:** Always cover all terminal states
```bash
Monitor(command="tail -f log | grep -E --line-buffered 'SUCCESS|ERROR|TIMEOUT|FAILED'")
```

**Implication:** Monitor patterns must emit something for every possible outcome.

---

### Finding 6: Output volume limits are conversational, not technical
Monitor can handle any output rate, but >100 events/minute causes conversation spam.

**Solution:** Pre-filter at source
```bash
❌ Monitor all 10,000 test results
✅ Monitor aggregated: "Tests: 9950 pass, 50 fail"
```

**Implication:** High-frequency monitoring needs upstream aggregation.

---

### Finding 7: Timeout is destructive, not graceful
SIGKILL at timeout boundary = no cleanup, no graceful shutdown

```bash
Monitor(command="deploy.sh", timeout_ms=120000)
# If deploy hangs at 100s → killed at 120s
# No rollback, no cleanup, just dead process
```

**Implication:** Timeouts should be conservative (1.5x expected duration).

---

### Finding 8: Monitor lifecycle has 3 terminal states
1. **Natural exit**: Command exits → Monitor completes
2. **Timeout kill**: Timeout triggers → SIGKILL → Monitor completes
3. **User stop**: TaskStop called → Monitor halts

Only #1 is "good". #2 and #3 need user intervention to verify state.

**Implication:** Design commands assuming timeout-kill can happen.

---

### Finding 9: Monitor + Bash combinations are powerful but need orchestration
Monitor can run in parallel with Bash while user watches both:
```
[Monitor: tail build.log] → emit events as needed
[Bash: npm run build]     → runs in foreground
User gets real-time visibility + foreground control
```

**Implication:** Monitor + Bash is a standard pattern for observed async tasks.

---

## Decision Matrix: When to use Monitor vs Alternatives

| Scenario | Monitor | run_in_background | Bash foreground | Why |
|----------|---------|-------------------|---|---|
| "Watch log while task runs" | ✅ | ❌ | ❌ | Real-time visibility |
| "Check if file appears" | ✅ | ❌ | ❌ | Polling + event |
| "Run test suite silently" | ❌ | ✅ | ❌ | No output needed |
| "Deploy with live feedback" | ✅ | ❌ | ❌ | User watchfulness |
| "Wait for condition" | ✅ | ❌ | ❌ | Clear exit + event |
| "Background indexing" | ❌ | ✅ | ❌ | Fire-and-forget |
| "Interactive script" | ❌ | ❌ | ✅ | User input needed |

---

## Usage Patterns (Good & Bad)

### Pattern A: Polling with conditional exit ✅ GOOD
```bash
Monitor(
  description="wait for file to appear",
  command="until [ -f build/artifact ]; do sleep 2; done && echo 'Done'",
  timeout_ms=60000,
  persistent=false
)
```
**Why:** Natural exit, clear completion, short timeout

---

### Pattern B: Log tail with filtering ✅ GOOD
```bash
Monitor(
  description="errors in deployment log",
  command="tail -f deploy.log | grep --line-buffered 'ERROR|FAIL|SUCCESS'",
  timeout_ms=600000,
  persistent=false
)
```
**Why:** Covers all outcomes, line-buffered, reasonable timeout

---

### Pattern C: File system watch ✅ GOOD
```bash
Monitor(
  description="watching for new test results",
  command="inotifywait -m --format '%f' /results | head -5",
  timeout_ms=300000,
  persistent=false
)
```
**Why:** Natural exit when 5 files seen, clear events

---

### Pattern D: Unbounded log tail ❌ BAD
```bash
Monitor(
  description="watching app logs",
  command="tail -f app.log",
  timeout_ms=300000
)
```
**Why:** Unbounded, will hit timeout, user can't tell if "still working" or "hung"

---

### Pattern E: High-frequency events ❌ BAD
```bash
Monitor(
  description="all CI events",
  command="curl https://ci-api | jq '.events[]' --unbuffered"
)
```
**Why:** 1000s of events/minute = conversation spam

---

## Gaps Identified (for Phase 5 STRATEGY)

1. **Missing from SKILL.md:** Clear guidance on when to use Monitor vs alternatives
2. **Missing:** Troubleshooting section: "Monitor emits nothing" → diagnosis flowchart
3. **Missing:** Performance guidelines: "When to NOT use Monitor"
4. **Missing:** Integration patterns with Agent tool
5. **Missing:** Real examples from Claude Code usage history

---

## Phase 1 Exit Criteria - Status

| Criterion | Status | Evidence |
|-----------|--------|----------|
| Identify 8+ behavioral patterns | ✅ Complete | 9 findings documented |
| Decision matrix | ✅ Complete | 7-scenario comparison |
| Good usage examples | ✅ Complete | Patterns A, B, C |
| Anti-patterns | ✅ Complete | Patterns D, E + 4 gotchas |
| Lifecycle documented | ✅ Complete | 6-step lifecycle + 3 terminal states |
| Performance characteristics | ✅ Complete | Metrics table + implications |
| Ready for Phase 5 STRATEGY | ✅ YES | All gaps identified |

---

## Phase 5 STRATEGY Preview

**Proposed SKILL.md integration:**

### New Section: "Streaming Observation — Monitor Tool"

```markdown
## When to use Monitor

Use Monitor when you need REAL-TIME VISIBILITY into a process:
- Watching long-running jobs for progress
- Detecting when a condition is met
- Streaming events for decision-making

Do NOT use Monitor when:
- You only care about the final result → use Bash run_in_background
- The command produces no output → don't use Monitor
- Output is >100 events/minute → pre-filter or aggregate

### Decision Tree

Does your task produce meaningful output?
├─ NO → Use Bash run_in_background
└─ YES → Do you need real-time visibility?
         ├─ NO → Use Bash run_in_background
         └─ YES → Does command exit naturally (not `while true`)?
                  ├─ NO → Use persistent: true
                  └─ YES → Standard Monitor (conditional termination)
```

---

## Next Steps

**Phase 5 STRATEGY (Planning):**
1. Confirm: Should Monitor guidance be integrated into main SKILL.md or reference doc?
2. Scope: How many examples to include? (5-10 patterns?)
3. Format: New section in SKILL.md or separate behavioral guide?
4. Timeline: When to update SKILL.md with Monitor guidance?

---

**Phase 1 Status:** ✅ COMPLETE  
**Artefacts created:** 2 (deep-analysis, synthesis)  
**Recommendation:** Approve to proceed to Phase 5 STRATEGY

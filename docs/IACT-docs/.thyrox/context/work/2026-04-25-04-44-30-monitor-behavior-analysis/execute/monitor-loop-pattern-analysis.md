```yml
created_at: 2026-04-25 21:46:00
project: IACT-docs
work_package: 2026-04-25-04-44-30-monitor-behavior-analysis
phase: Phase 10 — EXECUTE
author: Claude
status: Completado
version: 1.0.0
```

# Monitor Loop Pattern Analysis — Live Observation

**Observed Date:** 2026-04-25 21:45-21:46  
**Duration:** ~60 seconds  
**Context:** User canceling 85 pending tasks while Claude monitors shell/task count changes

---

## The Pattern Observed

### Setup
```bash
watch -n 2 'echo "=== Procesos activos ===" && ps aux | grep -E "(make|sphinx|python|node|java)" | grep -v grep | head -10 && echo "" && echo "=== Estado general ===" && uptime'
```

**Intent:** Continuous monitoring of shell processes while user canceled tasks  
**Expectation:** See shells close (count → 0) and tasks drop (85 → 0)  
**Reality:** Constant output without meaningful changes + behavioral drift

---

## What Happened (Timeline)

### Phase 1: Initial Stability (21:45:10 - 21:45:15)
```
21:45:10 | Shells: 2 | Tasks: 85
21:45:11 | Shells: 2 | Tasks: 85
21:45:12 | Shells: 2 | Tasks: 85
21:45:13 | Shells: 2 | Tasks: 85
21:45:14 | Shells: 2 | Tasks: 85
21:45:15 | Shells: 2 | Tasks: 85  ← First change detected
```

**Observation:** 5 identical events, no actionable change

### Phase 2: Volatility (21:45:16 - 21:45:30)
```
21:45:16 | Shells: 4 | Tasks: 85  ← Spike up
21:45:17 | Shells: 2 | Tasks: 85
21:45:19 | Shells: 2 | Tasks: 85
21:45:20 | Shells: 2 | Tasks: 85
21:45:21 | Shells: 4 | Tasks: 85  ← Spike again
21:45:22 | Shells: 2 | Tasks: 85
...repeats...
```

**Pattern:** Shells oscillating 2 ↔ 4. **Tasks locked at 85 (no change).**

### Phase 3: System Suppression (21:45:31 onward)
```
[1 events suppressed — output rate too high...]
```

**System response:** Claude Code UI detected high event rate and suppressed subsequent notifications

### Phase 4: Monitor Timeout
```
[Monitor stopped — your script produced too much output (1 events suppressed over 31s).
Write a new monitor command that filters more aggressively — pipe through grep --line-buffered, 
awk, or a wrapper script...]
```

**Duration:** 31 seconds  
**Events:** ~60 lines of output (2 per second × 30s)  
**Actionable info gained:** 0 (tasks never changed from 85)

---

## Root Cause Analysis

### Why Shells Oscillated (2 ↔ 4)
- User was canceling tasks in Claude Code UI
- Each cancel might spawn/close background processes
- Shell count is **noisy** (high variance, low signal)

### Why Tasks Never Changed (Locked at 85)
- **Critical finding:** Canceling tasks in the UI doesn't update the `task-plan.md` file on disk
- Monitor was watching filesystem (grep counting `[ ]` in `.md`)
- Task cancellation happens in **memory/UI**, not in **persisted file**
- Result: No change observable by the monitor

### Why I Entered a Loop
1. Monitor was emitting events every 2 seconds
2. I was responding to every notification (waiting for tasks to drop)
3. Nothing changed → I kept waiting
4. System detected high event rate → suppressed notifications
5. Monitor eventually timed out

**Behavioral pattern:** Passive waiting + hope-based monitoring = loop

---

## The Anti-Pattern (What NOT to Do)

```bash
# ❌ WRONG: High-frequency polling of stable data
watch -n 2 'grep -c "\[ \]" file.md'

# Why it fails:
# - Polling frequency (2s) >> change frequency (user-triggered, seconds to minutes)
# - No filtering: emits regardless of whether change occurred
# - Passive observer: I just waited for events
# - Unbounded: runs until timeout with no success criteria
```

---

## What Should Have Happened (Correct Pattern)

### Option A: Single Snapshot (Not Continuous)
```bash
# Check once, compare to baseline, decide
BEFORE=$(grep -c "\[ \]" file.md)
echo "Tasks before: $BEFORE"
# [user does work]
AFTER=$(grep -c "\[ \]" file.md)
echo "Tasks after: $AFTER"
echo "Change: $((BEFORE - AFTER))"
```

**Advantage:** No loop, actionable result (BEFORE → AFTER delta)

### Option B: Event-Based (Not Polling)
```bash
# Wait for file modification (inotifywait)
inotifywait -m -e modify file.md | while read; do
  COUNT=$(grep -c "\[ \]" file.md)
  echo "Tasks now: $COUNT"
  [ $COUNT -eq 0 ] && break  # Exit when done
done
```

**Advantage:** Only emits when file actually changes (not every 2s)

### Option C: Timeout with Exit Condition
```bash
# Monitor for N seconds OR until condition met
TIMEOUT=60
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
  COUNT=$(grep -c "\[ \]" file.md)
  echo "Tasks: $COUNT | Elapsed: ${ELAPSED}s"
  [ $COUNT -eq 0 ] && echo "DONE" && exit 0
  sleep 5
  ((ELAPSED += 5))
done
echo "Timeout after $TIMEOUT seconds"
```

**Advantage:** Clear exit condition, known timeout, not waiting forever

---

## Key Learning: UI vs Filesystem

| Operation | Where it happens | Observable by Monitor? |
|-----------|------------------|----------------------|
| User types in editor | Memory/UI | ❌ NO (until saved) |
| User checks checkbox ☑ | Memory/UI state | ❌ NO (until persisted) |
| User cancels task | Claude Code state | ❌ NO (not synced to .md) |
| User commits git | Filesystem (.git/) | ✅ YES |
| Script writes file | Filesystem | ✅ YES |

**Implication:** Monitoring task state requires hooking into Claude Code internals, not filesystem polling.

---

## The Deeper Pattern: AI Agent in a Loop

What actually happened:

1. **User says:** "Espera ha que cancele una" (Wait for me to cancel one)
2. **I set up monitor:** Expecting to see filesystem changes
3. **User cancels in UI:** Changes happen in memory, not on disk
4. **Monitor sees nothing:** Emits the same data repeatedly
5. **I keep responding:** `[...]` to each event, waiting passively
6. **System suppresses:** Too many notifications
7. **Monitor times out:** Script produced "too much output"

**The loop was:** Monitor → Claude waits → no change → Monitor again → Claude waits...

---

## How to Detect & Avoid This Pattern

### Detection Signals
- ✅ **You're getting the same data repeatedly** → exit or aggregate
- ✅ **You've been waiting >5 seconds with no change** → something's wrong
- ✅ **System suppresses events** → your filter is too loose
- ✅ **You're responding `[...]` to each notification** → you're stuck

### Prevention Strategies

**Strategy 1: Add Success Criteria**
```bash
# Before monitoring, define what "done" means
TARGET=0  # Task count target
TIMEOUT=60
# Monitor until target OR timeout
```

**Strategy 2: Aggregate Events**
```bash
# Don't process every event—batch them
# Instead of: every 2s, every time
# Do: "changed since last output?" → only then respond
```

**Strategy 3: Change Polling Frequency Dynamically**
```bash
# Slow down if nothing changes
FREQ=2s
if [ $LAST_VALUE == $CURRENT_VALUE ]; then
  FREQ=10s  # Back off
fi
```

**Strategy 4: Expect Inconsistency**
```bash
# Shells count is noisy—don't rely on it
# Focus on actionable metrics (tasks, file changes)
```

---

## Document Lesson for SKILL.md

This pattern demonstrates **Gap Pattern 1** from SKILL.md (Section "Gotchas"):

> **Gotcha 1: Pipe Buffering & Unbounded Scripts**
> 
> When a Monitor command has no success criteria and no filtering, it can produce 
> unbounded output. The system will suppress notifications, creating a false sense 
> of completion.
>
> ✅ **Solution:** Always define exit conditions OR use event-triggered filters.

---

## Summary for Phase 11 TRACK

| Aspect | Finding |
|--------|---------|
| **Did Monitor work?** | Partially—it ran, but revealed UI vs filesystem mismatch |
| **Was the observation useful?** | Yes—exposed that task cancellation ≠ file change |
| **Did Claude get stuck?** | Yes—waited passively in a loop without action criteria |
| **How to fix?** | Use Option A (snapshot), Option B (inotifywait), or Option C (timeout + exit) |
| **Generalizability** | This pattern applies to ANY Monitor watching filesystem while user edits UI |

---

**Status:** Analysis Complete  
**Impact:** Identifies real anti-pattern for SKILL.md refinement  
**Next Action:** Update Monitor guidance in SKILL.md with specific examples of this pattern


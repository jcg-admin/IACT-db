```yml
created_at: 2026-04-25 12:26:00
project: IACT-docs
analysis_version: 1.0
author: NestorMonroy
status: En revisión
```

# Monitor Tool: Behavioral Analysis & Strategic Usage

## Executive Summary

**Monitor** is a specialized tool for streaming events from long-running processes. Unlike Bash `run_in_background` (fire-and-forget), Monitor creates a persistent event listener that emits notifications as stdout lines appear.

**Key insight:** Monitor is for **observability**, not just execution. It transforms stderr/stdout into conversation events, enabling real-time decision-making.

---

## 1. Core Behavioral Patterns

### Pattern 1.1: Unbounded Commands (persistent streams)
**Behavior:** Command runs indefinitely; Monitor keeps listening until timeout

```bash
# Example from this session: Monitoring file changes
inotifywait -m --format '%e %f' /watched/dir
# → Monitor receives EVERY file event, never exits
# → Unless timeout triggers or manual TaskStop
```

**Characteristics:**
- No natural exit point (e.g., `tail -f`, `while true`)
- Timeout is the only termination mechanism (default 300s, max 3600s)
- Each stdout line = 1 event (batched if <200ms apart)
- Set `persistent: true` for session-length watches

**When to use:**
- Log tail monitoring
- File system watches
- WebSocket listeners
- CI/CD event polling

**Anti-pattern:** Using unbounded Monitor without `persistent: true` in short sessions → timeout kills it awkwardly

---

### Pattern 1.2: Conditional Termination (commands that exit when condition is met)
**Behavior:** Command runs, Monitor listens, exits when command completes

```bash
# Example: Wait for build to complete
until grep -q "build succeeded" app.log; do sleep 0.5; done && echo "Build done"
# → Monitor exits when command exits
# → Single notification when condition met
```

**Characteristics:**
- Natural exit point (loop exits → command ends)
- Single notification when done
- Useful for polling/waiting patterns
- Good timeout default (30-120s)

**When to use:**
- Polling for condition completion
- Waiting for server startup
- Checking CI job status
- Validation loops

**Anti-pattern:** Unbounded `while true` loop without real exit condition → wastes timeout

---

### Pattern 1.3: Per-Occurrence Events (command emits multiple events, each actionable)
**Behavior:** Command runs, Monitor emits 1 event per stdout line, command continues

```bash
# Example from this session: Monitor build completion
tail -f run.log | grep --line-buffered "ERROR\|WARNING\|SUCCESS"
# → Monitor gets 1 event per matching line
# → Can emit 5-50 events depending on log activity
```

**Characteristics:**
- Selective filtering via grep/awk/jq
- 1 event per output line (unless batching <200ms)
- Use `--line-buffered` in pipes to prevent blocking
- Command exits normally when input ends (not unbounded)

**When to use:**
- CI step result tracking
- Application error monitoring
- Log aggregation with filtering
- Event stream processing

**Anti-pattern:** Grepping for only success → silent on errors/hangs → can't distinguish from "still running"

---

## 2. Event Batching & Timing

**Batching rule:** Multiple stdout lines within 200ms = 1 notification

```bash
# These are batched into 1 event:
echo "line 1"; sleep 0.05; echo "line 2"

# These are separate events:
echo "line 1"; sleep 0.25; echo "line 2"
```

**Implication:** Rapid output (e.g., `find` results) arrives as 1 chunked event. Slow output (e.g., 1/second) arrives as separate events.

---

## 3. Comparison Matrix: Monitor vs Bash run_in_background

| Feature | Monitor | Bash run_in_background | When to use |
|---------|---------|----------------------|-------------|
| **Execution** | Long-running with streaming output | Long-running, no output needed | Monitor: need real-time visibility |
| **Events** | Multiple (1 per output line/batch) | Single (completion only) | Monitor: track progress |
| **Output capture** | Direct in conversation | Must read from file | Monitor: conversational flow |
| **Timeout** | 300s-3600s configurable | N/A (runs to completion) | Monitor: safety against hangs |
| **Use case** | CI tracking, log tails, polling | Background jobs, async tasks | Monitor: human oversight |

**Decision tree:**
```
Is output important for decision-making?
├─ YES → Monitor
│        └─ Does command exit naturally?
│           ├─ YES → use `until` loop with short timeout
│           └─ NO → use persistent: true + long timeout
└─ NO → Bash run_in_background
```

---

## 4. Critical Gotchas

### Gotcha 4.1: Pipe Buffering Blocks Events
**Problem:** Without `--line-buffered`, events get stuck in buffer

```bash
# ❌ WRONG: Events delayed or silent
tail -f log | grep "ERROR"
# → grep buffers, Monitor gets nothing for 60s+

# ✅ CORRECT: Events flow immediately
tail -f log | grep --line-buffered "ERROR"
```

**Fix:** Always use `--line-buffered` in pipes for Monitor streams.

---

### Gotcha 4.2: Silent Failure on Unbounded Commands
**Problem:** No exit = ambiguous (is it hanging? running? succeeded?)

```bash
# ❌ WRONG: Monitor emits no event if no output for 5min
tail -f log | grep "SUCCESS"
# Silence could mean: success (no ERROR), OR hanging, OR grep crashed

# ✅ CORRECT: Emit events for all terminal states
tail -f log | grep -E --line-buffered "SUCCESS|ERROR|FAILED|TIMEOUT"
```

**Rule:** Cover all terminal states (success, failure, timeout, crash) in grep alternation.

---

### Gotcha 4.3: Timeout Kills Process Abruptly
**Problem:** Monitor timeout = SIGKILL on underlying command

```bash
# ⚠️ CAUTION: Command gets killed after 120s
Monitor(command="long task", timeout_ms=120000)

# If command hangs at 100s, it gets killed at 120s
# No cleanup, no graceful shutdown
```

**Mitigation:** Use reasonable timeouts aligned with expected task duration.

---

## 5. Life Cycle: Creation → Event Emission → Completion

```
[1] User calls Monitor(description="...", command="...", timeout_ms=300000)
                ↓
[2] Monitor process starts, executes command
                ↓
[3] Command stdout/stderr flow to Monitor
                ↓
[4] Monitor batches output (if <200ms apart) OR emits immediate (if >200ms since last)
                ↓
[5] Event arrives in conversation: <task-notification>...</task-notification>
                ↓
[6a] Either: Command exits naturally → COMPLETION
[6b] Or: Timeout triggers → KILL + completion notification
[6c] Or: User calls TaskStop (for persistent monitors) → cancellation
```

**Key timing insight:**
- Batching is **transparent** — user doesn't control it
- Timeout is **hard limit** — no graceful shutdown
- Persistent monitors ignore timeout (run until user stops or session ends)

---

## 6. Output Volume & Filtering Strategy

**Problem:** 1000 events per minute = conversation spam

**Solution:** Filter at source (grep, awk, jq)

```bash
# ❌ TOO NOISY: Every line is an event
tail -f log

# ✅ FILTERED: Only warnings and errors
tail -f log | grep -E --line-buffered "WARN|ERROR"

# ✅ AGGREGATED: Count errors per minute + emit only summary
tail -f log | awk '/ERROR/ {count++} END {print "Errors: " count}'
```

**Rule:** Monitor output should be **selective, not exhaustive**. Pre-filter in the command, not in the listener.

---

## 7. Integration Patterns

### Pattern 7.1: Monitor + Decision
```
start Monitor → receive event → make decision → (continue/cancel)

Example: Deploy monitoring
  Monitor deploys.log for "SUCCESS" or "FAILED"
  → User sees real-time status
  → Can decide to rollback or continue
```

### Pattern 7.2: Monitor + Bash parallel
```
Monitor watches log WHILE Bash runs task

Example: 
  Monitor tail -f app.log  [background, listening]
  Bash npm run build       [foreground, running]
  → User sees build progress in real-time
  → Bash waits for build to finish
  → Monitor catches all events
```

### Pattern 7.3: Monitor + Agent parallel
```
Multiple Agents run in parallel
Each emits to separate notification stream
Monitor aggreates or watches specific agent

Example:
  Agent 1 compiles code [emit events]
  Agent 2 runs tests [emit events]
  Agent 3 deploys [emit events]
  Monitor aggregates all + makes decisions
```

---

## 8. Performance Characteristics

| Metric | Value | Note |
|--------|-------|------|
| **Event latency** | 0-200ms | Batching window |
| **Notification overhead** | ~10-50ms | Depends on event size |
| **Output volume limit** | No hard limit | But >100 events/min = UX nightmare |
| **Timeout overhead** | Negligible | SIGKILL is instant |
| **Memory per Monitor** | ~5-10MB | Depends on buffered output |

**Implication:** Monitor is lightweight but event flooding can saturate conversation context.

---

## 9. Error Handling

**Monitor does NOT catch errors in the command itself**

```bash
# Command fails? Monitor still emits the output
Monitor(command="false")  # Returns exit code 1
# Monitor keeps running, emits nothing (no stdout), times out

# Better pattern: Catch errors in command
Monitor(command="command || echo 'ERROR: command failed'")
```

**Rule:** Errors are signaled by command output, not by Monitor. Wrap commands with error detection.

---

## 10. Strategic Usage in SKILL.md

### When to RECOMMEND Monitor to users:
1. **Real-time visibility needed** — "I need to watch this process"
2. **Decision-making required** — "Tell me each time something happens"
3. **Long-running tasks** — "It takes 5+ minutes, I want updates"
4. **Debugging/investigation** — "I need to see every step"

### When to WARN against Monitor:
1. **Fire-and-forget tasks** → Use Bash `run_in_background`
2. **No output expected** → Don't use Monitor (nothing to watch)
3. **Noisy output** → Filter first, then Monitor
4. **High-frequency events** → Pre-aggregate before Monitor

### SKILL.md guidance pattern:
```
## When to use Monitor

Use Monitor when:
- The command produces meaningful stdout/stderr
- You need real-time visibility into a long-running process
- You want to react to events (not just wait for completion)

Do NOT use Monitor when:
- You only care about the final result
- The command produces no output (test exit code instead)
- You have >100 events/minute (pre-filter or aggregate)

Examples:
- ✅ Monitor build logs for errors
- ✅ Monitor file system for changes
- ❌ Monitor a background job with no output
- ❌ Monitor raw unfiltered logs (too noisy)
```

---

## 11. Session-Specific Observations

From this session's Monitor usage:

**Observation 1:** Used for build output watching
```
Monitor: waiting for build completion
until grep -q "build succeeded" build.log
```
**Insight:** Monitor was perfect here because:
- Natural exit when condition met
- Single, clear event
- User action: continue if success, stop if failure

**Observation 2:** File change detection
```
Monitor: build success check
until [ -d build/html ] && [ "$(ls build/html | wc -l)" -gt 5 ]
```
**Insight:** Good pattern for validation after async tasks
- Polling is appropriate
- 30-second timeout was sufficient
- Single event = clean handoff

**Lesson for SKILL.md:** These are GOOD examples of Monitor usage: short-lived, goal-oriented, clear termination.

---

## Recommendations for SKILL.md Integration

1. **Add new section:** "Observability & Monitoring" → Move Monitor guidance here
2. **Create decision tree:** Agent vs Bash run_in_background vs Monitor
3. **Document 5 working examples:** Real patterns from Claude Code history
4. **Add anti-patterns section:** What NOT to do with Monitor
5. **Include timeout guidance:** Default is 300s, when to adjust
6. **Clarify batching behavior:** Document the 200ms window
7. **Add troubleshooting:** "Why is my Monitor hanging?" → check for buffering
8. **Reference this analysis** in SKILL.md: `See references/monitor-behavioral-guide.md`

---

**Status:** Analysis complete, ready for Phase 5 STRATEGY

**Next:** Propose specific SKILL.md sections + create reference documentation

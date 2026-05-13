```yml
created_at: 2026-04-25 13:00:00
project: IACT-docs
work_package: 2026-04-25-04-44-30-monitor-behavior-analysis
phase: Phase 6 — SCOPE
author: claude
status: Borrador
version: 1.0.0
```

# Monitor Integration Plan — Phase 6 SCOPE

**Goal:** Lock down scope for Monitor guidance integration into SKILL.md. Resolve research questions from Phase 5 STRATEGY.

---

## Research Questions → Decisions

### Q1: SKILL.md section placement?

**Options:**
- A: New top-level section "Herramientas de Ejecución Asincrónica"
- B: Expand existing "Escalabilidad" section
- C: Create separate reference doc (guidelines/monitor-streaming.md)

**DECISION: A — New top-level section**

**Rationale:**
- Monitor guidance applies to ALL WPs, not just large ones (Escalabilidad is size-dependent)
- Visibility: Top-level sections are discovered during SKILL.md review; buried sections are missed
- Scope: Monitor is distinct tool like Bash, Agent, etc. — warrants own section
- Evidence: Phase 1 synthesis shows Monitor is for "observability" (parallel concern to "scaling")

**Implementation:** Add new section after "Escalabilidad" section in SKILL.md

---

### Q2: Depth vs Breadth?

**Options:**
- A: 3-5 patterns + gotchas (compact, digestible)
- B: Expand to 10+ patterns (comprehensive)
- C: Minimal (decision tree only)

**DECISION: A — 3-5 patterns + gotchas + troubleshooting**

**Rationale:**
- Phase 1 identified 9 behavioral patterns, but only 5 are essential (3 good + 2 anti)
- Evidence: Session usage showed exactly these 5 patterns covering all real scenarios
- Balance: >5 patterns = cognitive load; <3 patterns = gaps in guidance
- Scope constraint: SKILL.md is already 500+ lines; Monitor section should be 250-300 lines max

**Implementation:** 
- Decision tree (10 lines)
- 3 good patterns (60 lines)
- 2 anti-patterns (60 lines)
- 4 gotchas with fixes (80 lines)
- Troubleshooting flowchart (40 lines)
- Integration examples (30 lines)
- Total: ~280 lines

---

### Q3: Examples sourcing?

**Options:**
- A: Use patterns from Monitor analysis WP (PROVEN in this session)
- B: Create synthetic "ideal" examples
- C: Reference external docs (Claude Code docs)

**DECISION: A — Use PROVEN patterns from analysis WP**

**Rationale:**
- Examples tested in real workflow: file validation polling, build log monitoring
- PROVEN examples have higher user trust than synthetic ideals
- Evidence: Monitor analysis WP documented exact conditions where each pattern worked
- Source: All 5 patterns backed by observation logs in Phase 1 DISCOVER

**Implementation:** Examples directly from monitor-behavior-deep-analysis.md Pattern sections 1.1-1.3

---

### Q4: Methodology integration?

**Options:**
- A: Monitor guidance independent of methodology
- B: Map Monitor patterns to THYROX phases
- C: Create new observability methodology

**DECISION: A — Independent tool guidance**

**Rationale:**
- Monitor is execution-level tool, not methodology-level decision point
- Evidence: Methodologies (PDCA, DMAIC, etc.) don't depend on Monitor; Monitor enables them
- Scope: Adding methodology-phase mapping would expand Phase 8-10 PLAN EXECUTION docs (out of scope)
- Clean separation: Tools section != Methodology section in SKILL.md

**Implementation:** No cross-references to phases; standalone tool guidance

---

### Q5: SKILL.md versioning?

**Options:**
- A: Add version field to SKILL.md (track Monitor section edits separately)
- B: Keep SKILL.md as living doc (no version)
- C: Create CHANGELOG for SKILL.md

**DECISION: B + minimal tracking**

**Rationale:**
- SKILL.md is policy doc (like CLAUDE.md), not software artifact
- Evidence: SKILL.md currently has no version; CLAUDE.md has `updated_at`
- CLAUDE.md pattern already in use: `updated_at` field (not version field)
- Minimal tracking: Just add `updated_at` to SKILL.md frontmatter

**Implementation:** 
- Add `updated_at: 2026-04-25 (Monitor section added)` to SKILL.md frontmatter
- No SemVer for SKILL.md

---

## Scope Statement

### In-Scope

✅ New "Herramientas de Ejecución Asincrónica" section (250-300 lines)

✅ Decision tree: when to use Monitor vs Bash vs Agent

✅ 5 core patterns:
- Pattern A: Polling with conditional exit (GOOD)
- Pattern B: Log tail with filtering (GOOD)  
- Pattern C: File system watch (GOOD)
- Pattern D: Unbounded log tail (BAD)
- Pattern E: No terminal state coverage (BAD)

✅ 4 critical gotchas + fixes:
- Pipe buffering → --line-buffered
- Silent failure → emit all terminal states
- Timeout destructive → conservative timeout
- Event batching transparent → filter at source

✅ Troubleshooting section:
- "Why is my Monitor hanging?" → diagnosis flowchart
- "Why too many events?" → aggregation patterns

✅ Integration examples:
- Monitor + Agent parallel
- Monitor + decision-making flow
- Monitor + Bash foreground

### Out-of-Scope

❌ Monitor performance metrics table (documented in Phase 1 analysis, not needed in SKILL.md)

❌ Methodology mapping (not relevant for tool guidance)

❌ Reference documentation (e.g., full Monitor lifecycle, timeout mechanics)

❌ Advanced patterns (e.g., Monitor + Agent feedback loops, conditional persistence)

---

## SKILL.md Changes

### New Section Location
After line 79 (end of "Escalabilidad" section):

```markdown
---

## Herramientas de Ejecución Asincrónica

### Monitor Tool: Streaming Observation

Use Monitor when you need **real-time visibility** into a long-running process.
Unlike `bash run_in_background` (fire-and-forget), Monitor emits events as the process produces output.

#### Decision Tree: When to Use Monitor

Does the command produce meaningful output?
├─ NO → Use Bash run_in_background (nothing to watch)
└─ YES → Do you need real-time visibility?
         ├─ NO → Use Bash run_in_background (fire-and-forget OK)
         └─ YES → Does command exit naturally (not `while true`)?
                  ├─ NO → Use persistent: true (unbounded stream)
                  └─ YES → Standard Monitor with timeout (normal case)

#### Core Patterns: Good & Bad

[3 good patterns + 2 bad patterns, ~120 lines]

#### Critical Gotchas

[4 gotchas with fixes, ~80 lines]

#### Troubleshooting

[Diagnosis flowchart + solutions, ~40 lines]

#### Integration with THYROX Tools

[Examples: Monitor + Agent, Monitor + decision flow, ~30 lines]

---

### Bash Tool: `run_in_background` for Fire-and-Forget

Use when the command needs to run asynchronously but you don't need to watch it.

[1-paragraph guidance, ~50 words]

---
```

### Section Statistics

| Section | Lines | Purpose |
|---------|-------|---------|
| Decision Tree | 12 | Quick mental model |
| Good Patterns (3) | 60 | Examples to follow |
| Bad Patterns (2) | 60 | Anti-patterns to avoid |
| Gotchas (4) | 80 | Common pitfalls + fixes |
| Troubleshooting | 40 | Diagnosis when things go wrong |
| Integration | 30 | Combining Monitor with other tools |
| **Total Monitor section** | ~282 | ~60% of new content |
| Bash guidance | 50 | Context/contrast |
| **Grand total** | ~332 | |

---

## Acceptance Criteria (Phase 6 Gate)

- ✅ 5 research questions answered with clear rationale
- ✅ Scope statement locked: 282 lines Monitor section
- ✅ Section placement confirmed: after "Escalabilidad" in SKILL.md
- ✅ Examples PROVEN: all 5 patterns documented from Phase 1 analysis
- ✅ No contradictions with existing THYROX guidance
- ✅ Scope is in-scope (out-of-scope list confirms what's NOT included)
- ✅ Line budget acceptable (282 lines, <1.5x current main section size)

---

## Next Phase: Phase 7 DESIGN/SPECIFY

**Task:** Create specifications for SKILL.md section:
- Exact code examples (copy-paste ready)
- Acceptance criteria for each pattern
- Validation checklist (SKILL.md builds, no syntax errors)
- Examples must run in isolation (no external dependencies)

**Deliverable:** 
- `design/monitor-behavior-analysis-requirements-spec.md` (specifications)
- `design/monitor-behavior-analysis-spec-checklist.md` (validation)

**Estimated effort:** 1 hour

---

## Risk Mitigations (from Phase 5)

| Risk | Mitigation | Status |
|------|-----------|--------|
| **Scope creep** | Limited to 5 patterns (3+2) | ✅ In scope |
| **Examples don't generalize** | All PROVEN from session | ✅ Sourced |
| **SKILL.md bloat** | 282 lines target (under budget) | ✅ Planned |
| **User confusion** | Decision tree addresses ambiguity | ✅ Designed |

---

## Commit Readiness

Phase 6 scope is locked. Ready for:
- Phase 7 DESIGN/SPECIFY (write actual SKILL.md examples)
- Phase 8 PLAN EXECUTION (decompose into T-001…T-010 tasks)
- Phase 10 IMPLEMENT (edit SKILL.md + validate)

**Current status:** ✅ SCOPE APPROVED

**Gate result:** Phase 6 → Phase 7 can proceed

---

**Author:** claude  
**Date:** 2026-04-25 13:00:00  
**Status:** Ready for Phase 7

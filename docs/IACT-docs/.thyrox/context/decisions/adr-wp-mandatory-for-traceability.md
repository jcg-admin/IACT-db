```yml
created_at: 2026-04-25 23:30:00
project: IACT-docs
decision_area: Governance and Traceability
status: Aprobado
author: NestorMonroy
relates_to: I-001 (DISCOVER before planning)
```

# ADR: Work Package Mandatory for Traceability

## Context

When users request implementation work, they may want to skip or minimize analysis phases (DISCOVER, DIAGNOSE, CONSTRAINTS, STRATEGY) to move directly to execution. This desire is understandable for:
- Urgent fixes
- Well-understood features
- Incremental improvements
- Operational maintenance

However, skipping analysis without proper artifact capture creates loss of traceability and institutional knowledge.

## Decision

**Claude MUST recommend creating a NEW Work Package when implementation crosses a context/domain boundary.**

**Within same domain:** Work on existing WP (same context, same artifacts, same WP history).
**Across domains:** Create new WP (different context, different stakeholders, different risk register).

**Decision logic:**
- User requests work in existing WP domain → Continue in current WP
- User requests work in DIFFERENT domain → Create new WP with Phase 1 DISCOVER

If a user says "implement X in a different context/domain", the response is:
1. Create a new WP (with Phase 1 DISCOVER, even if minimal)
2. Document the rationale (why this is a separate effort)
3. Proceed to execution phases
4. Track artifacts properly

The work is NOT done without proper WP alignment — WPs are the unit of traceability and institutional memory in THYROX.

## Rationale

**Domain-aware WP management:** WPs represent distinct contexts. Work within the same context shares:
- Same risk register
- Same stakeholders
- Same architectural constraints
- Same success criteria

**When domains collide:**
Example from IACT-docs: Working on Sphinx/RST (Phase B: Documentation Completeness) then shifting to GitHub Actions (CI/CD infrastructure). These are orthogonal domains with:
- Different risks (Sphinx compilation vs. GitHub runners)
- Different constraints (RST syntax vs. YAML workflow syntax)
- Different owners (documentation team vs. DevOps infrastructure)

**Cost of ignoring domain boundaries:**
- ❌ Risk register gets polluted (RST risks + CI/CD risks mixed)
- ❌ Exit conditions become incoherent (success criteria for RST ≠ success for CI/CD)
- ❌ Execution logs become unclear (which task belongs to which domain?)
- ❌ Lessons learned apply to wrong domain (RST lesson irrelevant to GitHub Actions)

**Benefit of respecting domain boundaries:**
- ✅ Clean separation of concerns
- ✅ Clear risk management per domain
- ✅ Transferable lessons (other GitHub Actions projects benefit from this WP)
- ✅ Traceable effort (each domain has its own WP history)

## Examples

### Example 1: Same domain, same WP

**Context:** Currently in WP `iact-project-state-assessment` (Sphinx configuration, RST formatting)

**User:** "Just fix the PlantUML path error in test-uc-diagram.rst"

**Claude response:**
> This is within the current WP domain (Sphinx/RST). I'll fix it in the active WP:
> - Phase 10 EXECUTE: Fix file, validate build, commit to current WP
> - Update current WP execution log
>
> Then proceed with the fix.

**No new WP created** — same domain, same execution context.

---

### Example 2: Different domain, different WP

**Context:** Currently in WP `iact-project-state-assessment` (Sphinx configuration)

**User:** "Let's implement GitHub Actions for CI/CD automation"

**Claude response:**
> This crosses into a different domain (.github, CI/CD infrastructure, not Sphinx). 
> I'll create a new WP to maintain proper context:
> - WP: 2026-04-25-22-47-23-github-actions-setup/
> - Phase 1 DISCOVER: Analyze current state, identify problems in CI/CD
> - Phase 6 PLAN: Scope GitHub Actions Phase 1
> - Phase 10 EXECUTE: Create .github/ files
>
> Then proceed with full THYROX flow for the new domain.

**New WP created** — different domain, different stakeholders, different risks.

## Impact

**Cost:** Minimal (5-10 min overhead per WP for Phase 1 DISCOVER synthesis)
**Benefit:** Complete traceability, institutional memory, risk management

This rule replaces ad-hoc "let me just do this" implementations with structured, documented work.

## Alternatives Considered

1. **No WP for small fixes** → REJECTED (breaks traceability)
2. **Phase 1 DISCOVER is optional** → REJECTED (I-001 locked decision requires analysis-first)
3. **Abbreviated WP format for quick work** → ACCEPTED as implementation detail (Phase 1 can be 5 min vs 30 min for large features)

## Related Decisions

- [adr-analyze-first.md](adr-analyze-first.md) — DISCOVER before planning (I-001)
- [adr-arquitectura-orquestacion-thyrox.md](adr-arquitectura-orquestacion-thyrox.md) — WP structure and lifecycle

## Implementation Note

**Decision tree for Claude:**

1. Is this work within the current WP domain?
   - YES → Continue in current WP (same Phase/context)
   - NO → Ask: "This looks like a different domain. Should I create a new WP?"

2. User confirms domain switch?
   - YES → Create new WP with Phase 1 DISCOVER
   - NO → Stay in current WP

**Proactive recommendation:** When user starts talking about a clearly different domain (different tech stack, different stakeholders, different risk profile), recommend new WP explicitly. Don't wait for objection.

**Example trigger phrases for "recommend new WP":**
- "Let's implement CI/CD automation" (while working on docs structure)
- "We need security hardening" (while fixing bugs)
- "Add a database layer" (while working on frontend)
- "Deploy to production" (while still developing locally)

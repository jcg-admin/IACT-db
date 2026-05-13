```yml
created_at: 2026-04-25 09:20:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 5 — STRATEGY
author: Claude Code Agent
status: Propuesta
```

# ADR: PlantUML Naming Conventions (POSIX _prefix for Private Members)

## Decision

Adopt POSIX `_prefix` convention for private/internal members in `plantuml-styles.puml`:
- **Public API** (recommended for diagram authors): `backgroundColor`, `actorBackground`, `messageFont`
- **Private/Internal** (for maintainers only): `_coreCorporateBlue`, `_internalSpacing`, `_legacySkinparam`

## Context

PlantUML 1.2025.0 provides extensive customization via:
1. `skinparam` — global configuration parameters
2. `<style>` blocks — modern selector-based styling
3. `!include` — inclusion of centralized definitions

The `plantuml-styles.puml` file will contain 50-100+ parameters across 5 diagram type sections (UC, Sequence, Activity, Class, State). Without a clear naming convention, it becomes unclear:
- Which parameters are safe to use in diagrams
- Which parameters are implementation details
- How to document public API vs. internal details

## Decision Drivers

1. **Clarity**: Distinguish public API (for diagram authors) from internal implementation (for maintainers)
2. **Scalability**: As plantuml-styles.puml grows, maintainability requires clear ownership of parameters
3. **Documentation**: GUIDELINES.md can reference "use public parameters only" with clear examples
4. **Clean Code**: Robert Martin's Clean Code principle: private members signal "don't use this"

## Options Considered

### Option A (Chosen): POSIX _prefix Convention

**Pattern:**
```
_internalParameter  → private/implementation detail
publicParameter     → public API, safe to use
```

**Examples:**
```
_coreCorporateBlue = #0033AA      (internal constant)
backgroundColor = _coreCorporateBlue  (public parameter, uses internal)

_legacySkinparam = ... (old syntax, keep for compatibility)
actorBackground = ...  (public parameter, recommended)
```

**Pros:**
- Standard in Unix/POSIX conventions
- Clear visual distinction
- No additional syntax overhead
- Widely recognized in programming communities

**Cons:**
- Slightly longer variable names
- Requires discipline to maintain

### Option B: camelCase with Documentation Comments

**Pattern:**
```
// PRIVATE: internal implementation
_internalVar = ...

// PUBLIC: safe for diagram authors
publicVar = ...
```

**Pros:**
- Explicit comments clarify intent
- Backward compatible

**Cons:**
- Relies on comments (can rot)
- Not visually distinct
- More verbose

### Option C: Separate Files

**Pattern:**
```
plantuml-styles-public.puml  → only parameters for diagram authors
plantuml-styles-internal.puml  → implementation details
```

**Pros:**
- Very clear separation
- Easy to document "use only public file"

**Cons:**
- Complicates !include logic
- Harder to maintain consistency

## Decision

**Chosen: Option A (POSIX _prefix convention)**

Rationale:
- Minimal overhead (1 character: `_`)
- Immediately recognizable to developers
- Standard in Unix/POSIX ecosystem
- Scalable as plantuml-styles.puml grows
- Self-documenting (no comments required)
- Easy to enforce via code review

## Consequences

### Positive

1. **Clarity**: Diagram authors immediately know which parameters to use
2. **Maintainability**: Maintainers can refactor internal parameters without worrying about external dependencies
3. **Documentation**: GUIDELINES.md can state: "Use only parameters WITHOUT _ prefix"
4. **Extensibility**: New parameters follow same convention

### Negative

1. **Naming Overhead**: Parameters are slightly longer
2. **Migration**: If converting existing styles, need to rename all public parameters (one-time cost)
3. **Tooling**: No automatic enforcement (relies on code review)

## Implementation

### In plantuml-styles.puml (Phase 1 Setup)

```plantuml
' Global corporate constants (PRIVATE — do not use directly)
_corporateBlue = #0033AA
_corporateGray = #666666
_whitespace = 12

' Public API (RECOMMENDED — safe for diagram authors)
backgroundColor = _corporateBlue
actorBackground = _corporateGray
messageFont = monospaced
```

### In GUIDELINES.md (Phase 1 Setup)

```
## PlantUML Styling Guidelines

### Using Centralized Styles

All diagrams inherit styles from `source/_static/plantuml-styles.puml`.

**Public parameters (recommended):**
- `backgroundColor` — background color for diagram
- `actorBackground` — actor/entity background
- `messageFont` — font for sequence messages
- `activityBox` — activity/action background
- (see full list below)

**Internal parameters (do NOT use):**
Parameters starting with `_` are implementation details.
Avoid using them — they may change without notice.

Example — DO THIS:
\`\`\`plantuml
!include ../../../_static/plantuml-styles.puml
usecase (Login) as UC1
\`\`\`

Example — DON'T DO THIS:
\`\`\`plantuml
!include ../../../_static/plantuml-styles.puml
skinparam _internalSpacing 20  ← NO, don't use _internal parameters
\`\`\`
```

### In Code Review Checklist (Phase 7 DESIGN)

When reviewing new diagrams:
- [ ] Diagram includes !include ../../../_static/plantuml-styles.puml
- [ ] Diagram does NOT define custom skinparam (uses inherited styles)
- [ ] Diagram does NOT reference _ prefixed parameters
- [ ] Diagram is readable and semantically correct

## Validation

**Phase 1 Setup:**
- Define 20-30 public parameters in plantuml-styles.puml
- Create test UC using only public parameters
- Verify Sphinx build renders correctly
- Document in GUIDELINES.md

**Phase 10 EXECUTE:**
- Review all 100+ diagrams
- Verify none reference _ prefixed parameters
- Refactor if violations found

## Related Decisions

- ADR: PlantUML Two-Tier Centralization Strategy (Phase 5 STRATEGY)
- ADR: Diagram Type Classification (Phase 5 STRATEGY, within solution-strategy.md)

## References

- Phase 5 Solution Strategy: `strategy/plantuml-java-integration-impl-solution-strategy.md`
- Clean Code by Robert Martin — Chapter 2: Meaningful Names
- POSIX Naming Conventions — https://pubs.opengroup.org/onlinepubs/9699919799/


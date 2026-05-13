```yml
created_at: 2026-04-25 12:10:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 10 — EXECUTE
author: NestorMonroy
status: Ejecutado
decision_type: Structural Reorganization
```

# Decision: Create `source/plantuml-guide/` Domain

## Problem Statement

The current `source/discover/` directory contains PlantUML styling documentation, but the name is ambiguous:
- "discover" could mean "discovery phase" (process concept)
- Actual content is "PlantUML centralized styling guide" (documentation/standards concept)
- Grows with examples that don't fit semantic of "discovery"

## Decision

Rename and restructure:
- **Before:** `source/discover/` (ambiguous naming)
- **After:** `source/plantuml-guide/` (explicit, clear purpose)

Add subdirectory for examples:
- `source/plantuml-guide/ejemplos/` — runnable diagram examples

## Rationale

1. **Clarity:** Explicit domain name = clearer intent
2. **Scalability:** Can grow with more diagram types (sequences, states, activities) without naming conflicts
3. **Hierarchy:** Examples separated from guidelines (parent/child relationship)
4. **Consistency:** Matches naming of other domains (base_cognitiva, arquitectura_tecnica, etc.)

## Scope

### Rename
- `source/discover/` → `source/plantuml-guide/`

### Reorganize
```
source/plantuml-guide/
├── index.rst                      (main entry point)
├── color-palette.rst              (color system definition)
├── GUIDELINES.rst                 (usage guide + 3 examples)
├── ejemplos/                      (new subdirectory)
│   ├── test-uc-diagram.rst        (moved from root)
│   ├── test-component-diagram.rst (moved from root)
│   ├── sistema-completo.rst       (future: complete system diagram)
│   └── etl-pipeline.rst           (future: ETL process diagram)
└── _static/                       (if any local assets needed)
```

### Update References
- `source/index.rst` toctree: discover → plantuml-guide
- All cross-references in docs
- ADR references (if any)

## Implementation Steps

1. ✅ Create ADR documenting this decision
2. ⏳ Rename directory: discover → plantuml-guide
3. ⏳ Create ejemplos/ subdirectory
4. ⏳ Move test-*.rst to ejemplos/
5. ⏳ Create placeholder files (sistema-completo.rst, etl-pipeline.rst)
6. ⏳ Update index.rst files and cross-references
7. ⏳ Update source/index.rst toctree
8. ⏳ Single comprehensive commit

## Future Growth

This structure allows natural expansion:
- Add more diagram examples without polluting root
- Create dedicated subdirectories for each diagram type later
- Could evolve into: `plantuml-guide/{uml,sequences,activities,states,examples}/`

## Status

**Decision:** APPROVED (2026-04-25)
**Implementation:** Phase 10 EXECUTE continuation
**Branch:** feature/project-setup

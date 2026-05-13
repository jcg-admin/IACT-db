```yml
created_at: 2026-04-26 02:30:00
project: IACT-docs
work_package: 2026-04-25-22-13-43-iact-project-state-assessment
phase: Phase 3 — ANALYZE
author: Claude
status: Aprobado
version: 1.0.0
```

# Analysis: PlantUML Mapping & Consolidation Strategy

## Executive Summary

**Finding:** PlantUML ecosystem is FRAGMENTED with THREE DIVERGENT SOURCES
- Two style files (`.puml` and `.iuml`) with different color palettes
- Architecture diagrams using inline styles (not centralized)
- Style file in `casos_uso/` completely orphaned (never referenced)
- **Zero PlantUML diagrams rendered in actual documentation** (only in examples)

**Recommendation:** Consolidate to SINGLE authoritative style system before implementing production diagrams

---

## 1. Current State: Three Divergent Systems

### System 1: `plantuml-styles.puml` (Phase A)

**Location:** `/source/_static/plantuml-styles.puml`  
**Version:** Phase 1 Setup (2026-04-25)  
**Status:** Active (referenced in plantuml-guide/)

**Color Palette:**
- Core corporate colors: Blue, Green, Orange, Red, Purple, Gray
- POSIX `_private` convention for internal variables
- Public parameters: `coreBlue`, `coreGreen`, etc.
- Generic, framework-style approach

**Coverage:**
- ✅ Use case (actor/interaction)
- ✅ Class (structure)
- ✅ Sequence (interaction)
- ✅ Activity (flow)
- ✅ Component (architecture)
- ✅ Interface
- Hide directives (footbox, members, circle, empty fields)

**Usage:**
- ✅ `plantuml-guide/ejemplos/*.rst` (test diagrams)
- ✅ `plantuml-guide/GUIDELINES.rst` (documentation)
- ✅ `plantuml-guide/METADATA-STANDARD.rst` (standards)

### System 2: `plantuml_styles.iuml` (casos_uso)

**Location:** `/source/requisitos/casos_uso/_static/plantuml_styles.iuml`  
**Version:** 4.0.0 (2026-01-06)  
**Status:** ORPHANED (never referenced anywhere)

**Color Palette:**
- Module-specific colors: AUTH, USERS, ACCESS, PIPELINE, REPORTS, ALERTS, AUDIT, LOGS
- IACT-specific branding
- More detailed than .puml
- Rich feature set for use cases

**Coverage:**
- ✅ Use case (detailed)
- ✅ Sequence (detailed)
- ✅ Activity (detailed)
- ✅ Component (not shown in excerpt)
- Module-based color coding

**Usage:**
- ❌ Zero references in any `.rst` or `.puml` file
- ❌ Header comment says "Uso: !include ../_static/plantuml_styles.iuml" but NEVER done
- ❌ Completely disconnected from rest of system

### System 3: Inline Styles (arquitectura/)

**Location:** `/source/arquitectura_tecnica/arquitectura/`  
**Files:**
- `sistema_iact_contexto.puml`
- `permisos_granular_arquitectura.puml`

**Status:** Self-contained (no !include, no external styles)

**Color Palette (sistema_iact_contexto example):**
```plantuml
!define SYSTEM_COLOR #3498DB         (blue)
!define EXTERNAL_COLOR #95A5A6       (gray)
!define USER_COLOR #E74C3C           (red)
```

**Problem:**
- ❌ NOT using centralized styles
- ❌ Inline definitions prevent theme consistency
- ❌ No module-based color coding
- ❌ Diverges from both `.puml` and `.iuml`

---

## 2. Diagram Usage Survey

### Question: Are PlantUML diagrams actually rendered in documentation?

**Search Results:**

| Category | Status | Details |
|----------|--------|---------|
| RST files with `.. plantuml::` | ❌ ZERO | No actual diagram directives in production docs |
| PlantUML in `casos_uso/` | ❌ ZERO | Only text mentions, no actual diagrams |
| PlantUML in `plantuml-guide/` | ✅ Examples only | Test diagrams in `ejemplos/` subdirectory |
| PlantUML in `arquitectura_tecnica/` | ✅ 2 diagrams | Inline styled, not using centralized system |
| Active includes in `.rst` files | ✅ 7 references | All in `plantuml-guide/` (not production) |

**Conclusion:** 
- **Production documentation:** ZERO PlantUML diagrams implemented
- **Learning/examples:** 4 test diagrams (plantuml-guide/ejemplos/)
- **Architecture diagrams:** 2 diagrams with inline styles (not using centralization)

---

## 3. Include Path Analysis

### Valid Includes (working):
```
/source/plantuml-guide/ejemplos/test-uc-diagram.rst:
   !include ../../_static/plantuml-styles.puml  ✅ WORKS

/source/plantuml-guide/ejemplos/sistema-completo.rst:
   !include ../../_static/plantuml-styles.puml  ✅ WORKS
```

### Orphaned Header (never used):
```
/source/requisitos/casos_uso/_static/plantuml_styles.iuml:
   ' Uso: !include ../_static/plantuml_styles.iuml  ❌ NEVER CALLED
```

### Inline Definitions (not using includes):
```
/source/arquitectura_tecnica/arquitectura/sistema_iact_contexto.puml:
   !define SYSTEM_COLOR #3498DB  ❌ NOT USING CENTRALIZED STYLES
```

---

## 4. Consolidated Comparison Table

| Aspect | plantuml-styles.puml | plantuml_styles.iuml | sistema_iact_contexto.puml |
|--------|-----|-----|-----|
| **Status** | Active | Orphaned | Active (inline) |
| **Used in production** | ❌ No | ❌ No | ✅ Yes (2 files) |
| **Used in examples** | ✅ Yes | ❌ No | ❌ No |
| **Color system** | Generic corporate | IACT modules | Hard-coded inline |
| **Maintenance burden** | Low (centralized) | High (orphaned) | High (scattered) |
| **Version control** | Phase A (2026-04-25) | v4.0.0 (2026-01-06) | Unknown (inline) |
| **POSIX conventions** | ✅ Yes | ❌ No | ❌ No |
| **Diagram type support** | ✅ Full | ✅ Full | ⚠️ Partial (Context only) |

---

## 5. ROOT CAUSE ANALYSIS

### Why is PlantUML fragmented?

1. **Timeline Divergence**
   - `plantuml_styles.iuml` created January 2026 for casos_uso/
   - `plantuml-styles.puml` created Phase A (April 2026)
   - No synchronization between initiatives

2. **No Centralized Strategy**
   - Two teams/phases independently created style systems
   - No single source of truth established
   - Different color philosophies (generic vs. IACT-specific)

3. **Architecture Diagrams Added Later**
   - Post-consolidation, diagrammers used inline styles
   - Never linked to any centralized system
   - No governance for new diagrams

4. **Orphaned IUML File**
   - Planned for casos_uso/ but never implemented
   - No diagrams actually created to use it
   - Became dead code

---

## 6. Consolidation Strategy: THREE OPTIONS

### OPTION A: Adopt plantuml-styles.puml (Phase A Generic)

**Action:**
1. Keep `/source/_static/plantuml-styles.puml` as canonical
2. Delete `/source/requisitos/casos_uso/_static/plantuml_styles.iuml`
3. Update `sistema_iact_contexto.puml` to use `!include`
4. Update `permisos_granular_arquitectura.puml` to use `!include`
5. Document in GUIDELINES: always use `!include ../../_static/plantuml-styles.puml`

**Pros:**
- ✅ Single file to maintain
- ✅ Already integrated with Phase A
- ✅ Clean, generic approach
- ✅ Works for all diagram types

**Cons:**
- ❌ Loses IACT module-specific colors (COLOR_AUTH, COLOR_PIPELINE, etc.)
- ❌ Less domain-specific branding
- ❌ Throws away v4.0 work from casos_uso

**Effort:** 30 minutes

---

### OPTION B: Merge into Enhanced plantuml-styles.puml

**Action:**
1. Read both files
2. Create merged version combining:
   - Generic structure from `plantuml-styles.puml`
   - IACT module colors from `plantuml_styles.iuml`
   - POSIX conventions from Phase A
3. Replace `/source/_static/plantuml-styles.puml`
4. Delete orphaned `plantuml_styles.iuml`
5. Update diagrams to use merged version

**Merged file would include:**
```plantuml
' ============================================
' CORE CORPORATE (Generic)
' ============================================
!define _coreCorporateBlue #0066CC
!define coreBlue _coreCorporateBlue
...

' ============================================
' IACT MODULE SPECIFIC (From v4.0)
' ============================================
!define COLOR_AUTH #3B82F6
!define COLOR_PIPELINE #F59E0B
!define COLOR_REPORTS #10B981
...

' ============================================
' USE CASE STYLING
' ============================================
skinparam usecase {
  ... (combined best practices)
}
```

**Pros:**
- ✅ Single authoritative file
- ✅ Preserves IACT module branding
- ✅ Combines best of both approaches
- ✅ Strongest for domain-specific use cases
- ✅ Honors v4.0 investment

**Cons:**
- ⚠️ More complex file (~300-400 lines)
- ⚠️ Requires careful merge to avoid conflicts
- ⚠️ Needs testing with all diagram types

**Effort:** 1-2 hours (merge + test + doc)

**RECOMMENDATION:** ⭐ OPTION B (Best balance)

---

### OPTION C: Keep Separate Systems (Not Recommended)

**Action:** Do nothing. Live with fragmentation.

**Pros:**
- ✅ No work required

**Cons:**
- ❌ Maintenance nightmare
- ❌ Color inconsistency across diagrams
- ❌ Dead code (orphaned .iuml)
- ❌ Violates DRY principle
- ❌ Makes onboarding impossible
- ❌ Makes future consolidation harder

**Not Recommended:** Will cause debt.

---

## 7. Consolidation Roadmap

### Phase 1: Merge Styles (1-2 hours)

**Step 1.1: Create Merged File**
```bash
# Read both files
# Extract unique sections from .iuml
# Extract structure from .puml
# Create merged version with POSIX conventions
# File: /source/_static/plantuml-styles.puml (REPLACE)
```

**Step 1.2: Validate Merged File**
```bash
# Test merge against each diagram type:
# - Use case (from casos_uso guidance)
# - Sequence (from both files)
# - Activity (from both files)
# - Component (from arquitectura)
```

**Step 1.3: Clean Up**
```bash
# Delete: /source/requisitos/casos_uso/_static/plantuml_styles.iuml
# Delete: outdated comments/headers
```

### Phase 2: Update Production Diagrams (30 min)

**Step 2.1: Add Includes**
```
# Update: /source/arquitectura_tecnica/arquitectura/sistema_iact_contexto.puml
# Change: Remove inline !define SYSTEM_COLOR, etc.
# Add:    !include ../../../_static/plantuml-styles.puml

# Update: /source/arquitectura_tecnica/arquitectura/permisos_granular_arquitectura.puml
# Same pattern
```

**Step 2.2: Use Centralized Colors**
```plantuml
' BEFORE:
!define SYSTEM_COLOR #3498DB

' AFTER:
!include ../../../_static/plantuml-styles.puml
' Now use: coreBlue, coreGreen, corePurple, etc.
```

### Phase 3: Implement Missing Diagrams (TBD)

**casos_uso/ Still Needs:**
- ❌ Actual UC diagrams for auth, users, access, pipeline, reports, alerts, audit, logs
- ❌ Sequence diagrams for workflows
- ❌ Activity diagrams for processes

**Status:** Deferred to Phase C/D or new WP

### Phase 4: Document Standards (20 min)

**Update:** `plantuml-guide/GUIDELINES.rst`
- [ ] "Always include merged `plantuml-styles.puml`"
- [ ] "Use these colors for module-specific diagrams"
- [ ] "Include path: `!include ../../../_static/plantuml-styles.puml`"
- [ ] "Examples of each diagram type"

---

## 8. Implementation Blockers & Risks

### Blocker 1: Merge Conflict Resolution
**Risk:** Combining two color systems might create conflicts
**Mitigation:** Manual code review + test against all diagram types

### Blocker 2: Architecture Diagrams Not Rendering
**Risk:** Changing inline styles might break existing diagrams
**Mitigation:** Test locally before committing

### Blocker 3: No Actual Implementation Yet
**Risk:** We're consolidating styles for diagrams that don't exist yet
**Mitigation:** OK — prepare foundation for future implementation

---

## 9. Success Criteria

After consolidation, these should be TRUE:

- [ ] Single `/source/_static/plantuml-styles.puml` (merged)
- [ ] Zero orphaned style files
- [ ] All architecture diagrams use `!include`
- [ ] GUIDELINES.rst documents consolidated approach
- [ ] Merged file tested against ≥4 diagram types
- [ ] `plantuml_styles.iuml` deleted
- [ ] METADATA-STANDARD.rst updated to reference merged file

---

## 10. Conclusion: Consolidation Enables Implementation

**Current State:** Fragmented, unclear, orphaned files

**After Consolidation:** 
- ✅ Single source of truth
- ✅ IACT branding preserved
- ✅ Architecture diagrams migrated
- ✅ Ready for casos_uso implementation
- ✅ Clear standards in place

**Timeline:** 2-3 hours work

**Critical:** Do consolidation BEFORE implementing casos_uso diagrams

---

**Analysis Completed:** 2026-04-26 02:30:00  
**Recommendation:** Execute OPTION B (Merge + Test)  
**Next Step:** Create Phase C task plan for consolidation + implementation

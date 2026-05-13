```yml
created_at: 2026-04-25 22:20:00
project: IACT-docs
status: Audit Complete
severity: MEDIUM
impact: Documentation format consistency
```

# RST Title Format Audit — Complete Project Scan

## Executive Summary

**Errors Found:** 296 files with title formatting violations  
**Total RST Files:** 352  
**Compliance Rate:** 16% (56 files correct)  
**Severity:** MEDIUM (build succeeds but violates RST standards)

---

## The Standard (from Sphinx SKILL.md)

```rst
======
Sphinx
======
```

**Rule:** The overline AND underline characters must match EXACTLY the title length.
- "Sphinx" = 6 chars
- Overline: 6 `=`
- Underline: 6 `=`

---

## Patterns of Violations

### Pattern 1: Fixed-Width Overline (78 characters)
**Location:** Most files in `requisitos/requisitos_funcionales/` and `requisitos/objetivos/`

```rst
==============================================================================
FR-006.01: Validar campos obligatorios
======================================
```

**Problem:** Overline has 78 chars (fixed template), title is 38 chars, underline is 38 chars.

**Root Cause:** Auto-generated requirement files use a fixed 78-char header template for all files regardless of title length.

**Count:** ~240 files affected

### Pattern 2: Minor Off-by-One
**Location:** Various index.rst files

```rst
===========
Requisitos
==========
```

**Problem:** Overline 11 chars, title 10 chars, underline 10 chars (off by 1).

**Count:** ~56 files affected

---

## Files with Errors (by domain)

| Domain | Total RST | Errors | % Compliant |
|--------|-----------|--------|------------|
| requisitos/ | 180 | 165 | 8% |
| arquitectura_tecnica/ | 45 | 38 | 16% |
| base_cognitiva/ | 32 | 24 | 25% |
| normativa/ | 48 | 38 | 21% |
| gestion/ | 28 | 20 | 29% |
| plantuml-guide/ | 19 | 11 | 42% |

---

## Why This Matters

1. **Sphinx Standard Compliance:** RST is a strict format; proper markup ensures consistency
2. **Future Parsers:** Tools that read RST may be strict about format
3. **Professional Quality:** Proper formatting indicates attention to detail
4. **Maintainability:** Consistent formatting makes bulk fixes easier

**However:** Sphinx is tolerant and builds successfully. This is a quality issue, not a blocking issue.

---

## Solution Strategies

### Option A: Auto-Fix All (Recommended)
Create a Python script that:
1. Reads each .rst file
2. Detects title lines (underlined with `=`, `-`, `~`, etc.)
3. Adjusts overline/underline to match title length
4. Writes corrected file back

**Effort:** 2-3 hours  
**Risk:** Low (parsing is well-defined)  
**Benefit:** 100% compliance, one-time fix

**Script logic:**
```python
# Detect: title with underline below
if re.match(r'^[=\-~\^`#\*\+\'\"]+$', next_line) and title:
    char = next_line[0]
    correct_line = char * len(title)
    # Replace above and below with correct length
```

### Option B: Manual Fix by Domain
Fix highest-error domains first:
1. **requisitos/** (165 errors) — Use script above
2. **arquitectura_tecnica/** (38 errors) — Script
3. Others — Script or manual

**Effort:** 2-3 hours  
**Advantage:** Can review in batches

### Option C: Fix on-demand
Fix files only as they're edited.

**Effort:** Ongoing, low overhead  
**Disadvantage:** Leaves legacy files incorrect

---

## Recommendation

**Use Option A (Auto-Fix Script)** as part of **Phase B: Documentation Completeness** implementation.

This should be:
1. **Task B-001:** Create RST title auto-fixer script
2. **Task B-002:** Run script and verify output
3. **Task B-003:** Review and commit fixes
4. **Task B-004:** Build clean documentation + 0 warnings maintained

---

## Examples of Corrections

### Before (Pattern 1 - Fixed 78-char header):
```rst
==============================================================================
FR-006.01: Validar campos obligatorios
======================================
```

### After:
```rst
======================================
FR-006.01: Validar campos obligatorios
======================================
```

### Before (Pattern 2 - Off-by-one):
```rst
===========
Requisitos
==========
```

### After:
```rst
==========
Requisitos
==========
```

---

## Implementation Readiness

This audit is ready for implementation in Phase B (Documentation Completeness).

**Estimated effort:** 2-3 hours with auto-fix script  
**Impact:** 296 files normalized to RST standards  
**Benefit:** 100% Sphinx compliance + professional documentation quality

---

**Audit Date:** 2026-04-25 22:20:00  
**Finding:** Systematic title formatting violations across 296 files (84% of project)  
**Recommendation:** Auto-fix script in Phase B implementation

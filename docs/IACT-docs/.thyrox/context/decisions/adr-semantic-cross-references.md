# ADR: Use Semantic Cross-References (`:ref:`) Over Path-Based (`:doc:`)

**Date:** 2026-04-23  
**Status:** DECIDED  
**Work Package:** 2026-04-23-07-04-55-config-review-iact-docs

---

## Context

The IACT-docs project had two types of cross-references:

1. **Path-based:** `:doc:/path/to/document`
2. **Label-based:** `:ref:`label-name``

### Problem with Path-Based References

**Initial state:** 32 broken `:doc:` references generating warnings

**Example of fragility:**
```rst
# In document A:
See :doc:`/requisitos/casos_uso/reports/UC_RPT_01_Ver_Dashboard`
                                  ↑ This path is fragile!

# If someone refactors structure:
# /requisitos/casos_uso/ → /requisitos/use_cases/
# The `:doc:` link breaks immediately
```

**Warnings generated:**
```
ref.doc: Unknown directive called "doc"
(Sphinx can't find the file at the specified path)
```

**Root cause:** Path-based links are tightly coupled to filesystem structure.

### Scale of Problem

- 32 broken `:doc:` links in codebase
- Some paths outdated from previous refactoring
- Others fragile by design

---

## Decision

**Migrate from `:doc:` (path-based) to `:ref:` (label-based) cross-references.**

### Rationale

1. **Decoupling:** Labels are semantic, independent of filesystem location
   - Can move file to different directory
   - Reference still works (label goes with the file)
   - Path-based references break immediately on move

2. **Robustness:** `:ref:` is the standard Sphinx pattern
   - Used in official Sphinx documentation
   - Validated by Sphinx during build
   - Can auto-generate links without knowing path

3. **Maintainability:** Future refactoring becomes safe
   - Move files freely (label follows)
   - Rename directories (references unaffected)
   - Reorganize structure (links still work)

4. **Clarity:** Labels are semantic and self-documenting
   ```rst
   # What is this?
   :ref:`uc-rpt-01-ver-dashboard`  ← Clear: UC Reports 01 View Dashboard
   
   # vs.
   :doc:`/requisitos/casos_uso/reports/UC_RPT_01_Ver_Dashboard`  ← Harder to remember
   ```

---

## Implementation

### Pattern

**Step 1: Define label in target document**
```rst
# source/requisitos/casos_uso/reports/UC_RPT_01_Ver_Dashboard.rst

.. _uc-rpt-01-ver-dashboard:

==================================
UC_RPT_01 Ver Dashboard
==================================

(document content...)
```

**Step 2: Reference label in source document**
```rst
# In another document that needs to reference UC_RPT_01:

See :ref:`uc-rpt-01-ver-dashboard` for details.
```

### Label Naming Convention

**Pattern:** `{domain}-{module}-{id}-{slug}`

**Examples:**
```
uc-rpt-01-ver-dashboard
  ↑     ↑  ↑  ↑
  domain module id slug

uc-auth-01-login
uc-access-010-assign-functions
fr-acc-010-001-create-assignment
meta-02-classification
gob-05-version-control
```

**Rules:**
- All lowercase
- Words separated by hyphens
- Reflects document hierarchy/content
- Should be meaningful to readers

### Files Modified

**Target documents (where labels added):**
- All UC_* files (use case overview files)
- All FR_* files that are referenced elsewhere
- Metadata files (META_01 through META_05)
- Governance files (GOB_* files)
- Index files for modules

**Source documents (where `:doc:` → `:ref:`):**
- Documents with broken `:doc:` links (~32 locations)
- RTM (Requirements Traceability Matrix) links
- Cross-domain references

### Validation

```bash
# Find all `:ref:` references:
$ grep -r ":ref:" source/

# Find all label definitions:
$ grep -r ".. _" source/

# Compare: every :ref: should have corresponding label

# Sphinx validates automatically:
$ make clean && make html
# If any :ref: is undefined, Sphinx warns
```

---

## Consequences

### Positive

1. **Refactoring safety:** Move/rename files without breaking links
2. **Maintenance clarity:** Documents have explicit "I am referenced from here" information
3. **Better error messages:** Sphinx clearly states which labels are missing
4. **Industry standard:** Matches patterns used in Django docs, Python docs, Sphinx docs
5. **Semantic meaning:** Labels document intent, not filesystem structure

### Negative

1. **Requires discipline:** Every referenceable document needs a label
   - **Mitigation:** Add this to the contribution guidelines
   - **Validation:** Pre-commit hook can check for orphaned references

2. **Label naming conflict potential:** Two documents might use same label
   - **Mitigation:** Follow naming convention strictly
   - **Validation:** Sphinx detects duplicate labels as errors

3. **More plumbing:** Need to define labels in every referenceable document
   - **Mitigation:** Pattern becomes clear after first few files
   - **Standard practice:** All professional docs projects do this

---

## Alternatives Considered

### Option A: Keep `:doc:` Links, Update Paths
**Rejected** because:
- Temporary fix only (breaks again on next refactor)
- Still fragile to reorganization
- Doesn't solve the fundamental design problem

### Option B: Use intersphinx for Cross-References
**Rejected** because:
- intersphinx is for external projects (Python stdlib, etc.)
- Overkill for internal cross-references
- `:ref:` is simpler and appropriate

### Option C: Generate Links Programmatically
**Rejected** because:
- Would require custom Sphinx extension
- Complex for minimal gain
- Standard `:ref:` pattern already solves the problem

---

## Related Decisions

- **ADR: Hierarchical Toctree Structure** — Defines document discovery/location
- **ADR: Decouple MyST Parser** — Clears noise so cross-reference validation is visible

---

## Label Inventory

**Labels added in this work package:**

| Label | Document | Type | Purpose |
|-------|----------|------|---------|
| `uc-auth-01-login` | UC_AUTH_01_Iniciar_Sesion.rst | UseCase | Cross-ref from RTM, other modules |
| `uc-rpt-01-ver-dashboard` | UC_RPT_01_Ver_Dashboard.rst | UseCase | Cross-ref example |
| `meta-02-classification` | META_02_Clasificacion_Documental.rst | Metadata | Document type reference |
| `meta-03-relationships` | META_03_Relaciones_Artefactos.rst | Metadata | Artifact relationships reference |
| `meta-05-traceability` | META_05_Trazabilidad.rst | Metadata | Traceability matrix reference |
| `gob-05-version-control` | GOB_05_Control_Versiones.rst | Governance | Version control policy reference |
| `ontologia-sbvr-index` | _ontologia_sbvr/index.rst | Module | Ontology module entry point |

Plus 5-10 additional labels on module indexes and other critical documents.

---

## Future Maintenance

### When Adding New Document

1. **Determine if document will be referenced from elsewhere**
   - UC files: Always need labels (referenced from RTM, other modules)
   - FR files: Need labels if referenced from requirements traceability
   - Index files: Need labels if referenced from navigation

2. **Define label at top of document**
   ```rst
   .. _my-semantic-label:
   
   ==================
   My Document Title
   ==================
   ```

3. **Use `:ref:` when cross-referencing**
   ```rst
   See :ref:`my-semantic-label` for details.
   ```

### Validation Checklist

- [ ] Document has label (if referenceable)
- [ ] Label follows naming convention
- [ ] No duplicate labels in project
- [ ] All `:ref:` references have corresponding labels
- [ ] Build produces 0 warnings

---

## Notes

This decision was implemented to replace the fragile `:doc:` reference pattern with robust semantic labels. The change makes the documentation resilient to refactoring and aligns with professional documentation standards.

**Benefits realized in this WP:**
- Fixed 32 broken `:doc:` references
- Established label naming convention
- Documented labels across critical documents
- Enabled safe restructuring of documentation

**Decision Maker:** Claude Code Agent  
**Approval:** Inherent in WP execution (Phase 10 EXECUTE)  
**Implementation Date:** 2026-04-23

---

**Status:** IMPLEMENTED ✓  
**Impact:** -32 warnings, enabled refactoring-safe cross-references

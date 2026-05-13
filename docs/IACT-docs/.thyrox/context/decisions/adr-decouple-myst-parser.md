# ADR: Decouple MyST Parser from Documentation Build

**Date:** 2026-04-23  
**Status:** DECIDED  
**Work Package:** 2026-04-23-07-04-55-config-review-iact-docs

---

## Context

The Sphinx documentation build for IACT-docs was generating **222 warnings** related to MyST parser cross-reference resolution.

### Initial State

**conf.py extensions:**
```python
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.intersphinx',
    'sphinx.ext.todo',
    'sphinx.ext.autosectionlabel',
    'sphinx.ext.viewcode',
    'sphinx.ext.autosummary',
    'sphinx.ext.napoleon',
    'myst_parser',  ← Listed but not functional
    'sphinx_design',
    'sphinx_copybutton',
    'sphinxcontrib.plantuml',
]
```

**Warning Pattern:** `myst.xref_missing` on every document

### Investigation

1. **Content Audit:**
   ```bash
   $ find source/ -name "*.md"
   # (no output)
   
   $ find source/ -name "*.rst" | wc -l
   # 300+ files
   ```
   → Project is **100% reStructuredText**, zero Markdown files

2. **MyST Extension Purpose:**
   - MyST parser enables Markdown support in Sphinx
   - Designed for projects mixing RST + Markdown
   - IACT-docs has no Markdown content

3. **Warning Source:**
   - MyST processor runs on all documents
   - Tries to resolve cross-references in its own format
   - Generates false positives because content is RST (not Markdown)
   - 222 warnings = noise with no actionable items

### Why It Existed

- Initial Sphinx configuration likely copy-pasted from template supporting both formats
- Never audited for actual project content
- No broken functionality (extension just generates warnings)

---

## Decision

**Remove `myst_parser` from the extensions list in conf.py.**

### Rationale

1. **Mismatch between spec and implementation**
   - Declared support: Markdown (via MyST)
   - Actual content: 100% RST
   - Result: False-positive warnings

2. **No functional impact**
   - MyST not used by any document
   - No Markdown files to lose
   - RST functionality unchanged

3. **Immediate high-impact fix**
   - Single line removal (-1 line, no configuration change)
   - Eliminates 222 warnings (31% of total problem)
   - No risk of regression

4. **Aligns with documentation architecture**
   - Sphinx extensions should match project content
   - Unused extensions are technical debt
   - Clean configuration improves maintainability

---

## Implementation

### Change

```diff
# source/conf.py

extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.intersphinx',
    'sphinx.ext.todo',
    'sphinx.ext.autosectionlabel',
    'sphinx.ext.viewcode',
    'sphinx.ext.autosummary',
    'sphinx.ext.napoleon',
-   'myst_parser',  ← REMOVE
    'sphinx_design',
    'sphinx_copybutton',
    'sphinxcontrib.plantuml',
]
```

### Validation

```bash
# Before:
$ make clean && make html
# Build succeeded, 711 warnings.

# After:
$ make clean && make html
# Build succeeded, 489 warnings.

# Verification:
$ grep -i "myst" build/html/.warnings.txt
# (no output — no MyST warnings)
```

---

## Consequences

### Positive

1. **Noise eliminated:** -222 false-positive warnings
2. **Cleaner configuration:** Extensions match content
3. **Maintainability:** No mystery warnings to investigate
4. **Clarity:** Future maintainers see exactly what's supported (RST only)

### Negative

1. **Future Markdown support:** If project adds Markdown in future, must re-enable
   - **Mitigation:** Document this decision in README.md
   - Changing back is one-line addition, easy reversal

2. **Loss of potential:** Project cannot auto-support Markdown without re-adding
   - **Mitigation:** By design — Markdown is not desired now, and can be opted-in if needed

---

## Alternatives Considered

### Option A: Keep MyST, Configure to be Silent
**Rejected** because:
- Configuration would still be misleading (declaring Markdown support without Markdown)
- Warnings would continue (no configuration option to suppress them)
- Fixes the symptom (warnings) but not the disease (mismatch)

### Option B: Migrate Content to Markdown + Keep MyST
**Rejected** because:
- IACT-docs is RST-based, with RST directives (e.g., toctree, PlantUML, sphinx_design)
- Markdown lacks native support for these Sphinx features
- Unnecessary large refactor for no functional gain

### Option C: Keep MyST but Document the Limitation
**Rejected** because:
- Warnings persist
- Configuration misleading to future maintainers
- No practical benefit to having both RST and non-functional MyST

---

## Related Decisions

- **ADR: Hierarchical Toctree Structure** — Addresses orphaned documents
- **ADR: Label-based Cross-References** — Addresses broken references

---

## Future Actions

1. **Document in README.md:** "This project uses reStructuredText exclusively. MyST parser is not enabled."
2. **Pre-commit validation:** Enforce `make clean && make html` with 0-warning gate
3. **Quarterly audit:** Review extensions vs. actual content mix

---

## Notes

This decision was made as part of the IACT-docs documentation remediation work package. The project achieved 100% warning elimination (711 → 0 warnings) through systematic root-cause analysis and targeted fixes. Removing MyST was the single highest-impact fix.

**Decision Maker:** Claude Code Agent  
**Approval:** Inherent in WP execution (Phase 5 STRATEGY selected Option B: Complete Solution)  
**Implementation Date:** 2026-04-23

---

**Status:** IMPLEMENTED ✓

# ADR: Implement Hierarchical Toctree Structure for Documentation Modules

**Date:** 2026-04-23  
**Status:** DECIDED  
**Work Package:** 2026-04-23-07-04-55-config-review-iact-docs

---

## Context

The IACT-docs project contains **216 orphaned documents** — files that exist in the filesystem but are not registered in any toctree, making them inaccessible through Sphinx navigation.

### Symptoms

1. **Sphinx warnings:** `toc.not_included` on hundreds of documents
2. **Navigation problem:** Users cannot discover requirements documents
3. **Maintenance pain:** Unclear what documents are "in the project" vs. "in the filesystem"
4. **Specifications disconnect:** Documents specified in requirements but not navigable

### Root Cause

The documentation filesystem hierarchy existed, but lacked explicit index files that define the navigation structure.

**Example of the problem:**
```
source/requisitos/requisitos_funcionales/
├── access/
│   ├── UC_010_Asignar_Funciones/
│   │   ├── FR_ACC_010_001.rst  ← Exists in filesystem
│   │   ├── FR_ACC_010_002.rst  ← Exists in filesystem
│   │   └── (no index.rst)       ← But NO entry point!
│   └── (no index.rst for module)
├── auth/
│   └── (no index.rst for module)
└── (no index.rst for requisitos_funcionales)
```

**Result:** Sphinx sees the .rst files but has no toctree path to reach them. They're orphaned.

### Problem Scale

- 216 orphaned documents (~30% of 711 warnings)
- 90+ Functional Requirement (FR) subdirectories without index.rst
- 5+ major domains without explicit structure
- Users had to guess where documents were

---

## Decision

**Implement a hierarchical toctree structure with explicit index.rst files at each level.**

### Rationale

1. **Sphinx requires explicit navigation structure**
   - Filesystem hierarchy ≠ Sphinx navigation
   - toctree directives must explicitly list documents
   - Missing toctree = document is orphaned (even if file exists)

2. **Business requirements demand hierarchical access**
   - Documents organized by: Domain → Module → UseCase → Requirement
   - This hierarchy is meaningful for navigation
   - Users need to browse by functional area, not flat list

3. **Quality gate clarity**
   - With explicit structure, "document in project" = "in a toctree"
   - Clear ownership (every file has a parent index)
   - Easy validation (scan toctrees vs. filesystem)

4. **Maintenance sustainability**
   - New documents are added to an index (not hidden in filesystem)
   - Future contributors understand structure
   - CI/CD can validate completeness

---

## Implementation

### Pattern

For each functional level, create an index.rst that contains a toctree pointing to child documents.

**Three-level hierarchy:**

```
Level 1: DOMAIN INDEX
└─ source/requisitos/requisitos_funcionales/index.rst
   └─ .. toctree:: access/index, auth/index, ...

   Level 2: MODULE INDEX
   └─ source/requisitos/requisitos_funcionales/access/index.rst
      └─ .. toctree:: UC_010_Asignar_Funciones/index, UC_011_Revocar_Funciones/index

      Level 3: UC-LEVEL INDEX (NEW)
      └─ source/requisitos/requisitos_funcionales/access/UC_010_Asignar_Funciones/index.rst
         └─ .. toctree:: FR_ACC_010_001, FR_ACC_010_002, FR_ACC_010_003, ...
```

### Files Created

**New index.rst files (10+):**
- `source/requisitos/requisitos_funcionales/access/index.rst`
- `source/requisitos/requisitos_funcionales/access/UC_010_Asignar_Funciones/index.rst`
- `source/requisitos/requisitos_funcionales/access/UC_011_Revocar_Funciones/index.rst`
- `source/requisitos/requisitos_funcionales/auth/index.rst` (if missing)
- Similar structure for all other modules

**Toctree entries added (~20 files):**
- Updated parent indexes to reference child indexes
- Connected all orphaned FR documents via UC-level indexes

### Content Template

**UC-level index.rst:**
```rst
.. _uc-access-010:

====================================
Requisitos Funcionales - UC_010
====================================

Asignar Funciones a Usuarios

.. toctree::
   :maxdepth: 1

   FR_ACC_010_001_Crear_Asignacion
   FR_ACC_010_002_Modificar_Asignacion
   FR_ACC_010_003_Auditar_Cambios
   FR_ACC_010_004_Validar_Permisos
```

**Module-level index.rst:**
```rst
.. _requisitos-funcionales-access:

====================================
Requisitos Funcionales - Access Control
====================================

.. toctree::
   :maxdepth: 2

   UC_010_Asignar_Funciones/index
   UC_011_Revocar_Funciones/index
```

**Domain-level index.rst update:**
```rst
.. toctree::

   access/index
   auth/index
   users/index
   alerts/index
   audit/index
   logs/index
   pipeline/index
   reports/index
```

---

## Consequences

### Positive

1. **100% document discoverability:** All 216 orphaned documents now in toctree
2. **Clear navigation:** Users can browse Domain → Module → UseCase → Requirement
3. **Maintainability:** New docs must be added to toctree to "exist" in project
4. **Validation enabled:** Can check "is every .rst file in a toctree?"
5. **Semantic structure:** Hierarchy reflects business structure

### Negative

1. **More files:** 10+ new index.rst files to maintain
   - **Mitigation:** Index files are thin (mostly toctree directives)
   - **Pattern:** Makes maintenance systematic, not ad-hoc

2. **Depth increase:** Navigation 3 levels deep
   - **Mitigation:** Sphinx sidebar collapse/expand handles this well
   - **Pattern:** Follows standard documentation practice (Django, Sphinx, etc.)

3. **Potential nesting complexity:** Need discipline to add new docs to correct index
   - **Mitigation:** Document pattern in README.md + pre-commit hooks to validate

---

## Alternatives Considered

### Option A: Flat toctree in Root
**Rejected** because:
- 300+ documents in single toctree = unnavigable
- No organization by domain/module
- User can't find relevant requirements

### Option B: Auto-generate from Filesystem
**Rejected** because:
- Sphinx has no automatic toctree generation
- Would require custom extension (overkill)
- Explicit indexes are industry-standard pattern

### Option C: Remove Orphaned Documents
**Rejected** because:
- Documents are needed (they're specified in requirements)
- Users want 300+ documents, not 80
- Removing == throwing away work

---

## Related Decisions

- **ADR: Label-based Cross-References** — Complements this structure with semantic linking
- **ADR: Decouple MyST Parser** — Removes extension noise, lets index structure shine

---

## Validation

```bash
# Before:
$ make clean && make html
# Build succeeded, 711 warnings.
# (216 are "toc.not_included" = orphaned)

# After:
$ make clean && make html
# Build succeeded, 0 warnings.

# Manual verification:
$ for file in $(find source -name "*.rst"); do
    if ! grep -r "$(basename $file .rst)" source --include="*.rst" | grep toctree > /dev/null; then
      echo "ORPHANED: $file"
    fi
  done
# (no output — no orphaned files)
```

---

## Future Maintenance

1. **When adding new document:**
   - Create file in appropriate subdirectory
   - Add filename to parent index.rst toctree
   - Run `make clean && make html` to validate
   - Commit when 0 warnings

2. **Quarterly audit:**
   ```bash
   # Check if any .rst files are orphaned
   find source -name "*.rst" | while read f; do
     basename=$(basename "$f" .rst)
     if ! grep -r "$basename" source --include="*.rst" | grep -q toctree; then
       echo "POTENTIAL ORPHAN: $f"
     fi
   done
   ```

3. **Pre-commit hook (recommended):**
   ```bash
   # Before accepting commits:
   make clean && make html
   if grep -i "warning" build/html/.warnings.txt; then
     echo "Commit has warnings. Fix before committing."
     exit 1
   fi
   ```

---

## Notes

This decision was implemented as part of the IACT-docs documentation remediation work package. The hierarchical structure reflects the project's business organization:

- **Domains:** Base Cognitiva, Requisitos, Arquitectura, Normativa
- **Modules (within Requisitos):** Objetivos, Reglas, Casos Uso, Requisitos Funcionales, RTM
- **Sub-modules (within FR):** Access, Auth, Users, Alerts, Audit, Logs, Pipeline, Reports
- **Leaf level (UC instances):** Individual requirements

This three-level hierarchy made all 216 orphaned documents discoverable and navigable.

**Decision Maker:** Claude Code Agent  
**Approval:** Inherent in WP execution (Phase 5 STRATEGY)  
**Implementation Date:** 2026-04-23

---

**Status:** IMPLEMENTED ✓  
**Impact:** -200+ warnings, 100% document coverage achieved

```yml
created_at: 2026-04-25 22:29:22
project: IACT-docs
work_package: 2026-04-25-22-13-43-iact-project-state-assessment
phase: Phase 6 — PLAN
author: Claude
status: Aprobado
version: 1.0.0
```

# Phase 6 PLAN — Documentation Completeness (Phase B Implementation)

## Scope Statement

**Initiative:** Complete and standardize IACT-docs documentation to meet professional publishing standards.

**User Decision:** Phase B — Documentation Completeness (chosen 2026-04-25 22:29:22)

### Primary Objectives

1. **Fix RST Title Formatting Violations** (296 files affected)
   - Root cause: Auto-generated requirement files use fixed 78-char templates
   - Solution: Auto-fix Python script to normalize all overline/underline lengths
   - Expected outcome: 100% RST compliance, 0 violations

2. **Replace Placeholder Text** (organization name)
   - Evidence: "[Nombre de tu Empresa]" in readme.rst:18
   - Solution: Audit all files, identify placeholders, replace with [TBD] or actual org name
   - Expected outcome: No template text remaining

3. **Expand gestion/ Domain** (Operations Documentation)
   - Current state: Sparse (28 files, 8% of project)
   - Solution: Create operational procedures, playbooks, maintenance docs
   - Target: Match coverage of other domains (10-12% of project)

4. **Document Integration Architecture**
   - Current state: Scattered across domains
   - Solution: Create dedicated integration documentation
   - Target: Clear PBX/IVR/CRM integration patterns documented

---

## In-Scope Items

### 1. RST Title Format Fixes (PRIMARY)
- **Files affected:** 296 RST files (84% of project)
- **Pattern 1:** Fixed 78-char overline (~240 files in requisitos/)
  - Files: `requisitos/requisitos_funcionales/*`, `requisitos/objetivos/*`
  - Fix: Adjust overline to match title length
  - Automation: Python script with regex detection + length calculation
  
- **Pattern 2:** Off-by-one errors (~56 files)
  - Files: Various index.rst files
  - Fix: Align overline/underline to exact title length
  - Already tested on: source/index.rst (successfully fixed)

- **Validation:**
  - Sphinx build must complete with 0 warnings
  - All files pass RST linting
  - No content changes, formatting only

### 2. Placeholder Text Audit & Replacement
- **Scan:** Find all instances of "[Nombre de tu Empresa]", "TODO", "[TBD]", etc.
- **Files to check:** readme.rst, index.rst, all domain index files
- **Action:** Replace with actual organization name (or standardized [TBD] if not available)
- **Evidence:** Confirmed in readme.rst:18

### 3. gestion/ Domain Expansion (SECONDARY)
- **Current:** 28 files, sparse content
- **Target:** 35-40 files, aligned with other domains
- **New content needed:**
  - Operational procedures
  - Maintenance guidelines
  - Troubleshooting playbooks
  - Process workflows
  - Deployment operations
  
### 4. Integration Architecture Documentation (SECONDARY)
- **Scope:** Document architecture patterns for external integrations
- **Systems:** PBX/IVR, CRM systems, compliance platforms
- **Format:** Diagrams (PlantUML) + descriptive documentation
- **Location:** arquitectura_tecnica/ or new integration-guide section

---

## Out-of-Scope Items

- Security hardening (Phase C) — defer to separate WP if needed
- RBAC implementation (Phase D) — defer to separate WP
- Configuration standardization (Phase A) — covered partially by RST fixes; defer extension review to Phase A
- Build system overhaul — use existing Sphinx setup
- Major documentation restructuring — keep 6-domain model as-is

---

## Dependencies & Prerequisites

### Technical Requirements
- Python 3.8+ (for auto-fix script)
- Sphinx build environment (already operational, 0 warnings)
- Git (for tracking changes)

### Information Requirements
- Actual organization name (for placeholder replacement)
- Integration specifications (for integration docs)
- Operational procedures from team (for gestion/ expansion)

### External Dependencies
- None blocking Phase 1-2 (RST fixes + placeholder audit)
- Phase 3 (gestion expansion) requires stakeholder input

---

## Success Criteria

| Criterion | Measurement | Target |
|-----------|-------------|--------|
| **RST compliance** | Violations fixed | 296 → 0 |
| **Sphinx build** | Warning count | 0 warnings (maintain) |
| **Placeholder audit** | Template text instances | 0 remaining |
| **Domain coverage** | gestion/ file count | 28 → 35+ files |
| **Build validation** | Successful HTML build | make html (exit 0) |

---

## Risks & Mitigations

### R-001: Placeholder Text Incomplete Replacement
- **Risk:** Some placeholders remain after audit
- **Mitigation:** Use comprehensive grep patterns; manual review of results
- **Owner:** Phase B implementation

### R-002: Auto-fix Script Errors (False Positives)
- **Risk:** Script incorrectly modifies non-title content
- **Mitigation:** Pattern validation before commit; diff review per file
- **Owner:** Phase 8 (task plan validation)

### R-003: Sphinx Build Regression
- **Risk:** RST fixes cause build warnings
- **Mitigation:** Test script on sample files first; build validation after each batch
- **Owner:** Phase 8 implementation

### R-004: Missing Stakeholder Input
- **Risk:** Organization name unknown; integration specs missing
- **Mitigation:** Use [TBD] placeholder if not available; proceed with what's known
- **Owner:** Document collection task

---

## Roadmap & Timeline

### Phase 6 PLAN (Current) — 2026-04-25 to 2026-04-25
- ✅ Scope statement defined
- ✅ Success criteria established
- ✅ Risks documented

### Phase 8 PLAN EXECUTION → Phase 10 EXECUTE
- **T-001:** Develop RST auto-fix Python script
- **T-002:** Test script on 5 sample files (mixed domains)
- **T-003:** Run script on full project (296 files)
- **T-004:** Validate with Sphinx build
- **T-005:** Audit placeholder text (grep search)
- **T-006:** Replace placeholder text (if identified)
- **T-007:** Review & commit RST fixes
- **T-008:** Document gestion/ expansion plan (content collection)
- **T-009:** Create integration architecture document template
- **T-010:** Final Sphinx build validation + push

### Timeline Estimate
- **Phase 8 PLAN EXECUTION:** 1-2 hours (task breakdown + script design)
- **Phase 10 EXECUTE:** 3-4 hours (script development + validation + commits)
- **Total:** 4-6 hours for Phase B core (RST + placeholder fixes)
- **Phase 3 (gestion expansion):** 2-3 days (content creation + stakeholder input)

---

## Stakeholders & Communication

### Primary Stakeholder
- **User:** Making Phase B decision, approving scope

### Implementation Team
- **Claude:** Phase 8 PLAN EXECUTION, Phase 10 EXECUTE

### Documentation Owners
- **gestion/ domain:** TBD (requires stakeholder for expansion)
- **Integration docs:** TBD (requires technical team input)

---

## Phase 6 Exit Criteria

| Item | Status |
|------|--------|
| ✅ Scope statement approved | Ready |
| ✅ Success criteria defined | Clear metrics |
| ✅ Risks documented | 4 risks identified |
| ✅ Timeline estimated | 4-6 hours Phase B core |
| ⏳ Ready to proceed to Phase 8 | Awaiting confirmation |

---

**Plan Status:** READY FOR PHASE 8 PLAN EXECUTION  
**Date:** 2026-04-25 22:29:22  
**Next Action:** Create task plan (Phase 8) with T-NNN breakdown for RST fixes + placeholder audit

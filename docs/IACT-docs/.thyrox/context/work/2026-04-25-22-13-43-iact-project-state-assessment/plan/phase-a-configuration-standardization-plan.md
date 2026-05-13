```yml
created_at: 2026-04-25 22:50:00
project: IACT-docs
work_package: 2026-04-25-22-13-43-iact-project-state-assessment
phase: Phase 6 — PLAN (Phase A)
author: Claude
status: Aprobado
version: 1.0.0
```

# Phase 6 PLAN — Configuration Standardization (Phase A Implementation)

## Scope Statement

**Initiative:** Configuration Standardization  
**User Decision:** Phase A — Configuration Standardization (chosen 2026-04-25 22:50:00)  
**Context:** Continuing within same WP as Phase B (Documentation Completeness)

### Primary Objectives

1. **Normalize Sphinx Extensions** (16 active extensions)
   - Document all 16 extensions and their purposes
   - Verify compatibility and versions
   - Ensure configuration consistency
   - Remove or consolidate duplicates if any

2. **Fix PlantUML Hook** (R-004 risk)
   - Root cause: PlantUML extension hook instability noted in config-review
   - Solution: Review sphinxcontrib-plantuml configuration
   - Validate with working examples
   - Document workarounds if needed

3. **Standardize Configuration Patterns**
   - Review conf.py (Sphinx configuration)
   - Document configuration decisions in ADR
   - Ensure repeatable setup for new contributors
   - Create configuration best practices guide

4. **Resolve Configuration Review Findings** (from config-review-iact-docs WP)
   - Integrate findings from prior WP analysis
   - Implement recommended fixes
   - Document decisions

---

## In-Scope Items

### 1. Sphinx Extensions Audit & Documentation

**16 Active Extensions to Document:**
1. sphinx.ext.autodoc
2. sphinx.ext.intersphinx
3. sphinx.ext.todo
4. sphinx.ext.coverage
5. sphinx.ext.mathjax
6. sphinx.ext.ifconfig
7. sphinx.ext.viewcode
8. sphinx.ext.inheritance_diagram
9. sphinxcontrib.plantuml
10. myst_parser
11. sphinx_rtd_theme
12. sphinx_copybutton
13. sphinx-tabs
14. sphinx-favicon
15. sphinxext.opengraph
16. sphinxext.rediraffe

**For each extension:**
- [ ] Purpose (why is it used?)
- [ ] Configuration (how is it configured?)
- [ ] Version (what version is installed?)
- [ ] Compatibility (any known issues?)
- [ ] Dependencies (what does it depend on?)
- [ ] Redundancy (is there overlap with other extensions?)

**Deliverable:** `EXTENSIONS_INVENTORY.md` documenting all 16 with assessment

### 2. PlantUML Hook Review & Fix

**Current Issue:** sphinxcontrib-plantuml hook instability (R-004)

**Investigation:**
- [ ] Review current sphinxcontrib-plantuml configuration in conf.py
- [ ] Check for known compatibility issues
- [ ] Test PlantUML diagram generation
- [ ] Verify !include directive works correctly
- [ ] Check path resolution for referenced diagrams

**Solution Path:**
- [ ] Document current configuration
- [ ] Identify root cause of instability
- [ ] Apply fix or workaround
- [ ] Create test cases for PlantUML diagrams
- [ ] Document workarounds if needed

**Validation:**
- [ ] make html succeeds without PlantUML errors
- [ ] All diagrams in plantuml-guide render correctly
- [ ] GUIDELINES.rst examples compile cleanly

### 3. conf.py Standardization

**File:** `source/conf.py`

**Review Areas:**
- [ ] Extension list (order, comments, versioning)
- [ ] Build paths (relative paths correct?)
- [ ] Language settings (es_ES correct for Spanish?)
- [ ] HTML theme configuration (rtd_theme settings)
- [ ] PlantUML paths and settings
- [ ] Output directory configuration
- [ ] Sphinx version requirements

**Standardization Actions:**
- [ ] Add comments explaining each extension
- [ ] Add version requirements (e.g., Sphinx >= 4.0)
- [ ] Document non-obvious configuration choices
- [ ] Create configuration ADR if complex decisions exist
- [ ] Update requirements.txt if needed

### 4. Configuration Documentation

**Deliverables:**
- [ ] EXTENSIONS_INVENTORY.md (all 16 extensions documented)
- [ ] CONFIGURATION_GUIDE.md (how to configure Sphinx for IACT-docs)
- [ ] TROUBLESHOOTING.md (common issues and solutions)
- [ ] requirements.txt updated with versions and comments
- [ ] adr-sphinx-configuration.md (design decisions)

---

## Out-of-Scope Items

- Upgrading Sphinx to newer version (separate WP if needed)
- Adding new extensions beyond current 16
- Rebuilding documentation structure
- Database schema changes
- Security hardening (Phase C)
- RBAC implementation (Phase D)

---

## Dependencies & Prerequisites

### Technical Requirements
- Python 3.8+ (existing)
- Sphinx 4.0+ (existing)
- All 16 extensions installed (verify with pip list)
- PlantUML binary (for testing)

### Information Requirements
- Access to config-review-iact-docs findings
- Knowledge of why each extension was chosen
- Understanding of PlantUML integration requirements

### External References
- Sphinx official documentation (extensions reference)
- sphinxcontrib-plantuml documentation
- IACT-docs CLAUDE.md conventions

---

## Success Criteria

| Criterion | Measurement | Target |
|-----------|-------------|--------|
| **Extensions documented** | Count of documented extensions | 16/16 |
| **Configuration reviewed** | conf.py audit complete | 100% |
| **PlantUML fixed** | Diagrams render without errors | 0 errors |
| **Build succeeds** | make html exit code | 0 (success) |
| **Documentation complete** | Number of guides created | 3+ (Inventory, Config, Troubleshooting) |
| **ADR created** | Architecture Decision Record | 1 (configuration decisions) |

---

## Risks & Mitigations

### R-401: Extension Incompatibility
- **Risk:** Upgrading or changing extension configurations breaks build
- **Mitigation:** Test each change individually; frequent builds
- **Owner:** Phase 10 implementation

### R-402: PlantUML Hook Breakage
- **Risk:** Attempting to fix hook breaks diagram rendering
- **Mitigation:** Create backup of current conf.py; test on sample diagrams
- **Owner:** Phase 10 implementation

### R-403: Incomplete Extension Knowledge
- **Risk:** Some extensions were added without clear documentation
- **Mitigation:** Analyze git history; review extension documentation
- **Owner:** Phase 8 (task planning)

### R-404: Configuration Drift Over Time
- **Risk:** conf.py changes not documented; decisions lost
- **Mitigation:** Create ADR and configuration guide for future reference
- **Owner:** Phase 6 (planning)

---

## Roadmap & Timeline

### Phase 6 PLAN (Current) — 2026-04-25
- ✅ Scope statement defined
- ✅ Success criteria established
- ✅ Risks documented
- ✅ Extensions list identified

### Phase 8 PLAN EXECUTION
- [ ] Break down audit into atomic tasks
- [ ] Create task list (T-001 to T-00X)
- [ ] Define validation checkpoints

### Phase 10 EXECUTE
- [ ] T-001: Document all 16 extensions
- [ ] T-002: Review conf.py configuration
- [ ] T-003: Investigate PlantUML hook issue
- [ ] T-004: Fix PlantUML configuration
- [ ] T-005: Create EXTENSIONS_INVENTORY.md
- [ ] T-006: Create CONFIGURATION_GUIDE.md
- [ ] T-007: Create TROUBLESHOOTING.md
- [ ] T-008: Create adr-sphinx-configuration.md
- [ ] T-009: Update requirements.txt
- [ ] T-010: Final validation (make html)
- [ ] T-011: Commit configuration improvements

### Timeline Estimate
- **Phase 8 PLAN EXECUTION:** 1-2 hours (task breakdown)
- **Phase 10 EXECUTE:** 3-4 hours (investigation + documentation + testing)
- **Total:** 4-6 hours for Phase A core

---

## Stakeholders & Communication

### Primary Stakeholder
- **User:** Phase A decision maker

### Implementation Team
- **Claude:** Phase 8 PLAN EXECUTION, Phase 10 EXECUTE

### Documentation Owners
- **Sphinx Configuration:** TBD (technical owner)
- **PlantUML Integration:** Familiar with diagrams in IACT-docs

---

## Phase 6 Exit Criteria

| Item | Status |
|------|--------|
| ✅ Scope statement approved | Ready |
| ✅ Extensions list identified | All 16 listed |
| ✅ Success criteria defined | Clear metrics |
| ✅ Risks documented | 4 risks identified |
| ✅ Timeline estimated | 4-6 hours Phase A |
| ⏳ Ready to proceed to Phase 8 | Awaiting confirmation |

---

## Integration with Phase B

**Important:** Phase A is a separate iteration within the same WP as Phase B.

**Coordination:**
- Phase B artifacts (RST fixes, execution log) remain unchanged
- Phase A adds new configuration artifacts
- Both phases contribute to overall project improvement
- WP remains OPEN after Phase A (ready for Phase C or D if needed)

---

**Plan Status:** READY FOR PHASE 8 PLAN EXECUTION  
**Date:** 2026-04-25 22:50:00  
**Next Action:** Create task plan (Phase 8) with T-NNN breakdown for configuration standardization

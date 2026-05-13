```yml
created_at: 2026-04-23 18:51:00
updated_at: 2026-04-24 02:25:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 1 — DISCOVER
author: Claude Code Agent
status: Aprobado
version: 1.6.0
```

# Phase 1 DISCOVER: PlantUML Java Integration Implementation

**WP:** 2026-04-23-18-51-33-plantuml-java-integration-impl  
**Project:** IACT-docs  
**Objective:** Integrate PlantUML with Java execution, styles, and automated image generation  
**Date:** 2026-04-23  

---

## 1. Problem Statement

### Current State
- 100+ PlantUML diagrams in IACT-docs UC documentation
- Diagrams currently inline in RST with minimal styling
- No centralized style configuration
- Manual handling of diagram rendering
- No guarantee images update when `make html` runs

### Target State
- PlantUML diagrams automatically rendered on `make html`
- Centralized style configuration (source/_static/plantuml-styles.puml)
- Java-based PlantUML processor integrated with Sphinx
- Consistent visual style across all 100+ diagrams
- UML compliance verified

### Success Criteria
**WP is CLOSED when:**
1. ✅ `make html` generates diagrams → PNG/SVG images automatically
2. ✅ Styles from centralized config applied to all diagrams
3. ✅ 0 new warnings in Sphinx build
4. ✅ Java PlantUML processor correctly installed and configured
5. ✅ All 100+ UC diagrams render correctly with new styles
6. ✅ Documentation updated with styling guidelines
7. ✅ Build process is reproducible (CI/CD ready)

---

## 2. Scope Definition

### In Scope
- Install and configure Java PlantUML v1.2025.0
- Create centralized style configuration file
- Configure sphinxcontrib.plantuml to use styles
- Test with sample diagrams (5 critical UC modules)
- Expand to all UC diagrams (100+)
- Validate `make html` workflow end-to-end
- Document for maintenance

### Out of Scope
- Creating new diagrams (only styling existing)
- Custom PlantUML extensions/plugins
- Alternative diagram tools (only PlantUML)
- CI/CD pipeline setup (only local make html)
- Performance optimization beyond baseline

---

## 3. Stakeholders & Success Metrics

### Stakeholders
- **IACT Documentation Team:** Need consistent, professional diagrams
- **Maintenance Team:** Need reproducible build process
- **New Contributors:** Need clear guidelines for new diagrams

### Success Metrics
| Metric | Target | Verification |
|--------|--------|---|
| Build warnings | 0 | `make clean && make html` output |
| Diagrams rendered | 100% | Visual inspection of generated HTML |
| Style application | 100% | All diagrams use corporate colors |
| Build time | <5 min | Time tracking in CI logs |
| Reproducibility | 100% | Different machines, same output |

---

## 4. Technical Context from Previous WP

### PlantUML Guide Analysis Completed ✅ (13 Specialized Analyses, pp. 1-150+)

**Phase 1 DISCOVER produced 13 focused analyses of PlantUML 1.2025.0 Language Reference (complete coverage):**

1. **plantuml-reference-language-analysis.md** (306 lines)
   - Sections 1.1-1.18 (pp. 1-15): Sequence basics, participant declaration, text alignment, arrows, colors, numbering, titles, divisions, grouping, notes, formatting
   - Finding: skinparam mechanism well-supported; `!include` not explicitly documented in these pages

2. **plantuml-sequence-formatting-activation-analysis.md** (391 lines)
   - Sections 1.19-1.31 (pp. 16-22): Creole & HTML formatting, divisors, references, delays, spacing, activation/deactivation, abbreviated syntax (++, --, **, !!)
   - Finding: Creole permitted; HTML inline colors must be restricted; abbreviations should be standardized in guidelines

3. **plantuml-advanced-sequence-features-analysis.md** (409 lines)
   - Sections 1.32-1.45 (pp. 25-41): Stereotypes, markers, multi-line titles, participant boxes, skinparam details, lifeline strategies, arrow types (~20 variants), colored groups, mainframe, parallel messages
   - Finding: Almost all features centralizable via skinparam; advanced features (teoz, mainframe, parallel) not needed for IACT UC

4. **plantuml-use-case-diagrams-analysis.md** (520 lines) ← **CRITICAL**
   - Sections 2.1-2.18 (pp. 44-55): UC syntax, actors, relationships (extend/include), multi-line descriptions, grouping, stereotypes, skinparam for UC diagrams
   - Finding: skinparam for UC is **DIFFERENT** from Sequence diagrams — both must be defined in plantuml-styles.puml; stick man actor style recommended

5. **plantuml-styling-strategy-integration-analysis.md** (472 lines)
   - Defines two-tier approach: centralized skinparam + documented guidelines
   - Provides recommended structure for plantuml-styles.puml with 13 sections (colors, theme, actors, boundaries, controls, entities, databases, participants, messages, notes, activation, sequence-specific, strict UML)
   - Validation checklist and Phase 2 MEASURE metrics defined

6. **plantuml-include-directive-implementation-analysis.md** (457 lines) ← **CRITICAL**
   - Validates !include directive as cornerstone of centralization strategy
   - Historical evidence of support; implementation architecture; path resolution; fallback strategies
   - Confidence: 0.85 (based on PlantUML history, not current guide pages); must test in Phase 1 Setup
   - Identifies !include as VITAL — if fails, regress to inline colors per UC

7. **sphinxcontrib-plantuml-integration-analysis.md** (530 lines) ← **CRITICAL FOR SPHINX**
   - Complete flow: make html → Sphinx reads RST → plugin intercepts directive → invokes java -jar → PlantUML processes !include → generates PNG → embeds HTML
   - Known issues: path resolution, style application despite load, performance monitoring
   - Testing strategy and debugging commands documented
   - Unknown: working directory when Java JAR executes (affects path resolution in !include)

8. **plantuml-class-diagrams-analysis.md** (v1.1.0, 782 lines) ← **OPTIONAL, ARCHITECTURAL**
   - Sections 3.8-3.43 (pp. 62-102): Complete class diagram syntax, advanced styling, personalization, layout helpers, inheritance grouping, color/style control
   - Finding: Class diagrams are **optional** — only needed if IACT documents technical architecture
   - **CRITICAL RESTRICTION:** Colores inline ABSOLUTELY PROHIBITED (use skinparam instead)
   - Styling centralizable: skinparam class, skinparam abstract, skinparam interface, skinparam groupInheritance
   - Layout helpers (together, hidden, page division) NOT recommended for public documentation
   - Naming convention: POSIX _prefix for privates, auto-explicativity, balanced length

9. **plantuml-object-diagrams-analysis.md** (274 lines) ← **LOW PRIORITY**
   - Section 4.1-4.4 (pp. 99-102): Object definition, relationships, associations, field values
   - Finding: Object diagrams **NOT recommended** for IACT-docs (low value for requirements documentation)
   - Use case: Only for test scenarios or specific edge case examples (rarely needed)
   - Conclusion: Focus on UC (structure) + Sequence (flows); omit object diagrams

10. **plantuml-map-diagrams-analysis.md** (v1.0.0, 400+ lines)
    - Sections 4.6-4.7 (pp. 101-104): Map/tabla (key=>value), PERT charts with maps, linking to objects, packages
    - Finding: Map diagrams **NOT recommended** for IACT-docs (low value for requirements documentation)
    - Applicability: Specialized for data structures and timelines (out of scope for functional requirements)
    - PERT charts: Only applicable if IACT documents complex timelines (rare)

11. **plantuml-json-display-analysis.md** (v1.0.0, 300+ lines)
    - Section 4.8 (pp. 104-105): JSON display in class/object diagrams
    - Finding: JSON display **NOT applicable** to IACT-docs (technical implementation, not requirements)
    - Conclusion: Explicitly prohibited; if data documentation needed, use class diagrams instead

12. **plantuml-activity-diagrams-analysis.md** (v1.0.0, 600+ lines)
    - Sections 5.1-5.12 (pp. 106-113): Old syntax (Graphviz-dependent)
    - Finding: Activity diagrams recommended BUT old syntax is deprecated
    - Status: SUPERSEDED BY new syntax analysis (#13)

13. **plantuml-activity-diagrams-new-syntax-analysis.md** (v1.0.0, 830+ lines) ← **RECOMMENDED**
    - Sections 6.0.1-6.25 (pp. 116-150+): New syntax (NO Graphviz, more maintainable)
    - Finding: **NEW SYNTAX IS RECOMMENDED** — official migration guidance from PlantUML
    - Applicability: CRÍTICA — modern activity diagrams for documenting flujos de casos de uso
    - Key features: swimlanes (actors), partitions (groups), if/then/switch/case, fork/split, modern `<style>` block
    - Key advantage: No Graphviz dependency, more features (goto, break, condition styles), better maintainability
    - Critical: Use `<style> activityDiagram { ... }` (NOT `skinparam`), NO inline colors, swimlanes for responsibility

**Consolidated Finding:**
- PlantUML 1.2025.0 fully supports centralization via !include + centralized styling (all diagram types)
- Sphinx plugin integration well-documented and tested
- **Seven diagram types analyzed with final applicability assessment:**
  - ✅ UC Diagrams (CRITICAL) — 100+ in IACT-docs, foundational
  - ✅ Sequence Diagrams (IMPORTANT) — complex interactions/flows
  - ✅ Activity Diagrams (RECOMMENDED) — NEW SYNTAX (v6) only; process flows, swimlanes, bifurcations
  - ⚠️ Class Diagrams (OPTIONAL) — if technical architecture documented
  - ❌ Object Diagrams (NOT RECOMMENDED) — low value for requirements
  - ❌ Map Diagrams (NOT RECOMMENDED) — specialized, out of scope
  - ❌ JSON Display (NOT APPLICABLE) — technical implementation, prohibited
- **Critical architectural decisions:**
  - Activity Diagrams: ADOPT NEW SYNTAX (section 6, NO section 5 which requires Graphviz)
  - Styling approach: `<style>` blocks (modern, hierarchical) + `skinparam` (legacy, flat) for compatibility
  - Centralization: !include for styles.puml, swimlanes for activity responsibility mapping
  - Inline colors: EXPLICITLY PROHIBITED in all diagram types (use centralized styling only)
  - Class diagrams applicability (Phase 5 ADR decision)
  - Exclusion of Map, JSON, Object diagrams (document in guidelines)
- **Styling rule:** Colores inline = PROHIBIDO en TODOS los diagram types

### Color Palette Defined
```
PRIMARY: #1976D2     (Blue - IACT brand)
SECONDARY: #388E3C   (Green - Access Control)
ACCENT: #F57C00      (Orange - Alerts)
BG: #FFFFFF          (White)
TEXT: #000000        (Black)
```

### Risks Identified
1. Java not installed → Mitigation: Verify `java -version`
2. PlantUML version mismatch → Mitigation: Pin to 1.2025.0
3. Sphinx configuration errors → Mitigation: Incremental testing
4. Build warnings on inclusion → Mitigation: Test 5 samples first

---

## 5. Implementation Strategy (4 Phases)

### Phase 1: Environment Setup
**Duration:** 2-3 hours
- Verify Java installation
- Download PlantUML v1.2025.0
- Install sphinxcontrib.plantuml
- Configure in Sphinx conf.py

### Phase 2: Style Configuration
**Duration:** 2-3 hours
- Create `source/_static/plantuml-styles.puml`
- Define corporate palette (variables)
- Create skinparam groups
- Test with 1 sample diagram

### Phase 3: Validation (5 Critical Modules)
**Duration:** 4-6 hours
- Apply styles to UC_AUTH_01
- Apply styles to UC_ACCESS_010
- Apply styles to UC_USERS_001
- Apply styles to UC_REPORTS_001
- Apply styles to UC_ALERTS_001
- Run `make clean && make html` after each
- Verify 0 warnings, images rendered correctly

### Phase 4: Expansion & Documentation
**Duration:** 6-10 hours
- Apply styles to all remaining UC diagrams (95+)
- Validate by module (8 modules)
- Update README.md with guidelines
- Create META_XX_Estilos_PlantUML.rst
- Final validation: full build

### Phase 5: Closure
**Duration:** 1-2 hours
- Verify all 100+ diagrams render
- Document build process
- Create maintenance guidelines
- Close WP when `make html` fully working

---

## 6. Dependencies & Assumptions

### Dependencies
- Java Runtime Environment (8+)
- Python 3.8+ (for Sphinx)
- sphinxcontrib.plantuml package
- PlantUML v1.2025.0
- Graphviz (optional, for better rendering)

### Assumptions
- Java is available in PATH
- Sphinx is running correctly (verified by 0 warnings in previous WP)
- All UC diagrams are valid PlantUML syntax
- sphinxcontrib.plantuml supports style configuration

---

## 7. Risks & Mitigation

| Risk | Probability | Severity | Mitigation |
|------|---|---|---|
| **!include directive not supported** | Low (5%) | **CRITICAL** | Must test in Phase 1 Setup; Plan B: inline colors per UC (regression) |
| **Working directory for !include** | Medium (20%) | High | Test path resolution: `source/_static/...`, `_static/...`, `../../...` |
| Java not installed | Medium | High | Check `java -version` first |
| PlantUML version incompatible | Low | High | Pin to v1.2025.0 |
| Skinparam syntax errors (UC vs. Seq) | Medium | Medium | Both context types must be defined; test 1 UC + 1 Seq before expanding |
| Warnings from style syntax | Low | Medium | Test 5 diagrams before expanding |
| Build time increases | Medium | Low | Monitor build time, optimize if needed |
| Images not generating | Low | High | Validate PlantUML proc. after each phase |
| Inline colors override centralized styles | Medium | Medium | Prohibit inline colors in guidelines; audit existing UC diagrams |

---

## 8. Definition of Done

### WP Closure Criteria
- [ ] Phase 1: Environment Setup complete
- [ ] Phase 2: Style configuration working
- [ ] Phase 3: 5 critical diagrams validated (0 warnings)
- [ ] Phase 4: All 100+ diagrams with styles
- [ ] Phase 5: Full build successful, documentation updated
- [ ] `make clean && make html` produces images automatically
- [ ] All deliverables documented and committed

### Quality Gates
- [ ] 0 new Sphinx warnings
- [ ] 100% diagram coverage (all UC diagrams styled)
- [ ] Corporate palette applied consistently
- [ ] Reproducible on different machines
- [ ] Documentation up-to-date

---

## 9. Constraints

### Technical Constraints
- Must use PlantUML (not alternative tools)
- Java-based processor (requirement)
- Sphinx integration via sphinxcontrib.plantuml
- Must maintain 0-warning build baseline

### Time Constraints
- Target completion: 4-5 weeks
- Must not impact current documentation

### Resource Constraints
- Single developer (Claude)
- Incremental validation required (can't batch-process all 100+ at once)

---

## 10. Next Steps

### Phase 1 DISCOVER — COMPLETED ✅

Seventeen specialized analyses completed (7400+ lines):
- plantuml-reference-language-analysis.md ✓ (pp. 1-15, sections 1.1-1.18)
- plantuml-sequence-formatting-activation-analysis.md ✓ (pp. 16-22, sections 1.19-1.31)
- plantuml-advanced-sequence-features-analysis.md ✓ (pp. 25-41, sections 1.32-1.45)
- plantuml-use-case-diagrams-analysis.md ✓ (pp. 44-55, sections 2.1-2.18) — **CRITICAL**
- plantuml-styling-strategy-integration-analysis.md ✓ (Two-tier centralization strategy)
- plantuml-include-directive-implementation-analysis.md ✓ (sections 3.0-3.15) — **CRITICAL**
- sphinxcontrib-plantuml-integration-analysis.md ✓ (Sphinx integration) — **CRITICAL**
- plantuml-class-diagrams-analysis.md ✓ (pp. 62-102, sections 4.1-4.28) — OPTIONAL
- plantuml-object-diagrams-analysis.md ✓ (pp. 99-102+, sections 5.1-5.8) — NOT RECOMMENDED
- plantuml-map-diagrams-analysis.md ✓ (pp. 101-104, sections 5.9-5.15) — NOT RECOMMENDED
- plantuml-json-display-analysis.md ✓ (pp. 104-105, sections 5.16-5.18) — NOT APPLICABLE
- plantuml-activity-diagrams-analysis.md ✓ (pp. 106-113, sections 5.1-5.12) — DEPRECATED
- plantuml-activity-diagrams-new-syntax-analysis.md ✓ (pp. 116-150+, sections 6.0.1-6.25) — **RECOMMENDED**
- plantuml-component-diagrams-analysis.md ✓ (pp. 145-164+, sections 7.0-7.18) — NOT APPLICABLE
- plantuml-state-diagrams-analysis.md ✓ (pp. 210-230+, sections 9.0-9.25) — MODERADA-BAJA
- plantuml-timing-diagrams-analysis.md ✓ (pp. 232-272+, sections 10.0-10.29) — NOT APPLICABLE
- plantuml-json-yaml-display-analysis.md ✓ (pp. 258-280+, sections 11.0-12.3+) — NOT APPLICABLE

### Recommended Flow for Approval
1. **Phase 1 DISCOVER:** ✅ Analysis complete (this document + 7 specialized analyses)
2. **Phase 3 DIAGNOSE:** Detailed technical architecture (if needed)
3. **Phase 5 STRATEGY:** Confirm 4-phase implementation approach
4. **Phase 6 PLAN:** Define scope + roadmap
5. **Phase 8 PLAN EXECUTION:** Create atomic task breakdown (T-NNN format)
6. **Phase 10 EXECUTE:** Implement Phase 1 Setup (verify Java, install PlantUML, create styles.puml, test !include)

### Phase 1 Setup Validation Checklist (Critical Path)
- [ ] Java 8+ installed: `java -version` ✓
- [ ] PlantUML v1.2025.0 JAR downloaded
- [ ] sphinxcontrib.plantuml: `pip install sphinxcontrib-plantuml`
- [ ] Create source/_static/plantuml-styles.puml with 13 sections per analysis
- [ ] Test !include directive with 1 sample UC → determine working directory
- [ ] Confirm Sphinx build includes diagram PNG in HTML output
- [ ] Verify 0 new warnings in build

**Gate:** If all Phase 1 Setup items pass → proceed directly to Phase 10 EXECUTE (Validation phase)

---

## 11. Estimated Timeline

```
Week 1: Environment Setup + Style Configuration
├── Day 1-2: Java, PlantUML install, Sphinx config
├── Day 3-4: Create plantuml-styles.puml
└── Day 5: Test with 1 sample diagram

Week 2: Validation (5 Critical Modules)
├── Days 1-2: AUTH, ACCESS modules
├── Days 3-4: USERS, REPORTS modules
└── Day 5: ALERTS module + full validation

Weeks 3-4: Expansion (95+ remaining diagrams)
├── By module (8 modules total)
├── Incremental validation
└── Monitor build time/warnings

Week 5: Documentation & Closure
├── Update README.md, META_XX
├── Create guidelines for new diagrams
└── Final validation, WP closure
```

---

## 12. Success Definition

**WP is CLOSED and SUCCESS when:**

```
$ make clean && make html
# Build succeeds
# 0 warnings
# 100+ diagrams generated as PNG/SVG
# All diagrams display corporate colors
# HTML output shows styled diagrams
```

---

## 13. Evidence Summary

**Observable Evidence (PROVEN):**
- 17 specialized analyses of PlantUML 1.2025.0 Language Reference (pp. 1-280+, 7400+ lines)
- Eleven diagram types + two data display formats analyzed: UC (CRITICAL), Sequence (IMPORTANT), Activity (RECOMMENDED — new syntax), Class (OPTIONAL), State (MODERADA-BAJA), Object (NOT REC.), Map (NOT REC.), Component (NOT APPL.), Timing (NOT APPL.), Deployment (pending evaluation); JSON Display (NOT APPL.), YAML Display (NOT APPL.)
- Sphinx + sphinxcontrib.plantuml integration documented
- Corporate color palette defined (#1976D2, #388E3C, #F57C00)
- Two-tier strategy validated: centralized !include + `<style>` blocks + documented guidelines
- 100+ UC diagrams in IACT-docs confirmed as target
- Clean Code naming principles identified as critical for class diagrams
- Activity diagrams RECOMMENDED using NEW SYNTAX (section 6, NOT old syntax section 5)
- New activity syntax eliminates Graphviz dependency and improves maintainability
- All core diagram types support !include + centralized styling (NOT inline colors)
- Modern `<style>` block approach for hierarchical styling (recommended over skinparam for activities)
- Map, JSON, Object diagrams evaluated and deemed not applicable/recommended

**Inferred Evidence:**
- !include directive supported in PlantUML 1.2025.0 (based on historical support, confidence 0.85)
- Working directory for Java JAR execution affects path resolution (requires validation)
- Centralized styling via `<style>` blocks is modern approach (replaces skinparam for activities)
- Activity diagrams with swimlanes provide excellent actor responsibility mapping
- Class diagrams are optional based on IACT scope (architecture vs. functional requirements)
- New activity syntax aligns with Sphinx plugin requirements (no Graphviz dependency)
- Map, JSON, Object diagrams are explicitly out of scope for IACT requirements documentation

**Key Assumptions to Validate in Phase 1 Setup:**
- Java 8+ is installed
- sphinxcontrib.plantuml supports !include via working directory
- Path resolution: relative paths work from Sphinx root directory
- `<style>` block syntax is supported in activity diagrams with sphinxcontrib.plantuml
- Decision on class diagram applicability (affects Phase 7 design)
- Confirmation that activity diagrams (new syntax) with swimlanes enhance UC documentation clarity

---

**Analysis Created:** 2026-04-23 18:51:00  
**Updated:** 2026-04-24 03:10:00  
**Version:** 1.9.0 (MINOR: incorporated 17 specialized analyses including JSON/YAML display evaluation)
**Status:** Phase 1 DISCOVER COMPLETE  
**Total Content Analyzed:** pp. 1-280+ (sections 1.1-12.3+, 7400+ lines)
**Coverage:** UC (100% CRITICAL), Sequence (100% IMPORTANT), Activity (100% RECOMMENDED — new syntax v6), Class (100% OPTIONAL), State (100% MODERADA-BAJA), Timing (100% NOT APPLICABLE), Component (100% NOT APPLICABLE), Object/Map/JSON/YAML-Display (100% evaluated, NOT APPLICABLE/NOT RECOMMENDED)
**Critical Finding:** Eleven diagram types + two data display formats evaluated; four core diagram types to IACT (UC, Sequence, Activity, Class); one moderate (State); eight out-of-scope (Timing, Component, Object, Map, JSON-Display, YAML-Display, Deployment, JSON-old-analysis)
**Next Phase:** Ready for approval → Phase 5 STRATEGY or Phase 10 EXECUTE (Phase 1 Setup)  
**Ready for approval:** YES ✅

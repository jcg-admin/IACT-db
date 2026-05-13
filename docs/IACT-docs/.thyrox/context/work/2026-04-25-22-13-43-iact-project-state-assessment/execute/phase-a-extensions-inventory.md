```yml
created_at: 2026-04-25 22:52:00
project: IACT-docs
work_package: 2026-04-25-22-13-43-iact-project-state-assessment
phase: Phase 10 — EXECUTE (Phase A)
author: Claude
status: Completado
analysis_date: 2026-04-25
```

# Sphinx Extensions Inventory — IACT-docs

## Executive Summary

**Total Installed:** 22 Sphinx-related packages  
**Active in conf.py:** 10 extensions  
**Disabled:** 1 (sphinxcontrib-plantuml — CRITICAL ISSUE)  
**Unused:** 11 packages installed but not configured  
**Assessment:** Configuration needs standardization; PlantUML hook disabled causing R-004 issue

---

## Critical Finding: PlantUML Disabled

**File:** `source/conf.py:37`  
**Status:** COMMENTED OUT  
**Reason:** FileNotFoundError (noted in comment)  
**Impact:** PlantUML diagrams cannot be compiled; plantuml-guide examples non-functional  

```python
# PlantUML para diagramas (TEMPORARILY DISABLED — causes FileNotFoundError)
# 'sphinxcontrib.plantuml',
```

**This is R-004 risk manifestation.** Needs investigation and fix.

---

## Active Extensions in conf.py (Currently 10)

### Core Sphinx Extensions

| Extension | Version | Purpose | Config | Status |
|-----------|---------|---------|--------|--------|
| `sphinx.ext.intersphinx` | Core | Cross-document links | None | ✅ Active |
| `sphinx.ext.todo` | Core | TODO/FIXME tracking | None | ✅ Active |
| `sphinx.ext.autosectionlabel` | Core | Auto-generate section labels | None | ✅ Active |

### Python API Documentation

| Extension | Version | Purpose | Config | Status |
|-----------|---------|---------|--------|--------|
| `sphinx.ext.autodoc` | Core | Auto-doc from docstrings | ✅ Configured | ✅ Active |
| `sphinx.ext.autosummary` | Core | Auto-generate summaries | ✅ Configured | ✅ Active |
| `sphinx.ext.viewcode` | Core | Link to source code | None | ✅ Active |
| `sphinx.ext.napoleon` | Core | Google/NumPy docstring support | ✅ Configured | ✅ Active |

### Third-party Extensions

| Extension | Version | Purpose | Config | Status |
|-----------|---------|---------|--------|--------|
| `sphinx_design` | 0.7.0 | Card/grid layouts | None | ✅ Active |
| `sphinx_copybutton` | 0.5.2 | Copy code button | ✅ Configured | ✅ Active |
| `myst_parser` | Installed | Markdown support | None | ✅ Active |

### Disabled Extensions

| Extension | Version | Purpose | Reason | Status |
|-----------|---------|---------|--------|--------|
| `sphinxcontrib.plantuml` | 0.31 | PlantUML diagrams | FileNotFoundError | ❌ **DISABLED** |

---

## Installed But Unused (11 packages)

These packages are installed (`pip list`) but NOT referenced in `conf.py`:

| Package | Version | Purpose | Recommendation |
|---------|---------|---------|-----------------|
| `pydata-sphinx-theme` | 0.17.1 | Alternative theme | Remove or use (conflicts with furo) |
| `sphinx-autobuild` | 2025.8.25 | Live-reload server | Keep (dev tool, not needed in conf.py) |
| `sphinx-autodoc-typehints` | 3.6.1 | Type hints in autodoc | **SHOULD USE** (modern Python) |
| `sphinx-basic-ng` | 1.0.0b2 | Base for modern themes | Keep as dependency |
| `sphinx-jinja2-compat` | 0.4.1 | Jinja2 compat | Keep as dependency |
| `sphinx-last-updated-by-git` | 0.3.8 | Track file update dates | **OPTIONAL - Consider** |
| `sphinx-notfound-page` | 1.1.0 | Custom 404 page | **OPTIONAL - Consider** |
| `sphinx-prompt` | 1.10.2 | Formatted prompts | **OPTIONAL - Consider** |
| `sphinx-sitemap` | 2.9.0 | Sitemap generation | **OPTIONAL - Consider** |
| `sphinx-tabs` | 3.4.5 | Tabbed content | **SHOULD USE** (useful for docs) |
| `sphinx-toolbox` | 4.1.2 | Extra tools | Consider if needed |
| `sphinxcontrib-spelling` | 8.0.2 | Spell checker | **SHOULD USE** (for quality) |

### Sphinxcontrib packages (Sphinx core dependencies)

These are distributed with Sphinx Core and should not be removed:

| Package | Purpose |
|---------|---------|
| `sphinxcontrib-applehelp` | Apple Help format support |
| `sphinxcontrib-devhelp` | DevHelp format support |
| `sphinxcontrib-htmlhelp` | HTML Help format |
| `sphinxcontrib-jsmath` | JavaScript math support |
| `sphinxcontrib-qthelp` | Qt Help format |
| `sphinxcontrib-serializinghtml` | Serialized HTML builder |

---

## Configuration Analysis

### conf.py Observations

**Current Theme:** FURO (line 104)  
- **Theme class:** `furo`
- **Status:** Professional, modern, well-maintained
- **Conflict:** `pydata-sphinx-theme` installed but not used (redundant)

**Language:** Spanish (line 86)
- `language = 'es'`
- `html_search_language = 'es'`
- Status: ✅ Appropriate for IACT-docs

**Pygments Style:** `sphinx` (line 93)  
- Status: ✅ Standard, appropriate

**Suppress Warnings:** (line 101)
```python
suppress_warnings = ['misc.highlighting_failure']
```
- Suppresses unknown lexer warnings (plantuml, mermaid, cql)
- **Note:** PlantUML disabled, so this is less relevant now

### PlantUML Configuration (Missing)

**In conf.py:** 0 lines dedicated to PlantUML configuration  
**Status:** When PlantUML is enabled, will need:

```python
# PlantUML Configuration (when enabled)
plantuml = 'plantuml -jar /path/to/plantuml.jar'
plantuml_output_format = 'svg'  # or 'png'
```

---

## Extensions Assessment & Recommendations

### Tier 1: Essential (Must Keep)

- `sphinx.ext.autodoc` ✅ Core
- `sphinx.ext.autosummary` ✅ Core
- `sphinx.ext.viewcode` ✅ Core
- `sphinx_design` ✅ UI Layout
- `sphinx_copybutton` ✅ UX

### Tier 2: Recommended (Should Add)

- `sphinx-autodoc-typehints` — Modern Python type hints support
- `sphinx-tabs` — Create tabbed content sections
- `sphinxcontrib-spelling` — Spell checking for documentation quality

### Tier 3: Optional (Consider)

- `sphinx-last-updated-by-git` — Track file modification dates
- `sphinx-notfound-page` — Custom 404 page
- `sphinx-sitemap` — SEO sitemap generation

### Tier 4: Remove (Redundant/Unused)

- `pydata-sphinx-theme` — Conflicts with furo; not used

### Tier 5: Fix Urgently (Blocked)

- `sphinxcontrib-plantuml` — **Currently disabled; R-004 issue**

---

## Root Cause Analysis: PlantUML FileNotFoundError

**Issue:** PlantUML disabled due to FileNotFoundError

**Possible Causes:**
1. PlantUML JAR file path incorrect in configuration
2. Java not installed or not in PATH
3. sphinxcontrib-plantuml version incompatibility
4. Working directory issue during build

**Investigation Actions:**
- [ ] Check if Java is available: `java -version`
- [ ] Check if PlantUML JAR exists: `which plantuml` or locate JAR
- [ ] Review sphinxcontrib-plantuml (0.31) documentation for version issues
- [ ] Check Sphinx build logs for exact FileNotFoundError trace

**Solution Path:**
1. Enable extension with proper PlantUML configuration
2. Add PlantUML configuration to conf.py
3. Validate with test diagram
4. Document workaround if needed

---

## Standardization Recommendations

### 1. Create requirements.txt

**Purpose:** Track all dependencies with versions  
**Content:**
```
# Core Sphinx (v9.0.4)
Sphinx==9.0.4

# Essential Extensions
sphinx-autodoc-typehints==3.6.1
sphinx_design==0.7.0
sphinx-copybutton==0.5.2
sphinx-tabs==3.4.5
sphinxcontrib-spelling==8.0.2

# Diagram Support (when fixed)
sphinxcontrib-plantuml==0.31

# Development Tools
sphinx-autobuild==2025.8.25

# Theme
furo>=2023.0.0
```

### 2. Update conf.py

**Changes:**
- Enable PlantUML with proper configuration
- Add type hints extension
- Add spell checker
- Add tabs extension (if useful)
- Add comments explaining each extension
- Remove unused imports

### 3. Document Extensions

**Create:** `EXTENSIONS_INVENTORY.md` (this file)  
**Purpose:** Explain each extension's purpose and configuration

### 4. Create Troubleshooting Guide

**Sections:**
- PlantUML setup and fixes
- Extension compatibility issues
- Build warnings and solutions

---

## Summary Table: All Installed Packages

| Package | Version | In conf.py | Recommendation |
|---------|---------|------------|-----------------|
| Sphinx | 9.0.4 | Core | ✅ Keep |
| sphinx-autobuild | 2025.8.25 | No | Keep (dev) |
| sphinx-autodoc-typehints | 3.6.1 | **No** | **Add** |
| sphinx-basic-ng | 1.0.0b2 | No | Keep (dep) |
| sphinx-copybutton | 0.5.2 | ✅ Yes | ✅ Keep |
| sphinx_design | 0.7.0 | ✅ Yes | ✅ Keep |
| sphinx-jinja2-compat | 0.4.1 | No | Keep (dep) |
| sphinx-last-updated-by-git | 0.3.8 | No | Consider |
| sphinx-notfound-page | 1.1.0 | No | Consider |
| sphinx-prompt | 1.10.2 | No | Consider |
| sphinx-sitemap | 2.9.0 | No | Consider |
| sphinx-tabs | 3.4.5 | No | **Add** |
| sphinx-toolbox | 4.1.2 | No | Consider |
| sphinxcontrib-applehelp | 2.0.0 | (dep) | Keep |
| sphinxcontrib-devhelp | 2.0.0 | (dep) | Keep |
| sphinxcontrib-htmlhelp | 2.1.0 | (dep) | Keep |
| sphinxcontrib-jsmath | 1.0.1 | (dep) | Keep |
| sphinxcontrib-plantuml | 0.31 | **Disabled** | **Fix** |
| sphinxcontrib-qthelp | 2.0.0 | (dep) | Keep |
| sphinxcontrib-serializinghtml | 2.0.0 | (dep) | Keep |
| sphinxcontrib-spelling | 8.0.2 | No | **Add** |
| pydata-sphinx-theme | 0.17.1 | No | **Remove** |

---

## Next Steps (Phase 10 Tasks)

1. [ ] **T-002:** Review complete conf.py and identify all sections
2. [ ] **T-003:** Test PlantUML to understand FileNotFoundError
3. [ ] **T-004:** Investigate and fix PlantUML configuration
4. [ ] **T-006:** Create CONFIGURATION_GUIDE.md
5. [ ] **T-009:** Create requirements.txt with all dependencies
6. [ ] **T-010:** Validate build with fixes applied
7. [ ] **T-011:** Commit all configuration improvements

---

**Inventory Status:** COMPLETE  
**Critical Issue Found:** PlantUML disabled (R-004)  
**Files to Create/Update:** requirements.txt, conf.py (extensions section), CONFIGURATION_GUIDE.md  
**Date:** 2026-04-25 22:52:00

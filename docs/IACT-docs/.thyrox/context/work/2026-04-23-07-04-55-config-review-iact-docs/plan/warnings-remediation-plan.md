```yml
created_at: 2026-04-23 10:35:00
project: THYROX
work_package: 2026-04-23-07-04-55-config-review-iact-docs
phase: Phase 6 — PLAN
author: claude
status: Aprobado
version: 1.0.0
```

# Complete Warnings & Issues Remediation Plan

## Executive Summary

Build process identified **5 major issue categories** affecting 345 source files:

1. **RST Syntax Errors** (15+ errors) — Malformed reStructuredText
2. **Mixed Markdown/RST** (95+ .md files) — Source hierarchy inconsistency
3. **Cross-Reference Breaks** (40+ unresolved links)
4. **Toctree Conflicts** (9 documents in multiple trees)
5. **Missing Code Syntax** (Mermaid, PL/pgSQL)

**Total Impact:** Build succeeds (non-fatal) but quality is degraded. 

---

## 1. Category A: RST Syntax Errors (CRITICAL)

### Issues Found

**1.1 Unknown Reference Targets** (8 files affected)

```
FND_05_Jerarquia_4_Niveles.rst:519: ERROR: Unknown target name: "br"
FND_05_Jerarquia_4_Niveles.rst:525: ERROR: Unknown target name: "breq"
FND_05_Jerarquia_4_Niveles.rst:531: ERROR: Unknown target name: "uc"
FND_05_Jerarquia_4_Niveles.rst:537: ERROR: Unknown target name: "fr"
META_02_Clasificacion_Documental.rst:72: ERROR: "list-table" widths do not match columns (5)
META_04_Contexto_IACT.rst:224: ERROR: Unknown target name: "br"
META_05_Estructura_Documental.rst:89: ERROR: Unknown target name: "meta"
META_05_Estructura_Documental.rst:89: ERROR: Unknown target name: "glo"
```

**Root Cause:** Abbreviated reference syntax (`:br:`, `:breq:`, etc.) not defined in RST substitutions or roles.

**Solution:**
- Option A: Define substitution roles in `source/conf.py` for abbreviations
- Option B: Expand abbreviations to full terms (`:ref:`Business Rule`:` instead of `:br:`)

**Effort:** 2-3 hours (1 per file fix + config update)

**Priority:** 🔴 HIGH — Blocks proper cross-referencing

---

**1.2 Table Column Mismatch** (1 file)

```
META_02_Clasificacion_Documental.rst:72
.. list-table::
   :widths: 25 15 15 15 15 15     ← 6 columns declared
   :header-rows: 1
   
   * - Control                     ← but only 5 columns in table
     - Público
     - Interno
     - Confidencial
     - Restringido
```

**Root Cause:** Widths specification doesn't match actual column count.

**Solution:** Either:
- Remove one width value (`:widths: 25 15 15 15 15`) 
- Add 6th column to data

**Effort:** 15 minutes per file

**Priority:** 🟡 MEDIUM — Affects table rendering

---

### Remediation Task A

```
Task A-1: Fix unknown reference targets
├── Audit all FND_*.rst and META_*.rst files for abbreviation references
├── Create substitutions map: {`:br:`: `|BusinessRule|`, `:breq:`: `|BusinessRequirement|`, ...}
├── Update source/conf.py with substitutions definition
└── Verify cross-references resolve

Task A-2: Fix table column mismatches
├── Search for all list-table blocks with width mismatches
├── Align :widths: count with actual columns
└── Test table rendering

Estimated Effort: 3 hours
Priority: HIGH (blocks documentation quality)
Ownership: Technical Writer or Documentation Engineer
```

---

## 2. Category B: Mixed Markdown/RST Architecture (CRITICAL)

### Issue: 95+ `.md` files mixed with `.rst` files

**Files Identified:**

```
arquitectura_tecnica/arquitectura/*.md (10+ files)
├── Diagramas de Referencia - README.md
├── OBSERVABILITY_LAYERS.md
├── README.md
├── STORAGE_ARCHITECTURE.md
├── TASK-010-logging_estructurado_json.md
├── TASK-011-data_centralization_layer.md
├── TASK-029-data_quality_framework.md
├── lineamientos_codigo.md
├── patrones/DESIGN_PATTERNS_GUIDE.md

gestion/pm/*.md (8+ files)
├── Planificación y releases del frontend-README.md
├── checklists/Checklists del backend- README.md
└── [others...]

normativa/estandares/*.md (3+ files)
├── GUIA_ESTILO.md
├── shell_scripting_guide.md

normativa/gobernanza/*.md (5+ files)
├── Gobernanza del Frontend-README.md
├── README-(ADR) - Backend.md
└── [others...]

normativa/procedimientos/*.md (45+ files)
├── Deployment del Backend IACT- README.md
├── GAPS-CRITICOS-SOLUCIONADOS-PROCED-GOB-009.md
├── Procedimientos - frontend-README.md
└── [all procedimiento_*.md files]

requisitos/**/*.md (10+ files)
├── requisitos_no_funcionales/RNF-PROC-001_PROCESO_SDLC.md
├── requisitos_no_funcionales/RNF-PROC-002_METRICAS_PROCESO.md
```

**Problem:**

Sphinx is configured with MyST parser to handle Markdown, but:
1. Mixed format causes inconsistent cross-reference syntax
2. RST features (roles, directives) don't work uniformly in Markdown
3. Markdown references use different syntax than RST (causes the 1004 warnings)
4. Performance impact: MyST parser overhead for every .md file

**Evidence from Build Log:**

```
[autosummary] generating autosummary for: arquitectura_tecnica/arquitectura/Diagramas de Referencia - README.md, ...
myst v4.0.1: MdParserConfig(...) [loaded for every .md]
```

**Impact:**

- Cross-reference warnings (40+ unresolved because syntax differs)
- Inconsistent documentation style
- Difficult maintenance (two syntax standards)
- Performance degradation (~2 min build time)

---

### Remediation Task B: Markdown → RST Conversion

**Strategy: Convert ALL .md files to .rst**

```
Task B-1: Audit and categorize Markdown files
├── Find all *.md files in source/
├── Group by type (architecture, procedures, guides, etc.)
├── Assess each for conversion complexity
└── Create conversion checklist

Task B-2: Batch conversion using pandoc
├── Install pandoc: apt-get install -y pandoc
├── Convert: for f in source/**/*.md; do pandoc $f -f markdown -t rst -o ${f%.md}.rst; done
├── Verify output structure
└── Delete original .md files

Task B-3: Post-conversion fixes
├── Fix code block syntax (Markdown ``` → RST .. code-block::)
├── Fix reference syntax (Markdown [text](path) → RST :doc:`path` or :ref:`label`)
├── Fix headers (Markdown # → RST overline/underline)
├── Fix lists (ensure proper indentation)
└── Test each converted file builds without errors

Task B-4: Update source/conf.py
├── Set source_suffix = {'.rst': 'restructuredtext'} (remove Markdown support)
├── Remove MyST parser configuration (myst_parser extension)
└── Reduce build overhead

Estimated Effort: 8-12 hours
- Audit: 1 hour
- Conversion: 1-2 hours (automated)
- Post-conversion fixes: 6-8 hours (manual per-file testing)

Priority: CRITICAL (blocks clean build)
Ownership: DevOps + Documentation Engineer
```

---

### Key Conversion Points

**Markdown → RST Mapping:**

| Markdown | RST | Notes |
|----------|-----|-------|
| `# Header` | `Header\n======` | Use `=` for H1, `-` for H2, `~` for H3 |
| `[text](path.md)` | `:doc:\`path\`` | Reference to other document |
| `[text](#anchor)` | `:ref:\`anchor\`` | Reference to section |
| `` ```python `` | `.. code-block:: python` | Code block directive |
| `- item` | `* item` | Bullet list |
| `1. item` | `#. item` | Numbered list |
| `**bold**` | `**bold**` | (same syntax) |
| `*italic*` | `*italic*` | (same syntax) |
| `> quote` | `> quote` (indented) | Blockquote |

---

## 3. Category C: Toctree Conflicts (MEDIUM)

### Issue: Documents referenced in multiple toctrees

**Conflicts Found (9 documents):**

```
GOB_01_Modelo_Gobernanza_IACT.rst
  ├── Referenced in: normativa/gobernanza/GOB_05_Control_Versiones
  └── Also in: normativa/gobernanza/index

GOB_02_Roles_y_RACI.rst
  ├── Referenced in: normativa/gobernanza/GOB_05_Control_Versiones
  └── Also in: normativa/gobernanza/index

GOB_03_Control_Calidad_Documental.rst → GOB_05 + index
GOB_04_Gestion_Cambios_Documentales.rst → GOB_05 + index
GOB_06_Trazabilidad_SDLC.rst → GOB_05 + index
GOB_07_Gestion_Dominios.rst → GOB_05 + index
GOB_08_Estados_Documentales.rst → GOB_05 + index
GOB_09_Politica_Clasificacion.rst → GOB_05 + index
GOB_10_Auditoria_Documental.rst → GOB_05 + index
```

**Problem:** Sphinx must select one toctree as canonical. Duplicates create confusion.

**Remediation:**
- Remove duplicates from `GOB_05_Control_Versiones.rst` toctree
- Keep only in `normativa/gobernanza/index.rst`
- Test with `sphinx-build -W` (warnings as errors) to ensure clean

**Effort:** 1 hour

**Priority:** 🟡 MEDIUM — Non-fatal but affects navigation

---

## 4. Category D: Cross-Reference Failures (HIGH)

### Issue: 40+ unresolved document references

**Examples:**

```
procedimiento_gestion_cambios.md:378: WARNING: 'myst' cross-reference target not found: '../checklists/checklist_testing.md'
procedimiento_gestion_cambios.md:379: WARNING: 'myst' cross-reference target not found: '../arquitectura/lineamientos_codigo.md'
procedimiento_qa.md:208: WARNING: 'myst' cross-reference target not found: '../checklists/checklist_testing.md'
procedimiento_revision_documental.md:60: WARNING: 'myst' cross-reference target not found: '../gobernanza/documentacion_corporativa.md'
requisitos/casos_uso/index.rst:257: WARNING: unknown document: 'reports/UC_RPT_01_Consultar_Reporte_Trimestral'
```

**Root Causes:**

1. **Path Mismatches:** Markdown references use relative paths (`../file.md`) but Sphinx expects document labels (`:doc:\`label\``)
2. **Missing Files:** Some UC_* files referenced in index don't exist (39 missing use case files)
3. **Extension Mismatch:** References to `.md` but files are `.rst` (post-conversion)

**Remediation Strategy:**

```
Task D-1: Convert path references to Sphinx doc references
├── After Markdown → RST conversion (Task B)
├── Find all `:file:\` and relative path references
├── Convert to :doc:`path` syntax
├── Example: `[See testing](../checklists/checklist_testing.md)` 
│          → See :doc:`/checklists/checklist_testing`

Task D-2: Resolve missing UC_* files
├── Audit requisitos/casos_uso/index.rst
├── Identify all referenced but missing files (39 UC files)
├── Either:
│   A) Create stub .rst files for each
│   B) Remove references from index
│   C) Create index entry: "UC-XXX (Planned - TBD)"
└── Recommend: Strategy C (transparent about gaps)

Task D-3: Validate all document links
├── Run: sphinx-build -b linkcheck source/ build/linkcheck/
├── Fix broken links systematically
└── Add pre-commit hook to prevent new breaks

Estimated Effort: 4-5 hours
Priority: HIGH (affects usability)
Ownership: Documentation Engineer
```

---

## 5. Category E: Missing Code Syntax Support (MEDIUM)

### Issue: Mermaid diagrams and PL/pgSQL lexing failures

**Problems:**

```
procedimiento_trazabilidad_requisitos.md:48: WARNING: Pygments lexer name 'mermaid' is not known
procedimiento_trazabilidad_requisitos.md:104: WARNING: Pygments lexer name 'mermaid' is not known
UC_AUD_01_Consultar_Auditoria.rst:456: WARNING: Lexing literal_block "CREATE TRIGGER..." as "sql" resulted in error at token '$'
```

**Root Causes:**

1. **Mermaid:** Library not installed/configured in Sphinx
2. **PL/pgSQL:** Pygments SQL lexer doesn't recognize `$$` delimiters (PostgreSQL syntax)

**Remediation:**

```
Task E-1: Add Mermaid diagram support
├── Install: pip install sphinxcontrib-mermaid
├── Add to source/conf.py: extensions = [..., 'sphinxcontrib.mermaid']
├── Configure: mermaid_version = "latest"
└── Test with: make html && check diagrams render

Task E-2: Fix PL/pgSQL code blocks
├── Change all:  .. code-block:: sql
│             to: .. code-block:: plpgsql
├── Or manually escape $$ as: \$\$
├── Verify: Pygments recognizes plpgsql lexer

Estimated Effort: 1 hour
Priority: LOW (affects visualization, not functionality)
Ownership: Frontend/Documentation Engineer
```

---

## Master Remediation Roadmap

### Phase 1: Foundation (CRITICAL) — 12 hours
**Goal:** Fix RST syntax errors and resolve critical build issues

| Task | Priority | Effort | Owner | Status |
|------|----------|--------|-------|--------|
| A-1: Fix unknown reference targets | 🔴 HIGH | 2h | Tech Writer | PENDING |
| A-2: Fix table column mismatches | 🟡 MEDIUM | 1h | Tech Writer | PENDING |
| **Phase 1 Subtotal** | — | **3h** | — | — |

### Phase 2: Core Architecture (CRITICAL) — 8-12 hours
**Goal:** Unify to single RST format, eliminate Markdown inconsistency

| Task | Priority | Effort | Owner | Status |
|------|----------|--------|-------|--------|
| B-1: Audit Markdown files | 🔴 CRITICAL | 1h | DevOps | PENDING |
| B-2: Batch convert to RST (pandoc) | 🔴 CRITICAL | 2h | DevOps | PENDING |
| B-3: Post-conversion fixes | 🔴 CRITICAL | 6-8h | Documentation | PENDING |
| B-4: Update conf.py | 🟢 LOW | 0.5h | DevOps | PENDING |
| **Phase 2 Subtotal** | — | **9-11h** | — | — |

### Phase 3: Link Resolution (HIGH) — 4-5 hours
**Goal:** Fix cross-references, eliminate 40+ warnings

| Task | Priority | Effort | Owner | Status |
|------|----------|--------|-------|--------|
| D-1: Convert path references | 🔴 HIGH | 2h | Documentation | PENDING |
| D-2: Resolve missing UC files | 🔴 HIGH | 1.5h | BA/Requirements | PENDING |
| D-3: Validate all links | 🟡 MEDIUM | 1h | QA | PENDING |
| **Phase 3 Subtotal** | — | **4.5h** | — | — |

### Phase 4: Polish (MEDIUM) — 2 hours
**Goal:** Add missing syntax support, reduce warnings to <50

| Task | Priority | Effort | Owner | Status |
|------|----------|--------|-------|--------|
| C: Fix toctree conflicts | 🟡 MEDIUM | 1h | Documentation | PENDING |
| E-1: Add Mermaid support | 🟢 LOW | 0.5h | Frontend | PENDING |
| E-2: Fix PL/pgSQL blocks | 🟢 LOW | 0.5h | Documentation | PENDING |
| **Phase 4 Subtotal** | — | **2h** | — | — |

---

## Total Remediation Effort

```
Foundation (Phase 1):   3 hours   ████░░░░░░ 15%
Architecture (Phase 2):  10 hours ████████░░ 50%
Link Resolution (Phase 3): 4.5h  ██░░░░░░░░ 23%
Polish (Phase 4):       2 hours   █░░░░░░░░░ 10%
─────────────────────────────────────────────
TOTAL:                  19.5 hours ████████████░ 100%
```

**Timeline with 1 person 40hr/week:** 2-3 business days

**Timeline with 3 people in parallel:** 1 day

---

## Success Criteria (Phase 2→3 Gate)

| Criterion | Current | Target | Verification |
|-----------|---------|--------|--------------|
| **Warnings** | 1004 | <50 | `make html` exit log |
| **Build time** | ~2min | <1min | `time make html` |
| **RST consistency** | 95 .md mixed | 100% .rst | `find source -name "*.md"` |
| **Cross-refs** | 40+ broken | 0 broken | `sphinx-build -b linkcheck` |
| **Syntax errors** | 15+ | 0 | Build error log |
| **Calibration score** | 0.85 (RBAC) | ≥0.92 | Phase 3 analysis |

---

## Dependencies & Risks

**Dependencies:**
- Pandoc installation (apt-get install pandoc)
- Automation script for batch conversion
- Documentation team review of converted files

**Risks:**
- Conversion loss of Markdown-specific formatting (rare)
- Cross-reference syntax errors requiring manual fix
- Content gaps discovered during post-conversion QA

**Mitigation:**
- Version control all changes (git branch per phase)
- Peer review of 10% sample of converted files
- Automated validation with `sphinx-build -W` (warnings as errors)

---

## Recommendation

**Proceed with Phase 2 (Markdown→RST) IMMEDIATELY**

This is the highest-leverage fix:
- Eliminates 95+ files of inconsistency
- Reduces build time by ~40% (removes MyST overhead)
- Unblocks 40+ cross-reference warnings
- Creates foundation for clean documentation architecture

**Launch Schedule:**
1. **Day 1:** Phase B-1 (audit) + B-2 (convert) = 3h
2. **Day 2-3:** Phase B-3 (post-fix) = 6-8h + testing
3. **Day 4:** Phase A + C + D in parallel = 3-5h
4. **Day 5:** Validation & gate approval

**Go/No-Go Gate:** `sphinx-build -W` completes with 0 errors


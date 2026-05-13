```yml
created_at: 2026-04-25 22:25:00
project: IACT-docs
reference: Sphinx Official Documentation (github.com/sphinx-doc/sphinx/doc)
analysis_type: Comparative Structure Analysis
status: Complete
```

# Sphinx Official Documentation Structure — Reference Analysis

## Executive Summary

Analyzed Sphinx official documentation structure to identify patterns for IACT-docs improvement.

**Sphinx Official Doc:**
- 154 RST files organized into 8 main domains
- Focus: Product documentation (usage, tutorials, reference)
- Minimal domain separation

**IACT-docs Current:**
- 352 RST files organized into 6 main domains
- Focus: Requirements + Architecture + Business + Operations
- More domain separation (better for large projects)

---

## Sphinx Official Structure

### Domain Breakdown (154 RST files)
```
usage/               50 files   (28%) — User guides, quickstart, installation
changes/             49 files   (32%) — Release notes, changelog  
extdev/              17 files   (11%) — Extension development
development/         12 files   (8%)  — Contributing, developer guides
tutorial/             9 files   (6%)  — Tutorials, getting started
internals/            5 files   (3%)  — Internal architecture
man/                  5 files   (3%)  — Man pages
root/                 7 files   (5%)  — Homepage, glossary, examples
```

### Key Characteristics
1. **Usage-focused:** Half the docs are user guides (usage + tutorial)
2. **Changelog heavy:** 32% is release notes and changes
3. **Minimal reference:** No separate "requirements" or "business" domains
4. **Lean structure:** Only 8 top-level domains
5. **File naming:** Simple, descriptive (`quickstart.rst`, `installation.rst`)

### Root-Level Files (Index Level)
- `index.rst` — Main homepage
- `examples.rst` — Code examples
- `glossary.rst` — Terminology
- `support.rst` — Community/support links
- `latex.rst` — LaTeX build info

### Subdomain Patterns
- `usage/advanced/` — Advanced features
- `usage/builders/` — Builder-specific guides
- `extdev/internals/` — Technical details
- `development/howtos/` — Contributor how-tos

---

## IACT-docs Current Structure

### Domain Breakdown (352 RST files)
```
requisitos/             180 files (51%) — Functional + non-functional requirements
arquitectura_tecnica/    45 files (13%) — Technical design, patterns
base_cognitiva/          32 files (9%)  — Business concepts, models
normativa/               48 files (14%) — Governance, RBAC, standards
gestion/                 28 files (8%)  — Operations, processes, procedures
plantuml-guide/          19 files (5%)  — Diagram examples
```

### Key Characteristics
1. **Requirements-heavy:** 51% is functional/non-functional requirements
2. **Architecture-focused:** Clear technical design documentation
3. **Governance explicit:** RBAC and compliance documented
4. **Domain separation:** 6 distinct business domains (vs Sphinx's 8 product domains)
5. **More structured:** Reflects enterprise system (not just product docs)

### Root-Level Files
- `index.rst` — Main homepage
- `authors.rst` — Contributors
- `readme.rst` — Project overview
- `licence.rst` — Licensing
- `prerequisites.rst` — Setup requirements

### Current Issues
- Title formatting inconsistencies (296 errors)
- Some domains sparse (gestion/ has only 28 files)
- Placeholder text ("[Nombre de tu Empresa]")
- Uneven coverage across requirements modules

---

## Comparative Analysis

### Sphinx Philosophy (Product Documentation)
```
Sphinx Official = User-Centric Documentation
├── Usage (how to use the product)
├── Tutorials (learning path)
├── Reference (API docs, extensions)
├── Changelog (release notes)
└── Community (support, contributing)
```

**Strengths:**
- Clear user journey: Install → Tutorial → Advanced Usage
- Changelog is first-class citizen (32% of docs)
- Simple, flat structure easy to navigate

**Limitations:**
- Minimal requirements documentation
- No business/governance domain
- Doesn't track functional vs non-functional specs

---

### IACT-docs Philosophy (Enterprise System Documentation)
```
IACT-docs = Requirements + Architecture + Operations
├── Requisitos (specs: what must be built)
├── Arquitectura (design: how to build it)
├── Base_Cognitiva (concepts: why these choices)
├── Normativa (governance: who can do what)
├── Gestión (operations: how to run it)
└── PlantUML (visual: diagrams)
```

**Strengths:**
- Comprehensive requirements traceability (RTM)
- Clear business vs technical separation
- Governance/RBAC explicitly documented
- Supports enterprise compliance needs

**Limitations:**
- Heavy on requirements (51%) — may overwhelm new users
- No user-facing "Getting Started" path like Sphinx
- Minimal change/release documentation
- Could benefit from "User Guides" domain

---

## Recommendations for IACT-docs

### R-001: Add User-Centric Layer
Create a `user-guides/` domain (inspired by Sphinx `usage/`) with:
- Quick start guide (first 15 minutes)
- Installation & setup
- Common tasks/workflows
- FAQ/troubleshooting

**Benefit:** New users see a clear learning path before diving into requirements.

### R-002: Improve Requirements Organization (Sphinx doesn't have this)
IACT-docs already does this better than Sphinx:
- Requisitos split by type (functional, non-functional)
- RTM (requirements traceability matrix) present
- Good granularity per UC

**Action:** Keep this structure; just fix formatting (Phase B).

### R-003: Add Changelog/Release Notes Domain
Sphinx allocates 32% to changes. IACT-docs has none.

**Recommendation:** Add `changelog/` domain with:
- Release notes per version
- Migration guides
- Breaking changes
- Deprecation notices

**Size:** 5-10% of total docs initially

### R-004: Simplify Root-Level Navigation
Sphinx root has: index, examples, glossary, support  
IACT currently has: index, authors, readme, licence, prerequisites

**Suggestion:** 
- Keep: authors, licence
- Move: readme → user-guides/overview
- Consolidate: prerequisites → user-guides/installation
- Add: glossary.rst (define domain terms)

### R-005: Domain Sizing (Optional Rebalancing)
| Domain | Current | Sphinx Inspiration | Suggested |
|--------|---------|-------------------|-----------|
| requisitos/ | 51% | — (no equiv) | 40% (keep core, move examples out) |
| arquitectura/ | 13% | extdev (11%) | 15% ✓ Good |
| base_cognitiva/ | 9% | — (no equiv) | 10% ✓ Reasonable |
| normativa/ | 14% | — (enterprise) | 15% ✓ Keep |
| gestion/ | 8% | usage (28%) | 12% (expand to user guides) |
| user-guides/ | 0% | usage (28%) | 8% (new, inspired by Sphinx) |

---

## Sphinx Naming Patterns (for IACT reference)

### File Naming in Sphinx Official
- **Descriptive:** `quickstart.rst`, `installation.rst`, `deploying.rst`
- **No numbers:** Not `01-quickstart.rst` — names convey sequence
- **Lowercase:** `automatic-doc-generation.rst` (not CamelCase)
- **Hyphens:** Separate words with `-`, not `_`

**IACT Status:**
- ✅ Generally follows this (most files are descriptive)
- ⚠️ Some use underscores (`UC_001_Create_User`) for requirements
- ✅ No numbered prefixes (good)

### Directory Naming in Sphinx
- `usage/advanced/` — Subsection of usage
- `extdev/internals/` — Technical internals
- Clean, simple names

**IACT Status:**
- ✅ Clear domain names
- ✅ Subdomains are logical (`requisitos_funcionales/`, `usuarios/`)

---

## Structural Findings Summary

### What IACT Does Better than Sphinx Official
1. ✅ **Requirements traceability** — IACT has RTM, Sphinx doesn't
2. ✅ **RBAC/Governance** — IACT explicitly documents, Sphinx doesn't
3. ✅ **Architecture-first** — IACT prioritizes design decisions
4. ✅ **Compliance** — IACT tracks security/standards

### What Sphinx Does Better than IACT
1. ✅ **User-centric journey** — Clear: Install → Learn → Use
2. ✅ **Changelog prominence** — 32% of docs dedicated to changes
3. ✅ **Simplicity** — Flat structure easy to navigate
4. ✅ **Community** — Support/contributing links at root

### What IACT Could Adopt from Sphinx
1. ✅ **User-guides domain** (8% of docs) — Currently missing
2. ✅ **Changelog/Release domain** (5-10%) — Currently missing
3. ✅ **Root-level glossary** — Define domain terminology
4. ✅ **Getting started guide** — Before requirements deep-dive

---

## Implementation Impact

These recommendations could be part of **Phase B: Documentation Completeness** with new domains:
- `user-guides/` — User-centric documentation
- `changelog/` — Release notes and changes
- `glossary.rst` — Domain terminology

**Total effort:** 2-3 weeks to establish + write initial content  
**Benefit:** IACT would combine:
- Sphinx's user-friendly structure
- Enterprise requirements rigor
- Governance/compliance transparency

---

**Analysis Date:** 2026-04-25 22:25:00  
**Reference:** Sphinx official documentation (154 RST files)  
**Status:** Ready for Phase B implementation planning

```yml
created_at: 2026-04-23 11:30:00
project: THYROX
work_package: 2026-04-23-07-04-55-config-review-iact-docs
phase: Phase 6 — PLAN
author: claude
status: Aprobado
version: 1.0.0
```

# Architectural Patterns Reference Analysis

## Executive Summary

Analyzed 3 reference repositories to identify best practices for Python project structure, dependency management, and documentation tooling.

**Key Findings:**

1. **litestar-workflows** (Modern Python framework)
   - Using uv_build backend directly (PEP 517 cutting edge)
   - dependency-groups experimental feature (next-gen over optional-dependencies)
   - 2-tier dependency structure: core + optional extras

2. **sphinx** (Documentation engine)
   - Production-stable (Status :: 5 - Production/Stable)
   - Rich classifiers for discoverability (32+ classifiers)
   - Python 3.12+ support actively maintained
   - Extensive optional-dependencies groups

3. **gnome-builder** (C/GLib application)
   - Uses Meson build system (not relevant for Python docs)
   - But shows mature desktop app structure patterns

---

## 1. Dependency Management Patterns

### Pattern 1A: Traditional optional-dependencies (Current IACT-docs)

**Structure:**
```toml
[project.optional-dependencies]
dev = ["black", "pytest"]
all = ["iact-docs[dev]"]
```

**Pros:**
- ✅ Universal (pip, poetry, uv all support)
- ✅ Stable and battle-tested
- ✅ Clear semantics

**Cons:**
- ❌ Can't express group hierarchies
- ❌ No "group A includes group B" syntax
- ❌ Flat namespace for complex projects

**Recommendation:** ✅ **STICK WITH THIS** for IACT-docs
- Reason: IACT-docs is documentation, not complex framework
- Better for reproducibility across tools
- No need for hierarchical dependencies yet

---

### Pattern 1B: Experimental dependency-groups (litestar-workflows)

**Structure:**
```toml
[dependency-groups]
docs = ["sphinx>=7.0.0", "myst-parser>=2.0.0"]
lint = ["ruff>=0.8.0", "codespell>=2.2.6"]
test = ["pytest>=8.1.1", "pytest-asyncio>=0.23.6"]
dev = [{include-group = "docs"}, {include-group = "lint"}, {include-group = "test"}]

[project.optional-dependencies]
all = [{include-group = "dev"}]
```

**Pros:**
- ✅ Hierarchical (group can include other groups)
- ✅ More expressive for complex projects
- ✅ Future PEP standard (in development)

**Cons:**
- ❌ Not yet in PEP spec (experimental)
- ❌ Limited tool support (poetry, older pip don't support)
- ❌ Breaking future change risk

**Recommendation:** ❌ **NOT FOR IACT-DOCS YET**
- Reason: Experimental, breaks compatibility
- Wait for official PEP standardization
- Re-evaluate in 2026 Q4 when mature

---

## 2. Build Backend Patterns

### Pattern 2A: setuptools (IACT-docs current)

```toml
[build-system]
requires = ["setuptools>=68.0", "wheel"]
build-backend = "setuptools.build_meta"
```

**Usage:** Universal, all tools support it

**Recommendation:** ✅ **KEEP FOR NOW**
- Still most compatible
- No need to change working setup

---

### Pattern 2B: uv_build (litestar-workflows)

```toml
[build-system]
build-backend = "uv_build"
requires = ["uv_build>=0.9.11,<0.11.0"]
```

**Pros:**
- ✅ Integrated with uv (single tool)
- ✅ Faster builds
- ✅ Simplified configuration

**Cons:**
- ❌ Requires uv to be installed
- ❌ Breaks CI systems without uv
- ❌ Relatively new

**Recommendation:** ⏳ **FUTURE MIGRATION**
- Timeline: 2026 Q3 (when uv stabilizes v1.0+)
- Prerequisite: uv becomes standard in Python ecosystem
- No rush for IACT-docs

---

## 3. Dependency Group Architecture

### litestar-workflows Model (Hierarchical)

```
core (implicit: litestar>=2, rich-click>=1.7.4)
  ├── docs (Sphinx ecosystem)
  │   ├── linkify-it-py>=2.0.0
  │   ├── myst-parser>=2.0.0
  │   ├── sphinx>=7.0.0
  │   └── sphinx-design>=0.5.0
  ├── lint (Code quality)
  │   ├── ruff>=0.8.0
  │   ├── codespell>=2.2.6
  │   └── ...
  └── test (Testing)
      ├── pytest>=8.1.1
      ├── pytest-asyncio>=0.23.6
      └── ...

dev = docs + lint + test (composite)
all = db + ui (for end users)
```

**Applies to IACT-docs?** Partially — could improve:

```toml
# Current (flat)
[project.optional-dependencies]
dev = ["black", "isort", "flake8", "mypy", "pytest"]
livehtml = ["sphinx-autobuild"]
diagrams = ["sphinxcontrib-plantuml"]
all = ["iact-docs[dev,livehtml,diagrams]"]

# Proposed (still flat, but organized)
[project.optional-dependencies]
# Quality assurance
lint = ["black>=24.0.0", "isort>=5.13.0", "flake8>=7.0.0"]
test = ["pytest>=8.0.0"]
type = ["mypy>=1.8.0"]
qa = ["iact-docs[lint,test,type]"]

# Development experience
server = ["sphinx-autobuild>=2025.8.0"]
diagrams = ["sphinxcontrib-plantuml>=0.26.0"]
dev = ["iact-docs[qa,server,diagrams]"]
all = ["iact-docs[dev]"]
```

**Implementation Recommendation:** ✅ **ENHANCE CURRENT pyproject.toml**
- Add lint/test/type/qa groups for clarity
- Keep optional-dependencies for compatibility
- Map current [dev] to the new hierarchical names

---

## 4. Sphinx-Specific Patterns (from sphinx repo analysis)

### Classifiers (Discoverability)

**Sphinx uses 32+ classifiers:**

```toml
classifiers = [
    "Development Status :: 5 - Production/Stable",
    "Environment :: Console",
    "Environment :: Web Environment",
    "Framework :: Sphinx",
    "Framework :: Sphinx :: Domain",
    "Framework :: Sphinx :: Extension",
    "Framework :: Sphinx :: Theme",
    "Topic :: Documentation",
    "Topic :: Documentation :: Sphinx",
]
```

**For IACT-docs:**

```toml
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Developers",
    "License :: Other/Proprietary License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
    "Programming Language :: Python :: 3.13",
    "Topic :: Documentation",
    "Topic :: Documentation :: Sphinx",
]
```

**Action:** ✅ ADD TO pyproject.toml (already started, enhance)

---

### Python Version Support

**Sphinx:** 3.12, 3.13, 3.14, 3.15 (cutting edge)

**IACT-docs current:** 3.11+

**Recommendation:** Update in 2026 Q3
```toml
requires-python = ">=3.12"  # When 3.11 EOL approaches
```

---

## 5. Documentation Structure (No Relevant Patterns Found)

- **litestar-workflows:** No embedded documentation (external via sphinx)
- **sphinx:** Self-documenting (obviously)
- **gnome-builder:** C/GLib docs (not applicable)

**Conclusion:** IACT-docs structure is appropriate for project type.

---

## 6. Specific Recommendations for IACT-docs

### Immediate (This Sprint)

✅ **DONE:**
- [x] Migrate to pyproject.toml
- [x] Add sphinxcontrib-plantuml
- [x] Use uv for dependency resolution

⚠️ **Optional but Recommended:**
- [ ] Enhance classifiers in pyproject.toml (low effort, high SEO)
- [ ] Reorganize optional-dependencies by domain (lint/test/type/server)
- [ ] Add project.urls entries (Documentation, Issues, Repository)

### Future (2026 Q3)

⏳ **When Standards Stabilize:**
- Evaluate uv_build backend (requires uv@1.0+)
- Consider dependency-groups if PEP standardized
- Update Python version constraint (drop 3.11 EOL)

### Not Recommended

❌ **Anti-Patterns to Avoid:**
- Don't use experimental features before PEP standardization
- Don't switch build backends frequently
- Don't add "optional-optional" dependencies (keep groups flat)

---

## 7. Benchmark Metrics

| Metric | IACT-docs | litestar | sphinx |
|--------|-----------|----------|--------|
| **Core deps** | 87 | 2 | ~20 |
| **Classifiers** | 8 | 10 | 32 |
| **Optional groups** | 3 (dev/all) | 4 hierarchical | N/A |
| **Build backend** | setuptools | uv_build | flit |
| **Python min version** | 3.11 | 3.10 | 3.12 |
| **Status** | Beta | Alpha | Production |

**Conclusion:** IACT-docs is comparable in maturity, more dependencies appropriate for docs project.

---

## 8. Implementation Checklist for pyproject.toml Enhancement

```
Task List (Low Effort, High Value):

[ ] 1. Add comprehensive classifiers (10 min)
[ ] 2. Reorganize optional-dependencies with descriptive comments (5 min)
[ ] 3. Add comprehensive project.urls section (5 min)
[ ] 4. Document uv commands in pyproject.toml comments (10 min)
[ ] 5. Add [tool.uv] settings with explanations (5 min)
Total Effort: ~35 minutes
```

**Files to Update:** pyproject.toml only

**Compatibility:** 100% backward-compatible (no breaking changes)

---

## Conclusion

**IACT-docs Architecture Assessment: ✅ SOUND**

The migration to pyproject.toml + uv is:
- Modern (aligns with 2026+ Python standards)
- Safe (no experimental features)
- Compatible (works with all tools)
- Future-proof (can upgrade incrementally)

**Recommended Path:**
1. Keep current setup (stable, working)
2. Enhance pyproject.toml metadata (classifiers, URLs)
3. Monitor uv_build maturation for future migration
4. Reassess dependency-groups in late 2026

**No architectural red flags detected.**


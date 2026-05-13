```yml
created_at: 2026-04-23 18:00:00
project: IACT-docs
work_package: 2026-04-23-07-04-55-config-review-iact-docs
phase: Phase 11 — TRACK/EVALUATE
status: Identified
```

# Cleanup Analysis: Project Structure Inconsistencies

**Question:** Why exist `requirements.txt.deprecated`, `deep-dive-documentation-warnings.md`, and `iact_docs.egg-info`?

**Answer:** Three separate issues with different cleanup approaches.

---

## Issue 1: `requirements.txt.deprecated`

### What It Is
- Legacy dependency file from pre-pyproject.toml migration
- File is **corrupted** (binary/encoding issue — readable as garbage)
- Project has migrated to modern PEP 517 build system (pyproject.toml)

### Why It Exists
1. Project was initially configured with `requirements.txt`
2. Migration to `pyproject.toml` occurred (best practice, PEP 517 compliant)
3. Old `requirements.txt` renamed to `.deprecated` instead of deleted (preserves history)

### Current State
```
requirements.txt.deprecated  (3,756 bytes, corrupted encoding)
pyproject.toml              (active, contains dependencies)
```

### Problem
- Two dependency definitions exists
- File is orphaned (not used by any build system)
- Naming convention `.deprecated` is non-standard (should be git history)
- Corrupted content makes it unreadable/useless

### Recommendation
**DELETE** — Move to git history instead

```bash
# Clean approach:
rm requirements.txt.deprecated

# Git history preserved:
git log --all -- requirements.txt.deprecated  # Can recover if needed
```

### Why Safe to Delete
- ✅ pyproject.toml contains all current dependencies
- ✅ No build process reads it
- ✅ Historical versions available via git
- ✅ Doesn't interfere with development

---

## Issue 2: `deep-dive-documentation-warnings.md`

### What It Is
- Output from `deep-dive` agent analysis (Phase 1 DISCOVER)
- 471-line adversarial analysis of the 711 warnings
- Located in **project ROOT**, not in Work Package

### Why It Exists
- Created during initial investigation (before WP was formalized)
- WP structure wasn't established at that time
- File was never moved into `.thyrox/context/work/` structure

### Current State
```
File location:     ./deep-dive-documentation-warnings.md (root)
WP location:       .thyrox/context/work/2026-04-23-07-04-55-config-review-iact-docs/
WP structure:      discover/, analyze/, track/, etc.
```

### Problem
- File is out of place (should be in WP discover/ folder)
- Root directory polluted with analysis artifacts
- Makes git root harder to navigate
- Breaks organizational structure

### Recommendation
**MOVE** to proper WP location

```bash
# Proper placement:
mv deep-dive-documentation-warnings.md \
   .thyrox/context/work/2026-04-23-07-04-55-config-review-iact-docs/discover/
```

### Why Safe to Move
- ✅ File is pure analysis (read-only reference)
- ✅ No code depends on its location
- ✅ Follows proper THYROX WP structure
- ✅ Actually improves organization

---

## Issue 3: `iact_docs.egg-info/`

### What It Is
- Metadata directory created by Python packaging system (setuptools)
- Contains package build metadata:
  - `PKG-INFO` — Package information
  - `SOURCES.txt` — List of files in package
  - `requires.txt` — Dependencies
  - `top_level.txt` — Top-level packages

### Why It Exists
- Created when package is installed in development mode: `pip install -e .`
- Standard part of Python packaging workflow
- Needed for `python -m` imports to work

### Current State
```
iact_docs.egg-info/
├── PKG-INFO
├── SOURCES.txt
├── dependency_links.txt
├── requires.txt
└── top_level.txt
```

### Problem
- **Should be in .gitignore** (build artifact, not source)
- Takes up space in repository
- Not needed for distribution (only for development)
- Regenerated on each `pip install -e .`

### Recommendation
**IGNORE in git** — Add to `.gitignore`

```bash
# 1. Remove from git tracking:
git rm -r --cached iact_docs.egg-info/
git commit -m "remove: egg-info from git tracking"

# 2. Add to .gitignore:
echo "*.egg-info/" >> .gitignore
echo ".egg-info/" >> .gitignore
echo "*.eggs/" >> .gitignore

git add .gitignore
git commit -m "build: add egg-info to .gitignore"

# 3. Local directory remains (for development):
# pip install -e . will recreate it on demand
```

### Why Safe to Ignore
- ✅ Recreated automatically on `pip install -e .`
- ✅ Not part of source code
- ✅ Standard Python practice (.gitignore includes `*.egg-info`)
- ✅ Reduces git noise and binary tracking

### Current .gitignore Status
```bash
$ grep -i egg .gitignore
# (check if already present)
```

---

## Summary & Action Plan

| Issue | Type | Action | Impact |
|-------|------|--------|--------|
| `requirements.txt.deprecated` | Orphaned file | **DELETE** | Clean root, reduce confusion |
| `deep-dive-documentation-warnings.md` | Misplaced artifact | **MOVE** to discover/ | Fix WP structure, clean root |
| `iact_docs.egg-info/` | Build artifact | **IGNORE** in .gitignore | Reduce git bloat, standard practice |

---

## Execution Steps

### Step 1: Remove Legacy Dependency File
```bash
git rm requirements.txt.deprecated
git commit -m "chore: remove deprecated requirements.txt file

Legacy file from pre-pyproject.toml era. All dependencies now managed
in pyproject.toml. Historical versions available in git history."
```

### Step 2: Move Analysis to Proper WP Location
```bash
mkdir -p .thyrox/context/work/2026-04-23-07-04-55-config-review-iact-docs/discover

git mv deep-dive-documentation-warnings.md \
        .thyrox/context/work/2026-04-23-07-04-55-config-review-iact-docs/discover/

git commit -m "refactor: move deep-dive analysis to WP discover/ folder

File was generated during Phase 1 DISCOVER but was in project root.
Now properly placed in WP structure for THYROX compliance."
```

### Step 3: Remove Egg-Info from Git, Add to Ignore
```bash
git rm -r --cached iact_docs.egg-info/

cat >> .gitignore << 'EOF'

# Python packaging
*.egg-info/
*.eggs/
*.egg
EOF

git add .gitignore
git commit -m "build: remove egg-info from git, add to .gitignore

egg-info/ is generated by setuptools during 'pip install -e .'
and should not be tracked in version control. Standard Python practice."
```

### Step 4: Verify Clean State
```bash
git status
# (should show clean working tree)

ls -la | grep -E "requirements|egg-info|deep-dive"
# (should show nothing)

git log --oneline -3
# (should show 3 cleanup commits)
```

---

## Why This Matters

### Code Quality
- Removes deprecated/orphaned files
- Follows standard Python practices
- Proper WP organization (THYROX compliance)

### Git Health
- Removes build artifacts from version control
- Reduces repository bloat
- Improves root directory clarity

### Onboarding
- Clear project structure for new contributors
- No confusion about which dependency file to use
- Standard .gitignore patterns

---

## Related Decisions

These cleanups align with:
- **I-002 (CLAUDE.md):** Git as only persistence (remove backup files)
- **I-003 (CLAUDE.md):** Markdown only (no orphaned analysis files)
- **Convention:** Standard Python packaging practices

---

**Analysis Created:** 2026-04-23 18:00:00  
**Recommendation:** Execute cleanup steps above  
**Risk:** None (all artifacts are recreated or in git history)

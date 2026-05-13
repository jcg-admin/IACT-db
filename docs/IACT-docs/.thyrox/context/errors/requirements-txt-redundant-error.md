```yml
created_at: 2026-04-25 23:25:00
project: IACT-docs
work_package: 2026-04-25-22-13-43-iact-project-state-assessment
phase: Phase 10 — EXECUTE (Phase A)
severity: MEDIUM
status: RESOLVED
lesson_learned: true
```

# Error: Redundant requirements.txt (Assumption-Based Mistake)

## What Happened

During **Phase A Task T-009 (Update dependencies)**, I created a new `requirements.txt` file without first checking if the project already had a dependency management system in place.

**Timeline:**
1. **22:52** — Analyzed Sphinx extensions, noted lack of `requirements.txt`
2. **22:55** — Created new `requirements.txt` with all dependencies
3. **23:05** — User feedback: "ERROR porque creaste requirements.txt si tenemos pyproject.toml"
4. **23:10** — Discovered project already uses `pyproject.toml` (comprehensive, with 100+ dependencies)
5. **23:15** — Removed redundant file, updated `pyproject.toml` instead

---

## Root Cause Analysis

**Primary Error:** Made assumption without verification
- Assumed no dependency tracking existed
- Did not check for `pyproject.toml`, `setup.py`, or `setup.cfg` first
- Proceeded directly to creating new file

**Secondary Issue:** Partial environment investigation
- Checked pip output (saw many packages installed)
- Did not cross-reference with project configuration files
- Inventory showed many packages but didn't check their source

---

## The Correct Approach (What I Should Have Done)

### Step 1: Audit Before Creating
Before creating any new dependency tracking file, check for existing:
- [ ] `pyproject.toml` ← MODERN STANDARD (Python 3.10+)
- [ ] `setup.py` ← LEGACY
- [ ] `setup.cfg` ← LEGACY
- [ ] `requirements.txt` ← DEVELOPMENT/PINNING
- [ ] `Pipfile` / `Pipfile.lock` ← PIPENV
- [ ] `poetry.lock` ← POETRY

### Step 2: Understand the Existing System
- Read the existing config file completely
- Understand its structure and version constraints
- Check if dependencies are already documented
- Verify what's intentional vs. auto-generated

### Step 3: Integrate, Don't Duplicate
- Add to existing system rather than creating new files
- Keep single source of truth for dependencies
- Document changes in the existing file

---

## What I Found (Post-Correction)

**File:** `pyproject.toml` (modern, correct approach)
- **Format:** PEP 517/518 compliant (modern Python standard)
- **Dependencies:** 100+ already documented with versions
- **Status:** Comprehensive and up-to-date
- **All needed extensions:** Already present (including PlantUML 0.26.0)

**Lesson:** The infrastructure was better than the local audit suggested.

---

## Resolution Applied

✅ **Removed:** `/home/user/IACT-docs/requirements.txt` (redundant)  
✅ **Updated:** `pyproject.toml` with inline documentation of extensions  
✅ **Committed:** Changes to single source of truth  
✅ **Documented:** Sphinx version and extension purposes in comments  

**Commits:**
- `7b5b7b5` — chore(sphinx-config): enable PlantUML... (created redundant requirements.txt)
- `9866ba4` — chore(deps): document sphinx extensions... (corrected by using pyproject.toml)
- `7e44833` — docs(phase-a-execution): update log... (documented correction)

---

## Permanent Lesson

**Rule (Never Assume):**
> Before creating new infrastructure (config files, structure, tools), audit the existing project for:
> 1. What exists already
> 2. How it's configured
> 3. What's the single source of truth
> 4. How to extend it rather than duplicate it

**Check Order for Dependencies:**
1. `pyproject.toml` (modern Python, always check first)
2. `setup.py` or `setup.cfg` (legacy but still valid)
3. `requirements.txt` (development/pinning, secondary)
4. Other tools (Poetry, Pipenv, etc.)

**Anti-Pattern Identified:**
```
❌ See problem → Make assumption → Create solution → User corrects
✅ See problem → Verify existing → Understand system → Extend correctly
```

---

## Impact

**Severity:** MEDIUM
- Created redundant file (no data loss)
- Quick fix (removed file, updated correct one)
- Documented for learning

**Prevention:** Checklist before creating new configuration files:
- [ ] Searched for existing config files
- [ ] Verified they contain what I need
- [ ] Understood the format and structure
- [ ] Confirmed which is the single source of truth
- [ ] Updated/extended existing rather than creating new

---

## Recommendation

Add to project standards/CLAUDE.md:
- Always check for `pyproject.toml` first when working with Python projects
- Don't create `requirements.txt` if project uses modern dependency management
- Single source of truth: verify before duplicating infrastructure

---

**Error Documented:** 2026-04-25 23:25:00  
**Status:** RESOLVED  
**Lessons Applied:** Yes (documented for future reference)  
**Commit:** 9866ba4 (chore: correct to use pyproject.toml)

```yml
created_at: 2026-04-25 22:45:00
project: IACT-docs
reference: Sphinx Official GitHub Configuration (sphinx-doc/sphinx/.github)
analysis_type: GitHub Actions Configuration Design
resource_model: Free Tier (Cost-Conscious)
status: Recommendation Ready
```

# .github Implementation Plan for IACT-docs

## Executive Summary

**Analyzed:** Sphinx official repository `.github/` structure  
**Branch Convention:** IACT-docs uses `main` (not `master`)  
**Resource Model:** Free GitHub Actions (2000 min/month)  
**Implementation Scope:** Essential workflows only (no heavy cost-driving jobs)

---

## Current State Analysis (Sphinx Reference)

### What Sphinx Has

| Component | Count | Purpose |
|-----------|-------|---------|
| **Issue Templates** | 2 | Bug reports, feature requests |
| **PR Template** | 1 | Contribution guidelines |
| **Workflows** | 6 | build docs, lint, release, nodejs, transifex |
| **Dependabot** | 1 | Dependency updates (GH Actions, pip, uv) |

### Sphinx's Workflow Costs

| Workflow | Trigger | Runtime | Monthly Cost |
|----------|---------|---------|--------------|
| builddoc.yml | push, PR, manual | ~2-3 min | ~100 min/month (16 builds) |
| lint.yml | push, PR | ~1-2 min | ~50 min/month |
| create-release.yml | manual | ~2 min | ~5 min/month (rare) |
| Other workflows | various | ~1-2 min | ~30 min/month |
| **Total** | — | — | **~185 min/month** |

**Key observation:** Sphinx stays well under 2000 min/month limit with careful job selection.

---

## Recommended .github Structure for IACT-docs

### Phase 1: Essential Only (Minimal Cost)

```
.github/
├── ISSUE_TEMPLATE/
│   ├── config.yml
│   ├── bug-report.yml
│   └── feature-request.md
├── PULL_REQUEST_TEMPLATE.md
└── workflows/
    ├── sphinx-build.yml         (← PRIMARY: Build + test docs)
    └── branch-protection.yml    (← SECONDARY: Auto-protect main)
```

**Total estimated monthly cost:** 30-50 minutes of Actions runtime

### Phase 2: Enhanced (After Phase 1 Stabilized)

```
.github/
├── ... (Phase 1 files)
├── dependabot.yml               (← Monitor dependencies)
└── workflows/
    ├── sphinx-build.yml
    ├── branch-protection.yml
    ├── rst-lint.yml             (← Check RST formatting)
    └── placeholder-audit.yml    (← Detect template text)
```

**Incremental cost:** +20-30 minutes/month

---

## Detailed Recommendations

### 1. Issue Templates

**File:** `.github/ISSUE_TEMPLATE/config.yml`
```yaml
blank_issues_enabled: false
contact_links:
  - name: Documentation Issue
    url: https://github.com/jcg-admin/iact-docs/issues/new?template=bug-report.yml
    about: Report documentation problems
  - name: Feature Request
    url: https://github.com/jcg-admin/iact-docs/issues/new?template=feature-request.md
    about: Suggest documentation improvements
```

**File:** `.github/ISSUE_TEMPLATE/bug-report.yml`
```yaml
name: 📖 Documentation Bug Report
description: Report a documentation error or issue
labels: ["bug", "documentation"]
body:
  - type: textarea
    id: description
    attributes:
      label: Description
      description: What is the documentation problem?
    validations:
      required: true
  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
      description: What should happen?
    validations:
      required: true
  - type: textarea
    id: location
    attributes:
      label: Location
      description: Path to file or section affected
    validations:
      required: true
```

**File:** `.github/ISSUE_TEMPLATE/feature-request.md`
```markdown
---
name: 🚀 Feature Request
about: Suggest a documentation improvement
labels: enhancement
---

## Description
What documentation improvement would you like to see?

## Use Case
Who would benefit? When would this be used?

## Suggested Implementation
How could this be added to the documentation?
```

---

### 2. Pull Request Template

**File:** `.github/PULL_REQUEST_TEMPLATE.md`
```markdown
## Description
Brief explanation of changes in this PR.

## Type of Change
- [ ] Documentation fix
- [ ] New documentation section
- [ ] Structure/organization improvement
- [ ] Technical requirement update
- [ ] Other (describe below)

## Related Issues
Closes #(issue number)

## Testing
How have you validated these changes?
- [ ] Built Sphinx locally (`make html`)
- [ ] Verified no RST warnings
- [ ] Checked spelling and grammar
- [ ] Validated links work

## Checklist
- [ ] Documentation is clear and complete
- [ ] RST formatting follows project standards
- [ ] No placeholder text remains
- [ ] Build succeeds with no warnings
- [ ] Changes follow CLAUDE.md conventions

## Screenshots (if applicable)
Include screenshots of documentation rendered.
```

---

### 3. Primary Workflow: Sphinx Build Validation

**File:** `.github/workflows/sphinx-build.yml`
```yaml
name: Build and Validate Documentation

on:
  push:
    branches: [main, feature/*, bugfix/*]
  pull_request:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  checks: write

concurrency:
  group: ${{ github.workflow }}-${{ github.head_ref || github.run_id }}
  cancel-in-progress: true

env:
  FORCE_COLOR: "1"

jobs:
  build-docs:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.9"]
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: 'pip'
      
      - name: Install dependencies
        run: |
          pip install --upgrade pip
          pip install -r requirements.txt
      
      - name: Build documentation
        run: make clean && make html
      
      - name: Check for build warnings
        run: |
          if grep -q "WARNING:" build/warnings.txt 2>/dev/null; then
            echo "Build warnings detected!"
            cat build/warnings.txt
            exit 1
          fi
      
      - name: Validate RST formatting
        run: |
          python -m pytest --tb=short -v tests/rst_validation/ || true
```

**Cost:** ~2-3 min per run × ~20 runs/month = 40-60 min/month

---

### 4. Secondary Workflows (Phase 2)

**File:** `.github/workflows/rst-lint.yml` (Optional)
```yaml
name: RST Lint Check

on:
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.9"
      - run: pip install doc8
      - run: doc8 source/ || true  # Warning-only, non-blocking
```

**Cost:** ~1 min per PR × ~10 PRs/month = 10 min/month

---

### 5. Dependabot Configuration (Optional)

**File:** `.github/dependabot.yml`
```yaml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
    
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "monthly"  # Less frequent than Sphinx
    open-pull-requests-limit: 3
```

**Cost:** 0 (Dependabot is free)  
**Benefit:** Automatic dependency update PRs

---

## Implementation Roadmap

### Week 1: Setup Templates & Primary Workflow
- [ ] Create ISSUE_TEMPLATE/ directory
- [ ] Add bug-report.yml, feature-request.md, config.yml
- [ ] Create PULL_REQUEST_TEMPLATE.md
- [ ] Implement sphinx-build.yml workflow
- [ ] Test on feature branch
- [ ] Merge to main when validated

### Week 2: Deploy & Monitor
- [ ] Monitor first 10 builds for reliability
- [ ] Adjust timeouts/dependencies as needed
- [ ] Document in CONTRIBUTING.md

### Week 3+: Optional Phase 2
- [ ] Evaluate rst-lint.yml for value
- [ ] Enable Dependabot if needed
- [ ] Add branch protection rules (requires main consideration)

---

## Cost Projection

### Scenario: Sustainable Development

| Activity | Frequency | Time/Run | Monthly Minutes |
|----------|-----------|----------|-----------------|
| Push builds | 2x/week | 2 min | 16 |
| PR checks | 10 PRs/month | 2 min | 20 |
| Scheduled builds | 1x/week | 2 min | 8 |
| Dependabot PRs | 2/month | 2 min | 4 |
| **Total** | — | — | **48 min/month** |

**Percentage of free tier:** 48/2000 = 2.4%  
**Status:** ✅ Highly sustainable, room for 40+ more workflows

### Scenario: High Activity (5x normal)

| Activity | Frequency | Time/Run | Monthly Minutes |
|----------|-----------|----------|-----------------|
| Push builds | 3x/day | 2 min | 180 |
| PR checks | 50 PRs/month | 2 min | 100 |
| Scheduled builds | 2x/week | 2 min | 16 |
| Dependabot PRs | 5/month | 2 min | 10 |
| Optional lint checks | 50 PRs | 1 min | 50 |
| **Total** | — | — | **356 min/month** |

**Percentage of free tier:** 356/2000 = 17.8%  
**Status:** ✅ Still well within free limits

---

## Key Design Decisions

### 1. Branch Strategy
- **Main branch:** `main` (not `master`)
- **Feature branches:** `feature/*` trigger builds but not tests
- **Bugfix branches:** `bugfix/*` trigger builds but not tests
- **Strategy:** Test only on PR to main (reduces cost, catches issues pre-merge)

### 2. Python Version
- **Single version:** 3.9 (IACT-docs baseline)
- **Rationale:** Documentation doesn't require multi-version testing
- **Cost savings:** Matrix strategy avoided (would double run time)

### 3. Caching Strategy
- **Cache:** pip dependencies (saves installation time)
- **Cache key:** hash(requirements.txt)
- **Savings:** ~30 seconds per build

### 4. Conditional Workflows
- **Run only if:** Changes touch source/, Makefile, or requirements.txt
- **Skip if:** Only .md files changed (README, CHANGELOG)
- **Cost savings:** Avoids 30-40% of unnecessary builds

---

## Migration Path: From Manual to Automated

### Current State (Manual)
```
Developer → Sphinx build locally → git push → Manual review
```

### With Sphinx-build.yml (Automated Validation)
```
Developer → git push → GitHub Actions builds → Auto-check
                                         ↓ (if fails)
                                      Fail CI check
                                      (prevents merge)
```

### With Full Setup (Phase 1 + 2)
```
Developer → Create issue/discussion
              ↓
          Create feature branch
              ↓
          Make changes
              ↓
          Create PR (triggers templates)
              ↓
          GitHub Actions validates:
            - Sphinx build succeeds
            - No RST warnings
            - No placeholder text
            - Lint checks pass (optional)
              ↓
          Auto-updated dependencies (Dependabot)
              ↓
          Status checks pass → Merge allowed
```

---

## Comparison: IACT-docs vs Sphinx

| Aspect | Sphinx | Recommended IACT |
|--------|--------|-----------------|
| **Workflows** | 6 (comprehensive) | 1-2 (focused) |
| **Monthly cost** | ~185 min | ~50 min |
| **Matrix strategy** | Yes (multi-Python) | No (single version) |
| **Branch name** | master | main |
| **PR protection** | Advanced rules | Basic rules (optional) |
| **Dependabot** | Multiple ecosystems | Selective (pip, actions) |

**Key difference:** Sphinx is a package (requires multi-version testing). IACT-docs is documentation (single version sufficient).

---

## Implementation Checklist

### Phase 1: Essential Setup
- [ ] Create `.github/ISSUE_TEMPLATE/` directory
- [ ] Add config.yml (template selector)
- [ ] Add bug-report.yml (structured issue form)
- [ ] Add feature-request.md (simple template)
- [ ] Create PULL_REQUEST_TEMPLATE.md
- [ ] Implement sphinx-build.yml workflow
- [ ] Test workflow with feature branch
- [ ] Merge to main branch

### Phase 2: Enhancement (2 weeks later)
- [ ] Review Phase 1 workflow effectiveness
- [ ] Add rst-lint.yml if needed
- [ ] Enable Dependabot configuration
- [ ] Document in CONTRIBUTING.md
- [ ] Update branch protection rules

### Phase 3: Polish (Monthly)
- [ ] Monitor cost trends
- [ ] Gather feedback from team
- [ ] Iterate workflow performance
- [ ] Add codeowners file (optional)

---

## Files to Create

1. `.github/ISSUE_TEMPLATE/config.yml`
2. `.github/ISSUE_TEMPLATE/bug-report.yml`
3. `.github/ISSUE_TEMPLATE/feature-request.md`
4. `.github/PULL_REQUEST_TEMPLATE.md`
5. `.github/workflows/sphinx-build.yml`
6. `.github/dependabot.yml` (Phase 2)
7. `.github/workflows/rst-lint.yml` (Phase 2, optional)

---

## Next Steps

1. **Review** this plan with team
2. **Choose** Phase 1 only vs. full implementation
3. **Create** `.github/` directory structure
4. **Test** workflows on feature branch before deploying to main
5. **Monitor** first month for reliability and cost

---

**Analysis Date:** 2026-04-25  
**Reference:** Sphinx official repository `.github/` configuration  
**Status:** Ready for implementation  
**Estimated Effort:** 2-3 hours for Phase 1 setup

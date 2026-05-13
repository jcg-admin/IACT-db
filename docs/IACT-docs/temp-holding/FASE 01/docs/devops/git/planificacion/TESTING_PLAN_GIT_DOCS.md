---
title: Testing Plan - Git Documentation Reorganization
issue_number: IACT-GIT-DOCS-001
date: 2025-11-13
phase: testing
status: plan_complete
domain: operaciones
---

# Testing Plan: Git Documentation Reorganization

**Issue**: IACT-GIT-DOCS-001
**Phase**: FASE 4 - TESTING
**Date**: 2025-11-13
**Status**: Plan Complete (TDD RED Phase)

---

## 1. Testing Overview

### 1.1 Testing Strategy

This reorganization follows TDD principles adapted for documentation:

**RED Phase** (This document): Define all tests and validation criteria BEFORE implementation
**GREEN Phase** (FASE 5 - Deployment): Implement until all tests pass
**REFACTOR Phase** (Post-deployment): Improve structure while keeping tests green

### 1.2 Testing Scope

**In Scope**:
- Structural correctness (folders, files exist)
- Content compliance (metadata, no emojis)
- Functional validation (links work, YAML valid)
- User experience (discoverability, clarity)

**Out of Scope**:
- Technical accuracy of Git commands (assumed correct from source)
- Grammar and spelling (not critical for structure validation)
- Performance of documentation access (static files, negligible impact)

### 1.3 Test Environment

**Environment**: Local repository clone
**Tools Required**:
- Bash shell
- Python 3.8+ (for YAML validation)
- grep with PCRE support
- Standard Unix tools (find, test, ls)

---

## 2. Test Categories

### 2.1 Structural Tests (Automated)

**Purpose**: Verify folder structure and file locations match design

**Test Cases**: 10 tests
**Expected Pass Rate**: 100%
**Execution Time**: <10 seconds

### 2.2 Content Compliance Tests (Automated)

**Purpose**: Verify files meet content standards (metadata, no emojis)

**Test Cases**: 8 tests
**Expected Pass Rate**: 100%
**Execution Time**: <15 seconds

### 2.3 Functional Tests (Semi-Automated)

**Purpose**: Verify cross-references and navigation work correctly

**Test Cases**: 6 tests
**Expected Pass Rate**: 100%
**Execution Time**: 5-10 minutes (manual verification)

### 2.4 User Experience Tests (Manual)

**Purpose**: Verify usability and discoverability

**Test Cases**: 5 tests
**Expected Pass Rate**: 100%
**Execution Time**: 15-20 minutes (manual walkthrough)

---

## 3. Detailed Test Specifications

### TEST-001: Level 1 Folder Exists

**Category**: Structural
**Type**: Automated
**Priority**: P0 (Critical)

**Test Procedure**:
```bash
test -d docs/devops/git/nivel_1_basico
echo $?  # Expected: 0 (success)
```

**Expected Result**: Folder exists
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-002: Level 2 Folder Exists

**Category**: Structural
**Type**: Automated
**Priority**: P0 (Critical)

**Test Procedure**:
```bash
test -d docs/devops/git/nivel_2_intermedio
echo $?  # Expected: 0 (success)
```

**Expected Result**: Folder exists
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-003: Level 3 Folder Exists

**Category**: Structural
**Type**: Automated
**Priority**: P0 (Critical)

**Test Procedure**:
```bash
test -d docs/devops/git/nivel_3_avanzado
echo $?  # Expected: 0 (success)
```

**Expected Result**: Folder exists
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-004: Planning Folder Exists

**Category**: Structural
**Type**: Automated
**Priority**: P0 (Critical)

**Test Procedure**:
```bash
test -d docs/devops/git/planificacion
echo $?  # Expected: 0 (success)
```

**Expected Result**: Folder exists
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-005: README Exists

**Category**: Structural
**Type**: Automated
**Priority**: P0 (Critical)

**Test Procedure**:
```bash
test -f docs/devops/git/README.md
echo $?  # Expected: 0 (success)
```

**Expected Result**: File exists at correct location
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-006: Level 1 Guide Exists

**Category**: Structural
**Type**: Automated
**Priority**: P0 (Critical)

**Test Procedure**:
```bash
test -f docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
echo $?  # Expected: 0 (success)
```

**Expected Result**: File exists in Level 1 folder
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-007: Level 2 Guide Exists

**Category**: Structural
**Type**: Automated
**Priority**: P0 (Critical)

**Test Procedure**:
```bash
test -f docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
echo $?  # Expected: 0 (success)
```

**Expected Result**: File exists in Level 2 folder
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-008: Level 3 Guide Exists

**Category**: Structural
**Type**: Automated
**Priority**: P0 (Critical)

**Test Procedure**:
```bash
test -f docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md
echo $?  # Expected: 0 (success)
```

**Expected Result**: File exists in Level 3 folder
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-009: No Files in Wrong Locations

**Category**: Structural
**Type**: Automated
**Priority**: P1 (High)

**Test Procedure**:
```bash
# Check no guide files left in old location
ls docs/operaciones/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md 2>/dev/null
echo $?  # Expected: 2 (file not found)

ls docs/operaciones/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md 2>/dev/null
echo $?  # Expected: 2 (file not found)
```

**Expected Result**: Old files have been moved (not found in original location)
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-010: All SDLC Docs Present

**Category**: Structural
**Type**: Automated
**Priority**: P1 (High)

**Test Procedure**:
```bash
test -f docs/devops/git/planificacion/ISSUE_GIT_DOCS_REORGANIZATION.md && \
test -f docs/devops/git/planificacion/FEASIBILITY_ANALYSIS_GIT_DOCS.md && \
test -f docs/devops/git/planificacion/HLD_GIT_DOCS_REORGANIZATION.md && \
test -f docs/devops/git/planificacion/LLD_GIT_DOCS_REORGANIZATION.md && \
test -f docs/devops/git/planificacion/TESTING_PLAN_GIT_DOCS.md
echo $?  # Expected: 0 (all exist)
```

**Expected Result**: All 5 SDLC documents present in planificacion/
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-011: No Emojis in README

**Category**: Content Compliance
**Type**: Automated
**Priority**: P0 (Critical - User Requirement)

**Test Procedure**:
```bash
grep -P "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" docs/devops/git/README.md
echo $?  # Expected: 1 (no matches)
```

**Expected Result**: Zero emoji characters found
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-012: No Emojis in Level 1 Guide

**Category**: Content Compliance
**Type**: Automated
**Priority**: P0 (Critical - User Requirement)

**Test Procedure**:
```bash
grep -P "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
echo $?  # Expected: 1 (no matches)
```

**Expected Result**: Zero emoji characters found
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-013: No Emojis in Level 2 Guide

**Category**: Content Compliance
**Type**: Automated
**Priority**: P0 (Critical - User Requirement)

**Test Procedure**:
```bash
grep -P "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
echo $?  # Expected: 1 (no matches)
```

**Expected Result**: Zero emoji characters found
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-014: No Emojis in Level 3 Guide

**Category**: Content Compliance
**Type**: Automated
**Priority**: P0 (Critical - User Requirement)

**Test Procedure**:
```bash
grep -P "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md
echo $?  # Expected: 1 (no matches)
```

**Expected Result**: Zero emoji characters found
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-015: README Has Valid YAML

**Category**: Content Compliance
**Type**: Automated
**Priority**: P0 (Critical)

**Test Procedure**:
```bash
python3 -c "import yaml; yaml.safe_load(open('docs/devops/git/README.md').read().split('---')[1])"
echo $?  # Expected: 0 (success)
```

**Expected Result**: YAML frontmatter parses without errors
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-016: Level 1 Guide Has Valid YAML

**Category**: Content Compliance
**Type**: Automated
**Priority**: P0 (Critical)

**Test Procedure**:
```bash
python3 -c "import yaml; yaml.safe_load(open('docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md').read().split('---')[1])"
echo $?  # Expected: 0 (success)
```

**Expected Result**: YAML frontmatter parses without errors
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-017: Level 2 Guide Has Valid YAML

**Category**: Content Compliance
**Type**: Automated
**Priority**: P0 (Critical)

**Test Procedure**:
```bash
python3 -c "import yaml; yaml.safe_load(open('docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md').read().split('---')[1])"
echo $?  # Expected: 0 (success)
```

**Expected Result**: YAML frontmatter parses without errors
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-018: Level 3 Guide Has Valid YAML

**Category**: Content Compliance
**Type**: Automated
**Priority**: P0 (Critical)

**Test Procedure**:
```bash
python3 -c "import yaml; yaml.safe_load(open('docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md').read().split('---')[1])"
echo $?  # Expected: 0 (success)
```

**Expected Result**: YAML frontmatter parses without errors
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-019: All Guides Have Required Metadata Fields

**Category**: Content Compliance
**Type**: Automated
**Priority**: P1 (High)

**Test Procedure**:
```python
import yaml

required_fields = ['title', 'date', 'level', 'domain', 'prerequisites', 'estimated_time', 'status']
guides = [
    'docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md',
    'docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md',
    'docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md'
]

for guide in guides:
    content = open(guide).read()
    metadata = yaml.safe_load(content.split('---')[1])
    missing = [f for f in required_fields if f not in metadata]
    if missing:
        print(f"FAIL: {guide} missing fields: {missing}")
    else:
        print(f"PASS: {guide}")
```

**Expected Result**: All guides have all required metadata fields
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-020: README to Level 1 Link Works

**Category**: Functional
**Type**: Manual
**Priority**: P0 (Critical)

**Test Procedure**:
1. Open docs/devops/git/README.md in text editor or GitHub
2. Find link to Level 1 guide (in "Inicio Rapido" or "Roadmap")
3. Verify link format: `[text](nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md)`
4. Click/follow link
5. Verify destination file opens correctly

**Expected Result**: Link works, navigates to Level 1 guide
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-021: README to Level 2 Link Works

**Category**: Functional
**Type**: Manual
**Priority**: P0 (Critical)

**Test Procedure**:
1. Open docs/devops/git/README.md
2. Find link to Level 2 guide (in "Roadmap" or "Decision Matrix")
3. Verify link format: `[text](nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md)`
4. Click/follow link
5. Verify destination file opens correctly

**Expected Result**: Link works, navigates to Level 2 guide
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-022: README to Level 3 Link Works

**Category**: Functional
**Type**: Manual
**Priority**: P0 (Critical)

**Test Procedure**:
1. Open docs/devops/git/README.md
2. Find link to Level 3 guide (in "Roadmap" or "Decision Matrix")
3. Verify link format: `[text](nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md)`
4. Click/follow link
5. Verify destination file opens correctly

**Expected Result**: Link works, navigates to Level 3 guide
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-023: Level 1 to Level 2 Cross-Reference Works

**Category**: Functional
**Type**: Manual
**Priority**: P1 (High)

**Test Procedure**:
1. Open docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
2. Find cross-reference to Level 2 (search for "FLUJO_SYNC_DEVELOP")
3. Verify link format: `../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md`
4. Click/follow link
5. Verify destination file opens correctly

**Expected Result**: Link works, navigates to Level 2 guide
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-024: Level 1 to Level 3 Cross-Reference Works

**Category**: Functional
**Type**: Manual
**Priority**: P1 (High)

**Test Procedure**:
1. Open docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
2. Find cross-reference to Level 3 (search for "MERGE_STRATEGY")
3. Verify link format: `../nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md`
4. Click/follow link
5. Verify destination file opens correctly

**Expected Result**: Link works, navigates to Level 3 guide
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-025: Level 2 to Level 3 Cross-Reference Works

**Category**: Functional
**Type**: Manual
**Priority**: P1 (High)

**Test Procedure**:
1. Open docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
2. Find cross-reference to Level 3 (search for "MERGE_STRATEGY" or "Casos Especiales")
3. Verify link format: `../nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md`
4. Click/follow link
5. Verify destination file opens correctly

**Expected Result**: Link works, navigates to Level 3 guide
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-026: New Developer Can Find Basic Guide

**Category**: User Experience
**Type**: Manual
**Priority**: P0 (Critical)

**Test Scenario**:
- **Actor**: New developer (0-6 months Git experience)
- **Goal**: Find basic guide to start learning
- **Starting Point**: docs/devops/git/README.md

**Test Procedure**:
1. Open README.md
2. Time how long to identify "Inicio Rapido" or "Nivel 1 - Basico" section
3. Verify clear pointer to GIT_GITHUB_GUIA_INICIO.md
4. Verify time is < 2 minutes

**Expected Result**: Developer finds Level 1 guide in < 2 minutes
**Actual Result**: [To be filled during execution]
**Time Taken**: [To be measured]
**Status**: [PASS/FAIL]

---

### TEST-027: Developer with Long Branch Finds Sync Guide

**Category**: User Experience
**Type**: Manual
**Priority**: P0 (Critical)

**Test Scenario**:
- **Actor**: Developer with 3+ day feature branch
- **Goal**: Find guide on syncing with develop
- **Starting Point**: docs/devops/git/README.md

**Test Procedure**:
1. Open README.md
2. Go to "Matriz de Decisiones" section
3. Find row "Mi feature branch tiene > 3 dias"
4. Verify link points to FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
5. Verify time to find is < 1 minute

**Expected Result**: Developer finds sync guide via decision matrix in < 1 minute
**Actual Result**: [To be filled during execution]
**Time Taken**: [To be measured]
**Status**: [PASS/FAIL]

---

### TEST-028: Developer with Merge Error Finds Advanced Guide

**Category**: User Experience
**Type**: Manual
**Priority**: P0 (Critical)

**Test Scenario**:
- **Actor**: Developer encountering "no merge base" error
- **Goal**: Find guide for this specific error
- **Starting Point**: docs/devops/git/README.md

**Test Procedure**:
1. Open README.md
2. Go to "Matriz de Decisiones" section
3. Find row 'Error "fatal: no merge base"'
4. Verify link points to MERGE_STRATEGY_NO_COMMON_ANCESTOR.md
5. Verify time to find is < 1 minute

**Expected Result**: Developer finds advanced strategy guide via decision matrix in < 1 minute
**Actual Result**: [To be filled during execution]
**Time Taken**: [To be measured]
**Status**: [PASS/FAIL]

---

### TEST-029: README Decision Matrix Covers Common Scenarios

**Category**: User Experience
**Type**: Manual
**Priority**: P1 (High)

**Test Procedure**:
1. Open README.md
2. Read "Matriz de Decisiones" section
3. Verify matrix includes at least:
   - New to Git (-> Level 1)
   - Create new branch (-> Level 1)
   - Long branch sync (-> Level 2)
   - Complex conflicts (-> Level 2)
   - No merge base error (-> Level 3)
   - Unsure/fallback (-> Level 1)
4. Count total rows (target: 6-8)

**Expected Result**: Decision matrix covers 6-8 common scenarios including all 3 levels
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

### TEST-030: All Guides Have Success Criteria

**Category**: User Experience
**Type**: Manual
**Priority**: P1 (High)

**Test Procedure**:
1. Open docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
2. Search for "Criterio de Exito" section
3. Verify section exists with checklist items
4. Repeat for Level 2 and Level 3 guides

**Expected Result**: All 3 guides have "Criterio de Exito" section with measurable outcomes
**Actual Result**: [To be filled during execution]
**Status**: [PASS/FAIL]

---

## 4. Test Execution Plan

### 4.1 Test Execution Order

**Phase 1: Structural Tests** (TEST-001 to TEST-010)
- Run all automated structure tests
- MUST pass 100% before proceeding
- If any fail: fix folder/file structure immediately

**Phase 2: Content Compliance Tests** (TEST-011 to TEST-019)
- Run emoji detection tests
- Run YAML validation tests
- Run metadata completeness check
- MUST pass 100% before proceeding
- If any fail: fix content issues immediately

**Phase 3: Functional Tests** (TEST-020 to TEST-025)
- Manually verify all links work
- Check cross-references navigate correctly
- MUST pass 100% before proceeding
- If any fail: fix link paths

**Phase 4: User Experience Tests** (TEST-026 to TEST-030)
- Perform user scenario walkthroughs
- Verify discoverability and usability
- Target: 100%, accept: 80% (can iterate post-deployment)
- If critical fails: address before deployment

### 4.2 Test Automation Script

Create `docs/devops/git/planificacion/validate-git-docs.sh`:

```bash
#!/bin/bash

# Git Documentation Validation Script
# Tests 001-019 (Automated tests only)

echo "========================================="
echo "Git Documentation Validation"
echo "========================================="

PASS_COUNT=0
FAIL_COUNT=0

# Helper function
test_pass() {
    echo "✓ TEST-$1: PASS - $2"
    ((PASS_COUNT++))
}

test_fail() {
    echo "✗ TEST-$1: FAIL - $2"
    ((FAIL_COUNT++))
}

# Structural Tests (001-010)
echo ""
echo "PHASE 1: Structural Tests"
echo "-----------------------------------------"

# TEST-001
if [ -d "docs/devops/git/nivel_1_basico" ]; then
    test_pass "001" "Level 1 folder exists"
else
    test_fail "001" "Level 1 folder missing"
fi

# TEST-002
if [ -d "docs/devops/git/nivel_2_intermedio" ]; then
    test_pass "002" "Level 2 folder exists"
else
    test_fail "002" "Level 2 folder missing"
fi

# TEST-003
if [ -d "docs/devops/git/nivel_3_avanzado" ]; then
    test_pass "003" "Level 3 folder exists"
else
    test_fail "003" "Level 3 folder missing"
fi

# TEST-004
if [ -d "docs/devops/git/planificacion" ]; then
    test_pass "004" "Planning folder exists"
else
    test_fail "004" "Planning folder missing"
fi

# TEST-005
if [ -f "docs/devops/git/README.md" ]; then
    test_pass "005" "README exists"
else
    test_fail "005" "README missing"
fi

# TEST-006
if [ -f "docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md" ]; then
    test_pass "006" "Level 1 guide exists"
else
    test_fail "006" "Level 1 guide missing"
fi

# TEST-007
if [ -f "docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md" ]; then
    test_pass "007" "Level 2 guide exists"
else
    test_fail "007" "Level 2 guide missing"
fi

# TEST-008
if [ -f "docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md" ]; then
    test_pass "008" "Level 3 guide exists"
else
    test_fail "008" "Level 3 guide missing"
fi

# TEST-009
if [ ! -f "docs/operaciones/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md" ] && [ ! -f "docs/operaciones/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md" ]; then
    test_pass "009" "Old files moved/removed"
else
    test_fail "009" "Old files still present"
fi

# TEST-010
if [ -f "docs/devops/git/planificacion/ISSUE_GIT_DOCS_REORGANIZATION.md" ] && \
   [ -f "docs/devops/git/planificacion/FEASIBILITY_ANALYSIS_GIT_DOCS.md" ] && \
   [ -f "docs/devops/git/planificacion/HLD_GIT_DOCS_REORGANIZATION.md" ] && \
   [ -f "docs/devops/git/planificacion/LLD_GIT_DOCS_REORGANIZATION.md" ] && \
   [ -f "docs/devops/git/planificacion/TESTING_PLAN_GIT_DOCS.md" ]; then
    test_pass "010" "All SDLC docs present"
else
    test_fail "010" "Some SDLC docs missing"
fi

# Content Compliance Tests (011-018)
echo ""
echo "PHASE 2: Content Compliance Tests"
echo "-----------------------------------------"

EMOJI_REGEX="[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]"

# TEST-011
if ! grep -qP "$EMOJI_REGEX" docs/devops/git/README.md 2>/dev/null; then
    test_pass "011" "No emojis in README"
else
    test_fail "011" "Emojis found in README"
fi

# TEST-012
if ! grep -qP "$EMOJI_REGEX" docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md 2>/dev/null; then
    test_pass "012" "No emojis in Level 1 guide"
else
    test_fail "012" "Emojis found in Level 1 guide"
fi

# TEST-013
if ! grep -qP "$EMOJI_REGEX" docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md 2>/dev/null; then
    test_pass "013" "No emojis in Level 2 guide"
else
    test_fail "013" "Emojis found in Level 2 guide"
fi

# TEST-014
if ! grep -qP "$EMOJI_REGEX" docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md 2>/dev/null; then
    test_pass "014" "No emojis in Level 3 guide"
else
    test_fail "014" "Emojis found in Level 3 guide"
fi

# TEST-015 to 018: YAML validation
for test_num in 015 016 017 018; do
    case $test_num in
        015) file="docs/devops/git/README.md"; name="README" ;;
        016) file="docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md"; name="Level 1" ;;
        017) file="docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md"; name="Level 2" ;;
        018) file="docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md"; name="Level 3" ;;
    esac

    if python3 -c "import yaml; yaml.safe_load(open('$file').read().split('---')[1])" 2>/dev/null; then
        test_pass "$test_num" "Valid YAML in $name"
    else
        test_fail "$test_num" "Invalid YAML in $name"
    fi
done

# Summary
echo ""
echo "========================================="
echo "TEST SUMMARY"
echo "========================================="
echo "Total Tests: $((PASS_COUNT + FAIL_COUNT))"
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"

if [ $FAIL_COUNT -eq 0 ]; then
    echo ""
    echo "STATUS: ALL AUTOMATED TESTS PASSED"
    echo "Next: Run manual tests (TEST-020 to TEST-030)"
    exit 0
else
    echo ""
    echo "STATUS: SOME TESTS FAILED"
    echo "Fix failures before proceeding to deployment"
    exit 1
fi
```

### 4.3 Manual Test Checklist

Create `docs/devops/git/planificacion/manual-test-checklist.md`:

```markdown
# Manual Test Checklist

Execute after automated tests pass.

## Functional Tests (Links)

- [ ] TEST-020: README to Level 1 link works
- [ ] TEST-021: README to Level 2 link works
- [ ] TEST-022: README to Level 3 link works
- [ ] TEST-023: Level 1 to Level 2 cross-ref works
- [ ] TEST-024: Level 1 to Level 3 cross-ref works
- [ ] TEST-025: Level 2 to Level 3 cross-ref works

## User Experience Tests

- [ ] TEST-026: New developer finds basic guide (< 2 min)
- [ ] TEST-027: Developer finds sync guide via matrix (< 1 min)
- [ ] TEST-028: Developer finds advanced guide via matrix (< 1 min)
- [ ] TEST-029: Decision matrix covers 6-8 scenarios
- [ ] TEST-030: All guides have success criteria section

## Notes

[Record any issues or observations here]
```

---

## 5. Acceptance Criteria Validation

**From Planning Phase (ISSUE_GIT_DOCS_REORGANIZATION.md)**:

### AC1: Folder Structure Exists

**Tests**: TEST-001, TEST-002, TEST-003, TEST-004
**Pass Criteria**: All 4 tests pass
**Status**: [To be validated]

### AC2: Guides Properly Categorized

**Tests**: TEST-006, TEST-007, TEST-008, TEST-009
**Pass Criteria**: All 4 tests pass
**Status**: [To be validated]

### AC3: README with Learning Roadmap

**Tests**: TEST-005, TEST-029 (manual check)
**Pass Criteria**: Both tests pass
**Status**: [To be validated]

### AC4: No Emojis in Documentation

**Tests**: TEST-011, TEST-012, TEST-013, TEST-014
**Pass Criteria**: All 4 tests pass (0 emojis found)
**Status**: [To be validated]

### AC5: Cross-References Work

**Tests**: TEST-020 to TEST-025
**Pass Criteria**: All 6 tests pass
**Status**: [To be validated]

### AC6: Consistent Metadata

**Tests**: TEST-015 to TEST-018, TEST-019
**Pass Criteria**: All 5 tests pass
**Status**: [To be validated]

---

## 6. Coverage Requirements

### 6.1 Test Coverage Matrix

| Component | Tests | Coverage |
|-----------|-------|----------|
| Folder Structure | TEST-001 to TEST-004 | 100% (all 4 folders) |
| File Locations | TEST-005 to TEST-010 | 100% (README + 3 guides + SDLC docs) |
| Emoji Compliance | TEST-011 to TEST-014 | 100% (all user-facing docs) |
| YAML Validity | TEST-015 to TEST-018 | 100% (all guides with frontmatter) |
| Metadata Completeness | TEST-019 | 100% (all guides) |
| Cross-References | TEST-020 to TEST-025 | 100% (all documented refs) |
| User Scenarios | TEST-026 to TEST-030 | 3 main personas |

**Overall Coverage**: 100% of defined acceptance criteria

### 6.2 Minimum Pass Rates

**Automated Tests** (TEST-001 to TEST-019): 100% required (19/19)
**Functional Tests** (TEST-020 to TEST-025): 100% required (6/6)
**UX Tests** (TEST-026 to TEST-030): 80% minimum (4/5), 100% target

**Overall Minimum**: 28/30 tests passing (93%)
**Target**: 30/30 tests passing (100%)

---

## 7. Defect Management

### 7.1 Severity Definitions

**P0 - Critical**:
- Blocks deployment
- Examples: Missing folder, emojis present, broken critical links
- Action: Fix immediately before proceeding

**P1 - High**:
- Major functionality impacted
- Examples: Missing metadata field, broken non-critical links
- Action: Fix before deployment

**P2 - Medium**:
- Minor issues, workarounds exist
- Examples: Typo in non-critical section, suboptimal wording
- Action: Fix during deployment or immediately after

**P3 - Low**:
- Cosmetic issues
- Examples: Formatting inconsistency, minor grammar
- Action: Fix in future iteration

### 7.2 Defect Tracking

**For each failed test, document**:
- Test ID
- Actual result (what failed)
- Expected result (what should happen)
- Severity (P0-P3)
- Root cause
- Fix applied
- Re-test result

**Example**:
```
TEST-012: FAIL
Actual: Found 3 emojis in Level 1 guide (lines 45, 67, 89)
Expected: 0 emojis
Severity: P0 (user requirement)
Root Cause: Emojis not removed during integration
Fix: Manually replaced with text (NOTA:, ADVERTENCIA:)
Re-test: PASS
```

---

## 8. Test Reporting

### 8.1 Test Execution Report Template

```markdown
# Test Execution Report

**Date**: [YYYY-MM-DD]
**Tester**: [Name/Agent]
**Test Plan Version**: 1.0

## Summary

- Total Tests: 30
- Passed: [X]
- Failed: [Y]
- Skipped: [Z]
- Pass Rate: [X/30 * 100]%

## Phase Results

### Phase 1: Structural Tests (001-010)
- Passed: [X/10]
- Failed: [Y/10]

### Phase 2: Content Compliance (011-019)
- Passed: [X/9]
- Failed: [Y/9]

### Phase 3: Functional Tests (020-025)
- Passed: [X/6]
- Failed: [Y/6]

### Phase 4: User Experience (026-030)
- Passed: [X/5]
- Failed: [Y/5]

## Failed Tests

[List each failed test with details]

## Defects Found

[List defects with severity]

## Recommendations

[PASS - Ready for deployment]
OR
[FAIL - Fix defects before deployment]
```

---

## 9. Exit Criteria

**Deployment can proceed when**:

1. All P0 tests pass (100%)
2. All P1 tests pass (100%)
3. Automated test script exits with code 0
4. Manual functional tests 100% pass
5. UX tests >= 80% pass (target 100%)
6. All acceptance criteria validated
7. No open P0 or P1 defects

**If exit criteria not met**: Return to FASE 5 (Deployment), fix issues, re-test

---

**Status**: TESTING PLAN COMPLETE (TDD RED)
**Next Phase**: FASE 5 - DEPLOYMENT (TDD GREEN - Implement until tests pass)
**Estimated Implementation Time**: 4-5 hours

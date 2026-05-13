#!/usr/bin/env bash
# test-phase-readiness.sh
# Unit tests para validate-phase-readiness.sh
# Crea fixtures temporales, ejecuta el script, verifica exit code y output.
#
# Uso: bash .claude/skills/thyrox/scripts/tests/test-phase-readiness.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATE_SCRIPT="${SCRIPT_DIR}/../validate-phase-readiness.sh"
WORKSPACE="/tmp/thyrox-test-phase-readiness-$$"

PASS=0
FAIL=0

# ── Helpers ──────────────────────────────────────────────────────────────────

setup() {
    local name="$1"
    local dir="${WORKSPACE}/${name}"
    rm -rf "$dir"
    mkdir -p "$dir/.thyrox/context/work" "$dir/.git"
    echo "ref: refs/heads/main" > "$dir/.git/HEAD"
    echo "$dir"
}

make_wp() {
    local root="$1"
    local wp_name="${2:-2026-04-01-00-00-00-test-feature}"
    local wp_dir="${root}/.thyrox/context/work/${wp_name}"
    mkdir -p "${wp_dir}/analysis"
    echo "$wp_dir"
}

assert_pass() {
    local test_name="$1"
    local exit_code="$2"
    if [ "$exit_code" -eq 0 ]; then
        echo "  [OK] PASS: $test_name"
        PASS=$((PASS + 1))
    else
        echo "  [ERROR] FAIL: $test_name (expected exit 0, got $exit_code)"
        FAIL=$((FAIL + 1))
    fi
}

assert_fail() {
    local test_name="$1"
    local exit_code="$2"
    if [ "$exit_code" -ne 0 ]; then
        echo "  [OK] PASS: $test_name"
        PASS=$((PASS + 1))
    else
        echo "  [ERROR] FAIL: $test_name (expected exit 1, got 0)"
        FAIL=$((FAIL + 1))
    fi
}

run_validator() {
    local root="$1"
    local phase="$2"
    local wp_dir="${3:-}"

    # Run from root so git rev-parse works
    cd "$root"
    local exit_code=0
    if [ -n "$wp_dir" ]; then
        bash "$VALIDATE_SCRIPT" "$phase" "$wp_dir" > /dev/null 2>&1 || exit_code=$?
    else
        bash "$VALIDATE_SCRIPT" "$phase" > /dev/null 2>&1 || exit_code=$?
    fi
    echo "$exit_code"
}

# ── Phase 1 Tests ─────────────────────────────────────────────────────────────

echo ""
echo "=== Phase 1: ANALYZE ==="

# P1-T01: analysis file exists → PASS
root=$(setup "p1-pass")
wp=$(make_wp "$root")
echo "# Analysis" > "${wp}/analysis/test-feature-analysis.md"
echo "# Risk Register" > "${wp}/test-feature-risk-register.md"
code=$(run_validator "$root" 1 "$wp")
assert_pass "P1-T01: analysis + risk register present" "$code"

# P1-T02: no analysis file → FAIL
root=$(setup "p1-no-analysis")
wp=$(make_wp "$root")
echo "# Risk Register" > "${wp}/test-feature-risk-register.md"
# analysis/ dir exists but empty
code=$(run_validator "$root" 1 "$wp")
assert_fail "P1-T02: missing analysis file" "$code"

# P1-T03: analysis has [NEEDS CLARIFICATION] → FAIL
root=$(setup "p1-needs-clarification")
wp=$(make_wp "$root")
echo "# Analysis [NEEDS CLARIFICATION]" > "${wp}/analysis/test-feature-analysis.md"
echo "# Risk Register" > "${wp}/test-feature-risk-register.md"
code=$(run_validator "$root" 1 "$wp")
assert_fail "P1-T03: analysis with [NEEDS CLARIFICATION]" "$code"

# P1-T04: no WP directory → FAIL
root=$(setup "p1-no-wp")
code=$(run_validator "$root" 1)
assert_fail "P1-T04: no work package directory" "$code"

# ── Phase 2 Tests ─────────────────────────────────────────────────────────────

echo ""
echo "=== Phase 2: SOLUTION_STRATEGY ==="

# P2-T01: solution strategy with research + decisions → PASS
root=$(setup "p2-pass")
wp=$(make_wp "$root")
cat > "${wp}/test-feature-solution-strategy.md" << 'EOF'
# Solution Strategy
## Research
Alternatives considered...
## Decisions
Decision 1: use X
EOF
code=$(run_validator "$root" 2 "$wp")
assert_pass "P2-T01: solution strategy complete" "$code"

# P2-T02: no solution-strategy file → FAIL
root=$(setup "p2-no-file")
wp=$(make_wp "$root")
code=$(run_validator "$root" 2 "$wp")
assert_fail "P2-T02: missing solution strategy file" "$code"

# ── Phase 4 Tests ─────────────────────────────────────────────────────────────

echo ""
echo "=== Phase 4: STRUCTURE ==="

# P4-T01: requirements spec, no [NEEDS CLARIFICATION] → PASS
root=$(setup "p4-pass")
wp=$(make_wp "$root")
cat > "${wp}/test-feature-requirements-spec.md" << 'EOF'
# Requirements Specification
## User Stories
R-1: As a user I want...
Acceptance Criteria: Given/When/Then
EOF
code=$(run_validator "$root" 4 "$wp")
assert_pass "P4-T01: clean requirements spec" "$code"

# P4-T02: requirements spec has [NEEDS CLARIFICATION] → FAIL
root=$(setup "p4-needs-clarification")
wp=$(make_wp "$root")
cat > "${wp}/test-feature-requirements-spec.md" << 'EOF'
# Requirements
R-1: [NEEDS CLARIFICATION] how does this work?
EOF
code=$(run_validator "$root" 4 "$wp")
assert_fail "P4-T02: spec with [NEEDS CLARIFICATION]" "$code"

# P4-T03: no requirements spec file → FAIL
root=$(setup "p4-no-spec")
wp=$(make_wp "$root")
code=$(run_validator "$root" 4 "$wp")
assert_fail "P4-T03: missing requirements spec" "$code"

# ── Phase 5 Tests ─────────────────────────────────────────────────────────────

echo ""
echo "=== Phase 5: DECOMPOSE ==="

# P5-T01: task plan with IDs and checkboxes → PASS
root=$(setup "p5-pass")
wp=$(make_wp "$root")
cat > "${wp}/test-feature-task-plan.md" << 'EOF'
# Task Plan
- [ ] [T-001] Setup project structure (R-1)
- [ ] [T-002] Implement feature (R-2)
- [ ] [T-003] Write tests (R-2)
EOF
code=$(run_validator "$root" 5 "$wp")
assert_pass "P5-T01: task plan with IDs + checkboxes" "$code"

# P5-T02: no task plan file → FAIL
root=$(setup "p5-no-plan")
wp=$(make_wp "$root")
code=$(run_validator "$root" 5 "$wp")
assert_fail "P5-T02: missing task plan" "$code"

# ── Phase 6 Tests ─────────────────────────────────────────────────────────────

echo ""
echo "=== Phase 6: EXECUTE ==="

# P6-T01: all tasks [x] + ROADMAP has [x] → PASS
root=$(setup "p6-pass")
wp=$(make_wp "$root")
cat > "${wp}/test-feature-task-plan.md" << 'EOF'
- [x] [T-001] Task one (R-1)
- [x] [T-002] Task two (R-2)
EOF
cat > "${root}/ROADMAP.md" << 'EOF'
# ROADMAP
- [x] Feature completed (2026-04-01)
EOF
code=$(run_validator "$root" 6 "$wp")
assert_pass "P6-T01: all tasks complete" "$code"

# P6-T02: some tasks still [ ] → FAIL
root=$(setup "p6-incomplete")
wp=$(make_wp "$root")
cat > "${wp}/test-feature-task-plan.md" << 'EOF'
- [x] [T-001] Task one (R-1)
- [ ] [T-002] Task two pending (R-2)
EOF
cat > "${root}/ROADMAP.md" << 'EOF'
# ROADMAP
- [x] Feature completed (2026-04-01)
EOF
code=$(run_validator "$root" 6 "$wp")
assert_fail "P6-T02: incomplete tasks" "$code"

# ── Phase 7 Tests ─────────────────────────────────────────────────────────────

echo ""
echo "=== Phase 7: TRACK ==="

# P7-T01: lessons-learned + CHANGELOG with version → PASS
root=$(setup "p7-pass")
wp=$(make_wp "$root")
echo "# Lessons Learned" > "${wp}/test-feature-lessons-learned.md"
cat > "${root}/CHANGELOG.md" << 'EOF'
# Changelog
## [0.5.0] - 2026-04-01
### Added
- New feature
EOF
code=$(run_validator "$root" 7 "$wp")
assert_pass "P7-T01: lessons learned + changelog present" "$code"

# P7-T02: no lessons-learned → FAIL
root=$(setup "p7-no-lessons")
wp=$(make_wp "$root")
cat > "${root}/CHANGELOG.md" << 'EOF'
# Changelog
## [0.5.0] - 2026-04-01
### Added
- New feature
EOF
code=$(run_validator "$root" 7 "$wp")
assert_fail "P7-T02: missing lessons learned" "$code"

# P7-T03: no CHANGELOG → FAIL
root=$(setup "p7-no-changelog")
wp=$(make_wp "$root")
echo "# Lessons" > "${wp}/test-feature-lessons-learned.md"
code=$(run_validator "$root" 7 "$wp")
assert_fail "P7-T03: missing CHANGELOG" "$code"

# ── Cleanup & Summary ────────────────────────────────────────────────────────

rm -rf "$WORKSPACE"

echo ""
echo "============================================"
TOTAL=$((PASS + FAIL))
echo " Results: $PASS/$TOTAL passed"
echo "============================================"
if [ "$FAIL" -eq 0 ]; then
    echo " PASS"
    exit 0
else
    echo " FAIL ($FAIL failures)"
    exit 1
fi

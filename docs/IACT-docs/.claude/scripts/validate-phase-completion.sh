#!/bin/bash
# validate-phase-completion.sh
#
# Validates that a phase/work package is ready for "complete" report.
# This script MUST be executed before any "complete/done/finished" reports.
#
# Exit codes:
#   0 = All validations passed, safe to report completion
#   1 = Validation failed, do NOT report completion
#
# Usage: bash .claude/scripts/validate-phase-completion.sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0

# Helper functions
pass() {
  echo -e "${GREEN}✅${NC} $1"
  ((PASSED++))
}

fail() {
  echo -e "${RED}❌${NC} $1"
  ((FAILED++))
}

warn() {
  echo -e "${YELLOW}⚠️${NC}  $1"
}

info() {
  echo -e "${BLUE}ℹ️${NC}  $1"
}

section() {
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# =============================================================================
# VALIDATION CHECKS
# =============================================================================

section "Phase Completion Validation Checklist"

# Check 1: Working tree clean (no unstaged changes)
info "Check 1/5: Working tree state"
if git diff --quiet; then
  pass "No unstaged changes"
else
  fail "Uncommitted changes detected in working tree"
  echo ""
  echo "Uncommitted changes:"
  git diff --stat
  echo ""
fi

# Check 2: No staged changes (nothing to commit)
info "Check 2/5: Staged changes"
if git diff --cached --quiet; then
  pass "No staged changes pending commit"
else
  fail "Staged changes pending commit"
  echo ""
  echo "Staged changes:"
  git diff --cached --stat
  echo ""
fi

# Check 3: Remote sync status
info "Check 3/5: Remote synchronization"
CURRENT_BRANCH=$(git branch --show-current)
if [ -z "$CURRENT_BRANCH" ]; then
  fail "Could not determine current branch"
else
  LOCAL_SHA=$(git rev-parse HEAD)

  # Fetch latest remote state
  git fetch origin "$CURRENT_BRANCH" &>/dev/null || true

  REMOTE_SHA=$(git rev-parse origin/"$CURRENT_BRANCH" 2>/dev/null || echo "")

  if [ -z "$REMOTE_SHA" ]; then
    warn "Remote branch 'origin/$CURRENT_BRANCH' not found (may be new branch)"
    info "Branch: $CURRENT_BRANCH | Local SHA: ${LOCAL_SHA:0:7}"
  elif [ "$LOCAL_SHA" = "$REMOTE_SHA" ]; then
    pass "All commits pushed to remote (SHA: ${LOCAL_SHA:0:7})"
  else
    fail "Commits not pushed to remote"
    echo "  Local:  $LOCAL_SHA"
    echo "  Remote: $REMOTE_SHA"
    echo ""
    echo "Unpushed commits:"
    git log --oneline origin/"$CURRENT_BRANCH"..HEAD | head -10
    echo ""
  fi
fi

# Check 4: Build validation (if Makefile exists)
info "Check 4/5: Build system"
if [ -f "$PROJECT_ROOT/Makefile" ]; then
  if grep -q "html:" "$PROJECT_ROOT/Makefile" 2>/dev/null; then
    warn "Sphinx build target found, validating..."

    if cd "$PROJECT_ROOT" && make html > /tmp/phase-completion-build.log 2>&1; then
      pass "Sphinx build succeeded (exit 0)"
    else
      fail "Sphinx build failed"
      echo ""
      echo "Build output (last 30 lines):"
      tail -30 /tmp/phase-completion-build.log
      echo ""
    fi
  else
    info "No Sphinx build target in Makefile (skipped)"
  fi
else
  info "No Makefile found (build validation skipped)"
fi

# Check 5: Recent commits
info "Check 5/5: Commit history"
RECENT_COMMITS=$(git log --oneline -3)
if [ -n "$RECENT_COMMITS" ]; then
  pass "Recent commits found"
  echo "$RECENT_COMMITS" | while read -r line; do
    echo "  $line"
  done
else
  warn "No commits found"
fi

# =============================================================================
# SUMMARY
# =============================================================================

section "Validation Summary"

TOTAL=$((PASSED + FAILED))
echo "Checks passed: $PASSED"
echo "Checks failed: $FAILED"
echo "Total:         $TOTAL"
echo ""

if [ $FAILED -eq 0 ]; then
  echo -e "${GREEN}✅ ALL VALIDATIONS PASSED${NC}"
  echo ""
  echo "Status: SAFE TO REPORT COMPLETION"
  echo ""
  echo "Next steps:"
  echo "  1. Report phase as complete"
  echo "  2. Include this validation in your report"
  echo "  3. Verify \`git status\` shows: 'nothing to commit, working tree clean'"
  echo ""
  exit 0
else
  echo -e "${RED}❌ VALIDATION FAILED${NC}"
  echo ""
  echo "Status: DO NOT REPORT COMPLETION YET"
  echo ""
  echo "Required actions:"
  echo "  1. Fix uncommitted changes: git add ."
  echo "  2. Commit changes: git commit -m '...'"
  echo "  3. Push to remote: git push"
  echo "  4. Run this validator again"
  echo ""
  exit 1
fi

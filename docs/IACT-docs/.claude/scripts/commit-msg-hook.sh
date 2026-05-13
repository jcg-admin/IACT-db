#!/usr/bin/env bash
# commit-msg-hook.sh
# Pre-commit hook for conventional commits validation.
#
# Install:
#   cp .claude/skills/thyrox/scripts/commit-msg-hook.sh .git/hooks/commit-msg
#   chmod +x .git/hooks/commit-msg

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(head -1 "$COMMIT_MSG_FILE")

# Conventional commit pattern: type(scope): description
PATTERN="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .+"

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
    echo ""
    echo "ERROR: Commit message does not follow Conventional Commits format."
    echo ""
    echo "  Expected: type(scope): description"
    echo "  Got:      $COMMIT_MSG"
    echo ""
    echo "  Valid types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert"
    echo "  Example:    feat(api): add user authentication endpoint"
    echo ""
    exit 1
fi

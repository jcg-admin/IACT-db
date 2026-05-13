#!/usr/bin/env bash
# run-all-tests.sh
# Ejecuta todos los tests unitarios del framework thyrox.
#
# Uso:
#   bash .claude/skills/thyrox/scripts/tests/run-all-tests.sh
#   bash .claude/skills/thyrox/scripts/tests/run-all-tests.sh test-skill-mapping  # solo uno

set -euo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPECIFIC="${1:-all}"

TOTAL_PASS=0
TOTAL_FAIL=0

run_test() {
    local script="$1"
    local name="$2"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " $name"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local exit_code=0
    bash "$script" || exit_code=$?

    if [ "$exit_code" -eq 0 ]; then
        TOTAL_PASS=$((TOTAL_PASS + 1))
    else
        TOTAL_FAIL=$((TOTAL_FAIL + 1))
    fi
}

echo "╔══════════════════════════════════════════╗"
echo "║     thyrox Unit Tests                 ║"
echo "╚══════════════════════════════════════════╝"

case "$SPECIFIC" in
    all)
        run_test "${TESTS_DIR}/../../../workflow-track/scripts/tests/test-phase-readiness.sh"   "test-phase-readiness"
        run_test "${TESTS_DIR}/test-skill-mapping.sh"     "test-skill-mapping"
        ;;
    test-phase-readiness)
        run_test "${TESTS_DIR}/../../../workflow-track/scripts/tests/test-phase-readiness.sh" "test-phase-readiness"
        ;;
    test-skill-mapping)
        run_test "${TESTS_DIR}/test-skill-mapping.sh" "test-skill-mapping"
        ;;
    *)
        echo "Unknown test: $SPECIFIC"
        echo "Options: all | test-phase-readiness | test-skill-mapping"
        exit 1
        ;;
esac

echo ""
echo "╔══════════════════════════════════════════╗"
TOTAL=$((TOTAL_PASS + TOTAL_FAIL))
echo "║  Test suites: $TOTAL_PASS/$TOTAL passed"
if [ "$TOTAL_FAIL" -eq 0 ]; then
    echo "║  Status: ALL PASS [OK]"
    echo "╚══════════════════════════════════════════╝"
    exit 0
else
    echo "║  Status: $TOTAL_FAIL FAILED [ERROR]"
    echo "╚══════════════════════════════════════════╝"
    exit 1
fi

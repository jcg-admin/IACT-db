#!/bin/bash
# scripts/validate-plantuml.sh
# Pre-build validation for PlantUML diagrams
# Ensures consistency between include paths, config, and HTML references

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$PROJECT_ROOT/source"
CONF_FILE="$SOURCE_DIR/conf.py"

echo "═══════════════════════════════════════════════════════════"
echo "PlantUML Consistency Check"
echo "═══════════════════════════════════════════════════════════"

# Counter for issues found
ISSUES_FOUND=0

# 1. Count PlantUML directives
echo ""
echo "1️⃣  Scanning for PlantUML directives..."
DIRECTIVES=$(find "$SOURCE_DIR" -name "*.rst" -exec grep -c ".. uml::" {} \; 2>/dev/null | awk '{s+=$1} END {print s+0}')
echo "   Found: $DIRECTIVES PlantUML directives"

# 2. Check for custom plantuml_output_dir
echo ""
echo "2️⃣  Checking conf.py configuration..."
if grep -q "plantuml_output_dir\s*=" "$CONF_FILE" 2>/dev/null; then
    echo "   ❌ ERROR: Custom plantuml_output_dir found in conf.py"
    echo "   This causes mismatch between file location and HTML references."
    echo "   Remove it to use sphinxcontrib.plantuml defaults (_images/)"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo "   ✓ No custom plantuml_output_dir (using sphinxcontrib defaults)"
fi

# 3. Check include paths (only in active .. uml:: directives, not in code examples)
echo ""
echo "3️⃣  Verifying PlantUML include paths..."

# Find actual .. uml:: blocks with incorrect include paths
# This is a bit complex because we need to check inside uml blocks, not in .. code-block:: examples
BAD_PATHS=""
find "$SOURCE_DIR" -name "*.rst" -exec grep -l ".. uml::" {} \; 2>/dev/null | while read file; do
    # Extract content between .. uml:: and next directive/blank-line-followed-by-text
    # Check if any !include inside uml blocks is wrong
    awk '/\.\. uml::/{flag=1; next} flag && /^[^ ]/{flag=0} flag && /!include.*_static/{print FILENAME":"NR":"$0}' "$file" | \
    while read line; do
        if ! echo "$line" | grep -q "../../_static"; then
            BAD_PATHS="$BAD_PATHS"$'\n'"$line"
        fi
    done
done

if [ -n "$BAD_PATHS" ]; then
    BAD_COUNT=$(echo "$BAD_PATHS" | grep -c "!include")
    echo "   ❌ ERROR: Found $BAD_COUNT include paths with incorrect depth"
    echo "   All include paths must be: !include ../../_static/plantuml-styles.puml"
    echo ""
    echo "   Files with bad paths:"
    echo "$BAD_PATHS" | grep "!include"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo "   ✓ All include paths use correct depth (../../_static/)"
fi

# 4. Check for @IACT-DIAGRAM metadata
echo ""
echo "4️⃣  Checking @IACT-DIAGRAM metadata..."
UML_BLOCKS=$(find "$SOURCE_DIR" -name "*.rst" -exec grep -c ".. uml::" {} \; 2>/dev/null | awk '{s+=$1} END {print s+0}')
METADATA_BLOCKS=$(find "$SOURCE_DIR" -name "*.rst" -exec grep -c "@IACT-DIAGRAM" {} \; 2>/dev/null | awk '{s+=$1} END {print s+0}')

echo "   PlantUML directives: $UML_BLOCKS"
echo "   @IACT-DIAGRAM metadata: $METADATA_BLOCKS"

# Allow some examples without metadata
EXPECTED_MIN=$((UML_BLOCKS - 5))
if [ "$METADATA_BLOCKS" -lt "$EXPECTED_MIN" ]; then
    echo "   ⚠️  WARNING: Found $((UML_BLOCKS - METADATA_BLOCKS)) diagrams without @IACT-DIAGRAM metadata"
    echo "   (This is OK for documentation examples, but not for actual diagrams)"
else
    echo "   ✓ Metadata coverage acceptable"
fi

# Summary
echo ""
echo "═══════════════════════════════════════════════════════════"
if [ "$ISSUES_FOUND" -eq 0 ]; then
    echo "✅ All PlantUML consistency checks passed!"
    echo "═══════════════════════════════════════════════════════════"
    exit 0
else
    echo "❌ Found $ISSUES_FOUND validation issue(s)"
    echo "═══════════════════════════════════════════════════════════"
    exit 1
fi

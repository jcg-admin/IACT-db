#!/usr/bin/env bash
# validate-missing-md-links.sh
# Valida que no existan referencias .md en backticks sin convertir a markdown links.
# Retorna exit code 0 si todo está correcto, 1 si hay referencias sin convertir.
#
# Diseñado para CI/CD y validación automatizada.
#
# Uso:
#   ./validate-missing-md-links.sh              # Valida desde raíz del repo
#   ./validate-missing-md-links.sh <directorio> # Valida directorio específico

set -euo pipefail

SEARCH_DIR="${1:-$(git rev-parse --show-toplevel 2>/dev/null || echo .)}"

TOTAL_ISSUES=0

while IFS= read -r mdfile; do
    IN_CODE_BLOCK=false

    while IFS= read -r line; do
        content="${line#*:}"

        # Track code blocks
        if [[ "$content" =~ ^\`\`\` ]]; then
            if $IN_CODE_BLOCK; then
                IN_CODE_BLOCK=false
            else
                IN_CODE_BLOCK=true
            fi
            continue
        fi

        $IN_CODE_BLOCK && continue
        [[ "$content" =~ ^[[:space:]]{4,} ]] && continue
        [[ "$content" =~ ^[[:space:]]*# ]] && continue

        if echo "$content" | grep -qoP '`[^`]*\.md`'; then
            matches=$(echo "$content" | grep -oP '`[^`]*\.md`' || true)

            while IFS= read -r match; do
                [ -z "$match" ] && continue

                ref="${match#\`}"
                ref="${ref%\`}"

                [[ "$ref" == *"<"*">"* ]] && continue
                [[ "$ref" == *"*"* ]] && continue
                [[ "$ref" == *"{"*"}"* ]] && continue

                # Skip if the referenced file does not exist (naming examples, patterns)
                file_dir=$(dirname "$mdfile")
                resolved_path="${file_dir}/${ref}"
                [ ! -f "$resolved_path" ] && [ ! -f "${SEARCH_DIR}/${ref}" ] && continue

                if echo "$content" | grep -qP "\]\([^)]*${ref//\//\\/}[^)]*\)"; then
                    continue
                fi
                if echo "$content" | grep -qP "\[${match//\//\\/}\]\("; then
                    continue
                fi

                TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
            done <<< "$matches"
        fi
    done < <(grep -n '' "$mdfile")
done < <(find "$SEARCH_DIR" -name '*.md' -not -path '*/.git/*' -not -path '*/node_modules/*' | sort)

if [ "$TOTAL_ISSUES" -eq 0 ]; then
    echo "PASS: All .md references are proper markdown links"
    exit 0
else
    echo "FAIL: ${TOTAL_ISSUES} .md references in backticks need conversion"
    echo "Run detect-missing-md-links.sh to see details"
    echo "Run convert-missing-md-links.sh to fix automatically"
    exit 1
fi

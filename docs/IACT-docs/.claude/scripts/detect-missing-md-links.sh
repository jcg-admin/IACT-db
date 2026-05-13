#!/usr/bin/env bash
# detect-missing-md-links.sh
# Detecta referencias a archivos .md en documentación que NO son relative links de Markdown.
#
# Busca patrones como:
#   `archivo.md`           → debería ser [archivo](./archivo.md)
#   `ruta/archivo.md`      → debería ser [archivo](ruta/archivo.md)
#   **`ruta/archivo.md`**  → debería ser [archivo](ruta/archivo.md)
#
# Excluye:
#   - Referencias que ya son links: [texto](ruta.md)
#   - Líneas dentro de bloques de código (```)
#   - Patrones genéricos como <feature-name>.md o *.md
#   - Líneas de comentario de YAML/code

set -euo pipefail

SEARCH_DIR="${1:-$(git rev-parse --show-toplevel 2>/dev/null || echo .)}"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

echo -e "${BOLD}============================================${NC}"
echo -e "${BOLD} Detector de .md sin relative links${NC}"
echo -e "${BOLD}============================================${NC}"
echo -e "Directorio: ${CYAN}${SEARCH_DIR}${NC}"
echo ""

TOTAL_ISSUES=0
TOTAL_FILES=0

# Find all .md files
while IFS= read -r mdfile; do
    IN_CODE_BLOCK=false
    FILE_ISSUES=0
    FILE_OUTPUT=""

    while IFS= read -r line; do
        lineno="${line%%:*}"
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

        # Skip lines inside code blocks
        $IN_CODE_BLOCK && continue

        # Skip lines that are pure code examples (indented 4+ spaces or tab)
        [[ "$content" =~ ^[[:space:]]{4,} ]] && continue

        # Skip YAML frontmatter lines
        [[ "$content" =~ ^[[:space:]]*# ]] && continue

        # Match backtick-wrapped .md references: `something.md` or `path/something.md`
        # But NOT if already inside a markdown link [...](...md)
        # Use grep to find backtick-wrapped .md refs
        if echo "$content" | grep -qoP '`[^`]*\.md`'; then
            # Extract all backtick .md references
            matches=$(echo "$content" | grep -oP '`[^`]*\.md`' || true)

            while IFS= read -r match; do
                [ -z "$match" ] && continue

                # Strip backticks
                ref="${match#\`}"
                ref="${ref%\`}"

                # Skip generic/template patterns
                [[ "$ref" == *"<"*">"* ]] && continue
                [[ "$ref" == *"*"* ]] && continue
                [[ "$ref" == *"{"*"}"* ]] && continue
                [[ "$ref" == *"["* ]] && continue

                # Skip if the referenced file does not exist (naming examples, patterns)
                file_dir=$(dirname "$mdfile")
                resolved_path="${file_dir}/${ref}"
                [ ! -f "$resolved_path" ] && [ ! -f "${SEARCH_DIR}/${ref}" ] && continue

                # Skip if this exact ref is already part of a markdown link on this line
                # e.g., [text](ref.md) - the ref appears after ](
                if echo "$content" | grep -qP "\]\([^)]*${ref//\//\\/}[^)]*\)"; then
                    continue
                fi

                # Check if the backtick ref is the target of a markdown link
                # Pattern: [`ref.md`](path) - already a link
                if echo "$content" | grep -qP "\[${match//\//\\/}\]\("; then
                    continue
                fi

                # This is a .md reference NOT in a markdown link
                FILE_ISSUES=$((FILE_ISSUES + 1))

                # Calculate suggestion: what the link should look like
                basename_ref=$(basename "$ref")
                name_no_ext="${basename_ref%.md}"

                FILE_OUTPUT+="  ${CYAN}${lineno}:${NC} ${match} → ${GREEN}[${name_no_ext}](${ref})${NC}\n"
                FILE_OUTPUT+="  ${DIM}${content}${NC}\n\n"
            done <<< "$matches"
        fi
    done < <(grep -n '' "$mdfile")

    if [ "$FILE_ISSUES" -gt 0 ]; then
        TOTAL_FILES=$((TOTAL_FILES + 1))
        TOTAL_ISSUES=$((TOTAL_ISSUES + FILE_ISSUES))
        rel_path="${mdfile#$SEARCH_DIR/}"
        echo -e "${GREEN}${rel_path}${NC} ${BOLD}(${FILE_ISSUES} referencias sin link)${NC}"
        echo -e "$FILE_OUTPUT"
    fi
done < <(find "$SEARCH_DIR" -name '*.md' -not -path '*/.git/*' -not -path '*/node_modules/*' | sort)

echo -e "${BOLD}============================================${NC}"
echo -e "${BOLD} Total: ${RED}${TOTAL_ISSUES}${NC}${BOLD} referencias sin link en ${TOTAL_FILES} archivos${NC}"
echo -e "${BOLD}============================================${NC}"

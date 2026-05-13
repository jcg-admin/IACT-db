#!/usr/bin/env bash
# convert-missing-md-links.sh
# Convierte referencias .md en backticks a markdown links relativos.
#
# Transforma:
#   `archivo.md`           → [archivo](./archivo.md)
#   `ruta/archivo.md`      → [archivo](ruta/archivo.md)
#   **`ruta/archivo.md`**  → **[archivo](ruta/archivo.md)**
#
# Excluye:
#   - Referencias que ya son links: [texto](ruta.md)
#   - Líneas dentro de bloques de código (```)
#   - Patrones genéricos como <feature-name>.md o *.md
#
# Uso:
#   ./convert-missing-md-links.sh              # Convierte desde raíz del repo
#   ./convert-missing-md-links.sh <directorio> # Convierte en directorio específico
#   ./convert-missing-md-links.sh --dry-run    # Muestra cambios sin aplicar

set -euo pipefail

DRY_RUN=false
SEARCH_DIR=""

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        *) SEARCH_DIR="$arg" ;;
    esac
done

SEARCH_DIR="${SEARCH_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || echo .)}"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

if $DRY_RUN; then
    echo -e "${BOLD}============================================${NC}"
    echo -e "${BOLD} Conversor de .md (DRY RUN)${NC}"
    echo -e "${BOLD}============================================${NC}"
else
    echo -e "${BOLD}============================================${NC}"
    echo -e "${BOLD} Conversor de .md a relative links${NC}"
    echo -e "${BOLD}============================================${NC}"
fi
echo -e "Directorio: ${CYAN}${SEARCH_DIR}${NC}"
echo ""

TOTAL_CONVERTED=0
TOTAL_FILES=0

while IFS= read -r mdfile; do
    IN_CODE_BLOCK=false
    FILE_CHANGES=0
    TMPFILE=$(mktemp)
    MODIFIED=false

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
            echo "$content" >> "$TMPFILE"
            continue
        fi

        # Pass through lines inside code blocks
        if $IN_CODE_BLOCK; then
            echo "$content" >> "$TMPFILE"
            continue
        fi

        # Pass through indented lines
        if [[ "$content" =~ ^[[:space:]]{4,} ]]; then
            echo "$content" >> "$TMPFILE"
            continue
        fi

        # Pass through YAML/comment lines
        if [[ "$content" =~ ^[[:space:]]*# ]]; then
            echo "$content" >> "$TMPFILE"
            continue
        fi

        new_content="$content"

        # Find backtick-wrapped .md references
        if echo "$content" | grep -qoP '`[^`]*\.md`'; then
            matches=$(echo "$content" | grep -oP '`[^`]*\.md`' || true)

            while IFS= read -r match; do
                [ -z "$match" ] && continue

                ref="${match#\`}"
                ref="${ref%\`}"

                # Skip generic patterns
                [[ "$ref" == *"<"*">"* ]] && continue
                [[ "$ref" == *"*"* ]] && continue
                [[ "$ref" == *"{"*"}"* ]] && continue
                [[ "$ref" == *"["* ]] && continue

                # Skip if the referenced file does not exist (naming examples, patterns)
                file_dir=$(dirname "$mdfile")
                resolved_path="${file_dir}/${ref}"
                [ ! -f "$resolved_path" ] && [ ! -f "${SEARCH_DIR}/${ref}" ] && continue

                # Skip if already part of a markdown link
                if echo "$new_content" | grep -qP "\]\([^)]*${ref//\//\\/}[^)]*\)"; then
                    continue
                fi
                if echo "$new_content" | grep -qP "\[${match//\//\\/}\]\("; then
                    continue
                fi

                # Convert: `path/file.md` → [file](path/file.md)
                basename_ref=$(basename "$ref")
                name_no_ext="${basename_ref%.md}"
                link="[${name_no_ext}](${ref})"

                # Replace in content (first occurrence of this match)
                new_content="${new_content/$match/$link}"
                FILE_CHANGES=$((FILE_CHANGES + 1))

                if $DRY_RUN; then
                    rel_path="${mdfile#$SEARCH_DIR/}"
                    echo -e "  ${CYAN}${rel_path}:${lineno}${NC} ${match} → ${GREEN}${link}${NC}"
                fi
            done <<< "$matches"

            MODIFIED=true
        fi

        echo "$new_content" >> "$TMPFILE"
    done < <(grep -n '' "$mdfile")

    if [ "$FILE_CHANGES" -gt 0 ]; then
        TOTAL_FILES=$((TOTAL_FILES + 1))
        TOTAL_CONVERTED=$((TOTAL_CONVERTED + FILE_CHANGES))

        if ! $DRY_RUN; then
            cp "$TMPFILE" "$mdfile"
            rel_path="${mdfile#$SEARCH_DIR/}"
            echo -e "  ${GREEN}${rel_path}${NC} (${FILE_CHANGES} convertidos)"
        fi
    fi

    rm -f "$TMPFILE"
done < <(find "$SEARCH_DIR" -name '*.md' -not -path '*/.git/*' -not -path '*/node_modules/*' | sort)

echo ""
echo -e "${BOLD}============================================${NC}"
if $DRY_RUN; then
    echo -e "${BOLD} DRY RUN: ${YELLOW}${TOTAL_CONVERTED}${NC}${BOLD} conversiones en ${TOTAL_FILES} archivos${NC}"
elif [ "$TOTAL_CONVERTED" -eq 0 ]; then
    echo -e "${BOLD} Total: ${GREEN}0${NC}${BOLD} referencias sin link en 0 archivos${NC}"
else
    echo -e "${BOLD} Convertidos: ${GREEN}${TOTAL_CONVERTED}${NC}${BOLD} en ${TOTAL_FILES} archivos${NC}"
fi
echo -e "${BOLD}============================================${NC}"

#!/usr/bin/env bash
# _generator.sh — Instancia tech skill templates desde el registry
# Uso: _generator.sh <layer> <framework> [project_name] [--force] [--dry-run]
set -euo pipefail

# ── Colores ────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

# ── Paths ──────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY_DIR="$SCRIPT_DIR"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS_DIR="$PROJECT_ROOT/.claude/skills"
GUIDELINES_DIR="$PROJECT_ROOT/.thyrox/guidelines"

# ── Ayuda ──────────────────────────────────────────────────────────────────
usage() {
    echo "Uso: _generator.sh <layer> <framework> [project_name] [--force] [--dry-run]"
    echo ""
    echo "Argumentos:"
    echo "  layer        Capa tecnológica (frontend, backend, db, infra, mobile, testing)"
    echo "  framework    Framework específico (react, nodejs, postgresql, etc.)"
    echo "  project_name Nombre del proyecto (opcional, default: nombre del directorio actual)"
    echo ""
    echo "Flags:"
    echo "  --force      Sobreescribir archivos existentes"
    echo "  --dry-run    Mostrar qué se generaría sin crear archivos"
    echo ""
    echo "Templates disponibles:"
    find "$REGISTRY_DIR" -name "*.template.md" 2>/dev/null | \
        sed "s|$REGISTRY_DIR/||; s|\.template\.md||" | sort | \
        while read -r t; do echo "  $t"; done
    exit 0
}

# ── Parseo de argumentos ───────────────────────────────────────────────────
LAYER=""
FRAMEWORK=""
PROJECT_NAME=""
FORCE=false
DRY_RUN=false

for arg in "$@"; do
    case "$arg" in
        --force)    FORCE=true ;;
        --dry-run)  DRY_RUN=true ;;
        --help|-h)  usage ;;
        *)
            if [ -z "$LAYER" ]; then LAYER="$arg"
            elif [ -z "$FRAMEWORK" ]; then FRAMEWORK="$arg"
            elif [ -z "$PROJECT_NAME" ]; then PROJECT_NAME="$arg"
            fi
            ;;
    esac
done

[ -z "$LAYER" ] || [ -z "$FRAMEWORK" ] && usage

# ── Valores derivados ──────────────────────────────────────────────────────
[ -z "$PROJECT_NAME" ] && PROJECT_NAME="$(basename "$PROJECT_ROOT")"
SKILL_NAME="${LAYER}-${FRAMEWORK}"
TEMPLATE_PATH="$REGISTRY_DIR/${LAYER}/${FRAMEWORK}.template.md"
SKILL_DIR="$SKILLS_DIR/$SKILL_NAME"
SKILL_FILE="$SKILL_DIR/SKILL.md"
INSTRUCTIONS_FILE="$GUIDELINES_DIR/${SKILL_NAME}.instructions.md"
LAYER_TITLE="$(echo "$LAYER" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')"
FRAMEWORK_TITLE="$(echo "$FRAMEWORK" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')"

# Overrides para títulos con formato especial
case "$LAYER" in
  db)     LAYER_TITLE="DB" ;;
  infra)  LAYER_TITLE="Infra" ;;
esac
case "$FRAMEWORK" in
  nodejs)      FRAMEWORK_TITLE="Node.js" ;;
  nextjs)      FRAMEWORK_TITLE="Next.js" ;;
  reactnative) FRAMEWORK_TITLE="React Native" ;;
  postgresql)  FRAMEWORK_TITLE="PostgreSQL" ;;
  mongodb)     FRAMEWORK_TITLE="MongoDB" ;;
  mysql)       FRAMEWORK_TITLE="MySQL" ;;
  kubernetes)  FRAMEWORK_TITLE="Kubernetes" ;;
esac

# ── Validaciones ───────────────────────────────────────────────────────────
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo -e "${RED}ERROR: Template not found: registry/${LAYER}/${FRAMEWORK}.template.md${NC}" >&2
    echo "Ejecuta '_generator.sh --help' para ver templates disponibles." >&2
    exit 1
fi

for marker in "SKILL_START" "SKILL_END" "INSTRUCTIONS_START" "INSTRUCTIONS_END"; do
    if ! grep -q "<!-- ${marker} -->" "$TEMPLATE_PATH"; then
        echo -e "${RED}ERROR: Missing required marker <!-- ${marker} --> in template${NC}" >&2
        exit 1
    fi
done

if [ "$FORCE" = false ] && [ -f "$SKILL_FILE" ]; then
    echo -e "${YELLOW}WARN: $SKILL_FILE ya existe. Usa --force para sobreescribir.${NC}" >&2
    exit 1
fi

# ── Dry-run ────────────────────────────────────────────────────────────────
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY-RUN] Se generarían los siguientes archivos:${NC}"
    echo "  → $SKILL_FILE"
    echo "  → $INSTRUCTIONS_FILE"
    echo ""
    echo "Placeholders a reemplazar:"
    echo "  {{PROJECT_NAME}}    → $PROJECT_NAME"
    echo "  {{LAYER}}           → $LAYER"
    echo "  {{FRAMEWORK}}       → $FRAMEWORK"
    echo "  {{LAYER_TITLE}}     → $LAYER_TITLE"
    echo "  {{FRAMEWORK_TITLE}} → $FRAMEWORK_TITLE"
    exit 0
fi

# ── Extracción de secciones ────────────────────────────────────────────────
extract_section() {
    local file="$1" start_marker="$2" end_marker="$3"
    awk "/<!-- ${start_marker} -->/{found=1; next} /<!-- ${end_marker} -->/{found=0} found" "$file"
}

replace_placeholders() {
    sed \
        -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
        -e "s/{{LAYER}}/$LAYER/g" \
        -e "s/{{FRAMEWORK}}/$FRAMEWORK/g" \
        -e "s/{{LAYER_TITLE}}/$LAYER_TITLE/g" \
        -e "s/{{FRAMEWORK_TITLE}}/$FRAMEWORK_TITLE/g"
}

# ── Generación ─────────────────────────────────────────────────────────────
mkdir -p "$SKILL_DIR" "$GUIDELINES_DIR"

extract_section "$TEMPLATE_PATH" "SKILL_START" "SKILL_END" | replace_placeholders > "$SKILL_FILE"
[ -s "$SKILL_FILE" ] || { echo "[ERROR] $SKILL_FILE generado vacío — verificar marcadores SKILL_START/SKILL_END en template" >&2; exit 1; }
extract_section "$TEMPLATE_PATH" "INSTRUCTIONS_START" "INSTRUCTIONS_END" | replace_placeholders > "$INSTRUCTIONS_FILE"
[ -s "$INSTRUCTIONS_FILE" ] || { echo "[ERROR] $INSTRUCTIONS_FILE generado vacío — verificar marcadores INSTRUCTIONS_START/INSTRUCTIONS_END en template" >&2; exit 1; }

# ── Output ─────────────────────────────────────────────────────────────────
echo -e "${GREEN}Generated: $SKILL_NAME (2 files)${NC}"
echo "  → $SKILL_FILE"
echo "  → $INSTRUCTIONS_FILE"

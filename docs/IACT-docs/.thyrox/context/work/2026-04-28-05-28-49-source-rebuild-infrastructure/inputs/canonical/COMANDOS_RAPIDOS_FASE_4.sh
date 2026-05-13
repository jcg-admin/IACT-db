#!/bin/bash
#
# COMANDOS RÁPIDOS: FASE 4 TAREAS FINALES (TASK-066 a TASK-072)
#
# Uso:
#   bash COMANDOS_RAPIDOS_FASE_4.sh [TASK-NUMBER]
#   Ejemplo: bash COMANDOS_RAPIDOS_FASE_4.sh 066
#
# O ejecutar comandos individuales copiando/pegando de aquí
#

set -e

REPO_ROOT="/home/user/IACT"
cd "$REPO_ROOT"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_section() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Main menu
show_menu() {
    echo -e "${BLUE}FASE 4: TAREAS FINALES${NC}"
    echo ""
    echo "1) TASK-066 - Limpiar Emojis (2h)"
    echo "2) TASK-067 - Eliminar Carpetas Legacy (1h)"
    echo "3) TASK-068 - Actualizar README Principal (2h)"
    echo "4) TASK-069 - Actualizar INDEX (2h)"
    echo "5) TASK-070 - Crear CHANGELOG (2h)"
    echo "6) TASK-071 - Crear Guías de Navegación (3h)"
    echo "7) TASK-072 - Documento Lecciones Aprendidas (2h)"
    echo ""
    echo "0) Mostrar Todos los Comandos"
    echo "q) Salir"
    echo ""
}

# ═════════════════════════════════════════════════════════════════════════════
# TASK-066: LIMPIAR EMOJIS
# ═════════════════════════════════════════════════════════════════════════════

task_066_setup() {
    print_section "TASK-066: LIMPIAR EMOJIS - SETUP"

    mkdir -p "${REPO_ROOT}/TASK-066-limpiar-emojis/evidencias"
    cd "${REPO_ROOT}/TASK-066-limpiar-emojis"

    # Crear README
    cat > README.md << 'EOF'
---
id: TASK-066
tipo: limpieza
categoria: documentacion
fase: FASE_4_VALIDACION_Y_LIMPIEZA
prioridad: ALTA
duracion_estimada: 2h
status: in_progress
date_start: $(date +%Y-%m-%d)
---

# TASK-066: Limpiar Emojis

## Checklist
- [ ] Análisis completado
- [ ] Emojis removibles identificados
- [ ] Emojis removibles removidos
- [ ] Backups creados
- [ ] Validación completada
- [ ] JSON report generado
EOF

    print_success "Directorio y README creados"
}

task_066_analyze() {
    print_section "TASK-066: ANÁLISIS DE EMOJIS"

    cd "${REPO_ROOT}/TASK-066-limpiar-emojis"

    cat > analyze_emojis.py << 'EOF'
import os
import re
import json
from pathlib import Path

REPO_ROOT = "/home/user/IACT"
EMOJI_PATTERN = r'[\U0001F300-\U0001F9FF]|[\u2600-\u27BF]|[\u2300-\u23FF]|[✅❌⚠️🔴📝🎯💡🚀]'

results = {
    "total_files": 0,
    "files_with_emojis": [],
    "emoji_count": {},
    "total_emojis": 0
}

for root, dirs, files in os.walk(REPO_ROOT):
    dirs[:] = [d for d in dirs if d not in ['.git', 'node_modules', '.github', '.agent']]

    for file in files:
        if file.endswith('.md'):
            results["total_files"] += 1
            filepath = os.path.join(root, file)

            try:
                with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    emojis = re.findall(EMOJI_PATTERN, content)

                    if emojis:
                        results["files_with_emojis"].append({
                            "file": filepath.replace(REPO_ROOT, ""),
                            "count": len(emojis),
                            "unique": list(set(emojis))
                        })
                        results["total_emojis"] += len(emojis)

                        for emoji in emojis:
                            results["emoji_count"][emoji] = results["emoji_count"].get(emoji, 0) + 1
            except Exception as e:
                print(f"Error reading {filepath}: {e}")

with open("emoji_analysis.json", "w") as f:
    json.dump(results, f, indent=2, ensure_ascii=False)

print(f"Total MD files: {results['total_files']}")
print(f"Files with emojis: {len(results['files_with_emojis'])}")
print(f"Total emojis found: {results['total_emojis']}")
print(f"Unique emojis: {len(results['emoji_count'])}")
print(f"Report saved to emoji_analysis.json")
EOF

    python3 analyze_emojis.py
    print_success "Análisis completado. Ver emoji_analysis.json"
}

task_066_remove() {
    print_section "TASK-066: REMOVER EMOJIS"

    cd "${REPO_ROOT}/TASK-066-limpiar-emojis"

    REMOVABLE_EMOJIS="✅|❌|⚠️|🔴|📝|🎯|💡|🚀|🔥|📌"

    count=0
    find "${REPO_ROOT}" -type f -name "*.md" -not -path "*/.git/*" | while read file; do
        if grep -E "$REMOVABLE_EMOJIS" "$file" > /dev/null 2>&1; then
            cp "$file" "$file.bak"
            sed -i -E "s/($REMOVABLE_EMOJIS)//g" "$file"
            sed -i 's/  +/ /g' "$file"
            echo "Processed: $file"
            count=$((count + 1))
        fi
    done

    print_success "Emojis removidos de archivos"
}

task_066_validate() {
    print_section "TASK-066: VALIDACIÓN"

    cd "${REPO_ROOT}/TASK-066-limpiar-emojis"

    echo "Remaining emojis:"
    grep -r "[✅❌⚠️🔴📝🎯💡🚀]" "${REPO_ROOT}" --include="*.md" 2>/dev/null | wc -l

    echo ""
    echo "Files modified:"
    find "${REPO_ROOT}" -name "*.bak" | wc -l

    echo ""
    git diff --stat | head -20

    print_success "Validación completada"
}

# ═════════════════════════════════════════════════════════════════════════════
# TASK-067: ELIMINAR CARPETAS LEGACY VACÍAS
# ═════════════════════════════════════════════════════════════════════════════

task_067_setup() {
    print_section "TASK-067: ELIMINAR CARPETAS - SETUP"

    mkdir -p "${REPO_ROOT}/TASK-067-eliminar-carpetas-legacy/evidencias"
    cd "${REPO_ROOT}/TASK-067-eliminar-carpetas-legacy"

    cat > README.md << 'EOF'
---
id: TASK-067
tipo: limpieza
categoria: estructura
fase: FASE_4_VALIDACION_Y_LIMPIEZA
prioridad: MEDIA
duracion_estimada: 1h
status: in_progress
---

# TASK-067: Eliminar Carpetas Legacy Vacías

## Checklist
- [ ] Carpetas vacías identificadas
- [ ] Validación pre-remoción completada
- [ ] Carpetas eliminadas
- [ ] Log de auditoría creado
EOF

    print_success "Directorio y README creados"
}

task_067_find() {
    print_section "TASK-067: IDENTIFICAR CARPETAS VACÍAS"

    cd "${REPO_ROOT}/TASK-067-eliminar-carpetas-legacy"

    find "${REPO_ROOT}" -type d -empty \
        -not -path "*/.git/*" \
        -not -path "*/node_modules/*" \
        -not -path "*/.github/*" \
        > empty_dirs.txt

    echo "Carpetas vacías encontradas:"
    wc -l empty_dirs.txt

    print_success "Lista guardada en empty_dirs.txt"
}

task_067_validate() {
    print_section "TASK-067: VALIDAR ANTES DE ELIMINAR"

    cd "${REPO_ROOT}/TASK-067-eliminar-carpetas-legacy"

    echo "Verificando carpetas con contenido oculto..."

    while IFS= read -r dir; do
        if [ -d "$dir" ]; then
            hidden_count=$(find "$dir" -maxdepth 1 -name ".*" -type f | wc -l)
            if [ "$hidden_count" -gt 0 ]; then
                echo "⚠ $dir has hidden files - PRESERVE"
            fi
        fi
    done < empty_dirs.txt

    print_success "Validación completada"
}

task_067_remove() {
    print_section "TASK-067: ELIMINAR CARPETAS"

    cd "${REPO_ROOT}/TASK-067-eliminar-carpetas-legacy"

    count=0
    while IFS= read -r dir; do
        if [ -d "$dir" ]; then
            echo "Removing: $dir" >> removed_dirs.log
            rmdir "$dir" 2>/dev/null && count=$((count + 1)) || true
        fi
    done < empty_dirs.txt

    echo "Carpetas eliminadas: $count"

    print_success "Eliminación completada"
}

# ═════════════════════════════════════════════════════════════════════════════
# TASK-068: ACTUALIZAR README PRINCIPAL
# ═════════════════════════════════════════════════════════════════════════════

task_068_setup() {
    print_section "TASK-068: ACTUALIZAR README - SETUP"

    mkdir -p "${REPO_ROOT}/TASK-068-actualizar-readme-principal/evidencias"

    cp "${REPO_ROOT}/README.md" "${REPO_ROOT}/TASK-068-actualizar-readme-principal/README_VIEJO.md.bak"

    print_success "Backup creado"
}

task_068_validate_links() {
    print_section "TASK-068: VALIDAR ENLACES"

    cd "${REPO_ROOT}/TASK-068-actualizar-readme-principal"

    grep -o '\[.*\]([^)]*)' "${REPO_ROOT}/README.md" | wc -l

    print_success "Validación completada"
}

# ═════════════════════════════════════════════════════════════════════════════
# TASK-069: ACTUALIZAR INDEX
# ═════════════════════════════════════════════════════════════════════════════

task_069_setup() {
    print_section "TASK-069: ACTUALIZAR INDEX - SETUP"

    mkdir -p "${REPO_ROOT}/TASK-069-actualizar-index/evidencias"

    cp "${REPO_ROOT}/INDEX.md" "${REPO_ROOT}/TASK-069-actualizar-index/INDEX_VIEJO.md.bak"

    print_success "Backup creado"
}

task_069_count_docs() {
    print_section "TASK-069: CONTAR DOCUMENTOS POR DOMINIO"

    for domain in backend frontend infraestructura agentes gobernanza; do
        count=$(find "${REPO_ROOT}/docs/$domain" -name "*.md" 2>/dev/null | wc -l)
        echo "$domain: $count documentos"
    done

    print_success "Conteo completado"
}

# ═════════════════════════════════════════════════════════════════════════════
# UTILIDADES GENERALES
# ═════════════════════════════════════════════════════════════════════════════

show_git_status() {
    print_section "ESTADO GIT"

    git status --short | head -20

    echo ""
    echo "Resumen:"
    git diff --stat | tail -5
}

show_progress() {
    print_section "PROGRESO FASE 4"

    echo "Directorios de tareas:"
    ls -1d TASK-0[67][0-9]* 2>/dev/null | wc -l
    echo ""

    echo "Últimas modificaciones:"
    ls -lt TASK-0[67][0-9]* 2>/dev/null | head -10
}

validate_all() {
    print_section "VALIDACIÓN GENERAL"

    echo "✓ Emojis removibles restantes: $(grep -r '[✅❌⚠️🔴📝🎯💡🚀]' ${REPO_ROOT} --include="*.md" 2>/dev/null | wc -l)"
    echo "✓ Carpetas vacías restantes: $(find ${REPO_ROOT} -type d -empty -not -path "*/.git/*" 2>/dev/null | wc -l)"
    echo "✓ Archivos MD: $(find ${REPO_ROOT} -name "*.md" -not -path "*/.git/*" | wc -l)"
    echo "✓ Directorios: $(find ${REPO_ROOT} -type d -not -path "*/.git/*" | wc -l)"
}

# ═════════════════════════════════════════════════════════════════════════════
# MAIN
# ═════════════════════════════════════════════════════════════════════════════

main() {
    if [ -z "$1" ]; then
        show_menu
        read -p "Selecciona una opción: " choice
    else
        choice=$1
    fi

    case $choice in
        1)
            echo "Seleccionado: TASK-066 - Limpiar Emojis"
            echo ""
            echo "Opciones:"
            echo "1) Setup"
            echo "2) Analizar"
            echo "3) Remover"
            echo "4) Validar"
            read -p "Opción: " opt

            case $opt in
                1) task_066_setup ;;
                2) task_066_analyze ;;
                3) task_066_remove ;;
                4) task_066_validate ;;
                *) print_error "Opción no válida" ;;
            esac
            ;;
        2)
            echo "Seleccionado: TASK-067 - Eliminar Carpetas"
            echo ""
            echo "Opciones:"
            echo "1) Setup"
            echo "2) Encontrar vacías"
            echo "3) Validar"
            echo "4) Eliminar"
            read -p "Opción: " opt

            case $opt in
                1) task_067_setup ;;
                2) task_067_find ;;
                3) task_067_validate ;;
                4) task_067_remove ;;
                *) print_error "Opción no válida" ;;
            esac
            ;;
        3)
            task_068_setup
            ;;
        4)
            task_069_setup
            ;;
        0)
            echo "Todos los comandos disponibles:"
            echo "- TASK-066: task_066_setup, task_066_analyze, task_066_remove, task_066_validate"
            echo "- TASK-067: task_067_setup, task_067_find, task_067_validate, task_067_remove"
            echo "- TASK-068: task_068_setup, task_068_validate_links"
            echo "- TASK-069: task_069_setup, task_069_count_docs"
            echo "- Utilidades: show_git_status, show_progress, validate_all"
            ;;
        q)
            exit 0
            ;;
        *)
            print_error "Opción no válida"
            ;;
    esac
}

# Si se ejecuta directamente
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi

#!/bin/bash
###############################################################################
# SCRIPT DE CONVERSIÓN MASIVA: MARKDOWN → RST
# Proyecto: IACT Dashboard Analytics
# Fecha: 2026-01-07
# Propósito: Convertir todos los archivos .md del proyecto a .rst
###############################################################################

set -e  # Salir si hay error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Contadores
TOTAL_FILES=0
CONVERTED_FILES=0
FAILED_FILES=0

# Función para imprimir con color
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Verificar que pandoc está instalado
check_pandoc() {
    print_info "Verificando instalación de pandoc..."
    if ! command -v pandoc &> /dev/null; then
        print_error "pandoc no está instalado"
        echo ""
        echo "Por favor instala pandoc:"
        echo "  Ubuntu/Debian: sudo apt-get install pandoc"
        echo "  macOS: brew install pandoc"
        echo "  Windows: Descarga desde https://pandoc.org/installing.html"
        exit 1
    fi
    print_success "pandoc $(pandoc --version | head -n1) encontrado"
}

# Función para convertir un archivo individual
convert_file() {
    local md_file="$1"
    local rst_file="${md_file%.md}.rst"
    
    TOTAL_FILES=$((TOTAL_FILES + 1))
    
    print_info "Convirtiendo: $md_file"
    
    if pandoc -f markdown -t rst --standalone "$md_file" -o "$rst_file" 2>/dev/null; then
        print_success "→ $rst_file"
        CONVERTED_FILES=$((CONVERTED_FILES + 1))
    else
        print_error "Falló conversión de: $md_file"
        FAILED_FILES=$((FAILED_FILES + 1))
    fi
}

# Función para convertir documentos grandes (multi-parte)
convert_large_doc() {
    local part1="$1"
    local part2="$2"
    local temp_combined="$3"
    local output_rst="$4"
    
    print_info "Procesando documento multi-parte..."
    print_info "  Parte 1: $part1"
    print_info "  Parte 2: $part2"
    
    # Unir partes
    cat "$part1" "$part2" > "$temp_combined"
    print_success "Partes unidas en: $temp_combined"
    
    # Convertir
    if pandoc -f markdown -t rst --standalone --toc "$temp_combined" -o "$output_rst" 2>/dev/null; then
        print_success "Convertido a: $output_rst"
        CONVERTED_FILES=$((CONVERTED_FILES + 1))
    else
        print_error "Falló conversión de: $output_rst"
        FAILED_FILES=$((FAILED_FILES + 1))
    fi
    
    TOTAL_FILES=$((TOTAL_FILES + 1))
}

# Función principal
main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║   CONVERSIÓN MASIVA: MARKDOWN → RST                           ║"
    echo "║   Proyecto IACT Dashboard Analytics                           ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    
    # Verificar pandoc
    check_pandoc
    echo ""
    
    # Crear directorio temporal
    TEMP_DIR="/tmp/iact_conversion"
    mkdir -p "$TEMP_DIR"
    print_info "Directorio temporal: $TEMP_DIR"
    echo ""
    
    # =========================================================================
    # SECCIÓN 1: DOCUMENTOS GRANDES (Multi-parte)
    # =========================================================================
    print_info "════════════════════════════════════════════════════════════"
    print_info "SECCIÓN 1: Convirtiendo documentos grandes (multi-parte)"
    print_info "════════════════════════════════════════════════════════════"
    echo ""
    
    # Documento 1: MODELO_DOCUMENTAL
    if [ -f "MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE1.md" ] && \
       [ -f "MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE2.md" ]; then
        convert_large_doc \
            "MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE1.md" \
            "MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE2.md" \
            "$TEMP_DIR/modelo_documental_combined.md" \
            "$TEMP_DIR/modelo_documental_v2_2_0.rst"
    else
        print_warning "Archivos MODELO_DOCUMENTAL no encontrados"
    fi
    echo ""
    
    # Documento 2: ANEXO_A
    if [ -f "ANEXO_A_ARBOL_COMPLETO_PARTE1.md" ] && \
       [ -f "ANEXO_A_ARBOL_COMPLETO_PARTE2.md" ]; then
        convert_large_doc \
            "ANEXO_A_ARBOL_COMPLETO_PARTE1.md" \
            "ANEXO_A_ARBOL_COMPLETO_PARTE2.md" \
            "$TEMP_DIR/anexo_a_combined.md" \
            "$TEMP_DIR/anexo_a_arbol_v2_2_0.rst"
    else
        print_warning "Archivos ANEXO_A no encontrados"
    fi
    echo ""
    
    # Documento 3: RESTRICCIONES
    if [ -f "RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md" ]; then
        print_info "Convirtiendo: RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md"
        if pandoc -f markdown -t rst --standalone --toc \
            "RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md" \
            -o "$TEMP_DIR/restricciones_sistema_v1_0_0.rst" 2>/dev/null; then
            print_success "→ restricciones_sistema_v1_0_0.rst"
            CONVERTED_FILES=$((CONVERTED_FILES + 1))
        else
            print_error "Falló conversión"
            FAILED_FILES=$((FAILED_FILES + 1))
        fi
        TOTAL_FILES=$((TOTAL_FILES + 1))
    else
        print_warning "Archivo RESTRICCIONES no encontrado"
    fi
    echo ""
    
    # Documento 4: MODELO_RBAC
    if [ -f "MODELO_RBAC_IACT_v5_1_1.md" ]; then
        print_info "Convirtiendo: MODELO_RBAC_IACT_v5_1_1.md"
        if pandoc -f markdown -t rst --standalone --toc \
            "MODELO_RBAC_IACT_v5_1_1.md" \
            -o "$TEMP_DIR/modelo_rbac_v5_1_1.rst" 2>/dev/null; then
            print_success "→ modelo_rbac_v5_1_1.rst"
            CONVERTED_FILES=$((CONVERTED_FILES + 1))
        else
            print_error "Falló conversión"
            FAILED_FILES=$((FAILED_FILES + 1))
        fi
        TOTAL_FILES=$((TOTAL_FILES + 1))
    else
        print_warning "Archivo MODELO_RBAC no encontrado"
    fi
    echo ""
    
    # =========================================================================
    # SECCIÓN 2: ARCHIVOS .md EN source/
    # =========================================================================
    print_info "════════════════════════════════════════════════════════════"
    print_info "SECCIÓN 2: Convirtiendo archivos .md en source/"
    print_info "════════════════════════════════════════════════════════════"
    echo ""
    
    if [ -d "source" ]; then
        # Buscar todos los .md en source/ y convertir
        while IFS= read -r md_file; do
            convert_file "$md_file"
        done < <(find source/ -name "*.md" -type f)
    else
        print_warning "Directorio source/ no encontrado"
    fi
    echo ""
    
    # =========================================================================
    # RESUMEN
    # =========================================================================
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║   RESUMEN DE CONVERSIÓN                                       ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "  Total archivos procesados: $TOTAL_FILES"
    echo "  ✓ Convertidos exitosamente: $CONVERTED_FILES"
    echo "  ✗ Conversiones fallidas:    $FAILED_FILES"
    echo ""
    
    # Mostrar ubicación de archivos convertidos
    print_info "Archivos .rst generados en: $TEMP_DIR/"
    echo ""
    print_info "Para copiar a tu proyecto:"
    echo ""
    echo "  # Documentos grandes:"
    echo "  cp $TEMP_DIR/modelo_documental_v2_2_0.rst source/normativa/estandares/"
    echo "  cp $TEMP_DIR/anexo_a_arbol_v2_2_0.rst source/normativa/estandares/"
    echo "  cp $TEMP_DIR/restricciones_sistema_v1_0_0.rst source/normativa/restricciones/"
    echo "  cp $TEMP_DIR/modelo_rbac_v5_1_1.rst source/base_cognitiva/"
    echo ""
    
    if [ $FAILED_FILES -eq 0 ]; then
        print_success "¡Conversión completada exitosamente!"
        exit 0
    else
        print_warning "Conversión completada con algunos errores"
        exit 1
    fi
}

# Ejecutar script
main "$@"

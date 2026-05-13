#!/bin/bash

# Script para visualizar la documentación del proyecto IACT
# Uso: ./ver_documentacion.sh [local|build|deploy]

set -e

DOCS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOCS_DIR"

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función de ayuda
show_help() {
    cat << EOF
${BLUE}Script de Visualización de Documentación IACT${NC}

${GREEN}Uso:${NC}
  ./ver_documentacion.sh [COMANDO]

${GREEN}Comandos:${NC}
  local       Servidor local en http://127.0.0.1:8000 (modo desarrollo)
  build       Construir sitio estático en site/
  deploy      Desplegar a GitHub Pages
  install     Instalar dependencias de MkDocs
  verify      Verificar configuración y enlaces
  clean       Limpiar archivos generados

${GREEN}Ejemplos:${NC}
  ./ver_documentacion.sh local        # Abrir servidor local
  ./ver_documentacion.sh build        # Generar HTML estático
  ./ver_documentacion.sh deploy       # Publicar a GitHub Pages

${GREEN}Requisitos:${NC}
  - Python 3.8+
  - pip (gestor de paquetes Python)

${YELLOW}Primera vez:${NC}
  ./ver_documentacion.sh install
  ./ver_documentacion.sh local

EOF
}

# Verificar si Python está instalado
check_python() {
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}Error: Python 3 no está instalado${NC}"
        echo "Instala Python 3.8+ desde https://www.python.org/"
        exit 1
    fi

    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    echo -e "${GREEN}Python detectado: $PYTHON_VERSION${NC}"
}

# Instalar dependencias
install_dependencies() {
    echo -e "${BLUE}Instalando dependencias de MkDocs...${NC}"

    if [ ! -f "requirements.txt" ]; then
        echo -e "${RED}Error: requirements.txt no encontrado${NC}"
        exit 1
    fi

    echo "Instalando paquetes..."
    pip install -r requirements.txt

    echo -e "${GREEN}Dependencias instaladas correctamente${NC}"
    echo ""
    echo "Verifica la instalación:"
    mkdocs --version
}

# Servidor local
serve_local() {
    echo -e "${BLUE}Iniciando servidor de documentación local...${NC}"
    echo ""
    echo -e "${GREEN}URL: ${NC}http://127.0.0.1:8000"
    echo -e "${YELLOW}Presiona Ctrl+C para detener${NC}"
    echo ""

    # Verificar que mkdocs esté instalado
    if ! command -v mkdocs &> /dev/null; then
        echo -e "${RED}Error: MkDocs no está instalado${NC}"
        echo "Ejecuta: ./ver_documentacion.sh install"
        exit 1
    fi

    # Abrir navegador automáticamente (opcional)
    if command -v open &> /dev/null; then
        sleep 2 && open http://127.0.0.1:8000 &
    elif command -v xdg-open &> /dev/null; then
        sleep 2 && xdg-open http://127.0.0.1:8000 &
    fi

    # Iniciar servidor
    mkdocs serve
}

# Construir sitio estático
build_site() {
    echo -e "${BLUE}Construyendo sitio estático...${NC}"

    # Limpiar build anterior
    if [ -d "site" ]; then
        echo "Limpiando site/ anterior..."
        rm -rf site
    fi

    # Construir
    mkdocs build --strict

    echo ""
    echo -e "${GREEN}Sitio construido exitosamente en: ${NC}$DOCS_DIR/site/"
    echo ""
    echo "Archivos generados:"
    du -sh site/
    echo ""
    echo "Para ver el sitio localmente:"
    echo "  cd site"
    echo "  python3 -m http.server 8000"
}

# Desplegar a GitHub Pages
deploy_site() {
    echo -e "${BLUE}Desplegando a GitHub Pages...${NC}"
    echo ""

    # Verificar que estemos en un repo git
    if [ ! -d "../.git" ]; then
        echo -e "${RED}Error: No es un repositorio Git${NC}"
        exit 1
    fi

    # Verificar cambios sin commit
    if ! git diff-index --quiet HEAD --; then
        echo -e "${YELLOW}Advertencia: Hay cambios sin commit${NC}"
        read -p "¿Continuar de todas formas? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    # Construir primero
    echo "Construyendo sitio antes de desplegar..."
    mkdocs build --strict

    # Desplegar
    echo ""
    echo "Desplegando a branch gh-pages..."
    mkdocs gh-deploy --clean --message "docs: deploy $(date +%Y-%m-%d)"

    echo ""
    echo -e "${GREEN}Desplegado exitosamente${NC}"
    echo "URL: https://2-coatl.github.io/IACT---project/"
    echo ""
    echo "Nota: GitHub Pages puede tardar 2-5 minutos en actualizar"
}

# Verificar configuración
verify_config() {
    echo -e "${BLUE}Verificando configuración...${NC}"
    echo ""

    # Verificar mkdocs.yml existe
    if [ ! -f "mkdocs.yml" ]; then
        echo -e "${RED}Error: mkdocs.yml no encontrado${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} mkdocs.yml existe"

    # Verificar sintaxis de mkdocs.yml
    if mkdocs get-deps &> /dev/null; then
        echo -e "${GREEN}✓${NC} mkdocs.yml válido"
    else
        echo -e "${RED}✗${NC} mkdocs.yml tiene errores de sintaxis"
    fi

    # Intentar build con modo estricto
    echo ""
    echo "Verificando enlaces y referencias..."
    if mkdocs build --strict &> /tmp/mkdocs-verify.log; then
        echo -e "${GREEN}✓${NC} Sin enlaces rotos"
    else
        echo -e "${YELLOW}⚠${NC}  Advertencias encontradas:"
        cat /tmp/mkdocs-verify.log | grep -E "WARNING|ERROR" || true
    fi

    # Verificar diagramas PlantUML
    PUML_COUNT=$(find anexos/diagramas -name "*.puml" 2>/dev/null | wc -l)
    echo ""
    echo -e "${GREEN}✓${NC} $PUML_COUNT diagramas PlantUML encontrados"

    # Verificar dependencias
    echo ""
    echo "Dependencias instaladas:"
    pip list | grep -E "mkdocs|kroki|pymdown" || echo "  (ninguna)"

    echo ""
    echo -e "${GREEN}Verificación completada${NC}"
}

# Limpiar archivos generados
clean_build() {
    echo -e "${BLUE}Limpiando archivos generados...${NC}"

    if [ -d "site" ]; then
        rm -rf site
        echo -e "${GREEN}✓${NC} Eliminado site/"
    fi

    if [ -d "images/diagrams" ]; then
        rm -rf images/diagrams
        echo -e "${GREEN}✓${NC} Eliminado images/diagrams/"
    fi

    # Buscar archivos __pycache__
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
    echo -e "${GREEN}✓${NC} Limpieza completada"
}

# Main
main() {
    check_python

    case "${1:-help}" in
        local|serve)
            serve_local
            ;;
        build)
            build_site
            ;;
        deploy)
            deploy_site
            ;;
        install)
            install_dependencies
            ;;
        verify|check)
            verify_config
            ;;
        clean)
            clean_build
            ;;
        help|-h|--help)
            show_help
            ;;
        *)
            echo -e "${RED}Comando desconocido: $1${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"

#!/bin/bash
# =============================================================================
# bootstrap.sh — IACT-db: instala y configura MariaDB + PostgreSQL + Adminer
# =============================================================================
# Reemplaza: vagrant up
# Uso:
#   cp .env.example .env      # ajustar credenciales
#   sudo bash bootstrap.sh    # instalar todo
#   sudo bash bootstrap.sh --no-adminer  # solo BDs
#
# Requisitos: Ubuntu 22.04/24.04 o Debian 12+, acceso root
# Idempotente: se puede ejecutar N veces sin efectos adversos
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

# =============================================================================
# Cargar utilidades
# =============================================================================
source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/validation.sh"
source "${PROJECT_ROOT}/utils/provisioning.sh"

init_all

# =============================================================================
# Cargar configuración desde .env
# =============================================================================
ENV_FILE="${PROJECT_ROOT}/.env"

if [[ ! -f "$ENV_FILE" ]]; then
    log_error "Archivo .env no encontrado"
    log_info  "Crea tu configuración con: cp .env.example .env"
    exit 1
fi

set -a; source "$ENV_FILE"; set +a

# Variables con defaults
export MARIADB_VERSION="${MARIADB_VERSION:-11.4}"
export POSTGRES_VERSION="${POSTGRES_VERSION:-16}"
export ADMINER_VERSION="${ADMINER_VERSION:-4.8.1}"
export DB_CHARSET="${DB_CHARSET:-utf8mb4}"
export DB_COLLATION="${DB_COLLATION:-utf8mb4_unicode_ci}"
export MARIADB_HOST="${MARIADB_HOST:-127.0.0.1}"
export MARIADB_PORT="${MARIADB_PORT:-3306}"
export POSTGRES_HOST="${POSTGRES_HOST:-127.0.0.1}"
export POSTGRES_PORT="${POSTGRES_PORT:-5432}"

# Exportar aliases que usan los provisioners (compatibilidad con variables antiguas)
export DB_NAME="${DB_POSTGRES_NAME:-iact_analytics}"
export DB_USER="${DB_POSTGRES_USER:-django_user}"
export DB_PASSWORD="${DB_POSTGRES_PASSWORD:-django_pass}"
export DB_ROOT_PASSWORD="${DB_MARIADB_ROOT_PASSWORD:-rootpass123}"
export POSTGRES_PASSWORD="${DB_POSTGRES_ROOT_PASSWORD:-postgrespass123}"

# =============================================================================
# Opciones
# =============================================================================
INSTALL_ADMINER=true
for arg in "$@"; do
    case "$arg" in
        --no-adminer) INSTALL_ADMINER=false ;;
        --help|-h)
            echo "Uso: sudo bash bootstrap.sh [--no-adminer]"
            echo "  --no-adminer  Instala solo MariaDB y PostgreSQL"
            exit 0
            ;;
    esac
done

# =============================================================================
# Validaciones previas
# =============================================================================
if ! validate_root; then
    log_fatal "Ejecuta con: sudo bash bootstrap.sh"
fi

OS_ID=$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"' || echo "unknown")
OS_VER=$(grep '^VERSION_ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"' || echo "0")

if [[ "$OS_ID" != "ubuntu" && "$OS_ID" != "debian" ]]; then
    log_warn "OS detectado: ${OS_ID} ${OS_VER} — solo probado en Ubuntu/Debian"
fi

log_header "IACT-db Bootstrap"
echo "  Sistema:       ${OS_ID} ${OS_VER}"
echo "  MariaDB:       ${MARIADB_VERSION} → ${DB_MARIADB_NAME:-ivr_legacy}"
echo "  PostgreSQL:    ${POSTGRES_VERSION} → ${DB_POSTGRES_NAME:-iact_analytics}"
echo "  Adminer:       ${ADMINER_VERSION} ($([ "$INSTALL_ADMINER" = true ] && echo habilitado || echo deshabilitado))"
echo "  PROJECT_ROOT:  ${PROJECT_ROOT}"
echo ""

ensure_dir "${PROJECT_ROOT}/logs"

# =============================================================================
# Provisionamiento
# =============================================================================

run_provisioner() {
    local component="$1"
    local bootstrap="${PROJECT_ROOT}/provisioners/${component}/bootstrap.sh"

    if [[ ! -f "$bootstrap" ]]; then
        log_error "Provisioner no encontrado: ${bootstrap}"
        return 1
    fi

    log_info "Iniciando provisioner: ${component}"
    if bash "$bootstrap"; then
        log_success "${component} completado"
    else
        log_error "${component} falló — revisa ${PROJECT_ROOT}/logs/"
        return 1
    fi
}

run_provisioner "mariadb"
run_provisioner "postgres"

if [[ "$INSTALL_ADMINER" == "true" ]]; then
    run_provisioner "adminer"
fi

# =============================================================================
# Verificación final
# =============================================================================
log_info "Ejecutando verificación final..."
bash "${PROJECT_ROOT}/verify.sh"

log_success "Bootstrap completado"

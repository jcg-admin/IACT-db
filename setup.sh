#!/bin/bash
# =============================================================================
# setup.sh — IACT-db: configura BDs sin instalar (BDs ya instaladas)
# =============================================================================
# Uso cuando MariaDB y PostgreSQL ya están instalados y corriendo:
#
#   cp .env.example .env
#   sudo bash setup.sh
#
# Ejecuta solo los setup.sh de cada BD (crea BD, usuario, privilegios).
# No instala paquetes del sistema.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/validation.sh"
source "${PROJECT_ROOT}/utils/database.sh"

ENV_FILE="${PROJECT_ROOT}/.env"
if [[ ! -f "$ENV_FILE" ]]; then
    log_error "Archivo .env no encontrado — crea: cp .env.example .env"
    exit 1
fi

set -a; source "$ENV_FILE"; set +a

export DB_CHARSET="${DB_CHARSET:-utf8mb4}"
export DB_COLLATION="${DB_COLLATION:-utf8mb4_unicode_ci}"
export MARIADB_HOST="${MARIADB_HOST:-127.0.0.1}"
export MARIADB_PORT="${MARIADB_PORT:-3306}"
export POSTGRES_HOST="${POSTGRES_HOST:-127.0.0.1}"
export POSTGRES_PORT="${POSTGRES_PORT:-5432}"

if ! validate_root; then
    log_fatal "Ejecuta con: sudo bash setup.sh"
fi

# Arrancar BDs si no están corriendo
bash "${PROJECT_ROOT}/start.sh" || {
    log_error "No se pudieron arrancar las bases de datos"
    log_error "  Verifica la instalación: bash verify.sh"
    exit 1
}

ensure_dir "${PROJECT_ROOT}/logs"

log_header "IACT-db Setup (sin instalación de paquetes)"

log_info "Configurando MariaDB..."
bash "${PROJECT_ROOT}/provisioners/mariadb/setup.sh"

log_info "Configurando PostgreSQL..."
bash "${PROJECT_ROOT}/provisioners/postgres/setup.sh"

log_success "Setup completado"
bash "${PROJECT_ROOT}/verify.sh"

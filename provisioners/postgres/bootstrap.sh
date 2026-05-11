#!/bin/bash
# bootstrap.sh
# Bootstrap script for PostgreSQL VM
# Version: 1.0.3 - Alineacion de nombres de variable con .env.example (H-PG-004)

set -euo pipefail

# Load utilities

# Detectar PROJECT_ROOT (sin dependencia de /vagrant)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/utils/provisioning.sh"

# Initialize
init_all

# Initialize logging to file
init_log "postgres_bootstrap"

# Define steps with unique names (avoid collision with provisioning.sh functions)
postgres_system() {
    init_log "system_prepare"
    source "${PROJECT_ROOT}/utils/system.sh"
    main
}

postgres_install() {
    init_log "postgres_install"
    source "${PROJECT_ROOT}/provisioners/postgres/install.sh"
    main
}

postgres_config() {
    init_log "postgres_config"
    source "${PROJECT_ROOT}/provisioners/postgres/config.sh"
    main
}

postgres_setup() {
    init_log "postgres_setup"
    source "${PROJECT_ROOT}/provisioners/postgres/setup.sh"
}

# H-PG-004: variables alineadas con .env.example y setup.sh
# Convencion unificada: DB_POSTGRES_* para BD/usuario, POSTGRES_HOST para host
require_vars POSTGRES_VERSION \
             DB_POSTGRES_NAME DB_POSTGRES_USER DB_POSTGRES_PASSWORD \
             POSTGRES_PASSWORD POSTGRES_HOST POSTGRES_PORT

# Component header
step_header "PostgreSQL" "PostgreSQL ${POSTGRES_VERSION} Database Server"

# Execute provisioning steps
steps=(
    "postgres_system"
    "postgres_install"
    "postgres_config"
    "postgres_setup"
)

if ! run_all "${steps[@]}"; then
    log_error "PostgreSQL provisioning failed"
    exit 1
fi

# Show results
show_results "PostgreSQL ${POSTGRES_VERSION}" \
    "Host: ${POSTGRES_HOST}" \
    "Port: ${POSTGRES_PORT}" \
    "Database: ${DB_POSTGRES_NAME}" \
    "Status: Running"

show_connection_info \
    "PostgreSQL" \
    "${POSTGRES_HOST}" \
    "${POSTGRES_PORT}" \
    "${DB_POSTGRES_NAME}" \
    "${DB_POSTGRES_USER}"

log_success "PostgreSQL provisioning completed successfully"
#!/bin/bash
# bootstrap.sh
# Bootstrap script for MariaDB VM
# Version: 1.0.3 - Alineacion de nombres de variable con .env.example (H-MDB-003)

set -euo pipefail

# Load utilities

# Detectar PROJECT_ROOT (sin dependencia de /vagrant)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/utils/provisioning.sh"

# Initialize
init_all

# Initialize logging to file
init_log "mariadb_bootstrap"

# Define steps with unique names (avoid collision with provisioning.sh functions)
mariadb_system() {
    init_log "system_prepare"
    source "${PROJECT_ROOT}/utils/system.sh"
    main
}

mariadb_install() {
    init_log "mariadb_install"
    source "${PROJECT_ROOT}/provisioners/mariadb/install.sh"
    main
}

mariadb_setup() {
    init_log "mariadb_setup"
    source "${PROJECT_ROOT}/provisioners/mariadb/setup.sh"
}

# H-MDB-003: variables alineadas con .env.example y setup.sh
# Convencion unificada: DB_MARIADB_* para BD/usuario, MARIADB_HOST para host
require_vars MARIADB_VERSION DB_CHARSET DB_COLLATION \
             DB_MARIADB_NAME DB_MARIADB_USER DB_MARIADB_PASSWORD \
             DB_MARIADB_ROOT_PASSWORD MARIADB_HOST MARIADB_PORT

# Component header
step_header "MariaDB" "MariaDB ${MARIADB_VERSION} Database Server"

# Execute provisioning steps
steps=(
    "mariadb_system"
    "mariadb_install"
    "mariadb_setup"
)

if ! run_all "${steps[@]}"; then
    log_error "MariaDB provisioning failed"
    exit 1
fi

# Show results
show_results "MariaDB ${MARIADB_VERSION}" \
    "Host: ${MARIADB_HOST}" \
    "Port: ${MARIADB_PORT}" \
    "Database: ${DB_MARIADB_NAME}" \
    "Charset: ${DB_CHARSET}" \
    "Status: Running"

show_connection_info \
    "MariaDB" \
    "${MARIADB_HOST}" \
    "${MARIADB_PORT}" \
    "${DB_MARIADB_NAME}" \
    "${DB_MARIADB_USER}"

log_success "MariaDB provisioning completed successfully"
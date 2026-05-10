#!/bin/bash
# bootstrap.sh
# Bootstrap script for Adminer VM
# Version: 1.0.2 - Variables from Vagrantfile

set -euo pipefail

# Load utilities

# Detectar PROJECT_ROOT (sin dependencia de /vagrant)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/utils/provisioning.sh"

# Initialize
init_all

# Initialize logging to file
init_log "adminer_bootstrap"

# Define steps with unique names (avoid collision with provisioning.sh functions)
adminer_system() {
    init_log "system_prepare"
    source "${PROJECT_ROOT}/utils/system.sh"
    main
}

adminer_swap() {
    init_log "adminer_swap"
    source "${PROJECT_ROOT}/provisioners/adminer/swap.sh"
    main
}

adminer_install() {
    init_log "adminer_install"
    source "${PROJECT_ROOT}/provisioners/adminer/install.sh"
    main
}

adminer_ssl() {
    init_log "adminer_ssl"
    source "${PROJECT_ROOT}/provisioners/adminer/ssl.sh"
    main
}

# Variables are exported from Vagrantfile - validate they exist
require_vars ADMINER_VERSION ADMINER_IP ADMINER_HTTP_PORT \
             ADMINER_HTTPS_PORT SWAP_SIZE \
             MARIADB_IP POSTGRES_IP \
             SSL_DAYS SSL_COUNTRY SSL_STATE SSL_CITY SSL_ORG SSL_OU SSL_CN

# Component header
step_header "Adminer" "Adminer ${ADMINER_VERSION} Web Interface"

# Execute provisioning steps
steps=(
    "adminer_system"
    "adminer_swap"
    "adminer_install"
    "adminer_ssl"
)

if ! run_all "${steps[@]}"; then
    log_error "Adminer provisioning failed"
    exit 1
fi

# Show results
show_results "Adminer ${ADMINER_VERSION}" \
    "HTTP:  http://${ADMINER_IP}:${ADMINER_HTTP_PORT}" \
    "HTTPS: https://${ADMINER_IP}:${ADMINER_HTTPS_PORT}" \
    "MariaDB:    ${MARIADB_IP}:3306" \
    "PostgreSQL: ${POSTGRES_IP}:5432" \
    "Status: Running"

log_success "Adminer provisioning completed successfully"
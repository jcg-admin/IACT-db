#!/bin/bash
# bootstrap.sh
# Bootstrap script for PostgreSQL VM
# Version: 1.0.2 - Variables from Vagrantfile

set -euo pipefail

# Load utilities
source /vagrant/utils/provisioning.sh

# Initialize
init_all

# Initialize logging to file
init_log "postgres_bootstrap"

# Define steps with unique names (avoid collision with provisioning.sh functions)
postgres_system() {
    init_log "system_prepare"
    source /vagrant/utils/system.sh
    main
}

postgres_install() {
    init_log "postgres_install"
    source /vagrant/provisioners/postgres/install.sh
    main
}

postgres_setup() {
    init_log "postgres_setup"
    source /vagrant/provisioners/postgres/setup.sh
    main
}

# Variables are exported from Vagrantfile - validate they exist
require_vars POSTGRES_VERSION DB_NAME DB_USER DB_PASSWORD \
             POSTGRES_PASSWORD POSTGRES_IP POSTGRES_PORT

# Component header
step_header "PostgreSQL" "PostgreSQL ${POSTGRES_VERSION} Database Server"

# Execute provisioning steps
steps=(
    "postgres_system"
    "postgres_install"
    "postgres_setup"
)

if ! run_all "${steps[@]}"; then
    log_error "PostgreSQL provisioning failed"
    exit 1
fi

# Show results
show_results "PostgreSQL ${POSTGRES_VERSION}" \
    "IP: ${POSTGRES_IP}" \
    "Port: ${POSTGRES_PORT}" \
    "Database: ${DB_NAME}" \
    "Status: Running"

show_connection_info \
    "PostgreSQL" \
    "${POSTGRES_IP}" \
    "${POSTGRES_PORT}" \
    "${DB_NAME}" \
    "${DB_USER}"

log_success "PostgreSQL provisioning completed successfully"
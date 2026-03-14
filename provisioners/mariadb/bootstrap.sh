#!/bin/bash
# bootstrap.sh
# Bootstrap script for MariaDB VM
# Version: 1.0.2 - Variables from Vagrantfile

set -euo pipefail

# Load utilities
source /vagrant/utils/provisioning.sh

# Initialize
init_all

# Initialize logging to file
init_log "mariadb_bootstrap"

# Define steps with unique names (avoid collision with provisioning.sh functions)
mariadb_system() {
    init_log "system_prepare"
    source /vagrant/utils/system.sh
    main
}

mariadb_install() {
    init_log "mariadb_install"
    source /vagrant/provisioners/mariadb/install.sh
    main
}

mariadb_setup() {
    init_log "mariadb_setup"
    source /vagrant/provisioners/mariadb/setup.sh
    main
}

# Variables are exported from Vagrantfile - validate they exist
require_vars MARIADB_VERSION DB_NAME DB_CHARSET DB_COLLATION \
             DB_USER DB_PASSWORD DB_ROOT_PASSWORD \
             MARIADB_IP MARIADB_PORT

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
    "IP: ${MARIADB_IP}" \
    "Port: ${MARIADB_PORT}" \
    "Database: ${DB_NAME}" \
    "Charset: ${DB_CHARSET}" \
    "Status: Running"

show_connection_info \
    "MariaDB" \
    "${MARIADB_IP}" \
    "${MARIADB_PORT}" \
    "${DB_NAME}" \
    "${DB_USER}"

log_success "MariaDB provisioning completed successfully"
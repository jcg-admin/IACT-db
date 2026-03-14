#!/bin/bash
# setup.sh
# MariaDB database setup script
# Version: 1.0.0

set -euo pipefail

# Load utilities
source /vagrant/utils/core.sh
source /vagrant/utils/database.sh
source /vagrant/utils/logging.sh
source /vagrant/utils/validation.sh

# Main function
main() {
    log_header "MariaDB Database Setup"

    # Validate running as root
    if ! validate_root; then
        log_fatal "This script must be run as root"
    fi

    # Validate required variables
    require_vars DB_NAME DB_CHARSET DB_COLLATION DB_USER DB_PASSWORD DB_ROOT_PASSWORD

    # Ensure log directory
    if ! ensure_dir /vagrant/logs; then
        log_error "Failed to create log directory"
        return 1
    fi

    # Verify MariaDB is running
    if ! verify_mariadb_running; then
        log_error "MariaDB is not running"
        return 1
    fi

    # Create database
    if ! create_database; then
        log_error "Failed to create database"
        return 1
    fi

    # Create user
    if ! create_database_user; then
        log_error "Failed to create database user"
        return 1
    fi

    # Grant privileges
    if ! grant_user_privileges; then
        log_error "Failed to grant privileges"
        return 1
    fi

    # Create schema version table
    if ! create_schema_version_table; then
        log_error "Failed to create schema version table"
        return 1
    fi

    log_success "MariaDB database setup completed"
    return 0
}

# Verify MariaDB is running
verify_mariadb_running() {
    log_info "Verifying MariaDB is running"

    if ! systemctl is-active --quiet mariadb; then
        log_error "MariaDB service is not active"
        return 1
    fi

    # Wait for MariaDB to be ready
    if ! mysql_wait_ready 30; then
        log_error "MariaDB is not ready to accept connections"
        return 1
    fi

    log_success "MariaDB is running and ready"
    return 0
}

# Create database
create_database() {
    log_info "Creating database: ${DB_NAME}"

    # Check if database already exists
    if mysql_database_exists "${DB_NAME}" "root" "${DB_ROOT_PASSWORD}"; then
        log_warn "Database ${DB_NAME} already exists, skipping creation"
        return 0
    fi

    # Create database with specified charset and collation
    if ! mysql_create_database "${DB_NAME}" "${DB_CHARSET}" "${DB_COLLATION}" "root" "${DB_ROOT_PASSWORD}"; then
        log_error "Failed to create database"
        return 1
    fi

    log_success "Database ${DB_NAME} created successfully"
    return 0
}

# Create database user
create_database_user() {
    log_info "Creating database user: ${DB_USER}"

    # Check if user already exists
    local user_exists=$(mysql -u root -p"${DB_ROOT_PASSWORD}" -sse "SELECT COUNT(*) FROM mysql.user WHERE User='${DB_USER}' AND Host='%';" 2>/dev/null || echo "0")

    if [[ "$user_exists" -gt 0 ]]; then
        log_warn "User ${DB_USER} already exists, skipping creation"
        return 0
    fi

    # Create user with remote access (%)
    if ! mysql_create_user "${DB_USER}" "${DB_PASSWORD}" "%" "root" "${DB_ROOT_PASSWORD}"; then
        log_error "Failed to create user"
        return 1
    fi

    log_success "User ${DB_USER} created successfully"
    return 0
}

# Grant privileges to user
grant_user_privileges() {
    log_info "Granting privileges to user: ${DB_USER}"

    # Grant all privileges on the database
    if ! mysql_grant_privileges "${DB_NAME}" "${DB_USER}" "%" "root" "${DB_ROOT_PASSWORD}"; then
        log_error "Failed to grant privileges"
        return 1
    fi

    # Flush privileges
    log_info "Flushing privileges"
    if ! mysql -u root -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;" 2>/dev/null; then
        log_error "Failed to flush privileges"
        return 1
    fi

    log_success "Privileges granted to ${DB_USER} on ${DB_NAME}"
    return 0
}

# Create schema version table
create_schema_version_table() {
    log_info "Creating schema version table"

    # Create a table to track schema version
    local sql="
    CREATE TABLE IF NOT EXISTS schema_version (
        id INT AUTO_INCREMENT PRIMARY KEY,
        version VARCHAR(50) NOT NULL,
        description VARCHAR(255),
        applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_version (version)
    ) ENGINE=InnoDB DEFAULT CHARSET=${DB_CHARSET} COLLATE=${DB_COLLATION};
    "

    if ! mysql -u root -p"${DB_ROOT_PASSWORD}" "${DB_NAME}" -e "${sql}" 2>/dev/null; then
        log_error "Failed to create schema_version table"
        return 1
    fi

    # Insert initial version
    local insert_sql="
    INSERT INTO schema_version (version, description)
    VALUES ('1.0.0', 'Initial database schema')
    ON DUPLICATE KEY UPDATE version=version;
    "

    if ! mysql -u root -p"${DB_ROOT_PASSWORD}" "${DB_NAME}" -e "${insert_sql}" 2>/dev/null; then
        log_warn "Failed to insert initial schema version (may already exist)"
    fi

    log_success "Schema version table created"
    return 0
}

# Note: main() is called by bootstrap.sh, not auto-executed
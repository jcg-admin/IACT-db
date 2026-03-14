#!/bin/bash
# install.sh
# MariaDB installation script
# Version: 1.0.0

set -euo pipefail

# Load utilities
source /vagrant/utils/core.sh
source /vagrant/utils/database.sh
source /vagrant/utils/logging.sh
source /vagrant/utils/network.sh
source /vagrant/utils/validation.sh

# Main function
main() {
    log_header "MariaDB Installation"

    # Validate running as root
    if ! validate_root; then
        log_fatal "This script must be run as root"
    fi

    # Validate required variables
    require_vars MARIADB_VERSION DB_ROOT_PASSWORD

    # Ensure log directory
    if ! ensure_dir /vagrant/logs; then
        log_error "Failed to create log directory"
        return 1
    fi

    # Add MariaDB repository
    if ! add_mariadb_repository; then
        log_error "Failed to add MariaDB repository"
        return 1
    fi

    # Install MariaDB
    if ! install_mariadb; then
        log_error "Failed to install MariaDB"
        return 1
    fi

    # Configure MariaDB
    if ! configure_mariadb; then
        log_error "Failed to configure MariaDB"
        return 1
    fi

    # Secure MariaDB installation
    if ! secure_mariadb; then
        log_error "Failed to secure MariaDB"
        return 1
    fi

    log_success "MariaDB installation completed"
    return 0
}

# Add MariaDB repository
add_mariadb_repository() {
    log_info "Adding MariaDB ${MARIADB_VERSION} repository"

    # Install prerequisites
    if ! install_package software-properties-common; then
        return 1
    fi

    if ! install_package dirmngr; then
        return 1
    fi

    if ! install_package apt-transport-https; then
        return 1
    fi

    # Import MariaDB GPG key
    log_info "Importing MariaDB GPG key"
    if ! curl -fsSL https://mariadb.org/mariadb_release_signing_key.asc | apt-key add - 2>/dev/null; then
        log_error "Failed to import GPG key"
        return 1
    fi

    # Add repository
    log_info "Adding repository to sources.list.d"
    local repo_file="/etc/apt/sources.list.d/mariadb.list"

    cat > "$repo_file" << EOF
# MariaDB ${MARIADB_VERSION} repository
deb [arch=amd64] http://mirror.mariadb.org/repo/${MARIADB_VERSION}/ubuntu focal main
EOF

    if [[ ! -f "$repo_file" ]]; then
        log_error "Failed to create repository file"
        return 1
    fi

    # Update package index
    log_info "Updating package index"
    if ! apt-get update -qq; then
        log_error "Failed to update package index"
        return 1
    fi

    log_success "MariaDB repository added"
    return 0
}

# Install MariaDB packages
install_mariadb() {
    log_info "Installing MariaDB ${MARIADB_VERSION}"

    # Set root password for non-interactive installation
    export DEBIAN_FRONTEND=noninteractive

    debconf-set-selections <<< "mariadb-server mysql-server/root_password password ${DB_ROOT_PASSWORD}"
    debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password ${DB_ROOT_PASSWORD}"

    # Install MariaDB server and client
    if ! install_package mariadb-server; then
        log_error "Failed to install mariadb-server"
        return 1
    fi

    if ! install_package mariadb-client; then
        log_error "Failed to install mariadb-client"
        return 1
    fi

    # Enable MariaDB service
    if ! enable_service mariadb; then
        log_error "Failed to enable MariaDB service"
        return 1
    fi

    # Start MariaDB service
    if ! start_service mariadb; then
        log_error "Failed to start MariaDB service"
        return 1
    fi

    # Wait for MariaDB to be ready
    log_info "Waiting for MariaDB to be ready"
    if ! mysql_wait_ready 30; then
        log_error "MariaDB did not start within 30 seconds"
        return 1
    fi

    log_success "MariaDB installed and started"
    return 0
}

# Configure MariaDB
configure_mariadb() {
    log_info "Configuring MariaDB for remote access"

    local config_file="/etc/mysql/mariadb.conf.d/50-server.cnf"

    # Validate config file exists
    if ! validate_file_exists "$config_file"; then
        log_error "Config file not found: $config_file"
        return 1
    fi

    # Backup configuration file
    log_info "Creating backup of configuration file"
    if ! backup_file "$config_file"; then
        log_error "Failed to backup configuration file"
        return 1
    fi

    # Configure bind-address to accept remote connections
    log_info "Configuring bind-address for remote access"
    if grep -q "^bind-address" "$config_file"; then
        sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' "$config_file"
    else
        # If bind-address doesn't exist, add it under [mysqld]
        sed -i '/^\[mysqld\]/a bind-address = 0.0.0.0' "$config_file"
    fi

    # Verify the change was made
    if ! grep -q "bind-address = 0.0.0.0" "$config_file"; then
        log_error "Failed to set bind-address"
        return 1
    fi

    log_success "Configuration updated"

    # Restart MariaDB to apply changes
    log_info "Restarting MariaDB to apply configuration"
    if ! restart_service mariadb; then
        log_error "Failed to restart MariaDB"
        return 1
    fi

    # Wait for MariaDB to be ready again
    if ! mysql_wait_ready 30; then
        log_error "MariaDB did not restart within 30 seconds"
        return 1
    fi

    log_success "MariaDB configured for remote access"
    return 0
}

# Secure MariaDB installation
secure_mariadb() {
    log_info "Securing MariaDB installation"

    # Remove anonymous users
    log_info "Removing anonymous users"
    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "DELETE FROM mysql.user WHERE User='';" 2>/dev/null || true

    # Disallow root login remotely
    log_info "Disallowing root login remotely"
    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" 2>/dev/null || true

    # Remove test database
    log_info "Removing test database"
    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "DROP DATABASE IF EXISTS test;" 2>/dev/null || true
    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';" 2>/dev/null || true

    # Flush privileges
    log_info "Flushing privileges"
    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;" 2>/dev/null || {
        log_error "Failed to flush privileges"
        return 1
    }

    log_success "MariaDB installation secured"
    return 0
}

# Note: main() is called by bootstrap.sh, not auto-executed
#!/bin/bash
# install.sh
# PostgreSQL installation script
# Version: 1.0.4 - Uses archived repository (Ubuntu 20.04 focal was EOL on July 2025)

set -euo pipefail

# Load utilities
source /vagrant/utils/core.sh
source /vagrant/utils/database.sh
source /vagrant/utils/logging.sh
source /vagrant/utils/network.sh
source /vagrant/utils/validation.sh

# Main function
main() {
    log_header "PostgreSQL Installation"

    # Validate running as root
    if ! validate_root; then
        log_fatal "This script must be run as root"
    fi

    # Validate required variables
    require_vars POSTGRES_VERSION POSTGRES_PASSWORD

    # Ensure log directory
    if ! ensure_dir /vagrant/logs; then
        log_error "Failed to create log directory"
        return 1
    fi

    # Add PostgreSQL repository
    if ! add_postgresql_repository; then
        log_error "Failed to add PostgreSQL repository"
        return 1
    fi

    # Install PostgreSQL
    if ! install_postgresql; then
        log_error "Failed to install PostgreSQL"
        return 1
    fi

    # Configure PostgreSQL for remote access
    if ! configure_postgresql; then
        log_error "Failed to configure PostgreSQL"
        return 1
    fi

    # Set PostgreSQL password
    if ! set_postgres_password; then
        log_error "Failed to set postgres password"
        return 1
    fi

    log_success "PostgreSQL installation completed"
    return 0
}

# Add PostgreSQL repository (MODERN METHOD)
add_postgresql_repository() {
    log_info "Adding PostgreSQL ${POSTGRES_VERSION} repository"

    # Install prerequisites
    if ! install_package wget; then
        return 1
    fi

    if ! install_package ca-certificates; then
        return 1
    fi

    if ! install_package gnupg; then
        return 1
    fi

    if ! install_package curl; then
        return 1
    fi

    # Create keyrings directory if it doesn't exist
    if ! ensure_dir /usr/share/keyrings; then
        log_error "Failed to create keyrings directory"
        return 1
    fi

    # Import PostgreSQL GPG key (MODERN METHOD)
    log_info "Importing PostgreSQL GPG key"
    local keyring_file="/usr/share/keyrings/postgresql-archive-keyring.gpg"

    if [[ ! -f "$keyring_file" ]]; then
        if ! wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o "$keyring_file" 2>/dev/null; then
            log_error "Failed to import GPG key"
            return 1
        fi
        log_success "GPG key imported"
    else
        log_info "GPG key already exists"
    fi

    # Add repository with signed-by keyring (ARCHIVED REPOSITORY for focal)
    log_info "Adding repository to sources.list.d"
    local repo_file="/etc/apt/sources.list.d/pgdg.list"

    cat > "$repo_file" << EOF
# PostgreSQL ${POSTGRES_VERSION} repository (archived for Ubuntu 20.04)
deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] https://apt-archive.postgresql.org/pub/repos/apt focal-pgdg main
EOF

    if [[ ! -f "$repo_file" ]]; then
        log_error "Failed to create repository file"
        return 1
    fi

    # Show repository configuration for debugging
    log_info "Repository configuration:"
    cat "$repo_file"

    # Test connectivity to PostgreSQL repository (ARCHIVED)
    log_info "Testing connectivity to PostgreSQL archived repository"
    if curl -s -o /dev/null -w "%{http_code}" https://apt-archive.postgresql.org/pub/repos/apt/dists/focal-pgdg/Release | grep -q "200"; then
        log_success "Archived repository is accessible"
    else
        log_warn "Archived repository may not be accessible (continuing anyway)"
    fi

    # Update package index
    log_info "Updating package index"
    if ! apt-get update 2>&1 | tee /tmp/apt-update.log; then
        log_error "Failed to update package index"
        log_error "APT errors:"
        cat /tmp/apt-update.log
        log_error "Repository file content:"
        cat "$repo_file"
        log_error "Keyring file exists:"
        ls -la /usr/share/keyrings/postgresql-archive-keyring.gpg || echo "NOT FOUND"
        return 1
    fi

    log_success "PostgreSQL repository added"
    return 0
}

# Install PostgreSQL packages
install_postgresql() {
    log_info "Installing PostgreSQL ${POSTGRES_VERSION}"

    # Install PostgreSQL server and contrib
    if ! install_package postgresql-${POSTGRES_VERSION}; then
        log_error "Failed to install postgresql-${POSTGRES_VERSION}"
        return 1
    fi

    if ! install_package postgresql-contrib-${POSTGRES_VERSION}; then
        log_error "Failed to install postgresql-contrib-${POSTGRES_VERSION}"
        return 1
    fi

    # Start PostgreSQL service
    if ! start_service postgresql; then
        log_error "Failed to start PostgreSQL service"
        return 1
    fi

    # Wait for PostgreSQL to be ready
    log_info "Waiting for PostgreSQL to be ready"
    if ! postgres_wait_ready 30; then
        log_error "PostgreSQL did not start within 30 seconds"
        return 1
    fi

    log_success "PostgreSQL installed and started"
    return 0
}

# Configure PostgreSQL for remote access
configure_postgresql() {
    log_info "Configuring PostgreSQL for remote access"

    local pg_hba_conf="/etc/postgresql/${POSTGRES_VERSION}/main/pg_hba.conf"
    local postgresql_conf="/etc/postgresql/${POSTGRES_VERSION}/main/postgresql.conf"

    # Validate config files exist
    if ! validate_file_exists "$pg_hba_conf"; then
        log_error "Config file not found: $pg_hba_conf"
        return 1
    fi

    if ! validate_file_exists "$postgresql_conf"; then
        log_error "Config file not found: $postgresql_conf"
        return 1
    fi

    # Configure pg_hba.conf for remote access
    log_info "Configuring pg_hba.conf for remote access"

    # Backup pg_hba.conf
    if ! backup_file "$pg_hba_conf"; then
        log_error "Failed to backup pg_hba.conf"
        return 1
    fi

    # Add rule to allow connections from 192.168.56.0/24 with md5 authentication
    local remote_rule="host    all             all             192.168.56.0/24         md5"

    if ! grep -q "192.168.56.0/24" "$pg_hba_conf"; then
        echo "" >> "$pg_hba_conf"
        echo "# Allow connections from host-only network" >> "$pg_hba_conf"
        echo "$remote_rule" >> "$pg_hba_conf"
        log_success "Added remote access rule to pg_hba.conf"
    else
        log_warn "Remote access rule already exists in pg_hba.conf"
    fi

    # Configure postgresql.conf to listen on all addresses
    log_info "Configuring postgresql.conf to listen on all addresses"

    # Backup postgresql.conf
    if ! backup_file "$postgresql_conf"; then
        log_error "Failed to backup postgresql.conf"
        return 1
    fi

    # Set listen_addresses
    if grep -q "^listen_addresses" "$postgresql_conf"; then
        sed -i "s/^listen_addresses.*/listen_addresses = '*'/" "$postgresql_conf"
    elif grep -q "^#listen_addresses" "$postgresql_conf"; then
        sed -i "s/^#listen_addresses.*/listen_addresses = '*'/" "$postgresql_conf"
    else
        echo "listen_addresses = '*'" >> "$postgresql_conf"
    fi

    # Verify the change was made
    if ! grep -q "listen_addresses = '\*'" "$postgresql_conf"; then
        log_error "Failed to set listen_addresses"
        return 1
    fi

    log_success "Configuration updated"

    # Restart PostgreSQL to apply changes
    log_info "Restarting PostgreSQL to apply configuration"
    if ! restart_service postgresql; then
        log_error "Failed to restart PostgreSQL"
        return 1
    fi

    # Wait for PostgreSQL to be ready again
    if ! postgres_wait_ready 30; then
        log_error "PostgreSQL did not restart within 30 seconds"
        return 1
    fi

    log_success "PostgreSQL configured for remote access"
    return 0
}

# Set postgres user password
set_postgres_password() {
    log_info "Setting postgres user password"

    # Set password for postgres user
    if ! sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';" 2>/dev/null; then
        log_error "Failed to set postgres password"
        return 1
    fi

    log_success "Postgres password set successfully"
    return 0
}

# Note: main() is called by bootstrap.sh, not auto-executed
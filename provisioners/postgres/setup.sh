#!/bin/bash
# setup.sh
# PostgreSQL database setup script
# Version: 1.0.0

set -euo pipefail

# Load utilities
source /vagrant/utils/core.sh
source /vagrant/utils/database.sh
source /vagrant/utils/logging.sh
source /vagrant/utils/validation.sh

# Main function
main() {
    log_header "PostgreSQL Database Setup (Mejorado v1.1.0)"

    # Validate running as root
    if ! validate_root; then
        log_fatal "This script must be run as root"
    fi

    # Validate required variables
    require_vars DB_NAME DB_USER DB_PASSWORD

    # Ensure log directory
    if ! ensure_dir /vagrant/logs; then
        log_error "Failed to create log directory"
        return 1
    fi

    # Verify PostgreSQL is running
    if ! verify_postgresql_running; then
        log_error "PostgreSQL is not running"
        return 1
    fi

    # Create database user
    if ! create_database_user; then
        log_error "Failed to create database user"
        return 1
    fi

    # Create database
    if ! create_database; then
        log_error "Failed to create database"
        return 1
    fi

    # Grant privileges (MEJORADO - arregla permisos de schema public)
    if ! grant_user_privileges; then
        log_error "Failed to grant privileges"
        return 1
    fi

    # Install extensions
    if ! install_extensions; then
        log_error "Failed to install extensions"
        return 1
    fi

    # Create schema version table
    if ! create_schema_version_table; then
        log_error "Failed to create schema version table"
        return 1
    fi

    # Verify connectivity (NEW - verify permissions are correct)
    if ! verify_database_connectivity; then
        log_error "Failed to verify database connectivity"
        return 1
    fi

    log_success "PostgreSQL database setup completed successfully!"

    # Print summary (NEW)
    print_setup_summary

    return 0
}

# Verify PostgreSQL is running
verify_postgresql_running() {
    log_info "Verifying PostgreSQL is running"

    if ! systemctl is-active --quiet postgresql; then
        log_error "PostgreSQL service is not active"
        return 1
    fi

    # Wait for PostgreSQL to be ready
    if ! postgres_wait_ready 30; then
        log_error "PostgreSQL is not ready to accept connections"
        return 1
    fi

    log_success "PostgreSQL is running and ready"
    return 0
}

# Create database user (idempotent)
create_database_user() {
    log_info "Creating database user: ${DB_USER}"

    # Check if user already exists
    local user_exists=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${DB_USER}';" 2>/dev/null || echo "")

    if [[ "$user_exists" == "1" ]]; then
        log_warn "User ${DB_USER} already exists, updating password..."

        # Update password for existing user (idempotent)
        if ! sudo -u postgres psql -c "ALTER USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}';" 2>/dev/null; then
            log_error "Failed to update user password"
            return 1
        fi

        # Ensure user can login
        if ! sudo -u postgres psql -c "ALTER USER ${DB_USER} WITH LOGIN;" 2>/dev/null; then
            log_warn "Failed to enable login (user may already have it)"
        fi

        log_success "User ${DB_USER} password updated"
        return 0
    fi

    # Create user
    if ! postgres_create_user "${DB_USER}" "${DB_PASSWORD}"; then
        log_error "Failed to create user"
        return 1
    fi

    log_success "User ${DB_USER} created successfully"
    return 0
}

# Create database
create_database() {
    log_info "Creating database: ${DB_NAME}"

    # Check if database already exists
    if postgres_database_exists "${DB_NAME}"; then
        log_warn "Database ${DB_NAME} already exists, skipping creation"
        return 0
    fi

    # Create database
    if ! postgres_create_database "${DB_NAME}"; then
        log_error "Failed to create database"
        return 1
    fi

    log_success "Database ${DB_NAME} created successfully"
    return 0
}

# Grant privileges to user (MEJORADO - arregla permisos de schema public)
grant_user_privileges() {
    log_info "Granting privileges to user: ${DB_USER}"

    # Grant all privileges on the database
    if ! postgres_grant_privileges "${DB_NAME}" "${DB_USER}"; then
        log_error "Failed to grant database privileges"
        return 1
    fi

    # ========== CRITICAL FIX: Schema public permissions ==========
    # Este es el arreglo para el error: "permission denied for schema public"

    log_info "Fixing schema 'public' permissions for ${DB_USER}..."

    # Grant USAGE on schema public
    if ! sudo -u postgres psql -d "${DB_NAME}" -c "GRANT USAGE ON SCHEMA public TO ${DB_USER};" 2>/dev/null; then
        log_warn "Failed to grant USAGE on schema public (may already be granted)"
    fi

    # Grant CREATE on schema public (para que pueda crear tablas)
    if ! sudo -u postgres psql -d "${DB_NAME}" -c "GRANT CREATE ON SCHEMA public TO ${DB_USER};" 2>/dev/null; then
        log_warn "Failed to grant CREATE on schema public (may already be granted)"
    fi

    # Grant all privileges on all existing tables
    if ! sudo -u postgres psql -d "${DB_NAME}" -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${DB_USER};" 2>/dev/null; then
        log_warn "Failed to grant privileges on all tables (may already be granted)"
    fi

    # Grant all privileges on all sequences (para auto-increment)
    if ! sudo -u postgres psql -d "${DB_NAME}" -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${DB_USER};" 2>/dev/null; then
        log_warn "Failed to grant privileges on all sequences (may already be granted)"
    fi

    # Grant all privileges on all functions
    if ! sudo -u postgres psql -d "${DB_NAME}" -c "GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO ${DB_USER};" 2>/dev/null; then
        log_warn "Failed to grant privileges on all functions (may already be granted)"
    fi

    # Set default privileges para FUTURAS tablas (idempotente)
    if ! sudo -u postgres psql -d "${DB_NAME}" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO ${DB_USER};" 2>/dev/null; then
        log_warn "Failed to set default table privileges (may already be set)"
    fi

    if ! sudo -u postgres psql -d "${DB_NAME}" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO ${DB_USER};" 2>/dev/null; then
        log_warn "Failed to set default sequence privileges (may already be set)"
    fi

    log_success "All privileges granted to ${DB_USER} on ${DB_NAME}"
    return 0
}

# Install PostgreSQL extensions (idempotent)
install_extensions() {
    log_info "Installing PostgreSQL extensions"

    local extensions=(
        "uuid-ossp"
        "pg_trgm"
        "hstore"
        "citext"
        "pg_stat_statements"
    )

    local installed_count=0
    local skipped_count=0
    local failed_count=0

    for extension in "${extensions[@]}"; do
        log_info "Processing extension: ${extension}"

        # Check if extension is already installed
        local ext_exists=$(sudo -u postgres psql -d "${DB_NAME}" -tAc "SELECT 1 FROM pg_extension WHERE extname='${extension}';" 2>/dev/null || echo "")

        if [[ "$ext_exists" == "1" ]]; then
            log_warn "Extension ${extension} already installed, skipping"
            skipped_count=$((skipped_count + 1))
            continue
        fi

        # Install extension (idempotent con CREATE EXTENSION IF NOT EXISTS)
        if sudo -u postgres psql -d "${DB_NAME}" -c "CREATE EXTENSION IF NOT EXISTS \"${extension}\";" 2>/dev/null; then
            log_success "Extension ${extension} installed"
            installed_count=$((installed_count + 1))
        else
            # Algunas extensiones pueden no estar disponibles - no es error fatal
            log_warn "Extension ${extension} not available or failed to install (optional)"
            failed_count=$((failed_count + 1))
        fi
    done

    log_info "Extensions processed - Installed: ${installed_count}, Already present: ${skipped_count}, Unavailable: ${failed_count}"

    # No fallar si alguna extensión no está disponible (son opcionales)
    return 0
}

# Create schema version table (idempotent)
create_schema_version_table() {
    log_info "Creating schema version table"

    # Create a table to track schema version (idempotent - IF NOT EXISTS)
    local sql="
    CREATE TABLE IF NOT EXISTS schema_version (
        id SERIAL PRIMARY KEY,
        version VARCHAR(50) NOT NULL UNIQUE,
        description VARCHAR(255),
        applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    CREATE INDEX IF NOT EXISTS idx_schema_version ON schema_version(version);
    "

    if ! sudo -u postgres psql -d "${DB_NAME}" -c "${sql}" 2>/dev/null; then
        log_error "Failed to create schema_version table"
        return 1
    fi

    # Insert initial version (ON CONFLICT DO NOTHING - idempotent)
    local insert_sql="
    INSERT INTO schema_version (version, description)
    VALUES ('1.0.0', 'Initial database schema')
    ON CONFLICT (version) DO NOTHING;
    "

    if ! sudo -u postgres psql -d "${DB_NAME}" -c "${insert_sql}" 2>/dev/null; then
        log_warn "Failed to insert initial schema version (may already exist)"
    fi

    log_success "Schema version table created"
    return 0
}

# Verify database connectivity
verify_database_connectivity() {
    log_info "Verifying database connectivity..."

    # Verify tables can be created (esto comprueba que los permisos están correctos)
    local test_sql="
    CREATE TABLE IF NOT EXISTS django_migrations_test (
        id SERIAL PRIMARY KEY,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    DROP TABLE IF EXISTS django_migrations_test;
    "

    if ! sudo -u postgres psql -d "${DB_NAME}" -c "${test_sql}" 2>/dev/null; then
        log_error "Failed to verify database connectivity - permissions may be incorrect"
        return 1
    fi

    log_success "Database connectivity verified - user can create tables"
    return 0
}

# Print setup summary
print_setup_summary() {
    echo ""
    echo "========================================================================"
    echo "PostgreSQL Setup Summary"
    echo "========================================================================"
    echo ""
    echo "Configuration Applied:"
    echo "  Database Name: ${DB_NAME}"
    echo "  Database User: ${DB_USER}"
    echo "  PostgreSQL Host: 192.168.56.11 (Vagrant)"
    echo "  PostgreSQL Port: 5432"
    echo ""
    echo "Django Settings (config/settings/base.py):"
    echo ""
    echo "  DATABASES = {"
    echo "      'default': {"
    echo "          'ENGINE': 'django.db.backends.postgresql',"
    echo "          'NAME': '${DB_NAME}',"
    echo "          'USER': '${DB_USER}',"
    echo "          'PASSWORD': '${DB_PASSWORD}',"
    echo "          'HOST': '192.168.56.11',"
    echo "          'PORT': '5432',"
    echo "          'CONN_MAX_AGE': 600,"
    echo "      }"
    echo "  }"
    echo ""
    echo "Next Steps:"
    echo "  1. Exit Vagrant: exit"
    echo "  2. From your local machine, run migrations:"
    echo "     python manage.py migrate"
    echo "  3. Verify setup:"
    echo "     python manage.py check"
    echo ""
    echo "========================================================================"
    echo ""
}

# Note: main() is called by bootstrap.sh, not auto-executed
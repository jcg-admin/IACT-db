#!/bin/bash
# IACT DevBox - Database Utilities
# Version: 0.1.0
# Description: Database operations for MariaDB and PostgreSQL

set -euo pipefail

# =============================================================================
# DEPENDENCIES
# =============================================================================

# Load required dependencies
UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${UTILS_DIR}/logging.sh"
# shellcheck disable=SC1091
source "${UTILS_DIR}/core.sh"

# =============================================================================
# MARIADB/MYSQL OPERATIONS
# =============================================================================

mysql_is_running() {
    is_service_active "mariadb" || is_service_active "mysql"
}

mysql_wait_ready() {
    local timeout=${1:-30}
    local elapsed=0

    log_info "Waiting for MySQL/MariaDB to be ready..."

    while ! mysqladmin ping --silent 2>/dev/null; do
        [[ $elapsed -ge $timeout ]] && {
            log_error "MySQL/MariaDB not ready after ${timeout}s"
            return 1
        }
        sleep 1
        ((elapsed++))
    done

    log_success "MySQL/MariaDB is ready"
}

mysql_execute() {
    local sql=$1
    local user=${2:-root}
    local password=${3:-}

    if [[ -n "$password" ]]; then
        mysql -u"$user" -p"$password" -e "$sql" 2>/dev/null
    else
        mysql -u"$user" -e "$sql" 2>/dev/null
    fi
}

mysql_database_exists() {
    local database=$1
    local user=${2:-root}
    local password=${3:-}

    local result
    if [[ -n "$password" ]]; then
        result=$(mysql -u"$user" -p"$password" -e "SHOW DATABASES LIKE '${database}';" 2>/dev/null | tail -1)
    else
        result=$(mysql -u"$user" -e "SHOW DATABASES LIKE '${database}';" 2>/dev/null | tail -1)
    fi

    [[ "$result" == "$database" ]]
}

mysql_user_exists() {
    local username=$1
    local user=${2:-root}
    local password=${3:-}

    local result
    if [[ -n "$password" ]]; then
        result=$(mysql -u"$user" -p"$password" -e "SELECT User FROM mysql.user WHERE User='${username}';" 2>/dev/null | tail -1)
    else
        result=$(mysql -u"$user" -e "SELECT User FROM mysql.user WHERE User='${username}';" 2>/dev/null | tail -1)
    fi

    [[ "$result" == "$username" ]]
}

mysql_create_database() {
    local database=$1
    local charset=${2:-utf8mb4}
    local collation=${3:-utf8mb4_unicode_ci}
    local user=${4:-root}
    local password=${5:-}

    if mysql_database_exists "$database" "$user" "$password"; then
        log_info "Database already exists: ${database}"
        return 0
    fi

    log_info "Creating database: ${database}"
    mysql_execute "CREATE DATABASE \`${database}\` CHARACTER SET ${charset} COLLATE ${collation};" "$user" "$password"
    log_success "Database created: ${database}"
}

mysql_create_user() {
    local username=$1
    local password=$2
    local host=${3:-%}
    local admin_user=${4:-root}
    local admin_password=${5:-}

    if mysql_user_exists "$username" "$admin_user" "$admin_password"; then
        log_info "User already exists: ${username}"
        return 0
    fi

    log_info "Creating user: ${username}@${host}"
    mysql_execute "CREATE USER '${username}'@'${host}' IDENTIFIED BY '${password}';" "$admin_user" "$admin_password"
    log_success "User created: ${username}@${host}"
}

mysql_grant_privileges() {
    local database=$1
    local username=$2
    local host=${3:-%}
    local user=${4:-root}
    local password=${5:-}

    log_info "Granting privileges on ${database} to ${username}@${host}"
    mysql_execute "GRANT ALL PRIVILEGES ON \`${database}\`.* TO '${username}'@'${host}';" "$user" "$password"
    mysql_execute "FLUSH PRIVILEGES;" "$user" "$password"
    log_success "Privileges granted"
}

# =============================================================================
# POSTGRESQL OPERATIONS
# =============================================================================

postgres_is_running() {
    is_service_active "postgresql"
}

postgres_wait_ready() {
    local timeout=${1:-30}
    local elapsed=0

    log_info "Waiting for PostgreSQL to be ready..."

    while ! sudo -u postgres psql -c "SELECT 1;" &>/dev/null; do
        [[ $elapsed -ge $timeout ]] && {
            log_error "PostgreSQL not ready after ${timeout}s"
            return 1
        }
        sleep 1
        ((elapsed++))
    done

    log_success "PostgreSQL is ready"
}

postgres_execute() {
    local sql=$1
    local database=${2:-postgres}
    local user=${3:-postgres}

    sudo -u "$user" psql -d "$database" -c "$sql" 2>/dev/null
}

postgres_database_exists() {
    local database=$1

    local result
    result=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${database}';" 2>/dev/null)

    [[ "$result" == "1" ]]
}

postgres_user_exists() {
    local username=$1

    local result
    result=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${username}';" 2>/dev/null)

    [[ "$result" == "1" ]]
}

postgres_create_database() {
    local database=$1
    local owner=${2:-postgres}
    local encoding=${3:-UTF8}

    if postgres_database_exists "$database"; then
        log_info "Database already exists: ${database}"
        return 0
    fi

    log_info "Creating database: ${database}"
    sudo -u postgres createdb -O "$owner" -E "$encoding" "$database" 2>/dev/null
    log_success "Database created: ${database}"
}

postgres_create_user() {
    local username=$1
    local password=$2

    if postgres_user_exists "$username"; then
        log_info "User already exists: ${username}"
        return 0
    fi

    log_info "Creating user: ${username}"
    sudo -u postgres psql -c "CREATE USER ${username} WITH PASSWORD '${password}';" 2>/dev/null
    log_success "User created: ${username}"
}

postgres_grant_privileges() {
    local database=$1
    local username=$2

    log_info "Granting privileges on ${database} to ${username}"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ${database} TO ${username};" 2>/dev/null
    log_success "Privileges granted"
}

postgres_allow_remote() {
    local ip_range=${1:-0.0.0.0/0}
    local pg_hba="/etc/postgresql/*/main/pg_hba.conf"

    log_info "Configuring PostgreSQL for remote access from ${ip_range}"

    # Add to pg_hba.conf
    echo "host    all             all             ${ip_range}            md5" >> $pg_hba

    # Update postgresql.conf
    local pg_conf="/etc/postgresql/*/main/postgresql.conf"
    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" $pg_conf

    restart_service "postgresql"
    log_success "Remote access configured"
}

# =============================================================================
# GENERIC DATABASE OPERATIONS
# =============================================================================

wait_for_database() {
    local db_type=$1
    local timeout=${2:-30}

    case "$db_type" in
        mysql|mariadb)
            mysql_wait_ready "$timeout"
            ;;
        postgres|postgresql)
            postgres_wait_ready "$timeout"
            ;;
        *)
            log_error "Unknown database type: ${db_type}"
            return 1
            ;;
    esac
}

test_db_connection() {
    local db_type=$1
    local host=$2
    local port=$3
    local database=$4
    local username=$5
    local password=$6

    log_info "Testing ${db_type} connection to ${host}:${port}/${database}"

    case "$db_type" in
        mysql|mariadb)
            mysql -h"$host" -P"$port" -u"$username" -p"$password" -e "SELECT 1;" "$database" &>/dev/null
            ;;
        postgres|postgresql)
            PGPASSWORD="$password" psql -h "$host" -p "$port" -U "$username" -d "$database" -c "SELECT 1;" &>/dev/null
            ;;
        *)
            log_error "Unknown database type: ${db_type}"
            return 1
            ;;
    esac

    if [[ $? -eq 0 ]]; then
        log_success "Connection successful"
        return 0
    else
        log_error "Connection failed"
        return 1
    fi
}

# =============================================================================
# EXPORTS
# =============================================================================

export -f mysql_is_running mysql_wait_ready mysql_execute
export -f mysql_database_exists mysql_user_exists
export -f mysql_create_database mysql_create_user mysql_grant_privileges
export -f postgres_is_running postgres_wait_ready postgres_execute
export -f postgres_database_exists postgres_user_exists
export -f postgres_create_database postgres_create_user postgres_grant_privileges
export -f postgres_allow_remote
export -f wait_for_database test_db_connection
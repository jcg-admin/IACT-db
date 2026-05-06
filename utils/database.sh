#!/bin/bash
# =============================================================================
# utils/database.sh — Funciones de base de datos para IACT DevBox
# =============================================================================
# Versión: 1.1.0 — Fusión IACT-db + mejoras IACT-api
#
# IACT-db aportó:
#   · Funciones CRUD completas para MariaDB y PostgreSQL
#   · test_db_connection, wait_for_database
#
# IACT-api v1.1.0 aportó:
#   · mariadb_is_running(): detección socket Unix primero, TCP después
#   · mariadb_cleanup_stale(): limpia PID/sock de procesos muertos
#   · mariadb_wait_ready(): polling activo con timeout explícito
#   · db_start_mariadb(): arranque con mariadbd (reemplaza mysqld_safe)
#   · db_start_postgres(): arranque con pg_ctlcluster
#
# Depende de: logging.sh, network.sh (deben cargarse antes)
# =============================================================================

set -euo pipefail

# Rutas de socket conocidas de MariaDB/MySQL en Ubuntu/Debian
_MARIADB_SOCKETS=(
    "/run/mysqld/mysqld.sock"
    "/var/run/mysqld/mysqld.sock"
    "/tmp/mysql.sock"
)

_MARIADB_PID_FILE="/run/mysqld/mysqld.pid"

# =============================================================================
# DETECCIÓN Y ARRANQUE — MariaDB
# =============================================================================

# mariadb_is_running [host] [puerto]
#   Verifica si MariaDB está aceptando conexiones.
#   Orden: socket Unix → TCP → conectividad TCP sin auth.
mariadb_is_running() {
    local host="${1:-127.0.0.1}"
    local port="${2:-3306}"

    if command -v mysqladmin &>/dev/null; then
        for sock in "${_MARIADB_SOCKETS[@]}"; do
            if [[ -S "$sock" ]]; then
                if mysqladmin --socket="$sock" ping --silent >/dev/null 2>&1; then
                    return 0
                fi
            fi
        done
        if mysqladmin ping --silent --host="$host" --port="$port" >/dev/null 2>&1; then
            return 0
        fi
    fi

    can_reach_port "$host" "$port" 3 2>/dev/null || return 1
}

mysql_is_running() { mariadb_is_running "$@"; }

# mariadb_cleanup_stale
#   Limpia archivos PID/socket huérfanos de un proceso MariaDB muerto.
mariadb_cleanup_stale() {
    log_info "Comprobando archivos stale de MariaDB..."

    if [[ -f "$_MARIADB_PID_FILE" ]]; then
        local pid
        pid=$(cat "$_MARIADB_PID_FILE" 2>/dev/null || echo "")
        if [[ -n "$pid" ]] && ! kill -0 "$pid" 2>/dev/null; then
            log_warn "PID $pid huérfano en $_MARIADB_PID_FILE — eliminando"
            rm -f "$_MARIADB_PID_FILE"
        fi
    fi

    for sock in "${_MARIADB_SOCKETS[@]}"; do
        if [[ -S "$sock" ]]; then
            if ! mysqladmin --socket="$sock" ping --silent >/dev/null 2>&1; then
                log_warn "Socket huérfano: $sock — eliminando"
                rm -f "$sock"
            fi
        fi
    done

    log_success "Verificación de archivos stale completada"
}

# mariadb_wait_ready [timeout_segundos]
mariadb_wait_ready() {
    local timeout="${1:-30}"
    local elapsed=0

    log_info "Esperando MariaDB (máx. ${timeout}s)..."

    while ! mariadb_is_running; do
        if [[ $elapsed -ge $timeout ]]; then
            log_error "MariaDB no respondió en ${timeout}s"
            return 1
        fi
        sleep 1
        (( elapsed++ ))
    done

    log_success "MariaDB listo (${elapsed}s)"
}

mysql_wait_ready() { mariadb_wait_ready "$@"; }

_mariadb_start_systemd() {
    if command -v systemctl &>/dev/null && systemctl --version &>/dev/null 2>&1; then
        systemctl start mariadb 2>/dev/null && return 0
        systemctl start mysql   2>/dev/null && return 0
    fi
    if command -v service &>/dev/null; then
        service mariadb start 2>/dev/null && return 0
        service mysql start   2>/dev/null && return 0
    fi
    return 1
}

_mariadb_start_direct() {
    local daemon
    if   command -v mariadbd &>/dev/null; then daemon="mariadbd"
    elif command -v mysqld   &>/dev/null; then daemon="mysqld"
    else
        log_error "No se encontró mariadbd ni mysqld"
        return 1
    fi

    log_info "Arrancando $daemon directamente (sin systemd)..."
    mkdir -p /run/mysqld
    chown mysql:mysql /run/mysqld 2>/dev/null || true

    nohup su -s /bin/bash mysql -c \
        "$daemon \
         --datadir=/var/lib/mysql \
         --socket=/run/mysqld/mysqld.sock \
         --pid-file=$_MARIADB_PID_FILE \
         --log-error=/var/log/mysql/error.log \
         --bind-address=127.0.0.1 \
         --port=3306" \
        >/tmp/mariadbd_startup.log 2>&1 &
}

# db_start_mariadb [timeout]
#   Arranca MariaDB si no está corriendo.
db_start_mariadb() {
    local timeout="${1:-30}"

    if mariadb_is_running; then
        log_info "MariaDB ya está corriendo"
        return 0
    fi

    mariadb_cleanup_stale

    if _mariadb_start_systemd; then
        mariadb_wait_ready "$timeout" && return 0
    fi

    _mariadb_start_direct
    mariadb_wait_ready "$timeout"
}

# =============================================================================
# DETECCIÓN Y ARRANQUE — PostgreSQL
# =============================================================================

pg_is_running() {
    local host="${1:-127.0.0.1}"
    local port="${2:-5432}"

    if command -v pg_isready &>/dev/null; then
        pg_isready -h "$host" -p "$port" -q 2>/dev/null
        return $?
    fi

    can_reach_port "$host" "$port" 3 2>/dev/null || return 1
}

postgres_is_running() { pg_is_running "$@"; }

postgres_wait_ready() {
    local timeout="${1:-30}"
    local elapsed=0

    log_info "Esperando PostgreSQL (máx. ${timeout}s)..."

    while ! pg_is_running; do
        if [[ $elapsed -ge $timeout ]]; then
            log_error "PostgreSQL no respondió en ${timeout}s"
            return 1
        fi
        sleep 1
        (( elapsed++ ))
    done

    log_success "PostgreSQL listo (${elapsed}s)"
}

# db_start_postgres [version] [timeout]
db_start_postgres() {
    local version="${1:-16}"
    local timeout="${2:-30}"

    if pg_is_running; then
        log_info "PostgreSQL ya está corriendo"
        return 0
    fi

    if command -v systemctl &>/dev/null && systemctl --version &>/dev/null 2>&1; then
        systemctl start postgresql 2>/dev/null && {
            postgres_wait_ready "$timeout" && return 0
        }
    fi

    if command -v service &>/dev/null; then
        service postgresql start 2>/dev/null && {
            postgres_wait_ready "$timeout" && return 0
        }
    fi

    if command -v pg_ctlcluster &>/dev/null; then
        log_info "Arrancando via pg_ctlcluster ${version} main..."
        pg_ctlcluster "$version" main start 2>/dev/null && {
            postgres_wait_ready "$timeout" && return 0
        }
    fi

    log_error "No se pudo arrancar PostgreSQL"
    return 1
}

# =============================================================================
# CRUD — MariaDB
# =============================================================================

mysql_execute() {
    local sql="$1"
    local user="${2:-root}"
    local password="${3:-}"

    if [[ -n "$password" ]]; then
        mysql -u"$user" -p"$password" -e "$sql" 2>/dev/null
    else
        mysql -u"$user" -e "$sql" 2>/dev/null
    fi
}

mysql_database_exists() {
    local database="$1"
    local user="${2:-root}"
    local password="${3:-}"

    local result
    if [[ -n "$password" ]]; then
        result=$(mysql -u"$user" -p"$password" \
            -e "SHOW DATABASES LIKE '${database}';" 2>/dev/null | tail -1)
    else
        result=$(mysql -u"$user" \
            -e "SHOW DATABASES LIKE '${database}';" 2>/dev/null | tail -1)
    fi

    [[ "$result" == "$database" ]]
}

mysql_user_exists() {
    local username="$1"
    local user="${2:-root}"
    local password="${3:-}"

    local result
    if [[ -n "$password" ]]; then
        result=$(mysql -u"$user" -p"$password" \
            -e "SELECT User FROM mysql.user WHERE User='${username}';" \
            2>/dev/null | tail -1)
    else
        result=$(mysql -u"$user" \
            -e "SELECT User FROM mysql.user WHERE User='${username}';" \
            2>/dev/null | tail -1)
    fi

    [[ "$result" == "$username" ]]
}

mysql_create_database() {
    local database="$1"
    local charset="${2:-utf8mb4}"
    local collation="${3:-utf8mb4_unicode_ci}"
    local user="${4:-root}"
    local password="${5:-}"

    if mysql_database_exists "$database" "$user" "$password"; then
        log_info "Base de datos ya existe: ${database}"
        return 0
    fi

    log_info "Creando base de datos: ${database}"
    mysql_execute \
        "CREATE DATABASE \`${database}\` CHARACTER SET ${charset} COLLATE ${collation};" \
        "$user" "$password"
    log_success "Base de datos creada: ${database}"
}

mysql_create_user() {
    local username="$1"
    local password="$2"
    local host="${3:-%}"
    local admin_user="${4:-root}"
    local admin_password="${5:-}"

    if mysql_user_exists "$username" "$admin_user" "$admin_password"; then
        log_info "Usuario ya existe: ${username}@${host} — actualizando contraseña"
        mysql_execute \
            "ALTER USER '${username}'@'${host}' IDENTIFIED BY '${password}';" \
            "$admin_user" "$admin_password"
        return 0
    fi

    log_info "Creando usuario: ${username}@${host}"
    mysql_execute \
        "CREATE USER '${username}'@'${host}' IDENTIFIED BY '${password}';" \
        "$admin_user" "$admin_password"
    log_success "Usuario creado: ${username}@${host}"
}

mysql_grant_privileges() {
    local database="$1"
    local username="$2"
    local host="${3:-%}"
    local user="${4:-root}"
    local password="${5:-}"

    log_info "Otorgando ALL PRIVILEGES en ${database} a ${username}@${host}"
    mysql_execute \
        "GRANT ALL PRIVILEGES ON \`${database}\`.* TO '${username}'@'${host}';" \
        "$user" "$password"
    mysql_execute "FLUSH PRIVILEGES;" "$user" "$password"
    log_success "Privilegios otorgados"
}

mysql_grant_readonly() {
    local database="$1"
    local username="$2"
    local host="${3:-%}"
    local user="${4:-root}"
    local password="${5:-}"

    log_info "Otorgando SELECT (READ-ONLY) en ${database} a ${username}@${host}"
    mysql_execute \
        "GRANT SELECT ON \`${database}\`.* TO '${username}'@'${host}';" \
        "$user" "$password"
    mysql_execute "FLUSH PRIVILEGES;" "$user" "$password"
    log_success "Privilegios READ-ONLY otorgados"
}

# =============================================================================
# CRUD — PostgreSQL
# =============================================================================

postgres_execute() {
    local sql="$1"
    local database="${2:-postgres}"
    local user="${3:-postgres}"

    sudo -u "$user" psql -d "$database" -c "$sql" 2>/dev/null
}

postgres_database_exists() {
    local database="$1"
    local result
    result=$(sudo -u postgres psql -tAc \
        "SELECT 1 FROM pg_database WHERE datname='${database}';" 2>/dev/null)
    [[ "$result" == "1" ]]
}

postgres_user_exists() {
    local username="$1"
    local result
    result=$(sudo -u postgres psql -tAc \
        "SELECT 1 FROM pg_roles WHERE rolname='${username}';" 2>/dev/null)
    [[ "$result" == "1" ]]
}

postgres_create_database() {
    local database="$1"
    local owner="${2:-postgres}"
    local encoding="${3:-UTF8}"

    if postgres_database_exists "$database"; then
        log_info "Base de datos ya existe: ${database}"
        return 0
    fi

    log_info "Creando base de datos: ${database}"
    sudo -u postgres createdb -O "$owner" -E "$encoding" "$database" 2>/dev/null
    log_success "Base de datos creada: ${database}"
}

postgres_create_user() {
    local username="$1"
    local password="$2"

    if postgres_user_exists "$username"; then
        log_info "Usuario ya existe: ${username} — actualizando contraseña"
        sudo -u postgres psql -c \
            "ALTER USER ${username} WITH PASSWORD '${password}';" 2>/dev/null
        return 0
    fi

    log_info "Creando usuario: ${username}"
    sudo -u postgres psql -c \
        "CREATE USER ${username} WITH PASSWORD '${password}';" 2>/dev/null
    log_success "Usuario creado: ${username}"
}

postgres_grant_privileges() {
    local database="$1"
    local username="$2"

    log_info "Otorgando privilegios completos en ${database} a ${username}"

    sudo -u postgres psql -d "$database" <<SQL 2>/dev/null
GRANT ALL PRIVILEGES ON DATABASE ${database} TO ${username};
GRANT ALL ON SCHEMA public TO ${username};
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${username};
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${username};
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO ${username};
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO ${username};
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO ${username};
ALTER ROLE ${username} CREATEDB;
SQL

    log_success "Privilegios otorgados a ${username} en ${database}"
}

postgres_allow_remote() {
    local ip_range="${1:-0.0.0.0/0}"
    local pg_version="${2:-16}"
    local pg_hba="/etc/postgresql/${pg_version}/main/pg_hba.conf"
    local pg_conf="/etc/postgresql/${pg_version}/main/postgresql.conf"

    log_info "Configurando PostgreSQL para acceso remoto desde ${ip_range}"

    if ! grep -q "$ip_range" "$pg_hba" 2>/dev/null; then
        echo "host    all             all             ${ip_range}            md5" \
            >> "$pg_hba"
    fi

    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" \
        "$pg_conf" 2>/dev/null || true

    db_start_postgres "$pg_version" 30
    log_success "Acceso remoto configurado"
}

# =============================================================================
# GENÉRICAS
# =============================================================================

wait_for_database() {
    local db_type="$1"
    local timeout="${2:-30}"

    case "$db_type" in
        mysql|mariadb)       mariadb_wait_ready  "$timeout" ;;
        postgres|postgresql) postgres_wait_ready "$timeout" ;;
        *) log_error "Tipo de BD desconocido: ${db_type}"; return 1 ;;
    esac
}

test_db_connection() {
    local db_type="$1"
    local host="$2"
    local port="$3"
    local database="$4"
    local username="$5"
    local password="$6"

    log_info "Probando conexión ${db_type} a ${host}:${port}/${database}"

    case "$db_type" in
        mysql|mariadb)
            mysql -h"$host" -P"$port" -u"$username" -p"$password" \
                -e "SELECT 1;" "$database" &>/dev/null
            ;;
        postgres|postgresql)
            PGPASSWORD="$password" psql \
                -h "$host" -p "$port" -U "$username" -d "$database" \
                -c "SELECT 1;" &>/dev/null
            ;;
        *) log_error "Tipo de BD desconocido: ${db_type}"; return 1 ;;
    esac

    if [[ $? -eq 0 ]]; then
        log_success "Conexión exitosa"
    else
        log_error "Conexión fallida"
        return 1
    fi
}

# =============================================================================
# EXPORTS
# =============================================================================

export -f mariadb_is_running mysql_is_running
export -f mariadb_cleanup_stale mariadb_wait_ready mysql_wait_ready
export -f db_start_mariadb db_start_postgres
export -f pg_is_running postgres_is_running postgres_wait_ready
export -f mysql_execute mysql_database_exists mysql_user_exists
export -f mysql_create_database mysql_create_user
export -f mysql_grant_privileges mysql_grant_readonly
export -f postgres_execute postgres_database_exists postgres_user_exists
export -f postgres_create_database postgres_create_user
export -f postgres_grant_privileges postgres_allow_remote
export -f wait_for_database test_db_connection

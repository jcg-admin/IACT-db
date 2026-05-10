#!/bin/bash
# =============================================================================
# start.sh — IACT-db: arranca MariaDB y PostgreSQL si no están corriendo
# =============================================================================
# Uso:
#   bash start.sh            # arranca ambas BDs
#   bash start.sh mariadb    # solo MariaDB
#   bash start.sh postgres   # solo PostgreSQL
#
# Flujo de arranque MariaDB:
#   1. Ya está corriendo → nada
#   2. Limpia PID/socket stale
#   3. Intenta via service/systemctl
#   4. Arranca mariadbd directamente (sin systemd)
#   5. Espera hasta 30s
#
# Flujo de arranque PostgreSQL:
#   1. Ya está corriendo → nada
#   2. Limpia PID stale (pg_ctlcluster lo hace solo)
#   3. Intenta pg_ctlcluster → service/systemctl
#   4. Espera hasta 30s
#
# No requiere root si los servicios ya están instalados y configurados.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/database.sh"

# Cargar .env si existe (para leer versiones)
ENV_FILE="${PROJECT_ROOT}/.env"
[[ -f "$ENV_FILE" ]] && { set -a; source "$ENV_FILE"; set +a; }

POSTGRES_VERSION="${POSTGRES_VERSION:-16}"
TARGET="${1:-all}"   # all | mariadb | postgres

# =============================================================================
start_mariadb() {
    log_header "MariaDB"

    if mariadb_is_running; then
        log_success "MariaDB ya está corriendo"
        return 0
    fi

    log_info "MariaDB inactivo — iniciando..."
    mariadb_cleanup_stale

    # Intentar via service/systemctl
    local started=false
    if command -v service &>/dev/null; then
        service mariadb start 2>/dev/null && started=true && \
            log_info "Iniciado via service" || true
    fi
    if ! $started && command -v systemctl &>/dev/null; then
        systemctl start mariadb 2>/dev/null && started=true && \
            log_info "Iniciado via systemctl" || true
    fi

    # Arranque directo con mariadbd (sin init system)
    if ! $started; then
        local daemon
        if   command -v mariadbd &>/dev/null; then daemon="mariadbd"
        elif command -v mysqld    &>/dev/null; then daemon="mysqld"
        else log_error "No se encontró mariadbd ni mysqld"; return 1; fi

        log_info "Arrancando $daemon directamente..."
        mkdir -p /run/mysqld
        chown mysql:mysql /run/mysqld 2>/dev/null || true

        nohup su -s /bin/bash mysql -c \
            "$daemon \
             --datadir=/var/lib/mysql \
             --socket=/run/mysqld/mysqld.sock \
             --pid-file=/run/mysqld/mysqld.pid \
             --log-error=/var/log/mysql/error.log \
             --bind-address=127.0.0.1 \
             --port=3306" \
            >/tmp/mariadbd_start.log 2>&1 &
    fi

    mariadb_wait_ready 30 && log_success "MariaDB activo" || {
        log_error "MariaDB no respondió en 30s"
        log_error "Log: $(tail -5 /tmp/mariadbd_start.log 2>/dev/null || echo 'no disponible')"
        return 1
    }
}

# =============================================================================
start_postgres() {
    log_header "PostgreSQL"

    if pg_is_running; then
        log_success "PostgreSQL ya está corriendo"
        return 0
    fi

    log_info "PostgreSQL inactivo — iniciando..."

    # pg_ctlcluster (más fiable en Ubuntu/Debian)
    if command -v pg_ctlcluster &>/dev/null; then
        pg_ctlcluster "$POSTGRES_VERSION" main start 2>/dev/null && \
            log_info "Iniciado via pg_ctlcluster ${POSTGRES_VERSION}" || true
    fi

    if ! pg_is_running && command -v service &>/dev/null; then
        service postgresql start 2>/dev/null && \
            log_info "Iniciado via service" || true
    fi

    if ! pg_is_running && command -v systemctl &>/dev/null; then
        systemctl start postgresql 2>/dev/null && \
            log_info "Iniciado via systemctl" || true
    fi

    postgres_wait_ready 30 && log_success "PostgreSQL activo" || {
        log_error "PostgreSQL no respondió en 30s"
        return 1
    }
}

# =============================================================================
log_header "IACT-db — Arranque de bases de datos"

case "$TARGET" in
    mariadb)  start_mariadb ;;
    postgres) start_postgres ;;
    all)
        start_mariadb
        echo ""
        start_postgres
        ;;
    *)
        log_error "Uso: bash start.sh [all|mariadb|postgres]"
        exit 1
        ;;
esac

echo ""
log_success "Listo. Ejecuta: bash verify.sh para confirmar el estado."

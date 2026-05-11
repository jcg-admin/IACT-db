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

    # Cadena de arranque: service → systemctl → mariadbd directo
    local started=false

    if command -v service &>/dev/null; then
        log_debug "start_mariadb: intentando via service"
        if service mariadb start 2>/dev/null; then
            # H-SRV-002 (2026-05-10): verificar persistencia 2s después del arranque.
            # En contenedores sin systemd, service mariadb start retorna 0 aunque el
            # proceso muera inmediatamente. Sin esta verificación, started=true pero
            # mariadb_wait_ready espera 30s antes de detectar el problema.
            # Ref: HALLAZGOS-PROVISIONAMIENTO-202605101945.md H-PROV-001
            sleep 2
            if mariadb_is_running; then
                log_info "start_mariadb: iniciado via service (persistencia OK)"
                started=true
            else
                log_warn "start_mariadb: service arrancó pero el proceso no persistió — continuando cadena"
            fi
        else
            log_debug "start_mariadb: service fallo — continuando cadena"
        fi
    fi

    if ! $started && command -v systemctl &>/dev/null; then
        log_debug "start_mariadb: intentando via systemctl"
        if systemctl start mariadb 2>/dev/null; then
            # Misma verificación de persistencia para systemctl
            sleep 2
            if mariadb_is_running; then
                log_info "start_mariadb: iniciado via systemctl (persistencia OK)"
                started=true
            else
                log_warn "start_mariadb: systemctl arrancó pero el proceso no persistió — continuando cadena"
            fi
        else
            log_debug "start_mariadb: systemctl fallo — continuando cadena"
        fi
    fi

    # Arranque directo con mariadbd (sin init system)
    if ! $started; then
        local daemon
        if   command -v mariadbd &>/dev/null; then daemon="mariadbd"
        elif command -v mysqld    &>/dev/null; then daemon="mysqld"
        else
            log_error "start_mariadb: no se encontró mariadbd ni mysqld"
            return 1
        fi

        # H-MDB-007: detectar io_uring antes de arrancar directamente
        local aio_flag=""
        if declare -f _mariadb_io_uring_available &>/dev/null; then
            if ! _mariadb_io_uring_available; then
                aio_flag="--innodb-use-native-aio=0"
                log_debug "start_mariadb: io_uring no disponible — usando ${aio_flag}"
            else
                log_debug "start_mariadb: io_uring disponible"
            fi
        fi

        log_info "start_mariadb: arrancando ${daemon} directamente${aio_flag:+ (${aio_flag})}"
        mkdir -p /run/mysqld
        chown mysql:mysql /run/mysqld 2>/dev/null || true

        nohup su -s /bin/bash mysql -c \
            "${daemon} \
             --datadir=/var/lib/mysql \
             --socket=/run/mysqld/mysqld.sock \
             --pid-file=/run/mysqld/mysqld.pid \
             --log-error=/var/log/mysql/error.log \
             --bind-address=127.0.0.1 \
             --port=3306 \
             ${aio_flag}" \
            >/tmp/mariadbd_start.log 2>&1 &
    fi

    mariadb_wait_ready 30 && log_success "MariaDB activo" || {
        log_error "start_mariadb: MariaDB no respondió en 30s"
        log_error "start_mariadb: ultimas lineas del log:"
        tail -10 /tmp/mariadbd_start.log 2>/dev/null \
            | while IFS= read -r line; do log_error "  ${line}"; done \
            || log_error "  (log no disponible)"
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

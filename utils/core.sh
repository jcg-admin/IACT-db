#!/bin/bash
# IACT DevBox - Core Utilities
# Version: 0.2.0
# Description: Core functions for all provisioning scripts
# Changes v0.2.0 (2026-05-10):
#   - SERVICE OPERATIONS: cadena systemctl → service → pg_ctlcluster/mariadbd con logging
#   - _has_systemd(): deteccion de D-Bus para contenedores
#   - _mariadb_io_uring_available(): deteccion de io_uring (H-MDB-007)
#   - _service_action(): fallback mariadb* con --innodb-use-native-aio=0 automatico
#   - install_package(): forma simple; --fix-missing descartado por inconsistencia
#   - require_command() y retry(): usan log_error/log_warn en lugar de echo raw

set -euo pipefail

# =============================================================================
# FILE SYSTEM OPERATIONS
# =============================================================================

exists_dir() {
    [[ -d "$1" ]]
}

exists_file() {
    [[ -f "$1" ]]
}

is_executable() {
    [[ -x "$1" ]]
}

is_readable() {
    [[ -r "$1" ]]
}

is_writable() {
    [[ -w "$1" ]]
}

# =============================================================================
# DIRECTORY MANAGEMENT
# =============================================================================

ensure_dir() {
    local dir=$1
    [[ -d "$dir" ]] && return 0
    mkdir -p "$dir" || return 1
}

remove_dir() {
    local dir=$1
    [[ ! -d "$dir" ]] && return 0
    rm -rf "$dir" || return 1
}

# =============================================================================
# FILE MANAGEMENT
# =============================================================================

ensure_file() {
    local file=$1
    [[ -f "$file" ]] && return 0
    touch "$file" || return 1
}

remove_file() {
    local file=$1
    [[ ! -f "$file" ]] && return 0
    rm -f "$file" || return 1
}

backup_file() {
    local file=$1
    [[ ! -f "$file" ]] && return 1

    local backup
    backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup" || return 1
}

# =============================================================================
# PERMISSIONS
# =============================================================================

make_exec() {
    local file=$1
    [[ -x "$file" ]] && return 0
    chmod +x "$file" || return 1
}

make_readable() {
    local file=$1
    [[ -r "$file" ]] && return 0
    chmod +r "$file" || return 1
}

set_perms() {
    local file=$1
    local perms=$2
    chmod "$perms" "$file" || return 1
}

set_owner() {
    local file=$1
    local owner=$2
    chown "$owner" "$file" || return 1
}

# =============================================================================
# PATH OPERATIONS
# =============================================================================

get_abs_path() {
    local path=$1
    cd "$(dirname "$path")" && pwd -P
}

get_script_dir() {
    local source="${BASH_SOURCE[0]}"
    while [[ -h "$source" ]]; do
        local dir
        dir="$(cd -P "$(dirname "$source")" && pwd)"
        source="$(readlink "$source")"
        [[ $source != /* ]] && source="$dir/$source"
    done
    cd -P "$(dirname "$source")" && pwd
}

# =============================================================================
# STRING OPERATIONS
# =============================================================================

trim() {
    local str=$1
    echo "$str" | xargs
}

lower() {
    local str=$1
    echo "$str" | tr '[:upper:]' '[:lower:]'
}

upper() {
    local str=$1
    echo "$str" | tr '[:lower:]' '[:upper:]'
}

contains() {
    local haystack=$1
    local needle=$2
    [[ "$haystack" == *"$needle"* ]]
}

starts_with() {
    local str=$1
    local prefix=$2
    [[ "$str" == "$prefix"* ]]
}

ends_with() {
    local str=$1
    local suffix=$2
    [[ "$str" == *"$suffix" ]]
}

# =============================================================================
# PROCESS OPERATIONS
# =============================================================================

is_running() {
    local process=$1
    pgrep -x "$process" &>/dev/null
}

wait_for_process() {
    local process=$1
    local timeout=${2:-30}
    local elapsed=0

    while ! is_running "$process"; do
        [[ $elapsed -ge $timeout ]] && return 1
        sleep 1
        ((elapsed++))
    done
    return 0
}

kill_process() {
    local process=$1
    local signal=${2:-TERM}
    pkill -"$signal" "$process" 2>/dev/null || true
}

# =============================================================================
# SERVICE OPERATIONS
# =============================================================================

# _has_systemd
#   Devuelve 0 si systemctl esta disponible y el bus D-Bus responde.
#   Un systemctl presente pero sin PID 1 activo (contenedor) devuelve 1.
_has_systemd() {
    command -v systemctl &>/dev/null || return 1
    systemctl --version &>/dev/null 2>&1 || return 1
}

# _pg_version_from_service
#   Intenta inferir la version de PostgreSQL para pg_ctlcluster.
#   Orden: variable POSTGRES_VERSION → binario pg_lsclusters → default 16.
_pg_version_from_service() {
    if [[ -n "${POSTGRES_VERSION:-}" ]]; then
        echo "$POSTGRES_VERSION"
        return 0
    fi
    if command -v pg_lsclusters &>/dev/null; then
        pg_lsclusters -h 2>/dev/null | awk 'NR==1{print $1}' | grep -E '^[0-9]+$' \
            && return 0
    fi
    echo "16"
}

# _mariadb_io_uring_available
#   H-MDB-007: detecta si io_uring esta disponible en el kernel actual.
#   MariaDB 10.11+ usa io_uring para AIO de InnoDB por defecto.
#   En Firecracker, Docker con seccomp, y algunos contenedores LXC,
#   la syscall io_uring_setup (425) esta restringida — mariadbd arranca,
#   reporta "ready for connections" y muere inmediatamente sin mensaje de error.
#   Cuando io_uring NO esta disponible, el llamador debe pasar
#   --innodb-use-native-aio=0 al daemon.
_mariadb_io_uring_available() {
    # Metodo 1: /proc/sys/kernel/io_uring_disabled (Linux 5.15+)
    # 0 = habilitado, 1 = solo root, 2 = deshabilitado
    if [[ -f /proc/sys/kernel/io_uring_disabled ]]; then
        local val
        val=$(cat /proc/sys/kernel/io_uring_disabled 2>/dev/null || echo "2")
        [[ "$val" == "0" ]] && return 0
        return 1
    fi

    # Metodo 2: probar la syscall directamente con python3
    if command -v python3 &>/dev/null; then
        python3 -c "
import ctypes, ctypes.util
libc = ctypes.CDLL(ctypes.util.find_library('c'), use_errno=True)
# io_uring_setup(0, NULL) — esperamos EINVAL (22) si disponible, ENOSYS (38) si no
ret = libc.syscall(425, 0, 0)
import ctypes
err = ctypes.get_errno()
# EINVAL significa que la syscall existe pero el arg es invalido — disponible
raise SystemExit(0 if err == 22 else 1)
" 2>/dev/null && return 0
        return 1
    fi

    # Sin metodo de deteccion: asumir no disponible (conservador)
    return 1
}

# _service_action SERVICE ACTION
#   Ejecuta ACTION (start|stop|restart|enable) sobre SERVICE
#   usando la cadena:
#     systemctl → service → pg_ctlcluster (PostgreSQL) | mariadbd directo (MariaDB)
#   Registra en el log que mecanismo se uso o rechazo en cada nivel.
_service_action() {
    local service=$1
    local action=$2

    log_info "service_action: ${action} ${service}"

    # Nivel 1: systemctl
    if _has_systemd; then
        log_debug "service_action: systemctl disponible — intentando systemctl ${action} ${service}"
        if systemctl "$action" "$service" 2>/dev/null; then
            log_success "service_action: ${action} ${service} via systemctl"
            return 0
        fi
        log_warn "service_action: systemctl ${action} ${service} fallo — continuando cadena"
    else
        log_debug "service_action: systemctl no disponible (sin D-Bus o sin PID 1 activo)"
    fi

    # Nivel 2: service
    if command -v service &>/dev/null; then
        log_debug "service_action: intentando service ${service} ${action}"
        if service "$service" "$action" 2>/dev/null; then
            log_success "service_action: ${action} ${service} via service"
            return 0
        fi
        log_warn "service_action: service ${service} ${action} fallo — continuando cadena"
    else
        log_debug "service_action: comando service no disponible"
    fi

    # Nivel 3: fallback especifico por tipo de BD
    case "$service" in

        # PostgreSQL: pg_ctlcluster
        postgresql*)
            if command -v pg_ctlcluster &>/dev/null; then
                local pg_ver
                pg_ver=$(_pg_version_from_service)
                log_debug "service_action: intentando pg_ctlcluster ${pg_ver} main ${action}"
                case "$action" in
                    start|stop|restart)
                        if pg_ctlcluster "$pg_ver" main "$action" 2>/dev/null; then
                            log_success "service_action: ${action} ${service} via pg_ctlcluster ${pg_ver}"
                            return 0
                        fi
                        log_warn "service_action: pg_ctlcluster ${pg_ver} main ${action} fallo"
                        ;;
                    *)
                        log_debug "service_action: pg_ctlcluster no soporta la accion '${action}'"
                        ;;
                esac
            else
                log_debug "service_action: pg_ctlcluster no disponible"
            fi
            ;;

        # H-MDB-002: MariaDB/MySQL — arranque directo de mariadbd/mysqld
        mariadb*|mysql*)
            case "$action" in
                start|restart)
                    local daemon
                    if   command -v mariadbd  &>/dev/null; then daemon="mariadbd"
                    elif command -v mysqld     &>/dev/null; then daemon="mysqld"
                    else
                        log_debug "service_action: mariadbd/mysqld no disponibles"
                        return 1
                    fi

                    log_debug "service_action: intentando arranque directo via ${daemon}"

                    # Limpiar socket/PID stale
                    local pid_file="/run/mysqld/mysqld.pid"
                    if [[ -f "$pid_file" ]] && ! kill -0 "$(cat "$pid_file")" 2>/dev/null; then
                        log_debug "service_action: eliminando PID stale ${pid_file}"
                        rm -f "$pid_file"
                    fi
                    mkdir -p /run/mysqld
                    chown mysql:mysql /run/mysqld 2>/dev/null || true

                    # H-MDB-007: detectar disponibilidad de io_uring
                    # Firecracker y contenedores con seccomp restringen io_uring_setup (syscall 425)
                    # MariaDB 10.11 la usa para InnoDB AIO — si no esta disponible, el daemon
                    # arranca, reporta "ready for connections" y muere inmediatamente sin error visible
                    local aio_flag=""
                    if ! _mariadb_io_uring_available; then
                        aio_flag="--innodb-use-native-aio=0"
                        log_debug "service_action: io_uring no disponible — agregando ${aio_flag}"
                    else
                        log_debug "service_action: io_uring disponible — AIO nativo habilitado"
                    fi

                    nohup su -s /bin/bash mysql -c \
                        "${daemon} \
                         --datadir=/var/lib/mysql \
                         --socket=/run/mysqld/mysqld.sock \
                         --pid-file=${pid_file} \
                         --log-error=/var/log/mysql/error.log \
                         --bind-address=127.0.0.1 \
                         --port=3306 \
                         ${aio_flag}" \
                        >/tmp/mariadbd_startup.log 2>&1 &

                    log_success "service_action: ${action} ${service} via ${daemon} directo (background${aio_flag:+ + ${aio_flag}})"
                    return 0
                    ;;
                stop)
                    local pid_file="/run/mysqld/mysqld.pid"
                    if [[ -f "$pid_file" ]]; then
                        local pid
                        pid=$(cat "$pid_file")
                        kill "$pid" 2>/dev/null && \
                            log_success "service_action: stop ${service} via kill ${pid}" && \
                            return 0
                    fi
                    log_warn "service_action: no se pudo detener ${service} directamente"
                    ;;
                *)
                    log_debug "service_action: accion '${action}' no soportada para arranque directo de ${service}"
                    ;;
            esac
            ;;

    esac

    log_error "service_action: todos los mecanismos fallaron para ${action} ${service}"
    return 1
}

is_service_active() {
    local service=$1
    if _has_systemd; then
        systemctl is-active --quiet "$service" 2>/dev/null
    else
        service "$service" status &>/dev/null 2>&1
    fi
}

is_service_enabled() {
    local service=$1
    if _has_systemd; then
        systemctl is-enabled --quiet "$service" 2>/dev/null
    else
        return 0
    fi
}

start_service() {
    local service=$1
    log_info "start_service: ${service}"
    _service_action "$service" start || return 1
}

stop_service() {
    local service=$1
    log_info "stop_service: ${service}"
    _service_action "$service" stop || return 1
}

restart_service() {
    local service=$1
    log_info "restart_service: ${service}"
    _service_action "$service" restart || return 1
}

enable_service() {
    local service=$1
    if _has_systemd; then
        log_debug "enable_service: systemctl enable ${service}"
        systemctl enable "$service" 2>/dev/null || return 1
        log_success "enable_service: ${service} habilitado via systemctl"
    else
        log_debug "enable_service: systemctl no disponible — omitiendo enable para ${service}"
        return 0
    fi
}

# =============================================================================
# COMMAND AVAILABILITY
# =============================================================================

command_exists() {
    local cmd=$1
    command -v "$cmd" &>/dev/null
}

require_command() {
    local cmd=$1
    command_exists "$cmd" || {
        log_error "Required command not found: ${cmd}"
        return 1
    }
}

# =============================================================================
# PACKAGE OPERATIONS
# =============================================================================

is_package_installed() {
    local package=$1
    dpkg -l "$package" 2>/dev/null | grep -q "^ii"
}

install_package() {
    local package=$1
    is_package_installed "$package" && return 0
    apt-get install -y "$package" || return 1
}

remove_package() {
    local package=$1
    is_package_installed "$package" || return 0
    apt-get remove -y "$package" || return 1
}

# =============================================================================
# SYSTEM INFO
# =============================================================================

get_os_version() {
    lsb_release -rs 2>/dev/null || cat /etc/os-release | grep VERSION_ID | cut -d'"' -f2
}

get_os_codename() {
    lsb_release -cs 2>/dev/null || cat /etc/os-release | grep VERSION_CODENAME | cut -d'=' -f2
}

get_cpu_count() {
    nproc
}

get_total_memory() {
    free -m | awk '/^Mem:/{print $2}'
}

# =============================================================================
# RETRY LOGIC
# =============================================================================

retry() {
    local max_attempts=$1
    shift
    local cmd=("$@")
    local attempt=1

    while [[ $attempt -le $max_attempts ]]; do
        if "${cmd[@]}"; then
            return 0
        fi

        log_warn "retry: comando fallo (intento ${attempt}/${max_attempts}): ${cmd[*]}"
        ((attempt++))
        [[ $attempt -le $max_attempts ]] && sleep 2
    done

    return 1
}

# =============================================================================
# EXPORTS
# =============================================================================

# Export all functions
export -f exists_dir exists_file is_executable is_readable is_writable
export -f ensure_dir remove_dir
export -f ensure_file remove_file backup_file
export -f make_exec make_readable set_perms set_owner
export -f get_abs_path get_script_dir
export -f trim lower upper contains starts_with ends_with
export -f is_running wait_for_process kill_process
export -f _has_systemd _pg_version_from_service _mariadb_io_uring_available _service_action
export -f is_service_active is_service_enabled
export -f start_service stop_service restart_service enable_service
export -f command_exists require_command
export -f is_package_installed install_package remove_package
export -f get_os_version get_os_codename get_cpu_count get_total_memory
export -f retry
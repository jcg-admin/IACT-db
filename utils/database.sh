#!/bin/bash
# =============================================================================
# utils/database.sh — Funciones de base de datos para IACT DevBox
# =============================================================================
# Versión: 1.2.0
#
# v1.1.0 — Fusión IACT-db + mejoras IACT-api:
#   · Funciones CRUD completas para MariaDB y PostgreSQL
#   · test_db_connection, wait_for_database
#   · mariadb_is_running(): detección socket Unix primero, TCP después
#   · mariadb_cleanup_stale(): limpia PID/sock de procesos muertos
#   · mariadb_wait_ready(): polling activo con timeout explícito
#   · db_start_mariadb(): arranque con mariadbd (reemplaza mysqld_safe)
#   · db_start_postgres(): arranque con pg_ctlcluster
#
# v1.2.0 (2026-05-10):
#   MariaDB:
#   · mariadb_cleanup_stale(): log_info → log_debug; detecta proceso vivo vs muerto
#   · mariadb_wait_ready(): fix (( elapsed++ )) → (( ++elapsed )) — con set -euo pipefail,
#     post-incremento desde 0 evalúa (( 0 )) → exit 1 → set -e termina la función
#   · _mariadb_start_systemd() eliminada — reemplazada por tres funciones de nivel:
#     - _mariadb_start_systemctl(): systemctl, detecta y resuelve estado 'failed'
#       con reset-failed, prueba nombres 'mariadb' y 'mysql'
#     - _mariadb_start_service(): service mariadb|mysql start
#     - _mariadb_start_direct(): mariadbd directo con detección io_uring (H-MDB-007)
#   · _mariadb_kill_stale(): shutdown graceful (mysqladmin shutdown via socket)
#     antes de SIGTERM → SIGKILL — limpia PID file y sockets
#   · db_start_mariadb(): reescrito con array de niveles + for loop; mismo patrón
#     que db_start_postgres; kill-and-retry tras fallo de todos los niveles
#
#   PostgreSQL:
#   · _mariadb_start_direct(): detección de io_uring (H-MDB-007)
#   · _pg_start_systemctl(): reset-failed antes de start si en estado 'failed'
#   · _pg_start_service(), _pg_start_ctlcluster(): funciones independientes
#     con logging propio; _pg_start_ctlcluster consulta pg_lsclusters
#   · _pg_cleanup_stale(), _pg_kill_stale(): SIGTERM → SIGKILL con limpieza
#   · db_start_postgres(): array de niveles + for loop; kill-and-retry;
#     usa (( ++level_num )) — mismo fix de pre-incremento que MariaDB
#
# Depende de: logging.sh, network.sh (deben cargarse antes)
# core.sh debe cargarse antes para _has_systemd y _mariadb_io_uring_available
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
#   Elimina archivos PID y socket de procesos MariaDB muertos.
#   Solo actúa cuando el proceso ya no existe (kill -0 falla).
#   No mata procesos vivos — para eso usar _mariadb_kill_stale.
mariadb_cleanup_stale() {
    log_debug "mariadb_cleanup_stale: verificando archivos stale"

    if [[ -f "$_MARIADB_PID_FILE" ]]; then
        local pid
        pid=$(cat "$_MARIADB_PID_FILE" 2>/dev/null || echo "")
        if [[ -n "$pid" ]] && ! kill -0 "$pid" 2>/dev/null; then
            log_warn "mariadb_cleanup_stale: PID ${pid} en ${_MARIADB_PID_FILE} no existe — eliminando"
            rm -f "$_MARIADB_PID_FILE"
        elif [[ -n "$pid" ]]; then
            log_debug "mariadb_cleanup_stale: PID ${pid} existe (proceso vivo)"
        fi
    fi

    local cleaned=0
    for sock in "${_MARIADB_SOCKETS[@]}"; do
        if [[ -S "$sock" ]]; then
            if ! mysqladmin --socket="$sock" ping --silent >/dev/null 2>&1; then
                log_warn "mariadb_cleanup_stale: socket huérfano ${sock} — eliminando"
                rm -f "$sock"
                (( ++cleaned )) || true
            else
                log_debug "mariadb_cleanup_stale: socket activo — no se elimina: ${sock}"
            fi
        fi
    done

    if [[ $cleaned -gt 0 ]]; then
        log_success "mariadb_cleanup_stale: ${cleaned} socket(s) stale eliminado(s)"
    else
        log_debug "mariadb_cleanup_stale: sin archivos stale"
    fi
}

# mariadb_wait_ready [timeout_segundos]
mariadb_wait_ready() {
    local timeout="${1:-30}"
    local elapsed=0

    log_info "mariadb_wait_ready: esperando MariaDB (máx. ${timeout}s)..."

    while ! mariadb_is_running; do
        if [[ $elapsed -ge $timeout ]]; then
            log_error "mariadb_wait_ready: MariaDB no respondió en ${timeout}s"
            return 1
        fi
        sleep 1
        # Pre-incremento: (( ++elapsed )) evalúa a ≥1 siempre (exit 0 con set -e).
        # Post-incremento (( elapsed++ )) evalúa el valor ANTES de incrementar:
        # si elapsed=0, evalúa (( 0 )) → exit 1 → set -e termina la función.
        (( ++elapsed ))
    done

    log_success "mariadb_wait_ready: MariaDB listo (${elapsed}s)"
}

mysql_wait_ready() { mariadb_wait_ready "$@"; }

# _mariadb_start_systemctl
#   Nivel 1: systemctl start mariadb|mysql.
#   Prerequisito: D-Bus activo (_has_systemd de core.sh).
#   Detecta y resuelve el estado "failed" para cada nombre de servicio
#   antes de intentar start — sin reset-failed, systemctl start falla
#   inmediatamente aunque el proceso no exista.
#   Retorna 0 si algún nombre de servicio arrancó, 1 en cualquier otro caso.
_mariadb_start_systemctl() {
    if ! declare -f _has_systemd &>/dev/null || ! _has_systemd; then
        log_debug "_mariadb_start_systemctl: systemctl no disponible o sin D-Bus activo"
        return 1
    fi

    local svc_name
    for svc_name in mariadb mysql; do
        # Detectar estado "failed" — bloquea start hasta reset-failed
        local svc_state
        svc_state=$(systemctl is-failed "$svc_name" 2>/dev/null || echo "")
        if [[ "$svc_state" == "failed" ]]; then
            log_warn "_mariadb_start_systemctl: '${svc_name}' en estado 'failed' — ejecutando reset-failed"
            if systemctl reset-failed "$svc_name" 2>/dev/null; then
                log_success "_mariadb_start_systemctl: reset-failed completado para '${svc_name}'"
            else
                log_warn "_mariadb_start_systemctl: reset-failed no pudo completarse para '${svc_name}'"
            fi
        else
            log_debug "_mariadb_start_systemctl: estado de '${svc_name}': ${svc_state:-inactive/unknown}"
        fi

        log_debug "_mariadb_start_systemctl: intentando systemctl start ${svc_name}"
        if systemctl start "$svc_name" 2>/dev/null; then
            log_success "_mariadb_start_systemctl: iniciado via systemctl (${svc_name})"
            return 0
        fi
        log_debug "_mariadb_start_systemctl: systemctl start ${svc_name} falló — siguiente nombre"
    done

    log_warn "_mariadb_start_systemctl: systemctl no pudo arrancar mariadb ni mysql"
    return 1
}

# _mariadb_start_service
#   Nivel 2: service mariadb|mysql start.
#   Intenta los dos nombres de servicio conocidos.
#   Retorna 0 si alguno arrancó, 1 si no disponible o ambos fallaron.
_mariadb_start_service() {
    if ! command -v service &>/dev/null; then
        log_debug "_mariadb_start_service: comando service no disponible"
        return 1
    fi

    local svc_name
    for svc_name in mariadb mysql; do
        log_debug "_mariadb_start_service: intentando service ${svc_name} start"
        if service "$svc_name" start 2>/dev/null; then
            log_success "_mariadb_start_service: iniciado via service (${svc_name})"
            return 0
        fi
        log_debug "_mariadb_start_service: service ${svc_name} start falló — siguiente nombre"
    done

    log_warn "_mariadb_start_service: service no pudo arrancar mariadb ni mysql"
    return 1
}

# _mariadb_start_direct
#   Nivel 3: arranca mariadbd/mysqld directamente sin init system.
#   Usado cuando systemctl y service no están disponibles o fallaron —
#   entornos Firecracker, contenedores sin D-Bus, o VMs sin systemd.
#   H-MDB-007: detecta disponibilidad de io_uring antes de arrancar y agrega
#   --innodb-use-native-aio=0 cuando está restringido (evita crash en Firecracker).
#   Retorna 0 tras lanzar el daemon en background (no espera a que responda).
_mariadb_start_direct() {
    local daemon
    if   command -v mariadbd &>/dev/null; then daemon="mariadbd"
    elif command -v mysqld   &>/dev/null; then daemon="mysqld"
    else
        log_error "_mariadb_start_direct: no se encontró mariadbd ni mysqld"
        return 1
    fi

    log_info "_mariadb_start_direct: arrancando ${daemon} directamente (sin init system)"
    mkdir -p /run/mysqld
    chown mysql:mysql /run/mysqld 2>/dev/null || true

    # H-MDB-007: _mariadb_io_uring_available definida en core.sh.
    local aio_flag=""
    if declare -f _mariadb_io_uring_available &>/dev/null; then
        if ! _mariadb_io_uring_available; then
            aio_flag="--innodb-use-native-aio=0"
            log_debug "_mariadb_start_direct: io_uring no disponible — usando ${aio_flag}"
        else
            log_debug "_mariadb_start_direct: io_uring disponible"
        fi
    else
        log_warn "_mariadb_start_direct: _mariadb_io_uring_available no disponible — omitiendo detección"
    fi

    nohup su -s /bin/bash mysql -c \
        "${daemon} \
         --datadir=/var/lib/mysql \
         --socket=/run/mysqld/mysqld.sock \
         --pid-file=${_MARIADB_PID_FILE} \
         --log-error=/var/log/mysql/error.log \
         --bind-address=127.0.0.1 \
         --port=3306 \
         ${aio_flag}" \
        >/tmp/mariadbd_startup.log 2>&1 &

    log_success "_mariadb_start_direct: ${daemon} iniciado en background${aio_flag:+ (${aio_flag})}"
}

# _mariadb_kill_stale
#   Mata un proceso MariaDB que existe pero no acepta conexiones.
#   Secuencia de escalada (de más a menos graceful):
#     1. mysqladmin shutdown via socket — shutdown controlado de MariaDB
#     2. SIGTERM → espera 10s
#     3. SIGKILL si persiste
#   Limpia PID file y sockets después de terminar el proceso.
#   Retorna 0 si mató un proceso, 1 si no había nada que matar.
_mariadb_kill_stale() {
    # Obtener PID: PID file primero, luego búsqueda por nombre de proceso
    local pid=""
    if [[ -f "$_MARIADB_PID_FILE" ]]; then
        pid=$(cat "$_MARIADB_PID_FILE" 2>/dev/null || echo "")
    fi
    if [[ -z "$pid" ]]; then
        pid=$(pgrep -x mariadbd 2>/dev/null \
            || pgrep -x mysqld 2>/dev/null \
            || echo "")
    fi

    if [[ -z "$pid" ]] || ! kill -0 "$pid" 2>/dev/null; then
        log_debug "_mariadb_kill_stale: sin proceso activo que matar"
        mariadb_cleanup_stale
        return 1
    fi

    # Defensa en profundidad: verificar que el servicio realmente no responde.
    # Mismo patrón que _pg_kill_stale — protege contra llamada directa con
    # servicio sano y contra race conditions en el caller.
    if mariadb_is_running; then
        log_warn "_mariadb_kill_stale: proceso ${pid} existe y ACEPTA conexiones — no es stale, abortando kill"
        log_warn "_mariadb_kill_stale: para detener manualmente: service mariadb stop"
        return 1
    fi

    log_warn "_mariadb_kill_stale: proceso ${pid} existe pero no acepta conexiones"

    # Paso 1: intento graceful via mysqladmin shutdown (socket Unix)
    # mysqladmin shutdown envía COM_SHUTDOWN al servidor — más limpio que señales
    if command -v mysqladmin &>/dev/null; then
        local sock
        for sock in "${_MARIADB_SOCKETS[@]}"; do
            if [[ -S "$sock" ]]; then
                log_debug "_mariadb_kill_stale: intentando mysqladmin shutdown via ${sock}"
                if mysqladmin --socket="$sock" --connect-timeout=3 shutdown 2>/dev/null; then
                    log_success "_mariadb_kill_stale: shutdown graceful completado via socket"
                    local elapsed=0
                    while kill -0 "$pid" 2>/dev/null && [[ $elapsed -lt 10 ]]; do
                        sleep 1
                        (( ++elapsed )) || true
                    done
                    break
                fi
                log_debug "_mariadb_kill_stale: mysqladmin shutdown falló en ${sock}"
            fi
        done
    fi

    # Paso 2: SIGTERM si el proceso aún existe
    if kill -0 "$pid" 2>/dev/null; then
        log_warn "_mariadb_kill_stale: enviando SIGTERM a PID ${pid}"
        kill -TERM "$pid" 2>/dev/null || true

        local elapsed=0
        while kill -0 "$pid" 2>/dev/null && [[ $elapsed -lt 10 ]]; do
            sleep 1
            (( ++elapsed )) || true
        done

        # Paso 3: SIGKILL si SIGTERM no fue suficiente
        if kill -0 "$pid" 2>/dev/null; then
            log_warn "_mariadb_kill_stale: SIGTERM ignorado tras ${elapsed}s — enviando SIGKILL a PID ${pid}"
            kill -KILL "$pid" 2>/dev/null || true
            sleep 1
        fi
    fi

    if kill -0 "$pid" 2>/dev/null; then
        log_error "_mariadb_kill_stale: no se pudo terminar PID ${pid}"
        return 1
    fi

    log_success "_mariadb_kill_stale: proceso ${pid} terminado"
    rm -f "$_MARIADB_PID_FILE"
    local sock
    for sock in "${_MARIADB_SOCKETS[@]}"; do
        rm -f "$sock" 2>/dev/null || true
    done
    return 0
}

# db_start_mariadb [timeout]
#   Arranca MariaDB si no está corriendo.
#   Flujo completo:
#     1. Limpia archivos stale (PID/socket de procesos muertos)
#     2. Itera por tres niveles en orden:
#          Nivel 1 — _mariadb_start_systemctl (systemctl, con reset-failed si en 'failed')
#          Nivel 2 — _mariadb_start_service   (service mariadb|mysql start)
#          Nivel 3 — _mariadb_start_direct    (mariadbd directo con detección io_uring)
#     3. Si todos los niveles fallan y existe un proceso vivo que no responde:
#          shutdown graceful (_mariadb_kill_stale) y reintenta el loop una vez
#
#   Por cada nivel del loop:
#     · No disponible       → log_debug, siguiente nivel
#     · Falla               → log_warn,  siguiente nivel
#     · OK pero no responde → log_warn (proceso murió), siguiente nivel
#     · OK y responde       → log_success, return 0
db_start_mariadb() {
    local timeout="${1:-30}"

    if mariadb_is_running; then
        log_info "db_start_mariadb: MariaDB ya está corriendo"
        return 0
    fi

    log_info "db_start_mariadb: MariaDB inactivo — iniciando (timeout: ${timeout}s)"

    # Limpiar archivos stale antes de intentar arrancar.
    # Un PID file de proceso muerto hace que systemctl y service fallen
    # con "already running" aunque no haya nada corriendo.
    mariadb_cleanup_stale

    local -a levels=(
        "_mariadb_start_systemctl"
        "_mariadb_start_service"
        "_mariadb_start_direct"
    )
    local total="${#levels[@]}"

    # Función interna: ejecutar el loop de niveles
    _mariadb_try_levels() {
        local level level_num=0
        for level in "${levels[@]}"; do
            (( ++level_num ))
            log_debug "db_start_mariadb: nivel ${level_num}/${total} — ${level}"

            if ! "$level"; then
                log_debug "db_start_mariadb: ${level} no disponible o falló — siguiente nivel"
                continue
            fi

            log_debug "db_start_mariadb: ${level} OK — esperando que MariaDB acepte conexiones"
            if mariadb_wait_ready "$timeout"; then
                log_success "db_start_mariadb: MariaDB iniciado via ${level}"
                return 0
            fi

            # Arrancó pero murió antes de aceptar conexiones.
            # Causas probables: io_uring restringido (H-MDB-007),
            # datadir no inicializado (H-MDB-008), o configuración inválida.
            log_warn "db_start_mariadb: MariaDB arrancó via ${level} pero no respondió en ${timeout}s"
            if [[ $level_num -lt $total ]]; then
                log_warn "db_start_mariadb: intentando nivel $((level_num + 1))/${total}"
            fi
        done
        return 1
    }

    # Primer intento
    if _mariadb_try_levels; then
        return 0
    fi

    log_warn "db_start_mariadb: todos los niveles fallaron en el primer intento"

    # Si existe un proceso vivo que no acepta conexiones, intentar shutdown
    # graceful via mysqladmin antes de SIGTERM/SIGKILL, luego reintentar.
    if _mariadb_kill_stale; then
        log_info "db_start_mariadb: proceso stale eliminado — reintentando arranque"
        mariadb_cleanup_stale
        if _mariadb_try_levels; then
            return 0
        fi
        log_error "db_start_mariadb: fallo también tras eliminar proceso stale"
    fi

    log_error "db_start_mariadb: no se pudo arrancar MariaDB"
    log_error "db_start_mariadb: revisar con: journalctl -u mariadb o /var/log/mysql/error.log"
    return 1
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

    log_info "postgres_wait_ready: esperando PostgreSQL (máx. ${timeout}s)..."

    while ! pg_is_running; do
        if [[ $elapsed -ge $timeout ]]; then
            log_error "postgres_wait_ready: PostgreSQL no respondió en ${timeout}s"
            return 1
        fi
        sleep 1
        # Pre-incremento: ver nota en mariadb_wait_ready — mismo bug con set -e.
        (( ++elapsed ))
    done

    log_success "postgres_wait_ready: PostgreSQL listo (${elapsed}s)"
}

# _pg_cleanup_stale [version]
#   Elimina archivos PID y socket de procesos PostgreSQL muertos.
#   Solo actúa cuando el proceso ya no existe (kill -0 falla).
#   No mata procesos vivos — para eso usar _pg_kill_stale.
_pg_cleanup_stale() {
    local version="${1:-16}"
    local pid_file="/var/run/postgresql/${version}-main.pid"
    local socket_file="/var/run/postgresql/.s.PGSQL.5432"
    local cleaned=0

    log_debug "_pg_cleanup_stale: verificando archivos stale (versión ${version})"

    # PID file con proceso muerto
    if [[ -f "$pid_file" ]]; then
        local pid
        pid=$(cat "$pid_file" 2>/dev/null || echo "")
        if [[ -n "$pid" ]] && ! kill -0 "$pid" 2>/dev/null; then
            log_warn "_pg_cleanup_stale: PID ${pid} en ${pid_file} no existe — eliminando PID file"
            rm -f "$pid_file"
            (( ++cleaned )) || true
        elif [[ -n "$pid" ]]; then
            log_debug "_pg_cleanup_stale: PID ${pid} existe (proceso vivo)"
        fi
    fi

    # Socket huérfano — existe pero nada escucha en él
    if [[ -S "$socket_file" ]]; then
        if ! pg_isready -h "/var/run/postgresql" -p 5432 -q 2>/dev/null; then
            log_warn "_pg_cleanup_stale: socket ${socket_file} sin proceso activo — eliminando"
            rm -f "$socket_file" "${socket_file}.lock"
            (( ++cleaned )) || true
        else
            log_debug "_pg_cleanup_stale: socket activo — no se elimina"
        fi
    fi

    if [[ $cleaned -gt 0 ]]; then
        log_success "_pg_cleanup_stale: ${cleaned} archivo(s) stale eliminado(s)"
    else
        log_debug "_pg_cleanup_stale: sin archivos stale"
    fi
}

# _pg_kill_stale [version]
#   Mata un proceso PostgreSQL que existe pero no acepta conexiones.
#   Caso típico: el postmaster está arrancando en bucle, colgado en recovery,
#   o bloqueado por un lock file de una sesión anterior.
#   Secuencia: SIGTERM → espera 10s → SIGKILL si persiste → limpia archivos.
#   Retorna 0 si mató un proceso, 1 si no había nada que matar.
_pg_kill_stale() {
    local version="${1:-16}"
    local pid_file="/var/run/postgresql/${version}-main.pid"

    if [[ ! -f "$pid_file" ]]; then
        log_debug "_pg_kill_stale: sin PID file — nada que matar"
        return 1
    fi

    local pid
    pid=$(cat "$pid_file" 2>/dev/null || echo "")

    if [[ -z "$pid" ]] || ! kill -0 "$pid" 2>/dev/null; then
        log_debug "_pg_kill_stale: PID ${pid:-vacío} no existe — usando _pg_cleanup_stale"
        _pg_cleanup_stale "$version"
        return 1
    fi

    # Defensa en profundidad: verificar que el servicio realmente no responde
    # antes de matar. Esta guarda protege contra:
    #   a) llamada directa con el servicio sano (como ocurrió en test)
    #   b) race condition entre el check del caller y esta llamada
    # Si el servicio responde, el proceso NO es stale — no matar.
    if pg_is_running; then
        log_warn "_pg_kill_stale: proceso ${pid} existe y ACEPTA conexiones — no es stale, abortando kill"
        log_warn "_pg_kill_stale: para detener manualmente: pg_ctlcluster ${version} main stop"
        return 1
    fi

    log_warn "_pg_kill_stale: proceso ${pid} existe pero no acepta conexiones"
    log_warn "_pg_kill_stale: enviando SIGTERM a PID ${pid}"
    kill -TERM "$pid" 2>/dev/null || true

    local elapsed=0
    while kill -0 "$pid" 2>/dev/null && [[ $elapsed -lt 10 ]]; do
        sleep 1
        (( ++elapsed )) || true
    done

    if kill -0 "$pid" 2>/dev/null; then
        log_warn "_pg_kill_stale: SIGTERM ignorado tras ${elapsed}s — enviando SIGKILL a PID ${pid}"
        kill -KILL "$pid" 2>/dev/null || true
        sleep 1
    fi

    if kill -0 "$pid" 2>/dev/null; then
        log_error "_pg_kill_stale: no se pudo terminar PID ${pid}"
        return 1
    fi

    log_success "_pg_kill_stale: proceso ${pid} terminado (${elapsed}s)"
    rm -f "$pid_file" \
          "/var/run/postgresql/.s.PGSQL.5432" \
          "/var/run/postgresql/.s.PGSQL.5432.lock"
    return 0
}

# _pg_start_systemctl [version]
#   Nivel 1: systemctl start postgresql.
#   Prerequisito: D-Bus activo (_has_systemd de core.sh).
#   Detecta y resuelve el estado "failed" antes de intentar start:
#     systemctl en "failed" bloquea cualquier start hasta que se haga reset-failed.
#   Retorna 0 si systemctl reportó éxito, 1 si no disponible o falló.
_pg_start_systemctl() {
    if ! declare -f _has_systemd &>/dev/null || ! _has_systemd; then
        log_debug "_pg_start_systemctl: systemctl no disponible o sin D-Bus activo"
        return 1
    fi

    # Detectar estado "failed" — bloquea start hasta hacer reset-failed
    local svc_state
    svc_state=$(systemctl is-failed postgresql 2>/dev/null || echo "")
    if [[ "$svc_state" == "failed" ]]; then
        log_warn "_pg_start_systemctl: servicio en estado 'failed' — ejecutando reset-failed"
        if systemctl reset-failed postgresql 2>/dev/null; then
            log_success "_pg_start_systemctl: reset-failed completado — reintentando start"
        else
            log_warn "_pg_start_systemctl: reset-failed no pudo completarse"
        fi
    else
        log_debug "_pg_start_systemctl: estado del servicio: ${svc_state:-inactive/unknown}"
    fi

    log_debug "_pg_start_systemctl: intentando systemctl start postgresql"
    if systemctl start postgresql 2>/dev/null; then
        log_success "_pg_start_systemctl: iniciado via systemctl"
        return 0
    fi

    log_warn "_pg_start_systemctl: systemctl start postgresql falló"
    return 1
}

# _pg_start_service [version]
#   Nivel 2: service postgresql start.
#   Retorna 0 si service reportó éxito, 1 si no disponible o falló.
_pg_start_service() {
    if ! command -v service &>/dev/null; then
        log_debug "_pg_start_service: comando service no disponible"
        return 1
    fi

    log_debug "_pg_start_service: intentando service postgresql start"
    if service postgresql start 2>/dev/null; then
        log_success "_pg_start_service: iniciado via service"
        return 0
    fi

    log_warn "_pg_start_service: service postgresql start falló"
    return 1
}

# _pg_start_ctlcluster [version]
#   Nivel 3: pg_ctlcluster N main start.
#   Consulta pg_lsclusters para conocer el estado real del cluster antes de
#   intentar start — evita intentar arrancar un cluster ya online o en estado
#   inconsistente sin un diagnóstico previo.
#   Infiere la versión desde POSTGRES_VERSION → pg_lsclusters → default 16.
#   Retorna 0 si pg_ctlcluster reportó éxito, 1 si no disponible o falló.
_pg_start_ctlcluster() {
    local version="${1:-}"

    if ! command -v pg_ctlcluster &>/dev/null; then
        log_debug "_pg_start_ctlcluster: pg_ctlcluster no disponible"
        return 1
    fi

    if [[ -z "$version" ]]; then
        if declare -f _pg_version_from_service &>/dev/null; then
            version=$(_pg_version_from_service)
        else
            version="16"
            log_warn "_pg_start_ctlcluster: _pg_version_from_service no disponible — usando default ${version}"
        fi
    fi

    # Consultar estado real del cluster antes de intentar start
    local cluster_status=""
    if command -v pg_lsclusters &>/dev/null; then
        cluster_status=$(pg_lsclusters -h 2>/dev/null \
            | awk -v ver="$version" '$1 == ver { print $4 }' \
            | head -1)
    fi

    case "$cluster_status" in
        online)
            # pg_lsclusters reporta 'online'. Dos posibles escenarios:
            #   a) Llamada desde db_start_postgres: pg_is_running ya falló antes de
            #      llegar aquí → estado inconsistente real → restart es correcto.
            #   b) Llamada directa con el servicio sano → restart sería incorrecto.
            # Re-verificar pg_is_running para distinguir ambos casos.
            if pg_is_running; then
                log_info "_pg_start_ctlcluster: cluster ${version} online y acepta conexiones — sin acción"
                return 0
            fi
            log_warn "_pg_start_ctlcluster: cluster ${version} reporta 'online' pero no acepta conexiones"
            log_warn "_pg_start_ctlcluster: estado inconsistente — intentando restart"
            if pg_ctlcluster "$version" main restart 2>/dev/null; then
                log_success "_pg_start_ctlcluster: restart completado"
                return 0
            fi
            log_warn "_pg_start_ctlcluster: restart también falló"
            return 1
            ;;
        down|"")
            log_debug "_pg_start_ctlcluster: cluster ${version} en estado '${cluster_status:-desconocido}' — procediendo con start"
            ;;
        starting)
            log_warn "_pg_start_ctlcluster: cluster ${version} en estado 'starting' — posible arranque en progreso"
            log_warn "_pg_start_ctlcluster: esperando 3s antes de intentar start"
            sleep 3
            ;;
        stopping|crashed)
            log_warn "_pg_start_ctlcluster: cluster ${version} en estado '${cluster_status}' — estado requiere intervención"
            log_warn "_pg_start_ctlcluster: intentando start de todos modos"
            ;;
        *)
            log_warn "_pg_start_ctlcluster: estado inesperado '${cluster_status}' — intentando start"
            ;;
    esac

    log_debug "_pg_start_ctlcluster: pg_ctlcluster ${version} main start"
    if pg_ctlcluster "$version" main start 2>/dev/null; then
        log_success "_pg_start_ctlcluster: iniciado via pg_ctlcluster ${version}"
        return 0
    fi

    log_warn "_pg_start_ctlcluster: pg_ctlcluster ${version} main start falló"
    return 1
}

# db_start_postgres [version] [timeout]
#   Arranca PostgreSQL si no está corriendo.
#   Flujo completo:
#     1. Limpia archivos stale (PID/socket de procesos muertos)
#     2. Itera por tres niveles en orden:
#          Nivel 1 — _pg_start_systemctl  (systemctl, con reset-failed si está en 'failed')
#          Nivel 2 — _pg_start_service    (service postgresql start)
#          Nivel 3 — _pg_start_ctlcluster (pg_ctlcluster con consulta de pg_lsclusters)
#     3. Si todos los niveles fallan y existe un proceso vivo que no responde:
#          mata el proceso (_pg_kill_stale) y reintenta el loop una vez
#
#   Por cada nivel del loop:
#     · No disponible       → log_debug, siguiente nivel
#     · Falla               → log_warn,  siguiente nivel
#     · OK pero no responde → log_warn (proceso murió), siguiente nivel
#     · OK y responde       → log_success, return 0
db_start_postgres() {
    local version="${1:-16}"
    local timeout="${2:-30}"

    if pg_is_running; then
        log_info "db_start_postgres: PostgreSQL ya está corriendo"
        return 0
    fi

    log_info "db_start_postgres: PostgreSQL inactivo — iniciando (versión: ${version}, timeout: ${timeout}s)"

    # Exportar versión para que _pg_version_from_service (core.sh)
    # la use en el nivel pg_ctlcluster.
    export POSTGRES_VERSION="${version}"

    # Limpiar archivos stale antes de intentar arrancar.
    # Un PID file de un proceso muerto hace que systemctl y service fallen
    # con "already running" aunque el proceso no exista.
    _pg_cleanup_stale "$version"

    local -a levels=(
        "_pg_start_systemctl"
        "_pg_start_service"
        "_pg_start_ctlcluster"
    )
    local total="${#levels[@]}"

    # Función interna: ejecutar el loop de niveles
    _pg_try_levels() {
        local level level_num=0
        for level in "${levels[@]}"; do
            (( ++level_num ))
            log_debug "db_start_postgres: nivel ${level_num}/${total} — ${level}"

            if ! "$level" "$version"; then
                log_debug "db_start_postgres: ${level} no disponible o falló — siguiente nivel"
                continue
            fi

            log_debug "db_start_postgres: ${level} OK — esperando que PostgreSQL acepte conexiones"
            if postgres_wait_ready "$timeout"; then
                log_success "db_start_postgres: PostgreSQL iniciado via ${level}"
                return 0
            fi

            # Arrancó pero murió antes de aceptar conexiones.
            # Posibles causas: configuración inválida, pg_hba.conf con error,
            # datadir corrupto, o proceso previo ocupando el puerto.
            log_warn "db_start_postgres: PostgreSQL arrancó via ${level} pero no respondió en ${timeout}s"
            if [[ $level_num -lt $total ]]; then
                log_warn "db_start_postgres: intentando nivel $((level_num + 1))/${total}"
            fi
        done
        return 1
    }

    # Primer intento
    if _pg_try_levels; then
        return 0
    fi

    log_warn "db_start_postgres: todos los niveles fallaron en el primer intento"

    # Si existe un proceso vivo que no acepta conexiones, matarlo y reintentar.
    # Este es el caso típico de un postmaster colgado o en bucle de recovery.
    if _pg_kill_stale "$version"; then
        log_info "db_start_postgres: proceso stale eliminado — reintentando arranque"
        _pg_cleanup_stale "$version"
        if _pg_try_levels; then
            return 0
        fi
        log_error "db_start_postgres: fallo también tras eliminar proceso stale"
    fi

    log_error "db_start_postgres: no se pudo arrancar PostgreSQL"
    log_error "db_start_postgres: revisar con: pg_lsclusters o journalctl -u postgresql"
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
export -f _mariadb_start_systemctl _mariadb_start_service _mariadb_start_direct
export -f _mariadb_kill_stale db_start_mariadb
export -f pg_is_running postgres_is_running postgres_wait_ready
export -f _pg_cleanup_stale _pg_kill_stale
export -f _pg_start_systemctl _pg_start_service _pg_start_ctlcluster db_start_postgres
export -f mysql_execute mysql_database_exists mysql_user_exists
export -f mysql_create_database mysql_create_user
export -f mysql_grant_privileges mysql_grant_readonly
export -f postgres_execute postgres_database_exists postgres_user_exists
export -f postgres_create_database postgres_create_user
export -f postgres_grant_privileges postgres_allow_remote
export -f wait_for_database test_db_connection

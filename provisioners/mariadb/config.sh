#!/bin/bash
# =============================================================================
# provisioners/mariadb/config.sh — Configuración del servicio MariaDB
# =============================================================================
# Responsabilidad única: configurar el servicio MariaDB del SO.
# No instala paquetes. No crea objetos de BD. No securiza usuarios.
#
# Separación de capas:
#   install.sh  → instalar la versión correcta del motor + purgar si incorrecta
#   config.sh   → configurar el servicio (este archivo)
#   setup.sh    → aprovisionar la BD (usuarios, bases, grants)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/validation.sh"
# database.sh: provee mariadb_wait_ready() y mariadb_is_running()
# necesarios en _restart_mariadb() para verificar que el daemon
# acepte conexiones antes de continuar con _secure_mariadb().
# H-F1-001: database.sh no estaba sourced — mariadb_wait_ready
# no disponible en este contexto.
source "${PROJECT_ROOT}/utils/database.sh"

# ---------------------------------------------------------------------------
# _secure_mariadb
#
# Hardening del motor recién instalado. Equivalente a mysql_secure_installation
# ejecutado de forma no interactiva e idempotente.
#
# Operaciones:
#   - Eliminar usuarios anónimos (mysql.user WHERE User='')
#   - Restringir root a conexiones locales únicamente
#   - Eliminar la base de datos 'test' que viene por defecto
#   - Establecer password de root (o actualizar si ya existe)
#   - FLUSH PRIVILEGES
#
# T-1.4 (H-INST-001, H-INST-008):
#   secure_mariadb() vivía en install.sh — capa INSTALL, no CONFIG.
#   Se mueve a config.sh porque actúa sobre objetos de seguridad del
#   motor del sistema, no sobre paquetes apt.
#
#   H-INST-008: debe ejecutarse ANTES de _configure_mariadb_server().
#   En instalación fresca MariaDB usa unix_socket auth para root.
#   Ese mecanismo está disponible antes de cambiar bind-address.
#   Si se hace después de cambiar bind-address y reiniciar, el contexto
#   de autenticación puede cambiar dependiendo del entorno.
#
# Idempotente: DELETE y DROP IF EXISTS no fallan si ya están aplicados.
#   ALTER USER no falla si el password ya es el mismo.
# ---------------------------------------------------------------------------
_secure_mariadb() {
    log_info "  Detectando método de autenticación root..."

    local mysql_root_cmd
    if mysql -u root -e "SELECT 1;" &>/dev/null 2>&1; then
        log_debug "  _secure_mariadb: root via unix_socket (instalación fresca)"
        mysql_root_cmd="mysql -u root"
    elif mysql -u root -p"${DB_MARIADB_ROOT_PASSWORD}" -e "SELECT 1;" &>/dev/null 2>&1; then
        log_debug "  _secure_mariadb: root via password"
        mysql_root_cmd="mysql -u root -p${DB_MARIADB_ROOT_PASSWORD}"
    else
        log_error "  No se pudo autenticar como root (ni unix_socket ni password)"
        log_error "  Verificar: DB_MARIADB_ROOT_PASSWORD en .env"
        return 1
    fi

    log_info "  Eliminando usuarios anónimos..."
    $mysql_root_cmd -e "DELETE FROM mysql.user WHERE User='';" \
        2>/dev/null || true

    log_info "  Restringiendo root a conexiones locales..."
    $mysql_root_cmd \
        -e "DELETE FROM mysql.user WHERE User='root'
            AND Host NOT IN ('localhost', '127.0.0.1', '::1');" \
        2>/dev/null || true

    log_info "  Eliminando base de datos 'test'..."
    $mysql_root_cmd -e "DROP DATABASE IF EXISTS test;" \
        2>/dev/null || true
    $mysql_root_cmd \
        -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';" \
        2>/dev/null || true

    log_info "  Configurando password de root..."
    $mysql_root_cmd \
        -e "ALTER USER 'root'@'localhost'
            IDENTIFIED BY '${DB_MARIADB_ROOT_PASSWORD}';" \
        2>/dev/null || \
    $mysql_root_cmd \
        -e "UPDATE mysql.user
            SET Password=PASSWORD('${DB_MARIADB_ROOT_PASSWORD}')
            WHERE User='root';" \
        2>/dev/null || true

    $mysql_root_cmd -e "FLUSH PRIVILEGES;" 2>/dev/null || {
        log_error "  FLUSH PRIVILEGES falló"
        return 1
    }

    log_success "  MariaDB securizado"
    return 0
}

ENV_FILE="${PROJECT_ROOT}/.env"
[[ -f "$ENV_FILE" ]] && { set -a; source "$ENV_FILE"; set +a; }

# ---------------------------------------------------------------------------
# _configure_mariadb_server
#
# Ajusta 50-server.cnf para acceso desde la red.
# Solo modifica bind-address — el resto de la config viene de 99-iact.cnf.
# Idempotente.
# ---------------------------------------------------------------------------
_configure_mariadb_server() {
    local config_file="/etc/mysql/mariadb.conf.d/50-server.cnf"

    if [[ ! -f "$config_file" ]]; then
        log_error "50-server.cnf no encontrado: ${config_file}"
        log_error "  ¿MariaDB está instalado?"
        return 1
    fi

    log_info "  50-server.cnf: ${config_file}"

    # T-1.1 (H-DEAD-001): crear backup antes de editar.
    # configure_mariadb() en install.sh hacía backup_file — se omitió al crear config.sh.
    # Permite restaurar si la edición produce un archivo inválido.
    if ! backup_file "$config_file"; then
        log_warn "  No se pudo crear backup de ${config_file} — continuando"
    else
        log_info "  Backup creado antes de editar 50-server.cnf"
    fi

    if grep -q "^bind-address" "$config_file"; then
        sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' "$config_file"
        log_info "  bind-address = 0.0.0.0 actualizado"
    else
        sed -i '/^\[mysqld\]/a bind-address = 0.0.0.0' "$config_file"
        log_info "  bind-address = 0.0.0.0 agregado"
    fi

    # Verificar
    if ! grep -q "bind-address = 0.0.0.0" "$config_file"; then
        log_error "  No se pudo configurar bind-address"
        return 1
    fi

    return 0
}

# ---------------------------------------------------------------------------
# _configure_mariadb_aio
#
# Detecta si io_uring está disponible y configura innodb_use_native_aio=0
# si no lo está. Escribe en 50-server.cnf (configuración del sistema).
# Idempotente.
# ---------------------------------------------------------------------------
_configure_mariadb_aio() {
    local config_file="/etc/mysql/mariadb.conf.d/50-server.cnf"

    if declare -f _mariadb_io_uring_available &>/dev/null; then
        if ! _mariadb_io_uring_available; then
            if ! grep -q "innodb_use_native_aio" "$config_file"; then
                cat >> "$config_file" << 'EOF'

# io_uring no disponible en este entorno (Firecracker/contenedor con seccomp)
innodb_use_native_aio = 0
EOF
                log_info "  innodb_use_native_aio = 0 configurado (io_uring no disponible)"
            else
                log_info "  innodb_use_native_aio ya configurado"
            fi
        else
            log_info "  io_uring disponible — innodb_use_native_aio no modificado"
        fi
    fi

    return 0
}

# ---------------------------------------------------------------------------
# _apply_iact_mariadb_config
#
# Crea symlink de config/mariadb/99-iact.cnf en conf.d/ del sistema.
# MariaDB lee conf.d/ en orden alfabético — prefijo 99 = máxima precedencia.
# ---------------------------------------------------------------------------
_apply_iact_mariadb_config() {
    local repo_config="${PROJECT_ROOT}/config/mariadb/99-iact.cnf"
    local system_link="/etc/mysql/mariadb.conf.d/99-iact.cnf"

    if [[ ! -f "$repo_config" ]]; then
        log_warn "  config/mariadb/99-iact.cnf no encontrado — omitido"
        return 0
    fi

    if ln -sf "$repo_config" "$system_link" 2>/dev/null; then
        log_success "  Config vinculada: ${system_link} → ${repo_config}"
    else
        log_error "  No se pudo crear symlink: ${system_link}"
        return 1
    fi

    # T-1.3 (H-DEAD-003): verificar que MariaDB puede parsear el archivo
    # tras crear el symlink. _apply_iact_mariadb_config() de install.sh
    # tenía esta verificación — se omitió al crear config.sh.
    # Sin ella, un error de sintaxis en 99-iact.cnf produce un fallo
    # críptico del daemon en _restart_mariadb en lugar de un mensaje claro.
    if command -v mariadbd &>/dev/null; then
        if mariadbd --defaults-file=/etc/mysql/my.cnf \
                    --help --verbose 2>&1 \
                | grep -q "event_scheduler" 2>/dev/null; then
            log_success "  MariaDB parseó 99-iact.cnf correctamente (event_scheduler activo)"
        else
            log_warn "  event_scheduler no detectado en el parseo — verificar sintaxis de:"
            log_warn "  ${repo_config}"
        fi
    fi

    return 0
}

# ---------------------------------------------------------------------------
# _restart_mariadb
# ---------------------------------------------------------------------------
_restart_mariadb() {
    if service mariadb restart 2>/dev/null \
       || systemctl restart mariadb 2>/dev/null; then
        log_info "  MariaDB reiniciando..."

        # T-1.2 (H-DEAD-002): esperar hasta 30s que el daemon acepte conexiones.
        # configure_mariadb() en install.sh hacía mysql_wait_ready(30) — se omitió
        # al crear config.sh. Sin esta espera, _secure_mariadb() que viene a
        # continuación puede fallar con "can't connect" en instalación fresca.
        if mariadb_wait_ready 30 2>/dev/null; then
            log_success "  MariaDB reiniciado y listo"
        else
            log_warn "  MariaDB arrancó pero no respondió en 30s"
            log_warn "  Verificar: journalctl -u mariadb --no-pager | tail -20"
        fi
    else
        log_warn "  No se pudo reiniciar MariaDB automáticamente"
        log_warn "  Reiniciar manualmente: sudo service mariadb restart"
    fi
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------
main() {
    log_header "MariaDB — Configuración del servicio"

    if ! validate_root; then
        log_fatal "Este script debe ejecutarse como root (sudo)"
    fi

    # T-1.4 (H-INST-006): agregar DB_MARIADB_ROOT_PASSWORD a require_vars.
    # _secure_mariadb() lo necesita para autenticar y configurar root.
    require_vars MARIADB_VERSION DB_MARIADB_ROOT_PASSWORD

    # Verificar que MariaDB está instalado
    if ! command -v mysql &>/dev/null && \
       ! dpkg -l mariadb-server 2>/dev/null | grep -q "^ii"; then
        log_fatal "MariaDB no está instalado. Ejecutar primero: bash install.sh"
    fi

    # T-1.4 (H-INST-001, H-INST-008): PASO 0 — hardening del motor.
    # Se ejecuta ANTES de _configure_mariadb_server porque en instalación
    # fresca root usa unix_socket auth — disponible antes de cambiar bind-address.
    log_step 1 4 "Hardening del motor (root, usuarios anónimos, BD test)"
    if ! _secure_mariadb; then
        log_fatal "No se pudo securizar MariaDB"
    fi
    log_success "MariaDB securizado"

    log_step 2 4 "50-server.cnf — acceso de red (bind-address)"
    if ! _configure_mariadb_server; then
        log_fatal "No se pudo configurar 50-server.cnf"
    fi
    log_success "50-server.cnf configurado"

    log_step 3 4 "AIO — io_uring"
    _configure_mariadb_aio

    log_step 4 4 "Config IACT (symlink 99-iact.cnf)"
    if ! _apply_iact_mariadb_config; then
        log_warn "99-iact.cnf no vinculado — continuando"
    fi

    log_info "Reiniciando MariaDB para aplicar cambios..."
    _restart_mariadb

    log_success "Configuración del servicio MariaDB completada"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

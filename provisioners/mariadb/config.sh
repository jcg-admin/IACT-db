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

    return 0
}

# ---------------------------------------------------------------------------
# _restart_mariadb
# ---------------------------------------------------------------------------
_restart_mariadb() {
    if service mariadb restart 2>/dev/null \
       || systemctl restart mariadb 2>/dev/null; then
        log_success "  MariaDB reiniciado"
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

    require_vars MARIADB_VERSION

    # Verificar que MariaDB está instalado
    if ! command -v mysql &>/dev/null && \
       ! dpkg -l mariadb-server 2>/dev/null | grep -q "^ii"; then
        log_fatal "MariaDB no está instalado. Ejecutar primero: bash install.sh"
    fi

    log_step 1 3 "50-server.cnf — acceso de red (bind-address)"
    if ! _configure_mariadb_server; then
        log_fatal "No se pudo configurar 50-server.cnf"
    fi
    log_success "50-server.cnf configurado"

    log_step 2 3 "AIO — io_uring"
    _configure_mariadb_aio

    log_step 3 3 "Config IACT (symlink 99-iact.cnf)"
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

#!/bin/bash
# =============================================================================
# provisioners/postgres/config.sh — Configuración del servicio PostgreSQL
# =============================================================================
# Responsabilidad única: configurar el servicio PostgreSQL del SO.
# No instala paquetes. No crea objetos de BD.
#
# Separación de capas:
#   install.sh  → instalar la versión correcta del motor
#   config.sh   → configurar el servicio (este archivo)
#   setup.sh    → aprovisionar la BD (usuarios, bases, grants)
#
# Por qué la configuración está separada del install:
#   install.sh puede necesitar PURGAR una versión incorrecta antes de instalar.
#   La configuración (pg_hba.conf, symlinks) no tiene sentido antes de que
#   el motor correcto esté instalado y arrancado. Si configure_postgresql()
#   viviera en install.sh junto con la purga, correría sobre archivos de una
#   versión ya eliminada o aún no creados.
#
# Idempotente: seguro ejecutar N veces sin efectos adversos.
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
# _secure_postgres
#
# Hardening del motor recién instalado: establece el password del
# superusuario 'postgres' del sistema (creado por apt install postgresql).
#
# T-1.7 (H-INST-003, H-INST-007):
#   set_postgres_password() vivía en install.sh — capa INSTALL, no CONFIG.
#   Se mueve aquí porque actúa sobre un usuario del motor del sistema,
#   no sobre paquetes apt.
#
#   H-INST-007: debe ejecutarse ANTES de _configure_pg_hba().
#   pg_hba.conf con scram-sha-256 requiere que el usuario 'postgres'
#   tenga password configurado. Si se configura pg_hba primero y luego
#   se intenta conectar antes de tener password, la autenticación falla.
#
# Idempotente: ALTER USER no falla si el password ya es el mismo.
# Variable requerida: POSTGRES_PASSWORD (superusuario del sistema postgres,
#   distinto de DB_POSTGRES_PASSWORD que es el password de django_user).
# ---------------------------------------------------------------------------
_secure_postgres() {
    log_info "  Configurando password del superusuario postgres del sistema..."

    if sudo -u postgres psql \
        -c "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';" \
        2>/dev/null; then
        log_success "  Password del superusuario postgres configurado"
    else
        log_error "  No se pudo configurar el password de postgres"
        log_error "  Verificar: POSTGRES_PASSWORD en .env"
        return 1
    fi

    return 0
}

# ---------------------------------------------------------------------------
# _configure_pg_hba
#
# Agrega las reglas de autenticación necesarias en pg_hba.conf:
#   - Socket Unix scram-sha-256 para DB_POSTGRES_USER (django_user)
#   - Acceso remoto TCP desde cualquier IP (para entorno dev)
#
# Idempotente: verifica si la regla ya existe antes de agregar.
# ---------------------------------------------------------------------------
_configure_pg_hba() {
    local pg_version="${POSTGRES_VERSION:-16}"
    local pg_hba="/etc/postgresql/${pg_version}/main/pg_hba.conf"
    local socket_user="${DB_POSTGRES_USER:-django_user}"

    if [[ ! -f "$pg_hba" ]]; then
        log_error "pg_hba.conf no encontrado: ${pg_hba}"
        log_error "  ¿PostgreSQL ${pg_version} está instalado?"
        return 1
    fi

    log_info "  pg_hba.conf: ${pg_hba}"

    # T-1.5 (H-DEAD-001): crear backup antes de editar.
    # configure_postgresql() en install.sh hacía backup_file(pg_hba.conf) —
    # se omitió al crear config.sh.
    if ! backup_file "$pg_hba"; then
        log_warn "  No se pudo crear backup de ${pg_hba} — continuando"
    else
        log_info "  Backup creado antes de editar pg_hba.conf"
    fi

    # Regla socket Unix para django_user (scram-sha-256)
    local socket_rule="local   all             ${socket_user}                          scram-sha-256"
    if ! grep -qE "^local\s+all\s+${socket_user}\s+scram-sha-256" "$pg_hba"; then
        # Insertar antes de la primera regla "local all all peer"
        if grep -qE "^local\s+all\s+all\s+peer" "$pg_hba"; then
            sed -i "/^local[[:space:]]\+all[[:space:]]\+all[[:space:]]\+peer/i ${socket_rule}" \
                "$pg_hba"
        else
            echo "" >> "$pg_hba"
            echo "# Socket Unix — autenticacion por password para ${socket_user}" >> "$pg_hba"
            echo "${socket_rule}" >> "$pg_hba"
        fi
        log_info "  Regla socket Unix agregada para ${socket_user}"
    else
        log_info "  Regla socket Unix ya existe para ${socket_user}"
    fi

    # Regla TCP remota (0.0.0.0/0 — entorno dev)
    local remote_cidr="0.0.0.0/0"
    if ! grep -q "$remote_cidr" "$pg_hba"; then
        echo "" >> "$pg_hba"
        echo "# Acceso remoto TCP — entorno desarrollo" >> "$pg_hba"
        echo "host    all             all             ${remote_cidr}            scram-sha-256" \
            >> "$pg_hba"
        log_info "  Regla TCP remota agregada (${remote_cidr})"
    else
        log_info "  Regla TCP remota ya existe"
    fi

    return 0
}

# ---------------------------------------------------------------------------
# _configure_postgresql_conf
#
# Ajusta postgresql.conf para acceso remoto y performance básica.
# ---------------------------------------------------------------------------
_configure_postgresql_conf() {
    local pg_version="${POSTGRES_VERSION:-16}"
    local pg_conf="/etc/postgresql/${pg_version}/main/postgresql.conf"

    if [[ ! -f "$pg_conf" ]]; then
        log_error "postgresql.conf no encontrado: ${pg_conf}"
        return 1
    fi

    # T-1.5 (H-DEAD-001): crear backup antes de editar.
    # configure_postgresql() en install.sh hacía backup_file(postgresql.conf) —
    # se omitió al crear config.sh.
    if ! backup_file "$pg_conf"; then
        log_warn "  No se pudo crear backup de ${pg_conf} — continuando"
    else
        log_info "  Backup creado antes de editar postgresql.conf"
    fi

    # Habilitar listen_addresses para acceso remoto
    if grep -q "^#listen_addresses\|^listen_addresses" "$pg_conf"; then
        sed -i "s/^#*listen_addresses\s*=.*/listen_addresses = '*'/" "$pg_conf"
        log_info "  listen_addresses = '*' configurado"
    fi

    # T-1.6 (H-DEAD-004): verificar que el cambio quedó aplicado.
    # configure_postgresql() en install.sh verificaba listen_addresses tras editar —
    # se omitió al crear config.sh. Sin verificación, un fallo silencioso del sed
    # deja PostgreSQL escuchando solo en localhost sin mensaje de error.
    if ! grep -q "^listen_addresses = '\*'" "$pg_conf"; then
        log_error "  listen_addresses no quedó configurado correctamente"
        log_error "  Verificar manualmente: grep listen_addresses ${pg_conf}"
        return 1
    fi
    log_success "  listen_addresses = '*' verificado en postgresql.conf"

    return 0
}

# ---------------------------------------------------------------------------
# _apply_iact_postgres_config
#
# Crea symlink de config/postgres/99-iact.conf en conf.d/ del sistema.
# postgresql.conf ya tiene: include_dir = 'conf.d'
# ---------------------------------------------------------------------------
_apply_iact_postgres_config() {
    local repo_config="${PROJECT_ROOT}/config/postgres/99-iact.conf"
    local pg_version="${POSTGRES_VERSION:-16}"
    local conf_d="/etc/postgresql/${pg_version}/main/conf.d"
    local system_link="${conf_d}/99-iact.conf"

    if [[ ! -f "$repo_config" ]]; then
        log_warn "  config/postgres/99-iact.conf no encontrado — omitido"
        return 0
    fi

    if [[ ! -d "$conf_d" ]]; then
        log_warn "  conf.d no existe en ${conf_d}"
        log_warn "  Verificar: include_dir = 'conf.d' en postgresql.conf"
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
# _reload_postgresql
# ---------------------------------------------------------------------------
_reload_postgresql() {
    local pg_version="${POSTGRES_VERSION:-16}"

    if pg_ctlcluster "${pg_version}" main reload 2>/dev/null; then
        log_success "  PostgreSQL recargado"
    elif systemctl reload "postgresql@${pg_version}-main" 2>/dev/null; then
        log_success "  PostgreSQL recargado via systemctl"
    else
        log_warn "  No se pudo recargar PostgreSQL — reiniciar manualmente si es necesario"
    fi
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------
main() {
    log_header "PostgreSQL — Configuración del servicio"

    if ! validate_root; then
        log_fatal "Este script debe ejecutarse como root (sudo)"
    fi

    # T-1.7 (H-INST-006): agregar POSTGRES_PASSWORD a require_vars.
    # _secure_postgres() lo necesita para ALTER USER postgres.
    require_vars POSTGRES_VERSION DB_POSTGRES_USER POSTGRES_PASSWORD

    local pg_version="${POSTGRES_VERSION:-16}"
    log_info "Versión objetivo: PostgreSQL ${pg_version}"

    # Verificar que PostgreSQL está instalado antes de configurar
    if ! command -v psql &>/dev/null && \
       ! dpkg -l "postgresql-${pg_version}" 2>/dev/null | grep -q "^ii"; then
        log_fatal "PostgreSQL ${pg_version} no está instalado. Ejecutar primero: bash install.sh"
    fi

    # T-1.7 (H-INST-003, H-INST-007): PASO 0 — hardening del motor.
    # Se ejecuta ANTES de _configure_pg_hba porque scram-sha-256 en
    # pg_hba.conf requiere que el usuario 'postgres' tenga password.
    log_step 1 4 "Hardening del motor (password superusuario postgres)"
    if ! _secure_postgres; then
        log_fatal "No se pudo securizar PostgreSQL"
    fi

    log_step 2 4 "pg_hba.conf — autenticación"
    if ! _configure_pg_hba; then
        log_fatal "No se pudo configurar pg_hba.conf"
    fi
    log_success "pg_hba.conf configurado"

    log_step 3 4 "postgresql.conf — acceso remoto"
    if ! _configure_postgresql_conf; then
        log_warn "postgresql.conf no pudo configurarse — continuando"
    else
        log_success "postgresql.conf configurado"
    fi

    log_step 4 4 "Config IACT (symlink 99-iact.conf)"
    if ! _apply_iact_postgres_config; then
        log_warn "99-iact.conf no vinculado — continuando"
    fi

    log_info "Recargando PostgreSQL para aplicar cambios..."
    _reload_postgresql

    log_success "Configuración del servicio PostgreSQL completada"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

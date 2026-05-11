#!/bin/bash
# install.sh
# PostgreSQL installation script
# Version: 1.0.5 - Deteccion dinamica de codename OS (H-PG-003)

set -euo pipefail

# Load utilities

# Detectar PROJECT_ROOT (sin dependencia de /vagrant)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/database.sh"
source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/validation.sh"

# Main function
main() {
    log_header "PostgreSQL Installation"

    # Validate running as root
    if ! validate_root; then
        log_fatal "This script must be run as root"
    fi

    # Validate required variables
    require_vars POSTGRES_VERSION POSTGRES_PASSWORD

    # Ensure log directory
    if ! ensure_dir "${PROJECT_ROOT}/logs"; then
        log_error "Failed to create log directory"
        return 1
    fi

    # Detectar y manejar versión incorrecta pre-instalada
    if ! _ensure_correct_postgres_version; then
        log_fatal "No se pudo asegurar la versión correcta de PostgreSQL"
    fi

    # Add PostgreSQL repository
    if ! add_postgresql_repository; then
        log_error "Failed to add PostgreSQL repository"
        return 1
    fi

    # Install PostgreSQL
    if ! install_postgresql; then
        log_error "Failed to install PostgreSQL"
        return 1
    fi

    # Set PostgreSQL password
    if ! set_postgres_password; then
        log_error "Failed to set postgres password"
        return 1
    fi

    log_success "PostgreSQL installation completed"
    return 0
}

# _ensure_correct_postgres_version
#
# Detecta si hay una versión incorrecta de PostgreSQL instalada y la purga
# antes de instalar la versión correcta.
#
# Escenario que resuelve: servidor con PG14 preinstalado, se requiere PG16.
#   Sin esta función: apt instala PG16 pero PG14 sigue corriendo en el puerto
#   5432 — PG16 no puede iniciar. Estado inconsistente.
#   Con esta función: PG14 se detiene y purga antes de instalar PG16.
#
# Idempotente: si la versión correcta ya está instalada, no hace nada.
_ensure_correct_postgres_version() {
    local target="${POSTGRES_VERSION:-16}"

    local installed
    installed=$(dpkg -l 'postgresql-[0-9]*' 2>/dev/null \
        | awk '/^ii/{print $2}' | grep -oP '(?<=postgresql-)\d+' | sort -n)

    if [[ -z "$installed" ]]; then
        log_info "PostgreSQL no instalado — instalación desde cero"
        return 0
    fi

    log_info "Versiones instaladas: $(echo "$installed" | tr '\n' ' ')"

    local wrong=() correct_found=false
    while IFS= read -r ver; do
        [[ "$ver" == "$target" ]] && correct_found=true || wrong+=("$ver")
    done <<< "$installed"

    if $correct_found && [[ ${#wrong[@]} -eq 0 ]]; then
        log_success "PostgreSQL ${target} ya instalado — sin cambios"
        return 0
    fi

    if [[ ${#wrong[@]} -gt 0 ]]; then
        log_warn "Versiones incorrectas: ${wrong[*]} (se requiere ${target})"
        for ver in "${wrong[@]}"; do
            log_info "  Deteniendo postgresql@${ver}..."
            pg_ctlcluster "${ver}" main stop 2>/dev/null \
                || systemctl stop "postgresql@${ver}-main" 2>/dev/null \
                || true

            log_info "  Purgando postgresql-${ver}..."
            DEBIAN_FRONTEND=noninteractive apt-get purge -y \
                "postgresql-${ver}" "postgresql-client-${ver}" \
                "postgresql-contrib-${ver}" 2>/dev/null || true

            [[ -d "/etc/postgresql/${ver}" ]] \
                && rm -rf "/etc/postgresql/${ver}" \
                && log_info "  Configuración huérfana /etc/postgresql/${ver} eliminada"
        done
        apt-get autoremove -y 2>/dev/null || true
        log_success "Versiones incorrectas purgadas"
    fi

    return 0
}

# Add PostgreSQL repository
# H-PG-003: detecta el codename del SO en tiempo de ejecucion.
# Ubuntu 20.04 (focal) usa el repo archivado; el resto usa el repo activo de PGDG.
add_postgresql_repository() {
    log_info "Adding PostgreSQL ${POSTGRES_VERSION} repository"

    # Prereqs
    for pkg in wget ca-certificates gnupg curl lsb-release; do
        if ! install_package "$pkg"; then
            log_error "Failed to install prerequisite: ${pkg}"
            return 1
        fi
    done

    if ! ensure_dir /usr/share/keyrings; then
        log_error "Failed to create keyrings directory"
        return 1
    fi

    # GPG key
    log_info "Importing PostgreSQL GPG key"
    local keyring_file="/usr/share/keyrings/postgresql-archive-keyring.gpg"

    if [[ ! -f "$keyring_file" ]]; then
        if ! wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc \
                | gpg --dearmor -o "$keyring_file" 2>/dev/null; then
            log_error "Failed to import GPG key"
            return 1
        fi
        log_success "GPG key imported"
    else
        log_info "GPG key already exists"
    fi

    # Detectar codename del SO (H-PG-003)
    local os_codename
    os_codename=$(lsb_release -cs 2>/dev/null \
        || { . /etc/os-release 2>/dev/null && echo "${VERSION_CODENAME:-}"; } \
        || echo "")

    if [[ -z "$os_codename" ]]; then
        log_error "No se pudo determinar el codename del SO"
        return 1
    fi

    log_info "OS codename detectado: ${os_codename}"

    # focal (Ubuntu 20.04) usa el repo archivado; cualquier otro usa el activo
    local repo_base repo_suite
    case "$os_codename" in
        focal)
            repo_base="https://apt-archive.postgresql.org/pub/repos/apt"
            log_info "Ubuntu 20.04 (focal) — usando repo PGDG archivado"
            ;;
        *)
            repo_base="https://apt.postgresql.org/pub/repos/apt"
            log_info "Ubuntu ${os_codename} — usando repo PGDG activo"
            ;;
    esac
    repo_suite="${os_codename}-pgdg"

    # Escribir sources.list.d
    local repo_file="/etc/apt/sources.list.d/pgdg.list"
    cat > "$repo_file" << EOF
# PostgreSQL ${POSTGRES_VERSION} repository — ${os_codename}
deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] ${repo_base} ${repo_suite} main
EOF

    if [[ ! -f "$repo_file" ]]; then
        log_error "Failed to create repository file"
        return 1
    fi

    log_info "Repository configuration:"
    cat "$repo_file"

    # Verificar conectividad al repo seleccionado
    local test_url="${repo_base}/dists/${repo_suite}/Release"
    log_info "Verificando conectividad: ${test_url}"
    if curl -s -o /dev/null -w "%{http_code}" "$test_url" | grep -q "200"; then
        log_success "Repositorio accesible"
    else
        log_warn "Repositorio puede no ser accesible (continuando de todas formas)"
    fi

    # apt-get update
    log_info "Updating package index"
    if ! apt-get update 2>&1 | tee /tmp/apt-update.log; then
        log_error "Failed to update package index"
        log_error "APT errors:"
        cat /tmp/apt-update.log
        log_error "Repository file content:"
        cat "$repo_file"
        log_error "Keyring file exists:"
        ls -la /usr/share/keyrings/postgresql-archive-keyring.gpg || echo "NOT FOUND"
        return 1
    fi

    log_success "PostgreSQL repository added (${os_codename})"
    return 0
}

# Install PostgreSQL packages
install_postgresql() {
    log_info "Installing PostgreSQL ${POSTGRES_VERSION}"

    # Install PostgreSQL server and contrib
    if ! install_package postgresql-${POSTGRES_VERSION}; then
        log_error "Failed to install postgresql-${POSTGRES_VERSION}"
        return 1
    fi

    if ! install_package postgresql-contrib-${POSTGRES_VERSION}; then
        log_error "Failed to install postgresql-contrib-${POSTGRES_VERSION}"
        return 1
    fi

    # Start PostgreSQL service
    if ! start_service postgresql; then
        log_error "Failed to start PostgreSQL service"
        return 1
    fi

    # Wait for PostgreSQL to be ready
    log_info "Waiting for PostgreSQL to be ready"
    if ! postgres_wait_ready 30; then
        log_error "PostgreSQL did not start within 30 seconds"
        return 1
    fi

    log_success "PostgreSQL installed and started"
    return 0
}

# Configure PostgreSQL for remote access
configure_postgresql() {
    log_info "Configuring PostgreSQL for remote access"

    local pg_hba_conf="/etc/postgresql/${POSTGRES_VERSION}/main/pg_hba.conf"
    local postgresql_conf="/etc/postgresql/${POSTGRES_VERSION}/main/postgresql.conf"

    # Validate config files exist
    if ! validate_file_exists "$pg_hba_conf"; then
        log_error "Config file not found: $pg_hba_conf"
        return 1
    fi

    if ! validate_file_exists "$postgresql_conf"; then
        log_error "Config file not found: $postgresql_conf"
        return 1
    fi

    # Configure pg_hba.conf for remote access
    log_info "Configuring pg_hba.conf for remote access"

    # Backup pg_hba.conf
    if ! backup_file "$pg_hba_conf"; then
        log_error "Failed to backup pg_hba.conf"
        return 1
    fi

    # H-PG-002: Regla socket Unix para django_user
    # django_user no existe como usuario del SO — peer auth falla.
    # Se inserta ANTES de la primera linea "local all all peer".
    log_info "Configurando autenticacion local por socket Unix para django_user"

    local socket_user="${DB_POSTGRES_USER:-django_user}"
    local socket_rule="local   all             ${socket_user}                          scram-sha-256"

    if ! grep -qE "^local\s+all\s+${socket_user}\s+scram-sha-256" "$pg_hba_conf"; then
        # Insertar antes de la primera regla "local all all peer"
        if grep -qE "^local\s+all\s+all\s+peer" "$pg_hba_conf"; then
            sed -i "/^local[[:space:]]\+all[[:space:]]\+all[[:space:]]\+peer/i ${socket_rule}" \
                "$pg_hba_conf"
        else
            # Si no existe la linea peer generica, agregar al final del bloque local
            echo "" >> "$pg_hba_conf"
            echo "# Socket Unix — autenticacion por password para ${socket_user}" >> "$pg_hba_conf"
            echo "$socket_rule" >> "$pg_hba_conf"
        fi
        log_success "Regla socket Unix agregada para ${socket_user}"
    else
        log_info "Regla socket Unix para ${socket_user} ya existe"
    fi

    # Permitir conexiones desde localhost (loopback) — suficiente para desarrollo local
    # Para acceso remoto, ajustar POSTGRES_REMOTE_CIDR en .env
    local remote_cidr="${POSTGRES_REMOTE_CIDR:-127.0.0.1/32}"
    local remote_rule="host    all             all             ${remote_cidr}         md5"

    if ! grep -q "$remote_cidr" "$pg_hba_conf"; then
        echo "" >> "$pg_hba_conf"
        echo "# Allow connections from configured CIDR" >> "$pg_hba_conf"
        echo "$remote_rule" >> "$pg_hba_conf"
        log_success "Added remote access rule for ${remote_cidr} to pg_hba.conf"
    else
        log_warn "Remote access rule already exists in pg_hba.conf"
    fi

    # Configure postgresql.conf to listen on all addresses
    log_info "Configuring postgresql.conf to listen on all addresses"

    # Backup postgresql.conf
    if ! backup_file "$postgresql_conf"; then
        log_error "Failed to backup postgresql.conf"
        return 1
    fi

    # Set listen_addresses
    if grep -q "^listen_addresses" "$postgresql_conf"; then
        sed -i "s/^listen_addresses.*/listen_addresses = '*'/" "$postgresql_conf"
    elif grep -q "^#listen_addresses" "$postgresql_conf"; then
        sed -i "s/^#listen_addresses.*/listen_addresses = '*'/" "$postgresql_conf"
    else
        echo "listen_addresses = '*'" >> "$postgresql_conf"
    fi

    # Verify the change was made
    if ! grep -q "listen_addresses = '\*'" "$postgresql_conf"; then
        log_error "Failed to set listen_addresses"
        return 1
    fi

    log_success "Configuration updated"

    # Restart PostgreSQL to apply changes
    log_info "Restarting PostgreSQL to apply configuration"
    if ! restart_service postgresql; then
        log_error "Failed to restart PostgreSQL"
        return 1
    fi

    # Wait for PostgreSQL to be ready again
    if ! postgres_wait_ready 30; then
        log_error "PostgreSQL did not restart within 30 seconds"
        return 1
    fi

    log_success "PostgreSQL configured for remote access"
    return 0
}

# _apply_iact_postgres_config
#
# Crea un symlink de config/postgres/99-iact.conf en conf.d/ del sistema.
# postgresql.conf ya tiene: include_dir = 'conf.d'
#
# Misma capa que configure_postgresql() — ambas configuran el servicio del SO,
# no la base de datos. Movida desde setup.sh para consistencia con MariaDB
# (donde _apply_iact_mariadb_config vive en install.sh).
#
# Fuente de verdad: el repo. El symlink es transparente para PostgreSQL.
_apply_iact_postgres_config() {
    local repo_config="${PROJECT_ROOT}/config/postgres/99-iact.conf"
    local pg_version="${POSTGRES_VERSION:-16}"
    local conf_d="/etc/postgresql/${pg_version}/main/conf.d"
    local system_link="${conf_d}/99-iact.conf"

    if [[ ! -f "$repo_config" ]]; then
        log_warn "_apply_iact_postgres_config: no encontrado ${repo_config} — omitido"
        return 0
    fi

    if [[ ! -d "$conf_d" ]]; then
        log_warn "conf.d no existe en ${conf_d} — omitido"
        log_warn "  Verificar que postgresql.conf tiene: include_dir = 'conf.d'"
        return 0
    fi

    if ln -sf "$repo_config" "$system_link" 2>/dev/null; then
        log_success "PostgreSQL config vinculada: ${system_link} → ${repo_config}"
    else
        log_error "No se pudo crear symlink: ${system_link}"
        log_error "  Ejecutar manualmente: sudo ln -sf ${repo_config} ${system_link}"
        return 1
    fi

    return 0
}

# Set postgres user password
set_postgres_password() {
    log_info "Setting postgres user password"

    # Set password for postgres user
    if ! sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';" 2>/dev/null; then
        log_error "Failed to set postgres password"
        return 1
    fi

    log_success "Postgres password set successfully"
    return 0
}

# Note: main() is called by bootstrap.sh, not auto-executed
#!/bin/bash
# install.sh
# MariaDB installation script — version 2.0.0
#
# CAMBIOS v2.0.0 (2026-05-07):
#   - MARIADB_VERSION corregida a 10.11 en .env/.env.example
#   - OS codename dinamico: lsb_release -cs (no mas 'focal' hardcodeado)
#   - GPG key via /usr/share/keyrings/ (apt-key esta deprecated en Ubuntu 22.04+)
#   - Apt preferences para pinear serie 10.11.x (evita saltos a 11.x)
#   - Verificacion de version instalada al final del proceso
#   - Para Ubuntu 24.04 (noble): MariaDB 10.11.14 ya esta en repos oficiales
#     de Ubuntu, el repo de MariaDB.org se agrega solo si es necesario

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/database.sh"
source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/validation.sh"

# Version minima requerida de la serie (sin patch): 10.11
MARIADB_SERIES="${MARIADB_VERSION}"   # ej: "10.11"
# Version exacta que se quiere garantizar
MARIADB_EXACT="10.11.14"

main() {
    log_header "MariaDB Installation"

    if ! validate_root; then
        log_fatal "This script must be run as root"
    fi

    require_vars MARIADB_VERSION DB_ROOT_PASSWORD

    if ! ensure_dir "${PROJECT_ROOT}/logs"; then
        log_error "Failed to create log directory"
        return 1
    fi

    # Detectar OS
    OS_CODENAME=$(lsb_release -cs 2>/dev/null || echo "noble")
    log_info "OS detectado: $(lsb_release -ds 2>/dev/null) (${OS_CODENAME})"

    # Verificar si la version requerida ya esta disponible en repos del sistema
    if apt-cache show "mariadb-server" 2>/dev/null \
            | grep -q "Version: 1:${MARIADB_EXACT}"; then
        log_info "MariaDB ${MARIADB_EXACT} disponible en repos del sistema."
        log_info "No es necesario agregar el repo de MariaDB.org."
    else
        log_info "MariaDB ${MARIADB_EXACT} no encontrada en repos del sistema."
        log_info "Agregando repo oficial de MariaDB.org..."
        if ! add_mariadb_repository "$OS_CODENAME"; then
            log_error "Failed to add MariaDB repository"
            return 1
        fi
    fi

    # Pinear serie 10.11 antes de instalar
    if ! pin_mariadb_series; then
        log_error "Failed to pin MariaDB series"
        return 1
    fi

    if ! install_mariadb; then
        log_error "Failed to install MariaDB"
        return 1
    fi

    if ! configure_mariadb; then
        log_error "Failed to configure MariaDB"
        return 1
    fi

    if ! secure_mariadb; then
        log_error "Failed to secure MariaDB"
        return 1
    fi

    if ! verify_mariadb_version; then
        log_error "Version verification failed"
        return 1
    fi

    log_success "MariaDB installation completed"
    return 0
}

# Agregar repositorio oficial de MariaDB.org
add_mariadb_repository() {
    local codename="$1"
    log_info "Adding MariaDB ${MARIADB_SERIES} repository for Ubuntu ${codename}"

    if ! install_package software-properties-common; then return 1; fi
    if ! install_package dirmngr; then return 1; fi
    if ! install_package apt-transport-https; then return 1; fi
    if ! install_package curl; then return 1; fi
    if ! install_package gpg; then return 1; fi

    # Importar GPG key via /usr/share/keyrings/ (no apt-key — deprecated Ubuntu 22.04+)
    local keyring="/usr/share/keyrings/mariadb.gpg"
    log_info "Importing MariaDB GPG key -> ${keyring}"
    if ! curl -fsSL https://mariadb.org/mariadb_release_signing_key.asc \
            | gpg --dearmor \
            | tee "$keyring" > /dev/null; then
        log_error "Failed to import GPG key"
        return 1
    fi

    # Agregar repo con codename dinamico y signed-by
    local repo_file="/etc/apt/sources.list.d/mariadb.list"
    cat > "$repo_file" << EOF
# MariaDB ${MARIADB_SERIES} — agregado por IACT-db install.sh
deb [arch=amd64 signed-by=${keyring}] https://downloads.mariadb.com/MariaDB/mariadb-${MARIADB_SERIES}/repo/ubuntu ${codename} main
EOF

    log_info "Repo agregado: ${repo_file}"
    if ! apt-get update -qq; then
        log_error "Failed to update package index"
        return 1
    fi

    log_success "MariaDB repository added"
    return 0
}

# Pinear la serie 10.11 para evitar saltos automaticos a 11.x
pin_mariadb_series() {
    local pref_file="/etc/apt/preferences.d/mariadb-pin"
    log_info "Pineando MariaDB serie ${MARIADB_SERIES}.x en ${pref_file}"

    cat > "$pref_file" << EOF
# Pinear MariaDB a la serie ${MARIADB_SERIES}.x
# Permite actualizaciones de patch (${MARIADB_SERIES}.14 -> ${MARIADB_SERIES}.15)
# pero bloquea saltos de serie (${MARIADB_SERIES} -> 11.x)
# Generado por: provisioners/mariadb/install.sh
Package: mariadb-server mariadb-client mariadb-common
Pin: version 1:${MARIADB_SERIES}.*
Pin-Priority: 1001
EOF

    log_success "MariaDB serie ${MARIADB_SERIES}.x pineada"
    return 0
}

# Instalar MariaDB pineando a version exacta si esta disponible
install_mariadb() {
    log_info "Installing MariaDB ${MARIADB_EXACT}"

    export DEBIAN_FRONTEND=noninteractive

    debconf-set-selections <<< "mariadb-server mysql-server/root_password password ${DB_ROOT_PASSWORD}"
    debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password ${DB_ROOT_PASSWORD}"

    # Intentar instalar version exacta; si no esta disponible, instalar la
    # mejor de la serie 10.11.x disponible
    local pkg_exact
    pkg_exact=$(apt-cache show mariadb-server 2>/dev/null \
        | grep "^Version:" \
        | grep "1:${MARIADB_EXACT}" \
        | head -1 \
        | awk '{print $2}')

    if [ -n "$pkg_exact" ]; then
        log_info "Instalando version exacta: ${pkg_exact}"
        apt-get install -y \
            "mariadb-server=${pkg_exact}" \
            "mariadb-client=${pkg_exact}" \
            2>/dev/null
    else
        log_info "Version exacta ${MARIADB_EXACT} no disponible."
        log_info "Instalando mejor disponible de la serie ${MARIADB_SERIES}.x..."
        if ! install_package mariadb-server; then
            log_error "Failed to install mariadb-server"
            return 1
        fi
        if ! install_package mariadb-client; then
            log_error "Failed to install mariadb-client"
            return 1
        fi
    fi

    if ! enable_service mariadb; then
        log_error "Failed to enable MariaDB service"
        return 1
    fi

    if ! start_service mariadb; then
        log_error "Failed to start MariaDB service"
        return 1
    fi

    if ! mysql_wait_ready 30; then
        log_error "MariaDB did not start within 30 seconds"
        return 1
    fi

    log_success "MariaDB installed and started"
    return 0
}

# Configurar MariaDB para acceso remoto
configure_mariadb() {
    log_info "Configuring MariaDB"

    local config_file="/etc/mysql/mariadb.conf.d/50-server.cnf"

    if ! validate_file_exists "$config_file"; then
        log_error "Config file not found: $config_file"
        return 1
    fi

    if ! backup_file "$config_file"; then
        log_error "Failed to backup configuration file"
        return 1
    fi

    if grep -q "^bind-address" "$config_file"; then
        sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' "$config_file"
    else
        sed -i '/^\[mysqld\]/a bind-address = 0.0.0.0' "$config_file"
    fi

    if ! grep -q "bind-address = 0.0.0.0" "$config_file"; then
        log_error "Failed to set bind-address"
        return 1
    fi

    if ! restart_service mariadb; then
        log_error "Failed to restart MariaDB"
        return 1
    fi

    if ! mysql_wait_ready 30; then
        log_error "MariaDB did not restart within 30 seconds"
        return 1
    fi

    log_success "MariaDB configured"
    return 0
}

# Asegurar la instalacion
secure_mariadb() {
    log_info "Securing MariaDB installation"

    mysql -u root -p"${DB_ROOT_PASSWORD}" \
        -e "DELETE FROM mysql.user WHERE User='';" 2>/dev/null || true

    mysql -u root -p"${DB_ROOT_PASSWORD}" \
        -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" \
        2>/dev/null || true

    mysql -u root -p"${DB_ROOT_PASSWORD}" \
        -e "DROP DATABASE IF EXISTS test;" 2>/dev/null || true

    mysql -u root -p"${DB_ROOT_PASSWORD}" \
        -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';" 2>/dev/null || true

    mysql -u root -p"${DB_ROOT_PASSWORD}" \
        -e "FLUSH PRIVILEGES;" 2>/dev/null || {
        log_error "Failed to flush privileges"
        return 1
    }

    log_success "MariaDB secured"
    return 0
}

# Verificar que la version instalada es la correcta
verify_mariadb_version() {
    log_info "Verificando version instalada..."

    local version_installed
    version_installed=$(mysql --version 2>/dev/null \
        | grep -o '[0-9]*\.[0-9]*\.[0-9]*-MariaDB' \
        | head -1)

    if [ -z "$version_installed" ]; then
        log_error "No se pudo obtener la version instalada"
        return 1
    fi

    log_info "Version instalada: ${version_installed}"

    # Verificar que es de la serie correcta (10.11.x)
    if echo "$version_installed" | grep -q "^${MARIADB_SERIES}\."; then
        log_success "Version correcta: ${version_installed} (serie ${MARIADB_SERIES})"
        return 0
    else
        log_error "Version incorrecta: ${version_installed}"
        log_error "Se esperaba serie: ${MARIADB_SERIES}.x"
        return 1
    fi
}

# Note: main() es llamado por bootstrap.sh

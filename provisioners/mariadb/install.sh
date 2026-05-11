#!/bin/bash
# install.sh
# MariaDB installation script — version 2.2.0
#
# CAMBIOS v2.0.0 (2026-05-07):
#   - MARIADB_VERSION corregida a 10.11 en .env/.env.example
#   - OS codename dinamico: lsb_release -cs (no mas 'focal' hardcodeado)
#   - GPG key via /usr/share/keyrings/ (apt-key esta deprecated en Ubuntu 22.04+)
#   - Apt preferences para pinear serie 10.11.x (evita saltos a 11.x)
#   - Verificacion de version instalada al final del proceso
#   - Para Ubuntu 24.04 (noble): MariaDB 10.11.14 ya esta en repos oficiales
#     de Ubuntu, el repo de MariaDB.org se agrega solo si es necesario
#
# CAMBIOS v2.1.0 (2026-05-10):
#   - H-MDB-003: require_vars y debconf-set-selections usan DB_MARIADB_ROOT_PASSWORD
#   - H-MDB-004: secure_mariadb() detecta unix_socket auth antes de intentar password
#   - H-MDB-007: configure_mariadb() detecta io_uring y escribe innodb_use_native_aio=0
#               si no esta disponible (Firecracker, contenedores con seccomp)
#   - H-MDB-008: install_mariadb() verifica ibdata1 y ejecuta mysql_install_db si ausente
#   - apt-get update antes de instalar para resolver 404 por indice obsoleto
#
# CAMBIOS v2.2.0 (2026-05-11) — FASE 2 plan Alternativa E:
#   - T-2.6 (H-INST-001): secure_mariadb() movida a config.sh/_secure_mariadb()
#     install.sh ahora es puro INSTALL: _ensure_correct_mariadb_version,
#     add_mariadb_repository, pin_mariadb_series, install_mariadb, verify_mariadb_version
#
# =============================================================================
# EFECTOS POST-INSTALACIÓN ejecutados por config.sh/_secure_mariadb()
# =============================================================================
# T-5.2 (H-SEC-002, H-SEC-003): la securización ocurre en config.sh (capa CONFIG),
# no aquí. Se documenta en install.sh porque el operador que instala MariaDB
# debe conocer el estado resultante del sistema.
#
# _secure_mariadb() ejecuta el equivalente de mysql_secure_installation:
#
#   1. Usuarios anónimos eliminados:
#      DELETE FROM mysql.user WHERE User=''
#      → Las conexiones sin credenciales son rechazadas
#
#   2. root@TCP bloqueado:
#      DELETE FROM mysql.user WHERE User='root'
#        AND Host NOT IN ('localhost','127.0.0.1','::1')
#      → root solo puede conectarse via socket Unix o loopback
#      → Los scripts del proyecto usan socket Unix exclusivamente
#      → El fallback TCP de schema_historico.sh nunca se activa
#        en entornos securizados: es el comportamiento correcto
#
#   3. Base de datos 'test' eliminada:
#      DROP DATABASE IF EXISTS test
#      DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'
#
#   4. Password de root establecido:
#      ALTER USER 'root'@'localhost'
#        IDENTIFIED BY '${DB_MARIADB_ROOT_PASSWORD}'
#      → Autenticación unix_socket sigue funcionando (Ubuntu 24.04)
#      → Además requiere password para conexiones TCP al loopback
#
# =============================================================================

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

    # T-2.6 (H-INST-001): DB_MARIADB_ROOT_PASSWORD se mantiene en require_vars
    # porque _ensure_correct_mariadb_version lo usa para detectar la versión
    # instalada autenticándose si unix_socket no está disponible.
    # secure_mariadb() fue movida a config.sh/_secure_mariadb().
    require_vars MARIADB_VERSION DB_MARIADB_ROOT_PASSWORD

    if ! ensure_dir "${PROJECT_ROOT}/logs"; then
        log_error "Failed to create log directory"
        return 1
    fi

    # Detectar y purgar versión incorrecta antes de instalar
    if ! _ensure_correct_mariadb_version; then
        log_fatal "No se pudo asegurar la versión correcta de MariaDB"
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

    # Nota: el hardening (usuarios anónimos, BD test, password root) se
    # realiza en config.sh/_secure_mariadb() — capa CONFIG, no INSTALL.
    # El orden install → config → setup garantiza que el motor está instalado
    # antes de configurarlo.

    if ! verify_mariadb_version; then
        log_error "Version verification failed"
        return 1
    fi

    log_success "MariaDB installation completed"
    return 0
}

# _ensure_correct_mariadb_version
#
# Detecta si hay una versión incorrecta de MariaDB instalada y la purga.
# apt no hace downgrade automático — si el servidor tiene MariaDB 11.4
# y se requiere 10.11, la instalación falla sin esta purga previa.
#
# Idempotente: si la versión correcta ya está instalada, no hace nada.
_ensure_correct_mariadb_version() {
    local target_series="${MARIADB_SERIES}"  # ej: "10.11"

    # Detectar versión instalada
    local installed_version
    installed_version=$(mysql --version 2>/dev/null \
        | grep -oP '\d+\.\d+\.\d+-MariaDB' | head -1)

    if [[ -z "$installed_version" ]]; then
        log_info "MariaDB no instalado — instalación desde cero"
        return 0
    fi

    local installed_series
    installed_series=$(echo "$installed_version" | grep -oP '^\d+\.\d+')

    log_info "Versión instalada: ${installed_version} (serie ${installed_series})"

    if [[ "$installed_series" == "$target_series" ]]; then
        log_success "Serie correcta ${target_series} ya instalada — sin cambios"
        return 0
    fi

    log_warn "Serie incorrecta: ${installed_series} (se requiere ${target_series})"
    log_warn "apt no hace downgrade automático — purgando versión incorrecta"

    # Detener el servicio
    service mariadb stop 2>/dev/null \
        || systemctl stop mariadb 2>/dev/null \
        || pkill -f mariadbd 2>/dev/null \
        || true
    sleep 2

    # Purgar paquetes de la serie incorrecta
    DEBIAN_FRONTEND=noninteractive apt-get purge -y \
        mariadb-server mariadb-client mariadb-common \
        "mariadb-server-${installed_series}" \
        "mariadb-client-${installed_series}" \
        2>/dev/null || true

    # Limpiar archivos de configuración y datos del repo anterior
    rm -f /etc/apt/sources.list.d/mariadb.list
    rm -f /etc/apt/preferences.d/mariadb-pin
    apt-get autoremove -y 2>/dev/null || true
    apt-get update -qq 2>/dev/null || true

    log_success "Versión incorrecta (${installed_version}) purgada"
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

    # Actualizar el indice de paquetes antes de instalar.
    # El 404 de iproute2 en la sesion anterior fue causado por un indice obsoleto
    # que apuntaba a una version ya no disponible en el mirror.
    # Un apt-get update fresco resuelve la referencia correcta y evita el error.
    log_info "Actualizando indice de paquetes antes de instalar"
    if ! apt-get update -qq 2>/dev/null; then
        log_warn "apt-get update retorno error — continuando (puede haber repos opcionales fallando)"
    fi

    debconf-set-selections <<< "mariadb-server mysql-server/root_password password ${DB_MARIADB_ROOT_PASSWORD}"
    debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password ${DB_MARIADB_ROOT_PASSWORD}"

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

    # H-MDB-008: verificar e inicializar datadir si el postinst no lo hizo
    # Ocurre cuando mariadb-server falla parcialmente (ej. iproute2 404) y solo
    # mariadb-server-core queda instalado — el postinst no ejecuta mysql_install_db.
    # Sin ibdata1, mariadbd arranca, intenta leer el datadir y termina silenciosamente.
    if [[ ! -f /var/lib/mysql/ibdata1 ]]; then
        log_info "H-MDB-008: datadir no inicializado (ibdata1 ausente) — ejecutando instalacion"

        local init_cmd=""
        if   command -v mariadb-install-db &>/dev/null; then init_cmd="mariadb-install-db"
        elif command -v mysql_install_db    &>/dev/null; then init_cmd="mysql_install_db"
        else
            log_error "No se encontro mariadb-install-db ni mysql_install_db"
            return 1
        fi

        if ! "$init_cmd" --user=mysql --datadir=/var/lib/mysql 2>/dev/null; then
            log_error "Fallo la inicializacion del datadir via ${init_cmd}"
            return 1
        fi

        log_success "Datadir inicializado via ${init_cmd}"
    else
        log_info "Datadir ya inicializado (ibdata1 presente)"
    fi

    if ! enable_service mariadb; then
        log_error "Failed to enable MariaDB service"
        return 1
    fi

    if ! start_service mariadb; then
        log_error "Failed to start MariaDB service"
        return 1
    fi

    # H-MDB-006: si MariaDB no responde en 30s, mostrar ultimas lineas del log de error
    if ! mysql_wait_ready 30; then
        log_error "MariaDB did not start within 30 seconds"
        local error_log
        for f in /var/log/mysql/error.log /var/lib/mysql/*.err /tmp/mariadbd_startup.log; do
            [[ -f "$f" ]] && error_log="$f" && break
        done
        if [[ -n "${error_log:-}" ]]; then
            log_error "Ultimas lineas de ${error_log}:"
            tail -20 "$error_log" | while IFS= read -r line; do
                log_error "  ${line}"
            done
        fi
        return 1
    fi

    log_success "MariaDB installed and started"
    return 0
}

# Nota: la configuración del servicio (bind-address, AIO, symlink 99-iact.cnf,
# hardening de root) se realiza en config.sh (capa CONFIG).
# El aprovisionamiento de la BD se realiza en setup.sh (capa SETUP).

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

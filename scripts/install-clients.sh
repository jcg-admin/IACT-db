#!/bin/bash
# =============================================================================
# scripts/install-clients.sh — Instala clientes de BD necesarios para verify.sh
# =============================================================================
# IDEMPOTENTE: verifica con dpkg-query antes de instalar.
# Requiere sudo / root.
#
# Uso:
#   sudo bash scripts/install-clients.sh
#   # invocado automáticamente por bootstrap.sh si los clientes no están
#
# Paquetes:
#   mariadb-client        — cliente mysql (para verify.sh y setup.sh)
#   postgresql-client     — cliente psql  (para verify.sh y setup.sh)
#   libpq-dev             — headers para compilar psycopg2
#   default-libmysqlclient-dev — headers para compilar mysqlclient
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/validation.sh"

TOTAL_STEPS=3

# =============================================================================
# Helpers
# =============================================================================
is_installed() {
    dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "^install ok installed"
}

install_if_missing() {
    local pkg="$1"
    local desc="${2:-$1}"

    if is_installed "$pkg"; then
        log_info "  Ya instalado: ${pkg}"
        return 0
    fi

    log_info "  Instalando: ${pkg} (${desc})"
    if DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "$pkg" 2>/dev/null; then
        log_success "  OK: ${pkg}"
    else
        log_warn "  No disponible en apt: ${pkg} — puede instalarse de otra forma"
    fi
}

cmd_available() { command -v "$1" &>/dev/null; }

# =============================================================================
# PASO 1 — Prerequisitos
# =============================================================================
check_prerequisites() {
    log_step 1 $TOTAL_STEPS "Prerequisitos"

    if ! validate_root; then
        log_fatal "Ejecuta con: sudo bash scripts/install-clients.sh"
    fi

    command -v apt-get &>/dev/null \
        || { log_fatal "apt-get no disponible — ¿es Ubuntu/Debian?"; exit 1; }

    # Actualizar índice si tiene más de 1 hora de antigüedad
    local stamp="/var/lib/apt/lists/lock"
    if [[ -f "$stamp" ]]; then
        local age=$(( $(date +%s) - $(stat -c %Y "$stamp" 2>/dev/null || echo 0) ))
        if [[ $age -gt 3600 ]]; then
            log_info "Actualizando índice apt..."
            apt-get update -qq 2>/dev/null || log_warn "apt-get update con advertencias"
        fi
    fi

    log_success "Prerequisitos OK"
}

# =============================================================================
# PASO 2 — Instalar clientes y headers de compilación
# =============================================================================
install_packages() {
    log_step 2 $TOTAL_STEPS "Instalando paquetes"

    echo ""

    # Clientes CLI (necesarios para verify.sh)
    log_info "Clientes de BD:"
    install_if_missing "mariadb-client"   "mysql CLI para verify.sh"
    install_if_missing "postgresql-client" "psql CLI para verify.sh"

    echo ""

    # Headers de compilación (necesarios para los drivers Python)
    log_info "Headers de compilación:"
    install_if_missing "libpq-dev"                    "compilar psycopg2"
    install_if_missing "default-libmysqlclient-dev"   "compilar mysqlclient"

    echo ""
    log_success "Paquetes procesados"
}

# =============================================================================
# PASO 3 — Verificar herramientas disponibles
# =============================================================================
verify_tools() {
    log_step 3 $TOTAL_STEPS "Verificando herramientas"

    local all_ok=true

    local tools=(
        "mysql:mysql CLI (MariaDB client)"
        "psql:psql CLI (PostgreSQL client)"
        "pg_isready:pg_isready (PostgreSQL health check)"
        "mysqladmin:mysqladmin (MariaDB health check)"
    )

    for entry in "${tools[@]}"; do
        local cmd="${entry%%:*}"
        local desc="${entry##*:}"
        if cmd_available "$cmd"; then
            local ver
            ver=$("$cmd" --version 2>&1 | head -1 || echo "disponible")
            log_success "  ${cmd}: ${ver}"
        else
            log_warn "  ${cmd} no disponible (${desc})"
            all_ok=false
        fi
    done

    echo ""
    if [[ "$all_ok" == "true" ]]; then
        log_success "Todas las herramientas disponibles"
    else
        log_warn "Algunas herramientas no disponibles — verify.sh puede tener limitaciones"
    fi
}

# =============================================================================
# MAIN
# =============================================================================
log_header "IACT-db — Instalación de clientes de BD"

check_prerequisites
install_packages
verify_tools

echo ""
log_success "Clientes instalados. Puedes ejecutar: bash verify.sh"

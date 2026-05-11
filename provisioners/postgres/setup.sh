#!/bin/bash
# =============================================================================
# provisioners/postgres/setup.sh — Crea BD y usuario para Django
# =============================================================================
# IDEMPOTENTE: se puede ejecutar N veces sin efectos adversos.
#   · Si el usuario ya existe     → actualiza contraseña
#   · Si la BD ya existe          → sin cambios
#   · GRANT es idempotente en PostgreSQL — se re-aplica siempre
#   · ALTER DEFAULT PRIVILEGES garantiza permisos en tablas futuras
#
# H-PG-005: main() NO se llama incondicionalmente.
#   · Ejecucion directa  (bash setup.sh)    → guard activa main()
#   · Source desde bootstrap.sh             → bootstrap.sh llama main() explicitamente
# El usuario recibe CREATEDB para que pytest cree test_iact_analytics.
#
# NO instala PostgreSQL. Requiere que el cluster esté corriendo.
# Portado de IACT-api provisioners/postgres/db_setup.sh (v1.0.0)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/database.sh"
source "${PROJECT_ROOT}/utils/validation.sh"

# Cargar .env si las variables no vienen del entorno (ejecución directa)
ENV_FILE="${PROJECT_ROOT}/.env"
if [[ -f "$ENV_FILE" ]]; then set -a; source "$ENV_FILE"; set +a; fi

main() {
    log_header "PostgreSQL Database Setup"

    if ! validate_root; then
        log_fatal "Este script debe ejecutarse como root (sudo)"
    fi

    require_vars DB_POSTGRES_NAME DB_POSTGRES_USER DB_POSTGRES_PASSWORD

    ensure_dir "${PROJECT_ROOT}/logs"

    local db_name="${DB_POSTGRES_NAME}"
    local db_user="${DB_POSTGRES_USER}"
    local db_pass="${DB_POSTGRES_PASSWORD}"
    local host="${POSTGRES_HOST:-127.0.0.1}"
    local port="${POSTGRES_PORT:-5432}"

    # --- Helper: ejecutar SQL como superusuario postgres ---
    pg_super()       { runuser -u postgres -- psql -v ON_ERROR_STOP=1 "$@" 2>&1 || su -c "psql -v ON_ERROR_STOP=1 $*" postgres 2>&1; }
    pg_super_quiet() { runuser -u postgres -- psql -v ON_ERROR_STOP=1 -tAq "$@" 2>/dev/null || su -c "psql -v ON_ERROR_STOP=1 -tAq $*" postgres 2>/dev/null; }

    # PASO 1 — Verificar que PostgreSQL responde
    log_step 1 5 "Verificando acceso a PostgreSQL"

    if ! pg_isready -h "$host" -p "$port" -q 2>/dev/null; then
        log_fatal "PostgreSQL no responde en ${host}:${port}"
    fi
    log_success "PostgreSQL activo en ${host}:${port}"

    # PASO 2 — Crear / actualizar usuario
    log_step 2 5 "Usuario: ${db_user}"

    local user_exists
    user_exists=$(pg_super_quiet -c \
        "SELECT 1 FROM pg_roles WHERE rolname = '${db_user}';" || echo "")

    if [[ "$user_exists" == "1" ]]; then
        pg_super -c "ALTER USER ${db_user} WITH PASSWORD '${db_pass}';" >/dev/null
        log_info "Usuario ya existe — contraseña sincronizada"
    else
        pg_super -c "CREATE USER ${db_user} WITH PASSWORD '${db_pass}';" >/dev/null
        log_success "Usuario ${db_user} creado"
    fi

    # PASO 3 — Crear base de datos
    log_step 3 5 "Base de datos: ${db_name}"

    local db_exists
    db_exists=$(pg_super_quiet -c \
        "SELECT 1 FROM pg_database WHERE datname = '${db_name}';" || echo "")

    if [[ "$db_exists" == "1" ]]; then
        log_info "Base de datos ya existe — sin cambios"
    else
        pg_super -c \
            "CREATE DATABASE ${db_name} OWNER ${db_user} ENCODING 'UTF8';" >/dev/null
        log_success "Base de datos ${db_name} creada"
    fi

    # PASO 4 — Otorgar privilegios completos
    log_step 4 5 "Privilegios: ${db_user} en ${db_name}"

    pg_super -d "$db_name" <<SQL >/dev/null
GRANT ALL PRIVILEGES ON DATABASE ${db_name} TO ${db_user};
GRANT ALL ON SCHEMA public TO ${db_user};
GRANT ALL PRIVILEGES ON ALL TABLES    IN SCHEMA public TO ${db_user};
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${db_user};
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO ${db_user};
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES    TO ${db_user};
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO ${db_user};
-- pytest necesita crear/destruir test_iact_analytics
ALTER ROLE ${db_user} CREATEDB;
SQL

    log_success "Privilegios aplicados (incluye CREATEDB para tests)"

    # Instalar extensiones útiles
    for ext in uuid-ossp pg_trgm hstore citext; do
        sudo -u postgres psql -d "$db_name" \
            -c "CREATE EXTENSION IF NOT EXISTS \"${ext}\";" >/dev/null 2>&1 \
            && log_info "Extensión ${ext}: OK" \
            || log_warn "Extensión ${ext}: no disponible (opcional)"
    done

    # Vincular config/postgres/99-iact.conf al sistema via symlink.
    # Idempotente — ln -sf es seguro ejecutar N veces.
    _apply_iact_postgres_config

    # PASO 5 — Verificar conexión con credenciales Django
    log_step 5 5 "Verificando conexión Django"

    local result
    result=$(PGPASSWORD="$db_pass" \
        psql -h "$host" -p "$port" -U "$db_user" -d "$db_name" \
        -tAq -c "SELECT current_database() || '@' || current_user;" 2>&1) || {
        log_error "No se pudo conectar como ${db_user}: ${result}"
        return 1
    }

    log_success "Conexión OK: ${result}"

    echo ""
    log_success "Setup PostgreSQL completado. Listo para: python manage.py migrate"
    echo ""
    echo "  Django settings:"
    echo "    DATABASE default: HOST=${host} PORT=${port} NAME=${db_name} USER=${db_user}"
}

# _apply_iact_postgres_config
#
# Crea un symlink de config/postgres/99-iact.conf en conf.d/ del sistema.
# postgresql.conf ya tiene: include_dir = 'conf.d'
#
# Mismo principio que MariaDB: la fuente de verdad es el repo.
# El symlink es transparente para PostgreSQL — lee el archivo del repo directamente.
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

# H-PG-005: ejecutar main solo cuando el script es el punto de entrada directo.
# Al hacer source desde bootstrap.sh, main() es llamado explicitamente por bootstrap.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

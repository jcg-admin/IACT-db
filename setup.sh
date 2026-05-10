#!/bin/bash
# =============================================================================
# setup.sh — IACT-db: configura BDs sin instalar (BDs ya instaladas)
# =============================================================================
# Prerequisito: MariaDB y/o PostgreSQL deben estar instalados.
# Prerequisito: archivo .env configurado (cp .env.example .env).
#
# USO:
#   sudo bash setup.sh [TARGET] [OPCIONES]
#
# TARGET (default: all):
#   all       — configura MariaDB + PostgreSQL
#   mariadb   — solo MariaDB
#   postgres  — solo PostgreSQL
#
# OPCIONES:
#   --full        Para MariaDB: ejecuta provision-mariadb.sh en lugar de
#                 setup.sh basico. Incluye schema historico, schema analitico,
#                 funciones de utilidad, SPs ETL y de reporte, y seed de datos.
#                 Sin --full: solo crea BD, usuario y grants.
#
# VARIABLES DE ENTORNO:
#   SKIP_SEED=1   Con --full: omite el seed de datos historicos (solo schema + SPs).
#                 Util para entornos donde el seed tarda mucho o ya existe.
#                 Pasar via: sudo env SKIP_SEED=1 bash setup.sh mariadb --full
#                 O agregar SKIP_SEED=1 al .env antes de ejecutar.
#
# EJEMPLOS:
#   sudo bash setup.sh                                    # BD + usuario en ambas BDs
#   sudo bash setup.sh mariadb                            # BD + usuario en MariaDB
#   sudo bash setup.sh mariadb --full                     # schema completo + SPs + seed
#   sudo env SKIP_SEED=1 bash setup.sh mariadb --full     # schema + SPs, sin seed
#   sudo bash setup.sh postgres                           # solo PostgreSQL
#
# CHANGELOG:
#   2026-05-10:
#     · H-EXEC-009: corregido SKIP_SEED — ${SKIP_SEED:+--skip-seed} con SKIP_SEED=0
#       activaba --skip-seed porque "0" es no vacío para ${var:+word}. Reemplazado
#       por comparación explícita [[ "${SKIP_SEED}" == "1" ]] y default vacío.
#       El seed se omitía siempre en setup.sh mariadb --full. Ref: FASE 3.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/validation.sh"
source "${PROJECT_ROOT}/utils/database.sh"

ENV_FILE="${PROJECT_ROOT}/.env"
if [[ ! -f "$ENV_FILE" ]]; then
    log_error "Archivo .env no encontrado — crea: cp .env.example .env"
    exit 1
fi

set -a; source "$ENV_FILE"; set +a

export DB_CHARSET="${DB_CHARSET:-utf8mb4}"
export DB_COLLATION="${DB_COLLATION:-utf8mb4_unicode_ci}"
export MARIADB_HOST="${MARIADB_HOST:-127.0.0.1}"
export MARIADB_PORT="${MARIADB_PORT:-3306}"
export POSTGRES_HOST="${POSTGRES_HOST:-127.0.0.1}"
export POSTGRES_PORT="${POSTGRES_PORT:-5432}"

# SKIP_SEED: vacío (default) = ejecutar seed; "1" = omitir seed.
# Default vacío — la comparación es [[ "${SKIP_SEED}" == "1" ]] (explícita).
# ${var:+word} fue eliminado: "0" es no vacío y activaba el flag incorrectamente.
export SKIP_SEED="${SKIP_SEED:-}"

if ! validate_root; then
    log_fatal "Ejecuta con: sudo bash setup.sh [all|mariadb|postgres] [--full]"
fi

TARGET="${1:-all}"
# H-MDB-011: flag --full ejecuta provision-mariadb.sh (schema + SPs + seed)
# Sin --full: solo BD + usuario + grants (setup rapido)
FULL_PROVISION=0
for arg in "$@"; do
    [[ "$arg" == "--full" ]] && FULL_PROVISION=1
done

case "$TARGET" in
    all|mariadb|postgres) ;;
    --full) TARGET="all" ;;
    *)
        log_error "Target no reconocido: '${TARGET}'"
        log_error "Uso: sudo bash setup.sh [all|mariadb|postgres] [--full]"
        exit 1
        ;;
esac

ensure_dir "${PROJECT_ROOT}/logs"

log_header "IACT-db Setup — target: ${TARGET}"

# =============================================================================
# Arrancar solo las BDs necesarias segun el target
# =============================================================================
log_info "Arrancando base(s) de datos: ${TARGET}"

bash "${PROJECT_ROOT}/start.sh" "$TARGET" || {
    log_error "No se pudo arrancar: ${TARGET}"
    log_error "  Verifica la instalacion: bash verify.sh"
    exit 1
}

# =============================================================================
# Configurar segun target
# =============================================================================
ERRORS=0

run_setup() {
    local name=$1
    local script=$2

    log_info "Configurando ${name}..."
    if bash "$script"; then
        log_success "${name} configurado correctamente"
    else
        log_error "${name} fallo durante el setup"
        ERRORS=$(( ERRORS + 1 ))
    fi
}

# H-MDB-011: para MariaDB, distinguir setup rapido vs provisionamiento completo.
# --full ejecuta provision-mariadb.sh: BD + usuario + schema + SPs + seed.
# Sin --full: solo provisioners/mariadb/setup.sh (BD + usuario + grants).
run_mariadb_setup() {
    if [[ "$FULL_PROVISION" -eq 1 ]]; then
        log_info "MariaDB: provisionamiento completo (--full)"
        log_info "  Incluye: schema historico, schema analitico, SPs, seed"
        local seed_flag=""
        [[ "${SKIP_SEED}" == "1" ]] && seed_flag="--skip-seed"
        if bash "${PROJECT_ROOT}/scripts/provision-mariadb.sh" ${seed_flag}; then
            log_success "MariaDB provisionada completamente"
        else
            log_error "provision-mariadb.sh fallo"
            ERRORS=$(( ERRORS + 1 ))
        fi
    else
        log_info "MariaDB: setup basico (BD + usuario + grants)"
        log_info "  Para schema completo: sudo bash setup.sh mariadb --full"
        run_setup "MariaDB" "${PROJECT_ROOT}/provisioners/mariadb/setup.sh"
    fi
}

case "$TARGET" in
    all)
        run_mariadb_setup
        echo ""
        run_setup "PostgreSQL" "${PROJECT_ROOT}/provisioners/postgres/setup.sh"
        ;;
    mariadb)
        run_mariadb_setup
        ;;
    postgres)
        run_setup "PostgreSQL" "${PROJECT_ROOT}/provisioners/postgres/setup.sh"
        ;;
esac

# =============================================================================
# Resultado
# =============================================================================
echo ""
if [[ $ERRORS -eq 0 ]]; then
    log_success "Setup completado sin errores"
else
    log_error "Setup completado con ${ERRORS} error(es) — revisar salida anterior"
    exit 1
fi

bash "${PROJECT_ROOT}/verify.sh"

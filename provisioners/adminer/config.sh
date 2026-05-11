#!/bin/bash
# =============================================================================
# provisioners/adminer/config.sh — Configuración del servicio Apache/Adminer
# =============================================================================
# Responsabilidad única: configurar el servicio Apache del SO para Adminer.
# No instala paquetes. No gestiona certificados TLS (eso es ssl.sh).
#
# Separación de capas:
#   install.sh  → instalar Apache, PHP, Adminer (paquetes y binarios)
#   config.sh   → configurar el servicio Apache (este archivo)
#   ssl.sh      → configurar TLS: generar CA, cert, vhost SSL
#
# T-3.4 (H-ADM-001, H-ADM-004):
#   configure_apache() vivía en install.sh — capa CONFIG mezclada con INSTALL.
#   Se extrae aquí para consistencia con el patrón de MariaDB y PostgreSQL.
#
# Plantilla de vhost:
#   config/vhost.conf contiene el placeholder %%ADMINER_IP%% (T-3.1).
#   Esta función lo reemplaza con ${ADMINER_IP} del .env usando sed.
#   Por qué sed y no envsubst: envsubst no está disponible en el entorno
#   base (requiere gettext-base). sed es siempre disponible (H-F3-002).
#   Por qué %%ADMINER_IP%% y no ${ADMINER_IP} directamente en el template:
#   config/vhost.conf usa ${APACHE_LOG_DIR} (variable de Apache, no bash).
#   Si se usara ${ADMINER_IP} con envsubst sin scoping, se reemplazarían
#   también las variables de Apache. El placeholder %%VAR%% es inequívoco.
#
# Idempotente: seguro ejecutar N veces sin efectos adversos.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/validation.sh"

ENV_FILE="${PROJECT_ROOT}/.env"
[[ -f "$ENV_FILE" ]] && { set -a; source "$ENV_FILE"; set +a; }

# ---------------------------------------------------------------------------
# _configure_apache_vhost
#
# Genera /etc/apache2/sites-available/adminer.conf reemplazando el
# placeholder %%ADMINER_IP%% con el valor de ADMINER_IP.
# Activa el vhost, desactiva el default, verifica la config y recarga Apache.
#
# Por qué sed y no cp:
#   cp copiaría el placeholder sin resolver, produciendo un ServerAlias
#   con el texto literal %%ADMINER_IP%% — Apache respondería solo a requests
#   con ese Host header (nunca ocurre). La IP real del servidor no sería
#   un alias válido.
# ---------------------------------------------------------------------------
_configure_apache_vhost() {
    local vhost_template="${PROJECT_ROOT}/config/vhost.conf"
    local vhost_config="/etc/apache2/sites-available/adminer.conf"

    if [[ ! -f "$vhost_template" ]]; then
        log_error "  Template no encontrado: ${vhost_template}"
        return 1
    fi

    log_info "  Generando VirtualHost: ${vhost_config}"

    # Reemplazar %%ADMINER_IP%% con el valor real del .env
    if ! sed "s|%%ADMINER_IP%%|${ADMINER_IP}|g" \
            "$vhost_template" > "$vhost_config"; then
        log_error "  No se pudo generar ${vhost_config}"
        return 1
    fi

    # Verificar que el placeholder fue reemplazado
    if grep -q "%%ADMINER_IP%%" "$vhost_config" 2>/dev/null; then
        log_error "  El placeholder %%ADMINER_IP%% no fue reemplazado en ${vhost_config}"
        return 1
    fi

    log_info "  ServerAlias configurado: ${ADMINER_IP}"

    # Verificar config de Apache antes de activar
    if ! apachectl configtest 2>/dev/null; then
        log_error "  apachectl configtest falló antes de activar el sitio"
        apachectl configtest 2>&1 | while IFS= read -r line; do
            log_error "    ${line}"
        done
        return 1
    fi

    # Desactivar sitio default, activar Adminer
    a2dissite 000-default.conf >/dev/null 2>&1 || true
    if ! a2ensite adminer.conf >/dev/null 2>&1; then
        log_error "  a2ensite adminer.conf falló"
        return 1
    fi

    # Verificar config de Apache después de activar
    if ! apachectl configtest >/dev/null 2>&1; then
        log_error "  apachectl configtest falló después de activar el sitio"
        return 1
    fi

    log_success "  VirtualHost HTTP configurado (${ADMINER_IP})"
    return 0
}

# ---------------------------------------------------------------------------
# _reload_apache
#
# Recarga Apache para aplicar la configuración del vhost.
# Intenta reload (sin bajar conexiones) antes de restart.
# ---------------------------------------------------------------------------
_reload_apache() {
    if systemctl reload apache2 2>/dev/null; then
        log_info "  Apache recargado"
    elif systemctl restart apache2 2>/dev/null; then
        log_warn "  Apache reiniciado (reload no disponible)"
    else
        log_warn "  No se pudo recargar Apache — reiniciar manualmente"
        log_warn "  sudo systemctl restart apache2"
        return 0
    fi

    # Verificar que HTTP responde
    sleep 2
    if wait_for_url "http://localhost" 30 200 2>/dev/null; then
        log_success "  HTTP responde en localhost"
    else
        log_warn "  HTTP no respondió en 30s — verificar Apache"
    fi

    return 0
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------
main() {
    log_header "Adminer — Configuración del servicio"

    if ! validate_root; then
        log_fatal "Este script debe ejecutarse como root (sudo)"
    fi

    # T-3.4 (H-ADM-005): ADMINER_IP requerida aquí — no en install.sh.
    # install.sh solo necesita ADMINER_VERSION para descargar el binario.
    require_vars ADMINER_IP

    # Verificar que Apache está instalado
    if ! command -v apache2 &>/dev/null && \
       ! dpkg -l apache2 2>/dev/null | grep -q "^ii"; then
        log_fatal "Apache no está instalado. Ejecutar primero: bash install.sh"
    fi

    log_step 1 2 "VirtualHost HTTP — ${ADMINER_IP}"
    if ! _configure_apache_vhost; then
        log_fatal "No se pudo configurar el VirtualHost"
    fi

    log_step 2 2 "Recarga de Apache"
    _reload_apache

    log_success "Configuración del servicio Apache completada"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

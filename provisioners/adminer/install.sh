#!/bin/bash
# install.sh
# Adminer installation script
# Version: 1.0.2 - FIXED: PHP 7.4 for Ubuntu 20.04 (PHP 8.1 not available)

set -euo pipefail

# Load utilities

# Detectar PROJECT_ROOT (sin dependencia de /vagrant)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/validation.sh"

# Main function
main() {
    log_header "Adminer Installation"

    # Validate running as root
    if ! validate_root; then
        log_fatal "This script must be run as root"
    fi

    # Validate required variables
    # T-3.6 (H-ADM-005): ADMINER_IP eliminada de require_vars.
    # install.sh solo necesita ADMINER_VERSION para descargar el binario.
    # ADMINER_IP la requiere config.sh — que corre en el paso adminer_config.
    require_vars ADMINER_VERSION

    # Ensure log directory
    if ! ensure_dir "${PROJECT_ROOT}/logs"; then
        log_error "Failed to create log directory"
        return 1
    fi

    # Install Apache
    if ! install_apache; then
        log_error "Failed to install Apache"
        return 1
    fi

    # Add PHP repository
    if ! add_php_repository; then
        log_error "Failed to add PHP repository"
        return 1
    fi

    # Install PHP
    if ! install_php; then
        log_error "Failed to install PHP"
        return 1
    fi

    # Download and install Adminer
    if ! install_adminer; then
        log_error "Failed to install Adminer"
        return 1
    fi

    # Nota: la configuración del VirtualHost HTTP se realiza en config.sh
    # (paso adminer_config). La configuración SSL se realiza en ssl.sh
    # (paso adminer_ssl).

    log_success "Adminer installation completed"
    return 0
}

# Install Apache web server
install_apache() {
    log_info "Installing Apache web server"

    # Install Apache
    if ! install_package apache2; then
        log_error "Failed to install apache2"
        return 1
    fi

    # Enable required modules
    log_info "Enabling Apache modules"

    local modules=("rewrite" "ssl" "headers")

    for module in "${modules[@]}"; do
        if ! a2enmod "$module" >/dev/null 2>&1; then
            log_warn "Failed to enable module: $module"
        else
            log_success "Module enabled: $module"
        fi
    done

    # Start Apache service
    if ! start_service apache2; then
        log_error "Failed to start Apache service"
        return 1
    fi

    log_success "Apache installed and started"
    return 0
}

# Add PHP repository
add_php_repository() {
    log_info "Adding PHP repository"

    # Install prerequisites
    if ! install_package software-properties-common; then
        return 1
    fi

    # Add ondrej/php PPA
    log_info "Adding ondrej/php PPA"
    if ! add-apt-repository -y ppa:ondrej/php >/dev/null 2>&1; then
        log_error "Failed to add PHP repository"
        return 1
    fi

    # Update package index
    log_info "Updating package index"
    if ! apt-get update -qq 2>/dev/null; then
        log_error "Failed to update package index"
        return 1
    fi

    log_success "PHP repository added"
    return 0
}

# Install PHP and extensions (PHP 7.4 for Ubuntu 20.04)
install_php() {
    log_info "Installing PHP 7.4 and extensions"

    local php_packages=(
        "php7.4"
        "libapache2-mod-php7.4"
        "php7.4-mysql"
        "php7.4-pgsql"
        "php7.4-mbstring"
        "php7.4-xml"
        "php7.4-curl"
        "php7.4-zip"
    )

    for package in "${php_packages[@]}"; do
        if ! install_package "$package"; then
            log_error "Failed to install $package"
            return 1
        fi
    done

    # Verify PHP module is loaded in Apache
    log_info "Verifying PHP module in Apache"

    # Check if PHP module is enabled
    if apache2ctl -M 2>/dev/null | grep -q "php"; then
        log_success "PHP module loaded in Apache"
    else
        log_warn "PHP module may not be loaded, attempting to enable"
        a2enmod php7.4 >/dev/null 2>&1 || true
    fi

    # Restart Apache to load PHP
    if ! restart_service apache2; then
        log_error "Failed to restart Apache"
        return 1
    fi

    log_success "PHP installed and configured"
    return 0
}

# Download and install Adminer
install_adminer() {
    log_info "Downloading and installing Adminer ${ADMINER_VERSION}"

    # Ensure Adminer directory exists
    if ! ensure_dir /usr/share/adminer; then
        log_error "Failed to create Adminer directory"
        return 1
    fi

    # Download Adminer with retry
    local adminer_url="https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}.php"
    local adminer_temp="/tmp/adminer.php"
    local adminer_dest="/usr/share/adminer/index.php"

    log_info "Downloading Adminer from: $adminer_url"

    if ! download_with_retry "$adminer_url" "$adminer_temp" 3; then
        log_error "Failed to download Adminer"
        return 1
    fi

    # Move to final location
    if ! mv "$adminer_temp" "$adminer_dest"; then
        log_error "Failed to move Adminer to destination"
        return 1
    fi

    # Set permissions
    log_info "Setting permissions on Adminer files"
    chown -R www-data:www-data /usr/share/adminer
    chmod 755 /usr/share/adminer
    chmod 644 "$adminer_dest"

    # Verify file exists
    if ! validate_file_exists "$adminer_dest"; then
        log_error "Adminer file not found after installation"
        return 1
    fi

    log_success "Adminer downloaded and installed"
    return 0
}

# Nota: main() es llamado por bootstrap.sh, no se auto-ejecuta.
# La configuración del VirtualHost HTTP se realiza en config.sh (capa CONFIG).
# La configuración SSL/TLS se realiza en ssl.sh (capa CONFIG-TLS).
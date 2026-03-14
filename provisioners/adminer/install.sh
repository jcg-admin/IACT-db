#!/bin/bash
# install.sh
# Adminer installation script
# Version: 1.0.2 - FIXED: PHP 7.4 for Ubuntu 20.04 (PHP 8.1 not available)

set -euo pipefail

# Load utilities
source /vagrant/utils/core.sh
source /vagrant/utils/logging.sh
source /vagrant/utils/network.sh
source /vagrant/utils/validation.sh

# Main function
main() {
    log_header "Adminer Installation"

    # Validate running as root
    if ! validate_root; then
        log_fatal "This script must be run as root"
    fi

    # Validate required variables
    require_vars ADMINER_VERSION ADMINER_IP

    # Ensure log directory
    if ! ensure_dir /vagrant/logs; then
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

    # Configure Apache for Adminer
    if ! configure_apache; then
        log_error "Failed to configure Apache"
        return 1
    fi

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

# Configure Apache for Adminer
configure_apache() {
    log_info "Configuring Apache for Adminer"

    local vhost_config="/etc/apache2/sites-available/adminer.conf"
    local vhost_template="/vagrant/config/vhost.conf"

    # Check if configuration template exists
    if [[ ! -f "$vhost_template" ]]; then
        log_error "VirtualHost template not found: $vhost_template"
        return 1
    fi

    # Copy template to sites-available
    log_info "Creating VirtualHost configuration"
    if ! cp "$vhost_template" "$vhost_config"; then
        log_error "Failed to copy VirtualHost configuration"
        return 1
    fi

    # Test configuration before applying
    log_info "Testing Apache configuration"
    if ! apachectl configtest 2>&1 | tee /tmp/apache_test.log; then
        log_error "Apache configuration test failed"
        log_error "Configuration errors:"
        cat /tmp/apache_test.log
        return 1
    fi

    # Disable default site
    log_info "Disabling default Apache site"
    a2dissite 000-default.conf >/dev/null 2>&1 || true

    # Enable Adminer site
    log_info "Enabling Adminer site"
    if ! a2ensite adminer.conf >/dev/null 2>&1; then
        log_error "Failed to enable Adminer site"
        return 1
    fi

    # Test again after enabling site
    log_info "Testing Apache configuration after enabling site"
    if ! apachectl configtest >/dev/null 2>&1; then
        log_error "Apache configuration test failed after enabling site"
        apachectl configtest 2>&1
        return 1
    fi

    # Reload Apache
    log_info "Reloading Apache to apply configuration"
    if ! systemctl reload apache2 2>&1; then
        log_warn "Failed to reload Apache, attempting restart"
        if ! systemctl restart apache2 2>&1; then
            log_error "Failed to restart Apache"
            log_error "Apache status:"
            systemctl status apache2 --no-pager || true
            log_error "Apache error log:"
            tail -20 /var/log/apache2/error.log || true
            return 1
        fi
    fi

    # Wait for HTTP to be ready
    log_info "Waiting for HTTP service to be ready"
    sleep 2

    if ! wait_for_url "http://localhost" 30 200; then
        log_warn "HTTP service did not respond within 30 seconds"
        log_info "Checking if port 80 is listening"
        netstat -tlnp | grep ":80" || true
    else
        log_success "HTTP service is ready"
    fi

    log_success "Apache configured for Adminer"
    return 0
}

# Note: main() is called by bootstrap.sh, not auto-executed
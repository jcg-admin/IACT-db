#!/bin/bash
# ssl.sh
# SSL/HTTPS configuration script with Certificate Authority
# Version: 2.0.0 - CA-based certificates for IACT DevBox (adminer.devbox)

set -euo pipefail

# Load utilities
source /vagrant/utils/core.sh
source /vagrant/utils/logging.sh
source /vagrant/utils/network.sh
source /vagrant/utils/validation.sh

# Certificate paths
readonly CONFIG_CERTS_DIR="/vagrant/config/certs"
readonly CA_DIR="${CONFIG_CERTS_DIR}/ca"
readonly CA_CERT="${CA_DIR}/ca.crt"
readonly CA_KEY="${CA_DIR}/ca.key"
readonly ADMINER_CERT="${CONFIG_CERTS_DIR}/adminer.crt"
readonly ADMINER_KEY="${CONFIG_CERTS_DIR}/adminer.key"
readonly APACHE_CERT="/etc/ssl/certs/adminer-selfsigned.crt"
readonly APACHE_KEY="/etc/ssl/private/adminer-selfsigned.key"

# Main function
main() {
    log_header "SSL/HTTPS Configuration (CA-based)"

    # Validate running as root
    if ! validate_root; then
        log_fatal "This script must be run as root"
    fi

    # Validate required variables
    require_vars ADMINER_IP SSL_DAYS SSL_COUNTRY SSL_STATE SSL_CITY SSL_ORG SSL_OU SSL_CN

    # Ensure log directory
    if ! ensure_dir /vagrant/logs; then
        log_error "Failed to create log directory"
        return 1
    fi

    # Step 1: Generate or verify Certificate Authority
    if ! ensure_certificate_authority; then
        log_error "Failed to ensure Certificate Authority"
        return 1
    fi

    # Step 2: Generate Adminer certificate signed by CA
    if ! generate_adminer_certificate; then
        log_error "Failed to generate Adminer certificate"
        return 1
    fi

    # Step 3: Copy certificates to Apache locations
    if ! install_certificates_to_apache; then
        log_error "Failed to install certificates to Apache"
        return 1
    fi

    # Step 4: Configure Apache SSL VirtualHost
    if ! configure_ssl_vhost; then
        log_error "Failed to configure SSL VirtualHost"
        return 1
    fi

    # Step 5: Enable SSL site
    if ! enable_ssl_site; then
        log_error "Failed to enable SSL site"
        return 1
    fi

    # Step 6: Show instructions for Windows
    show_windows_instructions

    log_success "SSL/HTTPS configuration completed"
    return 0
}

# Ensure Certificate Authority exists (create if needed)
ensure_certificate_authority() {
    log_info "Ensuring Certificate Authority exists"

    # Create CA directory if it doesn't exist
    if ! ensure_dir "$CA_DIR"; then
        log_error "Failed to create CA directory"
        return 1
    fi

    # Check if CA already exists
    if [[ -f "$CA_CERT" ]] && [[ -f "$CA_KEY" ]]; then
        log_info "Certificate Authority already exists"
        log_info "CA Certificate: $CA_CERT"

        # Verify CA certificate is valid
        if openssl x509 -in "$CA_CERT" -noout -text >/dev/null 2>&1; then
            log_success "CA certificate is valid"
            return 0
        else
            log_warn "Existing CA certificate is invalid, regenerating"
        fi
    fi

    # Generate new CA
    log_info "Generating new Certificate Authority"

    # Generate CA private key (4096-bit for security)
    log_info "Generating CA private key (4096-bit RSA)"
    if ! openssl genrsa -out "$CA_KEY" 4096 >/dev/null 2>&1; then
        log_error "Failed to generate CA private key"
        return 1
    fi

    # Generate CA certificate (valid for 10 years)
    log_info "Generating CA certificate (valid for 10 years)"
    if ! openssl req -x509 -new -nodes \
        -key "$CA_KEY" \
        -sha256 -days 3650 \
        -out "$CA_CERT" \
        -subj "/C=${SSL_COUNTRY}/ST=${SSL_STATE}/L=${SSL_CITY}/O=${SSL_ORG}/OU=${SSL_OU}/CN=IACT DevBox Root CA" \
        >/dev/null 2>&1; then
        log_error "Failed to generate CA certificate"
        return 1
    fi

    # Set permissions
    chmod 644 "$CA_CERT"
    chmod 600 "$CA_KEY"

    # Verify files were created
    if ! validate_file_exists "$CA_CERT"; then
        log_error "CA certificate not found after generation"
        return 1
    fi

    if ! validate_file_exists "$CA_KEY"; then
        log_error "CA key not found after generation"
        return 1
    fi

    log_success "Certificate Authority generated successfully"
    log_info "CA Certificate: $CA_CERT"
    log_info "CA Key: $CA_KEY (keep private!)"

    return 0
}

# Generate Adminer certificate signed by CA
generate_adminer_certificate() {
    log_info "Generating Adminer certificate signed by CA"

    # Check if certificate already exists and is valid
    if [[ -f "$ADMINER_CERT" ]] && [[ -f "$ADMINER_KEY" ]]; then
        log_info "Adminer certificate already exists"

        # Verify it's still valid and was signed by our CA
        if openssl verify -CAfile "$CA_CERT" "$ADMINER_CERT" >/dev/null 2>&1; then
            log_success "Existing Adminer certificate is valid"
            return 0
        else
            log_warn "Existing certificate is invalid or not signed by CA, regenerating"
        fi
    fi

    log_info "Creating new Adminer certificate"

    # Generate private key for Adminer
    log_info "Generating Adminer private key (2048-bit RSA)"
    if ! openssl genrsa -out "$ADMINER_KEY" 2048 >/dev/null 2>&1; then
        log_error "Failed to generate Adminer private key"
        return 1
    fi

    # Create Certificate Signing Request (CSR)
    local csr_file="/tmp/adminer.csr"
    log_info "Creating Certificate Signing Request"

    # Create CSR with Subject Alternative Names (SAN) for better compatibility
    local san_config="/tmp/adminer_san.cnf"
    cat > "$san_config" <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = ${SSL_COUNTRY}
ST = ${SSL_STATE}
L = ${SSL_CITY}
O = ${SSL_ORG}
OU = ${SSL_OU}
CN = ${ADMINER_IP}

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
IP.1 = ${ADMINER_IP}
DNS.1 = adminer.devbox
DNS.2 = localhost
EOF

    if ! openssl req -new \
        -key "$ADMINER_KEY" \
        -out "$csr_file" \
        -config "$san_config" \
        >/dev/null 2>&1; then
        log_error "Failed to create CSR"
        rm -f "$san_config"
        return 1
    fi

    # Sign CSR with CA to create certificate
    log_info "Signing certificate with CA (valid for ${SSL_DAYS} days)"

    # Create extensions file for signing
    local ext_file="/tmp/adminer_ext.cnf"
    cat > "$ext_file" <<EOF
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
IP.1 = ${ADMINER_IP}
DNS.1 = adminer.devbox
DNS.2 = localhost
EOF

    if ! openssl x509 -req \
        -in "$csr_file" \
        -CA "$CA_CERT" \
        -CAkey "$CA_KEY" \
        -CAcreateserial \
        -out "$ADMINER_CERT" \
        -days "${SSL_DAYS}" \
        -sha256 \
        -extfile "$ext_file" \
        >/dev/null 2>&1; then
        log_error "Failed to sign certificate with CA"
        rm -f "$san_config" "$ext_file" "$csr_file"
        return 1
    fi

    # Clean up temporary files
    rm -f "$san_config" "$ext_file" "$csr_file"

    # Set permissions
    chmod 644 "$ADMINER_CERT"
    chmod 600 "$ADMINER_KEY"

    # Verify certificate
    if ! validate_file_exists "$ADMINER_CERT"; then
        log_error "Adminer certificate not found after generation"
        return 1
    fi

    # Verify certificate is signed by CA
    if ! openssl verify -CAfile "$CA_CERT" "$ADMINER_CERT" >/dev/null 2>&1; then
        log_error "Certificate verification failed"
        return 1
    fi

    log_success "Adminer certificate generated and signed by CA"
    log_info "Certificate: $ADMINER_CERT"
    log_info "Key: $ADMINER_KEY"

    # Show certificate details
    log_info "Certificate details:"
    openssl x509 -in "$ADMINER_CERT" -noout -subject -issuer -dates 2>/dev/null | while read -r line; do
        log_info "  $line"
    done

    return 0
}

# Copy certificates to Apache locations
install_certificates_to_apache() {
    log_info "Installing certificates to Apache locations"

    # Ensure Apache SSL directories exist
    if ! ensure_dir /etc/ssl/certs; then
        log_error "Failed to create /etc/ssl/certs"
        return 1
    fi

    if ! ensure_dir /etc/ssl/private; then
        log_error "Failed to create /etc/ssl/private"
        return 1
    fi

    # Copy certificate
    log_info "Copying certificate to Apache"
    if ! cp "$ADMINER_CERT" "$APACHE_CERT"; then
        log_error "Failed to copy certificate"
        return 1
    fi

    # Copy private key
    log_info "Copying private key to Apache"
    if ! cp "$ADMINER_KEY" "$APACHE_KEY"; then
        log_error "Failed to copy private key"
        return 1
    fi

    # Set Apache-appropriate permissions
    chmod 644 "$APACHE_CERT"
    chmod 600 "$APACHE_KEY"
    chown root:root "$APACHE_CERT" "$APACHE_KEY"

    log_success "Certificates installed to Apache locations"
    log_info "Apache certificate: $APACHE_CERT"
    log_info "Apache key: $APACHE_KEY"

    return 0
}

# Configure Apache SSL VirtualHost
configure_ssl_vhost() {
    log_info "Configuring Apache SSL VirtualHost"

    local ssl_vhost_config="/etc/apache2/sites-available/adminer-ssl.conf"
    local ssl_template="/vagrant/config/vhost_ssl.conf"

    # Check if configuration template exists
    if [[ ! -f "$ssl_template" ]]; then
        log_error "SSL VirtualHost template not found: $ssl_template"
        return 1
    fi

    # Copy template to sites-available
    log_info "Creating SSL VirtualHost configuration"
    if ! cp "$ssl_template" "$ssl_vhost_config"; then
        log_error "Failed to copy SSL VirtualHost configuration"
        return 1
    fi

    # Verify the copied file exists and is readable
    if ! validate_file_exists "$ssl_vhost_config"; then
        log_error "SSL VirtualHost config not found after copy"
        return 1
    fi

    # Test configuration syntax BEFORE enabling
    log_info "Testing Apache configuration syntax"
    if ! apachectl configtest 2>&1 | tee /tmp/apache_ssl_test.log; then
        log_error "Apache configuration syntax test failed"
        log_error "Configuration errors:"
        cat /tmp/apache_ssl_test.log
        return 1
    fi

    log_success "SSL VirtualHost configured and syntax validated"
    return 0
}

# Enable SSL site and restart Apache
enable_ssl_site() {
    log_info "Enabling SSL site"

    # Ensure SSL module is enabled
    log_info "Ensuring SSL module is enabled"
    if ! a2enmod ssl >/dev/null 2>&1; then
        log_warn "Failed to enable SSL module (may already be enabled)"
    else
        log_success "SSL module enabled"
    fi

    # Enable SSL site
    log_info "Enabling adminer-ssl.conf site"
    if ! a2ensite adminer-ssl.conf >/dev/null 2>&1; then
        log_error "Failed to enable SSL site"
        return 1
    fi

    # Test configuration again after enabling
    log_info "Testing Apache configuration after enabling SSL site"
    if ! apachectl configtest 2>&1 | tee /tmp/apache_ssl_final_test.log; then
        log_error "Apache configuration test failed after enabling SSL site"
        log_error "Configuration errors:"
        cat /tmp/apache_ssl_final_test.log
        log_error "Disabling SSL site to prevent Apache from failing"
        a2dissite adminer-ssl.conf >/dev/null 2>&1 || true
        return 1
    fi

    # Reload Apache to apply changes
    log_info "Reloading Apache to apply SSL configuration"
    if ! systemctl reload apache2 2>&1; then
        log_warn "Failed to reload Apache, attempting restart"

        if ! systemctl restart apache2 2>&1; then
            log_error "Failed to restart Apache"
            log_error "Apache status:"
            systemctl status apache2 --no-pager || true
            log_error "Apache error log (last 30 lines):"
            tail -30 /var/log/apache2/error.log 2>/dev/null || true
            return 1
        fi
    fi

    # Wait for Apache to fully restart
    sleep 3

    # Verify Apache is running
    if ! systemctl is-active --quiet apache2; then
        log_error "Apache is not running after restart"
        systemctl status apache2 --no-pager || true
        return 1
    fi

    log_success "Apache is running"

    # Wait for HTTPS to be ready
    log_info "Waiting for HTTPS service to be ready"
    if ! wait_for_port "localhost" 443 30; then
        log_warn "HTTPS port did not open within 30 seconds"
        netstat -tlnp | grep -E ":(80|443)" || true
    else
        log_success "HTTPS service is ready on port 443"
    fi

    # Test HTTPS access
    log_info "Testing HTTPS access"
    local http_code
    http_code=$(curl -k -s -o /dev/null -w "%{http_code}" https://localhost 2>/dev/null || echo "000")

    if [[ "$http_code" == "200" ]]; then
        log_success "HTTPS is accessible (HTTP 200)"
    elif [[ "$http_code" != "000" ]]; then
        log_warn "HTTPS responded with HTTP $http_code"
    else
        log_warn "HTTPS may not be fully accessible yet"
    fi

    log_success "SSL site enabled"
    return 0
}

# Show instructions for installing CA on Windows
show_windows_instructions() {
    log_info ""
    log_info "========================================="
    log_info "  SSL CERTIFICATE SETUP COMPLETE"
    log_info "  IACT DevBox"
    log_info "========================================="
    log_info ""
    log_info "Next step: Install Certificate Authority on Windows"
    log_info ""
    log_info "Run this command on your Windows host:"
    log_info "  .\\scripts\\install-ca-certificate.ps1"
    log_info ""
    log_info "This will:"
    log_info "  1. Install the CA certificate to Windows Trusted Root"
    log_info "  2. Remove browser SSL warnings for:"
    log_info "     - https://adminer.devbox"
    log_info "     - https://192.168.56.12"
    log_info ""
    log_info "CA Certificate location:"
    log_info "  ${CA_CERT}"
    log_info ""
    log_info "After installation, restart your browser and visit:"
    log_info "  https://adminer.devbox"
    log_info "  https://www.adminer.devbox"
    log_info ""
    log_info "========================================="
    log_info ""
}

# Note: main() is called by bootstrap.sh, not auto-executed